--SQL Retail Sales Analysis
-- Create Table
CREATE TABLE sql_project_1(
transactions_id	INT PRIMARY KEY,
sale_date	DATE,
sale_time	TIME,
customer_id	INT,
gender	VARCHAR(15),
age	INT,
category VARCHAR(15),
quantity	INT,
price_per_unit	FLOAT,
cogs	FLOAT,
total_sale FLOAT
);
SELECTFROM sql_project_1;
SELECT
COUNT()
FROM sql_project_1;
-- Data Exploration & Cleaning
SELECT COUNT(*) FROM sql_project_1;
SELECT COUNT(DISTINCT customer_id) FROM sql_project_1;
SELECT DISTINCT category FROM sql_project_1;

SELECT * FROM sql_project_1
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM sql_project_1
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;


--Data Analysis & Findings

--Q.1 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
SELECT category,sum(quantity) FROM sql_project_1
WHERE category = 'Clothing'
AND TO_CHAR(sale_date,'YYYY-MM') = '2022-11'
GROUP BY 1

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 inthe month of Nov-2022
SELECT 
* 
FROM sql_project_1
WHERE 
category = 'Clothing'
AND
TO_CHAR(sale_date,'YYYY-MM') = '2022-11'
AND 
quantity>=4

--Q.3 Write a SQL query to calculate the total sales for each category 
SELECT category, SUM(total_sale) AS net_sale,
COUNT(*) AS total_orders
FROM sql_project_1
GROUP BY 1

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
SELECT ROUND(AVG(age),2) FROM sql_project_1
WHERE category = 'Beauty';

--Q.5 Write a SQL query to find all transactions where the total sale is greater than 1000
SELECT transactions_id FROM sql_project_1
WHERE total_sale>=1000;

-- Q.6 Write a SQL query to find the total number of transactions made by eac gender in each category
SELECT 
gender, category,
COUNT(*) AS total_transaction
FROM sql_project_1
GROUP BY gender, category
ORDER BY 1

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT
year,
month,
avg_sale
FROM
(
SELECT
EXTRACT (YEAR FROM sale_date) AS year,
EXTRACT(MONTH FROM sale_date) AS month,
AVG(total_sale) AS avg_sale,
RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG (total_sale)DESC)
FROM sql_project_1
GROUP BY 1,2
) AS t1
WHERE rank =1

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sale 
SELECT
customer_id, 
SUM(total_sale) AS total_sales
FROM sql_project_1
GROUP BY 1 
ORDER BY 1,2 ASC
LIMIT 5

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category
SELECT 
COUNT( DISTINCT(customer_id)) AS unique_customer,
category
FROM sql_project_1
GROUP BY 2

--Q.10 Write a SQL query to create each shift and number of orders (Example Morning <= 12, Afternoon between 12 & 17, Evening >17)

WITH hourly_sales
AS
(
SELECT *,
CASE 
WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
ELSE 'Evening'
END as shift
FROM sql_project_1
)
SELECT
shift,
COUNT(*) AS total_orders
FROM hourly_sales
GROUP BY shift