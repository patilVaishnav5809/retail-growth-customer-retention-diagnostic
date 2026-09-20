-- ============================================================
-- KEY VALIDATION
-- FILE: unique_key_checks.sql
-- PURPOSE: Validate unique-key constraints and candidate keys
-- ============================================================

USE olist_db;


-- ============================================================
-- CUSTOMERS
-- ============================================================

-- 1. customer_id uniqueness
SELECT
    customer_id,
    COUNT(*) AS record_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;


-- 2. customer_unique_id is NOT expected to be unique
-- This check identifies repeated business identities.
SELECT
    customer_unique_id,
    COUNT(*) AS customer_record_count
FROM customers
GROUP BY customer_unique_id
HAVING COUNT(*) > 1
ORDER BY customer_record_count DESC;


-- ============================================================
-- ORDERS
-- ============================================================

-- 3. order_id uniqueness
SELECT
    order_id,
    COUNT(*) AS record_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;


-- ============================================================
-- ORDER_ITEMS
-- ============================================================

-- 4. order_id alone should NOT be unique
-- This validates that the table grain is item-level.
SELECT
    order_id,
    COUNT(*) AS item_count
FROM order_items
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY item_count DESC;


-- 5. order_item_id alone should NOT be treated as globally unique
SELECT
    order_item_id,
    COUNT(*) AS record_count
FROM order_items
GROUP BY order_item_id
HAVING COUNT(*) > 1;


-- ============================================================
-- PRODUCTS
-- ============================================================

-- 6. product_id uniqueness
SELECT
    product_id,
    COUNT(*) AS record_count
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;


-- ============================================================
-- SELLERS
-- ============================================================

-- 7. seller_id uniqueness
SELECT
    seller_id,
    COUNT(*) AS record_count
FROM sellers
GROUP BY seller_id
HAVING COUNT(*) > 1;


-- ============================================================
-- ORDER_PAYMENTS
-- ============================================================

-- 8. order_id alone should NOT be unique
-- Multiple payment records may belong to one order.
SELECT
    order_id,
    COUNT(*) AS payment_count
FROM order_payments
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY payment_count DESC;


-- 9. payment_sequential alone should NOT be unique
SELECT
    payment_sequential,
    COUNT(*) AS record_count
FROM order_payments
GROUP BY payment_sequential
HAVING COUNT(*) > 1;


-- ============================================================
-- ORDER_REVIEWS
-- ============================================================

-- 10. review_id uniqueness
SELECT
    review_id,
    COUNT(*) AS record_count
FROM order_reviews
GROUP BY review_id
HAVING COUNT(*) > 1;


-- 11. order_id is not necessarily unique in reviews
-- Identify orders having multiple review records.
SELECT
    order_id,
    COUNT(*) AS review_count
FROM order_reviews
GROUP BY order_id
HAVING COUNT(*) > 1;


-- ============================================================
-- PRODUCT_CATEGORY_TRANSLATION
-- ============================================================

-- 12. Portuguese category should be unique
SELECT
    product_category_name,
    COUNT(*) AS record_count
FROM product_category_translation
GROUP BY product_category_name
HAVING COUNT(*) > 1;


-- 13. English category should normally map one-to-one
-- Identify English names appearing more than once.
SELECT
    product_category_name_english,
    COUNT(*) AS record_count
FROM product_category_translation
GROUP BY product_category_name_english
HAVING COUNT(*) > 1;


-- ============================================================
-- KEY CONSISTENCY SUMMARY
-- ============================================================

-- 14. Customers
SELECT
    'customers' AS table_name,
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_id) AS distinct_key_values
FROM customers;


-- 15. Orders
SELECT
    'orders' AS table_name,
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS distinct_key_values
FROM orders;


-- 16. Products
SELECT
    'products' AS table_name,
    COUNT(*) AS total_rows,
    COUNT(DISTINCT product_id) AS distinct_key_values
FROM products;


-- 17. Sellers
SELECT
    'sellers' AS table_name,
    COUNT(*) AS total_rows,
    COUNT(DISTINCT seller_id) AS distinct_key_values
FROM sellers;


-- 18. Reviews
SELECT
    'order_reviews' AS table_name,
    COUNT(*) AS total_rows,
    COUNT(DISTINCT review_id) AS distinct_key_values
FROM order_reviews;