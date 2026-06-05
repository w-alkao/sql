-- check for duplicated key

SELECT prd_id, COUNT(*) AS nb
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL


-- split categories

SELECT prd_id, prd_key, REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id
FROM bronze.crm_prd_info


-- categories not in table px cat g1v2

SELECT
	prd_id, prd_key, REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id
FROM bronze.crm_prd_info
WHERE REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') NOT IN (
	SELECT DISTINCT id FROM bronze.erp_px_cat_g1v2
);

-- product not in sales details table

SELECT prd_id, prd_key, SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key
FROM bronze.crm_prd_info
WHERE  SUBSTRING(prd_key, 7, LEN(prd_key)) NOT IN (
	SELECT DISTINCT sls_prd_key FROM bronze.crm_sales_details
)

-- check for unwanted space before and after name

SELECT prd_id, prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

-- check for null or negative number and replace it with 0

SELECT prd_cst
FROM bronze.crm_prd_info
WHERE prd_cst < 0 OR prd_cst IS NULL;

SELECT ISNULL(prd_cst, 0) AS prd_cst
FROM bronze.crm_prd_info
WHERE prd_cst IS NULL;

-- check for different catogorie of product line

SELECT DISTINCT prd_line,
	CASE
		WHEN prd_line = 'M' THEN 'Mountain'
		WHEN prd_line = 'R' THEN 'Road'
		WHEN prd_line = 'S' THEN 'Other Sales'
		WHEN prd_line = 'T' THEN 'Touring'
		ELSE 'n/a'
	END AS prd_lines
FROM bronze.crm_prd_info;

-- chech when start date is greater than end date

SELECT prd_key, COUNT(*) as nb
FROM bronze.crm_prd_info
GROUP BY prd_key
order by nb DESC












SELECT
	prd_id, 
	prd_key,
	REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
	SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
	prd_nm,
	ISNULL(prd_cst,0) AS prd_cst,
	CASE UPPER(TRIM(prd_line))
		WHEN 'R' THEN 'Road'
		WHEN 'S' THEN 'Other Sales'
		WHEN 'T' THEN 'Touring'
		WHEN 'M' THEN 'Mountain'
		ELSE 'n/a'
	END AS prd_lines,
	prd_start_dt,
	prd_end_dt
FROM bronze.crm_prd_info

