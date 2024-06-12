/*Create a view called 'sales_revenue_by_category_qtr' that shows the film category and total sales revenue for the current 
 quarter and year. The view should only display categories with at least one sale in the current quarter. 
Note: when the next quarter begins, it will be considered as the current quarter.*/

CREATE VIEW sales_revenue_by_category_qtr AS
WITH helper AS (
    SELECT  
        inv.film_id,
        SUM(pay.amount) AS revenue,
        pay.payment_date
    FROM 
        payment pay
        INNER JOIN rental ren ON pay.rental_id = ren.rental_id
        INNER JOIN inventory inv ON ren.inventory_id = inv.inventory_id
    WHERE EXTRACT --(YEAR FROM pay.payment_date) = 2017 
       EXTRACT(QUARTER FROM pay.payment_date) = EXTRACT(QUARTER FROM CURRENT_DATE)  -- Filter for current quarter
       AND EXTRACT(YEAR FROM pay.payment_date) = EXTRACT(YEAR FROM CURRENT_DATE)  -- Filter for current year
    GROUP BY 
        inv.film_id,
        pay.payment_date
)
SELECT 
    cat.name,
    SUM(revenue) AS total_revenue
FROM 
    helper he
    INNER JOIN film_category fil_cat ON he.film_id = fil_cat.film_id 
    INNER JOIN category cat ON cat.category_id = fil_cat.category_id
GROUP BY 
    cat.name
HAVING 
    SUM(revenue) > 0  -- Only include categories with at least one sale in the current quarter
ORDER BY 
    cat.name DESC;



/*Create a query language function called 'get_sales_revenue_by_category_qtr' that accepts one parameter representing 
 * the current quarter and year and returns the same result as the 'sales_revenue_by_category_qtr' view.*/


CREATE OR REPLACE FUNCTION get_sales_revenue_by_category_qtr(p_quarter INT, p_year INT)
RETURNS TABLE (
    category_name TEXT,
    total_revenue NUMERIC
    --payment_date DATE
) AS $$
BEGIN
    RETURN QUERY
    WITH helper AS (
        SELECT  
            inv.film_id,
            SUM(pay.amount) AS revenue,
            pay.payment_date
        FROM 
            payment pay
            INNER JOIN rental ren ON pay.rental_id = ren.rental_id
            INNER JOIN inventory inv ON ren.inventory_id = inv.inventory_id
        WHERE 
            EXTRACT(QUARTER FROM pay.payment_date) = p_quarter
            AND EXTRACT(YEAR FROM pay.payment_date) = p_year
        GROUP BY 
            inv.film_id,
            pay.payment_date
    )
    SELECT 
        cat.name AS category_name,
        SUM(revenue) AS total_revenue
        --CURRENT_DATE AS payment_date
    FROM 
        helper he
        INNER JOIN film_category fil_cat ON he.film_id = fil_cat.film_id 
        INNER JOIN category cat ON cat.category_id = fil_cat.category_id
    GROUP BY 
        cat.name
    HAVING 
        SUM(revenue) > 0
    ORDER BY 
        cat.name DESC;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_sales_revenue_by_category_qtr(1, 2017); -- Replace 1 and 2024 with the desired quarter and year





