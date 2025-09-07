---SQL Retail Sales Analysis --- p1
Create database sql_project_p2

---Create table 
DROP TABLE IF EXISTS retail_sales;

CREATE TABLE retail_sales(
transactions_id	int,
sale_date date,	
sale_time time,
customer_id	int,
gender	varchar(15),
age int,	
category varchar(15),	
quantiy	int,
price_per_unit	float,
cogs float,	
total_sale float
);

select * from retail_sales
limit 10;


----修改字段名
ALTER TABLE retail_sales
RENAME COLUMN quantiy TO quantity;


---count用法
select count(*) from retail_sales;
----统计非空数值
select count(category) from retail_sales;
----统计有多少不同的值,去除重复
SELECT COUNT(DISTINCT customer_id)
FROM retail_sales;

----检查表中是否存在空值：只要某一列为 NULL，该行就会被选出
---check if there are NULL values in the table, if any column is Null, the row will be selected
SELECT * FROM retail_sales
WHERE 
    transactions_id IS NULL
    OR 
	sale_date IS NULL
    OR 
	sale_time IS NULL
    OR 
	gender IS NULL
    OR 
	category IS NULL
    OR 
	quantity IS NULL
    OR 
	cogs IS NULL;


----data cleaning
delete from retail_sales
where
    transactions_id IS NULL
    OR 
	sale_date IS NULL
    OR 
	sale_time IS NULL
    OR 
	gender IS NULL
    OR 
	category IS NULL
    OR 
	quantity IS NULL
    OR 
	cogs IS NULL;

--data exploration 
-- how many sales do we have ?  一共有多少笔销售记录？
select count(*) as total_sale from retail_sales;

--how many unique customers do we have?
select count(distinct customer_id) as total_cus from retail_sales;


--Q.1 write a SQL query to retrieve all columns for sales made on "2022-11-05"
select * from retail_sales
where sale_date = '2022-11-05';

--Q.2 write a SQL query to retrieve all transactions where the category is 'clothing' and the quantity sold is more than 10
--in the month of Nov-2022
select * from retail_sales
where 
	category = 'Clothing'
	And 
	To_char(sale_date,'YYYY-MM') = '2022-11'
	And
	quantity >= 4

--Q.3 write a SQL query to calculate the total sales(total_sale) for each category
--统计每个类别的总销售总额 total_sales
--统计每个类别的总订单数量 total_orders 
select category,
	sum(total_sale) AS total_sales,
	count(*) AS total_orders
from retail_sales
group by category;


--Q.4 write a SQL query to find the average age of customers who purchased items from the 'Beauty' category 
select * 
from retail_sales
where category ='Beauty'


select Avg(age) from retail_sales
where category ='Beauty';

-- final sql query, 保持两位小数
select Round(Avg(age),2) from retail_sales
where category ='Beauty';


--Q.5 write a SQL query to find all the transaction where the total_sale is greater than 1000
select * from retail_sales
where total_sale >= '1000'

--Q.6 write a SQL query to find a total number of transctions(transaction_id) made by each gender in each category
select category,
	   gender,
	   count(transactions_id) as total_transactions
from retail_sales
group by category, gender
order by 1


--Q.7 write a SQL query to calculate the average sale for each month, find out the best selling month in each year 
--计算每个月的平均销售额，并找出每一年中销售额最高的月份。
select 
	extract (year from sale_date) As year,
	extract (month from sale_date) As month,
	Avg(total_sale) as avg_sales
from retail_sales
group by 1,2
order by 1,2


"""
select sale_date from retail_sales;

SELECT TO_CHAR(sale_date, 'YYYY-MM') AS year_month
FROM retail_sales;


SELECT
  category,
  total_sale,
  AVG(total_sale) OVER (PARTITION BY category) AS avg_in_category
FROM retail_sales;
"""

--要找出 每一年平均销售额最高的月份，我们需要用 窗口函数 RANK() 或 ROW_NUMBER() 来给月份排名，然后筛选出第一名。
select year,month, avg_sales
from (
	SELECT 
	    EXTRACT(YEAR  FROM sale_date) AS year,
	    EXTRACT(MONTH FROM sale_date) AS month,
	    AVG(total_sale) AS avg_sales,
	    RANK() OVER (
	        PARTITION BY EXTRACT(YEAR FROM sale_date) --把数据按照“年份”划分，比如 2022 年一组，2023 年一组。
	        ORDER BY AVG(total_sale) DESC --在每个年份组内，先算出每个月的平均销售额，再按从高到低排序。
	    ) AS rnk
	FROM retail_sales
	GROUP BY 1,2
)t
where rnk=1
ORDER BY year, month;


"""
rank 函数的用法

RANK() OVER (
    PARTITION BY <分组列> 
    ORDER BY <排序列> [ASC|DESC]
)
RANK()：给结果集里的每一行分配一个排名，从 1 开始。
PARTITION BY：可选参数，表示在分组内单独排名（不写就是全表一起排）。
ORDER BY：必须的，表示按照哪个字段排序来决定名次。
"""



--Q.8 Write a SQL query to find the top 5 customers based the highest total sales
--需要统计每个顾客的总销售额，然后按照总销售额从高到低排序，最后取前 5 名
--数据表里一共有 1997 条交易记录 (transactions)，但是并不等于有 1997 个不同的顾客
--一个顾客可能会多次购买 → 所以在表里会出现多次相同的 customer_id

-- 统计不同顾客的数量
select 
    count(customer_id) as total_rows,              -- 全部购买记录1997条
    count(distinct customer_id) as unique_customers  -- 不同顾客数量155
from retail_sales;


select customer_id, 
	   SUM(total_sale) AS total_sales
from retail_sales
group by customer_id
order by total_sales desc;


--method 1
select customer_id, 
	   SUM(total_sale) AS total_sales
from retail_sales
group by customer_id
order by total_sales desc
limit 5;


-- method 2
select * 
from(
	select customer_id, 
		   sum(total_sale) as total_sales,
		   rank() over(order by sum(total_sale) desc) as rnk
	from retail_sales
	group by customer_id
)t
where rnk <= 5;

--Q.9 Write a SQL query to find the number of unique customers who purchased items for each category 
select count(distinct customer_id) as unique_customers,
       category
from retail_sales
group by category;

--Q.10 Write a SQL query to create each shift number of orders
--(example morning <= 12, afternood between 12 & 17, evening > 17)

-- CASE WHEN = 条件判断语法 

"""
select student_id,          -- 选择学生ID
       score,               -- 选择分数
       case                 -- 开始条件判断
           when score >= 90 then 'A'   -- 如果分数 >= 90，返回 'A'
           when score >= 75 then 'B'   -- 如果分数 >= 75，返回 'B'
           when score >= 60 then 'C'   -- 如果分数 >= 60，返回 'C'
           else 'F'                    -- 其他情况返回 'F'
       end as grade         -- 给这个结果列起名字叫 "grade"
from exam_results;          -- 数据来自 exam_results 表
"""


--Q.10 Write a SQL query to create each shift number of orders
--(example morning <= 12, afternood between 12 & 17, evening > 17)
select * from retail_sales;

"""
CTE = 临时表 + 起名
好处：让复杂 SQL 更清晰、可维护

WITH 临时表名 AS (
    子查询语句
)
SELECT ...
FROM 临时表名;


WITH customer_totals AS (                    -- ① 定义一个 CTE 临时表 customer_totals
    SELECT customer_id, 
           SUM(total_sale) AS total_sales    -- ② 按顾客汇总消费金额
    FROM retail_sales
    GROUP BY customer_id                     -- ③ 每个顾客分组，计算总消费
)
SELECT *                                     -- ④ 从临时表 customer_totals 取数据
FROM customer_totals
ORDER BY total_sales DESC                    -- ⑤ 按消费金额从大到小排序
LIMIT 1;                                     -- ⑥ 只取前 1 条（最大值）



"""

--method 1
select 
	case
		when extract(hour from sale_time) <12 then 'morning'
		when extract(hour from sale_time) between 12 and 17 then 'afternoon'
		else 'evening'
	end as shift,
	count(*) AS total_orders
from retail_sales
GROUP BY shift
ORDER BY total_orders DESC;

-- method 2 cte写法
with hourly_sales as (
		select *,
			case
				when extract(hour from sale_time) < 12 then 'Morning'
				when extract(hour from sale_time) between 12 and 17 then 'afternoon'
				else 'evening'
			end as shift
		from retail_sales
)
select shift,
	   count(*) as total_orders
from hourly_sales	   
group by shift
order by total_orders desc;

-- end of project 



