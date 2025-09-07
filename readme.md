# 🛒 Retail Sales Analysis SQL Project

## Project Overview
**Project Title:** Retail Sales Analysis  
**Level:** Beginner  
**Database:** `sql_project_p2`  

This project demonstrates SQL skills typically used by data analysts to **explore, clean, and analyze retail sales data**.  
It covers database setup, data cleaning, exploratory analysis (EDA), and business-style queries.  
Perfect for beginners who want to build a solid SQL foundation.

---

## Objectives
1. **Set up a retail sales database** – create and populate tables.  
2. **Data Cleaning** – handle null values, fix column names.  
3. **Exploratory Data Analysis** – run descriptive queries (counts, distinct, group by).  
4. **Business Analysis** – answer specific business questions via SQL queries.  
5. **Advanced SQL** – practice with **window functions**, **CTEs**, and **CASE WHEN**.

---

## Business Questions & SQL Solutions

### Q1. Retrieve all columns for sales made on `2022-11-05`
```sql
SELECT *
FROM retail_sales
WHERE sale_date = DATE '2022-11-05';
```

### Q2. Retrieve all transactions where the category is **Clothing** and the quantity sold is more than 10 in **Nov-2022**
```sql
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND quantity > 10
  AND EXTRACT(YEAR FROM sale_date) = 2022
  AND EXTRACT(MONTH FROM sale_date) = 11;
```

### Q3. Calculate the total sales (`total_sale`) and total orders for each category
```sql
SELECT
  category,
  SUM(total_sale) AS total_sales,
  COUNT(*)        AS total_orders
FROM retail_sales
GROUP BY category
ORDER BY total_sales DESC;
```

### Q4. Find the average age of customers who purchased items from the **Beauty** category
```sql
SELECT ROUND(AVG(age), 2) AS average_age
FROM retail_sales
WHERE category = 'Beauty';
```

### Q5. Find all transactions where the `total_sale` is greater than 1000
```sql
SELECT *
FROM retail_sales
WHERE total_sale > 1000;
```

### Q6. Find the total number of transactions (`transaction_id`) made by each gender in each category
```sql
SELECT
  category,
  gender,
  COUNT(transactions_id) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY category, gender;
```

### Q7. Calculate the average sale for each month, and find out the best-selling month in each year
```sql
-- monthly averages
WITH monthly AS (
  SELECT
    EXTRACT(YEAR  FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
    AVG(total_sale)               AS avg_sales
  FROM retail_sales
  GROUP BY 1,2
)
-- best month per year
SELECT year, month, avg_sales
FROM (
  SELECT
    year, month, avg_sales,
    RANK() OVER (PARTITION BY year ORDER BY avg_sales DESC) AS rnk
  FROM monthly
) t
WHERE rnk = 1
ORDER BY year, month;
```

### Q8. Find the top 5 customers based on the highest total sales
```sql
SELECT *
FROM (
  SELECT
    customer_id,
    SUM(total_sale) AS total_sales,
    RANK() OVER (ORDER BY SUM(total_sale) DESC) AS rnk
  FROM retail_sales
  GROUP BY customer_id
) t
WHERE rnk <= 5
ORDER BY total_sales DESC, customer_id;
```

### Q9. Find the number of unique customers who purchased items for each category
```sql
SELECT
  category,
  COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category
ORDER BY unique_customers DESC;
```

### Q10. Create each shift number of orders (Morning <=12, Afternoon 12–17, Evening >17)
```sql
WITH hourly_sales AS (
  SELECT
    *,
    CASE
      WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
      WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
      ELSE 'Evening'
    END AS shift
  FROM retail_sales
)
SELECT
  shift,
  COUNT(*) AS total_orders
FROM hourly_sales
GROUP BY shift
ORDER BY total_orders DESC;
```

---

## Findings
- **Customer Demographics** → Customers span multiple age groups, with sales concentrated in **Clothing** and **Beauty**.  
- **High-Value Transactions** → Several orders exceeded `1000` in total sales, indicating premium purchases.  
- **Seasonal Trends** → November showed strong sales, with clear **best months per year**.  
- **Top Customers** → A few customers contributed disproportionately to revenue.  
- **Sales Shifts** → Most transactions occurred during **Afternoon** hours.

---

## Run the Project (PostgreSQL)
```bash
createdb sql_project_p2
psql -d sql_project_p2 -f project1_retail_sales.sql
```

---

## License
MIT License – Free to use and adapt.
