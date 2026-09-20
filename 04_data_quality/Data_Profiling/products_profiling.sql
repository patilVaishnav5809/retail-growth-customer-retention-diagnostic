-- ============================================================
-- OLIST RETAIL ANALYSIS
-- PRODUCTS TABLE — DATA PROFILING
-- ============================================================

USE olist_db;


-- 1. Inspect table structure
-- Purpose: Understand columns, data types, keys, and nullability.
DESC products;


-- 2. Establish table size
-- Purpose: Determine the total number of product records.
SELECT COUNT(*) AS total_products
FROM products;


-- 3. Check duplicate product IDs
-- Purpose: product_id should uniquely identify a product.
SELECT
    product_id,
    COUNT(*) AS product_count
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;


-- 4. Check NULL product IDs
-- Purpose: Identify missing product identifiers.
SELECT COUNT(*) AS null_product_ids
FROM products
WHERE product_id IS NULL;


-- 5. Check NULL values across all columns
-- Purpose: Identify missing values in product attributes.
SELECT
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END)
        AS product_id_nulls,

    SUM(CASE WHEN product_category_name IS NULL THEN 1 ELSE 0 END)
        AS category_name_nulls,

    SUM(CASE WHEN product_name_lenght IS NULL THEN 1 ELSE 0 END)
        AS product_name_length_nulls,

    SUM(CASE WHEN product_description_lenght IS NULL THEN 1 ELSE 0 END)
        AS product_description_length_nulls,

    SUM(CASE WHEN product_photos_qty IS NULL THEN 1 ELSE 0 END)
        AS product_photos_qty_nulls,

    SUM(CASE WHEN product_weight_g IS NULL THEN 1 ELSE 0 END)
        AS product_weight_nulls,

    SUM(CASE WHEN product_length_cm IS NULL THEN 1 ELSE 0 END)
        AS product_length_nulls,

    SUM(CASE WHEN product_height_cm IS NULL THEN 1 ELSE 0 END)
        AS product_height_nulls,

    SUM(CASE WHEN product_width_cm IS NULL THEN 1 ELSE 0 END)
        AS product_width_nulls
FROM products;


-- 6. Calculate NULL percentages
-- Purpose: Measure the proportion of missing values in each attribute.
SELECT
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END)
        / COUNT(*) * 100 AS product_id_null_pct,

    SUM(CASE WHEN product_category_name IS NULL THEN 1 ELSE 0 END)
        / COUNT(*) * 100 AS category_name_null_pct,

    SUM(CASE WHEN product_name_lenght IS NULL THEN 1 ELSE 0 END)
        / COUNT(*) * 100 AS product_name_length_null_pct,

    SUM(CASE WHEN product_description_lenght IS NULL THEN 1 ELSE 0 END)
        / COUNT(*) * 100 AS product_description_length_null_pct,

    SUM(CASE WHEN product_photos_qty IS NULL THEN 1 ELSE 0 END)
        / COUNT(*) * 100 AS product_photos_qty_null_pct,

    SUM(CASE WHEN product_weight_g IS NULL THEN 1 ELSE 0 END)
        / COUNT(*) * 100 AS product_weight_null_pct,

    SUM(CASE WHEN product_length_cm IS NULL THEN 1 ELSE 0 END)
        / COUNT(*) * 100 AS product_length_null_pct,

    SUM(CASE WHEN product_height_cm IS NULL THEN 1 ELSE 0 END)
        / COUNT(*) * 100 AS product_height_null_pct,

    SUM(CASE WHEN product_width_cm IS NULL THEN 1 ELSE 0 END)
        / COUNT(*) * 100 AS product_width_null_pct
FROM products;


-- 7. Check category distribution
-- Purpose: Understand how many products belong to each category.
SELECT
    product_category_name,
    COUNT(*) AS product_count
FROM products
GROUP BY product_category_name
ORDER BY product_count DESC;


-- 8. Check missing category records
-- Purpose: Identify products without a category assignment.
SELECT
    COUNT(*) AS uncategorized_products
FROM products
WHERE product_category_name IS NULL;


-- 9. Check blank category values
-- Purpose: Identify category values that are empty strings rather than NULL.
SELECT
    COUNT(*) AS blank_category_values
FROM products
WHERE TRIM(product_category_name) = '';


-- 10. Check product name-length values
-- Purpose: Understand the distribution of stored product-name lengths.
SELECT
    MIN(product_name_lenght) AS min_name_length,
    MAX(product_name_lenght) AS max_name_length,
    AVG(product_name_lenght) AS avg_name_length
FROM products
WHERE product_name_lenght IS NOT NULL;


-- 11. Check invalid product name lengths
-- Purpose: Identify negative or zero name-length values.
SELECT
    product_id,
    product_name_lenght
FROM products
WHERE product_name_lenght <= 0;


-- 12. Check product description lengths
-- Purpose: Understand the distribution of stored description lengths.
SELECT
    MIN(product_description_lenght) AS min_description_length,
    MAX(product_description_lenght) AS max_description_length,
    AVG(product_description_lenght) AS avg_description_length
FROM products
WHERE product_description_lenght IS NOT NULL;


-- 13. Check invalid product description lengths
-- Purpose: Identify negative description-length values.
SELECT
    product_id,
    product_description_lenght
FROM products
WHERE product_description_lenght < 0;


-- 14. Check product photo quantity
-- Purpose: Understand the range of photo counts.
SELECT
    MIN(product_photos_qty) AS min_photo_count,
    MAX(product_photos_qty) AS max_photo_count,
    AVG(product_photos_qty) AS avg_photo_count
FROM products
WHERE product_photos_qty IS NOT NULL;


-- 15. Check invalid photo quantities
-- Purpose: Identify negative photo counts.
SELECT
    product_id,
    product_photos_qty
FROM products
WHERE product_photos_qty < 0;


-- 16. Check zero-photo products
-- Purpose: Identify products with no recorded photos.
SELECT
    COUNT(*) AS zero_photo_products
FROM products
WHERE product_photos_qty = 0;


-- 17. Check product weight distribution
-- Purpose: Understand the range of product weights.
SELECT
    MIN(product_weight_g) AS min_weight_g,
    MAX(product_weight_g) AS max_weight_g,
    AVG(product_weight_g) AS avg_weight_g
FROM products
WHERE product_weight_g IS NOT NULL;


-- 18. Check invalid product weights
-- Purpose: Identify zero or negative product weights.
SELECT
    product_id,
    product_weight_g
FROM products
WHERE product_weight_g <= 0;


-- 19. Check product length distribution
-- Purpose: Understand the range of product lengths.
SELECT
    MIN(product_length_cm) AS min_length_cm,
    MAX(product_length_cm) AS max_length_cm,
    AVG(product_length_cm) AS avg_length_cm
FROM products
WHERE product_length_cm IS NOT NULL;


-- 20. Check invalid product lengths
-- Purpose: Identify zero or negative product lengths.
SELECT
    product_id,
    product_length_cm
FROM products
WHERE product_length_cm <= 0;


-- 21. Check product height distribution
-- Purpose: Understand the range of product heights.
SELECT
    MIN(product_height_cm) AS min_height_cm,
    MAX(product_height_cm) AS max_height_cm,
    AVG(product_height_cm) AS avg_height_cm
FROM products
WHERE product_height_cm IS NOT NULL;


-- 22. Check invalid product heights
-- Purpose: Identify zero or negative product heights.
SELECT
    product_id,
    product_height_cm
FROM products
WHERE product_height_cm <= 0;


-- 23. Check product width distribution
-- Purpose: Understand the range of product widths.
SELECT
    MIN(product_width_cm) AS min_width_cm,
    MAX(product_width_cm) AS max_width_cm,
    AVG(product_width_cm) AS avg_width_cm
FROM products
WHERE product_width_cm IS NOT NULL;


-- 24. Check invalid product widths
-- Purpose: Identify zero or negative product widths.
SELECT
    product_id,
    product_width_cm
FROM products
WHERE product_width_cm <= 0;


-- 25. Check products with any invalid physical measurement
-- Purpose: Create a consolidated exception list for physical attributes.
SELECT
    product_id,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
FROM products
WHERE product_weight_g <= 0
   OR product_length_cm <= 0
   OR product_height_cm <= 0
   OR product_width_cm <= 0;


-- 26. Check products with all physical measurements missing
-- Purpose: Identify products lacking every physical measurement.
SELECT
    product_id
FROM products
WHERE product_weight_g IS NULL
  AND product_length_cm IS NULL
  AND product_height_cm IS NULL
  AND product_width_cm IS NULL;


-- 27. Check products with partial physical measurements
-- Purpose: Identify records where some, but not all, physical
-- measurements are missing.
SELECT
    product_id,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
FROM products
WHERE (
        product_weight_g IS NULL
        OR product_length_cm IS NULL
        OR product_height_cm IS NULL
        OR product_width_cm IS NULL
      )
  AND NOT (
        product_weight_g IS NULL
        AND product_length_cm IS NULL
        AND product_height_cm IS NULL
        AND product_width_cm IS NULL
      );


-- 28. Check extreme product weights
-- Purpose: Identify unusually large product weights for manual review.
SELECT
    product_id,
    product_weight_g
FROM products
WHERE product_weight_g > (
    SELECT AVG(product_weight_g) + 3 * STDDEV(product_weight_g)
    FROM products
    WHERE product_weight_g IS NOT NULL
)
ORDER BY product_weight_g DESC;


-- 29. Check extreme product dimensions
-- Purpose: Identify unusually large dimensions for manual review.
SELECT
    product_id,
    product_length_cm,
    product_height_cm,
    product_width_cm
FROM products
WHERE product_length_cm > (
          SELECT AVG(product_length_cm) + 3 * STDDEV(product_length_cm)
          FROM products
          WHERE product_length_cm IS NOT NULL
      )
   OR product_height_cm > (
          SELECT AVG(product_height_cm) + 3 * STDDEV(product_height_cm)
          FROM products
          WHERE product_height_cm IS NOT NULL
      )
   OR product_width_cm > (
          SELECT AVG(product_width_cm) + 3 * STDDEV(product_width_cm)
          FROM products
          WHERE product_width_cm IS NOT NULL
      );


-- 30. Overall product profiling summary
-- Purpose: Produce a compact quality summary of product attributes.
SELECT
    COUNT(*) AS total_products,
    COUNT(DISTINCT product_id) AS distinct_products,
    COUNT(DISTINCT product_category_name) AS distinct_categories,
    MIN(product_weight_g) AS min_weight_g,
    MAX(product_weight_g) AS max_weight_g,
    AVG(product_weight_g) AS avg_weight_g,
    MIN(product_photos_qty) AS min_photo_count,
    MAX(product_photos_qty) AS max_photo_count,
    AVG(product_photos_qty) AS avg_photo_count,
    MIN(product_length_cm) AS min_length_cm,
    MAX(product_length_cm) AS max_length_cm,
    MIN(product_height_cm) AS min_height_cm,
    MAX(product_height_cm) AS max_height_cm,
    MIN(product_width_cm) AS min_width_cm,
    MAX(product_width_cm) AS max_width_cm
FROM products;


-- ============================================================
-- END OF PRODUCTS TABLE DATA PROFILING
-- Next table: SELLERS
-- ============================================================