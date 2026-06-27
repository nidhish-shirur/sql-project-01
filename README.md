# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Database**: `retail_sales_analysis`  
**Core Tools**: MySQL Workbench, Excel (for initial staging)

This project is a hands-on look at how I took a messy retail dataset and turned it into something useful. In this project, I took a raw CSV file with about 2,000 retail transactions and built a clean, working database out of it using MySQL Workbench. I went through the whole process from scratch: setting up the table structure, figuring out how to handle messy data (like missing ages and blank financial rows), and finally writing SQL queries to find real answers about sales trends, popular categories, and when customers buy the most.

## Objectives

1. **Database Architecture**: Design and implement a structured database schema to house transactional retail data.
2. **Data Wrangling & Cleaning**: Handle missing variables, enforce data integrity constraints (Primary Keys), and standardize date/time formats for SQL ingestion.
3. **Exploratory Data Analysis (EDA)**: Run descriptive statistics to understand customer demographics and product performance.
4. **Business Intelligence**: Formulate complex SQL queries to extract KPIs such as top-performing categories, monthly sales trends, and peak operational hours.

## Project Structure

### 1. Database Setup

- **Database Creation**: Created the `retail_sales_analysis` schema.
- **Table Creation**: Designed the `retail_sales` table with strict data types (`INT`, `VARCHAR`, `DATE`, `TIME`, `FLOAT`) to ensure data integrity during the CSV import process.

```sql
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
```

## 2. Data Cleaning
Real-world data is rarely perfect. During the import process, specific strategies were implemented to handle missing and malformed data:

- **Null Value Handling (Demographics):** Missing values in the `age` column were substituted with `-1` to maintain the `INT` data type constraint while distinctly flagging the data as missing for future average calculations.

- **Null Value Handling (Financials):** Rows with completely missing financial metrics (`quantity`, `price_per_unit`, `cogs`, `total_sale`) were identified as "ghost transactions" and were deleted to prevent skewed revenue averages.

- **Formatting:** Standardized Excel date formats to strict `YYYY-MM-DD` and time formats to 24-hour `HH:MM:SS` prior to database ingestion.

## 3. Exploratory Data Analysis

```sql
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
```

## 4. SQL Queries

The following MySQL queries were developed to answer core business questions:

```sql
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
```
