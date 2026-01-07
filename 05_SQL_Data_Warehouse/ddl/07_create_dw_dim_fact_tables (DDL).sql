/* =========================================================
   DIM_CUSTOMERS
   ========================================================= */
IF OBJECT_ID ('dw.dim_customers', 'U') IS NOT NULL
	DROP TABLE dw.dim_customers;
GO

CREATE TABLE dw.dim_customers (
	customer_key INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	customer_unique_id NVARCHAR(50) NOT NULL,
	customer_id NVARCHAR(50) NULL, 
	customer_zip_code_prefix VARCHAR(10),
	customer_lat DECIMAL(18,8),
	customer_lng DECIMAL(18,8),
	customer_city NVARCHAR(50),
	customer_state NVARCHAR(50),
	customer_region NVARCHAR(50)		-- phân tích theo khu vực
);
GO

/* =========================================================
   DIM_SELLERS
   ========================================================= */
IF OBJECT_ID ('dw.dim_sellers', 'U') IS NOT NULL
	DROP TABLE dw.dim_sellers;
GO

CREATE TABLE dw.dim_sellers (
	seller_key INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	seller_id NVARCHAR(50) NOT NULL,
	seller_zip_code_prefix VARCHAR(10),
	seller_lat DECIMAL(18,8),
	seller_lng DECIMAL(18,8),
	seller_city NVARCHAR(50),
	seller_state NVARCHAR(50),
	seller_region NVARCHAR(50)			-- phân tích theo khu vực
);
GO

/* =========================================================
   DIM_PRODUCTS
   ========================================================= */
IF OBJECT_ID ('dw.dim_products', 'U') IS NOT NULL
	DROP TABLE dw.dim_products;
GO

CREATE TABLE dw.dim_products (
	product_key INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	product_id NVARCHAR(50) NOT NULL,
	product_category_pt NVARCHAR(50),
	product_category_en NVARCHAR(50),
	product_name_length DECIMAL(18,8),
	product_description_length DECIMAL(18,8),
	product_photos_qty DECIMAL(10,2),
	product_weight DECIMAL(10,2),
	product_length DECIMAL(10,2),
	product_height DECIMAL(10,2),
	product_width DECIMAL(10,2)
);
GO

/* =========================================================
   FACT_ORDERS
   ========================================================= */
IF OBJECT_ID ('dw.fact_orders', 'U') IS NOT NULL
	DROP TABLE dw.fact_orders;
GO

CREATE TABLE dw.fact_orders (
	order_id NVARCHAR(50) PRIMARY KEY NOT NULL,
	customer_key INT NOT NULL,
	order_status NVARCHAR(50) NOT NULL,
	order_purchase_date DATE,
	order_approved_date DATE,
	order_carrier_date DATE,
	order_delivered_date DATE,
	order_estimated_date DATE,
	customer_id NVARCHAR(50),
	handling_time_days INT,				-- phân tích số ngày xử lý đơn từ approved đơn -> delivery carrier (carrier_date – approved_date)
	shipping_time_days INT,				-- phân tích số ngày vận chuyển carrier date -> delivered date (delivered_date – carrier_date)
	delivery_time_days INT,				-- phân tích số ngày từ approved date --> delivered date (delivered_date – approved_date)
	delivery_delay_days INT,			-- phân tích số ngày từ esimated date -> delivered date (delivered_date – estimated_date)
	is_canceled BIT,
	is_delivered BIT,
	is_late_delivery BIT
);
GO

/* =========================================================
   FACT_ORDER_ITEMS
   ========================================================= */
IF OBJECT_ID ('dw.fact_order_items', 'U') IS NOT NULL
    DROP TABLE dw.fact_order_items;
GO

CREATE TABLE dw.fact_order_items (
    order_id            NVARCHAR(50) NOT NULL,
    order_item_id       INT NOT NULL,
    product_key         INT NOT NULL,
    seller_key          INT NOT NULL,
    product_id          NVARCHAR(50) NOT NULL,
    seller_id           NVARCHAR(50) NOT NULL,
    shipping_limit_date DATE,
    price               DECIMAL(18,2),
    freight_value       DECIMAL(18,2),
	item_gross_revenue	DECIMAL(18,2),					-- doanh thu cho each item trong olist = price (có thể thay đổi rule sau này: quantity, discount, tax…) 
    is_free_shipping    BIT NOT NULL,					-- 1 free, 0 None
    CONSTRAINT PK_fact_order_items PRIMARY KEY (order_id, order_item_id)
);
GO


/* =========================================================
   FACT_PAYMENTS
   ========================================================= */
IF OBJECT_ID ('dw.fact_payments', 'U') IS NOT NULL
	DROP TABLE dw.fact_payments;
GO

CREATE TABLE dw.fact_payments (
    order_id            NVARCHAR(50) NOT NULL,
    payment_sequential  INT NOT NULL,
    payment_type        NVARCHAR(50) NOT NULL,
    payment_installments INT,
    payment_value       DECIMAL(18,2),
    order_payment_date  DATE,							-- ngày payment_date  = order_approved_date
    is_installment      BIT NOT NULL DEFAULT 0,			-- trả góp khi payment_installments > 1 elso 0
    total_order_paid_amount DECIMAL(18,2),				-- tổng giá trị thanh toán trên 1 đơn hàng: total_order_paid_amount = SUM(payment_value) OVER (PARTITION BY order_id)
    CONSTRAINT PK_fact_payments PRIMARY KEY (order_id, payment_sequential)
);
GO

/* =========================================================
   FACT_REVIEWS
   ========================================================= */
IF OBJECT_ID ('dw.fact_reviews', 'U') IS NOT NULL
	DROP TABLE dw.fact_reviews;
GO

CREATE TABLE dw.fact_reviews (
	review_id NVARCHAR(50) PRIMARY KEY NOT NULL,
	order_id NVARCHAR(50) NOT NULL,
	review_score INT NOT NULL,
	review_comment_title NVARCHAR(500),
	review_comment_message NVARCHAR(500),
	review_creation_date DATE,
	review_answer_date DATE,
	has_comment BIT NOT NULL DEFAULT 0,					-- 1: review_title or review_message is not null else 0
	comment_rate NVARCHAR(10)							-- "good" (score = 4-5), "normal" (score = 3), "bad" (score = 1-2)
);
GO

/* =========================================================
   DIM_DATE
   ========================================================= */
IF OBJECT_ID('dw.dim_date', 'U') IS NOT NULL
    DROP TABLE dw.dim_date;
GO

CREATE TABLE dw.dim_date (
    full_date       DATE        NOT NULL PRIMARY KEY,  -- dùng full_date làm key
    [year]          INT         NOT NULL,
    [quarter]       TINYINT     NOT NULL,
    month_number    TINYINT     NOT NULL,
    month_name      NVARCHAR(20) NOT NULL,
    day_of_month    TINYINT     NOT NULL,
    day_of_week     TINYINT     NOT NULL,      -- 1–7
    day_name        NVARCHAR(20) NOT NULL,
    is_weekend      BIT         NOT NULL,
	is_holiday		BIT			NOT NULL DEFAULT(0)
);
GO





