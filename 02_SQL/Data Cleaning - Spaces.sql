USE Olist_Ecommerce


--------- claen the spaces-----

-- Checking for leading & trailing spaces in customer_city and customer_state columns.
-- All values returned 0 → both columns are clean (no unwanted spaces found).

SELECT
    SUM(CASE WHEN LEFT(customer_state, 1) = ' ' THEN 1 ELSE 0 END) AS State_Leading_Spaces,
    SUM(CASE WHEN RIGHT(customer_state, 1) = ' ' THEN 1 ELSE 0 END) AS State_Trailing_Spaces,
    SUM(CASE WHEN LEFT(customer_city, 1) = ' ' THEN 1 ELSE 0 END) AS City_Leading_Spaces,
    SUM(CASE WHEN RIGHT(customer_city, 1) = ' ' THEN 1 ELSE 0 END) AS City_Trailing_Spaces
FROM customers_dataset;

--  Checking for leading & trailing spaces in seller_city and seller_state columns.
-- All results returned 0 → data is clean with no extra spaces.

SELECT
    SUM(CASE WHEN LEFT(seller_city, 1) = ' ' THEN 1 ELSE 0 END) AS SellerCity_Leading,
    SUM(CASE WHEN RIGHT(seller_city, 1) = ' ' THEN 1 ELSE 0 END) AS SellerCity_Trailing,
    SUM(CASE WHEN LEFT(seller_state, 1) = ' ' THEN 1 ELSE 0 END) AS SellerState_Leading,
    SUM(CASE WHEN RIGHT(seller_state, 1) = ' ' THEN 1 ELSE 0 END) AS SellerState_Trailing
FROM sellers_dataset;

-- Checking for leading & trailing spaces in geolocation_city and geolocation_state columns.
-- All values returned 0 → both columns are clean and contain no unwanted spaces.

SELECT
    SUM(CASE WHEN LEFT(geolocation_city, 1) = ' ' THEN 1 ELSE 0 END) AS City_Leading,
    SUM(CASE WHEN RIGHT(geolocation_city, 1) = ' ' THEN 1 ELSE 0 END) AS City_Trailing,
    SUM(CASE WHEN LEFT(geolocation_state, 1) = ' ' THEN 1 ELSE 0 END) AS State_Leading,
    SUM(CASE WHEN RIGHT(geolocation_state, 1) = ' ' THEN 1 ELSE 0 END) AS State_Trailing
FROM geolocation_dataset;

-- Checking for leading & trailing spaces in product_category_name column.
-- All results returned 0 → the column is clean with no extra spaces.

SELECT
    SUM(CASE WHEN LEFT(product_category_name, 1) = ' ' THEN 1 ELSE 0 END) AS Category_Leading,
    SUM(CASE WHEN RIGHT(product_category_name, 1) = ' ' THEN 1 ELSE 0 END) AS Category_Trailing
FROM products_dataset;

-- Checking for leading & trailing spaces in product_category_name and product_category_name_english columns.
-- All values returned 0 → both columns are clean with no extra spaces.

SELECT
    SUM(CASE WHEN LEFT(product_category_name, 1) = ' ' THEN 1 ELSE 0 END) AS Name_Leading,
    SUM(CASE WHEN RIGHT(product_category_name, 1) = ' ' THEN 1 ELSE 0 END) AS Name_Trailing,
    SUM(CASE WHEN LEFT(product_category_name_english, 1) = ' ' THEN 1 ELSE 0 END) AS NameEng_Leading,
    SUM(CASE WHEN RIGHT(product_category_name_english, 1) = ' ' THEN 1 ELSE 0 END) AS NameEng_Trailing
FROM product_category_name_translation;


-- Checking for leading & trailing spaces in order_status column.
-- All results returned 0 → the column is clean with no unwanted spaces.

SELECT
    SUM(CASE WHEN LEFT(order_status, 1) = ' ' THEN 1 ELSE 0 END) AS Status_Leading,
    SUM(CASE WHEN RIGHT(order_status, 1) = ' ' THEN 1 ELSE 0 END) AS Status_Trailing
FROM orders_dataset;


--6 order_payments_dataset no space
SELECT
    SUM(CASE WHEN LEFT(payment_type, 1) = ' ' THEN 1 ELSE 0 END) AS Type_Leading,
    SUM(CASE WHEN RIGHT(payment_type, 1) = ' ' THEN 1 ELSE 0 END) AS Type_Trailing
FROM order_payments_dataset;


-- Checking for leading & trailing spaces in order_id, product_id, and seller_id columns.
-- All results returned 0 → all ID columns are clean with no extra spaces.

SELECT
    SUM(CASE WHEN LEFT(order_id, 1) = ' ' THEN 1 ELSE 0 END) AS OrderID_Leading,
    SUM(CASE WHEN RIGHT(order_id, 1) = ' ' THEN 1 ELSE 0 END) AS OrderID_Trailing,
    SUM(CASE WHEN LEFT(product_id, 1) = ' ' THEN 1 ELSE 0 END) AS ProductID_Leading,
    SUM(CASE WHEN RIGHT(product_id, 1) = ' ' THEN 1 ELSE 0 END) AS ProductID_Trailing,
    SUM(CASE WHEN LEFT(seller_id, 1) = ' ' THEN 1 ELSE 0 END) AS SellerID_Leading,
    SUM(CASE WHEN RIGHT(seller_id, 1) = ' ' THEN 1 ELSE 0 END) AS SellerID_Trailing
FROM order_items_dataset;


-- Checking for leading & trailing spaces in review_comment_title and review_comment_message columns.
-- Results show: Title_Leading = 9, Title_Trailing = 23, Message_Leading = 226 → 
-- These columns contain unwanted spaces and need cleaning using TRIM or LTRIM/RTRIM functions.

SELECT
    SUM(CASE WHEN LEFT(review_comment_title, 1) = ' ' THEN 1 ELSE 0 END) AS Title_Leading,
    SUM(CASE WHEN RIGHT(review_comment_title, 1) = ' ' THEN 1 ELSE 0 END) AS Title_Trailing,
    SUM(CASE WHEN LEFT(review_comment_message, 1) = ' ' THEN 1 ELSE 0 END) AS Message_Leading,
    SUM(CASE WHEN RIGHT(review_comment_message, 1) = ' ' THEN 1 ELSE 0 END) AS Message_Trailing
FROM order_reviews_dataset;

-- Cleaning review_comment_title and review_comment_message columns using TRIM to remove leading & trailing spaces.
-- Rechecked the cleaned view (vw_order_reviews_cleaned) → all results returned 0, confirming both columns are now clean.

CREATE OR ALTER VIEW vw_order_reviews_cleaned AS
SELECT
    review_id,
    order_id,
    review_score,
    -- Remove leading and trailing spaces using TRIM
    TRIM(review_comment_title) AS review_comment_title,
    TRIM(review_comment_message) AS review_comment_message,
    review_creation_date,
    review_answer_timestamp
FROM order_reviews_dataset;

-- Recheck cleaned data
SELECT
    SUM(CASE WHEN LEFT(review_comment_title, 1) = ' ' THEN 1 ELSE 0 END) AS Title_Leading,
    SUM(CASE WHEN RIGHT(review_comment_title, 1) = ' ' THEN 1 ELSE 0 END) AS Title_Trailing,
    SUM(CASE WHEN LEFT(review_comment_message, 1) = ' ' THEN 1 ELSE 0 END) AS Message_Leading,
    SUM(CASE WHEN RIGHT(review_comment_message, 1) = ' ' THEN 1 ELSE 0 END) AS Message_Trailing
FROM vw_order_reviews_cleaned;


-- Checking for leading & trailing spaces in customer_city and customer_state columns.
-- All results returned 0 → both columns are clean with no unwanted spaces.

SELECT
    SUM(CASE WHEN LEFT(customer_city, 1) = ' ' THEN 1 ELSE 0 END) AS City_Leading,
    SUM(CASE WHEN RIGHT(customer_city, 1) = ' ' THEN 1 ELSE 0 END) AS City_Trailing,
    SUM(CASE WHEN LEFT(customer_state, 1) = ' ' THEN 1 ELSE 0 END) AS State_Leading,
    SUM(CASE WHEN RIGHT(customer_state, 1) = ' ' THEN 1 ELSE 0 END) AS State_Trailing
FROM customers_dataset;

