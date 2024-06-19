-- Q1: Identify the overall trend in liqour salers in Iowoa over the years

SELECT 
 EXTRACT(YEAR from date) as year, SUM(sale_dollars) AS sales
FROM `bigquery-public-data.iowa_liquor_sales.sales` 
GROUP BY year 
ORDER BY year ASC
LIMIT 1000;