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
