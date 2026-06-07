SELECT * FROM silver.crm_prd_info
SELECT * FROM silver.erp_px_cat_g1v2

-- Fisrt try to join two product table

SELECT 
	pi.prd_id,
	pi.cat_id,
	pi.prd_key,
	pi.prd_name,
	pi.prd_cost,
	pi.prd_line,
	pi.prd_start_dt,
	pi.prd_end_dt,
	pcg.cat,
	pcg.subcat,
	pcg.maintenance
FROM
	silver.crm_prd_info pi
	LEFT JOIN silver.erp_px_cat_g1v2 pcg ON pi.cat_id = pcg.id
WHERE
	pi.prd_end_dt IS NOT NULL

-- check for duplicated key

SELECT prd_key
FROM (
	SELECT 
		pi.prd_id,
		pi.cat_id,
		pi.prd_key,
		pi.prd_name,
		pi.prd_line,
		pi.prd_start_dt,
		pcg.cat,
		pcg.subcat,
		pcg.maintenance
	FROM
		silver.crm_prd_info pi
		LEFT JOIN silver.erp_px_cat_g1v2 pcg ON pi.cat_id = pcg.id
	WHERE pi.prd_end_dt IS NULL
)t
GROUP BY prd_key
HAVING COUNT(*) > 1

-- final join 
DROP VIEW gold.dim_products;
CREATE VIEW gold.dim_products AS
	SELECT
		ROW_NUMBER() OVER(ORDER BY pi.prd_start_dt, pi.prd_key) AS product_key,
		pi.prd_id AS product_id,
		pi.prd_key AS product_number,
		pi.prd_name AS product_name,
		pi.cat_id AS category_id,
		pcg.cat AS category,
		pcg.subcat AS subcategory,
		pcg.maintenance,
		pi.prd_cost AS cost,
		pi.prd_line,
		pi.prd_start_dt AS started_date,
		pi.prd_end_dt AS end_date
	FROM
		silver.crm_prd_info pi
		LEFT JOIN silver.erp_px_cat_g1v2 pcg ON pi.cat_id = pcg.id

SELECT * FROM gold.dim_products