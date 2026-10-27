-- Coffee Shop Sales Analysis
USE coffee_shop_analysis;

-- 1. Overall Business Performance
SELECT ROUND(SUM(Revenue), 2) AS total_revenue,
    SUM(transaction_qty) AS total_units_sold,
    COUNT(DISTINCT transaction_id) AS total_transactions,
    ROUND(SUM(Revenue) / COUNT(DISTINCT transaction_id), 2) AS average_transaction_value
FROM coffee_sales;


-- 2. Revenue and Sales by Store Location
SELECT store_location,
    ROUND(SUM(Revenue), 2) AS total_revenue,
    SUM(transaction_qty) AS total_units_sold,
    COUNT(DISTINCT transaction_id) AS total_transactions
FROM coffee_sales
GROUP BY store_location
ORDER BY total_revenue DESC;


-- 3. Top 10 Products by Units Sold
SELECT product_detail,
    SUM(transaction_qty) AS total_units_sold,
    ROUND(SUM(Revenue), 2) AS total_revenue
FROM coffee_sales
GROUP BY product_detail
ORDER BY total_units_sold DESC
LIMIT 10;


-- 4. Monthly Revenue Analysis
SELECT MONTH(transaction_date) AS month_number,
    MONTHNAME(transaction_date) AS month_name,
    ROUND(SUM(Revenue), 2) AS total_revenue,
    SUM(transaction_qty) AS total_units_sold,
    COUNT(DISTINCT transaction_id) AS total_transactions
FROM coffee_sales
GROUP BY MONTH(transaction_date),
    MONTHNAME(transaction_date)
ORDER BY month_number;


-- 5. Product Category Performance
SELECT product_category,
    ROUND(SUM(Revenue), 2) AS total_revenue,
    SUM(transaction_qty) AS total_units_sold,
    COUNT(DISTINCT transaction_id) AS total_transactions
FROM coffee_sales
GROUP BY product_category
ORDER BY total_revenue DESC;


-- 6. Day-wise Revenue Analysis
SELECT DAYNAME(transaction_date) AS day_name,
    ROUND(SUM(Revenue), 2) AS total_revenue,
    SUM(transaction_qty) AS total_units_sold,
    COUNT(DISTINCT transaction_id) AS total_transactions
FROM coffee_sales
GROUP BY DAYOFWEEK(transaction_date),
    DAYNAME(transaction_date)
ORDER BY DAYOFWEEK(transaction_date);


USE coffee_shop_analysis;

-- 1. BUSINESS KPIs
-- Total Records, Quantity Sold, Revenue, Average
-- Transaction Value

SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT transaction_id) AS total_transactions,
    SUM(transaction_qty) AS total_quantity_sold,
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_revenue,
    ROUND(
        SUM(transaction_qty * unit_price) / COUNT(DISTINCT transaction_id), 2
    ) AS avg_transaction_value
FROM coffee_sales;


-- 2. TOP 10 PRODUCTS BY REVENUE

SELECT
    product_type,
    SUM(transaction_qty) AS units_sold,
    ROUND(
        SUM(transaction_qty * unit_price), 2) AS total_revenue
FROM coffee_sales
GROUP BY product_type
ORDER BY total_revenue DESC
LIMIT 10;


-- 3. MONTHLY SALES PERFORMANCE
-- Monthly Revenue and Quantity Sold

SELECT
    MONTH(transaction_date) AS month_number,
    MONTHNAME(transaction_date) AS month_name,
    ROUND(
        SUM(transaction_qty * unit_price),2) AS monthly_revenue,
        SUM(transaction_qty) AS units_sold
FROM coffee_sales
GROUP BY
    MONTH(transaction_date),
    MONTHNAME(transaction_date)
ORDER BY month_number;


-- 4. STORE PERFORMANCE COMPARISON
SELECT
    store_location,
    COUNT(DISTINCT transaction_id) AS total_transactions,
    SUM(transaction_qty) AS units_sold,
    ROUND(
        SUM(transaction_qty * unit_price), 2
    ) AS total_revenue,
    ROUND(
        SUM(transaction_qty * unit_price)/ COUNT(DISTINCT transaction_id),2
    ) AS avg_transaction_value
FROM coffee_sales
GROUP BY store_location
ORDER BY total_revenue DESC;


-- 5. CATEGORY-WISE REVENUE CONTRIBUTION
SELECT
    product_category,
    ROUND(
        SUM(transaction_qty * unit_price),
        2
    ) AS category_revenue,
    ROUND(
        100.0 * SUM(transaction_qty * unit_price) / (
            SELECT SUM(transaction_qty * unit_price)
            FROM coffee_sales), 2 
    ) AS revenue_percentage
FROM coffee_sales
GROUP BY product_category
ORDER BY category_revenue DESC;
