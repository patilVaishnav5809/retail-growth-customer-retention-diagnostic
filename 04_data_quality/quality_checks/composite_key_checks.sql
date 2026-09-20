-- ============================================================
-- KEY VALIDATION
-- FILE: composite_key_checks.sql
-- PURPOSE: Validate composite keys
-- ============================================================

USE olist_db;


-- ============================================================
-- ORDER_ITEMS
-- Composite key: (order_id, order_item_id)
-- ============================================================

-- 1. Check NULL values in composite key
SELECT
    order_id,
    order_item_id
FROM order_items
WHERE order_id IS NULL
   OR order_item_id IS NULL;


-- 2. Check duplicate composite key
SELECT
    order_id,
    order_item_id,
    COUNT(*) AS record_count
FROM order_items
GROUP BY
    order_id,
    order_item_id
HAVING COUNT(*) > 1;


-- 3. Composite-key summary
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT
        CONCAT(order_id, '|', order_item_id)
    ) AS distinct_composite_keys
FROM order_items;


-- 4. Check whether number of rows equals number of composite keys
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT
        CONCAT(order_id, '|', order_item_id)
    ) AS distinct_keys,
    CASE
        WHEN COUNT(*) =
             COUNT(DISTINCT CONCAT(order_id, '|', order_item_id))
        THEN 'PASS'
        ELSE 'FAIL'
    END AS key_validation_status
FROM order_items;


-- ============================================================
-- ORDER_PAYMENTS
-- Composite key: (order_id, payment_sequential)
-- ============================================================

-- 5. Check NULL values in composite key
SELECT
    order_id,
    payment_sequential
FROM order_payments
WHERE order_id IS NULL
   OR payment_sequential IS NULL;


-- 6. Check duplicate composite key
SELECT
    order_id,
    payment_sequential,
    COUNT(*) AS record_count
FROM order_payments
GROUP BY
    order_id,
    payment_sequential
HAVING COUNT(*) > 1;


-- 7. Composite-key summary
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT
        CONCAT(order_id, '|', payment_sequential)
    ) AS distinct_composite_keys
FROM order_payments;


-- 8. Check whether number of rows equals number of composite keys
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT
        CONCAT(order_id, '|', payment_sequential)
    ) AS distinct_keys,
    CASE
        WHEN COUNT(*) =
             COUNT(DISTINCT CONCAT(order_id, '|', payment_sequential))
        THEN 'PASS'
        ELSE 'FAIL'
    END AS key_validation_status
FROM order_payments;


-- ============================================================
-- ORDER-LEVEL ITEM NUMBERING
-- Supporting composite-key integrity check
-- ============================================================

-- 9. Check that item numbering starts at 1
SELECT
    order_id,
    MIN(order_item_id) AS minimum_item_id
FROM order_items
GROUP BY order_id
HAVING MIN(order_item_id) <> 1;


-- 10. Check for gaps in item numbering
SELECT
    order_id,
    MAX(order_item_id) AS maximum_item_id,
    COUNT(DISTINCT order_item_id) AS item_count
FROM order_items
GROUP BY order_id
HAVING MAX(order_item_id) <> COUNT(DISTINCT order_item_id);


-- ============================================================
-- PAYMENT SEQUENCE
-- Supporting composite-key integrity check
-- ============================================================

-- 11. Check that payment numbering starts at 1
SELECT
    order_id,
    MIN(payment_sequential) AS minimum_payment_sequence
FROM order_payments
GROUP BY order_id
HAVING MIN(payment_sequential) <> 1;


-- 12. Check for gaps in payment sequence
SELECT
    order_id,
    MAX(payment_sequential) AS maximum_payment_sequence,
    COUNT(DISTINCT payment_sequential) AS payment_count
FROM order_payments
GROUP BY order_id
HAVING MAX(payment_sequential) <> COUNT(DISTINCT payment_sequential);