
/*Top-3 most selling movie categories of all time and total dvd rental income for each category. 
 * Only consider dvd rental customers from the USA.*/

/*The best selling film is the one that generates the most revenue */
/*I've used the inner joins beacuse I need the shared part of used tables*/
/*Subquery heps to find customers from US*/
/*FETCH FIRST 3 ROWS WITH TIES shows 3 movies with the highest income (there can be more than one person with the same income)*/
/*In this case we can also use limit 3 beacuse the three first rows have different income*/

SELECT 	cat.name AS film_category, 
		SUM(pay.amount) AS rental_income
FROM category cat
INNER JOIN film_category film_cat ON cat.category_id = film_cat.category_id
INNER JOIN film film ON film.film_id = film_cat.film_id
INNER JOIN inventory invent ON invent.film_id = film.film_id
INNER JOIN rental rent ON rent.inventory_id = invent.inventory_id
INNER JOIN payment pay ON pay.rental_id = rent.rental_id
WHERE pay.customer_id IN 
	(
	SELECT cust.customer_id
	FROM customer cust
	INNER JOIN address adress ON cust.address_id = adress.address_id
	INNER JOIN city city ON adress.city_id = city.city_id
	INNER JOIN country country ON city.country_id = country.country_id
	WHERE country.country = 'United States'
	)
GROUP BY cat.category_id
ORDER BY rental_income DESC 
FETCH FIRST 3 ROWS WITH TIES;

/*For each client, display a list of horrors that he had ever rented (in one column, separated by commas),
 *  and the amount of money that he paid for it*/
/*I've used the inner joins beacuse I need the shared part of used tables*/
/*I've used the left joins beacuse I need all cutomers from customer table not only the ones who rented horrors*/
/*CTE customer_horrors filter the cutomers who rented horror, sum what they paid for the rented horror and shows tittles of their rented horror*/

WITH customer_horrors AS
(
	SELECT	cust.first_name,	
	    	cust.last_name,	
	   		STRING_AGG(film.title, '. ') AS rented_horrors,
	    	SUM(pay.amount)	AS total_rental_income,
	    	cust.customer_id 
	FROM customer cust
	INNER JOIN payment pay ON cust.customer_id = pay.customer_id
	INNER JOIN rental rent ON rent.rental_id = pay.rental_id
	INNER JOIN inventory invent ON invent.inventory_id = rent.inventory_id
	INNER JOIN film film ON film.film_id = invent.film_id
	INNER JOIN film_category film_cat ON film_cat.film_id = film.film_id
	INNER JOIN category cat ON cat.category_id = film_cat.category_id
	WHERE cat.name = 'Horror'
	GROUP BY cust.customer_id,
			 cust.first_name,	
	    	 cust.last_name,
	    	 cust.customer_id 
)
SELECT cust.first_name	AS customer_first_name,
	   cust.last_name	AS customer_last_name,
	   rented_horrors,
	   total_rental_income
FROM customer cust 
LEFT JOIN customer_horrors cust_horr ON cust.customer_id = cust_horr.customer_id
ORDER BY rented_horrors;

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
