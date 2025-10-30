
USE Olist_Ecommerce


---<<< Data Cleaning - Cheack spaces >>>---

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

---<<< Data Cleaning - Cheack Nulls >>>---
---{{ 1️. Orders Table }}---

/* -- Missing values in order_approved_at, order_delivered_carrier_date, 
   -- and order_delivered_customer_date are acceptable — not every order is delivered or approved yet.
   --->>> Do not remove them; they represent ongoing or cancelled orders.*/

SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS null_order_id,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
    SUM(CASE WHEN order_status IS NULL THEN 1 ELSE 0 END) AS null_order_status,
    SUM(CASE WHEN order_purchase_timestamp IS NULL THEN 1 ELSE 0 END) AS null_order_purchase_timestamp,
    SUM(CASE WHEN order_approved_at IS NULL THEN 1 ELSE 0 END) AS null_order_approved_at,
    SUM(CASE WHEN order_delivered_carrier_date IS NULL THEN 1 ELSE 0 END) AS null_order_delivered_carrier_date,
    SUM(CASE WHEN order_delivered_customer_date IS NULL THEN 1 ELSE 0 END) AS null_order_delivered_customer_date,
    SUM(CASE WHEN order_estimated_delivery_date IS NULL THEN 1 ELSE 0 END) AS null_order_estimated_delivery_date
FROM orders_dataset;

                   --------------------------------------------------------------------------------------
---{{ 2️. Customers Table }}---

/* -- Usually no missing values.
   --->>> There are usually no missing values because customer records come from verified orders, 
          where all address and ID details are required by the platform.*/

SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
    SUM(CASE WHEN customer_unique_id IS NULL THEN 1 ELSE 0 END) AS null_customer_unique_id,
    SUM(CASE WHEN customer_zip_code_prefix IS NULL THEN 1 ELSE 0 END) AS null_customer_zip_code_prefix,
    SUM(CASE WHEN customer_city IS NULL THEN 1 ELSE 0 END) AS null_customer_city,
    SUM(CASE WHEN customer_state IS NULL THEN 1 ELSE 0 END) AS null_customer_state
FROM customers_dataset;

                   --------------------------------------------------------------------------------------
---{{ 3️. Order Items Table }}---

/* -- No Missing Values.
   --->>> Missing product or seller IDs → serious data loss, but rare.
   --->>> Missing shipping_limit_date → possibly cancelled items. Keep them NULL.*/

SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS null_order_id,
    SUM(CASE WHEN order_item_id IS NULL THEN 1 ELSE 0 END) AS null_order_item_id,
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS null_product_id,
    SUM(CASE WHEN seller_id IS NULL THEN 1 ELSE 0 END) AS null_seller_id,
    SUM(CASE WHEN shipping_limit_date IS NULL THEN 1 ELSE 0 END) AS null_shipping_limit_date,
    SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END) AS null_price,
    SUM(CASE WHEN freight_value IS NULL THEN 1 ELSE 0 END) AS null_freight_value
FROM order_items_dataset;

                   --------------------------------------------------------------------------------------
---{{ 4️. Order Payments Table }}---

/* -- Rarely contains NULLs. 
   -- If payment_type is NULL → unknown payment method; keep NULL (don’t impute).
   --->>> There are rare NULLs because payment data is system-generated and only missing in exceptional cases 
          (e.g., failed or incomplete transactions).*/

SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS null_order_id,
    SUM(CASE WHEN payment_sequential IS NULL THEN 1 ELSE 0 END) AS null_payment_sequential,
    SUM(CASE WHEN payment_type IS NULL THEN 1 ELSE 0 END) AS null_payment_type,
    SUM(CASE WHEN payment_installments IS NULL THEN 1 ELSE 0 END) AS null_payment_installments,
    SUM(CASE WHEN payment_value IS NULL THEN 1 ELSE 0 END) AS null_payment_value
FROM order_payments_dataset;

                   --------------------------------------------------------------------------------------
---{{ 5️. Order Reviews Table }}---

/* -- Text columns (review_comment_title, review_comment_message) often NULL — 
      Acceptable (some users leave only a rating).
      No handling needed. */

SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN review_id IS NULL THEN 1 ELSE 0 END) AS null_review_id,
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS null_order_id,
    SUM(CASE WHEN review_score IS NULL THEN 1 ELSE 0 END) AS null_review_score,
    SUM(CASE WHEN review_comment_title IS NULL THEN 1 ELSE 0 END) AS null_review_comment_title,
    SUM(CASE WHEN review_comment_message IS NULL THEN 1 ELSE 0 END) AS null_review_comment_message,
    SUM(CASE WHEN review_creation_date IS NULL THEN 1 ELSE 0 END) AS null_review_creation_date,
    SUM(CASE WHEN review_answer_timestamp IS NULL THEN 1 ELSE 0 END) AS null_review_answer_timestamp
FROM order_reviews_dataset;

                   --------------------------------------------------------------------------------------
---{{ 6️. Products Table }}---

/* -- Some numeric columns have 0 or NULL — replace with average values.
      product_category_name missing → can’t infer → keep as NULL.*/

SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS null_product_id,
    SUM(CASE WHEN product_category_name IS NULL THEN 1 ELSE 0 END) AS null_product_category_name,
    SUM(CASE WHEN product_name_lenght IS NULL THEN 1 ELSE 0 END) AS null_product_name_length,
    SUM(CASE WHEN product_description_lenght IS NULL THEN 1 ELSE 0 END) AS null_product_description_length,
    SUM(CASE WHEN product_photos_qty IS NULL THEN 1 ELSE 0 END) AS null_product_photos_qty,
    SUM(CASE WHEN product_weight_g IS NULL THEN 1 ELSE 0 END) AS null_product_weight_g,
    SUM(CASE WHEN product_length_cm IS NULL THEN 1 ELSE 0 END) AS null_product_length_cm,
    SUM(CASE WHEN product_height_cm IS NULL THEN 1 ELSE 0 END) AS null_product_height_cm,
    SUM(CASE WHEN product_width_cm IS NULL THEN 1 ELSE 0 END) AS null_product_width_cm
FROM products_dataset;

-- Product Data Cleaning and Standardization View.
/* 1. Replaces missing (NULL) values with 0 using the COALESCE() function.
      → Ensures no column contains NULLs, which simplifies numeric calculations.

   2. Detects and fixes invalid zeros (e.g., missing measurements stored as 0).
      → Any zero value is replaced with the average value of that same column using a window function (AVG() OVER()).

   3. Creates a clean, standardized dataset view (VW_Cleaned_Products) that can be used by:
      -- Data Analysts to generate accurate summaries, statistics, and reports.
      -- Data Scientists to train models without bias from missing data.
      -- ETL / Data Engineering teams to ensure consistent and validated data pipelines.*/

CREATE VIEW VW_Cleaned_Products AS
WITH FilledNulls AS (
    SELECT
        product_id,
        COALESCE(product_name_lenght, 0) AS product_name_lenght,
        COALESCE(product_description_lenght, 0) AS product_description_lenght,
        COALESCE(product_photos_qty, 0) AS product_photos_qty,
        COALESCE(product_weight_g, 0) AS product_weight_g,
        COALESCE(product_length_cm, 0) AS product_length_cm,
        COALESCE(product_height_cm, 0) AS product_height_cm,
        COALESCE(product_width_cm, 0) AS product_width_cm
    FROM products_dataset
)
SELECT
    product_id,
    CASE WHEN product_name_lenght = 0 
         THEN AVG(product_name_lenght * 1.0) OVER()
         ELSE product_name_lenght END AS product_name_lenght,
    CASE WHEN product_description_lenght = 0 
         THEN AVG(product_description_lenght * 1.0) OVER()
         ELSE product_description_lenght END AS product_description_lenght,
    CASE WHEN product_photos_qty = 0 
         THEN AVG(product_photos_qty * 1.0) OVER()
         ELSE product_photos_qty END AS product_photos_qty,
    CASE WHEN product_weight_g = 0 
         THEN AVG(product_weight_g * 1.0) OVER()
         ELSE product_weight_g END AS product_weight_g,
    CASE WHEN product_length_cm = 0 
         THEN AVG(product_length_cm * 1.0) OVER()
         ELSE product_length_cm END AS product_length_cm,
    CASE WHEN product_height_cm = 0 
         THEN AVG(product_height_cm * 1.0) OVER()
         ELSE product_height_cm END AS product_height_cm,
    CASE WHEN product_width_cm = 0 
         THEN AVG(product_width_cm * 1.0) OVER()
         ELSE product_width_cm END AS product_width_cm
FROM FilledNulls;

-- Average Value of Each Column that was Replaced in the "VW_Cleaned_Products view":
SELECT
    AVG(product_name_lenght) AS avg_product_name_lenght,
    AVG(product_description_lenght) AS avg_product_description_lenght,
    AVG(product_photos_qty) AS avg_product_photos_qty,
    AVG(product_weight_g) AS avg_product_weight_g,
    AVG(product_length_cm) AS avg_product_length_cm,
    AVG(product_height_cm) AS avg_product_height_cm,
    AVG(product_width_cm) AS avg_product_width_cm
FROM VW_Cleaned_Products;

                   --------------------------------------------------------------------------------------
---{{ 7️. Sellers Table }}---

/* -- Usually complete.
   --->>> The sellers_dataset is generally complete and reliable because all sellers are registered with verified details.*/

SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN seller_id IS NULL THEN 1 ELSE 0 END) AS null_seller_id,
    SUM(CASE WHEN seller_zip_code_prefix IS NULL THEN 1 ELSE 0 END) AS null_seller_zip_code_prefix,
    SUM(CASE WHEN seller_city IS NULL THEN 1 ELSE 0 END) AS null_seller_city,
    SUM(CASE WHEN seller_state IS NULL THEN 1 ELSE 0 END) AS null_seller_state
FROM sellers_dataset;

                   --------------------------------------------------------------------------------------
---{{ 8️. Geolocation Table }}---

/* -- Missing latitude/longitude → can’t be reconstructed.
   --->>> Keep them as NULL since location imputation would introduce bias.*/

SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN geolocation_zip_code_prefix IS NULL THEN 1 ELSE 0 END) AS null_geolocation_zip_code_prefix,
    SUM(CASE WHEN geolocation_lat IS NULL THEN 1 ELSE 0 END) AS null_geolocation_lat,
    SUM(CASE WHEN geolocation_lng IS NULL THEN 1 ELSE 0 END) AS null_geolocation_lng,
    SUM(CASE WHEN geolocation_city IS NULL THEN 1 ELSE 0 END) AS null_geolocation_city,
    SUM(CASE WHEN geolocation_state IS NULL THEN 1 ELSE 0 END) AS null_geolocation_state
FROM geolocation_dataset;

                   --------------------------------------------------------------------------------------
---{{ 9️ Product Category Translation Table }}---

/* -- No Missing.
   --->>> Missing translations may appear — can be ignored since they don’t affect numeric analysis.*/

SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN product_category_name IS NULL THEN 1 ELSE 0 END) AS null_product_category_name,
    SUM(CASE WHEN product_category_name_english IS NULL THEN 1 ELSE 0 END) AS null_product_category_name_english
FROM product_category_name_translation;

-- ===========================================================
-- 1 Clean View for Customers Table
-- Removes spaces and keeps only valid records
-- ===========================================================
CREATE OR ALTER VIEW vw_customers_cleaned AS
SELECT
    customer_id,
    customer_unique_id,
    TRIM(customer_city) AS customer_city,
    TRIM(customer_state) AS customer_state,
    customer_zip_code_prefix
FROM customers_dataset;

-- ===========================================================
-- 2️ Clean View for Sellers Table
-- Removes leading/trailing spaces and keeps valid sellers
-- ===========================================================
CREATE OR ALTER VIEW vw_sellers_cleaned AS
SELECT
    seller_id,
    TRIM(seller_city) AS seller_city,
    TRIM(seller_state) AS seller_state,
    seller_zip_code_prefix
FROM sellers_dataset;

-- ===========================================================
-- 3️ Clean View for Geolocation Table
-- Removes spaces, keeps only valid city/state values
-- ===========================================================
CREATE OR ALTER VIEW vw_geolocation_cleaned AS
SELECT
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    TRIM(geolocation_city) AS geolocation_city,
    TRIM(geolocation_state) AS geolocation_state
FROM geolocation_dataset;

-- ===========================================================
-- 4 Cleaning review_comment_title and review_comment_message columns using TRIM to remove leading & trailing spaces.
-- Rechecked the cleaned view (vw_order_reviews_cleaned) → all results returned 0, confirming both columns are now clean.
-- ===========================================================
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

-- ===========================================================
-- 5️ Clean View for Product Category Translation Table
-- Removes spaces in category names
-- ===========================================================
CREATE OR ALTER VIEW vw_product_category_translation_cleaned AS
SELECT
    TRIM(product_category_name) AS product_category_name,
    TRIM(product_category_name_english) AS product_category_name_english
FROM product_category_name_translation;

-- ===========================================================
-- 6️ Clean View for Orders Table
-- Keeps all valid records and trims order_status
-- ===========================================================
CREATE OR ALTER VIEW vw_orders_cleaned AS
SELECT
    order_id,
    customer_id,
    TRIM(order_status) AS order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
FROM orders_dataset;

-- ===========================================================
-- 7️ Clean View for Order Items Table
-- Trims IDs and ensures numeric columns are valid
-- ===========================================================
CREATE OR ALTER VIEW vw_order_items_cleaned AS
SELECT
    TRIM(order_id) AS order_id,
    TRIM(product_id) AS product_id,
    TRIM(seller_id) AS seller_id,
    order_item_id,
    shipping_limit_date,
    price,
    freight_value
FROM order_items_dataset;

-- ===========================================================
-- 8 Clean View for Order Payments Table
-- Trims payment type
-- ===========================================================
CREATE OR ALTER VIEW vw_order_payments_cleaned AS
SELECT
    TRIM(order_id) AS order_id,
    payment_sequential,
    TRIM(payment_type) AS payment_type,
    payment_installments,
    payment_value
FROM order_payments_dataset;

-- ===========================================================
-- 9 Cleaning review_comment_title and review_comment_message columns using TRIM to remove leading & trailing spaces.
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
-- ===========================================================




