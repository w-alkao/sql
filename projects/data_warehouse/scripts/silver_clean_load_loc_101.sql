/*
===============================================================================
Quality Checks & Load Locations Infos Data
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy, 
    and standardization across the bronze.erp_loc_a101 Table and performs the ETL (Extract, Transform, Load) process to 
    populate the silver.erp_loc_a101 schema tables from the 'bronze' schema.
	It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

	- Truncates Silver.erp_loc_a101 tables.
	- Inserts transformed and cleansed data from Bronze.erp_loc_a101 into Silver.erp_loc_a101 tables.
===============================================================================
*/

SELECT * FROM bronze.erp_loc_a101

SELECT * FROM silver.crm_cust_info

-- replace - in the cid to match customer info

SELECT cid, REPLACE(cid, '-', '') as new_cid
FROM bronze.erp_loc_a101

-- different value of country

SELECT
	DISTINCT cntry,
	CASE
		WHEN TRIM(cntry) = 'DE' THEN 'Germany'
		WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
		WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
		ELSE TRIM(cntry)
	END AS cntry
FROM bronze.erp_loc_a101


-- Insert new clean data into silver erp loc 101

INSERT INTO silver.erp_loc_a101 (cid, cntry)
SELECT
	REPLACE(cid, '-', '') as cid,
	CASE
		WHEN TRIM(cntry) = 'DE' THEN 'Germany'
		WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
		WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
		ELSE TRIM(cntry)
	END AS cntry
FROM bronze.erp_loc_a101