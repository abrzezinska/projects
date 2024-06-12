-- Creation of database

CREATE DATABASE healthcare_system;

--Create the schema

CREATE SCHEMA IF NOT EXISTS healthcare;

-- After creating the tables the values was inserted in each tables.
-- In all tables the id column is SERIAL becuase there will not be many rows in them ( for tables with big amount of row I would use BIGSERIAL type)
-- Check if the tables already exists if not then create one
-- Ckeck if added values are already in table if not then insert
-- Relationships between tables was done using primary and foreign keys ( in creating tables step) 
--- The facilitieas are all in London England thats why there is no addirtional tables like country and city

CREATE TABLE IF NOT EXISTS healthcare.address_details
(
	address_details_id SERIAL PRIMARY KEY,
	street TEXT NOT NULL,
	city TEXT DEFAULT 'London' NOT NULL,
	home_number TEXT, -- NOT EVERY address has home no
	postal_code TEXT NOT NULL,
	last_update TIMESTAMP DEFAULT (NOW() - INTERVAL '3 months' * RANDOM())  -- current dete is random date of  update fro LAST 3 months
);

CREATE TABLE IF NOT EXISTS healthcare.contact_details
(
	contact_details_id SERIAL PRIMARY KEY,
	phone_number TEXT NOT NULL,
	email_adress TEXT UNIQUE NOT NULL,
	last_update TIMESTAMP DEFAULT (NOW() - INTERVAL '3 months' * RANDOM())  -- current dete is random date of  update fro LAST 3 months
);

-- Create Patients Table
CREATE TABLE IF NOT EXISTS healthcare.patient 
(
    patient_ID SERIAL PRIMARY KEY,
    patient_name TEXT NOT NULL,
    patient_surname TEXT NOT NULL,
	full_name TEXT GENERATED ALWAYS AS (patient_name || ' ' || patient_surname) STORED NOT NULL, ---GENERATE ALWAYS AS used
    date_of_brith DATE,
    gender TEXT,
    contact_details_id INT NOT NULL REFERENCES healthcare.contact_details(contact_details_id),
	address_details_id INT NOT NULL REFERENCES healthcare.address_details(address_details_id),
    last_update TIMESTAMP DEFAULT (NOW() - INTERVAL '3 months' * RANDOM())  -- current dete is random date of  update fro LAST 3 months
);

-- Create Capacity Table
CREATE TABLE IF NOT EXISTS healthcare.capacity 
(
    capacity_ID SERIAL PRIMARY KEY,
    max_patients_per_day INT UNIQUE,
    last_update TIMESTAMP DEFAULT (NOW() - INTERVAL '3 months' * RANDOM())  -- current dete is random date of  update fro LAST 3 months
);

-- Create Facilities Table
CREATE TABLE IF NOT EXISTS healthcare.facilities 
(
    facility_ID SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    contact_details_id INT NOT NULL REFERENCES healthcare.contact_details(contact_details_id),
	address_details_id INT NOT NULL REFERENCES healthcare.address_details(address_details_id),
    capacity_ID INT REFERENCES healthcare.capacity(capacity_ID),
    last_update TIMESTAMP DEFAULT (NOW() - INTERVAL '3 months' * RANDOM())  -- current dete is random date of  update fro LAST 3 months
    
);

-- Create Postion Table
CREATE TABLE IF NOT EXISTS healthcare.position 
(
    position_ID SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    last_update TIMESTAMP DEFAULT (NOW() - INTERVAL '3 months' * RANDOM())  -- current dete is random date of  update fro LAST 3 months
);

--In one staff member can work only in one facilitie
-- Create Staff Table
CREATE TABLE IF NOT EXISTS healthcare.staff 
(
    staff_ID SERIAL PRIMARY KEY,
    facility_ID INT REFERENCES healthcare.facilities(facility_ID) NOT NULL,
    name TEXT NOT NULL,
    position_ID INT REFERENCES healthcare.position(position_ID) NOT NULL,
    last_update TIMESTAMP DEFAULT (NOW() - INTERVAL '3 months' * RANDOM())  -- current dete is random date of  update fro LAST 3 months
 
);

-- Create Resources Table
CREATE TABLE IF NOT EXISTS healthcare.resources 
(
    resource_ID SERIAL PRIMARY KEY,
    facility_ID INT  REFERENCES healthcare.facilities(facility_ID) NOT NULL,
    resource_name TEXT NOT NULL,
    quantity INT DEFAULT 0,
    last_update TIMESTAMP DEFAULT (NOW() - INTERVAL '3 months' * RANDOM())  -- current dete is random date of  update fro LAST 3 months
   
);


-- Create Visits Table
CREATE TABLE IF NOT EXISTS healthcare.visits 
(
    visit_ID SERIAL PRIMARY KEY,
    patient_ID INT REFERENCES healthcare.patient(patient_ID) NOT NULL,
    facility_ID INT REFERENCES healthcare.facilities(facility_ID) NOT NULL,
    staff_ID INT REFERENCES healthcare.staff(staff_ID) NOT NULL,
    visit_date DATE,
    reason TEXT,
    outcome TEXT,
    last_update TIMESTAMP DEFAULT (NOW() - INTERVAL '3 months' * RANDOM())  -- current dete is random date of  update fro LAST 3 months
 
);

-- Insert data into address_details table
INSERT INTO healthcare.address_details (street, city, home_number, postal_code)
SELECT  newaddress.street, 
		newaddress.city, 
		newaddress.home_number, 
		newaddress.postal_code
FROM (VALUES
    ('123 Main St', 'London', NULL, '12345'),
    ('456 Elm St','London', '789', '67890'),
    ('452 Elm St','London', '722', '67892'),
    ('451 Elm St','London', '783', '67893'),
    ('450 Elm St','London', '788', '67899')
   ) AS newaddress(street, city, home_number, postal_code)
WHERE NOT EXISTS (
SELECT 1
FROM healthcare.address_details ad
WHERE   ad.street = newaddress.street AND 
		ad.city = newaddress.city AND 
		ad.postal_code = newaddress.postal_code
  );

-- Insert data into contact_details table
INSERT INTO healthcare.contact_details (phone_number, email_adress)
SELECT  new_contact.phone_number, 
		new_contact.email_adress
FROM (VALUES 
    ('123-456-7890', 'example1@example.com'),
    ('987-654-3210', 'example2@example.com'),
    ('987-654-3211', 'example3@example.com'),
    ('987-654-3212', 'example4@example.com'),
    ('987-654-3213', 'example5@example.com')
)AS new_contact (phone_number, email_adress)
WHERE NOT EXISTS (
SELECT 1
FROM healthcare.contact_details con
WHERE   con.phone_number = new_contact.phone_number AND 
		con.email_adress = new_contact.email_adress 
  );
 
-- Insert data into facilities table
INSERT INTO healthcare.facilities (name, contact_details_id, address_details_id, capacity_ID)
SELECT  newfacilities.name, 
		newfacilities.contact_details_id, 
		newfacilities.address_details_id, 
		newfacilities.capacity_ID
 FROM (VALUES
    ('Hospital A',
    (SELECT contact_details_id FROM healthcare.contact_details ORDER BY RANDOM() LIMIT 1),
    (SELECT address_details_id FROM healthcare.address_details ORDER BY RANDOM() LIMIT 1),
    (SELECT capacity_ID FROM healthcare.capacity ORDER BY RANDOM() LIMIT 1)),
    ('Hospital B',
    (SELECT contact_details_id FROM healthcare.contact_details ORDER BY RANDOM() LIMIT 1),
    (SELECT address_details_id FROM healthcare.address_details ORDER BY RANDOM() LIMIT 1),
    (SELECT capacity_ID FROM healthcare.capacity ORDER BY RANDOM() LIMIT 1)),
    ('Hospital C',
    (SELECT contact_details_id FROM healthcare.contact_details ORDER BY RANDOM() LIMIT 1),
    (SELECT address_details_id FROM healthcare.address_details ORDER BY RANDOM() LIMIT 1),
    (SELECT capacity_ID FROM healthcare.capacity ORDER BY RANDOM() LIMIT 1)),
    ('Hospital D',
    (SELECT contact_details_id FROM healthcare.contact_details ORDER BY RANDOM() LIMIT 1),
    (SELECT address_details_id FROM healthcare.address_details ORDER BY RANDOM() LIMIT 1),
    (SELECT capacity_ID FROM healthcare.capacity ORDER BY RANDOM() LIMIT 1)),
    ('Hospital E',
    (SELECT contact_details_id FROM healthcare.contact_details ORDER BY RANDOM() LIMIT 1),
    (SELECT address_details_id FROM healthcare.address_details ORDER BY RANDOM() LIMIT 1),
    (SELECT capacity_ID FROM healthcare.capacity ORDER BY RANDOM() LIMIT 1))
) AS newfacilities(name, contact_details_id, address_details_id, capacity_ID)
WHERE NOT EXISTS (
SELECT 1
FROM healthcare.facilities fa
WHERE   fa.name= newfacilities.name AND 
		fa.contact_details_id = newfacilities.contact_details_id AND 
		fa.address_details_id = newfacilities.address_details_id AND  
		fa.capacity_ID = newfacilities.capacity_ID
  );
 
 -- Insert data into postion table
INSERT INTO healthcare.position (name)
SELECT   newsposition.name
FROM (VALUES
    ('Oncologist'),
    ('Pediatrician'), 
    ('Internist'), 
    ('Ophthalmologist'), 
    ('Helper'),
    ('Surgeon')
    )AS  newsposition(name)
WHERE NOT EXISTS (
SELECT 1
FROM healthcare.position po
WHERE   po.name= newsposition.name
  );
 
-- Insert data into staff table
INSERT INTO healthcare.staff (facility_ID, name, position_id)
SELECT  newstaff.facility_ID, 
		newstaff.name, 
		newstaff.position_id
FROM (VALUES
    ((SELECT facility_ID FROM healthcare.facilities ORDER BY RANDOM() LIMIT 1), 'John Doe', (SELECT position_ID FROM healthcare.position ORDER BY RANDOM() LIMIT 1)),
    ((SELECT facility_ID FROM healthcare.facilities ORDER BY RANDOM() LIMIT 1), 'Jane Smith', (SELECT position_ID FROM healthcare.position ORDER BY RANDOM() LIMIT 1)),
    ((SELECT facility_ID FROM healthcare.facilities ORDER BY RANDOM() LIMIT 1), 'Johan Dot', (SELECT position_ID FROM healthcare.position ORDER BY RANDOM() LIMIT 1)),
    ((SELECT facility_ID FROM healthcare.facilities ORDER BY RANDOM() LIMIT 1), 'Jane Smath', (SELECT position_ID FROM healthcare.position ORDER BY RANDOM() LIMIT 1)),
    ((SELECT facility_ID FROM healthcare.facilities ORDER BY RANDOM() LIMIT 1), 'Jonson Smathann', (SELECT position_ID FROM healthcare.position ORDER BY RANDOM() LIMIT 1))
)AS newstaff (facility_ID, name, position_id)
WHERE NOT EXISTS (
SELECT 1
FROM healthcare.staff st
WHERE   st.name= newstaff.name AND 
		st.facility_ID = newstaff.facility_ID AND 
		st.position_id = newstaff.position_id 
  );
 
-- Insert data into resources table
INSERT INTO healthcare.resources (facility_ID, resource_name, quantity)
SELECT  newresources.facility_ID, 
		newresources.resource_name, 
		newresources.quantity
FROM(VALUES
    ((SELECT facility_ID FROM healthcare.facilities ORDER BY RANDOM() LIMIT 1), 'Medical Equipment', 10),
    ((SELECT facility_ID FROM healthcare.facilities ORDER BY RANDOM() LIMIT 1), 'Medications', 100),
    ((SELECT facility_ID FROM healthcare.facilities ORDER BY RANDOM() LIMIT 1), 'Medical Equipment', 12),
    ((SELECT facility_ID FROM healthcare.facilities ORDER BY RANDOM() LIMIT 1), 'Medications', 102),
    ((SELECT facility_ID FROM healthcare.facilities ORDER BY RANDOM() LIMIT 1), 'Medical Equipment', 5)
)AS newresources (facility_ID, resource_name, quantity)
WHERE NOT EXISTS (
SELECT 1
FROM healthcare.resources re
WHERE   re.resource_name= newresources.resource_name AND 
		re.facility_ID = newresources.facility_ID 
  );

-- Insert data into capacity table
INSERT INTO healthcare.capacity ( max_patients_per_day)
SELECT  newcapacity.max_patients_per_day
FROM(VALUES
    ( 200),
    ( 20),
    ( 300),
    ( 50),
    ( 100)
)AS newcapacity (max_patients_per_day)
WHERE NOT EXISTS (
SELECT 1
FROM healthcare.capacity ca
WHERE  ca.max_patients_per_day = newcapacity.max_patients_per_day 
);
 
-- Insert data into patients table
INSERT INTO healthcare.patient (patient_name, patient_surname, date_of_brith, gender, contact_details_id, address_details_id)
SELECT  newpatient.patient_name, 
		newpatient.patient_surname, 
		newpatient.date_of_brith::DATE, 
		newpatient.gender, 
		newpatient.contact_details_id, 
		newpatient.address_details_id
FROM (VALUES
    ('Alice', 'Johnson', '1990-05-15', 'Female', (SELECT contact_details_id FROM healthcare.contact_details ORDER BY RANDOM() LIMIT 1),
    (SELECT address_details_id FROM healthcare.address_details ORDER BY RANDOM() LIMIT 1)),
    ('Bob', 'Smith', '1985-10-20', 'Male', (SELECT contact_details_id FROM healthcare.contact_details ORDER BY RANDOM() LIMIT 1),
    (SELECT address_details_id FROM healthcare.address_details ORDER BY RANDOM() LIMIT 1)),
    ('Alina', 'Johnsonan', '1990-05-17', 'Female', (SELECT contact_details_id FROM healthcare.contact_details ORDER BY RANDOM() LIMIT 1),
    (SELECT address_details_id FROM healthcare.address_details ORDER BY RANDOM() LIMIT 1)),
    ('Rob', 'Smithan', '1985-10-21', 'Male', (SELECT contact_details_id FROM healthcare.contact_details ORDER BY RANDOM() LIMIT 1),
    (SELECT address_details_id FROM healthcare.address_details ORDER BY RANDOM() LIMIT 1)),
    ('Robinson', 'Smithant', '1985-10-23', 'Male', (SELECT contact_details_id FROM healthcare.contact_details ORDER BY RANDOM() LIMIT 1),
    (SELECT address_details_id FROM healthcare.address_details ORDER BY RANDOM() LIMIT 1))
)AS newpatient (patient_name, patient_surname, date_of_brith, gender, contact_details_id, address_details_id)
WHERE NOT EXISTS (
SELECT 1
FROM healthcare.patient pa
WHERE   pa.patient_name = newpatient.patient_name AND 
		pa.patient_surname = newpatient.patient_surname AND 
		pa.date_of_brith= newpatient.date_of_brith::DATE AND 
		pa.gender= newpatient.gender AND 
		pa.contact_details_id= newpatient.contact_details_id AND 
		pa.address_details_id= newpatient.address_details_id 
  );
 
-- the reason and outcome can be everything the is no normalization here
-- Insert data into visits table
INSERT INTO healthcare.visits (patient_ID, facility_ID, staff_ID, visit_date, reason, outcome)
SELECT  newvisits.patient_ID, 
		newvisits.facility_ID, 
		newvisits.staff_ID, 
		newvisits.visit_date, 
		newvisits.reason, 
		newvisits.outcome
FROM(VALUES
    ((SELECT patient_ID FROM healthcare.patient ORDER BY RANDOM() LIMIT 1),
    (SELECT facility_ID FROM healthcare.staff ORDER BY RANDOM() LIMIT 1),
    (SELECT staff_ID FROM healthcare.staff ORDER BY RANDOM() LIMIT 1),(NOW() - INTERVAL '2 months' * RANDOM()), 'Checkup', 'Good'),
    ((SELECT patient_ID FROM healthcare.patient ORDER BY RANDOM() LIMIT 1),
    (SELECT facility_ID FROM healthcare.staff ORDER BY RANDOM() LIMIT 1),
    (SELECT staff_ID FROM healthcare.staff ORDER BY RANDOM() LIMIT 1), (NOW() - INTERVAL '2 months' * RANDOM()), 'Consultation', 'Stable'),
    ((SELECT patient_ID FROM healthcare.patient ORDER BY RANDOM() LIMIT 1),
    (SELECT facility_ID FROM healthcare.staff ORDER BY RANDOM() LIMIT 1),
    (SELECT staff_ID FROM healthcare.staff ORDER BY RANDOM() LIMIT 1),(NOW() - INTERVAL '2 months' * RANDOM()), 'Checkup', 'Good'),
    ((SELECT patient_ID FROM healthcare.patient ORDER BY RANDOM() LIMIT 1),
    (SELECT facility_ID FROM healthcare.staff ORDER BY RANDOM() LIMIT 1),
    (SELECT staff_ID FROM healthcare.staff ORDER BY RANDOM() LIMIT 1), (NOW() - INTERVAL '2 months' * RANDOM()), 'Consultation', 'Stable'),
    ((SELECT patient_ID FROM healthcare.patient ORDER BY RANDOM() LIMIT 1),
    (SELECT facility_ID FROM healthcare.staff ORDER BY RANDOM() LIMIT 1),
    (SELECT staff_ID FROM healthcare.staff ORDER BY RANDOM() LIMIT 1), (NOW() - INTERVAL '2 months' * RANDOM()), 'Consultation', 'Stable')
)AS  newvisits (patient_ID, facility_ID, staff_ID, visit_Date, reason, outcome)
WHERE NOT EXISTS (
SELECT 1
FROM healthcare.visits vi
WHERE   vi.patient_ID= newvisits.patient_ID AND 
		vi.facility_ID= newvisits.facility_ID AND 
		vi.staff_ID= newvisits.staff_ID AND 
		vi.visit_date= newvisits.visit_date AND 
		vi.reason= newvisits.reason AND 
		vi.outcome= newvisits.outcome
  );

/*Apply three check constraints across the tables to restrict certain values, including
-inserted value that can only be a specific value 
-unique
-not null
First check if the constrain already exists if not the add the constrain
I used pgSQL block (DO $$ ... $$;) to execute the conditional ALTER TABLE statement.*/

DO $$
BEGIN
	
	-- Check if the constraint Unique name
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.constraint_column_usage
        WHERE table_name = 'facilities' AND constraint_name = 'unique_name'
    ) THEN
        -- UNIQUE constraint. Each facilitie must have a different/unique name
        ALTER TABLE healthcare.facilities 
        ADD CONSTRAINT Unique_name UNIQUE (name);
    END IF;

    -- Check if the constraint Level_check exists and if the inserted value that is the specific 
    --value ( Male, Female)
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.constraint_column_usage
        WHERE table_name = 'patient' AND constraint_name = 'gender_check'
    ) THEN
        -- Inserted value that can only be a specific value. 
        ALTER TABLE healthcare.patient
        ADD CONSTRAINT Gender_check CHECK (gender IN ('Male','Female'));
    END IF;
   
    -- Check if the constraint NOT_NULL_check exists
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.constraint_column_usage
        WHERE table_name = 'patient' AND constraint_name = 'not_null_check'
    ) THEN
        -- Patient name cannot be NULL.
        ALTER TABLE healthcare.patient 
        ADD CONSTRAINT NOT_NULL_check CHECK (patient_name IS NOT NULL);
    END IF;
   
END $$;

/*Find doctors who have had a workload of fewer than 5 patients per each month over the last two months (current and previous).*/


WITH monthly_patient_counts AS (
    SELECT
        staff.staff_ID,
        COUNT(DISTINCT visits.patient_ID) AS total_patients, -- ONLY different patients will be counted
        DATE_TRUNC('month', visits.visit_date) AS visit_month
    FROM
        healthcare.staff
    INNER JOIN healthcare.visits ON staff.staff_ID = visits.staff_ID
    INNER JOIN healthcare.position ON staff.position_id = position.position_id
    WHERE visits.visit_date >= (NOW() - INTERVAL '2 months' * RANDOM())  
    GROUP BY staff.staff_ID,
        	 visit_month
)
SELECT
    staff.staff_ID,
    staff.name AS doctor_name,
    monthly_patient_counts.total_patients,
    monthly_patient_counts.visit_month
FROM
    healthcare.staff
INNER JOIN
    monthly_patient_counts ON staff.staff_ID = monthly_patient_counts.staff_ID
WHERE
   monthly_patient_counts.total_patients < 5;
   


