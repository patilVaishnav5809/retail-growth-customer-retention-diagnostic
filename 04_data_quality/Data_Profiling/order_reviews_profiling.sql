-- ============================================================
-- OLIST RETAIL ANALYSIS
-- ORDER_REVIEWS TABLE — DATA PROFILING
-- ============================================================

USE olist_db;


-- 1. Inspect table structure
-- Purpose: Understand columns, data types, and schema definition.
DESC order_reviews;


-- 2. Establish table size
-- Purpose: Determine the total number of review records.
SELECT COUNT(*) AS total_review_records
FROM order_reviews;


-- 3. Check duplicate review IDs
-- Purpose: Identify review_id values appearing more than once.
SELECT
    review_id,
    COUNT(*) AS review_count
FROM order_reviews
GROUP BY review_id
HAVING COUNT(*) > 1;


-- 4. Check NULL review IDs
-- Purpose: Identify reviews without a review identifier.
SELECT COUNT(*) AS null_review_ids
FROM order_reviews
WHERE review_id IS NULL;


-- 5. Check duplicate order IDs
-- Purpose: Determine whether an order can have multiple review records.
SELECT
    order_id,
    COUNT(*) AS review_count
FROM order_reviews
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY review_count DESC;


-- 6. Check NULL values across all columns
-- Purpose: Identify missing review information.
SELECT
    SUM(CASE WHEN review_id IS NULL THEN 1 ELSE 0 END)
        AS review_id_nulls,

    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END)
        AS order_id_nulls,

    SUM(CASE WHEN review_score IS NULL THEN 1 ELSE 0 END)
        AS review_score_nulls,

    SUM(CASE WHEN review_comment_title IS NULL THEN 1 ELSE 0 END)
        AS comment_title_nulls,

    SUM(CASE WHEN review_comment_message IS NULL THEN 1 ELSE 0 END)
        AS comment_message_nulls,

    SUM(CASE WHEN review_creation_date IS NULL THEN 1 ELSE 0 END)
        AS creation_date_nulls,

    SUM(CASE WHEN review_answer_timestamp IS NULL THEN 1 ELSE 0 END)
        AS answer_timestamp_nulls
FROM order_reviews;


-- 7. Calculate NULL percentages
-- Purpose: Measure missing-value percentage for every review attribute.
SELECT
    SUM(CASE WHEN review_id IS NULL THEN 1 ELSE 0 END)
        / COUNT(*) * 100 AS review_id_null_pct,

    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END)
        / COUNT(*) * 100 AS order_id_null_pct,

    SUM(CASE WHEN review_score IS NULL THEN 1 ELSE 0 END)
        / COUNT(*) * 100 AS review_score_null_pct,

    SUM(CASE WHEN review_comment_title IS NULL THEN 1 ELSE 0 END)
        / COUNT(*) * 100 AS comment_title_null_pct,

    SUM(CASE WHEN review_comment_message IS NULL THEN 1 ELSE 0 END)
        / COUNT(*) * 100 AS comment_message_null_pct,

    SUM(CASE WHEN review_creation_date IS NULL THEN 1 ELSE 0 END)
        / COUNT(*) * 100 AS creation_date_null_pct,

    SUM(CASE WHEN review_answer_timestamp IS NULL THEN 1 ELSE 0 END)
        / COUNT(*) * 100 AS answer_timestamp_null_pct
FROM order_reviews;


-- 8. Check invalid order references
-- Purpose: Verify that every review order_id exists in orders.
SELECT
    r.review_id,
    r.order_id
FROM order_reviews r
LEFT JOIN orders o
    ON r.order_id = o.order_id
WHERE o.order_id IS NULL;


-- 9. Count invalid order references
-- Purpose: Quantify reviews that cannot be linked to an order.
SELECT COUNT(*) AS invalid_order_references
FROM order_reviews r
LEFT JOIN orders o
    ON r.order_id = o.order_id
WHERE o.order_id IS NULL;


-- 10. Review-score distribution
-- Purpose: Understand the frequency of each review score.
SELECT
    review_score,
    COUNT(*) AS review_count
FROM order_reviews
GROUP BY review_score
ORDER BY review_score;


-- 11. Validate review scores
-- Purpose: Identify scores outside the expected 1–5 range.
SELECT
    review_id,
    order_id,
    review_score
FROM order_reviews
WHERE review_score IS NULL
   OR review_score < 1
   OR review_score > 5;


-- 12. Count invalid review scores
-- Purpose: Quantify review-score records outside the valid range.
SELECT
    COUNT(*) AS invalid_review_score_count
FROM order_reviews
WHERE review_score IS NULL
   OR review_score < 1
   OR review_score > 5;


-- 13. Check average review score
-- Purpose: Profile the numerical distribution of review scores.
SELECT
    MIN(review_score) AS min_review_score,
    MAX(review_score) AS max_review_score,
    AVG(review_score) AS avg_review_score
FROM order_reviews
WHERE review_score IS NOT NULL;


-- 14. Check blank review titles
-- Purpose: Identify empty strings separately from NULL values.
SELECT
    COUNT(*) AS blank_comment_title_count
FROM order_reviews
WHERE review_comment_title IS NOT NULL
  AND TRIM(review_comment_title) = '';


-- 15. Check blank review messages
-- Purpose: Identify empty review messages separately from NULL values.
SELECT
    COUNT(*) AS blank_comment_message_count
FROM order_reviews
WHERE review_comment_message IS NOT NULL
  AND TRIM(review_comment_message) = '';


-- 16. Check review comment title length
-- Purpose: Profile the length of available review titles.
SELECT
    MIN(CHAR_LENGTH(review_comment_title)) AS min_title_length,
    MAX(CHAR_LENGTH(review_comment_title)) AS max_title_length,
    AVG(CHAR_LENGTH(review_comment_title)) AS avg_title_length
FROM order_reviews
WHERE review_comment_title IS NOT NULL
  AND TRIM(review_comment_title) <> '';


-- 17. Check review message length
-- Purpose: Profile the length of available review messages.
SELECT
    MIN(CHAR_LENGTH(review_comment_message)) AS min_message_length,
    MAX(CHAR_LENGTH(review_comment_message)) AS max_message_length,
    AVG(CHAR_LENGTH(review_comment_message)) AS avg_message_length
FROM order_reviews
WHERE review_comment_message IS NOT NULL
  AND TRIM(review_comment_message) <> '';


-- 18. Check review creation date range
-- Purpose: Identify the temporal coverage of review creation.
SELECT
    MIN(review_creation_date) AS earliest_review_creation,
    MAX(review_creation_date) AS latest_review_creation
FROM order_reviews
WHERE review_creation_date IS NOT NULL;


-- 19. Check review answer timestamp range
-- Purpose: Identify the temporal coverage of review responses.
SELECT
    MIN(review_answer_timestamp) AS earliest_review_answer,
    MAX(review_answer_timestamp) AS latest_review_answer
FROM order_reviews
WHERE review_answer_timestamp IS NOT NULL;


-- 20. Check answer timestamps before review creation
-- Purpose: Identify logically inconsistent review timelines.
SELECT
    review_id,
    order_id,
    review_creation_date,
    review_answer_timestamp
FROM order_reviews
WHERE review_creation_date IS NOT NULL
  AND review_answer_timestamp IS NOT NULL
  AND review_answer_timestamp < review_creation_date;


-- 21. Count answer timestamps before review creation
-- Purpose: Quantify invalid review timeline records.
SELECT
    COUNT(*) AS answer_before_creation_count
FROM order_reviews
WHERE review_creation_date IS NOT NULL
  AND review_answer_timestamp IS NOT NULL
  AND review_answer_timestamp < review_creation_date;


-- 22. Check reviews answered after creation
-- Purpose: Profile the elapsed time between review creation and response.
SELECT
    review_id,
    order_id,
    review_creation_date,
    review_answer_timestamp,
    TIMESTAMPDIFF(
        HOUR,
        review_creation_date,
        review_answer_timestamp
    ) AS answer_time_hours
FROM order_reviews
WHERE review_creation_date IS NOT NULL
  AND review_answer_timestamp IS NOT NULL
  AND review_answer_timestamp >= review_creation_date;


-- 23. Review answer-time statistics
-- Purpose: Profile response-time distribution.
SELECT
    MIN(
        TIMESTAMPDIFF(
            HOUR,
            review_creation_date,
            review_answer_timestamp
        )
    ) AS min_answer_time_hours,

    MAX(
        TIMESTAMPDIFF(
            HOUR,
            review_creation_date,
            review_answer_timestamp
        )
    ) AS max_answer_time_hours,

    AVG(
        TIMESTAMPDIFF(
            HOUR,
            review_creation_date,
            review_answer_timestamp
        )
    ) AS avg_answer_time_hours
FROM order_reviews
WHERE review_creation_date IS NOT NULL
  AND review_answer_timestamp IS NOT NULL
  AND review_answer_timestamp >= review_creation_date;


-- 24. Check reviews with no answer timestamp
-- Purpose: Identify reviews that do not have a recorded response time.
SELECT
    review_id,
    order_id,
    review_score,
    review_creation_date
FROM order_reviews
WHERE review_answer_timestamp IS NULL;


-- 25. Count reviews with no answer timestamp
-- Purpose: Quantify reviews without recorded responses.
SELECT
    COUNT(*) AS unanswered_review_count
FROM order_reviews
WHERE review_answer_timestamp IS NULL;


-- 26. Check reviews with comments
-- Purpose: Determine whether a review contains title/message text.
SELECT
    COUNT(*) AS reviews_with_comments
FROM order_reviews
WHERE
    (review_comment_title IS NOT NULL
     AND TRIM(review_comment_title) <> '')
 OR
    (review_comment_message IS NOT NULL
     AND TRIM(review_comment_message) <> '');


-- 27. Check reviews without comments
-- Purpose: Identify reviews containing neither a title nor a message.
SELECT
    COUNT(*) AS reviews_without_comments
FROM order_reviews
WHERE
    (review_comment_title IS NULL
     OR TRIM(review_comment_title) = '')
AND
    (review_comment_message IS NULL
     OR TRIM(review_comment_message) = '');


-- 28. Check review ID length
-- Purpose: Identify review IDs that differ from the expected
-- identifier structure.
SELECT
    review_id,
    CHAR_LENGTH(review_id) AS review_id_length
FROM order_reviews
WHERE review_id IS NOT NULL
  AND CHAR_LENGTH(review_id) <> 32;


-- 29. Check review ID format
-- Purpose: Identify review IDs containing unexpected characters.
SELECT
    review_id
FROM order_reviews
WHERE review_id IS NOT NULL
  AND review_id NOT REGEXP '^[0-9a-fA-F]{32}$';


-- 30. Check orders with multiple review IDs
-- Purpose: Identify orders linked to multiple distinct review identifiers.
SELECT
    order_id,
    COUNT(DISTINCT review_id) AS review_id_count
FROM order_reviews
GROUP BY order_id
HAVING COUNT(DISTINCT review_id) > 1
ORDER BY review_id_count DESC;


-- 31. Check duplicate review IDs across different orders
-- Purpose: Verify whether a review_id is associated with multiple orders.
SELECT
    review_id,
    COUNT(DISTINCT order_id) AS order_count
FROM order_reviews
GROUP BY review_id
HAVING COUNT(DISTINCT order_id) > 1;


-- 32. Check review records with missing critical attributes
-- Purpose: Create an exception list for incomplete review records.
SELECT
    review_id,
    order_id,
    review_score,
    review_creation_date,
    review_answer_timestamp
FROM order_reviews
WHERE review_id IS NULL
   OR order_id IS NULL
   OR review_score IS NULL
   OR review_creation_date IS NULL;


-- 33. Count incomplete review records
-- Purpose: Quantify records missing at least one critical review attribute.
SELECT
    COUNT(*) AS incomplete_review_records
FROM order_reviews
WHERE review_id IS NULL
   OR order_id IS NULL
   OR review_score IS NULL
   OR review_creation_date IS NULL;


-- 34. Check review creation dates before order purchase
-- Purpose: Identify reviews created before the corresponding order existed.
SELECT
    r.review_id,
    r.order_id,
    o.order_purchase_timestamp,
    r.review_creation_date
FROM order_reviews r
INNER JOIN orders o
    ON r.order_id = o.order_id
WHERE r.review_creation_date < o.order_purchase_timestamp;


-- 35. Count reviews created before order purchase
-- Purpose: Quantify logically inconsistent review/order timelines.
SELECT
    COUNT(*) AS review_before_purchase_count
FROM order_reviews r
INNER JOIN orders o
    ON r.order_id = o.order_id
WHERE r.review_creation_date < o.order_purchase_timestamp;


-- 36. Check reviews after customer delivery
-- Purpose: Profile the relationship between delivery completion
-- and review creation.
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


-- 37. Count reviews created before customer delivery
-- Purpose: Quantify review records created before delivery completion.
SELECT
    COUNT(*) AS reviews_before_delivery_count
FROM order_reviews r
INNER JOIN orders o
    ON r.order_id = o.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
  AND r.review_creation_date IS NOT NULL
  AND r.review_creation_date < o.order_delivered_customer_date;


-- 38. Review score percentages
-- Purpose: Measure the proportion of each valid review score.
SELECT
    review_score,
    COUNT(*) AS review_count,
    COUNT(*) / SUM(COUNT(*)) OVER () * 100 AS review_percentage
FROM order_reviews
WHERE review_score BETWEEN 1 AND 5
GROUP BY review_score
ORDER BY review_score;


-- 39. Review records by creation year
-- Purpose: Check the temporal distribution of reviews.
SELECT
    YEAR(review_creation_date) AS review_year,
    COUNT(*) AS review_count
FROM order_reviews
WHERE review_creation_date IS NOT NULL
GROUP BY YEAR(review_creation_date)
ORDER BY review_year;


-- 40. Overall order-reviews profiling summary
-- Purpose: Produce a compact data-quality summary.
SELECT
    COUNT(*) AS total_review_records,
    COUNT(DISTINCT review_id) AS distinct_review_ids,
    COUNT(DISTINCT order_id) AS distinct_orders,
    COUNT(DISTINCT review_score) AS distinct_review_scores,
    MIN(review_score) AS min_review_score,
    MAX(review_score) AS max_review_score,
    AVG(review_score) AS avg_review_score,
    MIN(review_creation_date) AS earliest_review_creation,
    MAX(review_creation_date) AS latest_review_creation
FROM order_reviews;


-- ============================================================
-- END OF ORDER_REVIEWS DATA PROFILING
-- Next table: GEO_LOC
-- ============================================================