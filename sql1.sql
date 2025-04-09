CREATE DATABASE sql_p1;
USE sql_p1;

-- Create Table --
DROP TABLE IF EXISTS sales;
CREATE TABLE sales(
		transactions_id INT PRIMARY KEY,
		sale_date DATE,	
		sale_time TIME,
		customer_id INT,	
		gender	VARCHAR(15),
		age	INT,
		category VARCHAR(15),	
		quantiy INT,	
		price_per_unit FLOAT,	
		cogs FLOAT,
		total_sale FLOAT
        );
        
SELECT * FROM sales;

-- Data Cleaning
SELECT * FROM sales
WHERE transactions_id IS NULL;

SELECT * FROM sales
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
    quantiy IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- Data Exploration

-- How many sales we have?

SELECT COUNT(*) 
FROM sales;

-- How many uniuque customers we have ?
SELECT COUNT(DISTINCT(customer_id)) FROM sales;

-- Data Analysis & Business Key Problems & Answers
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT * FROM sales 
WHERE sale_date = '2022-11-05';


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
SELECT 
  *
FROM sales
WHERE 
  category = 'Clothing'
  AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
  AND quantiy >= 4;
  
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
	category, 
	SUM(total_sale) AS 'total sales',
	count(*) AS total_orders
FROM sales
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT 
	ROUND(AVG(age),2) AS beauty_avg_age
FROM sales
WHERE category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT 
	* FROM sales
    WHERE total_sale > 1000
    ORDER BY total_sale DESC;
    
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
	 category,gender, COUNT(*) AS 'total transactions'
    FROM sales
    GROUP BY category, gender;
    
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
WITH monthly_sales AS (
  SELECT 
    YEAR(sale_date) AS yr,
    MONTH(sale_date) AS mth,
    ROUND(AVG(total_sale), 2) AS avg_sale,
    RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS rnk
  FROM sales
  GROUP BY YEAR(sale_date), MONTH(sale_date)
)
SELECT *
FROM monthly_sales
WHERE rnk = 1;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT customer_id,SUM(total_sale)
FROM sales
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT category,count(DISTINCT(customer_id)) AS unique_customers
FROM sales
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH shifts AS (
  SELECT 
    CASE 
      WHEN HOUR(sale_time) < 12 THEN 'Morning'
      WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
      ELSE 'Evening'
    END AS shift,
    COUNT(*) AS `num of orders`
  FROM sales
  GROUP BY shift
)
SELECT * FROM shifts;
