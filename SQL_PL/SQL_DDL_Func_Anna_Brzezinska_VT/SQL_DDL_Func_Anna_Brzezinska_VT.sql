

CREATE OR REPLACE FUNCTION public.get_customer_metrics(
    client_id INT,
    left_boundary TIMESTAMP WITH TIME ZONE,
    right_boundary TIMESTAMP WITH TIME ZONE
)
RETURNS TABLE (
    metric_name TEXT,
    metric_value TEXT
) AS $$
DECLARE
	customer_info TEXT;
    total_rentals INT;
    film_list TEXT;
    total_payments INT;
    total_amount NUMERIC;
BEGIN
	 -- Check if the left boundary is greater than the right boundary
    IF left_boundary > right_boundary THEN
        RAISE EXCEPTION 'Left boundary cannot be greater than the right boundary';
    END IF;
   
    -- Number of films rented during specified timeframe
    SELECT COUNT(ren.rental_id) INTO total_rentals
    FROM public.rental ren
    WHERE ren.customer_id = client_id AND
     	  rental_date >= left_boundary AND
     	  rental_date <= right_boundary;
   
    -- Comma-separated list of rented films at the end of specified time period
    SELECT string_agg(fil.title, ', ') INTO film_list -- adding title to list
    FROM public.rental ren
    INNER JOIN public.inventory inv ON ren.inventory_id = inv.inventory_id
    INNER JOIN public.film  fil ON inv.film_id = fil.film_id
    WHERE ren.customer_id = client_id AND
    	  ren.rental_date >= left_boundary AND
          ren.rental_date <= right_boundary;
   
    -- Comma-separated information aboyt client
    SELECT CONCAT_WS(', ', cus.first_name || ' ' || cus.last_name, cus.email) INTO customer_info -- full name and email added to customer info 
    FROM public.customer cus
    WHERE cus.customer_id = client_id;
   
    
    -- Total number of payments made during specified time period
    SELECT COUNT(pay.payment_id) INTO total_payments
    FROM public.payment pay
    WHERE pay.customer_id = client_id AND
	      pay.payment_date >= left_boundary AND
	      pay.payment_date <= right_boundary;
    
    -- Total amount paid during specified time period
    SELECT SUM(pay.amount) INTO total_amount
    FROM public.payment pay
    WHERE pay.customer_id = client_id AND
	      pay.payment_date >= left_boundary AND
	      pay.payment_date <= right_boundary;
    
    -- Return the metrics
    RETURN QUERY VALUES ('Customer info', COALESCE(customer_info, 'Unknown')),
    					('Number of films rented', total_rentals::TEXT),
                        ('List of rented films', COALESCE(film_list, 'None')),
                        ('Number of payments made', total_payments::TEXT),
                        ('Amount paid', COALESCE(total_amount::TEXT, '0'));
END;
$$ LANGUAGE plpgsql;



--Check if working
SELECT * FROM public.get_customer_metrics(
    client_id := 597, -- Replace with the actual client_id
    left_boundary := '2005-01-10 00:00:00+00', -- Replace with the start of the timeframe
    right_boundary := '2020-01-31 23:59:59+00' -- Replace with the end of the timeframe
);

SELECT * FROM public.get_customer_metrics(
    client_id := 597, -- Replace with the actual client_id
    left_boundary := '2010-01-10 00:00:00+00', -- Replace with the start of the timeframe
    right_boundary := '2005-01-31 23:59:59+00' -- Replace with the end of the timeframe
);






