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

-- Updating dates with incorect date format
UPDATE pizza_sales 
SET order_date = DATE_FORMAT(STR_TO_DATE(order_date, '%d-%m-%Y'), '%m/%d/%Y')
WHERE order_date REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}';

-- Updating dates from string to date format
UPDATE pizza_sales 
SET order_date = DATE_FORMAT(STR_TO_DATE(order_date, '%m/%d/%Y'), '%m/%d/%Y')
WHERE order_date REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}';

-- Formatting all dates from string to date
UPDATE pizza_sales
SET order_date = STR_TO_DATE(order_date, '%m/%d/%Y');

# Updating order_date column from TEXT to DATE datatype
ALTER TABLE pizza_sales 
MODIFY order_date DATE;

# Dropping pizza_ingredients column
ALTER TABLE pizza_sales
DROP COLUMN pizza_ingredients;
