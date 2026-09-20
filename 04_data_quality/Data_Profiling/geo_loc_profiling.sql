-- ============================================================
-- OLIST RETAIL ANALYSIS
-- GEO_LOC TABLE — DATA PROFILING
-- ============================================================

USE olist_db;


-- 1. Inspect table structure
-- Purpose: Understand columns, data types, keys, and schema definition.
DESC geo_loc;


-- 2. Establish table size
-- Purpose: Determine the total number of geographic records.
SELECT
    COUNT(*) AS total_geo_records
FROM geo_loc;


-- 3. Check duplicate geographic keys
-- Purpose: Identify repeated ZIP-code prefixes or geographic identifiers.
SELECT
    geolocation_zip_code_prefix,
    COUNT(*) AS record_count
FROM geo_loc
GROUP BY geolocation_zip_code_prefix
HAVING COUNT(*) > 1
ORDER BY record_count DESC;


-- 4. Check NULL values across all columns
-- Purpose: Identify missing geographic information.
SELECT
    SUM(CASE
        WHEN geolocation_zip_code_prefix IS NULL
        THEN 1 ELSE 0
    END) AS zip_prefix_nulls,

    SUM(CASE
        WHEN geolocation_lat IS NULL
        THEN 1 ELSE 0
    END) AS latitude_nulls,

    SUM(CASE
        WHEN geolocation_lng IS NULL
        THEN 1 ELSE 0
    END) AS longitude_nulls,

    SUM(CASE
        WHEN geolocation_city IS NULL
        THEN 1 ELSE 0
    END) AS city_nulls,

    SUM(CASE
        WHEN geolocation_state IS NULL
        THEN 1 ELSE 0
    END) AS state_nulls
FROM geo_loc;


-- 5. Calculate NULL percentages
-- Purpose: Measure the proportion of missing values in each geographic field.
SELECT
    SUM(CASE
        WHEN geolocation_zip_code_prefix IS NULL
        THEN 1 ELSE 0
    END) / COUNT(*) * 100 AS zip_prefix_null_pct,

    SUM(CASE
        WHEN geolocation_lat IS NULL
        THEN 1 ELSE 0
    END) / COUNT(*) * 100 AS latitude_null_pct,

    SUM(CASE
        WHEN geolocation_lng IS NULL
        THEN 1 ELSE 0
    END) / COUNT(*) * 100 AS longitude_null_pct,

    SUM(CASE
        WHEN geolocation_city IS NULL
        THEN 1 ELSE 0
    END) / COUNT(*) * 100 AS city_null_pct,

    SUM(CASE
        WHEN geolocation_state IS NULL
        THEN 1 ELSE 0
    END) / COUNT(*) * 100 AS state_null_pct
FROM geo_loc;


-- 6. Check blank city values
-- Purpose: Identify empty city strings that are not stored as NULL.
SELECT
    COUNT(*) AS blank_city_count
FROM geo_loc
WHERE geolocation_city IS NOT NULL
  AND TRIM(geolocation_city) = '';


-- 7. Check blank state values
-- Purpose: Identify empty state strings that are not stored as NULL.
SELECT
    COUNT(*) AS blank_state_count
FROM geo_loc
WHERE geolocation_state IS NOT NULL
  AND TRIM(geolocation_state) = '';


-- 8. Check ZIP-code-prefix range
-- Purpose: Understand the numerical range of geographic ZIP prefixes.
SELECT
    MIN(geolocation_zip_code_prefix) AS min_zip_prefix,
    MAX(geolocation_zip_code_prefix) AS max_zip_prefix
FROM geo_loc
WHERE geolocation_zip_code_prefix IS NOT NULL;


-- 9. Check invalid ZIP-code-prefix values
-- Purpose: Identify ZIP prefixes outside the expected numerical range.
SELECT
    geolocation_zip_code_prefix
FROM geo_loc
WHERE geolocation_zip_code_prefix < 0
   OR geolocation_zip_code_prefix > 99999;


-- 10. Count invalid ZIP-code-prefix values
-- Purpose: Quantify ZIP prefixes outside the expected range.
SELECT
    COUNT(*) AS invalid_zip_prefix_count
FROM geo_loc
WHERE geolocation_zip_code_prefix < 0
   OR geolocation_zip_code_prefix > 99999;


-- 11. Check latitude range
-- Purpose: Identify latitude values outside the valid geographic range.
SELECT
    MIN(geolocation_lat) AS min_latitude,
    MAX(geolocation_lat) AS max_latitude
FROM geo_loc
WHERE geolocation_lat IS NOT NULL;


-- 12. Check invalid latitude values
-- Purpose: Identify latitude values outside -90 to +90 degrees.
SELECT
    geolocation_zip_code_prefix,
    geolocation_lat
FROM geo_loc
WHERE geolocation_lat < -90
   OR geolocation_lat > 90;


-- 13. Count invalid latitude values
-- Purpose: Quantify geographically invalid latitude records.
SELECT
    COUNT(*) AS invalid_latitude_count
FROM geo_loc
WHERE geolocation_lat < -90
   OR geolocation_lat > 90;


-- 14. Check longitude range
-- Purpose: Identify longitude values outside the valid geographic range.
SELECT
    MIN(geolocation_lng) AS min_longitude,
    MAX(geolocation_lng) AS max_longitude
FROM geo_loc
WHERE geolocation_lng IS NOT NULL;


-- 15. Check invalid longitude values
-- Purpose: Identify longitude values outside -180 to +180 degrees.
SELECT
    geolocation_zip_code_prefix,
    geolocation_lng
FROM geo_loc
WHERE geolocation_lng < -180
   OR geolocation_lng > 180;


-- 16. Count invalid longitude values
-- Purpose: Quantify geographically invalid longitude records.
SELECT
    COUNT(*) AS invalid_longitude_count
FROM geo_loc
WHERE geolocation_lng < -180
   OR geolocation_lng > 180;


-- 17. Check zero coordinates
-- Purpose: Identify records where latitude or longitude equals zero.
-- Zero is not automatically invalid, so these are profiling exceptions.
SELECT
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng
FROM geo_loc
WHERE geolocation_lat = 0
   OR geolocation_lng = 0;


-- 18. Count zero-coordinate records
-- Purpose: Quantify records containing zero latitude or longitude.
SELECT
    COUNT(*) AS zero_coordinate_count
FROM geo_loc
WHERE geolocation_lat = 0
   OR geolocation_lng = 0;


-- 19. Check missing coordinate pairs
-- Purpose: Identify records missing either latitude or longitude.
SELECT
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng
FROM geo_loc
WHERE geolocation_lat IS NULL
   OR geolocation_lng IS NULL;


-- 20. Count incomplete coordinate pairs
-- Purpose: Quantify records with incomplete geographic coordinates.
SELECT
    COUNT(*) AS incomplete_coordinate_count
FROM geo_loc
WHERE geolocation_lat IS NULL
   OR geolocation_lng IS NULL;


-- 21. Check duplicate coordinate pairs
-- Purpose: Identify geographic records sharing exactly the same coordinates.
SELECT
    geolocation_lat,
    geolocation_lng,
    COUNT(*) AS coordinate_record_count
FROM geo_loc
GROUP BY
    geolocation_lat,
    geolocation_lng
HAVING COUNT(*) > 1
ORDER BY coordinate_record_count DESC;


-- 22. Count distinct ZIP prefixes
-- Purpose: Determine geographic ZIP-prefix coverage.
SELECT
    COUNT(DISTINCT geolocation_zip_code_prefix)
        AS distinct_zip_prefixes
FROM geo_loc
WHERE geolocation_zip_code_prefix IS NOT NULL;


-- 23. Count distinct cities
-- Purpose: Determine the number of geographic city values.
SELECT
    COUNT(DISTINCT geolocation_city)
        AS distinct_cities
FROM geo_loc
WHERE geolocation_city IS NOT NULL;


-- 24. Count distinct states
-- Purpose: Determine the number of geographic state values.
SELECT
    COUNT(DISTINCT geolocation_state)
        AS distinct_states
FROM geo_loc
WHERE geolocation_state IS NOT NULL;


-- 25. State distribution
-- Purpose: Profile geographic records across states.
SELECT
    geolocation_state,
    COUNT(*) AS geo_record_count
FROM geo_loc
GROUP BY geolocation_state
ORDER BY geo_record_count DESC;


-- 26. Validate state-code format
-- Purpose: Identify NULL or incorrectly formatted state codes.
SELECT
    geolocation_state,
    COUNT(*) AS record_count
FROM geo_loc
WHERE geolocation_state IS NULL
   OR geolocation_state NOT REGEXP '^[A-Z]{2}$'
GROUP BY geolocation_state;


-- 27. City distribution
-- Purpose: Profile the geographic records by city.
SELECT
    geolocation_city,
    COUNT(*) AS geo_record_count
FROM geo_loc
GROUP BY geolocation_city
ORDER BY geo_record_count DESC;


-- 28. ZIP-prefix distribution
-- Purpose: Identify ZIP prefixes with the highest number of geographic records.
SELECT
    geolocation_zip_code_prefix,
    COUNT(*) AS geo_record_count
FROM geo_loc
GROUP BY geolocation_zip_code_prefix
ORDER BY geo_record_count DESC;


-- 29. Check multiple cities for the same ZIP prefix
-- Purpose: Identify ZIP prefixes associated with multiple city values.
SELECT
    geolocation_zip_code_prefix,
    COUNT(DISTINCT geolocation_city) AS city_count
FROM geo_loc
GROUP BY geolocation_zip_code_prefix
HAVING COUNT(DISTINCT geolocation_city) > 1
ORDER BY city_count DESC;


-- 30. Check multiple states for the same ZIP prefix
-- Purpose: Identify ZIP prefixes associated with multiple state values.
SELECT
    geolocation_zip_code_prefix,
    COUNT(DISTINCT geolocation_state) AS state_count
FROM geo_loc
GROUP BY geolocation_zip_code_prefix
HAVING COUNT(DISTINCT geolocation_state) > 1
ORDER BY state_count DESC;


-- 31. Check multiple coordinate locations for the same ZIP prefix
-- Purpose: Determine geographic coordinate variation within each ZIP prefix.
SELECT
    geolocation_zip_code_prefix,
    COUNT(DISTINCT geolocation_lat, geolocation_lng)
        AS coordinate_count
FROM geo_loc
GROUP BY geolocation_zip_code_prefix
HAVING COUNT(DISTINCT geolocation_lat, geolocation_lng) > 1
ORDER BY coordinate_count DESC;


-- 32. Check city/state combinations
-- Purpose: Profile geographic combinations represented in the data.
SELECT
    geolocation_city,
    geolocation_state,
    COUNT(*) AS record_count
FROM geo_loc
GROUP BY
    geolocation_city,
    geolocation_state
ORDER BY record_count DESC;


-- 33. Identify incomplete geographic records
-- Purpose: Create an exception list for records missing geographic attributes.
SELECT
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state
FROM geo_loc
WHERE geolocation_zip_code_prefix IS NULL
   OR geolocation_lat IS NULL
   OR geolocation_lng IS NULL
   OR geolocation_city IS NULL
   OR geolocation_state IS NULL;


-- 34. Count incomplete geographic records
-- Purpose: Quantify records missing at least one geographic attribute.
SELECT
    COUNT(*) AS incomplete_geo_records
FROM geo_loc
WHERE geolocation_zip_code_prefix IS NULL
   OR geolocation_lat IS NULL
   OR geolocation_lng IS NULL
   OR geolocation_city IS NULL
   OR geolocation_state IS NULL;


-- 35. Check exact duplicate geographic records
-- Purpose: Identify completely duplicated geographic rows.
SELECT
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state,
    COUNT(*) AS duplicate_count
FROM geo_loc
GROUP BY
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;


-- 36. Count distinct complete geographic combinations
-- Purpose: Compare total records with unique geographic combinations.
SELECT
    COUNT(DISTINCT
        CONCAT_WS(
            '|',
            geolocation_zip_code_prefix,
            geolocation_lat,
            geolocation_lng,
            geolocation_city,
            geolocation_state
        )
    ) AS distinct_geo_combinations
FROM geo_loc;


-- 37. Check geographic records with all critical fields missing
-- Purpose: Identify completely unusable geographic records.
SELECT
    COUNT(*) AS fully_missing_geo_records
FROM geo_loc
WHERE geolocation_zip_code_prefix IS NULL
  AND geolocation_lat IS NULL
  AND geolocation_lng IS NULL
  AND geolocation_city IS NULL
  AND geolocation_state IS NULL;


-- 38. Overall geo_loc profiling summary
-- Purpose: Produce a compact geographic data-quality summary.
SELECT
    COUNT(*) AS total_geo_records,

    COUNT(DISTINCT geolocation_zip_code_prefix)
        AS distinct_zip_prefixes,

    COUNT(DISTINCT geolocation_city)
        AS distinct_cities,

    COUNT(DISTINCT geolocation_state)
        AS distinct_states,

    MIN(geolocation_lat)
        AS min_latitude,

    MAX(geolocation_lat)
        AS max_latitude,

    MIN(geolocation_lng)
        AS min_longitude,

    MAX(geolocation_lng)
        AS max_longitude
FROM geo_loc;


-- ============================================================
-- END OF GEO_LOC DATA PROFILING
-- Next table: PRODUCT_CATEGORY_TRANSLATION
-- ============================================================