-- Creation of database

CREATE DATABASE mountaineering_club_1;

--Create the schema

CREATE SCHEMA mountain_club;

-- After creating the tables the values was inserted in each tables.
-- In all tables the id column is SERIAL becuase there will not be many rows in them ( for tables with big amount of row I would use BIGSERIAL type)
-- Check if the tables already exists if not then create one
-- Ckeck if added values are already in table if not then insert
-- Relationships between tables was done using primary and foreign keys ( in creating tables step) 

CREATE TABLE IF NOT EXISTS mountain_club.contact_details
(
	contact_details_id SERIAL PRIMARY KEY,
	phone_number TEXT NOT NULL,
	email_adress TEXT NOT NULL
);

--2
CREATE TABLE IF NOT EXISTS mountain_club.country
(
	country_id SERIAL PRIMARY KEY,
	country_name TEXT NOT NULL
);

--3
CREATE TABLE IF NOT EXISTS mountain_club.city
(
	city_id SERIAL PRIMARY KEY,
	country_id INT NOT NULL REFERENCES country(country_id),
	city_name TEXT NOT NULL
);

--4
CREATE TABLE IF NOT EXISTS mountain_club.address_details
(
	address_details_id SERIAL PRIMARY KEY,
	street TEXT NOT NULL,
	city_id INT NOT NULL REFERENCES city(city_id),
	home_number INT, -- NOT EVERY address has home no
	postal_code TEXT NOT NULL
);

--5
CREATE TABLE IF NOT EXISTS mountain_club.emergency_contact
(
	emergency_contact_id SERIAL PRIMARY KEY,
	contact_name TEXT NOT NULL,
	contact_surname TEXT NOT NULL,
	contact_details_id INT NOT NULL REFERENCES contact_details(contact_details_id),
	address_details_id INT NOT NULL REFERENCES address_details(address_details_id)
);

--6
CREATE TABLE IF NOT EXISTS mountain_club.participant_advancement_level
(
	participant_advancement_level_id SERIAL PRIMARY KEY,
	LEVEL TEXT NOT null
);

--7
CREATE TABLE IF NOT EXISTS mountain_club.participant
(
	participant_id SERIAL PRIMARY KEY,
	emergency_contact_id INT NOT NULL REFERENCES emergency_contact(emergency_contact_id),
	participant_name TEXT NOT NULL,
	participant_surname TEXT NOT NULL,
	participant_full_name TEXT GENERATED ALWAYS AS (participant_name || ' ' || participant_surname) STORED NOT NULL, ---GENERATE ALWAYS AS used
	participant_age INT NOT NULL,
	contact_details_id INT NOT NULL REFERENCES contact_details(contact_details_id),
	address_details_id INT NOT NULL REFERENCES address_details(address_details_id),
	participant_advancement_level_id INT  NOT NULL REFERENCES participant_advancement_level(participant_advancement_level_id),
	participant_last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

--8
CREATE TABLE IF NOT EXISTS mountain_club.guide
(
	guide_id SERIAL PRIMARY KEY,
	guide_name TEXT NOT NULL,
	guide_surname TEXT NOT NULL,
	contact_details_id INT  NOT NULL REFERENCES contact_details(contact_details_id),
	address_details_id INT NOT NULL REFERENCES address_details(address_details_id),
	guide_age INT NOT NULL,
	guide_certificate_id TEXT NOT NULL,
	guide_price DECIMAL(4,2) NOT NULL,
	guide_last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

--9
CREATE TABLE IF NOT EXISTS mountain_club.hotel
(
	hotel_id SERIAL PRIMARY KEY,
	hotel_name TEXT NOT NULL,
	contact_details_id INT  NOT NULL REFERENCES contact_details(contact_details_id),
	address_details_id INT NOT NULL REFERENCES address_details(address_details_id),
	hotel_start_date DATE NOT  NULL,
	hotel_finish_date DATE NOT NULL,
	hotel_price DECIMAL(5,2) NOT NULL,
	hotel_last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

--10
CREATE TABLE IF NOT EXISTS mountain_club.transport_form
(
	transport_form_id SERIAL PRIMARY KEY,
	name TEXT NOT NULL
);

--11
CREATE TABLE IF NOT EXISTS mountain_club.difficulty_level
(
	difficulty_level_id SERIAL PRIMARY KEY,
	name TEXT NOT NULL
);

INSERT INTO mountain_club.contact_details (phone_number, email_adress)
SELECT  newcontact.phone_number,
		newcontact.email_adress
FROM (VALUES
('123-456-7890', 'john@example.com'),
('987-654-3210', 'jane@example.com')
) AS newcontact (phone_number, email_adress)
WHERE NOT EXISTS (
SELECT 1
FROM mountain_club.contact_details ct
WHERE ct.phone_number = newcontact.phone_number AND 
ct.email_adress = newcontact.email_adress
);
 

--12
CREATE TABLE IF NOT EXISTS mountain_club.payment_status
(
	payment_status_id SERIAL PRIMARY KEY,
	status TEXT NOT NULL
);

--13
CREATE TABLE IF NOT EXISTS mountain_club.transport
(
	transport_id SERIAL PRIMARY KEY,
	transport_form_id INT NOT NULL REFERENCES transport_form(transport_form_id),
	departure_place TEXT NOT NULL,
	arrival_place TEXT NOT NULL,
	departure_datatime TIMESTAMP NOT NULL,
	arrival_datatime TIMESTAMP  NOT NULL,
	transport_price DECIMAL(5,2) NOT NULL
);

--14
CREATE TABLE IF NOT EXISTS mountain_club.mountain
(
	mountain_id SERIAL PRIMARY KEY,
	name TEXT NOT NULL,
	height INT NOT NULL,
	difficulty_level_id INT NOT NULL REFERENCES difficulty_level(difficulty_level_id)
);

--15
CREATE TABLE IF NOT EXISTS mountain_club.mountain_area
(
	mountain_area_id SERIAL PRIMARY KEY,
	area TEXT NOT NULL,
	country_id INT NOT NULL REFERENCES country(country_id)
);

--16
CREATE TABLE IF NOT EXISTS mountain_club.location_detail
(
	location_detail_id SERIAL PRIMARY KEY,
	mountain_id INT NOT NULL REFERENCES mountain(mountain_id),
	mountain_area_id INT NOT NULL REFERENCES mountain_area(mountain_area_id)
);

-- creating ENUM type to choose from three exsisting option 
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_type
        WHERE typname = 'payment_method_enum'
    ) THEN
        CREATE TYPE payment_method_enum AS ENUM ('card', 'cash', 'transfer');
    END IF;
END $$;

--17
CREATE TABLE IF NOT EXISTS mountain_club.payment
(
	payment_id SERIAL PRIMARY KEY,
	payment_status_id INT NOT NULL REFERENCES hotel(hotel_id),
	payment_method  payment_method_enum,
	payment_datetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL

);

--18
CREATE TABLE IF NOT EXISTS mountain_club.expedition
(
	expedition_id SERIAL PRIMARY KEY,
	participant_id INT NOT NULL REFERENCES participant(participant_id),
	transport_id INT NOT NULL REFERENCES transport(transport_id),
	guide_id INT NOT NULL REFERENCES guide(guide_id),
	payment_id INT NOT NULL REFERENCES payment(payment_id),
	finish_place TEXT NOT NULL,
	meeting_place TEXT NOT NULL,
	expedition_start_datetime TIMESTAMP NOT NULL,
	expedition_end_datetime TIMESTAMP NOT NULL,
	expedition_last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

--19
CREATE TABLE IF NOT EXISTS mountain_club.expedition_detail
(
	expedition_detail_id SERIAL PRIMARY KEY,
	expedition_id INT NOT NULL REFERENCES expedition(expedition_id),
	mountain_id INT NOT NULL REFERENCES mountain(mountain_id),
	hotel_id INT NOT NULL REFERENCES hotel(hotel_id)
);

/*Apply five check constraints across the tables to restrict certain values, including
-date to be inserted, which must be greater than January 1, 2000
-inserted measured value that cannot be negative
-inserted value that can only be a specific value 
-unique
-not null
First check if the constrain already exists if not the add the constrain
I used pgSQL block (DO $$ ... $$;) to execute the conditional ALTER TABLE statement.*/

DO $$
BEGIN
	
	-- Check if the constraint Unique_guide_certificate_id exists
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.constraint_column_usage
        WHERE table_name = 'guide' AND constraint_name = 'unique_guide_certificate_id'
    ) THEN
        -- UNIQUE constraint. Each guide must have a different/unique certificate_id
        ALTER TABLE mountain_club.guide 
        ADD CONSTRAINT Unique_guide_certificate_id UNIQUE (guide_certificate_id);
    END IF;

    -- Check if the constraint Price_value exists
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.constraint_column_usage
        WHERE table_name = 'guide' AND constraint_name = 'price_value'
    ) THEN
        -- Inserted measured value that cannot be negative constraint. Guide price has to be >0 (price cannot be negative)
        ALTER TABLE mountain_club.guide 
        ADD CONSTRAINT Price_value CHECK (guide_price >= 0);
    END IF;

    -- Check if the constraint Level_check exists and if the inserted value that is the specific 
    --value ( Beginner, Intermediate, Advance)
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.constraint_column_usage
        WHERE table_name = 'participant_advancement_level' AND constraint_name = 'level_check'
    ) THEN
        -- Inserted value that can only be a specific value. Participant_advancement_level can be one of three Beginner, Intermediate, Advance.
        ALTER TABLE mountain_club.participant_advancement_level
        ADD CONSTRAINT Level_check CHECK (level IN ('Beginner','Intermediate', 'Advance'));
    END IF;
   
    -- Check if the constraint NOT_NULL_check exists
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.constraint_column_usage
        WHERE table_name = 'hotel' AND constraint_name = 'not_null_check'
    ) THEN
        -- Hotel start date cannot be NULL.
        ALTER TABLE mountain_club.hotel 
        ADD CONSTRAINT NOT_NULL_check CHECK (hotel_start_date IS NOT NULL);
    END IF;
   
    -- Check if the constraint Date_check exists
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.constraint_column_usage
        WHERE table_name = 'hotel' AND constraint_name = 'date_check'
    ) THEN
        -- Date to be inserted, which must be greater than January 1, 2000.
        ALTER TABLE mountain_club.hotel 
        ADD CONSTRAINT Date_check CHECK (hotel_start_date > '2000-01-01');
    END IF;
END $$;
   

--In next part the values will be inserted in the tables.

INSERT INTO mountain_club.country (country_name)
SELECT  newcountry.country_name
FROM (VALUES
('United States'),
('Canada')
) AS newcountry(country_name)
WHERE NOT EXISTS (
SELECT 1
FROM mountain_club.country co
WHERE co.country_name = newcountry.country_name 
);
    
  
INSERT INTO mountain_club.city (country_id, city_name)
SELECT  newcity.country_id,
		newcity.city_name
FROM (VALUES
((SELECT country_id FROM mountain_club.country WHERE country_name = 'United States'), 'New York'),
((SELECT country_id FROM mountain_club.country WHERE country_name = 'Canada'), 'Toronto')
) AS newcity (country_id, city_name)
WHERE NOT EXISTS (
SELECT 1
FROM mountain_club.city ci
WHERE   ci.country_id = newcity.country_id AND
		ci.city_name = newcity.city_name
);


INSERT INTO mountain_club.address_details (street, city_id, home_number, postal_code)
SELECT  newaddress_details.street,
		newaddress_details.city_id,
		newaddress_details.home_number,
		newaddress_details.postal_code
FROM (VALUES
('123 Main St', (SELECT city_id FROM mountain_club.city WHERE city_name = 'New York'), 10, '10001'),
('456 Elm St', (SELECT city_id FROM mountain_club.city WHERE city_name = 'Toronto'), 20, 'M1X 1X1')
) AS newaddress_details (street, city_id, home_number, postal_code)
WHERE NOT EXISTS (
SELECT 1
FROM mountain_club.address_details ad
WHERE   ad.street = newaddress_details.street AND
		ad.city_id = newaddress_details.city_id AND 
		ad.postal_code = newaddress_details.postal_code
);


INSERT INTO mountain_club.emergency_contact (contact_name, contact_surname, contact_details_id, address_details_id)
SELECT  newemergency_contact.contact_name,
		newemergency_contact.contact_surname,
		newemergency_contact.contact_details_id,
		newemergency_contact.address_details_id
FROM (VALUES 
    ('Mary', 'Smith', (SELECT contact_details_id FROM mountain_club.contact_details ORDER BY RANDOM() LIMIT 1), (SELECT address_details_id FROM mountain_club.address_details ORDER BY RANDOM() LIMIT 1)),
    ('Bob', 'Johnson', (SELECT contact_details_id FROM mountain_club.contact_details ORDER BY RANDOM() LIMIT 1), (SELECT address_details_id FROM mountain_club.address_details ORDER BY RANDOM() LIMIT 1))
)AS newemergency_contact (contact_name, contact_surname, contact_details_id, address_details_id)
WHERE NOT EXISTS (
SELECT 1
FROM mountain_club.emergency_contact em_cont
WHERE   em_cont.contact_name = newemergency_contact.contact_name AND
		em_cont.contact_surname = newemergency_contact.contact_surname AND
		em_cont.contact_details_id = newemergency_contact.contact_details_id AND
		em_cont.address_details_id = newemergency_contact.address_details_id
);

INSERT INTO mountain_club.participant_advancement_level (level)
SELECT  newparticipant_advancement_level.level
FROM (VALUES 
    ('Beginner'),
    ('Intermediate')
)AS newparticipant_advancement_level (level)
WHERE NOT EXISTS (
SELECT 1
FROM mountain_club.participant_advancement_level pa_ad_lev
WHERE   pa_ad_lev.level = newparticipant_advancement_level.level
);

INSERT INTO mountain_club.participant (emergency_contact_id, participant_name, participant_surname, participant_age, contact_details_id, address_details_id, participant_advancement_level_id)
SELECT  newparticipant.emergency_contact_id,
		newparticipant.participant_name,
		newparticipant.participant_surname,
		newparticipant. participant_age,
		newparticipant.contact_details_id,
		newparticipant.address_details_id,
		newparticipant.participant_advancement_level_id
FROM (VALUES 
    ((SELECT emergency_contact_id FROM mountain_club.emergency_contact ORDER BY RANDOM() LIMIT 1), 'John', 'Doe', 25, (SELECT contact_details_id FROM mountain_club.contact_details ORDER BY RANDOM() LIMIT 1), (SELECT address_details_id FROM mountain_club.address_details ORDER BY RANDOM() LIMIT 1), (SELECT participant_advancement_level_id FROM mountain_club.participant_advancement_level ORDER BY RANDOM() LIMIT 1)),
    ((SELECT emergency_contact_id FROM mountain_club.emergency_contact ORDER BY RANDOM() LIMIT 1), 'Jane', 'Smith', 30, (SELECT contact_details_id FROM mountain_club.contact_details ORDER BY RANDOM() LIMIT 1), (SELECT address_details_id FROM mountain_club.address_details ORDER BY RANDOM() LIMIT 1), (SELECT participant_advancement_level_id FROM mountain_club.participant_advancement_level ORDER BY RANDOM() LIMIT 1))
)AS newparticipant(emergency_contact_id, participant_name, participant_surname, participant_age, contact_details_id, address_details_id, participant_advancement_level_id)
WHERE NOT EXISTS (
SELECT 1
FROM mountain_club.participant pa
WHERE   pa.emergency_contact_id = newparticipant.emergency_contact_id AND
		pa.participant_name = newparticipant.participant_name AND
		pa.participant_surname = newparticipant.participant_surname AND
		pa.participant_age = newparticipant. participant_age AND
		pa.contact_details_id = newparticipant.contact_details_id AND
		pa.address_details_id = newparticipant.address_details_id AND
		pa.participant_advancement_level_id = newparticipant.participant_advancement_level_id
);

INSERT INTO mountain_club.guide (guide_name, guide_surname, contact_details_id, address_details_id, guide_age, guide_certificate_id, guide_price)
SELECT  newguide.guide_name,
		newguide.guide_surname,
		newguide.contact_details_id,
		newguide.address_details_id,
		newguide.guide_age,
		newguide.guide_certificate_id,
		newguide.guide_price
FROM (VALUES 
    ('Michael', 'Brown', (SELECT contact_details_id FROM mountain_club.contact_details ORDER BY RANDOM() LIMIT 1), (SELECT address_details_id FROM mountain_club.address_details ORDER BY RANDOM() LIMIT 1), 35, 'ABCD1234', 50.00),
    ('Emily', 'Johnson', (SELECT contact_details_id FROM mountain_club.contact_details ORDER BY RANDOM() LIMIT 1), (SELECT address_details_id FROM mountain_club.address_details ORDER BY RANDOM() LIMIT 1), 40, 'EFGH5678', 60.00)
)AS newguide(guide_name, guide_surname, contact_details_id, address_details_id, guide_age, guide_certificate_id, guide_price)
WHERE NOT EXISTS (
SELECT 1
FROM mountain_club.guide gu
WHERE   gu.guide_name = newguide.guide_name AND
		gu.guide_surname = newguide.guide_surname AND
		gu.contact_details_id = newguide.contact_details_id AND
		gu.address_details_id = newguide.address_details_id AND
		gu.guide_age = newguide.guide_age AND
		gu.guide_certificate_id = newguide.guide_certificate_id AND
		gu.guide_price = newguide.guide_price
);


INSERT INTO mountain_club.hotel (hotel_name, contact_details_id, address_details_id, hotel_start_date, hotel_finish_date, hotel_price)
SELECT  newhotel.hotel_name,
		newhotel.contact_details_id,
		newhotel.address_details_id,
		newhotel.hotel_start_date::DATE,
		newhotel.hotel_finish_date::DATE,
		newhotel.hotel_price
FROM (VALUES 
    ('Sheraton', (SELECT contact_details_id FROM mountain_club.contact_details ORDER BY RANDOM() LIMIT 1), (SELECT address_details_id FROM mountain_club.address_details ORDER BY RANDOM() LIMIT 1), '2024-04-01', '2024-04-03', 200.00),
    ('Hilton', (SELECT contact_details_id FROM mountain_club.contact_details ORDER BY RANDOM() LIMIT 1), (SELECT address_details_id FROM mountain_club.address_details ORDER BY RANDOM() LIMIT 1), '2024-04-02',  '2024-04-04' , 250.00)
)AS newhotel(hotel_name, contact_details_id, address_details_id, hotel_start_date, hotel_finish_date, hotel_price)
WHERE NOT EXISTS (
SELECT 1
FROM mountain_club.hotel ho
WHERE   ho.hotel_name = newhotel.hotel_name AND
		ho.contact_details_id = newhotel.contact_details_id AND
		ho.address_details_id = newhotel.address_details_id AND
		ho.hotel_start_date = newhotel.hotel_start_date::DATE AND
		ho.hotel_finish_date = newhotel.hotel_finish_date::DATE AND
		ho.hotel_price = newhotel.hotel_price
);


INSERT INTO mountain_club.transport_form (name)
SELECT newtransport_form.name
FROM (VALUES 
    ('Bus'),
    ('Train')
)AS newtransport_form(name)
WHERE NOT EXISTS (
SELECT 1
FROM mountain_club.transport_form tra_fo
WHERE   tra_fo.name = newtransport_form.name
);
   

INSERT INTO mountain_club.difficulty_level (name)
SELECT newdifficulty_level.name
FROM( VALUES 
    ('Easy'),
    ('Moderate')
)AS newdifficulty_level(name)
WHERE NOT EXISTS (
SELECT 1
FROM mountain_club.difficulty_level dif
WHERE   dif.name = newdifficulty_level.name
);


INSERT INTO mountain_club.payment_status (status)
SELECT newpayment_status.status
FROM (VALUES 
    ('Paid'),
    ('Pending')
 ) AS newpayment_status(status)
WHERE NOT EXISTS (
SELECT 1
FROM mountain_club.payment_status pay_sta
WHERE   pay_sta.status = newpayment_status.status
);


INSERT INTO mountain_club.transport (transport_form_id, departure_place, arrival_place, departure_datatime, arrival_datatime, transport_price)
SELECT  newtransport.transport_form_id,
		newtransport.departure_place,
		newtransport.arrival_place,
		newtransport.departure_datatime,
		newtransport.arrival_datatime,
		newtransport.transport_price
FROM(VALUES 
    ((SELECT transport_form_id FROM mountain_club.transport_form ORDER BY RANDOM() LIMIT 1), 'New York', 'Toronto', TIMESTAMP '2024-04-01 08:00:00+01',TIMESTAMP '2024-04-01 16:00:00+01', 100.00),
    ((SELECT transport_form_id FROM mountain_club.transport_form ORDER BY RANDOM() LIMIT 1), 'Toronto', 'New York', TIMESTAMP '2024-04-04 08:00:00+01',TIMESTAMP '2024-04-04 16:00:00+01', 120.00)
)AS newtransport(transport_form_id, departure_place, arrival_place, departure_datatime, arrival_datatime, transport_price)
WHERE NOT EXISTS (
SELECT 1
FROM mountain_club.transport tra
WHERE   tra.transport_form_id = newtransport.transport_form_id AND
		tra.departure_place = newtransport.departure_place AND
		tra.arrival_place = newtransport.arrival_place AND
		tra.departure_datatime = newtransport.departure_datatime AND
		tra.arrival_datatime = newtransport.arrival_datatime AND
		tra.transport_price = newtransport.transport_price
);


INSERT INTO mountain_club.mountain (name, height, difficulty_level_id)
SELECT  newmountain.name,
		newmountain.height,
		newmountain.difficulty_level_id
FROM(VALUES 
    ('Mount Everest', 8848, (SELECT difficulty_level_id FROM difficulty_level ORDER BY RANDOM() LIMIT 1)),
    ('Mount Kilimanjaro', 5895, (SELECT difficulty_level_id FROM difficulty_level ORDER BY RANDOM() LIMIT 1))
)AS newmountain(name, height, difficulty_level_id)
WHERE NOT EXISTS (
SELECT 1
FROM mountain_club.mountain mo
WHERE   mo.name =  newmountain.name AND
		mo.height = newmountain.height AND
		mo.difficulty_level_id = newmountain.difficulty_level_id
);


INSERT INTO mountain_club.mountain_area (area, country_id)
SELECT  newmountain_area.area,
		newmountain_area.country_id
FROM(VALUES 
    ('Himalayas', (SELECT country_id FROM mountain_club.country WHERE country_name = 'United States')),
    ('Kilimanjaro National Park', (SELECT country_id FROM mountain_club.country WHERE country_name = 'Canada'))
)AS newmountain_area(area, country_id)
WHERE NOT EXISTS (
SELECT 1
FROM mountain_club.mountain_area mo_ar
WHERE   mo_ar.area =  newmountain_area.area AND
		mo_ar.country_id = newmountain_area.country_id
);		


INSERT INTO mountain_club.location_detail (mountain_id, mountain_area_id)
SELECT  newlocation_detail.mountain_id,
		newlocation_detail.mountain_area_id
FROM(VALUES 
    ((SELECT mountain_id FROM mountain_club.mountain WHERE name = 'Mount Everest'), (SELECT mountain_area_id FROM mountain_club.mountain_area WHERE area = 'Himalayas')),
    ((SELECT mountain_id FROM mountain_club.mountain WHERE name = 'Mount Kilimanjaro'), (SELECT mountain_area_id FROM mountain_club.mountain_area WHERE area = 'Kilimanjaro National Park'))
)newlocation_detail (mountain_id, mountain_area_id)
WHERE NOT EXISTS (
SELECT 1
FROM mountain_club.location_detail lo_de
WHERE   lo_de.mountain_id = newlocation_detail.mountain_id AND
		lo_de.mountain_area_id = newlocation_detail.mountain_area_id
);		


INSERT INTO mountain_club.payment (payment_status_id, payment_method)
SELECT  newpayment.payment_status_id,
		newpayment.payment_method::payment_method_enum
FROM(VALUES 
    ((SELECT payment_status_id FROM payment_status ORDER BY RANDOM() LIMIT 1), 'card'::payment_method_enum),
    ((SELECT payment_status_id FROM payment_status ORDER BY RANDOM() LIMIT 1), 'cash'::payment_method_enum)
)AS newpayment (payment_status_id, payment_method)
WHERE NOT EXISTS (
SELECT 1
FROM mountain_club.payment pay
WHERE   pay.payment_status_id = newpayment.payment_status_id AND
		pay.payment_method = newpayment.payment_method
);		

INSERT INTO mountain_club.expedition (participant_id, transport_id, guide_id, payment_id, finish_place, meeting_place, expedition_start_datetime, expedition_end_datetime)
SELECT  newexpedition.participant_id,
		newexpedition.transport_id,
		newexpedition.guide_id,
		newexpedition.payment_id,
		newexpedition.finish_place,
		newexpedition.meeting_place,
		newexpedition.expedition_start_datetime,
		newexpedition.expedition_end_datetime
FROM(VALUES 
    ((SELECT participant_id FROM mountain_club.participant ORDER BY RANDOM() LIMIT 1), 
    (SELECT transport_id FROM mountain_club.transport ORDER BY RANDOM() LIMIT 1), 
    (SELECT guide_id FROM mountain_club.guide ORDER BY RANDOM() LIMIT 1), 
    (SELECT payment_id FROM mountain_club.payment ORDER BY RANDOM() LIMIT 1), 
    'Toronto', 
    'New York', 
    TIMESTAMP '2024-04-01 08:00:00+01', 
    TIMESTAMP '2024-04-04 16:00:00+01')
)AS newexpedition (participant_id, transport_id, guide_id, payment_id, finish_place, meeting_place, expedition_start_datetime, expedition_end_datetime)
WHERE NOT EXISTS (
SELECT 1
FROM mountain_club.expedition ex
WHERE   ex.participant_id = newexpedition.participant_id AND
		ex.transport_id = newexpedition.transport_id AND
		ex.guide_id = newexpedition.guide_id AND
		ex.payment_id  = newexpedition.payment_id AND
		ex.finish_place = newexpedition.finish_place AND
		ex.meeting_place = newexpedition.meeting_place AND
		ex.expedition_start_datetime = newexpedition.expedition_start_datetime AND
		ex.expedition_end_datetime = newexpedition.expedition_end_datetime
);		


INSERT INTO mountain_club.expedition_detail (expedition_id, mountain_id, hotel_id)
SELECT  newexpedition_detail.expedition_id,
		newexpedition_detail.mountain_id,
		newexpedition_detail.hotel_id
FROM(VALUES 
    ((SELECT expedition_id FROM mountain_club.expedition WHERE finish_place = 'Toronto' AND meeting_place = 'New York'), 
    (SELECT mountain_id FROM mountain_club.mountain WHERE name = 'Mount Everest'), 
    (SELECT hotel_id FROM mountain_club.hotel WHERE hotel_name = 'Sheraton'))
)AS newexpedition_detail (expedition_id, mountain_id, hotel_id)
WHERE NOT EXISTS (
SELECT 1
FROM mountain_club.expedition_detail ex_d
WHERE   ex_d.expedition_id = newexpedition_detail.expedition_id AND
		ex_d.mountain_id = newexpedition_detail.mountain_id AND
		ex_d.hotel_id = newexpedition_detail.hotel_id
);		

/*Add a not null 'record_ts' field to each table using ALTER TABLE statements,
 set the default value to current_date, and check to make sure the value has been set for the existing rows.*/
-- I used an anonymous block (DO $$ ... $$;) to execute dynamic SQL statements
DO $$
DECLARE
    tablename RECORD;
BEGIN
    FOR tablename IN  --  Iterate over each table in the mountain_club schema 
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema = 'mountain_club' AND table_type = 'BASE TABLE'
    LOOP
	    --record_ts column is added with a default value of current_date, not null
        EXECUTE format('ALTER TABLE %I ADD COLUMN IF NOT EXISTS record_ts DATE DEFAULT current_date NOT NULL', tablename.table_name); 
        -- if record_ts column is null th to the current date where it's currently NULL
        EXECUTE format('UPDATE %I SET record_ts = current_date WHERE record_ts IS NULL', tablename.table_name);
    END LOOP;
END $$;


