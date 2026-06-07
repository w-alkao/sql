/*
===============================================================================
Quality Checks & Load Customers AZ12 Infos Data
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy, 
    and standardization across the bronze.erp_cust_az12 Table and performs the ETL (Extract, Transform, Load) process to 
    populate the silver.erp_cust_az12 schema tables from the 'bronze' schema.
	It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

	- Truncates Silver.erp_cust_az12 tables.
	- Inserts transformed and cleansed data from Bronze.erp_cust_az12 into Silver.erp_cust_az12 tables.
===============================================================================
*/



SELECT * FROM bronze.erp_cust_az12

SELECT * FROM silver.crm_cust_info

-- removing NAS before cid to match with silver crm customer info

SELECT
	cid,
	CASE
		WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
		ELSE cid
	END AS cid_new
FROM bronze.erp_cust_az12

-- Identity out of range date

SELECT bdate
FROM bronze.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE()

-- chech for gender possible value

SELECT DISTINCT gen
FROM bronze.erp_cust_az12

SELECT
	DISTINCT gen,
	CASE 
		WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
		WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
		ELSE 'n/a'
	END as gen_new
FROM bronze.erp_cust_az12


-- inserting new clean data into silver erp customer az12

TRUNCATE TABLE silver.erp_cust_az12;

INSERT INTO silver.erp_cust_az12 (
	cid, bdate, gen
)
SELECT
	CASE
		WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
		ELSE cid
	END AS cid,
	CASE
		WHEN bdate > GETDATE() THEN NULL
		ELSE bdate
	END AS bdate,
	CASE 
		WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
		WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
		ELSE 'n/a'
	END as gen_new
FROM bronze.erp_cust_az12