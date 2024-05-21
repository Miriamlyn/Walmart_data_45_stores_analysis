-- This dataset was downloaded from Kaggle -- 
-- The period of the data spans from 2010-02-05 to 2012-11-01 -- 
-- The data is a historical data and no changes were made to the original data --

USE Portfolio_project;
SELECT * FROM walmart_sales;

/* This answers the total sales for the period in review*/

SELECT SUM(Weekly_Sales) AS total_sales
FROM walmart_sales;

/* This answers the average sales for the period in review*/

SELECT AVG(Weekly_Sales) AS avg_sales
FROM walmart_sales;

/* This answers the top 10 stores with highest sales */

SELECT Store,
       SUM(Weekly_Sales) AS total_sales
FROM walmart_sales
GROUP BY Store
ORDER BY total_sales DESC
LIMIT 10;

/* This answers the bottom 10 stores with lowest sales */
SELECT Store,
       SUM(Weekly_Sales) AS total_sales
FROM walmart_sales
GROUP BY Store
ORDER BY total_sales ASC
LIMIT 10;

/* top 5 stores with the highest Avg sales */ 
SELECT Store,
       AVG(Weekly_Sales) AS total_sales
FROM walmart_sales
GROUP BY Store
ORDER BY total_sales DESC
LIMIT 5;

/* bottom 5 stores with the lowest Avg sales */ 
SELECT Store,
       AVG(Weekly_Sales) AS total_sales
FROM walmart_sales
GROUP BY Store
ORDER BY total_sales ASC
LIMIT 5;

/* weekly sales in the weeks that has holiday */

SELECT Date,
       SUM(Weekly_Sales) AS sales_per_week_holiday
FROM walmart_sales
WHERE Holiday_Flag = 1
GROUP BY Date
ORDER BY sales_per_week_holiday DESC;


/* total sales in the holiday weeks */

SELECT SUM(sales_per_week_holiday) total_holiday_sales
FROM 
(SELECT Date,
       SUM(Weekly_Sales) AS sales_per_week_holiday
FROM walmart_sales
WHERE Holiday_Flag = 1
GROUP BY Date
ORDER BY sales_per_week_holiday DESC) sub;


/* weekly sales in the weeks that has no holiday */

SELECT Date,
       SUM(Weekly_Sales) AS sales_per_normal_week
FROM walmart_sales
WHERE Holiday_Flag = 0
GROUP BY Date
ORDER BY sales_per_normal_week DESC;


/* total sales in the weeks without holidays */

SELECT SUM(sales_per_normal_week) AS total_no_holiday_sales
FROM (SELECT Date,
       SUM(Weekly_Sales) AS sales_per_normal_week
FROM walmart_sales
WHERE Holiday_Flag = 0
GROUP BY Date
ORDER BY sales_per_normal_week DESC) no_holiday;

/* avg sales on holiday week vs no holiday week*/

SELECT 
  AVG(CASE WHEN Holiday_Flag = 1 THEN Weekly_Sales ELSE NULL END) AS Avg_Holiday_Sales,
  AVG(CASE WHEN Holiday_Flag = 0 THEN Weekly_Sales ELSE NULL END) AS Avg_Non_Holiday_Sales
FROM walmart_sales;

# Percentage change in sales in the Holiday week

WITH holiday_sales AS (
SELECT AVG(CASE WHEN Holiday_Flag = 1 THEN Weekly_sales ELSE NULL END) AS avg_holiday_sales
FROM walmart_sales
),
no_holiday_sales AS (
SELECT AVG(CASE WHEN Holiday_Flag = 0 THEN Weekly_sales ELSE NULL END) AS avg_no_holiday_sales 
FROM walmart_sales
)
SELECT ROUND((holiday_sales.avg_holiday_sales - no_holiday_sales.avg_no_holiday_sales) / no_holiday_sales.avg_no_holiday_sales * 100, 2) percentage_change
FROM holiday_sales, no_holiday_sales;

/* Totals sales where unemployement rate is above average */

SELECT Date,
       Store,
       Unemployment,
       SUM(Weekly_Sales) AS weekly_sales
FROM walmart_sales
WHERE Unemployment > (SELECT AVG(Unemployment) AS avg_unemployment_rate FROM walmart_sales)
GROUP BY Date, Store, Unemployment
ORDER BY weekly_sales DESC;


/*Totals sales where unemployement rate is below average */

SELECT SUM(weekly_sales) AS total_sales_unemployed_rate_below_avg
FROM (
      SELECT Date,
       Store,
       Unemployment,
       SUM(Weekly_Sales) AS weekly_sales
FROM walmart_sales
WHERE Unemployment < (SELECT AVG(Unemployment) AS avg_unemployment_rate FROM walmart_sales)
GROUP BY Date, Store, Unemployment
ORDER BY weekly_sales DESC) below_avg_unemploy_rate;

/* Count of no weeks with holidays */

SELECT COUNT(Holiday_Flag) AS holiday_count
FROM walmart_sales
WHERE Holiday_Flag = 1;

/* Weeks without holiday */

SELECT COUNT(Holiday_Flag) AS holiday_count
FROM walmart_sales
WHERE Holiday_Flag = 0;

