-- ============================================================
-- OLIST RETAIL ANALYSIS
-- SELLERS TABLE — DATA PROFILING
-- ============================================================

USE olist_db;


-- 1. Inspect table structure
-- Purpose: Understand columns, data types, keys, and nullability.
DESC sellers;


-- 2. Establish table size
-- Purpose: Determine the total number of seller records.
SELECT COUNT(*) AS total_sellers
FROM sellers;


-- 3. Check duplicate seller IDs
-- Purpose: seller_id should uniquely identify a seller.
SELECT
    seller_id,
    COUNT(*) AS seller_count
FROM sellers
GROUP BY seller_id
HAVING COUNT(*) > 1;


-- 4. Check NULL seller IDs
-- Purpose: Identify missing seller identifiers.
SELECT COUNT(*) AS null_seller_ids
FROM sellers
WHERE seller_id IS NULL;


-- 5. Check NULL values across all columns
-- Purpose: Identify missing seller location attributes.
SELECT
    SUM(CASE WHEN seller_id IS NULL THEN 1 ELSE 0 END)
        AS seller_id_nulls,

    SUM(CASE WHEN seller_zip_code_prefix IS NULL THEN 1 ELSE 0 END)
        AS zip_code_prefix_nulls,

    SUM(CASE WHEN seller_city IS NULL THEN 1 ELSE 0 END)
        AS city_nulls,

    SUM(CASE WHEN seller_state IS NULL THEN 1 ELSE 0 END)
        AS state_nulls
FROM sellers;


-- 6. Calculate NULL percentages
-- Purpose: Measure the proportion of missing values in each column.
SELECT
    SUM(CASE WHEN seller_id IS NULL THEN 1 ELSE 0 END)
        / COUNT(*) * 100 AS seller_id_null_pct,

    SUM(CASE WHEN seller_zip_code_prefix IS NULL THEN 1 ELSE 0 END)
        / COUNT(*) * 100 AS zip_code_prefix_null_pct,

    SUM(CASE WHEN seller_city IS NULL THEN 1 ELSE 0 END)
        / COUNT(*) * 100 AS city_null_pct,

    SUM(CASE WHEN seller_state IS NULL THEN 1 ELSE 0 END)
        / COUNT(*) * 100 AS state_null_pct
FROM sellers;


-- 7. Check seller ZIP-code-prefix range
-- Purpose: Understand the numerical range of seller ZIP prefixes.
SELECT
    MIN(seller_zip_code_prefix) AS minimum_zip_prefix,
    MAX(seller_zip_code_prefix) AS maximum_zip_prefix
FROM sellers
WHERE seller_zip_code_prefix IS NOT NULL;


-- 8. Check invalid ZIP-code-prefix values
-- Purpose: Identify ZIP prefixes outside the expected 5-digit range.
SELECT
    seller_id,
    seller_zip_code_prefix
FROM sellers
WHERE seller_zip_code_prefix < 0
   OR seller_zip_code_prefix > 99999;


-- 9. Check ZIP-code-prefix distribution
-- Purpose: Identify how sellers are distributed across ZIP prefixes.
SELECT
    seller_zip_code_prefix,
    COUNT(*) AS seller_count
FROM sellers
GROUP BY seller_zip_code_prefix
ORDER BY seller_count DESC;


-- 10. Check seller city distribution
-- Purpose: Identify the number of sellers associated with each city.
SELECT
    seller_city,
    COUNT(*) AS seller_count
FROM sellers
GROUP BY seller_city
ORDER BY seller_count DESC;


-- 11. Check blank seller-city values
-- Purpose: Identify empty strings that are not represented as NULL.
SELECT
    COUNT(*) AS blank_city_count
FROM sellers
WHERE TRIM(seller_city) = '';


-- 12. Check seller state distribution
-- Purpose: Understand the distribution of sellers across states.
SELECT
    seller_state,
    COUNT(*) AS seller_count
FROM sellers
GROUP BY seller_state
ORDER BY seller_count DESC;


-- 13. Validate seller state format
-- Purpose: Identify NULL or incorrectly formatted state codes.
SELECT
    seller_state,
    COUNT(*) AS seller_count
FROM sellers
WHERE seller_state IS NULL
   OR seller_state NOT REGEXP '^[A-Z]{2}$'
GROUP BY seller_state;


-- 14. Check blank seller-state values
-- Purpose: Identify empty state strings that are not represented as NULL.
SELECT
    COUNT(*) AS blank_state_count
FROM sellers
WHERE TRIM(seller_state) = '';


-- 15. Check city/state combinations
-- Purpose: Identify location combinations and their record counts.
SELECT
    seller_city,
    seller_state,
    COUNT(*) AS seller_count
FROM sellers
GROUP BY
    seller_city,
    seller_state
ORDER BY seller_count DESC;


-- 16. Check whether a seller is associated with multiple locations
-- Purpose: Identify seller IDs appearing with multiple city/state combinations.
SELECT
    seller_id,
    COUNT(DISTINCT seller_city) AS city_count,
    COUNT(DISTINCT seller_state) AS state_count
FROM sellers
GROUP BY seller_id
HAVING COUNT(DISTINCT seller_city) > 1
    OR COUNT(DISTINCT seller_state) > 1;


-- 17. Check seller ID length
-- Purpose: Identify seller identifiers that do not follow the expected
-- 32-character hexadecimal UUID-like structure.
SELECT
    seller_id,
    CHAR_LENGTH(seller_id) AS seller_id_length
FROM sellers
WHERE seller_id IS NOT NULL
  AND CHAR_LENGTH(seller_id) <> 32;


-- 18. Check seller ID format
-- Purpose: Identify seller IDs containing characters outside
-- the expected hexadecimal format.
SELECT
    seller_id
FROM sellers
WHERE seller_id IS NOT NULL
  AND seller_id NOT REGEXP '^[0-9a-fA-F]{32}$';


-- 19. Check duplicate location combinations
-- Purpose: Identify how many sellers share the same city/state location.
SELECT
    seller_city,
    seller_state,
    COUNT(*) AS seller_count
FROM sellers
GROUP BY seller_city, seller_state
HAVING COUNT(*) > 1
ORDER BY seller_count DESC;


-- 20. Check sellers with missing location information
-- Purpose: Create an exception list for incomplete seller locations.
SELECT
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
FROM sellers
WHERE seller_zip_code_prefix IS NULL
   OR seller_city IS NULL
   OR seller_state IS NULL;


-- 21. Count sellers with incomplete location information
-- Purpose: Quantify sellers missing at least one location attribute.
SELECT
    COUNT(*) AS incomplete_location_count
FROM sellers
WHERE seller_zip_code_prefix IS NULL
   OR seller_city IS NULL
   OR seller_state IS NULL;


-- 22. Check consistency between ZIP prefix and state
-- Purpose: Identify ZIP-prefix/state combinations that occur in the data.
-- This is a profiling output; it does not by itself establish that
-- a combination is geographically invalid.
SELECT
    seller_state,
    seller_zip_code_prefix,
    COUNT(*) AS seller_count
FROM sellers
GROUP BY
    seller_state,
    seller_zip_code_prefix
ORDER BY seller_state, seller_zip_code_prefix;


-- 23. Count distinct seller cities
-- Purpose: Determine the number of unique seller cities represented.
SELECT
    COUNT(DISTINCT seller_city) AS distinct_seller_cities
FROM sellers
WHERE seller_city IS NOT NULL;


-- 24. Count distinct seller states
-- Purpose: Determine the number of unique seller states represented.
SELECT
    COUNT(DISTINCT seller_state) AS distinct_seller_states
FROM sellers
WHERE seller_state IS NOT NULL;


-- 25. Count distinct seller ZIP prefixes
-- Purpose: Determine the number of unique ZIP prefixes represented.
SELECT
    COUNT(DISTINCT seller_zip_code_prefix) AS distinct_zip_prefixes
FROM sellers
WHERE seller_zip_code_prefix IS NOT NULL;


-- 26. Overall seller profiling summary
-- Purpose: Produce a compact quality summary of seller records.
SELECT
    COUNT(*) AS total_sellers,
    COUNT(DISTINCT seller_id) AS distinct_sellers,
    COUNT(DISTINCT seller_city) AS distinct_cities,
    COUNT(DISTINCT seller_state) AS distinct_states,
    COUNT(DISTINCT seller_zip_code_prefix) AS distinct_zip_prefixes,
    MIN(seller_zip_code_prefix) AS min_zip_prefix,
    MAX(seller_zip_code_prefix) AS max_zip_prefix
FROM sellers;


-- ============================================================
-- END OF SELLERS TABLE DATA PROFILING
-- Next table: ORDER_PAYMENTS
-- ============================================================