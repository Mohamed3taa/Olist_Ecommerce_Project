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

