
-- COFFEE SHOP SALES ANALYSIS
-- Database: coffee_shop_analysis
-- Purpose: Business KPIs, Product Trends, and Sales Analysis

USE coffee_shop_analysis;

-- 1. OVERALL BUSINESS PERFORMANCE
-- Analyze total records, transactions, units, revenue,
-- and average transaction value.

SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT transaction_id) AS total_transactions,
    SUM(transaction_qty) AS total_units_sold,
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_revenue,
    ROUND(
     SUM(transaction_qty * unit_price) / NULLIF(COUNT(DISTINCT transaction_id), 0), 2
    ) AS average_transaction_value
FROM coffee_sales;

-- 2. STORE PERFORMANCE COMPARISON
-- Compare revenue, units sold, transactions,
-- and average transaction value across stores.

SELECT
    store_location,
    COUNT(DISTINCT transaction_id) AS total_transactions,
    SUM(transaction_qty) AS total_units_sold,
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_revenue,
    ROUND(
     SUM(transaction_qty * unit_price)/ NULLIF(COUNT(DISTINCT transaction_id), 0), 2
    ) AS average_transaction_value
FROM coffee_sales
GROUP BY store_location
ORDER BY total_revenue DESC;

-- 3. TOP 10 PRODUCTS BY UNITS SOLD
-- Identify the most frequently purchased product details.

SELECT
    product_detail,
    SUM(transaction_qty) AS total_units_sold,
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_revenue
FROM coffee_sales
GROUP BY product_detail
ORDER BY total_units_sold DESC
LIMIT 10;

-- 4. MONTHLY SALES PERFORMANCE
-- Analyze monthly revenue, units sold, and transactions.

SELECT
    MONTH(transaction_date) AS month_number,
    MONTHNAME(transaction_date) AS month_name,
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_revenue,
    SUM(transaction_qty) AS total_units_sold,
    COUNT(DISTINCT transaction_id) AS total_transactions
FROM coffee_sales
GROUP BY
MONTH(transaction_date),
MONTHNAME(transaction_date)
ORDER BY month_number;

-- 5. CATEGORY-WISE REVENUE CONTRIBUTION
-- Calculate revenue and percentage contribution by category.

SELECT
    product_category,
    SUM(transaction_qty) AS total_units_sold,
    ROUND(SUM(transaction_qty * unit_price), 2) AS category_revenue,
    ROUND(
    100.0 * SUM(transaction_qty * unit_price)
    / NULLIF(
     (SELECT
         SUM(transaction_qty * unit_price)
         FROM coffee_sales),0
      ),2
     ) AS revenue_percentage
FROM coffee_sales
GROUP BY product_category
ORDER BY category_revenue DESC;

-- 6. DAY-WISE SALES PERFORMANCE
-- Compare revenue, units sold, and transactions by weekday.

SELECT
    DAYNAME(transaction_date) AS day_name,
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_revenue,
    SUM(transaction_qty) AS total_units_sold,
    COUNT(DISTINCT transaction_id) AS total_transactions
FROM coffee_sales
GROUP BY
DAYOFWEEK(transaction_date),
DAYNAME(transaction_date)
ORDER BY DAYOFWEEK(transaction_date);



 -- 7. DATA QUALITY CHECKS

-- Total records aur duplicate transaction IDs
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT transaction_id) AS unique_transactions,
    COUNT(*) - COUNT;


--. Check missing values in important columns
SELECT
    SUM(transaction_id IS NULL) AS missing_transaction_id,
    SUM(transaction_date IS NULL) AS missing_transaction_date,
    SUM(transaction_qty IS NULL) AS missing_quantity,
    SUM(unit_price IS NULL) AS missing_unit_price,
    SUM(product_category IS NULL) AS missing_category,
    SUM(product_type IS NULL) AS missing_product_type
FROM coffee_sales;

--  Check invalid prices, quantities, and future dates
SELECT
    SUM(unit_price <= 0) AS invalid_prices,
    SUM(transaction_qty <= 0) AS invalid_quantities,
    SUM(transaction_date IS NOT NULL
        AND transaction_date > CURRENT_DATE()) AS future_dates
FROM coffee_sales;
