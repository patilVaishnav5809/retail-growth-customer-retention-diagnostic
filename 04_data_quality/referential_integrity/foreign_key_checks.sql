USE olist_DB;

-- ============================================================
-- FOREIGN KEY REFERENTIAL INTEGRITY CHECKS
-- Purpose:
-- Validate that every foreign key in a child table
-- corresponds to an existing key in the parent table.
-- ============================================================


-- ============================================================
-- 1. orders.customer_id -> customers.customer_id
-- ============================================================

SELECT COUNT(*) AS invalid_customer_references
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


-- ============================================================
-- 2. order_items.order_id -> orders.order_id
-- ============================================================

SELECT COUNT(*) AS invalid_order_references
FROM order_items oi
LEFT JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;


-- ============================================================
-- 3. order_items.product_id -> products.product_id
-- ============================================================

SELECT COUNT(*) AS invalid_product_references
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;


-- ============================================================
-- 4. order_items.seller_id -> sellers.seller_id
-- ============================================================

SELECT COUNT(*) AS invalid_seller_references
FROM order_items oi
LEFT JOIN sellers s
    ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL;


-- ============================================================
-- 5. order_payments.order_id -> orders.order_id
-- ============================================================

SELECT COUNT(*) AS invalid_payment_order_references
FROM order_payments op
LEFT JOIN orders o
    ON op.order_id = o.order_id
WHERE o.order_id IS NULL;


-- ============================================================
-- 6. order_reviews.order_id -> orders.order_id
-- ============================================================

SELECT COUNT(*) AS invalid_review_order_references
FROM order_reviews r
LEFT JOIN orders o
    ON r.order_id = o.order_id
WHERE o.order_id IS NULL;


-- ============================================================
-- 7. product_category_translation.product_category_name
--    -> products.product_category_name
--
-- Note:
-- product_category_name is not a product-level FK.
-- This validates whether every translated category exists
-- in the products table.
-- ============================================================

SELECT COUNT(*) AS invalid_category_references
FROM product_category_translation pct
LEFT JOIN products p
    ON pct.product_category_name = p.product_category_name
WHERE p.product_category_name IS NULL;