
-- =====================================================
-- WOMEN'S E-COMMERCE REVIEWS ANALYSIS
-- Database: ecommerce_reviews_analysis
-- Table: customer_reviews
-- =====================================================


-- 1. CREATE TABLE

CREATE TABLE customer_reviews (
    source_index INTEGER,
    clothing_id INTEGER,
    age INTEGER,
    title TEXT,
    review_text TEXT,
    rating INTEGER,
    recommended_ind INTEGER,
    positive_feedback_count INTEGER,
    division_name TEXT,
    department_name TEXT,
    class_name TEXT,
    review_length INTEGER,
    rating_sentiment TEXT
);


-- 2. DATA VALIDATION

-- Check total and unique records
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT source_index) AS unique_records
FROM customer_reviews;

-- Check missing values
SELECT
    COUNT(*) FILTER (WHERE review_text IS NULL) AS missing_reviews,
    COUNT(*) FILTER (WHERE department_name IS NULL) AS missing_departments,
    COUNT(*) FILTER (WHERE rating IS NULL) AS missing_ratings
FROM customer_reviews;

-- Preview records
SELECT *
FROM customer_reviews
LIMIT 5;


-- 3. AVERAGE RATING BY DEPARTMENT

SELECT
    department_name,
    COUNT(*) AS total_reviews,
    ROUND(AVG(rating), 2) AS average_rating
FROM customer_reviews
WHERE department_name IS NOT NULL
GROUP BY department_name
ORDER BY average_rating DESC;


-- 4. REVIEW DETAIL LEVEL AND HELPFUL VOTES

SELECT
    CASE
        WHEN review_length < 50 THEN 'Short'
        WHEN review_length <= 150 THEN 'Medium'
        ELSE 'Detailed'
    END AS review_detail,
    COUNT(*) AS total_reviews,
    ROUND(AVG(positive_feedback_count), 2)
        AS average_helpful_votes
FROM customer_reviews
GROUP BY
    CASE
        WHEN review_length < 50 THEN 'Short'
        WHEN review_length <= 150 THEN 'Medium'
        ELSE 'Detailed'
    END
ORDER BY average_helpful_votes DESC;


-- 5. FIT-RELATED COMPLAINTS BY CLOTHING CLASS

SELECT
    class_name,
    CASE
        WHEN review_text ILIKE '%runs small%'
          OR review_text ILIKE '%run small%'
            THEN 'Runs Small'
        WHEN review_text ILIKE '%runs large%'
          OR review_text ILIKE '%run large%'
            THEN 'Runs Large'
        WHEN review_text ILIKE '%too small%'
            THEN 'Too Small'
        WHEN review_text ILIKE '%too large%'
            THEN 'Too Large'
    END AS fit_issue,
    COUNT(*) AS complaint_count
FROM customer_reviews
WHERE
    review_text ILIKE '%runs small%'
    OR review_text ILIKE '%run small%'
    OR review_text ILIKE '%runs large%'
    OR review_text ILIKE '%run large%'
    OR review_text ILIKE '%too small%'
    OR review_text ILIKE '%too large%'
GROUP BY
    class_name,
    CASE
        WHEN review_text ILIKE '%runs small%'
          OR review_text ILIKE '%run small%'
            THEN 'Runs Small'
        WHEN review_text ILIKE '%runs large%'
          OR review_text ILIKE '%run large%'
            THEN 'Runs Large'
        WHEN review_text ILIKE '%too small%'
            THEN 'Too Small'
        WHEN review_text ILIKE '%too large%'
            THEN 'Too Large'
    END
ORDER BY complaint_count DESC;


-- 6. RECOMMENDATION RATE BY AGE GROUP

SELECT
    CASE
        WHEN age BETWEEN 18 AND 24 THEN '18-24'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        WHEN age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+'
    END AS age_band,
    COUNT(*) AS total_reviews,
    ROUND(AVG(recommended_ind) * 100, 2)
        AS recommendation_percentage
FROM customer_reviews
WHERE age >= 18
GROUP BY
    CASE
        WHEN age BETWEEN 18 AND 24 THEN '18-24'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        WHEN age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+'
    END
ORDER BY age_band;
