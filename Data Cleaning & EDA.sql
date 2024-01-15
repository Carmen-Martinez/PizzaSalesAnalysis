### Data Cleaning and EDA ###

## CLEANING DATA

SELECT *
FROM pizza_sales;

# adding ingredient columns 
ALTER TABLE pizza_sales
ADD COLUMN 1st_main_ingredient TEXT,
ADD COLUMN 2nd_main_ingredient TEXT,
ADD COLUMN 3rd_main_ingredient TEXT;

# creating 3 main ingredients columns based on pizza_ingredient column
SELECT *,
SUBSTRING_INDEX(pizza_ingredients, ",", 1) AS 1st_main_ingredient, 
SUBSTRING_INDEX(SUBSTRING_INDEX(pizza_ingredients, ",", 2), ",", -1) AS 2nd_main_ingredient,
SUBSTRING_INDEX(SUBSTRING_INDEX(pizza_ingredients, ",", 3), ",", -1) AS 3rd_main_ingredient
FROM pizza_sales;

# adding values to all ingredient columns
UPDATE pizza_sales
SET 1st_main_ingredient = SUBSTRING_INDEX(pizza_ingredients, ",", 1);

UPDATE pizza_sales
SET 2nd_main_ingredient = SUBSTRING_INDEX(SUBSTRING_INDEX(pizza_ingredients, ",", 2), ",", -1);

UPDATE pizza_sales
SET 3rd_main_ingredient = SUBSTRING_INDEX(SUBSTRING_INDEX(pizza_ingredients, ",", 3), ",", -1);

# replacing values in 3rd_main_ingredient where 2nd_main_ingredient = 3rd_main_ingredient with NULL values
SELECT *, 
	CASE
        WHEN 2nd_main_ingredient = 3rd_main_ingredient THEN NULL
        ELSE 3rd_main_ingredient
    END
FROM pizza_sales;

-- updating 3rd_main_ingredient column
UPDATE pizza_sales
SET 3rd_main_ingredient =  
	CASE
        WHEN 2nd_main_ingredient = 3rd_main_ingredient THEN NULL
        ELSE 3rd_main_ingredient
    END;

## Locating Duplicates ##

SELECT pizza_id, COUNT(CONCAT(order_id, pizza_name_id))
FROM pizza_sales
GROUP BY pizza_id
HAVING COUNT(CONCAT(order_id, pizza_name_id)) = 1;
-- [No duplicates found]

## STANDARDIZING COLUMNS ##

# removing special characters & extra space
UPDATE pizza_sales
SET 1st_main_ingredient =  TRIM(REGEXP_REPLACE(1st_main_ingredient, '[^a-zA-Z0-9 ]', ''));

UPDATE pizza_sales
SET 2nd_main_ingredient =  TRIM(REGEXP_REPLACE(2nd_main_ingredient, '[^a-zA-Z0-9 ]', ''));

UPDATE pizza_sales
SET 3rd_main_ingredient =  TRIM(REGEXP_REPLACE(3rd_main_ingredient, '[^a-zA-Z0-9 ]', ''));

/*
SELECT *
FROM pizza_sales
WHERE order_date = '2015-01-13' ;

UPDATE pizza_sales
SET order_date =  DATE_FORMAT(str_to_date(order_date, '%d-%m-%Y'), '%m-%d-%y')
WHERE str_to_date(order_date, '%d-%m-%Y') = '01-13-2015';
*/

# Dropping pizza_ingredients column
ALTER TABLE pizza_sales
DROP COLUMN pizza_ingredients;



##################################################



## EXPLORATORY DATA ANALYSIS ##

# Unique orders placed
SELECT COUNT(DISTINCT(order_id))
FROM pizza_sales;
-- [21350 unique orders placed]

# What is the total revenue generated over all operational days?
SELECT ROUND(SUM(total_price),1) AS total_rev, MAX(order_date) - MIN(order_date) AS number_of_days
FROM pizza_sales;
-- [$817,860 total revenue in 8 days]

# Busiest time for the pizza store
SELECT order_time, COUNT(order_time) as order_count
FROM pizza_sales
GROUP BY order_time
ORDER BY order_count DESC
LIMIT 1000;
-- [Most pizzas are ordered between 11am-1pm]

# TOP 10 pizzas ordered
SELECT pizza_name, COUNT(pizza_name) AS num_pizza_orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY COUNT(pizza_name) DESC
LIMIT 10;

# BOTTOM 10 pizzas ordered
SELECT pizza_name, COUNT(pizza_name) AS num_pizza_orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY COUNT(pizza_name) ASC
LIMIT 10;
-- [The top 6 pizza's get about the same number of orders]

# TOTAL REVENUE of TOP 10 pizzas
SELECT 
    ROUND(SUM(Total_Rev),1) AS Total_Rev_Top_10
FROM (
    SELECT 
        ROUND(SUM(total_price), 1) AS Total_Rev
    FROM pizza_sales
    GROUP BY pizza_name
    ORDER BY Total_Rev DESC
    LIMIT 10
) AS Top_10_Pizzas;

# TOTAL REVENUE of BOTTOM 10 pizzas
SELECT ROUND(SUM(Total_Rev),1) AS Total_Rev_Top_10
FROM (
    SELECT 
        ROUND(SUM(total_price), 1) AS Total_Rev
    FROM pizza_sales
    GROUP BY pizza_name
    ORDER BY Total_Rev ASC
    LIMIT 10
) AS Top_10_Pizzas;
-- [The TOP 10 Pizza's total revenue is 2x the BOTTOM 10 Pizza's total revenue]







