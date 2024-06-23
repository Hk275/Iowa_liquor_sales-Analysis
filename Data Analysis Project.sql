-- Q1: Identify the overall trend in liqour salers in Iowoa over the years

SELECT 
 EXTRACT(YEAR from date) as year, ROUND(SUM(sale_dollars),2) AS sales
FROM `bigquery-public-data.iowa_liquor_sales.sales` 
GROUP BY year 
ORDER BY year ASC
LIMIT 1000;


-- Which are the most popular liquor categories and brands sold in Iowa? 
-- Categories 
SELECT category_name, COUNT(*) AS num
FROM `bigquery-public-data.iowa_liquor_sales.sales` 
GROUP BY category_name
ORDER BY num DESC
LIMIT 10  ;
-- Brand 

SELECT item_description, COUNT(*) AS num
FROM `bigquery-public-data.iowa_liquor_sales.sales` 
GROUP BY item_description
ORDER BY num DESC
LIMIT 10  ;

-- How has the popularity of brands changed over time?
WITH CTE AS (
  SELECT EXTRACT(YEAR from date) as year,  -- This extracts the year
  item_description, 
  COUNT(*) as num_sold -- COUNTS everything 
  FROM `bigquery-public-data.iowa_liquor_sales.sales` 
  GROUP BY year, item_description -- Groups total sold by year and item_description
)
SELECT * 
FROM (
  SELECT * ,
  DENSE_RANK() OVER(PARTITION BY year ORDER BY num_sold DESC) AS RANK FROM CTE
) ranked 
WHERE RANK <= 5
ORDER BY year, RANK;


-- Are there any seasonal patterns 
SELECT 
EXTRACT( MONTH from date) as month,
SUM(sale_dollars) as sales 
FROM `bigquery-public-data.iowa_liquor_sales.sales` 
GROUP BY month 
ORDER BY month; 

-- Which counties have the highest sales 
SELECT county, SUM(sale_dollars) as sales
FROM `bigquery-public-data.iowa_liquor_sales.sales` 
GROUP BY county
ORDER BY sales DESC
LIMIT 10 ;


-- Avg PRICE of liquor by category. 
SELECT category_name, ROUND(AVG(sale_dollars/bottles_sold),2) as sales
FROM `bigquery-public-data.iowa_liquor_sales.sales` 
WHERE bottles_sold != 0
GROUP BY category_name
ORDER BY sales DESC
LIMIT 10;


-- Which Liquor Brands have the highest profit margins for reatilers
SELECT
item_description,
ROUND(AVG(state_bottle_cost),2) AS avg_cost,
ROUND (AVG(state_bottle_retail),2) AS avg_revenue,
ROUND(AVG(state_bottle_retail) - AVG(state_bottle_cost),2) AS profit
FROM `bigquery-public-data.iowa_liquor_sales.sales` 
GROUP BY item_description
LIMIT 10;
