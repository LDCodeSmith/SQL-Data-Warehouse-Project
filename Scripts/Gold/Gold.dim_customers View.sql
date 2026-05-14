CREATE VIEW gold.dim_customers AS 
SELECT 
ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
ci.cst_id AS Customer_id,
ci.cst_key AS Customer_number,
ci.cst_firstname AS First_Name,
ci.cst_lastname AS Last_Name,
la.cntry AS country,
ci.cst_marital_status AS Marital_Status,
CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM is the Master for gender Info
	 ELSE COALESCE(ca.gen, 'n/a')
END AS new_gen,
ca.bdate AS birthdate, 
ci.cst_create_date AS create_date
FROM silver.crm_cust_info ci
LEFT JOIN Silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN Silver.erp_loc_a101 la
ON ci.cst_key = la.cid
