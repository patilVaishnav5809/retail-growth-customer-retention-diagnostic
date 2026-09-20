-- ============================================================
-- QUALITY CHECKS
-- FILE: data_type_checks.sql
-- PURPOSE: Validate declared column data types
-- ============================================================

USE olist_db;


-- ============================================================
-- 1. Inspect all declared data types
-- ============================================================

SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    COLUMN_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'olist_db'
ORDER BY
    TABLE_NAME,
    ORDINAL_POSITION;


-- ============================================================
-- CUSTOMERS
-- ============================================================

SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    COLUMN_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'olist_db'
  AND TABLE_NAME = 'customers'
ORDER BY ORDINAL_POSITION;


-- ============================================================
-- ORDERS
-- ============================================================

SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    COLUMN_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'olist_db'
  AND TABLE_NAME = 'orders'
ORDER BY ORDINAL_POSITION;


-- ============================================================
-- ORDER_ITEMS
-- ============================================================

SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    COLUMN_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'olist_db'
  AND TABLE_NAME = 'order_items'
ORDER BY ORDINAL_POSITION;


-- ============================================================
-- PRODUCTS
-- ============================================================

SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    COLUMN_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'olist_db'
  AND TABLE_NAME = 'products'
ORDER BY ORDINAL_POSITION;


-- ============================================================
-- SELLERS
-- ============================================================

SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    COLUMN_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'olist_db'
  AND TABLE_NAME = 'sellers'
ORDER BY ORDINAL_POSITION;


-- ============================================================
-- ORDER_PAYMENTS
-- ============================================================

SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    COLUMN_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'olist_db'
  AND TABLE_NAME = 'order_payments'
ORDER BY ORDINAL_POSITION;


-- ============================================================
-- ORDER_REVIEWS
-- ============================================================

SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    COLUMN_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'olist_db'
  AND TABLE_NAME = 'order_reviews'
ORDER BY ORDINAL_POSITION;


-- ============================================================
-- GEO_LOC
-- ============================================================

SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    COLUMN_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'olist_db'
  AND TABLE_NAME = 'geo_loc'
ORDER BY ORDINAL_POSITION;


-- ============================================================
-- PRODUCT_CATEGORY_TRANSLATION
-- ============================================================

SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    COLUMN_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'olist_db'
  AND TABLE_NAME = 'product_category_translation'
ORDER BY ORDINAL_POSITION;


-- ============================================================
-- 2. Find character columns containing unexpected numeric
--    formatting issues
-- ============================================================

SELECT
    customer_zip_code_prefix
FROM customers
WHERE CAST(customer_zip_code_prefix AS CHAR)
      NOT REGEXP '^[0-9]+$';


-- ============================================================
-- 3. Check numeric product attributes
-- ============================================================

SELECT
    product_id,
    product_name_lenght,
    product_description_lenght,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
FROM products
WHERE product_name_lenght IS NOT NULL
   OR product_description_lenght IS NOT NULL
   OR product_photos_qty IS NOT NULL
   OR product_weight_g IS NOT NULL
   OR product_length_cm IS NOT NULL
   OR product_height_cm IS NOT NULL
   OR product_width_cm IS NOT NULL;


-- ============================================================
-- 4. Check payment numeric fields
-- ============================================================

SELECT
    order_id,
    payment_sequential,
    payment_installments,
    payment_value
FROM order_payments
WHERE payment_sequential IS NULL
   OR payment_installments IS NULL
   OR payment_value IS NULL;