# --- SQL QUERIES ---

SELECT *
FROM retail_sales;

-- Q1. Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';


-- Q2. Write SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or equal to 4 in the month of Nov 2022
SELECT *
FROM retail_sales
WHERE 
	category = 'Clothing' 
    AND 
    quantiy >= 4
    AND
    YEAR(sale_date) = 2022 AND MONTH(sale_date) = 11
;


-- Q3. Write SQL query to calculate the total sales for each category
SELECT category, SUM(total_sale) as category_total_sale, COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category
ORDER BY category_total_sale DESC;


-- Q4. Write SQL query to find the average age of customers who purchased items from the 'Beauty' category
SELECT category, ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty' AND age > 0;	# age > 0 because i have replaced blank values as -1


-- Q5. Write SQL query to find all transactions where the total sale is greater than 1000
SELECT *
FROM retail_sales
WHERE total_sale > 1000;


-- Q6. Write SQL query to find the total number of transactions (transactions_id) made by each gender in each category
SELECT category, gender, COUNT(*) as total_trans
FROM retail_sales
GROUP BY category, gender
ORDER BY 1;


-- Q7. Write SQL query to calculate the average sale for each month. Find out the best selling month in each year.
SELECT 
	YEAR(sale_date) AS `year`, 
    MONTH(sale_date) AS `month`, 
    ROUND(AVG(total_sale), 2) AS avg_sal,
    DENSE_RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS `Rank`
FROM retail_sales
GROUP BY 1, 2;


SELECT *
FROM (
SELECT 
	YEAR(sale_date) AS `year`, 
    MONTH(sale_date) AS `month`, 
    ROUND(AVG(total_sale), 2) AS avg_sal,
    DENSE_RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS `Rank`
FROM retail_sales
GROUP BY 1, 2
) AS t1
WHERE `Rank` = 1;


-- Q8. Write SQL query to find the top 5 customers based on the highest total sales
SELECT customer_id, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


-- Q9. Write SQL query to find the number of unique customers who purchased items from each category
SELECT category, COUNT(DISTINCT customer_id)
FROM retail_sales
GROUP BY 1;


-- Q10. Write SQL query to create each shift and number of orders (Eg. Morning <= 12, Afternoon b/w 12 and 17, Evening > 17)
WITH hourly_sale
AS (
	SELECT *,
		CASE
			WHEN HOUR(sale_time) <= 12 THEN 'Morning'
			WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
		END AS shift
	FROM retail_sales
)
SELECT shift, COUNT(transactions_id) AS total_orders
FROM hourly_sale
GROUP BY shift;