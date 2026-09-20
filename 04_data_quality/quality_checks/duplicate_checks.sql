-- ============================================================
-- QUALITY CHECKS
-- FILE: duplicate_checks.sql
-- PURPOSE: Check uniqueness and duplicate records
-- ============================================================

USE olist_db;


-- ============================================================
-- CUSTOMERS
-- ============================================================

-- 1. customer_id should be unique
SELECT
    customer_id,
    COUNT(*) AS record_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;


-- 2. Check duplicate complete customer records
SELECT
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state,
    COUNT(*) AS duplicate_count
FROM customers
GROUP BY
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
HAVING COUNT(*) > 1;


-- ============================================================
-- ORDERS
-- ============================================================

-- 3. order_id should be unique
SELECT
    order_id,
    COUNT(*) AS record_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;


-- 4. Check exact duplicate orders
SELECT
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date,
    COUNT(*) AS duplicate_count
FROM orders
GROUP BY
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
HAVING COUNT(*) > 1;


-- ============================================================
-- ORDER_ITEMS
-- ============================================================

-- 5. (order_id, order_item_id) should be unique
SELECT
    order_id,
    order_item_id,
    COUNT(*) AS record_count
FROM order_items
GROUP BY
    order_id,
    order_item_id
HAVING COUNT(*) > 1;


-- 6. Check duplicate complete order-item records
SELECT
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value,
    COUNT(*) AS duplicate_count
FROM order_items
GROUP BY
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value
HAVING COUNT(*) > 1;


-- ============================================================
-- PRODUCTS
-- ============================================================

-- 7. product_id should be unique
SELECT
    product_id,
    COUNT(*) AS record_count
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;


-- ============================================================
-- SELLERS
-- ============================================================

-- 8. seller_id should be unique
SELECT
    seller_id,
    COUNT(*) AS record_count
FROM sellers
GROUP BY seller_id
HAVING COUNT(*) > 1;


-- ============================================================
-- ORDER_PAYMENTS
-- ============================================================

-- 9. (order_id, payment_sequential) should be unique
SELECT
    order_id,
    payment_sequential,
    COUNT(*) AS record_count
FROM order_payments
GROUP BY
    order_id,
    payment_sequential
HAVING COUNT(*) > 1;


-- 10. Check exact duplicate payment records
SELECT
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value,
    COUNT(*) AS duplicate_count
FROM order_payments
GROUP BY
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
HAVING COUNT(*) > 1;


-- ============================================================
-- ORDER_REVIEWS
-- ============================================================

-- 11. review_id should be unique
SELECT
    review_id,
    COUNT(*) AS record_count
FROM order_reviews
GROUP BY review_id
HAVING COUNT(*) > 1;


-- 12. Check duplicate review records
SELECT
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp,
    COUNT(*) AS duplicate_count
FROM order_reviews
GROUP BY
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp
HAVING COUNT(*) > 1;


-- ============================================================
-- GEO_LOC
-- ============================================================

-- 13. Check exact duplicate geographic records
SELECT
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state,
    COUNT(*) AS duplicate_count
FROM geo_loc
GROUP BY
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state
HAVING COUNT(*) > 1;


-- ============================================================
-- PRODUCT_CATEGORY_TRANSLATION
-- ============================================================

-- 14. product_category_name should be unique
SELECT
    product_category_name,
    COUNT(*) AS record_count
FROM product_category_translation
GROUP BY product_category_name
HAVING COUNT(*) > 1;


-- 15. Check duplicate English translations
SELECT
    product_category_name_english,
    COUNT(*) AS record_count
FROM product_category_translation
GROUP BY product_category_name_english
HAVING COUNT(*) > 1;