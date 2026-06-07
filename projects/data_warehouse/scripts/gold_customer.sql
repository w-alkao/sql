SELECT * FROM silver.crm_cust_info;
SELECT * FROM silver.erp_cust_az12;
SELECT * FROM silver.erp_loc_a101;

INSERT INTO silver.crm_cust_info (cst_id, cst_key, cst_firstname, cst_lastname, cst_material_status, cst_gndr, cst_create_date)
VALUES (30000, 'ZA00030000', 'Adamou', 'Walkao', 'Single', 'Male', '2026-01-06')

DELETE FROM silver.crm_cust_info WHERE cst_id = 30000;

-- first trying to Join all customer talbe

SELECT
	ci.cst_id,
	ci.cst_key,
	ci.cst_firstname,
	ci.cst_lastname,
	ci.cst_material_status,
	ci.cst_gndr,
	ci.cst_create_date,
	ca.bdate,
	ca.gen,
	la.cntry
FROM
	silver.crm_cust_info ci
	LEFT JOIN silver.erp_cust_az12 ca ON ca.cid = ci.cst_key
	LEFT JOIN silver.erp_loc_a101 la ON ci.cst_key = la.cid


-- check for duplicated key in joined table

SELECT cst_id
FROM (
	SELECT
		ci.cst_id,
		ci.cst_key,
		ci.cst_firstname,
		ci.cst_lastname,
		ci.cst_material_status,
		ci.cst_gndr,
		ci.cst_create_date,
		ca.bdate,
		ca.gen,
		la.cntry
	FROM
		silver.crm_cust_info ci
		LEFT JOIN silver.erp_cust_az12 ca ON ci.cst_key = ca.cid
		LEFT JOIN silver.erp_loc_a101 la ON ci.cst_key = la.cid
)t 
GROUP BY cst_id
HAVING COUNT(*) > 1

-- check inconsistency betwenn two gender column 

SELECT DISTINCT
	ci.cst_gndr, ca.gen
FROM
	silver.crm_cust_info ci
	LEFT JOIN silver.erp_cust_az12 ca ON ci.cst_key = ca.cid
ORDER BY 1, 2

-- show rows with inconsistency between gender in customer info and customer az12 talbe

SELECT
	ci.cst_id,
	ci.cst_key,
	ci.cst_firstname,
	ci.cst_lastname,
	ci.cst_material_status,
	ci.cst_gndr, ca.gen
FROM
	silver.crm_cust_info ci
	LEFT JOIN silver.erp_cust_az12 ca ON ci.cst_key = ca.cid
WHERE
	ci.cst_gndr != ca.gen
ORDER BY 6, 7



SELECT 
	ci.cst_gndr, ca.gen, COUNT(*) As nb1
FROM
	silver.crm_cust_info ci
	LEFT JOIN silver.erp_cust_az12 ca ON ci.cst_key = ca.cid
WHERE ci.cst_gndr != ca.gen
GROUP BY cst_gndr, gen
ORDER BY 1, 2

-- integrate data between cst_gndr and gen column

SELECT DISTINCT
	ci.cst_gndr, ca.gen,
	CASE
		WHEN cst_gndr != 'n/a' THEN cst_gndr
		ELSE COALESCE(ca.gen, 'n/a')
	END
FROM
	silver.crm_cust_info ci
	LEFT JOIN silver.erp_cust_az12 ca ON ci.cst_key = ca.cid
ORDER BY 1, 2


-- Final joining into view


CREATE VIEW gold.dim_customers AS
	SELECT
		ROW_NUMBER() OVER(ORDER BY ci.cst_id) AS customer_key,
		ci.cst_id AS customer_id,
		ci.cst_key AS customer_number,
		ci.cst_firstname AS first_name,
		ci.cst_lastname AS last_name,
		CASE
			WHEN cst_gndr != 'n/a' THEN cst_gndr
			ELSE COALESCE(ca.gen, 'n/a')
		END AS gender,
		ci.cst_material_status AS marital_status,
		la.cntry AS country,
		ca.bdate AS birthdate,
		ci.cst_create_date AS created_date
	FROM
		silver.crm_cust_info ci
		LEFT JOIN silver.erp_cust_az12 ca ON ca.cid = ci.cst_key
		LEFT JOIN silver.erp_loc_a101 la ON ci.cst_key = la.cid

SELECT * FROM gold.dim_customers;