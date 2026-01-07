IF OBJECT_ID('stg.usp_Load_Staging_Cleaned', 'P') IS NOT NULL
    DROP PROCEDURE stg.usp_Load_Staging_Cleaned;
GO

CREATE PROCEDURE stg.usp_Load_Staging_Cleaned
AS
BEGIN
    SET NOCOUNT ON;

    /* ============================================
       GEOLOCATION_CLEANED
       ============================================ */
    TRUNCATE TABLE stg.geolocation_cleaned;

    INSERT INTO stg.geolocation_cleaned (
        geolocation_zip_code_prefix,
        geolocation_lat,
        geolocation_lng,
        geolocation_city,
        geolocation_state
    )
    SELECT
        TRIM(geolocation_zip_code_prefix)                        AS geolocation_zip_code_prefix,
        AVG(geolocation_lat)                                    AS geolocation_lat,
        AVG(geolocation_lng)                                    AS geolocation_lng,
        TRIM(MIN(geolocation_city))                             AS geolocation_city,
        TRIM(MIN(geolocation_state))                            AS geolocation_state
    FROM stg.geolocation_raw
    GROUP BY TRIM(geolocation_zip_code_prefix);


    /* ============================================
       CUSTOMERS_CLEANED
       ============================================ */
    TRUNCATE TABLE stg.customers_cleaned;

    INSERT INTO stg.customers_cleaned (
        customer_id,
        customer_unique_id,
        customer_zip_code_prefix,
        customer_lat,
        customer_lng,
        customer_city,
        customer_state
    )
    SELECT DISTINCT
        c.customer_id,
        c.customer_unique_id,
        c.customer_zip_code_prefix,
        g.geolocation_lat       AS customer_lat,
        g.geolocation_lng       AS customer_lng,
        TRIM(ISNULL(g.geolocation_city,  c.customer_city))  AS customer_city,
        TRIM(ISNULL(g.geolocation_state, c.customer_state)) AS customer_state
    FROM stg.customers_raw c
    LEFT JOIN stg.geolocation_cleaned g
        ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix;


    /* ============================================
       SELLERS_CLEANED
       ============================================ */
    TRUNCATE TABLE stg.sellers_cleaned;

    INSERT INTO stg.sellers_cleaned (
        seller_id,
        seller_zip_code_prefix,
        seller_lat,
        seller_lng,
        seller_city,
        seller_state
    )
    SELECT
        s.seller_id,
        s.seller_zip_code_prefix,
        g.geolocation_lat,
        g.geolocation_lng,
        TRIM(ISNULL(g.geolocation_city,  s.seller_city))  AS seller_city,
        TRIM(ISNULL(g.geolocation_state, s.seller_state)) AS seller_state
    FROM stg.sellers_raw s
    LEFT JOIN stg.geolocation_cleaned g
        ON s.seller_zip_code_prefix = g.geolocation_zip_code_prefix;


    /* ============================================
       PAYMENTS_CLEANED
       ============================================ */
    TRUNCATE TABLE stg.payments_cleaned;

    INSERT INTO stg.payments_cleaned (
        order_id,
        payment_sequential,
        payment_type,
        payment_installments,
        payment_value
    )
    SELECT
        order_id,
        payment_squential AS payment_sequential,
        LOWER(payment_type) AS payment_type,
        CASE 
            WHEN payment_installments = 0 
                 AND LOWER(payment_type) = 'credit_card'
                THEN 1
            ELSE payment_installments
        END AS payment_installments,
        payment_value
    FROM stg.payments_raw
    WHERE payment_value > 0;


    /* ============================================
       PRODUCT_CATEGORY_TRANSLATE_NAME_CLEANED
       ============================================ */
    TRUNCATE TABLE stg.product_category_translate_name_cleaned;

    INSERT INTO stg.product_category_translate_name_cleaned (
        product_category_pt,
        product_category_en
    )
    SELECT DISTINCT
        LOWER(TRIM(product_category_name))   AS product_category_pt,
        TRIM(product_category_name_english)  AS product_category_en
    FROM stg.product_category_translate_name_raw;


    /* ============================================
       PRODUCTS_CLEANED
       ============================================ */
    TRUNCATE TABLE stg.products_cleaned;

    INSERT INTO stg.products_cleaned (
        product_id,
        product_category_pt,
        product_category_en,
        product_name_length,
        product_description_length,
        product_photos_qty,
        product_weight,
        product_length,
        product_height,
        product_width
    )
    SELECT
        pp.product_id,
        COALESCE(pp.product_category_name, 'unknown')             AS product_category_pt,
        COALESCE(pe.product_category_en, 'unknown')               AS product_category_en,
        pp.product_name_lenght          AS product_name_length,
        pp.product_description_lenght   AS product_description_length,
        pp.product_photos_qty           AS product_photos_qty,
        pp.product_weight_g             AS product_weight,
        pp.product_length_cm            AS product_length,
        pp.product_height_cm            AS product_height,
        pp.product_width_cm             AS product_width
    FROM stg.products_raw pp
    LEFT JOIN stg.product_category_translate_name_cleaned pe
        ON LOWER(pp.product_category_name) = LOWER(pe.product_category_pt);


    /* ============================================
       ORDER_ITEMS_CLEANED
       ============================================ */
    TRUNCATE TABLE stg.order_items_cleaned;

    INSERT INTO stg.order_items_cleaned (
        order_id,
        order_item_id,
        product_id,
        seller_id,
        shipping_limit_date,
        shipping_date,
        price,
        freight_value
    )
    SELECT
        order_id,
        order_item_id,
        product_id,
        seller_id,
        shipping_limit_date,
        CAST(shipping_limit_date AS DATE) AS shipping_date,
        price,
        freight_value
    FROM stg.order_items_raw;


    /* ============================================
       ORDERS_CLEANED
       ============================================ */
    TRUNCATE TABLE stg.orders_cleaned;

    INSERT INTO stg.orders_cleaned (
        order_id,
        customer_id,
        order_status,
        order_purchase_time_stamp,
        order_purchase_date,
        order_approved_at,
        order_approved_date,
        order_delivered_carrier_date,
        order_carrier_date,
        order_delivered_customer_date,
        order_delivered_date,
        order_estimated_delivery_date,
        order_estimated_date
    )
    SELECT
        order_id,
        customer_id,
        LOWER(TRIM(order_status))                   AS order_status,
        order_purchase_time_stamp,
        CAST(order_purchase_time_stamp AS DATE)     AS order_purchase_date,
        order_approved_at,
        CAST(order_approved_at AS DATE)             AS order_approved_date,
        order_delivered_carrier_date,
        CAST(order_delivered_carrier_date AS DATE)  AS order_carrier_date,
        order_delivered_customer_date,
        CAST(order_delivered_customer_date AS DATE) AS order_delivered_date,
        order_estimated_delivery_date,
        CAST(order_estimated_delivery_date AS DATE) AS order_estimated_date
    FROM stg.orders_raw;


    /* ============================================
       REVIEWS_CLEANED
       ============================================ */
    TRUNCATE TABLE stg.reviews_cleaned;

    INSERT INTO stg.reviews_cleaned (
        review_id,
        order_id,
        review_score,
        review_comment_title,
        review_comment_message,
        review_creation_datetime,
        review_creation_date,
        review_answer_datetime,
        review_answer_date
    )
    SELECT
        x.review_id,
        x.order_id,
        x.review_score,
        LOWER(TRIM(x.review_comment_title))    AS review_comment_title,    -- dùng LTRIM/RTRIM nếu TRIM không hỗ trợ
        LOWER(TRIM(x.review_comment_message))  AS review_comment_message,
        x.review_creation_datetime,
        CAST(x.review_creation_datetime AS DATE)   AS review_creation_date,
        x.review_answer_datetime,
        CAST(x.review_answer_datetime AS DATE)     AS review_answer_date
    FROM (
        SELECT
            r.review_id,
            r.order_id,
            r.review_score,
            r.review_comment_title,
            r.review_comment_message,
            r.review_creation_date     AS review_creation_datetime,   -- từ raw
            r.review_answer_timestamp  AS review_answer_datetime,     -- từ raw
            ROW_NUMBER() OVER (
                PARTITION BY r.review_id
                ORDER BY r.review_creation_date DESC
            ) AS rn
        FROM stg.reviews_raw r
    ) x
    WHERE x.rn = 1;   -- giữ đúng 1 dòng (mới nhất) cho mỗi review_id
                    -- chỉ lấy review_id mới nhất rn = 1
END;
GO


