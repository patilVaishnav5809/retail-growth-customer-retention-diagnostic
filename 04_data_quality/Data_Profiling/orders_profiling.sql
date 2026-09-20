

USE olist_db;


-- 1. Inspect table structure
-- Purpose: Understand columns, data types, keys, and nullability.
DESC orders;


-- 2. Establish table size
-- Purpose: Determine the total number of order records.
SELECT COUNT(*) AS total_orders
FROM orders;


-- 3. Check duplicate order IDs
-- Purpose: order_id should uniquely identify an order.
SELECT
    order_id,
    COUNT(*) AS order_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;


-- 4. Check NULL order IDs
-- Purpose: Identify missing values in the order identifier.
SELECT COUNT(*) AS null_order_ids
FROM orders
WHERE order_id IS NULL;


-- 5. Check NULL customer IDs
-- Purpose: Identify orders without an associated customer.
SELECT COUNT(*) AS null_customer_ids
FROM orders
WHERE customer_id IS NULL;


-- 6. Check NULL values across all columns
-- Purpose: Get a complete view of missing data in the table.
SELECT
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS order_id_nulls,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS customer_id_nulls,
    SUM(CASE WHEN order_status IS NULL THEN 1 ELSE 0 END) AS order_status_nulls,
    SUM(CASE WHEN order_purchase_timestamp IS NULL THEN 1 ELSE 0 END) AS purchase_timestamp_nulls,
    SUM(CASE WHEN order_approved_at IS NULL THEN 1 ELSE 0 END) AS approved_timestamp_nulls,
    SUM(CASE WHEN order_delivered_carrier_date IS NULL THEN 1 ELSE 0 END) AS carrier_delivery_nulls,
    SUM(CASE WHEN order_delivered_customer_date IS NULL THEN 1 ELSE 0 END) AS customer_delivery_nulls,
    SUM(CASE WHEN order_estimated_delivery_date IS NULL THEN 1 ELSE 0 END) AS estimated_delivery_nulls
FROM orders;


-- 7. Calculate NULL percentages
-- Purpose: Measure the proportion of missing values in each column.
SELECT
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100 AS order_id_null_pct,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100 AS customer_id_null_pct,
    SUM(CASE WHEN order_status IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100 AS order_status_null_pct,
    SUM(CASE WHEN order_purchase_timestamp IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100 AS purchase_timestamp_null_pct,
    SUM(CASE WHEN order_approved_at IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100 AS approved_timestamp_null_pct,
    SUM(CASE WHEN order_delivered_carrier_date IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100 AS carrier_delivery_null_pct,
    SUM(CASE WHEN order_delivered_customer_date IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100 AS customer_delivery_null_pct,
    SUM(CASE WHEN order_estimated_delivery_date IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100 AS estimated_delivery_null_pct
FROM orders;


-- 8. Check order status distribution
-- Purpose: Understand the number of orders in each lifecycle status.
SELECT
    order_status,
    COUNT(*) AS order_count
FROM orders
GROUP BY order_status;


-- 9. Validate order statuses
-- Purpose: Identify unexpected or NULL order status values.
SELECT
    order_status,
    COUNT(*) AS order_count
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
OR order_status IS NULL
GROUP BY order_status;


-- 10. Find the overall purchase date range
-- Purpose: Determine the earliest and latest order purchase timestamps.
SELECT
    MIN(order_purchase_timestamp) AS earliest_purchase,
    MAX(order_purchase_timestamp) AS latest_purchase
FROM orders;


-- 11. Yearly order distribution
-- Purpose: Understand how order volume is distributed across years.
SELECT
    YEAR(order_purchase_timestamp) AS year,
    COUNT(*) AS order_count
FROM orders
GROUP BY year
ORDER BY year;


-- 12. Check approval timestamp consistency
-- Purpose: Identify orders approved before they were purchased.
SELECT
    order_id,
    order_purchase_timestamp,
    order_approved_at
FROM orders
WHERE order_approved_at < order_purchase_timestamp;


-- 13. Check carrier delivery timestamp consistency
-- Purpose: Identify carrier delivery dates occurring before purchase.
SELECT
    order_id,
    order_purchase_timestamp,
    order_delivered_carrier_date
FROM orders
WHERE order_delivered_carrier_date < order_purchase_timestamp;


-- 14. Check customer delivery timestamp consistency
-- Purpose: Identify customer delivery dates occurring before purchase.
SELECT
    order_id,
    order_purchase_timestamp,
    order_delivered_customer_date
FROM orders
WHERE order_delivered_customer_date < order_purchase_timestamp;


-- 15. Check carrier-to-customer delivery sequence
-- Purpose: Customer delivery should not occur before carrier delivery.
SELECT
    order_id,
    order_delivered_carrier_date,
    order_delivered_customer_date
FROM orders
WHERE order_delivered_customer_date < order_delivered_carrier_date;


-- 16. Identify late deliveries
-- Purpose: Find orders delivered after the estimated delivery date.
SELECT
    order_id,
    order_delivered_customer_date,
    order_estimated_delivery_date
FROM orders
WHERE order_delivered_customer_date > order_estimated_delivery_date;


-- 17. Check customer referential integrity
-- Purpose: Identify orders whose customer_id does not exist in customers.
SELECT
    o.order_id,
    o.customer_id
FROM orders o
WHERE o.customer_id NOT IN (
    SELECT customer_id
    FROM customers
);


-- 18. Delivered orders missing customer delivery date
-- Purpose: A delivered order should normally have a customer delivery timestamp.
SELECT
    order_id,
    order_status,
    order_delivered_customer_date
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NULL;


-- 19. Non-delivered orders with customer delivery date
-- Purpose: Identify possible status/date inconsistencies.
SELECT
    order_id,
    order_status,
    order_delivered_customer_date
FROM orders
WHERE order_status <> 'delivered'
  AND order_delivered_customer_date IS NOT NULL;


-- 20. Delivered orders missing carrier delivery date
-- Purpose: Check whether delivered orders have a carrier delivery timestamp.
SELECT
    order_id,
    order_status,
    order_delivered_carrier_date
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_carrier_date IS NULL;


-- 21. Order status percentage
-- Purpose: Measure the proportion of total orders represented by each status.
SELECT
    order_status,
    COUNT(*) AS order_count,
    COUNT(*) / (SELECT COUNT(*) FROM orders) * 100 AS order_percentage
FROM orders
GROUP BY order_status;


-- 22. Average approval time
-- Purpose: Check the typical elapsed time between purchase and approval.
SELECT
    AVG(
        TIMESTAMPDIFF(
            MINUTE,
            order_purchase_timestamp,
            order_approved_at
        )
    ) AS avg_approval_minutes
FROM orders
WHERE order_purchase_timestamp IS NOT NULL
  AND order_approved_at IS NOT NULL;


-- 23. Minimum and maximum approval time
-- Purpose: Detect unusually short or long purchase-to-approval durations.
SELECT
    MIN(
        TIMESTAMPDIFF(
            MINUTE,
            order_purchase_timestamp,
            order_approved_at
        )
    ) AS min_approval_minutes,
    MAX(
        TIMESTAMPDIFF(
            MINUTE,
            order_purchase_timestamp,
            order_approved_at
        )
    ) AS max_approval_minutes
FROM orders
WHERE order_purchase_timestamp IS NOT NULL
  AND order_approved_at IS NOT NULL;


-- 24. Count invalid approval sequences
-- Purpose: Quantify orders where approval occurred before purchase.
SELECT
    COUNT(*) AS invalid_approval_sequence_count
FROM orders
WHERE order_approved_at < order_purchase_timestamp;


-- 25. Average delivery duration
-- Purpose: Check the typical elapsed time between purchase and customer delivery.
SELECT
    AVG(
        TIMESTAMPDIFF(
            DAY,
            order_purchase_timestamp,
            order_delivered_customer_date
        )
    ) AS avg_delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;


-- 26. Minimum and maximum delivery duration
-- Purpose: Detect unusually short or long purchase-to-delivery durations.
SELECT
    MIN(
        TIMESTAMPDIFF(
            DAY,
            order_purchase_timestamp,
            order_delivered_customer_date
        )
    ) AS min_delivery_days,
    MAX(
        TIMESTAMPDIFF(
            DAY,
            order_purchase_timestamp,
            order_delivered_customer_date
        )
    ) AS max_delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;


-- 27. Count invalid purchase-to-delivery sequences
-- Purpose: Quantify orders where customer delivery occurred before purchase.
SELECT
    COUNT(*) AS invalid_delivery_sequence_count
FROM orders
WHERE order_delivered_customer_date < order_purchase_timestamp;


-- 28. Count invalid purchase-to-carrier sequences
-- Purpose: Quantify orders where carrier delivery occurred before purchase.
SELECT
    COUNT(*) AS invalid_carrier_delivery_sequence_count
FROM orders
WHERE order_delivered_carrier_date < order_purchase_timestamp;


-- 29. Count invalid carrier-to-customer sequences
-- Purpose: Quantify orders where customer delivery occurred before carrier delivery.
SELECT
    COUNT(*) AS invalid_carrier_customer_sequence_count
FROM orders
WHERE order_delivered_customer_date < order_delivered_carrier_date;


-- 30. Late-delivery percentage
-- Purpose: Measure the percentage of orders with actual delivery after the estimate.
SELECT
    SUM(
        CASE
            WHEN order_delivered_customer_date > order_estimated_delivery_date
            THEN 1
            ELSE 0
        END
    ) / COUNT(*) * 100 AS late_delivery_percentage
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL;


-- 31. Average actual-vs-estimated delivery difference
-- Purpose: Measure the average difference between actual and estimated delivery dates.
SELECT
    AVG(
        DATEDIFF(
            order_delivered_customer_date,
            order_estimated_delivery_date
        )
    ) AS avg_delivery_difference_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL;


-- 32. Minimum and maximum actual-vs-estimated difference
-- Purpose: Detect extreme differences between actual and estimated delivery dates.
SELECT
    MIN(
        DATEDIFF(
            order_delivered_customer_date,
            order_estimated_delivery_date
        )
    ) AS min_delivery_difference_days,
    MAX(
        DATEDIFF(
            order_delivered_customer_date,
            order_estimated_delivery_date
        )
    ) AS max_delivery_difference_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL;


-- 33. Orders delivered before estimated date
-- Purpose: Count orders delivered earlier than the estimated date.
SELECT
    COUNT(*) AS early_delivery_count
FROM orders
WHERE order_delivered_customer_date < order_estimated_delivery_date;


-- 34. Orders delivered exactly on estimated date
-- Purpose: Count orders delivered on the estimated delivery date.
SELECT
    COUNT(*) AS on_time_delivery_count
FROM orders
WHERE order_delivered_customer_date = order_estimated_delivery_date;


-- 35. Delivered orders missing estimated delivery date
-- Purpose: Check whether delivered orders have an estimated delivery date.
SELECT
    order_id,
    order_delivered_customer_date,
    order_estimated_delivery_date
FROM orders
WHERE order_status = 'delivered'
  AND order_estimated_delivery_date IS NULL;


-- 36. Non-delivered orders with carrier delivery date
-- Purpose: Identify status/date inconsistencies involving carrier delivery.
SELECT
    order_id,
    order_status,
    order_delivered_carrier_date
FROM orders
WHERE order_status <> 'delivered'
  AND order_delivered_carrier_date IS NOT NULL;


-- 37. Invalid estimated delivery date
-- Purpose: Identify estimated delivery dates occurring before purchase.
SELECT
    order_id,
    order_purchase_timestamp,
    order_estimated_delivery_date
FROM orders
WHERE order_estimated_delivery_date < order_purchase_timestamp;


-- 38. Count invalid estimated delivery dates
-- Purpose: Quantify orders where estimated delivery occurs before purchase.
SELECT
    COUNT(*) AS invalid_estimated_delivery_count
FROM orders
WHERE order_estimated_delivery_date < order_purchase_timestamp;



