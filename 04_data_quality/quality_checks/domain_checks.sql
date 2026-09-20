-- ============================================================
-- QUALITY CHECKS
-- FILE: domain_checks.sql
-- PURPOSE: Validate allowed values and numerical ranges
-- ============================================================

USE olist_db;


-- ============================================================
-- CUSTOMERS
-- ============================================================

-- 1. Customer state must use two uppercase characters
SELECT *
FROM customers
WHERE customer_state IS NULL
   OR customer_state NOT REGEXP '^[A-Z]{2}$';


-- 2. Customer ZIP prefix must be within numeric range
SELECT *
FROM customers
WHERE customer_zip_code_prefix IS NOT NULL
  AND (
      customer_zip_code_prefix < 0
      OR customer_zip_code_prefix > 99999
  );


-- ============================================================
-- ORDERS
-- ============================================================

-- 3. Order status must belong to the known status domain
SELECT
    order_id,
    order_status
FROM orders
WHERE order_status NOT IN (
    'delivered',
    'shipped',
    'canceled',
    'unavailable',
    'invoiced',
    'processing',
    'created',
    'approved'
)
OR order_status IS NULL;


-- ============================================================
-- ORDER_ITEMS
-- ============================================================

-- 4. Price cannot be negative
SELECT *
FROM order_items
WHERE price < 0;


-- 5. Freight value cannot be negative
SELECT *
FROM order_items
WHERE freight_value < 0;


-- 6. Order item sequence must be positive
SELECT *
FROM order_items
WHERE order_item_id <= 0;


-- ============================================================
-- PRODUCTS
-- ============================================================

-- 7. Product name length cannot be negative
SELECT *
FROM products
WHERE product_name_lenght < 0;


-- 8. Product description length cannot be negative
SELECT *
FROM products
WHERE product_description_lenght < 0;


-- 9. Product photo quantity cannot be negative
SELECT *
FROM products
WHERE product_photos_qty < 0;


-- 10. Product weight cannot be negative
SELECT *
FROM products
WHERE product_weight_g < 0;


-- 11. Product length cannot be negative
SELECT *
FROM products
WHERE product_length_cm < 0;


-- 12. Product height cannot be negative
SELECT *
FROM products
WHERE product_height_cm < 0;


-- 13. Product width cannot be negative
SELECT *
FROM products
WHERE product_width_cm < 0;


-- ============================================================
-- SELLERS
-- ============================================================

-- 14. Seller state must use two uppercase characters
SELECT *
FROM sellers
WHERE seller_state IS NULL
   OR seller_state NOT REGEXP '^[A-Z]{2}$';


-- 15. Seller ZIP prefix must be within expected range
SELECT *
FROM sellers
WHERE seller_zip_code_prefix IS NOT NULL
  AND (
      seller_zip_code_prefix < 0
      OR seller_zip_code_prefix > 99999
  );


-- ============================================================
-- ORDER_PAYMENTS
-- ============================================================

-- 16. Payment type must belong to allowed domain
SELECT *
FROM order_payments
WHERE payment_type NOT IN (
    'credit_card',
    'boleto',
    'voucher',
    'debit_card'
)
OR payment_type IS NULL;


-- 17. Payment sequence must be positive
SELECT *
FROM order_payments
WHERE payment_sequential <= 0;


-- 18. Payment installments must be positive
SELECT *
FROM order_payments
WHERE payment_installments <= 0;


-- 19. Payment value cannot be negative
SELECT *
FROM order_payments
WHERE payment_value < 0;


-- ============================================================
-- ORDER_REVIEWS
-- ============================================================

-- 20. Review score must be between 1 and 5
SELECT *
FROM order_reviews
WHERE review_score NOT BETWEEN 1 AND 5
   OR review_score IS NULL;


-- ============================================================
-- GEO_LOC
-- ============================================================

-- 21. Latitude must be between -90 and +90
SELECT *
FROM geo_loc
WHERE geolocation_lat < -90
   OR geolocation_lat > 90;


-- 22. Longitude must be between -180 and +180
SELECT *
FROM geo_loc
WHERE geolocation_lng < -180
   OR geolocation_lng > 180;


-- 23. ZIP prefix must be within expected range
SELECT *
FROM geo_loc
WHERE geolocation_zip_code_prefix IS NOT NULL
  AND (
      geolocation_zip_code_prefix < 0
      OR geolocation_zip_code_prefix > 99999
  );


-- 24. State code must follow two-letter format
SELECT *
FROM geo_loc
WHERE geolocation_state IS NULL
   OR geolocation_state NOT REGEXP '^[A-Z]{2}$';


-- ============================================================
-- PRODUCT_CATEGORY_TRANSLATION
-- ============================================================

-- 25. Check blank Portuguese category names
SELECT *
FROM product_category_translation
WHERE product_category_name IS NULL
   OR TRIM(product_category_name) = '';


-- 26. Check blank English category names
SELECT *
FROM product_category_translation
WHERE product_category_name_english IS NULL
   OR TRIM(product_category_name_english) = '';