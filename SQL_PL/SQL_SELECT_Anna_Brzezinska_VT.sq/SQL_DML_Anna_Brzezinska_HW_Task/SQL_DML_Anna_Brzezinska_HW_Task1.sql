
/*Choose your top-3 favorite movies and add them to the 'film' table. Fill in rental rates with 4.99, 9.99 and 19.99 
 * and rental durations with 1, 2 and 3 weeks respectively.*/


INSERT INTO film (title, release_year, language_id, rental_duration, rental_rate)
SELECT  newfilm.title,
		newfilm.release_year,
		newfilm.language_id,
		newfilm.rental_duration,
		newfilm.rental_rate
FROM (VALUES
('HOBBIT', 2012,
(
SELECT lan.language_id
FROM public."language" lan
WHERE lan."name" = 'English'
),
7,
4.99 
), 
(
'WOLVERINE', 2013,
(
SELECT lan.language_id
FROM public."language"  lan
WHERE lan."name" = 'German'
),
14,
9.99
), (
'AQUAMAN', 2018,
(
SELECT lan.language_id
FROM public."language" lan
WHERE lan."name" = 'English'
),
21,
19.99
)
) AS newfilm (title, release_year, language_id, rental_duration, rental_rate)
WHERE NOT EXISTS (
SELECT 1
FROM public.film fil
WHERE fil.title = newfilm.title AND 
fil.language_id = newfilm.language_id AND 
fil.release_year = newfilm.release_year
); --- the same film in different languages can be added new vesrion with the same title and langueage too.  
 

/*Add the actors who play leading roles in your favorite movies to the 'actor' and 'film_actor' tables (6 or more actors in total).*/

INSERT INTO actor (first_name, last_name)
SELECT  newactor.first_name,
		newactor.last_name
FROM (VALUES
('ORLANDO', 'BLOOM'),
('HUGH', 'JACKMAN'),
('JASON', 'MOMOA'),
('AMBER', 'HEARD'),
('RICHARD', 'ARMITAGE'),
('TAO', 'OKAMAOTO')
)AS newactor (first_name, last_name)
WHERE NOT EXISTS (
SELECT 1
FROM public.actor act
WHERE act.first_name = newactor.first_name AND 
act.last_name = newactor.last_name
);

INSERT INTO film_actor (film_id, actor_id)
SELECT film_id, actor_id
FROM (
VALUES
    -- Orlando Bloom in HOBBIT
    ((SELECT film_id FROM film WHERE title = 'HOBBIT'), (SELECT actor_id  FROM actor WHERE first_name = 'ORLANDO' AND last_name = 'BLOOM')),
    -- Hugh Jackman in WOLVERINE
    ((SELECT film_id FROM film WHERE title = 'WOLVERINE'), (SELECT actor_id FROM actor WHERE first_name = 'HUGH' AND last_name = 'JACKMAN')),
    -- Jason Momoa in Aquaman
    ((SELECT film_id FROM film WHERE title = 'AQUAMAN'), (SELECT actor_id FROM actor WHERE first_name = 'JASON' AND last_name = 'MOMOA')),
    -- Amber Heard in Aquaman
    ((SELECT film_id FROM film WHERE title = 'AQUAMAN'), (SELECT actor_id FROM actor WHERE first_name = 'AMBER' AND last_name = 'HEARD')),
    -- Richard Armitage in HOBBIT
    ((SELECT film_id FROM film WHERE title = 'HOBBIT'), (SELECT actor_id FROM actor WHERE first_name = 'RICHARD' AND last_name = 'ARMITAGE')),
    -- Tao Okamoto in The Wolverine (assuming a movie for demonstration)
    ((SELECT film_id FROM film WHERE title = 'WOLVERINE'), (SELECT actor_id FROM actor WHERE first_name = 'TAO' AND last_name = 'OKAMAOTO'))
) AS data (film_id, actor_id)
WHERE NOT EXISTS (
    SELECT fil_act.film_id, fil_act.actor_id
    FROM film_actor fil_act
    WHERE fil_act.film_id = data.film_id AND
    fil_act.actor_id = data.actor_id
   );
    
-- Add your favorite movies to any store's inventory
    
WITH random_store AS (
    SELECT store_id FROM store ORDER BY RANDOM() LIMIT 1
)   
INSERT INTO inventory  (film_id, store_id)
SELECT film_id, store_id
FROM (
VALUES
	((SELECT film_id FROM film WHERE title = 'HOBBIT'), (SELECT store_id  FROM random_store)),
    ((SELECT film_id FROM film WHERE title = 'WOLVERINE'), (SELECT store_id  FROM random_store)),
    ((SELECT film_id FROM film WHERE title = 'AQUAMAN'), (SELECT store_id  FROM random_store))
) AS data_1 (film_id, store_id)
WHERE NOT EXISTS (
    SELECT invent.film_id, invent.store_id
    FROM inventory invent
    WHERE invent.film_id = data_1.film_id AND
    invent.store_id = data_1.store_id
   );
   
 /*Alter any existing customer in the database with at least 43 rental and 43 payment records. 
  * Change their personal data to yours (first name, last name, address, etc.). 
  * You can use any existing address from the "address" table. Please do not perform any updates on the "address" table,
  *  as this can impact multiple records with the same address.*/   


UPDATE customer
SET 
	first_name = newcustomer.first_name,
    last_name = newcustomer.last_name,
    address_id = newcustomer.address_id,
    email = newcustomer.email
FROM 
(VALUES
('ANNA', 'BRZEZINSKA',(SELECT adr.address_id FROM address adr ORDER BY RANDOM() LIMIT 1),'ANNA.email@example.com' )

)AS newcustomer(first_name, last_name, address_id, email )
WHERE customer_id IN (
    SELECT pay.customer_id
    FROM payment pay
    GROUP BY pay.customer_id
    HAVING COUNT(DISTINCT pay.rental_id) >= 43
    AND COUNT(DISTINCT pay.payment_id) >= 43
    ORDER BY RANDOM() LIMIT 1
)
AND NOT EXISTS ( -- Checking IF the customer already exist in db
    SELECT 1
    FROM customer cus
    WHERE cus.first_name = newcustomer.first_name
    AND cus.last_name = newcustomer.last_name 
    AND cus.email = newcustomer.email
);

/*Remove any records related to you (as a customer) from all tables except 'Customer' and 'Inventory'*/

BEGIN TRANSACTION;

-- Create a temporary table to store the customer_id values
CREATE TEMPORARY TABLE temp_delete_row AS
SELECT customer_id 
FROM customer cust  
WHERE cust.first_name = 'ANNA' AND
cust.last_name = 'BRZEZINSKA'  AND
cust.email = 'ANNA.email@example.com';

-- DELETE payment records associated with the customer_id values in the temporary table
DELETE FROM payment 
WHERE customer_id IN (SELECT customer_id FROM temp_delete_row);

-- DELETE rental records associated with the customer_id values in the temporary table
DELETE FROM rental 
WHERE customer_id IN (SELECT customer_id FROM temp_delete_row);

-- Drop the temporary table
DROP TABLE temp_delete_row;

-- Commit the transaction if everything executed successfully
COMMIT;

--Scond way with cte

WITH cte_delete_rental AS (
DELETE FROM public.rental r
WHERE r.customer_id IN (
SELECT c.customer_id
FROM customer c
WHERE UPPER(first_name) = 'ANNA' AND
UPPER(last_name) = 'BRZEZINSKA'
)
RETURNING r.customer_id
)
DELETE FROM public.payment p
WHERE p.customer_id IN (
SELECT cte.customer_id
FROM cte_delete_rental cte
GROUP BY cte.customer_id
);

/*Rent you favorite movies from the store they are in and pay for them (add corresponding records to the database to represent
 *  this activity) (Note: to insert the payment_date into the table payment, you can create a new partition
 *  (see the scripts to install the training database ) or add records for the first half of 2017)*/

CREATE TABLE IF NOT EXISTS public.payment_p2024 PARTITION OF public.payment 
FOR VALUES FROM ('2024-01-01 00:00:00+01') TO ('2024-12-31 22:00:00+01');

-- The customer can rent the same film many times.

WITH cte_rent AS (
INSERT INTO public.rental (rental_date, return_date, inventory_id, customer_id, staff_id)
VALUES (
(
SELECT TIMESTAMP '2023-10-31 01:39:54' +
RANDOM() * (NOW() - TIMESTAMP '2023-10-31 01:39:54')
),
(
SELECT NOW()
),
(
SELECT i.inventory_id -- Non-deterministic subquery used instead of randomization
FROM public.inventory i
WHERE i.film_id = (
SELECT fil.film_id
FROM public.film fil
WHERE UPPER(fil.title) = 'HOBBIT'
LIMIT 1
)
),
(
SELECT cust.customer_id -- Non-deterministic subquery used instead of randomization
FROM public.customer cust 
WHERE cust.first_name = 'ANNA' AND
cust.last_name = 'BRZEZINSKA'  AND
cust.email = 'ANNA.email@example.com'
LIMIT 1
),
(
SELECT st.staff_id -- Non-deterministic subquery used instead of randomization
FROM public.staff st
WHERE st.staff_id IN 
( 
SELECT MAX(staff_id) AS max_staff_id 
FROM staff 
LIMIT 1
)
)
)
RETURNING 	rental_date, 
			return_date, 
			inventory_id, 
			customer_id, 
			staff_id, 
			rental_id
)
INSERT INTO public.payment (customer_id, staff_id, rental_id, payment_date, amount)
SELECT  cte.customer_id,
		cte.staff_id,
		cte.rental_id,
		NOW(),
		((EXTRACT(EPOCH FROM (cte.return_date::timestamp - cte.rental_date::timestamp)) / 86400) * 
		(SELECT fil.rental_rate
		FROM public.film fil
		WHERE UPPER(fil.title) = 'HOBBIT'
		LIMIT 1)) -- Calculating amount based on rental duration
FROM cte_rent cte
RETURNING   rental_id,
			payment_id;

