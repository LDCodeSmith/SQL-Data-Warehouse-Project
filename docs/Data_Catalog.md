# Overview

#### The Gold Layer is the business-level data representation, structured to support analytical and reporting use cases. It consists of dimension tables and fact tables for specfific business metrics.

---

# 1. Gold.dim_customers

- **Purpose:** Stores customers details enriched with demographic and geographic data.
- **Columns:**
  
| Column Name | Data Type | Description |
|---|---|---|
| customer_key | INT | Surrogate Key uniquely identifying each customer recored in the dimension table. |
| Customer_id | INT | Unique numerical identifier assigned to each customer. |
