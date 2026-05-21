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

GRANT pg_read_server_files TO postgres;

