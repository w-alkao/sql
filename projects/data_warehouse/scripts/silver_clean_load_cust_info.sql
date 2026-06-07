/*
===============================================================================
Quality Checks & Load Customer Infos Data
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy, 
    and standardization across the bronze.crm_cust_info Table and performs the ETL (Extract, Transform, Load) process to 
    populate the silver.crm_cust_info schema tables from the 'bronze' schema.
	It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

	- Truncates Silver.crm_cust_info tables.
	- Inserts transformed and cleansed data from Bronze.crm_cust_info into Silver.crm_cust_info tables.
===============================================================================
*/

-- Check for Nulls or Duplicates in Primary Key

-- Check duplicates cst_id
SELECT cst_id, COUNT(*) AS nb
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id = NULL

-- View all duplicates cst_id
SELECT *, ROW_NUMBER () OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS row_n
FROM bronze.crm_cust_info
WHERE 
	cst_id IN (
		SELECT cst_id
		FROM bronze.crm_cust_info
		GROUP BY cst_id
		HAVING COUNT(*) > 1 
	) OR cst_id IS NULL
ORDER BY cst_id

-- Duplicates cst_id to remove
SELECT *
FROM (
	SELECT *, ROW_NUMBER () OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS row_n
	FROM bronze.crm_cust_info
)t
WHERE row_n != 1


SELECT *
FROM (
	SELECT *, ROW_NUMBER () OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS row_n
	FROM bronze.crm_cust_info
)t
WHERE row_n = 1


-- Check for unwanted spaces and after first and last name, material status, gender

SELECT cst_firstname, cst_lastname
FROM bronze.crm_cust_info
WHERE
	cst_firstname != TRIM(cst_firstname) OR cst_lastname != TRIM(cst_lastname)

SELECT cst_material_status, cst_gndr
FROM bronze.crm_cust_info
WHERE cst_material_status != TRIM(cst_material_status) OR cst_gndr != TRIM(cst_gndr);

-- check different value of gender and material status
SELECT DISTINCT cst_gndr
FROM bronze.crm_cust_info

SELECT DISTINCT cst_material_status
FROM bronze.crm_cust_info

-- provide full meaning of gender and material status

SELECT
	cst_id, cst_gndr,
	CASE
		WHEN cst_gndr = 'M' THEN 'Male'
		WHEN cst_gndr = 'F' THEN 'Female'
		ELSE 'n/a'
	END AS gender,
	cst_material_status,
	CASE
		WHEN cst_material_status = 'S' THEN 'Single'
		WHEN cst_material_status = 'M' THEN 'Maried'
		ELSE 'n/a'
	END AS material_status
FROM bronze.crm_cust_info

-- removing duplicated cst_id and removing unwanted space before and after first and last name

INSERT INTO silver.crm_cust_info (
	cst_id, cst_key, cst_firstname, cst_lastname, cst_material_status,cst_gndr, cst_create_date
)
SELECT
	cst_id, cst_key, TRIM(cst_firstname) AS cst_firstname,
	TRIM(cst_lastname) AS cst_lastname,
	CASE
		WHEN cst_material_status = 'S' THEN 'Single'
		WHEN cst_material_status = 'M' THEN 'Maried'
		ELSE 'n/a'
	END AS cst_material_status,
	CASE
		WHEN cst_gndr = 'M' THEN 'Male'
		WHEN cst_gndr = 'F' THEN 'Female'
		ELSE 'n/a'
	END AS cst_gndr,
	cst_create_date
FROM (
	SELECT *, ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
	FROM bronze.crm_cust_info
	WHERE cst_id IS NOT NULL
) t
WHERE flag_last = 1

SELECT * FROM silver.crm_cust_info
