--CHECKING FOR BAD DATA SO IT IS UNDERSTOOD WHAT TRANSFORMATIONS MUST BE DONE

USE DataWarehouse

/* check For Nulls or Duplicates in Primary Key 
Expectation: No Result */

SELECT 
cst_id,
COUNT(*)
FROM Silver.crm_cust_info
GROUP BY cst_id 
HAVING COUNT(*) > 1 OR cst_id IS NULL

--Check for Unwanted Spaces
--Expectation: No Results

SELECT 
cst_firstname
FROM Silver.crm_cust_info
WHERE cst_key != TRIM(cst_key)

--Data Standardization & Consistency 
SELECT DISTINCT 
prd_line
FROM Bronze.crm_prd_info

--Check for invalid Date Orders
SELECT 
*
FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt

--Check Data Consistency: Between Sales, Quantity, and Price
-- >> Sales = Quantity * Price
-- >> Values must not be NULL, zero, or negative.
SELECT DISTINCT 
sls_Sales,
sls_quantity,
sls_price,
CASE WHEN sls_sales IS NULL OR sls_sales <=0 OR sls_sales != sls_quantity * ABS(sls_price)
	THEN sls_quantity * ABS(sls_price) 
	ELSE sls_sales
END AS sls_sales,
CASE WHEN sls_price IS NULL OR sls_price <=0
	THEN sls_sales / NULLIF(sls_quantity, 0)
	ELSE sls_price
END AS sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL 
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <=0

--Checking SIlver.crm_sales_details

SELECT DISTINCT
sls_sales,
sls_quantity,
sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL 
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <=0
ORDER BY sls_sales, sls_quantity, sls_price

--Identify Out-of-Range Dates
SELECT DISTINCT 
bdate
FROM Silver.erp_CUST_AZ12
WHERE bdate < '1924-01-01' OR bdate > GETDATE() 

--Identify Data Standardization & Consistency Problems
SELECT DISTINCT gen
FROM bronze.erp_cust_az12

--Fixing Data Standardization & Consistency Weirdness
SELECT DISTINCT 
gen,
CASE WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
	WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
	ELSE 'n/a'

FROM bronze.erp_cust_az12

--SELECT silver.erp_cust_az12
SELECT 
*
FROM silver.erp_cust_az12
