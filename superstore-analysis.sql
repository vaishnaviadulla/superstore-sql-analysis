CREATE DATABASE superstore_project;
USE superstore_project;

select * from superstore;

select count(*) from superstore;

-- Overall Analysis --

SELECT SUM(Sales) AS total_sales FROM superstore;
SELECT MAX(Sales) AS max_sales FROM superstore;
SELECT MIN(Sales) AS min_sales FROM superstore;
SELECT AVG(Sales) AS avg_sales FROM superstore;


-- Category-wise Analysis --

SELECT Category, SUM(Sales) AS total_sales
FROM superstore
GROUP BY Category;

SELECT Category, SUM(Sales) AS total_sales
FROM superstore
GROUP BY Category
ORDER BY total_sales;

SELECT Category, SUM(Profit) AS total_profit
FROM superstore
GROUP BY Category;

SELECT Category, SUM(Profit) AS total_profit
FROM superstore
GROUP BY Category
ORDER BY total_profit DESC;

SELECT Category, SUM(Profit) AS total_profit
FROM superstore
GROUP BY Category
ORDER BY total_profit DESC
LIMIT 1;

SELECT Category, MAX(Profit) AS Max_profit
FROM superstore
GROUP BY Category
ORDER BY Max_profit DESC
LIMIT 1;

SELECT Category, AVG(Profit)
FROM superstore
GROUP BY Category
ORDER BY AVG(Profit) DESC;


-- Region-wise Sales Analysis --


SELECT Region, SUM(Sales) AS total_sales
FROM superstore
GROUP BY Region
ORDER BY total_sales DESC;


-- High Performing Categories


SELECT Category, SUM(Sales) AS total_sales
FROM superstore
GROUP BY Category
HAVING total_sales > 100000;


SELECT Category, SUM(Sales) AS total_sales
FROM superstore
GROUP BY Category
HAVING total_sales > 800000;


SELECT Category, SUM(Sales) AS total_sales
FROM superstore
GROUP BY Category
HAVING total_sales > 100000
ORDER BY total_sales DESC;

SELECT Category, SUM(Sales) AS total_sales
FROM superstore
GROUP BY Category
HAVING total_sales > 100000
ORDER BY total_sales DESC
LIMIT 1;


-- Loss Making Categories


SELECT Category, SUM(Profit) AS total_profit
FROM superstore
GROUP BY Category
HAVING total_profit < 0;


-- High Value Orders


SELECT *
FROM superstore
WHERE Sales > 5000;


SELECT *
FROM superstore
WHERE Sales < 100;


-- Most Profitable Region


SELECT Region, SUM(Profit) AS total_profit
FROM superstore
GROUP BY Region
ORDER BY total_profit DESC
LIMIT 1;


-- Profit by Region


SELECT Region, SUM(Profit) AS total_profit
FROM superstore
GROUP BY Region
ORDER BY total_profit DESC;


-- Loss Making Regions


SELECT Region, SUM(Profit) AS total_profit
FROM superstore
GROUP BY Region
HAVING total_profit < 0;


-- Avg Profit per Region

SELECT Region, AVG(Profit) AS avg_profit
FROM superstore
GROUP BY Region;


-- Top 2 Regions by Profit


SELECT Region, SUM(Profit) AS total_profit
FROM superstore
GROUP BY Region
ORDER BY total_profit DESC
LIMIT 2;


-- Sales vs Profit by Region


SELECT Region, 
       SUM(Sales) AS total_sales,
       SUM(Profit) AS total_profit
FROM superstore
GROUP BY Region;


-- Number of Orders by Region


SELECT Region, COUNT(*) AS total_orders
FROM superstore
GROUP BY Region;


SELECT Region, COUNT(*) AS total_orders
FROM superstore
GROUP BY Region
ORDER BY total_orders DESC;



-- Creating region_info table to store region managers

CREATE TABLE region_info (
region VARCHAR(50),
manager VARCHAR(50)
);

-- Inserting data

INSERT INTO region_info VALUES
('West', 'Alice'),
('East', 'Bob'),
('Central', 'John'),
('South', 'Emma');

SELECT * FROM region_info;



-- Joining superstore data with region_info 


SELECT s.Region, r.manager, SUM(s.Sales) AS total_sales
FROM superstore s
JOIN region_info r
ON s.Region = r.region
GROUP BY s.Region, r.manager;


SELECT s.Region, r.manager, SUM(s.Sales) AS total_sales
FROM superstore s
JOIN region_info r
ON s.Region = r.region
GROUP BY s.Region, r.manager
ORDER BY total_sales DESC;



-- customers whose total sales are above average


SELECT `Customer Name`, SUM(Sales) AS total_sales
FROM superstore
GROUP BY `Customer Name`
HAVING total_sales > (
    -- Subquery to calculate average sales
    SELECT AVG(Sales) FROM superstore
);



-- Classifying each product as Profit or Loss

SELECT `Product Name`, Profit,
CASE
    WHEN Profit > 0 THEN 'Profit'
    WHEN Profit < 0 THEN 'Loss'
    ELSE 'No Profit No Loss'
END AS profit_status
FROM superstore;



-- Counting number of profit vs loss orders

SELECT 
CASE 
    WHEN Profit > 0 THEN 'Profit'
    ELSE 'Loss'
END AS status,
COUNT(*) AS total_orders
FROM superstore
GROUP BY status;



-- Create CTE to calculate total sales per customer

WITH cs AS (
  SELECT `Customer Name`, SUM(Sales) AS total_sales
  FROM superstore
  GROUP BY `Customer Name`
)
SELECT * FROM cs;


-- Calculate total sales per customer using window function

SELECT DISTINCT `Customer Name`,
       SUM(Sales) OVER (PARTITION BY `Customer Name`) AS total_sales
FROM superstore;


-- Calculate total sales per customer

WITH cs AS (
  SELECT `Customer Name`, SUM(Sales) AS total_sales
  FROM superstore
  GROUP BY `Customer Name`
)

-- Apply ranking on total sales

SELECT `Customer Name`, total_sales,
       RANK() OVER (ORDER BY total_sales DESC) AS rnk
FROM cs;


-- Directly calculate total sales and rank customers

SELECT `Customer Name`,
       SUM(Sales) AS total_sales,
       RANK() OVER (ORDER BY SUM(Sales) DESC) AS rnk
FROM superstore
GROUP BY `Customer Name`;



--  Get daily total sales

-- Assign row number based on highest sales

SELECT `Customer Name`, Sales,
ROW_NUMBER() OVER (ORDER BY Sales DESC) AS row_num
FROM superstore;


-- Rank customers by sales (same rank for ties)


SELECT `Customer Name`, Sales,
RANK() OVER (ORDER BY Sales DESC) AS rank_num
FROM superstore;


-- Running total of sales

SELECT `Order Date`, Sales,
SUM(Sales) OVER (ORDER BY `Order Date`) AS running_total
FROM superstore;


-- Customers with high sales using CTE

WITH customer_sales AS (
    SELECT `Customer Name`, SUM(Sales) AS total_sales
    FROM superstore
    GROUP BY `Customer Name`
)
SELECT *
FROM customer_sales
WHERE total_sales > 5000;


SELECT Region,
       SUM(Sales) AS total_sales,
       ROUND(SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER (), 2) AS percentage
FROM superstore
GROUP BY Region;


SELECT Category, `Product Name`, total_sales
FROM (
    SELECT Category, `Product Name`,
           SUM(Sales) AS total_sales,
           RANK() OVER (PARTITION BY Category ORDER BY SUM(Sales) DESC) AS rnk
    FROM superstore
    GROUP BY Category, `Product Name`
) t
WHERE rnk <= 3;


SELECT `Customer Name`, COUNT(*) AS count
FROM superstore
GROUP BY `Customer Name`
HAVING COUNT(*) > 1;


SELECT `Order Date`, Sales,
       LAG(Sales) OVER (ORDER BY `Order Date`) AS previous_sales
FROM superstore;




-- Top 3 products in each category (best performers)


SELECT Category, `Product Name`, total_sales
FROM (
    SELECT Category, `Product Name`,
           SUM(Sales) AS total_sales,
           RANK() OVER (PARTITION BY Category ORDER BY SUM(Sales) DESC) AS rnk
    FROM superstore
    GROUP BY Category, `Product Name`
) t
WHERE rnk <= 3;



-- Percentage contribution of each region


SELECT Region,
       SUM(Sales) AS total_sales,
       ROUND(SUM(Sales) * 100 / SUM(SUM(Sales)) OVER (), 2) AS percentage
FROM superstore
GROUP BY Region;


-- Monthly sales trend


SELECT DATE_FORMAT(`Order Date`, '%Y-%m') AS month,
       SUM(Sales) AS total_sales
FROM superstore
GROUP BY month
ORDER BY month;


-- Category performance (profit or loss)


SELECT Category,
       SUM(Profit) AS total_profit,
       CASE 
           WHEN SUM(Profit) > 0 THEN 'Profitable'
           ELSE 'Loss'
       END AS status
FROM superstore
GROUP BY Category;


-- Customers who ordered more than once


SELECT `Customer Name`, COUNT(*) AS total_orders
FROM superstore
GROUP BY `Customer Name`
HAVING COUNT(*) > 1;


SELECT `Customer Name`, COUNT(*) AS total_orders
FROM superstore
GROUP BY `Customer Name`
HAVING COUNT(*) < 2;


-- Compare current sales with previous order


SELECT `Order Date`, Sales,
       LAG(Sales) OVER (ORDER BY `Order Date`) AS previous_sales
FROM superstore;



SELECT * FROM superstore;























































































