USE olist_DB;

-- ============================================================
-- RELATIONSHIP CONSISTENCY CHECKS
-- Purpose:
-- Validate expected parent-child relationships.
-- These checks are different from simple FK validation because
-- they also identify missing child relationships.
-- ============================================================


-- ============================================================
-- 1. Customers without any orders
-- ============================================================

SELECT
    c.customer_id
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


-- ============================================================
-- 2. Orders without any order items
-- ============================================================

SELECT
    o.order_id
FROM orders o
LEFT JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE oi.order_id IS NULL;


-- ============================================================
-- 3. Orders without any payment records
-- ============================================================

SELECT
    o.order_id
FROM orders o
LEFT JOIN order_payments op
    ON o.order_id = op.order_id
WHERE op.order_id IS NULL;


-- ============================================================
-- 4. Orders without any review
--
-- This is an exception check, not necessarily a data-quality
-- failure because customers are not required to submit reviews.
-- ============================================================

SELECT
    o.order_id
FROM orders o
LEFT JOIN order_reviews r
    ON o.order_id = r.order_id
WHERE r.order_id IS NULL;


-- ============================================================
-- 5. Products without any order items
-- ============================================================

SELECT
    p.product_id
FROM products p
LEFT JOIN order_items oi
    ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;


-- ============================================================
-- 6. Sellers without any order items
-- ============================================================

SELECT
    s.seller_id
FROM sellers s
LEFT JOIN order_items oi
    ON s.seller_id = oi.seller_id
WHERE oi.seller_id IS NULL;


-- ============================================================
-- 7. Product categories without translation
-- ============================================================

SELECT DISTINCT
    p.product_category_name
FROM products p
LEFT JOIN product_category_translation pct
    ON p.product_category_name = pct.product_category_name
WHERE p.product_category_name IS NOT NULL
  AND pct.product_category_name IS NULL;