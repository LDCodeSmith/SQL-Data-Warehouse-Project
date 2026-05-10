--Creating Silver.erp_px_cat_g1v2 Table NO TRANSFORMATION NEEDED

INSERT INTO Silver.erp_px_cat_g1v2 (
	id,
	cat,
	subcat,
	maintenance
)

SELECT 
id,
cat,
subcat,
maintenance
FROM bronze.erp_px_cat_g1v2

--Check For Unwanted Spaces
SELECT 
*
FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR Maintenance != TRIM(maintenance)

--Data Standardization & Consistency 
SELECT DISTINCT 
maintenance
FROM bronze.erp_px_cat_g1v2

SELECT 
* 
FROM Silver.erp_px_cat_g1v2
