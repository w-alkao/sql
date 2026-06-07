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