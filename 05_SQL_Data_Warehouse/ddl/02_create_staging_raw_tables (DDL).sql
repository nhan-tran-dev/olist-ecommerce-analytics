IF OBJECT_ID ('stg.orders_raw', 'U') IS NOT NULL
	DROP TABLE stg.orders_raw;
CREATE TABLE stg.orders_raw (
	order_id nvarchar(50),
	customer_id nvarchar(50),
	order_status nvarchar(50),
	order_purchase_time_stamp datetime,
	order_approved_at datetime,
	order_delivered_carrier_date datetime,
	order_delivered_customer_date datetime,
	order_estimated_delivery_date datetime
);

IF OBJECT_ID ('stg.order_items_raw', 'U') IS NOT NULL
	DROP TABLE stg.order_items_raw;
CREATE TABLE stg.order_items_raw (
	order_id nvarchar(50),
	order_item_id INT,
	product_id nvarchar(50),
	seller_id nvarchar(50),
	shipping_limit_date datetime,
	price decimal(18,2),
	freight_value decimal(18,2)
);

IF OBJECT_ID ('stg.payments_raw', 'U') IS NOT NULL
	DROP TABLE stg.payments_raw;
CREATE TABLE stg.payments_raw (
	order_id nvarchar(50),
	payment_squential INT,
	payment_type nvarchar(50),
	payment_installments INT,
	payment_value decimal(18,2)
);

IF OBJECT_ID ('stg.reviews_raw', 'U') IS NOT NULL
	DROP TABLE stg.reviews_raw;
CREATE TABLE stg.reviews_raw (
	review_id nvarchar(50),
	order_id nvarchar(50),
	review_score INT,
	review_comment_title nvarchar(500),
	review_comment_message nvarchar(500),
	review_creation_date datetime,
	review_answer_timestamp datetime
);

IF OBJECT_ID ('stg.products_raw', 'U') IS NOT NULL
	DROP TABLE stg.products_raw;
CREATE TABLE stg.products_raw (
	product_id nvarchar(50),
	product_category_name nvarchar(50),
	product_name_lenght decimal(18,2),
	product_description_lenght decimal(18,2),
	product_photos_qty DECIMAL(18,8),
	product_weight_g DECIMAL(18,8),
	product_length_cm DECIMAL(18,8),
	product_height_cm DECIMAL(18,8),
	product_width_cm DECIMAL(18,8)
);

IF OBJECT_ID ('stg.customers_raw', 'U') IS NOT NULL
	DROP TABLE stg.customers_raw;
CREATE TABLE stg.customers_raw (
	customer_id nvarchar(50),
	customer_unique_id nvarchar(50),
	customer_zip_code_prefix varchar(10),
	customer_city nvarchar(50),
	customer_state nvarchar(50)
);

IF OBJECT_ID ('stg.sellers_raw', 'U') IS NOT NULL
	DROP TABLE stg.sellers_raw;
CREATE TABLE stg.sellers_raw (
	seller_id nvarchar(50),
	seller_zip_code_prefix varchar(10),
	seller_city nvarchar(50),
	seller_state nvarchar(50)
);

IF OBJECT_ID ('stg.geolocation_raw', 'U') IS NOT NULL
	DROP TABLE stg.geolocation_raw;
CREATE TABLE stg.geolocation_raw (
	geolocation_zip_code_prefix varchar(10),
	geolocation_lat decimal(18,8),
	geolocation_lng decimal(18,8),
	geolocation_city nvarchar(50),
	geolocation_state nvarchar(50)
);

IF OBJECT_ID ('stg.product_category_translate_name_raw', 'U') IS NOT NULL
	DROP TABLE stg.product_category_translate_name_raw;
CREATE TABLE stg.product_category_translate_name_raw (
	product_category_name nvarchar(50),
	product_category_name_english nvarchar(50)
);
	