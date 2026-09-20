-- ========================
--  cross_table_checks.sql
-- ========================

 /* This should contain structural/numeric consistency checks across tables, without turning them into business KPIs.*/


USE olist_DB;

 --  Orders vs order items
-- ============================================================
-- 1. Orders with no corresponding order items
-- ============================================================

SELECT
    o.order_id
FROM orders o
LEFT JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE oi.order_id IS NULL;

--  Order items belonging to orders
-- ============================================================
-- 2. Order-item count by order
-- Used to reconcile order-level records with item-level records
-- ============================================================

SELECT
    o.order_id,
    COUNT(oi.order_item_id) AS item_count
FROM orders o
LEFT JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY o.order_id;

--  Orders vs payments
-- ============================================================
-- 3. Orders without payment records
-- ============================================================

SELECT
    o.order_id
FROM orders o
LEFT JOIN order_payments op
    ON o.order_id = op.order_id
WHERE op.order_id IS NULL;
-- Payment totals at order level
-- ============================================================
-- 4. Reconcile payment records into order-level payment totals
-- ============================================================

SELECT
    o.order_id,
    COALESCE(SUM(op.payment_value), 0) AS total_payment_value
FROM orders o
LEFT JOIN order_payments op
    ON o.order_id = op.order_id
GROUP BY o.order_id;

--  Orders vs reviews
-- ============================================================
-- 5. Reconcile review records against orders
-- ============================================================

SELECT
    o.order_id,
    COUNT(r.review_id) AS review_count
FROM orders o
LEFT JOIN order_reviews r
    ON o.order_id = r.order_id
GROUP BY o.order_id;

-- Products vs order items
-- ============================================================
-- 6. Products with no order-item references
-- ============================================================

SELECT
    p.product_id
FROM products p
LEFT JOIN order_items oi
    ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

-- Sellers vs order items
-- ============================================================
-- 7. Sellers with no order-item references
-- ============================================================

SELECT
    s.seller_id
FROM sellers s
LEFT JOIN order_items oi
    ON s.seller_id = oi.seller_id
WHERE oi.seller_id IS NULL;