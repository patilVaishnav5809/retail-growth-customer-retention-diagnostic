USE olist_db;


-- 1. Count the total number of records in the customers table
SELECT COUNT(*)
FROM olist_db.customers;


-- 2. Identify customer_id values that appear more than once
-- This checks whether customer_id is unique
SELECT customer_id, COUNT(*) AS customer_count
FROM olist_db.customers
GROUP BY customer_id
HAVING COUNT(*) > 1;


-- 3. Practice query: attempt to identify duplicate customer_id records
-- NOTE: This query is not valid/reliable for this purpose because SELECT * is being used with GROUP BY
SELECT *
FROM olist_db.customers
GROUP BY customer_id
HAVING COUNT(*) > 1;


-- 4. Count how many times each duplicated customer_id appears
-- This measures the number of records associated with each duplicate ID
SELECT customer_id, COUNT(*) AS customer_count
FROM olist_db.customers
GROUP BY customer_id
HAVING COUNT(customer_id) > 1;


-- 5. Count the number of distinct customer identities
-- customer_unique_id represents the underlying customer identity
SELECT COUNT(DISTINCT customer_unique_id)
FROM olist_db.customers;


-- 6. Identify customer identities associated with multiple customer_id records
-- This checks the relationship between customer_unique_id and customer_id
SELECT customer_unique_id,
       COUNT(DISTINCT customer_id) AS customer_id_count
FROM olist_db.customers
GROUP BY customer_unique_id
HAVING COUNT(DISTINCT customer_id) > 1;


-- 7. Count NULL customer_id values
-- This checks whether the customer identifier contains missing values
SELECT COUNT(*)
FROM olist_db.customers c
WHERE c.customer_id IS NULL;


-- 8. Count NULL values in each customer table column
-- This provides a column-level missing-value profile
SELECT 
     SUM(CASE WHEN c.customer_id IS NULL THEN 1 ELSE 0 END) AS customer_id_nulls,
     SUM(CASE WHEN c.customer_unique_id IS NULL THEN 1 ELSE 0 END) AS customer_unique_id_nulls,
     SUM(CASE WHEN c.customer_city IS NULL THEN 1 ELSE 0 END) AS city_nulls,
     SUM(CASE WHEN c.customer_state IS NULL THEN 1 ELSE 0 END) AS state_nulls,
     SUM(CASE WHEN c.customer_zip_code_prefix IS NULL THEN 1 ELSE 0 END) AS zip_code_prefix_nulls
FROM olist_db.customers c;


-- 9. Calculate the NULL percentage for each customer table column
-- This measures the proportion of records missing values in each column
SELECT 
     SUM(CASE WHEN c.customer_id IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100 AS customer_id_nulls,
     SUM(CASE WHEN c.customer_unique_id IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100 AS customer_unique_id_nulls,
     SUM(CASE WHEN c.customer_city IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100 AS city_nulls,
     SUM(CASE WHEN c.customer_state IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100 AS state_nulls,
     SUM(CASE WHEN c.customer_zip_code_prefix IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100 AS zip_code_prefix_nulls
FROM olist_db.customers c;


-- 10. Find the customer identity with the highest number of customer_id records
-- This identifies the maximum number of records associated with one customer_unique_id
SELECT customer_unique_id,
       customer_id_count
FROM (
      SELECT c.customer_unique_id,
             COUNT(*) AS customer_id_count
      FROM olist_db.customers c
      GROUP BY c.customer_unique_id
     ) AS customer_uniquness
ORDER BY customer_id_count DESC
LIMIT 1;


-- 11. Identify customer identities associated with multiple cities
-- This checks whether one customer_unique_id appears across different cities
SELECT c.customer_unique_id,
       COUNT(DISTINCT c.customer_city) AS city_count
FROM olist_db.customers c
GROUP BY c.customer_unique_id
HAVING COUNT(DISTINCT c.customer_city) > 1;


-- 12. Identify customer identities associated with multiple states
-- This checks whether one customer_unique_id appears across different states
SELECT c.customer_unique_id,
       COUNT(DISTINCT c.customer_state) AS state_count
FROM olist_db.customers c
GROUP BY c.customer_unique_id
HAVING COUNT(DISTINCT c.customer_state) > 1;


-- 13. Count customers by state
-- This profiles the geographical distribution of customer records
SELECT c.customer_state,
       COUNT(*) AS customer_count
FROM olist_db.customers c
GROUP BY c.customer_state;


-- 14. Identify NULL or incorrectly formatted customer_state values
-- This checks whether state values follow the expected two-uppercase-letter format
SELECT 
    c.customer_state,
    COUNT(*) AS customer_count
FROM olist_db.customers c
WHERE c.customer_state IS NULL
   OR c.customer_state NOT REGEXP '^[A-Z]{2}$'
GROUP BY c.customer_state;