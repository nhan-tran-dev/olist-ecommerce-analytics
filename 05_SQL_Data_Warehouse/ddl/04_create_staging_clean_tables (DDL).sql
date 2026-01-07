/* =========================================================
   1. GEOLOCATION_CLEANED
   ========================================================= */
IF OBJECT_ID ('stg.geolocation_cleaned', 'U') IS NOT NULL
    DROP TABLE stg.geolocation_cleaned;
GO

CREATE TABLE stg.geolocation_cleaned (
    geolocation_zip_code_prefix  VARCHAR(10)    NOT NULL,
    geolocation_lat              DECIMAL(18,8) NULL,
    geolocation_lng              DECIMAL(18,8) NULL,
    geolocation_city             NVARCHAR(100) NULL,
    geolocation_state            NVARCHAR(50)  NULL
);
GO


/* =========================================================
   2. CUSTOMERS_CLEANED
   ========================================================= */
IF OBJECT_ID ('stg.customers_cleaned', 'U') IS NOT NULL
    DROP TABLE stg.customers_cleaned;
GO

CREATE TABLE stg.customers_cleaned (
    customer_id             NVARCHAR(50)   NOT NULL,
    customer_unique_id      NVARCHAR(50)   NOT NULL,
    customer_zip_code_prefix VARCHAR(10)   NULL,
    customer_lat            DECIMAL(18,8)  NULL,
    customer_lng            DECIMAL(18,8)  NULL,
    customer_city           NVARCHAR(100)  NULL,
    customer_state          NVARCHAR(50)   NULL
);
GO


/* =========================================================
   3. SELLERS_CLEANED
   ========================================================= */
IF OBJECT_ID ('stg.sellers_cleaned', 'U') IS NOT NULL
    DROP TABLE stg.sellers_cleaned;
GO

CREATE TABLE stg.sellers_cleaned (
    seller_id               NVARCHAR(50)  NOT NULL,
    seller_zip_code_prefix  VARCHAR(10)   NULL,
    seller_lat              DECIMAL(18,8) NULL,
    seller_lng              DECIMAL(18,8) NULL,
    seller_city             NVARCHAR(100) NULL,
    seller_state            NVARCHAR(50)  NULL
);
GO


/* =========================================================
   4. PAYMENTS_CLEANED
   ========================================================= */
IF OBJECT_ID ('stg.payments_cleaned', 'U') IS NOT NULL
    DROP TABLE stg.payments_cleaned;
GO

CREATE TABLE stg.payments_cleaned (
    order_id             NVARCHAR(50)  NOT NULL,
    payment_sequential   INT           NOT NULL,
    payment_type         NVARCHAR(50)  NOT NULL,
    payment_installments INT           NOT NULL,
    payment_value        DECIMAL(18,8) NOT NULL
);
GO


/* =========================================================
   5. PRODUCT_CATEGORY_TRANSLATE_NAME_CLEANED
   ========================================================= */
IF OBJECT_ID ('stg.product_category_translate_name_cleaned', 'U') IS NOT NULL
    DROP TABLE stg.product_category_translate_name_cleaned;
GO

CREATE TABLE stg.product_category_translate_name_cleaned (
    product_category_pt NVARCHAR(100) NULL,
    product_category_en NVARCHAR(100) NULL
);
GO


/* =========================================================
   6. PRODUCTS_CLEANED
   ========================================================= */
IF OBJECT_ID ('stg.products_cleaned', 'U') IS NOT NULL
    DROP TABLE stg.products_cleaned;
GO

CREATE TABLE stg.products_cleaned (
    product_id                NVARCHAR(50)  NOT NULL,
    product_category_pt       NVARCHAR(100) NULL,
    product_category_en       NVARCHAR(100) NULL,
    product_name_length       INT           NULL,
    product_description_length INT          NULL,
    product_photos_qty        INT           NULL,
    product_weight            DECIMAL(18,8) NULL,
    product_length            DECIMAL(18,8) NULL,
    product_height            DECIMAL(18,8) NULL,
    product_width             DECIMAL(18,8) NULL
);
GO


/* =========================================================
   7. ORDER_ITEMS_CLEANED
   ========================================================= */
IF OBJECT_ID ('stg.order_items_cleaned', 'U') IS NOT NULL
    DROP TABLE stg.order_items_cleaned;
GO

CREATE TABLE stg.order_items_cleaned (
    order_id            NVARCHAR(50)  NOT NULL,
    order_item_id       INT           NOT NULL,
    product_id          NVARCHAR(50)  NOT NULL,
    seller_id           NVARCHAR(50)  NOT NULL,
    shipping_limit_date DATETIME      NULL,
    shipping_date       DATE          NULL,
    price               DECIMAL(18,2) NULL,
    freight_value       DECIMAL(18,2) NULL
);
GO



/* =========================================================
   8. ORDERS_CLEANED
   ========================================================= */
IF OBJECT_ID ('stg.orders_cleaned', 'U') IS NOT NULL
    DROP TABLE stg.orders_cleaned;
GO

CREATE TABLE stg.orders_cleaned (
    order_id                       NVARCHAR(50) NOT NULL,
    customer_id                    NVARCHAR(50) NOT NULL,
    order_status                   NVARCHAR(50) NOT NULL,
    order_purchase_time_stamp      DATETIME     NULL,
    order_purchase_date            DATE         NULL,
    order_approved_at              DATETIME     NULL,
    order_approved_date            DATE         NULL,
    order_delivered_carrier_date   DATETIME     NULL,
    order_carrier_date             DATE         NULL,
    order_delivered_customer_date  DATETIME     NULL,
    order_delivered_date           DATE         NULL,
    order_estimated_delivery_date  DATETIME     NULL,
    order_estimated_date           DATE         NULL
);
GO


/* =========================================================
   9. REVIEWS_CLEANED
   ========================================================= */
IF OBJECT_ID ('stg.reviews_cleaned', 'U') IS NOT NULL
    DROP TABLE stg.reviews_cleaned;
GO

CREATE TABLE stg.reviews_cleaned (
    review_id               NVARCHAR(50)   NOT NULL,
    order_id                NVARCHAR(50)   NOT NULL,
    review_score            INT            NOT NULL,
    review_comment_title    NVARCHAR(1000) NULL,
    review_comment_message  NVARCHAR(MAX)  NULL,
    review_creation_datetime DATETIME      NULL,
    review_creation_date    DATE           NULL,
    review_answer_datetime  DATETIME       NULL,
    review_answer_date      DATE           NULL
);
GO

