# --- EDA ---

-- How many sales we have?
SELECT COUNT(*) as Total_Sales
FROM retail_sales;


-- How many unique customers we have?
SELECT COUNT(DISTINCT customer_id) as Total_Customers
FROM retail_sales;


-- How many and what unique categories we have?
SELECT COUNT(DISTINCT category) as Total_Customers
FROM retail_sales;

SELECT DISTINCT category as Total_Customers
FROM retail_sales;


-- Total sales amount
SELECT SUM(total_sale)
FROM retail_sales;


-- Which category had the max sales amount
SELECT category, SUM(total_sale) AS max_sales_amount
FROM retail_sales
GROUP BY category
ORDER BY max_sales_amount DESC
LIMIT 1;