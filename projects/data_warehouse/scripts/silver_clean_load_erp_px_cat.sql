/*
===============================================================================
Quality Checks & Load Product Category Infos Data
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy, 
    and standardization across the bronze.erp_px_cat_g1v2 Table and performs the ETL (Extract, Transform, Load) process to 
    populate the silver.erp_px_cat_g1v2 schema tables from the 'bronze' schema.
	It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

	- Truncates Silver.erp_px_cat_g1v2 tables.
	- Inserts transformed and cleansed data from Bronze.erp_px_cat_g1v2 into Silver.erp_px_cat_g1v2 tables.
===============================================================================
*/

SELECT * FROM bronze.erp_px_cat_g1v2
SELECT * FROM silver.crm_prd_info

-- check if id is the same in crm product info

SELECT id
FROM bronze.erp_px_cat_g1v2
WHERE id NOT IN (SELECT DISTINCT cat_id FROM silver.crm_prd_info)

-- check for unwanted spaces

SELECT cat, subcat, maintenance
FROM bronze.erp_px_cat_g1v2
WHERE TRIM(cat) != cat OR subcat != TRIM(subcat) or maintenance != TRIM(maintenance)

-- check for different value for cat, subcat, maintenance

SELECT DISTINCT cat
FROM bronze.erp_px_cat_g1v2

SELECT DISTINCT subcat
FROM bronze.erp_px_cat_g1v2

SELECT DISTINCT maintenance
FROM bronze.erp_px_cat_g1v2





-- Load clean data into silver erp px cat g1v2
-- Truncating the table before loading data

TRUNCATE TABLE silver.erp_px_cat_g1v2
INSERT INTO silver.erp_px_cat_g1v2 (id, cat, subcat, maintenance)
SELECT
	id,
	cat,
	subcat,
	maintenance
FROM bronze.erp_px_cat_g1v2

SELECT * FROM silver.erp_px_cat_g1v2