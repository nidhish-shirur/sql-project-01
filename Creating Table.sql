DROP TABLE IF EXISTS retail_sales;

CREATE TABLE retail_sales (
	transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantiy INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);

SELECT *
FROM retail_sales;

# number of rows
SELECT COUNT(*)
FROM retail_sales;