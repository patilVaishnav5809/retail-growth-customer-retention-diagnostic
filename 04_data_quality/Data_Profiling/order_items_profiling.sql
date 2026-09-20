USE olist_db;


-- 1. Inspect table structure
-- Purpose: Understand columns, data types, keys, and nullability.
DESC order_items;


-- 2. Establish table size
-- Purpose: Determine the total number of order-item records.
SELECT COUNT(*) AS total_order_items
FROM order_items;


-- 3. Check composite-key uniqueness
-- Purpose: (order_id, order_item_id) should uniquely identify
-- each item within an order.
SELECT
    order_id,
    order_item_id,
    COUNT(*) AS item_count
FROM order_items
GROUP BY order_id, order_item_id
HAVING COUNT(*) > 1;


-- 4. Check NULL values across all columns
-- Purpose: Identify missing values in the order_items table.
SELECT
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS order_id_nulls,
    SUM(CASE WHEN order_item_id IS NULL THEN 1 ELSE 0 END) AS order_item_id_nulls,
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS product_id_nulls,
    SUM(CASE WHEN seller_id IS NULL THEN 1 ELSE 0 END) AS seller_id_nulls,
    SUM(CASE WHEN shipping_limit_date IS NULL THEN 1 ELSE 0 END) AS shipping_limit_date_nulls,
    SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END) AS price_nulls,
    SUM(CASE WHEN freight_value IS NULL THEN 1 ELSE 0 END) AS freight_value_nulls
FROM order_items;


-- 5. Calculate NULL percentages
-- Purpose: Measure the proportion of missing values in each column.
SELECT
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100
        AS order_id_null_pct,

    SUM(CASE WHEN order_item_id IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100
        AS order_item_id_null_pct,

    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100
        AS product_id_null_pct,

    SUM(CASE WHEN seller_id IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100
        AS seller_id_null_pct,

    SUM(CASE WHEN shipping_limit_date IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100
        AS shipping_limit_date_null_pct,

    SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100
        AS price_null_pct,

    SUM(CASE WHEN freight_value IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100
        AS freight_value_null_pct
FROM order_items;


-- 6. Check order_id referential integrity
-- Purpose: Identify order_items records whose order_id
-- does not exist in the orders table.
SELECT
    oi.order_id
FROM order_items oi
LEFT JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;


-- 7. Count invalid order_id references
-- Purpose: Quantify order_items records without a matching order.
SELECT
    COUNT(*) AS invalid_order_id_count
FROM order_items oi
LEFT JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;


-- 8. Check product_id referential integrity
-- Purpose: Identify order_items records whose product_id
-- does not exist in the products table.
SELECT
    oi.product_id
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;


-- 9. Count invalid product_id references
-- Purpose: Quantify order_items records without a matching product.
SELECT
    COUNT(*) AS invalid_product_id_count
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;


-- 10. Check seller_id referential integrity
-- Purpose: Identify order_items records whose seller_id
-- does not exist in the sellers table.
SELECT
    oi.seller_id
FROM order_items oi
LEFT JOIN sellers s
    ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL;


-- 11. Count invalid seller_id references
-- Purpose: Quantify order_items records without a matching seller.
SELECT
    COUNT(*) AS invalid_seller_id_count
FROM order_items oi
LEFT JOIN sellers s
    ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL;


-- 12. Check order_item_id distribution
-- Purpose: Understand how many item positions occur within orders.
SELECT
    order_item_id,
    COUNT(*) AS record_count
FROM order_items
GROUP BY order_item_id
ORDER BY order_item_id;


-- 13. Find orders with unusually high item counts
-- Purpose: Identify orders containing a large number of items
-- that may require data-quality review.
SELECT
    order_id,
    COUNT(*) AS item_count
FROM order_items
GROUP BY order_id
ORDER BY item_count DESC
LIMIT 20;


-- 14. Check for zero or negative prices
-- Purpose: Identify potentially invalid item prices.
SELECT
    order_id,
    order_item_id,
    product_id,
    price
FROM order_items
WHERE price <= 0;


-- 15. Count zero or negative prices
-- Purpose: Quantify potentially invalid item prices.
SELECT
    COUNT(*) AS invalid_price_count
FROM order_items
WHERE price <= 0;


-- 16. Check for zero or negative freight values
-- Purpose: Identify potentially invalid freight values.
SELECT
    order_id,
    order_item_id,
    freight_value
FROM order_items
WHERE freight_value < 0;


-- 17. Count negative freight values
-- Purpose: Quantify potentially invalid freight values.
SELECT
    COUNT(*) AS negative_freight_count
FROM order_items
WHERE freight_value < 0;


-- 18. Check zero freight values
-- Purpose: Identify records with no freight charge.
-- This is a profiling check, not automatically a data-quality error.
SELECT
    COUNT(*) AS zero_freight_count
FROM order_items
WHERE freight_value = 0;


-- 19. Check price distribution
-- Purpose: Understand the minimum, maximum, and average item price.
SELECT
    MIN(price) AS minimum_price,
    MAX(price) AS maximum_price,
    AVG(price) AS average_price
FROM order_items;


-- 20. Check freight-value distribution
-- Purpose: Understand the minimum, maximum, and average freight value.
SELECT
    MIN(freight_value) AS minimum_freight,
    MAX(freight_value) AS maximum_freight,
    AVG(freight_value) AS average_freight
FROM order_items;


-- 21. Check shipping-limit date range
-- Purpose: Determine the temporal coverage of shipping-limit dates.
SELECT
    MIN(shipping_limit_date) AS earliest_shipping_limit,
    MAX(shipping_limit_date) AS latest_shipping_limit
FROM order_items;


-- 22. Check invalid shipping-limit dates
-- Purpose: Identify shipping-limit dates that occur before
-- the associated order purchase timestamp.
SELECT
    oi.order_id,
    o.order_purchase_timestamp,
    oi.shipping_limit_date
FROM order_items oi
INNER JOIN orders o
    ON oi.order_id = o.order_id
WHERE oi.shipping_limit_date < o.order_purchase_timestamp;


-- 23. Count invalid shipping-limit dates
-- Purpose: Quantify records where shipping limit occurs
-- before order purchase.
SELECT
    COUNT(*) AS invalid_shipping_limit_count
FROM order_items oi
INNER JOIN orders o
    ON oi.order_id = o.order_id
WHERE oi.shipping_limit_date < o.order_purchase_timestamp;


-- 24. Check duplicate product-seller combinations within an order
-- Purpose: Identify cases where the same product from the same seller
-- appears multiple times within one order.
SELECT
    order_id,
    product_id,
    seller_id,
    COUNT(*) AS combination_count
FROM order_items
GROUP BY
    order_id,
    product_id,
    seller_id
HAVING COUNT(*) > 1;


-- 25. Check whether item numbering is continuous within orders
-- Purpose: Identify orders where item positions may contain gaps.
SELECT
    order_id,
    MAX(order_item_id) AS max_item_number,
    COUNT(*) AS item_count
FROM order_items
GROUP BY order_id
HAVING MAX(order_item_id) <> COUNT(*);


-- 26. Check first item numbering
-- Purpose: Identify orders whose first item does not start at position 1.
SELECT
    order_id,
    MIN(order_item_id) AS first_item_number
FROM order_items
GROUP BY order_id
HAVING MIN(order_item_id) <> 1;


-- 27. Check price NULL or invalid values together
-- Purpose: Create a focused exception list for item pricing.
SELECT
    order_id,
    order_item_id,
    product_id,
    price
FROM order_items
WHERE price IS NULL
   OR price <= 0;


-- 28. Check freight NULL or invalid values together
-- Purpose: Create a focused exception list for freight values.
SELECT
    order_id,
    order_item_id,
    freight_value
FROM order_items
WHERE freight_value IS NULL
   OR freight_value < 0;


-- 29. Check whether shipping_limit_date is NULL for records
-- Purpose: Create an exception list for missing shipping-limit dates.
SELECT
    order_id,
    order_item_id,
    shipping_limit_date
FROM order_items
WHERE shipping_limit_date IS NULL;


-- 30. Overall order_items profiling summary
-- Purpose: Produce a compact quality summary for key item attributes.
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT order_id) AS distinct_orders,
    COUNT(DISTINCT product_id) AS distinct_products,
    COUNT(DISTINCT seller_id) AS distinct_sellers,
    MIN(price) AS min_price,
    MAX(price) AS max_price,
    AVG(price) AS avg_price,
    MIN(freight_value) AS min_freight_value,
    MAX(freight_value) AS max_freight_value,
    AVG(freight_value) AS avg_freight_value
FROM order_items;