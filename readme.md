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

## Example Queries

### Q1. Retrieve all columns for sales made on `2022-11-05`
```sql
SELECT *
FROM retail_sales
WHERE sale_date = DATE '2022-11-05';
