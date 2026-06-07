/*
===============================================================================
Quality Checks & Create Fact Sales Views
===============================================================================
Script Purpose:
    This script performs quality checks to validate the integrity, consistency, 
    and accuracy of fact sales and creates views in the Gold layer . 
    The Gold layer represents the final dimension and fact tables (Star Schema)
These checks ensure:
    - Uniqueness of surrogate keys in dimension tables.
    - Referential integrity between fact and dimension tables.
    - Validation of relationships in the data model for analytical purposes.

    This view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.
===============================================================================
*/



SELECT * FROM silver.crm_sales_details
SELECT * FROM gold.dim_customers
SELECT * FROM gold.dim_products
SELECT * FROM silver.crm_prd_info

CREATE VIEW gold.fact_sales AS
SELECT
	sd.sls_ord_num AS order_number,
	pr.product_key,
	cu.customer_key,
	sd.sls_order_dt AS order_date,
	sd.sls_ship_dt AS shipping_date,
	sd.sls_due_dt AS due_date,
	sd.sls_sales AS amount,
	sd.sls_quantity AS quantity,
	sd.sls_price AS price
FROM
	silver.crm_sales_details sd
	LEFT JOIN gold.dim_products pr ON sd.sls_prd_key = pr.product_number
	LEFT JOIN gold.dim_customers cu ON sd.sls_cust_id = cu.customer_id

SELECT * FROM gold.fact_sales;