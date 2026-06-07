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

TRUNCATE TABLE silver.erp_cust_az12
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