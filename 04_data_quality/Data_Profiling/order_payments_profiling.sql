-- ============================================================
-- OLIST RETAIL ANALYSIS
-- ORDER_PAYMENTS TABLE — DATA PROFILING
-- ============================================================

USE olist_db;


-- 1. Inspect table structure
-- Purpose: Understand columns, data types, and schema definition.
DESC order_payments;


-- 2. Establish table size
-- Purpose: Determine the total number of payment records.
SELECT COUNT(*) AS total_payment_records
FROM order_payments;


-- 3. Check the table grain
-- Purpose: Determine how many payment records can exist per order.
SELECT
    order_id,
    COUNT(*) AS payment_record_count
FROM order_payments
GROUP BY order_id
ORDER BY payment_record_count DESC;


-- 4. Check duplicate payment records
-- Purpose: Identify completely duplicated payment rows.
SELECT
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value,
    COUNT(*) AS duplicate_count
FROM order_payments
GROUP BY
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
HAVING COUNT(*) > 1;


-- 5. Check NULL values across all columns
-- Purpose: Identify missing payment information.
SELECT
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END)
        AS order_id_nulls,

    SUM(CASE WHEN payment_sequential IS NULL THEN 1 ELSE 0 END)
        AS payment_sequential_nulls,

    SUM(CASE WHEN payment_type IS NULL THEN 1 ELSE 0 END)
        AS payment_type_nulls,

    SUM(CASE WHEN payment_installments IS NULL THEN 1 ELSE 0 END)
        AS payment_installments_nulls,

    SUM(CASE WHEN payment_value IS NULL THEN 1 ELSE 0 END)
        AS payment_value_nulls
FROM order_payments;


-- 6. Calculate NULL percentages
-- Purpose: Measure the proportion of missing values in each column.
SELECT
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END)
        / COUNT(*) * 100 AS order_id_null_pct,

    SUM(CASE WHEN payment_sequential IS NULL THEN 1 ELSE 0 END)
        / COUNT(*) * 100 AS payment_sequential_null_pct,

    SUM(CASE WHEN payment_type IS NULL THEN 1 ELSE 0 END)
        / COUNT(*) * 100 AS payment_type_null_pct,

    SUM(CASE WHEN payment_installments IS NULL THEN 1 ELSE 0 END)
        / COUNT(*) * 100 AS payment_installments_null_pct,

    SUM(CASE WHEN payment_value IS NULL THEN 1 ELSE 0 END)
        / COUNT(*) * 100 AS payment_value_null_pct
FROM order_payments;


-- 7. Check NULL order IDs
-- Purpose: Identify payment records that cannot be linked to an order.
SELECT *
FROM order_payments
WHERE order_id IS NULL;


-- 8. Check invalid order references
-- Purpose: Verify referential integrity between payments and orders.
SELECT
    op.order_id
FROM order_payments op
LEFT JOIN orders o
    ON op.order_id = o.order_id
WHERE o.order_id IS NULL;


-- 9. Count invalid order references
-- Purpose: Quantify payment records without a matching order.
SELECT COUNT(*) AS invalid_order_references
FROM order_payments op
LEFT JOIN orders o
    ON op.order_id = o.order_id
WHERE o.order_id IS NULL;


-- 10. Check payment type distribution
-- Purpose: Identify all payment methods represented in the dataset.
SELECT
    payment_type,
    COUNT(*) AS payment_record_count
FROM order_payments
GROUP BY payment_type
ORDER BY payment_record_count DESC;


-- 11. Check blank payment types
-- Purpose: Identify empty strings that are not represented as NULL.
SELECT
    COUNT(*) AS blank_payment_type_count
FROM order_payments
WHERE TRIM(payment_type) = '';


-- 12. Validate payment types
-- Purpose: Identify payment types outside the expected Olist values.
SELECT
    payment_type,
    COUNT(*) AS payment_record_count
FROM order_payments
WHERE payment_type NOT IN (
    'credit_card',
    'boleto',
    'voucher',
    'debit_card'
)
OR payment_type IS NULL
GROUP BY payment_type;


-- 13. Check payment sequential values
-- Purpose: Understand the range and distribution of payment sequence numbers.
SELECT
    MIN(payment_sequential) AS min_payment_sequential,
    MAX(payment_sequential) AS max_payment_sequential
FROM order_payments
WHERE payment_sequential IS NOT NULL;


-- 14. Check invalid payment sequential values
-- Purpose: Identify payment sequence values that are zero or negative.
SELECT
    order_id,
    payment_sequential
FROM order_payments
WHERE payment_sequential <= 0;


-- 15. Count invalid payment sequential values
-- Purpose: Quantify invalid payment sequence records.
SELECT
    COUNT(*) AS invalid_payment_sequential_count
FROM order_payments
WHERE payment_sequential <= 0;


-- 16. Check payment sequence gaps within orders
-- Purpose: Identify orders where payment sequence numbering is not continuous.
SELECT
    order_id,
    MIN(payment_sequential) AS min_sequence,
    MAX(payment_sequential) AS max_sequence,
    COUNT(DISTINCT payment_sequential) AS distinct_sequences
FROM order_payments
GROUP BY order_id
HAVING MIN(payment_sequential) <> 1
    OR MAX(payment_sequential) <> COUNT(DISTINCT payment_sequential);


-- 17. Check duplicate payment sequence numbers within an order
-- Purpose: Identify repeated sequence numbers for the same order.
SELECT
    order_id,
    payment_sequential,
    COUNT(*) AS sequence_count
FROM order_payments
GROUP BY
    order_id,
    payment_sequential
HAVING COUNT(*) > 1;


-- 18. Check payment value statistics
-- Purpose: Understand the numerical range of payment values.
SELECT
    MIN(payment_value) AS min_payment_value,
    MAX(payment_value) AS max_payment_value,
    AVG(payment_value) AS avg_payment_value
FROM order_payments
WHERE payment_value IS NOT NULL;


-- 19. Check zero payment values
-- Purpose: Identify payment records with a zero monetary value.
SELECT
    order_id,
    payment_sequential,
    payment_type,
    payment_value
FROM order_payments
WHERE payment_value = 0;


-- 20. Count zero payment values
-- Purpose: Quantify zero-value payment records.
SELECT
    COUNT(*) AS zero_payment_value_count
FROM order_payments
WHERE payment_value = 0;


-- 21. Check negative payment values
-- Purpose: Identify mathematically invalid negative payment amounts.
SELECT
    order_id,
    payment_sequential,
    payment_type,
    payment_value
FROM order_payments
WHERE payment_value < 0;


-- 22. Count negative payment values
-- Purpose: Quantify negative payment records.
SELECT
    COUNT(*) AS negative_payment_value_count
FROM order_payments
WHERE payment_value < 0;


-- 23. Check payment installment statistics
-- Purpose: Understand the range of installment values.
SELECT
    MIN(payment_installments) AS min_installments,
    MAX(payment_installments) AS max_installments,
    AVG(payment_installments) AS avg_installments
FROM order_payments
WHERE payment_installments IS NOT NULL;


-- 24. Check invalid installment values
-- Purpose: Identify zero or negative installment values.
SELECT
    order_id,
    payment_sequential,
    payment_type,
    payment_installments
FROM order_payments
WHERE payment_installments <= 0;


-- 25. Count invalid installment values
-- Purpose: Quantify invalid installment records.
SELECT
    COUNT(*) AS invalid_installment_count
FROM order_payments
WHERE payment_installments <= 0;


-- 26. Check payment type and installment combinations
-- Purpose: Profile how installment values occur across payment methods.
SELECT
    payment_type,
    payment_installments,
    COUNT(*) AS payment_record_count
FROM order_payments
GROUP BY
    payment_type,
    payment_installments
ORDER BY
    payment_type,
    payment_installments;


-- 27. Check unusually high installment values
-- Purpose: Identify records requiring further validation.
SELECT
    order_id,
    payment_sequential,
    payment_type,
    payment_installments
FROM order_payments
WHERE payment_installments > 24
ORDER BY payment_installments DESC;


-- 28. Check payment records per order
-- Purpose: Identify orders having multiple payment records.
SELECT
    order_id,
    COUNT(*) AS payment_record_count
FROM order_payments
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY payment_record_count DESC;


-- 29. Check maximum number of payment records for one order
-- Purpose: Determine the maximum payment-record multiplicity.
SELECT
    MAX(payment_record_count) AS max_payment_records_per_order
FROM (
    SELECT
        order_id,
        COUNT(*) AS payment_record_count
    FROM order_payments
    GROUP BY order_id
) AS payment_counts;


-- 30. Check multiple payment types within an order
-- Purpose: Identify orders containing more than one payment method.
SELECT
    order_id,
    COUNT(DISTINCT payment_type) AS payment_type_count
FROM order_payments
GROUP BY order_id
HAVING COUNT(DISTINCT payment_type) > 1;


-- 31. Check payment records with missing critical attributes
-- Purpose: Create an exception list for incomplete payment records.
SELECT
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
FROM order_payments
WHERE order_id IS NULL
   OR payment_sequential IS NULL
   OR payment_type IS NULL
   OR payment_installments IS NULL
   OR payment_value IS NULL;


-- 32. Count incomplete payment records
-- Purpose: Quantify records missing at least one critical attribute.
SELECT
    COUNT(*) AS incomplete_payment_records
FROM order_payments
WHERE order_id IS NULL
   OR payment_sequential IS NULL
   OR payment_type IS NULL
   OR payment_installments IS NULL
   OR payment_value IS NULL;


-- 33. Check payment value decimal precision
-- Purpose: Identify payment values with more than two decimal places.
SELECT
    order_id,
    payment_sequential,
    payment_value
FROM order_payments
WHERE payment_value IS NOT NULL
  AND payment_value <> ROUND(payment_value, 2);


-- 34. Check payment type vs installment combinations
-- Purpose: Review payment-method/installation patterns for data consistency.
SELECT
    payment_type,
    MIN(payment_installments) AS min_installments,
    MAX(payment_installments) AS max_installments,
    AVG(payment_installments) AS avg_installments
FROM order_payments
GROUP BY payment_type
ORDER BY payment_type;


-- 35. Check order-level payment total
-- Purpose: Profile the total payment amount recorded for each order.
-- This is a data-structure check, not a business revenue analysis.
SELECT
    order_id,
    COUNT(*) AS payment_records,
    SUM(payment_value) AS total_payment_value
FROM order_payments
GROUP BY order_id
ORDER BY total_payment_value DESC;


-- 36. Check orders with zero total payment
-- Purpose: Identify orders whose payment records sum to zero.
SELECT
    order_id,
    SUM(payment_value) AS total_payment_value
FROM order_payments
GROUP BY order_id
HAVING SUM(payment_value) = 0;


-- 37. Check orders with negative total payment
-- Purpose: Identify orders whose payment records sum to a negative amount.
SELECT
    order_id,
    SUM(payment_value) AS total_payment_value
FROM order_payments
GROUP BY order_id
HAVING SUM(payment_value) < 0;


-- 38. Overall order-payments profiling summary
-- Purpose: Produce a compact data-quality summary.
SELECT
    COUNT(*) AS total_payment_records,
    COUNT(DISTINCT order_id) AS distinct_orders,
    COUNT(DISTINCT payment_type) AS distinct_payment_types,
    MIN(payment_value) AS min_payment_value,
    MAX(payment_value) AS max_payment_value,
    AVG(payment_value) AS avg_payment_value,
    MIN(payment_installments) AS min_installments,
    MAX(payment_installments) AS max_installments,
    AVG(payment_installments) AS avg_installments
FROM order_payments;


-- ============================================================
-- END OF ORDER_PAYMENTS DATA PROFILING
-- Next table: ORDER_REVIEWS
-- ============================================================
