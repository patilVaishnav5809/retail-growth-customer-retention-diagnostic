-- ============================================================
-- KEY VALIDATION
-- FILE: primary_key_checks.sql
-- PURPOSE: Validate single-column primary keys
-- ============================================================

USE olist_db;


-- ============================================================
-- CUSTOMERS
-- Expected PK: customer_id
-- ============================================================

-- 1. Check NULL customer_id
SELECT *
FROM customers
WHERE customer_id IS NULL;


-- 2. Check duplicate customer_id
SELECT
    customer_id,
    COUNT(*) AS record_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;


-- 3. Primary-key summary for customers
SELECT
    COUNT(*) AS total_rows,
    COUNT(customer_id) AS non_null_pk,
    COUNT(DISTINCT customer_id) AS distinct_pk
FROM customers;


-- ============================================================
-- ORDERS
-- Expected PK: order_id
-- ============================================================

-- 4. Check NULL order_id
SELECT *
FROM orders
WHERE order_id IS NULL;


-- 5. Check duplicate order_id
SELECT
    order_id,
    COUNT(*) AS record_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;


-- 6. Primary-key summary for orders
SELECT
    COUNT(*) AS total_rows,
    COUNT(order_id) AS non_null_pk,
    COUNT(DISTINCT order_id) AS distinct_pk
FROM orders;


-- ============================================================
-- PRODUCTS
-- Expected PK: product_id
-- ============================================================

-- 7. Check NULL product_id
SELECT *
FROM products
WHERE product_id IS NULL;


-- 8. Check duplicate product_id
SELECT
    product_id,
    COUNT(*) AS record_count
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;


-- 9. Primary-key summary for products
SELECT
    COUNT(*) AS total_rows,
    COUNT(product_id) AS non_null_pk,
    COUNT(DISTINCT product_id) AS distinct_pk
FROM products;


-- ============================================================
-- SELLERS
-- Expected PK: seller_id
-- ============================================================

-- 10. Check NULL seller_id
SELECT *
FROM sellers
WHERE seller_id IS NULL;


-- 11. Check duplicate seller_id
SELECT
    seller_id,
    COUNT(*) AS record_count
FROM sellers
GROUP BY seller_id
HAVING COUNT(*) > 1;


-- 12. Primary-key summary for sellers
SELECT
    COUNT(*) AS total_rows,
    COUNT(seller_id) AS non_null_pk,
    COUNT(DISTINCT seller_id) AS distinct_pk
FROM sellers;


-- ============================================================
-- ORDER_REVIEWS
-- Expected PK: review_id
-- ============================================================

-- 13. Check NULL review_id
SELECT *
FROM order_reviews
WHERE review_id IS NULL;


-- 14. Check duplicate review_id
SELECT
    review_id,
    COUNT(*) AS record_count
FROM order_reviews
GROUP BY review_id
HAVING COUNT(*) > 1;




-- 15. Primary-key summary for reviews
SELECT
    COUNT(*) AS total_rows,
    COUNT(review_id) AS non_null_pk,
    COUNT(DISTINCT review_id) AS distinct_pk
FROM order_reviews;


-- ============================================================
-- PRODUCT_CATEGORY_TRANSLATION
-- Expected PK: product_category_name
-- ============================================================

-- 16. Check NULL category key
SELECT *
FROM product_category_translation
WHERE product_category_name IS NULL;


-- 17. Check duplicate category key
SELECT
    product_category_name,
    COUNT(*) AS record_count
FROM product_category_translation
GROUP BY product_category_name
HAVING COUNT(*) > 1;


-- 18. Primary-key summary
SELECT
    COUNT(*) AS total_rows,
    COUNT(product_category_name) AS non_null_pk,
    COUNT(DISTINCT product_category_name) AS distinct_pk
FROM product_category_translation;