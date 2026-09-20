USE olist_DB;

-- ============================================================
-- ORPHAN RECORD CHECKS
-- Purpose:
-- Identify child records whose referenced parent record
-- does not exist.
-- ============================================================


-- ============================================================
-- 1. Orders without a matching customer
-- ============================================================

SELECT
    o.order_id,
    o.customer_id
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


-- ============================================================
-- 2. Order items without a matching order
-- ============================================================

SELECT
    oi.order_id,
    oi.order_item_id
FROM order_items oi
LEFT JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;


-- ============================================================
-- 3. Order items without a matching product
-- ============================================================

SELECT
    oi.order_id,
    oi.order_item_id,
    oi.product_id
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;


-- ============================================================
-- 4. Order items without a matching seller
-- ============================================================

SELECT
    oi.order_id,
    oi.order_item_id,
    oi.seller_id
FROM order_items oi
LEFT JOIN sellers s
    ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL;


-- ============================================================
-- 5. Payments without a matching order
-- ============================================================

SELECT
    op.order_id,
    op.payment_sequential
FROM order_payments op
LEFT JOIN orders o
    ON op.order_id = o.order_id
WHERE o.order_id IS NULL;


-- ============================================================
-- 6. Reviews without a matching order
-- ============================================================

SELECT
    r.review_id,
    r.order_id
FROM order_reviews r
LEFT JOIN orders o
    ON r.order_id = o.order_id
WHERE o.order_id IS NULL;


-- ============================================================
-- 7. Category translations without a matching product category
-- ============================================================

SELECT
    pct.product_category_name,
    pct.product_category_name_english
FROM product_category_translation pct
LEFT JOIN products p
    ON pct.product_category_name = p.product_category_name
WHERE p.product_category_name IS NULL;