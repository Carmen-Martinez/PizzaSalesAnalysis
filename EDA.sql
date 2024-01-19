## EXPLORATORY DATA ANALYSIS ##

SELECT *
FROM pizza_sales;

# Unique orders placed
SELECT COUNT(DISTINCT(order_id))
FROM pizza_sales;
-- [21350 unique orders placed]

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

# most favorite ingredient
SELECT DISTINCT(main_topping), COUNT(main_topping) AS fav_main_topping -- , 2nd_main_ingredient, 3rd_main_ingredient
FROM pizza_sales
GROUP BY main_topping
ORDER BY fav_main_topping DESC;
-- [Chicken is the most favorite main ingredient on pizza]

# 2nd most favorite ingredient
SELECT DISTINCT(2nd_main_topping), COUNT(2nd_main_topping) AS fav_2nd_main_topping -- , 2nd_main_ingredient, 3rd_main_ingredient
FROM pizza_sales
GROUP BY 2nd_main_topping
HAVING 2nd_main_topping <> 'tomatoes'
ORDER BY fav_2nd_main_topping DESC;
-- [mushroom is the 2nd most favoite ingredient, if we remove tomatoes and mozzarella cheese]

# 3rd most favorite ingredient
SELECT DISTINCT(3rd_main_topping), COUNT(3rd_main_topping) AS fav_3rd_main_topping -- , 2nd_main_ingredient, 3rd_main_ingredient
FROM pizza_sales
GROUP BY 3rd_main_topping
HAVING 3rd_main_topping <> 'tomatoes' AND 3rd_main_topping <> 'mozzarella cheese'
ORDER BY fav_3rd_main_topping DESC;
-- [red peppers is the 2nd most favoite ingredient, if we remove tomatoes and mozzarella cheese]

# What is the total revenue generated over all operational days?
SELECT DATEDIFF(MAX(order_date), MIN(order_date)) + 1, ROUND(SUM(total_price),2) AS total_rev
FROM pizza_sales;
-- [$817,860 total revenue in 1 year]

# What is peak hour(s) of pizza orders?
SELECT HOUR(order_time) AS order_hour, COUNT(HOUR(order_time)) as Hour_Count
FROM pizza_sales
GROUP BY HOUR(order_time)
ORDER BY COUNT(HOUR(order_time)) DESC;
-- [most pizzas are ordered between 1-2pm and 5-7pm]

# What date did they receive the most unique orders?
SELECT order_date, COUNT(DISTINCT(order_id)) AS order_count
FROM pizza_sales
GROUP BY order_date
ORDER BY order_count DESC;
-- [Peak number of pizzas ordered were on 11/26/2015 AND 11/27/2015]

# Which pizzas are ordered more than once?
SELECT pizza_name, ROUND(AVG(quantity),2) AS avg_order_count
FROM pizza_sales
GROUP BY pizza_name
ORDER BY avg_order_count DESC;
-- [Most people order 1 pizza per order]
-- [though there is a higher frequency of ordering more than 1 'The Big Meat Pizza" in a single order]

-- What is the most popular pizza size?
SELECT pizza_size, COUNT(pizza_size) AS pizza_size_cnt
FROM pizza_sales
GROUP BY pizza_size
ORDER BY pizza_size_cnt DESC;
-- [Most people order Large Pizzas, with few ordering XL or XXL]

# Which Pizza + Size is the most popular?
SELECT pizza_name_id, COUNT(pizza_name_id) AS pizza_name_size
FROM pizza_sales
GROUP BY pizza_name_id
ORDER BY pizza_name_size DESC
-- [most common pizza ordered is the Medium-sized Big Meat Pizza]


