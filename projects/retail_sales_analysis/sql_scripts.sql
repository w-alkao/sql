-- SQL Retail Sales Analysis

-- Create database
CREATE DATABASE sql_projects;

-- Create Table
DROP TABLE IF EXISTS retails_sales;

CREATE TABLE retail_sales(
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(15),
	quantity INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);


--Load data into retails sales tables
COPY retail_sales
FROM 'C:\Users\walka\MyGit\sql\projects\retail_sales_analysis\data.csv'
WITH (FORMAT csv, HEADER);


-- Data Cleaning

-- Check for null values
SELECT * FROM retail_sales
WHERE
	transactions_id IS NULL OR sale_date IS NULL OR sale_time IS NULL OR gender IS NULL OR category IS NULL OR quantity IS NULL OR cogs IS NULL OR total_sale IS NULL;



-- Data Exploration

-- How many sales we have ?
SELECT COUNT(*) AS total_sales FROM retail_sales;

-- How many category do we have ?
SELECT DISTINCT category FROM retail_sales;


-- DATA ANALYSIS & BUSINESS KEY PROBLEMS & ANSWERS

-- My Analysis & Findings
-- Q.1 Retrieve all columns for sales made on '2022-11-05'
-- Q.2 Retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov 2022
-- Q.3 Calculate the total sales for each category
-- Q.4 Find the average age of customers who purchased items from the 'Beauty' category
-- Q.5 Find all transactions where the total sale is greater than 1000
-- Q.6 Fin the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Calculate the average sale for each month. Find out best selling month in each year.
-- Q.8 Find the top 5 customers based on the highest total sales
-- Q.9 Find the number of unique customers who purchased items from each category.
-- Q.10 Creae each shift and number of orders (ex: Morning <= 12, Afternoon Between 12 & 17, Evening > 17)
;


-- QUERIES

-- Q.1 Retrieve all columns for sales made on '2022-11-05'

SELECT
	transactions_id, sale_date, gender, category, total_sale
FROM retail_sales
WHERE sale_date > '2022-11-05'
ORDER BY sale_date;


-- Q.2 Retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov 2022

SELECT
	transactions_id, sale_date, category, quantity
FROM retail_sales
WHERE
	category = 'Clothing' AND quantity >=3 AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
ORDER BY transactions_id;


-- Q.3 Calculate the total sales for each category

SELECT
	category,
	COUNT(*) As net_sale,
	SUM(total_sale) AS total_orders
FROM retail_sales
GROUP BY category
ORDER BY net_sale DESC;


-- Q.4 Find the average age of customers who purchased items from the 'Beauty' category

SELECT
	ROUND(AVG(age), 0) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';


-- Q.5 Find all transactions where the total sale is greater than 1000

SELECT
	transactions_id, gender, category, total_sale
FROM retail_sales
WHERE total_sale > 1000
ORDER BY total_sale DESC;


-- Q.6 Fin the total number of transactions (transaction_id) made by each gender in each category.

SELECT
	gender, category, COUNT(*) AS total_trans
FROM retail_sales
GROUP BY gender, category
ORDER BY gender, total_trans DESC;


-- Q.7 Calculate the average sale for each month. Find out best selling month in each year.

SELECT
	year, month, rank
FROM (
	SELECT
		EXTRACT(YEAR FROM sale_date) as year,
		EXTRACT(MONTH FROM sale_date) as month,
		COUNT(*) AS count_sale,
		ROUND(AVG(total_sale)) AS avg_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY ROUND(AVG(total_sale)) DESC) AS rank
	FROM retail_sales
	GROUP BY year, month
	ORDER BY year, avg_sale DESC
)
WHERE rank = 1;


-- Q.8 Find the top 5 customers based on the highest total sales

SELECT
	customer_id,
	SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;


-- Q.9 Find the number of unique customers who purchased items from each category.

SELECT
	category,
	COUNT( DISTINCT customer_id) as nb_uniq_customer
FROM retail_sales
GROUP BY category;


-- Q.10 Creae each shift and number of orders (ex: Morning <= 12, Afternoon Between 12 & 17, Evening > 17)

WITH hourly_sale AS (
	SELECT
		transactions_id, sale_time,
		CASE
			WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
			WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
		END as shift
	FROM retail_sales
	ORDER BY transactions_id
)
SELECT
	shift,
	COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift
ORDER BY total_orders DESC;



-- End of Project
