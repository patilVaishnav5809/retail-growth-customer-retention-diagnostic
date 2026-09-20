-- ============================================================
-- QUALITY CHECKS
-- FILE: business_rule_checks.sql
-- PURPOSE: Validate cross-table and business consistency rules
-- ============================================================

USE olist_db;


-- ============================================================
-- REFERENTIAL INTEGRITY
-- ============================================================

-- 1. Every order customer must exist in customers
SELECT
    o.order_id,
    o.customer_id
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


-- 2. Every order item order_id must exist in orders
SELECT
    oi.order_id,
    oi.order_item_id
FROM order_items oi
LEFT JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;


-- 3. Every order item product_id must exist in products
SELECT
    oi.order_id,
    oi.product_id
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;


-- 4. Every order item seller_id must exist in sellers
SELECT
    oi.order_id,
    oi.seller_id
FROM order_items oi
LEFT JOIN sellers s
    ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL;


-- 5. Every payment order_id must exist in orders
SELECT
    op.order_id
FROM order_payments op
LEFT JOIN orders o
    ON op.order_id = o.order_id
WHERE o.order_id IS NULL;


-- 6. Every review order_id must exist in orders
SELECT
    r.review_id,
    r.order_id
FROM order_reviews r
LEFT JOIN orders o
    ON r.order_id = o.order_id
WHERE o.order_id IS NULL;


-- 7. Every category translation must correspond to a product category
SELECT
    pct.product_category_name,
    pct.product_category_name_english
FROM product_category_translation pct
LEFT JOIN products p
    ON pct.product_category_name = p.product_category_name
WHERE p.product_category_name IS NULL;


-- ============================================================
-- ORDER STATUS RULES
-- ============================================================

-- 8. Delivered orders must have customer delivery date
SELECT
    order_id,
    order_status,
    order_delivered_customer_date
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NULL;


-- 9. Delivered orders must have carrier delivery date
SELECT
    order_id,
    order_status,
    order_delivered_carrier_date
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_carrier_date IS NULL;


-- 10. Delivered orders must have estimated delivery date
SELECT
    order_id,
    order_status,
    order_estimated_delivery_date
FROM orders
WHERE order_status = 'delivered'
  AND order_estimated_delivery_date IS NULL;


-- 11. Non-delivered orders with customer delivery date
SELECT
    order_id,
    order_status,
    order_delivered_customer_date
FROM orders
WHERE order_status <> 'delivered'
  AND order_delivered_customer_date IS NOT NULL;


-- 12. Non-delivered orders with carrier delivery date
SELECT
    order_id,
    order_status,
    order_delivered_carrier_date
FROM orders
WHERE order_status IN (
    'created',
    'approved',
    'processing'
)
AND order_delivered_carrier_date IS NOT NULL;


-- ============================================================
-- ORDER ITEM RULES
-- ============================================================

-- 13. Order item sequence should start at 1
SELECT
    order_id,
    MIN(order_item_id) AS minimum_item_id
FROM order_items
GROUP BY order_id
HAVING MIN(order_item_id) <> 1;


-- 14. Order item numbering should not contain gaps
SELECT
    order_id,
    MAX(order_item_id) AS max_item_id,
    COUNT(DISTINCT order_item_id) AS item_count
FROM order_items
GROUP BY order_id
HAVING MAX(order_item_id) <> COUNT(DISTINCT order_item_id);


-- ============================================================
-- PAYMENT RULES
-- ============================================================

-- 15. Payment sequence should start at 1 for each order
SELECT
    order_id,
    MIN(payment_sequential) AS minimum_payment_sequence
FROM order_payments
GROUP BY order_id
HAVING MIN(payment_sequential) <> 1;


-- 16. Payment sequence should not contain gaps
SELECT
    order_id,
    MAX(payment_sequential) AS max_sequence,
    COUNT(DISTINCT payment_sequential) AS sequence_count
FROM order_payments
GROUP BY order_id
HAVING MAX(payment_sequential) <> COUNT(DISTINCT payment_sequential);


-- 17. Credit-card payments should have positive installments
SELECT
    order_id,
    payment_sequential,
    payment_type,
    payment_installments
FROM order_payments
WHERE payment_type = 'credit_card'
  AND payment_installments <= 0;


-- ============================================================
-- REVIEW RULES
-- ============================================================

-- 18. Review score must be valid
SELECT
    review_id,
    order_id,
    review_score
FROM order_reviews
WHERE review_score NOT BETWEEN 1 AND 5
   OR review_score IS NULL;


-- 19. Review answer cannot precede review creation
SELECT
    review_id,
    order_id,
    review_creation_date,
    review_answer_timestamp
FROM order_reviews
WHERE review_answer_timestamp IS NOT NULL
  AND review_creation_date IS NOT NULL
  AND review_answer_timestamp < review_creation_date;


-- ============================================================
-- PRODUCT RULES
-- ============================================================

-- 20. Product physical dimensions should not be negative
SELECT
    product_id,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
FROM products
WHERE product_weight_g < 0
   OR product_length_cm < 0
   OR product_height_cm < 0
   OR product_width_cm < 0;


-- 21. Product photo quantity should not be negative
SELECT
    product_id,
    product_photos_qty
FROM products
WHERE product_photos_qty < 0;


-- ============================================================
-- LOCATION RULES
-- ============================================================

-- 22. Customer ZIP prefix should be within valid range
SELECT
    customer_id,
    customer_zip_code_prefix
FROM customers
WHERE customer_zip_code_prefix < 0
   OR customer_zip_code_prefix > 99999;


-- 23. Seller ZIP prefix should be within valid range
SELECT
    seller_id,
    seller_zip_code_prefix
FROM sellers
WHERE seller_zip_code_prefix < 0
   OR seller_zip_code_prefix > 99999;


-- 24. Geographic latitude should be valid
SELECT
    geolocation_zip_code_prefix,
    geolocation_lat
FROM geo_loc
WHERE geolocation_lat < -90
   OR geolocation_lat > 90;


-- 25. Geographic longitude should be valid
SELECT
    geolocation_zip_code_prefix,
    geolocation_lng
FROM geo_loc
WHERE geolocation_lng < -180
   OR geolocation_lng > 180;


-- ============================================================
-- ORDER/PAYMENT CONSISTENCY
-- ============================================================

-- 26. Every order should have at least one payment record
SELECT
    o.order_id
FROM orders o
LEFT JOIN order_payments op
    ON o.order_id = op.order_id
WHERE op.order_id IS NULL;


-- 27. Every order should have at least one order item
SELECT
    o.order_id
FROM orders o
LEFT JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE oi.order_id IS NULL;


-- ============================================================
-- ORDER/REVIEW CONSISTENCY
-- ============================================================

-- 28. Delivered orders without a review
-- This is an exception check, not necessarily a data-quality error.
SELECT
    o.order_id
FROM orders o
LEFT JOIN order_reviews r
    ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND r.order_id IS NULL;


-- ============================================================
-- PAYMENT/ORDER ITEM CONSISTENCY
-- ============================================================

-- 29. Compare orders represented in payments and order items
SELECT
    op.order_id
FROM order_payments op
LEFT JOIN order_items oi
    ON op.order_id = oi.order_id
WHERE oi.order_id IS NULL;


-- 30. Compare order item orders with payment orders
SELECT
    oi.order_id
FROM order_items oi
LEFT JOIN order_payments op
    ON oi.order_id = op.order_id
WHERE op.order_id IS NULL;