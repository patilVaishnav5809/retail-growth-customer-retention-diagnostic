USE olist_DB;

-- ============================================================
-- BUSINESS RECONCILIATION
-- Purpose:
-- Validate that important business measures remain consistent
-- when calculated through different tables or aggregation levels.
--
-- This file is for reconciliation only.
-- It should NOT contain KPI analysis or business insights.
-- ============================================================


-- ============================================================
-- 1. TOTAL REVENUE RECONCILIATION
--
-- Revenue from order_items should equal revenue obtained after
-- first aggregating order_items to the order level.
-- ============================================================

SELECT
    SUM(price) AS direct_item_revenue
FROM order_items;


SELECT
    SUM(order_revenue) AS order_level_revenue
FROM (
    SELECT
        order_id,
        SUM(price) AS order_revenue
    FROM order_items
    GROUP BY order_id
) x;


-- ============================================================
-- 2. REVENUE RECONCILIATION DIFFERENCE
--
-- Expected difference = 0
-- ============================================================

SELECT
    direct_revenue,
    aggregated_revenue,
    direct_revenue - aggregated_revenue AS reconciliation_difference
FROM
(
    SELECT
        SUM(price) AS direct_revenue
    FROM order_items
) a
CROSS JOIN
(
    SELECT
        SUM(order_revenue) AS aggregated_revenue
    FROM
    (
        SELECT
            order_id,
            SUM(price) AS order_revenue
        FROM order_items
        GROUP BY order_id
    ) x
) b;


-- ============================================================
-- 3. PAYMENT VALUE RECONCILIATION
--
-- Total payment_value should equal the sum of order-level
-- payment totals.
-- ============================================================

SELECT
    SUM(payment_value) AS direct_payment_value
FROM order_payments;


SELECT
    SUM(order_payment_value) AS order_level_payment_value
FROM
(
    SELECT
        order_id,
        SUM(payment_value) AS order_payment_value
    FROM order_payments
    GROUP BY order_id
) x;


-- ============================================================
-- 4. PAYMENT RECONCILIATION DIFFERENCE
--
-- Expected difference = 0
-- ============================================================

SELECT
    direct_payment_value,
    aggregated_payment_value,
    direct_payment_value - aggregated_payment_value
        AS reconciliation_difference
FROM
(
    SELECT
        SUM(payment_value) AS direct_payment_value
    FROM order_payments
) a
CROSS JOIN
(
    SELECT
        SUM(order_payment_value) AS aggregated_payment_value
    FROM
    (
        SELECT
            order_id,
            SUM(payment_value) AS order_payment_value
        FROM order_payments
        GROUP BY order_id
    ) x
) b;


-- ============================================================
-- 5. ORDER COUNT RECONCILIATION
--
-- Compare total orders with orders represented in order_items.
-- ============================================================

SELECT
    COUNT(DISTINCT order_id) AS total_orders
FROM orders;


SELECT
    COUNT(DISTINCT order_id) AS orders_with_items
FROM order_items;


-- ============================================================
-- 6. ORDERS WITHOUT ITEMS
--
-- This identifies the difference between the two populations.
-- ============================================================

SELECT
    COUNT(*) AS orders_without_items
FROM orders o
LEFT JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE oi.order_id IS NULL;


-- ============================================================
-- 7. ORDER COUNT RECONCILIATION
-- Using explicit population difference.
-- ============================================================

SELECT
    (SELECT COUNT(DISTINCT order_id)
     FROM orders)
    -
    (SELECT COUNT(DISTINCT order_id)
     FROM order_items)
    AS order_item_coverage_difference;


-- ============================================================
-- 8. PAYMENT ORDER COVERAGE RECONCILIATION
--
-- Compare orders with payment records against total orders.
-- ============================================================

SELECT
    COUNT(DISTINCT order_id) AS total_orders
FROM orders;


SELECT
    COUNT(DISTINCT order_id) AS orders_with_payments
FROM order_payments;


-- ============================================================
-- 9. ORDERS WITHOUT PAYMENTS
-- ============================================================

SELECT
    COUNT(*) AS orders_without_payments
FROM orders o
LEFT JOIN order_payments op
    ON o.order_id = op.order_id
WHERE op.order_id IS NULL;


-- ============================================================
-- 10. CUSTOMER REVENUE RECONCILIATION
--
-- Revenue calculated directly from order_items and revenue
-- calculated after aggregating each order first should agree.
-- ============================================================

SELECT
    SUM(oi.price) AS direct_customer_revenue
FROM orders o
INNER JOIN order_items oi
    ON o.order_id = oi.order_id;


SELECT
    SUM(order_revenue) AS aggregated_customer_revenue
FROM
(
    SELECT
        o.order_id,
        SUM(oi.price) AS order_revenue
    FROM orders o
    INNER JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY o.order_id
) x;


-- ============================================================
-- 11. CUSTOMER REVENUE RECONCILIATION DIFFERENCE
-- ============================================================

SELECT
    direct_revenue,
    aggregated_revenue,
    direct_revenue - aggregated_revenue
        AS reconciliation_difference
FROM
(
    SELECT
        SUM(oi.price) AS direct_revenue
    FROM orders o
    INNER JOIN order_items oi
        ON o.order_id = oi.order_id
) a
CROSS JOIN
(
    SELECT
        SUM(order_revenue) AS aggregated_revenue
    FROM
    (
        SELECT
            o.order_id,
            SUM(oi.price) AS order_revenue
        FROM orders o
        INNER JOIN order_items oi
            ON o.order_id = oi.order_id
        GROUP BY o.order_id
    ) x
) b;


-- ============================================================
-- 12. ORDER-LEVEL REVENUE VS PAYMENT VALUE
--
-- Compare merchandise revenue (price) with payment value.
--
-- IMPORTANT:
-- This is a reconciliation comparison, NOT an assertion that
-- the two values must be equal.
-- Payment value may include freight and other payment components.
-- ============================================================

SELECT
    order_id,
    SUM(price) AS item_revenue,
    (
        SELECT SUM(op.payment_value)
        FROM order_payments op
        WHERE op.order_id = oi.order_id
    ) AS payment_value
FROM order_items oi
GROUP BY order_id;


-- ============================================================
-- 13. ORDERS WITH PAYMENT VALUE LOWER THAN ITEM REVENUE
--
-- Exception report for further investigation.
-- This does NOT automatically indicate bad data.
-- ============================================================

SELECT
    x.order_id,
    x.item_revenue,
    x.payment_value,
    x.item_revenue - x.payment_value AS difference
FROM
(
    SELECT
        oi.order_id,
        SUM(oi.price) AS item_revenue,
        (
            SELECT SUM(op.payment_value)
            FROM order_payments op
            WHERE op.order_id = oi.order_id
        ) AS payment_value
    FROM order_items oi
    GROUP BY oi.order_id
) x
WHERE x.payment_value < x.item_revenue;


-- ============================================================
-- 14. ORDER ITEM REVENUE + FREIGHT RECONCILIATION
--
-- Calculate the merchandise value and freight value at the
-- order level to provide a comparable order-level structure.
-- ============================================================

SELECT
    order_id,
    SUM(price) AS item_revenue,
    SUM(freight_value) AS freight_value,
    SUM(price + freight_value) AS merchandise_plus_freight
FROM order_items
GROUP BY order_id;


-- ============================================================
-- 15. PAYMENT VS ITEM + FREIGHT EXCEPTION CHECK
--
-- Identifies orders where payment value differs from the
-- calculated item + freight amount.
--
-- Difference can occur for legitimate reasons and should be
-- investigated rather than automatically treated as an error.
-- ============================================================

SELECT
    x.order_id,
    x.item_plus_freight,
    x.payment_value,
    x.payment_value - x.item_plus_freight AS difference
FROM
(
    SELECT
        oi.order_id,
        SUM(oi.price + oi.freight_value) AS item_plus_freight,
        (
            SELECT SUM(op.payment_value)
            FROM order_payments op
            WHERE op.order_id = oi.order_id
        ) AS payment_value
    FROM order_items oi
    GROUP BY oi.order_id
) x
WHERE x.payment_value <> x.item_plus_freight;


-- ============================================================
-- 16. FINAL BUSINESS RECONCILIATION SUMMARY
--
-- Provides high-level reconciliation indicators.
-- ============================================================

SELECT
    (SELECT COUNT(DISTINCT order_id)
     FROM orders) AS total_orders,

    (SELECT COUNT(DISTINCT order_id)
     FROM order_items) AS orders_with_items,

    (SELECT COUNT(DISTINCT order_id)
     FROM order_payments) AS orders_with_payments,

    (SELECT SUM(price)
     FROM order_items) AS total_item_revenue,

    (SELECT SUM(payment_value)
     FROM order_payments) AS total_payment_value,

    (SELECT SUM(freight_value)
     FROM order_items) AS total_freight_value;