-- ============================================================
-- QUALITY CHECKS
-- FILE: date_validation.sql
-- PURPOSE: Validate chronological and temporal relationships
-- ============================================================

USE olist_db;


-- ============================================================
-- ORDERS
-- ============================================================

-- 1. Approval cannot occur before purchase
SELECT
    order_id,
    order_purchase_timestamp,
    order_approved_at
FROM orders
WHERE order_approved_at IS NOT NULL
  AND order_approved_at < order_purchase_timestamp;


-- 2. Carrier delivery cannot occur before purchase
SELECT
    order_id,
    order_purchase_timestamp,
    order_delivered_carrier_date
FROM orders
WHERE order_delivered_carrier_date IS NOT NULL
  AND order_delivered_carrier_date < order_purchase_timestamp;


-- 3. Customer delivery cannot occur before purchase
SELECT
    order_id,
    order_purchase_timestamp,
    order_delivered_customer_date
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_delivered_customer_date < order_purchase_timestamp;


-- 4. Customer delivery cannot occur before carrier delivery
SELECT
    order_id,
    order_delivered_carrier_date,
    order_delivered_customer_date
FROM orders
WHERE order_delivered_carrier_date IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
  AND order_delivered_customer_date < order_delivered_carrier_date;


-- 5. Estimated delivery cannot be before purchase
SELECT
    order_id,
    order_purchase_timestamp,
    order_estimated_delivery_date
FROM orders
WHERE order_estimated_delivery_date IS NOT NULL
  AND order_estimated_delivery_date < order_purchase_timestamp;


-- 6. Delivery dates should not exist for impossible states
-- This identifies records for review rather than automatically
-- declaring them invalid.
SELECT
    order_id,
    order_status,
    order_delivered_carrier_date,
    order_delivered_customer_date
FROM orders
WHERE order_status IN ('created', 'approved', 'processing')
  AND (
      order_delivered_carrier_date IS NOT NULL
      OR order_delivered_customer_date IS NOT NULL
  );


-- ============================================================
-- ORDER_ITEMS
-- ============================================================

-- 7. Shipping limit date cannot be before order purchase
SELECT
    oi.order_id,
    oi.order_item_id,
    o.order_purchase_timestamp,
    oi.shipping_limit_date
FROM order_items oi
INNER JOIN orders o
    ON oi.order_id = o.order_id
WHERE oi.shipping_limit_date < o.order_purchase_timestamp;


-- ============================================================
-- ORDER_REVIEWS
-- ============================================================

-- 8. Review creation cannot occur before order purchase
SELECT
    r.review_id,
    r.order_id,
    o.order_purchase_timestamp,
    r.review_creation_date
FROM order_reviews r
INNER JOIN orders o
    ON r.order_id = o.order_id
WHERE r.review_creation_date < o.order_purchase_timestamp;


-- 9. Review answer cannot occur before review creation
SELECT
    review_id,
    order_id,
    review_creation_date,
    review_answer_timestamp
FROM order_reviews
WHERE review_answer_timestamp IS NOT NULL
  AND review_creation_date IS NOT NULL
  AND review_answer_timestamp < review_creation_date;


-- 10. Review creation before customer delivery
-- This is an exception check for investigation.
SELECT
    r.review_id,
    r.order_id,
    o.order_delivered_customer_date,
    r.review_creation_date
FROM order_reviews r
INNER JOIN orders o
    ON r.order_id = o.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
  AND r.review_creation_date IS NOT NULL
  AND r.review_creation_date < o.order_delivered_customer_date;