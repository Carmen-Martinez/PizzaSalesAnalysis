-- Data Cleaning and EDA
SELECT *
FROM pizza_sales;

-- adding ingredient columns 
ALTER TABLE pizza_sales
ADD COLUMN 1st_main_ingredient TEXT,
ADD COLUMN 2nd_main_ingredient TEXT,
ADD COLUMN 3rd_main_ingredient TEXT
;

-- creating 3 main ingredients columns based on pizza_ingredient column
SELECT *,
SUBSTRING_INDEX(pizza_ingredients, ",", 1) AS 1st_main_ingredient, 
SUBSTRING_INDEX(SUBSTRING_INDEX(pizza_ingredients, ",", 2), ",", -1) AS 2nd_main_ingredient,
SUBSTRING_INDEX(SUBSTRING_INDEX(pizza_ingredients, ",", 3), ",", -1) AS 3rd_main_ingredient
FROM pizza_sales;

-- adding values to all ingredient columns
UPDATE pizza_sales
SET 1st_main_ingredient = SUBSTRING_INDEX(pizza_ingredients, ",", 1);

UPDATE pizza_sales
SET 2nd_main_ingredient = SUBSTRING_INDEX(SUBSTRING_INDEX(pizza_ingredients, ",", 2), ",", -1);

UPDATE pizza_sales
SET 3rd_main_ingredient = SUBSTRING_INDEX(SUBSTRING_INDEX(pizza_ingredients, ",", 3), ",", -1);

-- replacing values in 3rd_main_ingredient where 2nd_main_ingredient = 3rd_main_ingredient with NULL values
SELECT *, 
	CASE
        WHEN 2nd_main_ingredient = 3rd_main_ingredient THEN NULL
        ELSE 3rd_main_ingredient
    END
FROM pizza_sales
;

-- updating 3rd_main_ingredient column
UPDATE pizza_sales
SET 3rd_main_ingredient =  
	CASE
        WHEN 2nd_main_ingredient = 3rd_main_ingredient THEN NULL
        ELSE 3rd_main_ingredient
    END
;

-- Locating Duplicates
-- No duplicates found
SELECT pizza_id, COUNT(CONCAT(order_id, pizza_name_id))
FROM pizza_sales
GROUP BY pizza_id
HAVING COUNT(CONCAT(order_id, pizza_name_id)) = 1

-- STANDARDIZING COLUMNS
/*
-- Checking for unique values in multiple columns
SELECT COUNT(DISTINCT(order_id))
FROM pizza_sales;

SELECT DISTINCT(pizza_category)
FROM pizza_sales;

-- Top 10 most popular pizza
SELECT pizza_name, COUNT(pizza_name) AS num_pizza_orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY COUNT(pizza_name) DESC
LIMIT 10;
*/



