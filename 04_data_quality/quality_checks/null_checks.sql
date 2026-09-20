-- ============================================================
-- QUALITY CHECKS
-- FILE: null_checks.sql
-- PURPOSE: Check mandatory fields for NULL values
-- ============================================================

USE olist_db;


-- ============================================================
-- CUSTOMERS
-- ============================================================

-- 1. customer_id must not be NULL
SELECT *
FROM customers
WHERE customer_id IS NULL;


-- 2. customer_unique_id must not be NULL
SELECT *
FROM customers
WHERE customer_unique_id IS NULL;


-- 3. customer_zip_code_prefix must not be NULL
SELECT *
FROM customers
WHERE customer_zip_code_prefix IS NULL;


-- 4. customer_city must not be NULL
SELECT *
FROM customers
WHERE customer_city IS NULL;


-- 5. customer_state must not be NULL
SELECT *
FROM customers
WHERE customer_state IS NULL;


-- ============================================================
-- ORDERS
-- ============================================================

-- 6. order_id must not be NULL
SELECT *
FROM orders
WHERE order_id IS NULL;


-- 7. customer_id must not be NULL
SELECT *
FROM orders
WHERE customer_id IS NULL;


-- 8. order_status must not be NULL
SELECT *
FROM orders
WHERE order_status IS NULL;


-- 9. order_purchase_timestamp must not be NULL
SELECT *
FROM orders
WHERE order_purchase_timestamp IS NULL;


-- ============================================================
-- ORDER_ITEMS
-- ============================================================

-- 10. order_id must not be NULL
SELECT *
FROM order_items
WHERE order_id IS NULL;


-- 11. order_item_id must not be NULL
SELECT *
FROM order_items
WHERE order_item_id IS NULL;


-- 12. product_id must not be NULL
SELECT *
FROM order_items
WHERE product_id IS NULL;


-- 13. seller_id must not be NULL
SELECT *
FROM order_items
WHERE seller_id IS NULL;


-- 14. shipping_limit_date must not be NULL
SELECT *
FROM order_items
WHERE shipping_limit_date IS NULL;


-- 15. price must not be NULL
SELECT *
FROM order_items
WHERE price IS NULL;


-- 16. freight_value must not be NULL
SELECT *
FROM order_items
WHERE freight_value IS NULL;


-- ============================================================
-- PRODUCTS
-- ============================================================

-- 17. product_id must not be NULL
SELECT *
FROM products
WHERE product_id IS NULL;


-- ============================================================
-- SELLERS
-- ============================================================

-- 18. seller_id must not be NULL
SELECT *
FROM sellers
WHERE seller_id IS NULL;


-- 19. seller_zip_code_prefix must not be NULL
SELECT *
FROM sellers
WHERE seller_zip_code_prefix IS NULL;


-- 20. seller_city must not be NULL
SELECT *
FROM sellers
WHERE seller_city IS NULL;


-- 21. seller_state must not be NULL
SELECT *
FROM sellers
WHERE seller_state IS NULL;


-- ============================================================
-- ORDER_PAYMENTS
-- ============================================================

-- 22. order_id must not be NULL
SELECT *
FROM order_payments
WHERE order_id IS NULL;


-- 23. payment_sequential must not be NULL
SELECT *
FROM order_payments
WHERE payment_sequential IS NULL;


-- 24. payment_type must not be NULL
SELECT *
FROM order_payments
WHERE payment_type IS NULL;


-- 25. payment_installments must not be NULL
SELECT *
FROM order_payments
WHERE payment_installments IS NULL;


-- 26. payment_value must not be NULL
SELECT *
FROM order_payments
WHERE payment_value IS NULL;


-- ============================================================
-- ORDER_REVIEWS
-- ============================================================

-- 27. review_id must not be NULL
SELECT *
FROM order_reviews
WHERE review_id IS NULL;


-- 28. order_id must not be NULL
SELECT *
FROM order_reviews
WHERE order_id IS NULL;


-- 29. review_score must not be NULL
SELECT *
FROM order_reviews
WHERE review_score IS NULL;


-- 30. review_creation_date must not be NULL
SELECT *
FROM order_reviews
WHERE review_creation_date IS NULL;


-- ============================================================
-- GEO_LOC
-- ============================================================

-- 31. ZIP prefix must not be NULL
SELECT *
FROM geo_loc
WHERE geolocation_zip_code_prefix IS NULL;


-- 32. Latitude must not be NULL
SELECT *
FROM geo_loc
WHERE geolocation_lat IS NULL;


-- 33. Longitude must not be NULL
SELECT *
FROM geo_loc
WHERE geolocation_lng IS NULL;


-- 34. City must not be NULL
SELECT *
FROM geo_loc
WHERE geolocation_city IS NULL;


-- 35. State must not be NULL
SELECT *
FROM geo_loc
WHERE geolocation_state IS NULL;


-- ============================================================
-- PRODUCT_CATEGORY_TRANSLATION
-- ============================================================

-- 36. product_category_name must not be NULL
SELECT *
FROM product_category_translation
WHERE product_category_name IS NULL;


-- 37. product_category_name_english must not be NULL
SELECT *
FROM product_category_translation
WHERE product_category_name_english IS NULL;