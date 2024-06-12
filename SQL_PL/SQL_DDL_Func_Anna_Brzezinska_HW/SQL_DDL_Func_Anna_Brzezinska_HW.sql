/*Create a view called 'sales_revenue_by_category_qtr' that shows the film category and total sales revenue for the current 
 quarter and year. The view should only display categories with at least one sale in the current quarter. 
Note: when the next quarter begins, it will be considered as the current quarter.*/

DO $$
BEGIN
    -- Check if the view already exists, drop it if it does
    IF EXISTS(SELECT 1 FROM information_schema.views WHERE table_name = 'sales_revenue_by_category_qtr') THEN
        DROP VIEW public.sales_revenue_by_category_qtr;
    END IF;

    -- Attempt to create the view
    BEGIN
        CREATE VIEW public.sales_revenue_by_category_qtr AS
		SELECT  cat.name,
		    	SUM(pay.amount) AS total_revenue
		FROM public.payment pay
		    INNER JOIN public.rental ren ON pay.rental_id = ren.rental_id
		    INNER JOIN public.inventory inv ON ren.inventory_id = inv.inventory_id
		    INNER JOIN public.film_category fil_cat ON inv.film_id = fil_cat.film_id 
		    INNER JOIN public.category cat ON cat.category_id = fil_cat.category_id
		WHERE EXTRACT(QUARTER FROM pay.payment_date) = EXTRACT(QUARTER FROM CURRENT_DATE) AND
		      EXTRACT(YEAR FROM pay.payment_date) = EXTRACT(YEAR FROM CURRENT_DATE)
		GROUP BY  cat.name
		HAVING SUM(pay.amount) > 0
		ORDER BY cat.name DESC;
    EXCEPTION
        WHEN others THEN
            RAISE EXCEPTION 'Failed to create view: sales_revenue_by_category_qtr. Error: %', SQLERRM;
    END;

    -- Check if the view was created successfully
    IF NOT EXISTS(SELECT 1 FROM information_schema.views WHERE table_name = 'sales_revenue_by_category_qtr') THEN
        RAISE EXCEPTION 'Failed to create view: sales_revenue_by_category_qtr';
    END IF;
END $$;

SELECT * FROM public.sales_revenue_by_category_qtr;
----------------------------------------------------------------------------------------------------------------------------
   

/*Create a query language function called 'get_sales_revenue_by_category_qtr' that accepts one parameter representing 
 * the current quarter and year and returns the same result as the 'sales_revenue_by_category_qtr' view.*/


CREATE OR REPLACE FUNCTION public.get_sales_revenue_by_category_qtr(p_date TIMESTAMP)
RETURNS TABLE (
    category_name TEXT,
    total_revenue NUMERIC
    --payment_date DATE
) AS $$
DECLARE
    p_quarter INT;
    p_year INT;
BEGIN
	-- Extract quarter and year from the input datetime
    p_quarter := EXTRACT(QUARTER FROM p_date); -- extraxting quarter from input date
    p_year := EXTRACT(YEAR FROM p_date);-- extraxting year from input date
   
    RETURN QUERY
    WITH helper AS (
        SELECT  inv.film_id,
	            SUM(pay.amount) AS revenue,
	            pay.payment_date
        FROM public.payment pay
            INNER JOIN public.rental ren ON pay.rental_id = ren.rental_id
            INNER JOIN public.inventory inv ON ren.inventory_id = inv.inventory_id
        WHERE  EXTRACT(QUARTER FROM pay.payment_date) = p_quarter AND --choosnig anly this value with tha same quarter as the input date
           	   EXTRACT(YEAR FROM pay.payment_date) = p_year --choosnig anly this value with tha same year as input date
        GROUP BY  inv.film_id,
           		  pay.payment_date
    )
    SELECT  cat.name AS category_name,
        	SUM(revenue) AS total_revenue --sum total revenu for each film category
        --CURRENT_DATE AS payment_date
    FROM helper he
        INNER JOIN public.film_category fil_cat ON he.film_id = fil_cat.film_id 
        INNER JOIN public.category cat ON cat.category_id = fil_cat.category_id
    GROUP BY cat.name
    HAVING SUM(revenue) > 0
    ORDER BY cat.name DESC;
    RETURN;
EXCEPTION
    WHEN others THEN
        RAISE EXCEPTION 'An error occurred while executing the function: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM public.get_sales_revenue_by_category_qtr('26-01-2017'); -- Replace with current date
----------------------------------------------------------------------------------------------------------------------------------------

/*Create a function that takes a country as an input parameter and returns the most popular film in that specific country. */

CREATE OR REPLACE FUNCTION public.most_popular_films_by_countries(country_names TEXT[])
RETURNS TABLE (country TEXT, film_title TEXT, release_year INTEGER, language TEXT, length INTEGER, rating TEXT, total_rental BIGINT)
AS $$
DECLARE
    country_name TEXT;
BEGIN
    FOR country_name IN SELECT unnest(country_names) LOOP
        RETURN QUERY
        WITH most_popular_movie AS (
            SELECT  film.title::TEXT AS film_title,
	                film.release_year::INT,
	                film.language_id, 
	                film."length"::INT, 
	                film.rating::TEXT, 
	                COUNT(rent.rental_id) AS total_rental, 
	                co.country::TEXT
            FROM  public.rental rent
            	INNER JOIN public.customer cus ON cus.customer_id = rent.customer_id
                INNER JOIN public.inventory invent ON rent.inventory_id = invent.inventory_id
            	INNER JOIN public.film film ON invent.film_id = film.film_id
                INNER JOIN public.address ad ON ad.address_id = cus.address_id
                INNER JOIN public.city ci ON ci.city_id = ad.city_id
                INNER JOIN public.country co ON co.country_id = ci.country_id
            WHERE  UPPER(co.country) = upper (country_name::TEXT) --country_name::TEXT
            GROUP BY film.title, 
	                 film.release_year, 
	                 film.language_id, 
	                 film.length, 
	                 film.rating, 
              		 co.country
            ORDER BY total_rental DESC 
            FETCH FIRST 1 ROWS WITH TIES  -- the number of rental films can be the same in some countries
        )
        SELECT  mo.country::TEXT AS country, 
            	mo.film_title::TEXT, 
	            mo.release_year::INT, 
	            lan.name::TEXT AS language, 
	            mo.length::INT, 
	            mo.rating::TEXT, 
	            mo.total_rental 
        FROM 
            most_popular_movie mo
            INNER JOIN public.language lan ON mo.language_id = lan.language_id;
    END LOOP;
    -- Return empty result if no countries are provided
    IF NOT FOUND THEN
        RETURN QUERY SELECT NULL::TEXT AS country, 
       						NULL::TEXT AS film_title, 
       						NULL::INT AS release_year, 
       						NULL::TEXT AS language, 
       						NULL::INT AS length, 
       						NULL::TEXT AS rating, 
       						NULL::BIGINT AS total_rental;
    END IF;

     --If execution reaches here, the function has executed successfully
    RETURN;
EXCEPTION
    WHEN others THEN	
        RAISE EXCEPTION 'An error occurred while executing the function: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;


-- Example of how to call the function with an array of country names
SELECT * FROM public.most_popular_films_by_countries(ARRAY['Afghanistan', 'angola']);
SELECT * FROM public.most_popular_films_by_countries(ARRAY['canada', 'austria']);
SELECT * FROM public.most_popular_films_by_countries(ARRAY['algeria', 'germany']);
SELECT * FROM public.most_popular_films_by_countries(ARRAY['Hong Kong', 'Poland']);
SELECT * FROM public.most_popular_films_by_countries(ARRAY['hungary', 'india']);
SELECT * FROM public.most_popular_films_by_countries(ARRAY['ITALY', 'SPAIN']);

------------------------------------------------------------------------------------------------------------------------------

/*Create a function that generates a list of movies available in stock based on a partial title match 
 * (e.g., movies containing the word 'love' in their title). 
 * 
The titles of these movies are formatted as '%...%', and if a movie with the specified title is not in stock, 
return a message indicating that it was not found.

The function should produce the result set in the following format (note: the 'row_num' field is an automatically
 generated counter field, starting from 1 and incrementing for each entry, e.g., 1, 2, ..., 100, 101, ...).

*/

CREATE OR REPLACE FUNCTION public.get_movies_by_partial_title(partial_title TEXT)
RETURNS TABLE (
    row_num INT,
    title TEXT,
    customer_name TEXT,
    rental_date DATE,
    language_name TEXT,
    rental_count INT,
    returned_count INT
) AS $$
DECLARE
    movie_record RECORD;
    counter INT := 1;
BEGIN
    -- Drop the temporary table if it already exists
    DROP TABLE IF EXISTS temp_movies;

    -- Create the temporary table to store the result set
    CREATE TEMP TABLE temp_movies (
        row_num INT,
        title TEXT,
        customer_name TEXT,
        rental_date DATE,
        language_name TEXT,
        rental_count INT,
        returned_count INT
    );

    IF NOT EXISTS (
        SELECT 1
        FROM public.film film
        WHERE film.title ILIKE '%' || partial_title || '%'
    ) THEN
        -- If no matching movies are found, insert a placeholder row into the temporary table
        INSERT INTO temp_movies VALUES (
            1,
            'Movie not found',
            '',
            NULL,
            '',
            0,
            0
        );
    ELSE
        -- Fetch movies matching the partial title and populate the temporary table
        FOR movie_record IN
            SELECT DISTINCT ON (film.title) -- movies title is not doubled
                film.title,
                CONCAT(cus.first_name, ' ', cus.last_name) AS customer_name,
                rent.rental_date::DATE AS rental_date,
                lan.name::TEXT AS language_name,
                COUNT(rent.rental_id) AS rental_count,
                COUNT(rent.return_date) AS returned_count
            FROM    public.film film
            INNER JOIN public.inventory invent ON invent.film_id = film.film_id
            INNER JOIN public.rental rent ON rent.inventory_id = invent.inventory_id
            INNER JOIN public.customer cus ON rent.customer_id = cus.customer_id
            INNER JOIN public.language lan ON film.language_id = lan.language_id
            WHERE film.title ILIKE '%' || partial_title || '%' 
            AND rent.return_date >= rent.rental_date -- check if movie is in stock at this moment
            GROUP BY film.title, customer_name, rent.rental_date, lan.name
            ORDER BY film.title, rent.rental_date
        LOOP
            -- Insert each movie record into the temporary table
            INSERT INTO temp_movies VALUES (
                counter,
                movie_record.title,
                movie_record.customer_name,
                movie_record.rental_date,
                movie_record.language_name,
                movie_record.rental_count,
                movie_record.returned_count
            );
            counter := counter + 1; -- counting row number
        END LOOP;
    END IF;

    -- Return the result set from the temporary table
    RETURN QUERY SELECT * FROM temp_movies;
   EXCEPTION
    WHEN others THEN
        RAISE EXCEPTION 'An error occurred while executing the function: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;

--Checking if working correctly
SELECT * FROM public.get_movies_by_partial_title('loven'); --NOT found
SELECT * FROM public.get_movies_by_partial_title('love'); -- FOUND
SELECT * FROM public.get_movies_by_partial_title('haten'); --NOT found
SELECT * FROM public.get_movies_by_partial_title('hate'); -- FOUND
SELECT * FROM public.get_movies_by_partial_title('monster'); -- FOUND
SELECT * FROM public.get_movies_by_partial_title('honey'); -- FOUND

------------------------------------------------------------------------------------------------------------------------------

/*Create a procedure language function called 'new_movie' that takes a movie title as a parameter and inserts a new movie 
 * with the given title in the film table. The function should generate a new unique film ID, set the rental rate to 4.99, 
 * the rental duration to three days, the replacement cost to 19.99. The release year and language are optional and by default 
 * should be current year and Klingon respectively. The function should also verify that the language exists in the 'language' table. 
 * Then, ensure that no such function has been created before; if so, replace it.*/

CREATE OR REPLACE FUNCTION public.new_movie(
    movie_title TEXT,
    release_year_new INT DEFAULT extract(year from current_date),-- if date not added the extrat year from current date
    language_name TEXT DEFAULT 'Klingon' -- if langeage not added then input Klingon
)
RETURNS TABLE (
    new_film_id INT,
    new_title TEXT,
    new_release_year INT,
    new_language TEXT,
    new_rental_rate NUMERIC,
    new_rental_duration INT,
    new_replacement_cost NUMERIC
) AS $$
DECLARE
    new_film_id INT;
    new_lang_id INT; -- Variable to store the new language ID
    movie_exists BOOLEAN; -- Variable to store whether the movie already exists
BEGIN
    -- Check if the provided language exists in the language table
    SELECT language_id INTO new_lang_id FROM public.language WHERE name = language_name;

    IF NOT FOUND THEN
        -- If language doesn't exist, insert it into the language table
        -- Generate a new unique language_id
        SELECT COALESCE(MAX(language_id), 0) + 1 INTO new_lang_id FROM language;
        -- Insert the language into the language table
        INSERT INTO public.language (language_id, name) VALUES (new_lang_id, language_name);
    END IF;

    -- Check if the movie already exists
    SELECT EXISTS (
        SELECT 1
        FROM film
        WHERE title = movie_title
        AND release_year ::INT = release_year_new
    ) INTO movie_exists;

    IF movie_exists THEN
        RAISE EXCEPTION 'Movie "%" released in % already exists.', movie_title, release_year_new;
    ELSE
        -- Generate a new unique film ID
        SELECT COALESCE(MAX(film_id), 0) + 1 INTO new_film_id FROM film;

        -- Insert the new movie into the film table
        INSERT INTO film (film_id, title, release_year, language_id, rental_rate, rental_duration, replacement_cost)
        VALUES (new_film_id, movie_title, release_year_new, new_lang_id, 4.99, 3, 19.99);

        -- Return the details of the newly added movie
        RETURN QUERY 
        SELECT fil.film_id, fil.title, fil.release_year::INT, lan.name::TEXT AS language_name, fil.rental_rate, fil.rental_duration::INT, fil.replacement_cost
        FROM public.film fil
        INNER JOIN public.language lan ON fil.language_id = lan.language_id
        WHERE fil.title = movie_title;
    END IF;
END;
$$ LANGUAGE plpgsql;

--Checking if working correctly
SELECT * FROM public.new_movie('Your Movie Title3');
SELECT * FROM public.new_movie('nananan', 2019 );
SELECT * FROM public.new_movie('ALOHA', 2018, 'English');