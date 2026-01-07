/* =========================================================
   FACT_ORDERS
   ========================================================= */
IF OBJECT_ID ('dw.usp_load_fact_orders', 'P') IS NOT NULL
	DROP PROCEDURE dw.usp_load_fact_orders;
GO

CREATE PROCEDURE dw.usp_load_fact_orders 
AS
BEGIN
	SET NOCOUNT ON;
	
	INSERT INTO dw.fact_orders (
		order_id,
		customer_key,
		order_status,
		order_purchase_date,
		order_approved_date,
		order_carrier_date,
		order_delivered_date,
		order_estimated_date,
		customer_id,
		handling_time_days,				-- phân tích số ngày xử lý đơn từ approved đơn -> delivery carrier (carrier_date – approved_date)
		shipping_time_days,				-- phân tích số ngày vận chuyển carrier date -> delivered date (delivered_date – carrier_date)
		delivery_time_days,				-- phân tích số ngày từ approved date --> delivered date (delivered_date – approved_date)
		delivery_delay_days,			-- phân tích số ngày từ esimated date -> delivered date (delivered_date – estimated_date)
		is_canceled,
		is_delivered,
		is_late_delivery
)
	SELECT
		o.order_id,
        c.customer_key,
        o.order_status,
        o.order_purchase_date,
        o.order_approved_date,
        o.order_carrier_date,
        o.order_delivered_date,
        o.order_estimated_date,
		cu.customer_id,
		handling_time_days = DATEDIFF(day, o.order_approved_date, o.order_carrier_date),
		shipping_time_days = DATEDIFF(day, o.order_carrier_date, o.order_delivered_date),
		delivery_time_days = DATEDIFF(day, o.order_approved_date, o.order_delivered_date),
		delivery_delay_days = DATEDIFF(day, o.order_estimated_date, o.order_delivered_date),
		is_canceled = CASE
						WHEN o.order_status = 'canceled' THEN 1 ELSE 0 END,
		is_delivered = CASE	
						WHEN o.order_status = 'delivered' THEN 1 ELSE 0 END,
		is_late_delivery = CASE
							WHEN o.order_delivered_date > o.order_estimated_date and o.order_status = 'delivered'
							THEN 1 ELSE 0 END
	FROM stg.orders_cleaned o
	JOIN stg.customers_cleaned cu
	ON o.customer_id = cu.customer_id
	JOIN dw.dim_customers c
	ON cu.customer_unique_id = c.customer_unique_id
	LEFT JOIN dw.fact_orders f
    ON o.order_id = f.order_id
    WHERE f.order_id IS NULL;
END;
GO


/* =========================================================
   FACT_ORDER_ITEMS
   ========================================================= */
IF OBJECT_ID ('dw.usp_load_fact_order_items', 'P') IS NOT NULL
	DROP PROCEDURE dw.usp_load_fact_order_items;
GO

CREATE PROCEDURE dw.usp_load_fact_order_items
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO dw.fact_order_items (
		order_id,
		order_item_id,
		product_key,
		seller_key,
		product_id,
		seller_id,
		shipping_limit_date,
		price,
		freight_value,
		item_gross_revenue,					-- doanh thu cho each item trong olist = price (có thể thay đổi rule sau này: quantity, discount, tax…) 
		is_free_shipping
	)
	SELECT 
		oi.order_id,
		oi.order_item_id,
		p.product_key,
		s.seller_key,
		oi.product_id,
		oi.seller_id,
		oi.shipping_limit_date,
		oi.price,
		oi.freight_value,
		item_gross_revenue = oi.price,					 
		is_free_shipping = CASE
							WHEN oi.freight_value = 0 THEN 1 ELSE 0 END
	FROM stg.order_items_cleaned oi
	JOIN dw.dim_products p
	ON oi.product_id = p.product_id
	JOIN dw.dim_sellers s
	ON oi.seller_id = s.seller_id
	LEFT JOIN dw.fact_order_items f
	ON oi.order_id = f.order_id
	AND oi.order_item_id = f.order_item_id
	WHERE f.order_id IS NULL;
END;
GO


/* =========================================================
   FACT_PAYMENTS
   ========================================================= */
IF OBJECT_ID ('dw.usp_load_fact_payments', 'P') IS NOT NULL
	DROP PROCEDURE dw.usp_load_fact_payments;
GO

CREATE PROCEDURE dw.usp_load_fact_payments
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO dw.fact_payments (
		order_id,
		payment_sequential,
		payment_type,
		payment_installments,
		payment_value,
		order_payment_date,							-- ngày payment_date  = order_approved_date
		is_installment,								-- trả góp khi payment_installments > 1 elso 0
		total_order_paid_amount						-- tổng giá trị thanh toán trên 1 đơn hàng: total_order_paid_amount = SUM(payment_value) OVER (PARTITION BY order_id)
)
	SELECT
		pa.order_id,
		pa.payment_sequential,
		pa.payment_type,
		pa.payment_installments,
		pa.payment_value,
		order_payment_date = o.order_approved_date,							
		is_installment = CASE
							WHEN pa.payment_installments > 1 THEN 1 ELSE 0 END,								
		total_order_paid_amount = SUM(pa.payment_value) OVER (PARTITION BY pa.order_id)
	FROM stg.payments_cleaned pa
	JOIN dw.fact_orders o
	ON pa.order_id = o.order_id
	LEFT JOIN dw.fact_payments f
	ON f.order_id = pa.order_id
	AND f.payment_sequential = pa.payment_sequential
	WHERE f.order_id IS NULL;
END;
GO

/* =========================================================
   FACT_REVIEWS
   ========================================================= */
IF OBJECT_ID ('dw.usp_load_fact_reviews', 'P') IS NOT NULL
	DROP PROCEDURE dw.usp_load_fact_reviews;
GO

CREATE PROCEDURE dw.usp_load_fact_reviews
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO dw.fact_reviews (
		review_id,
		order_id,
		review_score,
		review_comment_title,
		review_comment_message,
		review_creation_date,
		review_answer_date,
		has_comment,								-- 1: review_title or review_message is not null else 0
		comment_rate								-- "good" (score = 4-5), "normal" (score = 3), "bad" (score = 1-2)
	)
	SELECT 
		r.review_id,
		r.order_id,
		r.review_score,
		r.review_comment_title,
		r.review_comment_message,
		r.review_creation_date,
		r.review_answer_date,
		has_comment = CASE
							WHEN NULLIF(TRIM(r.review_comment_title),   '') IS NOT NULL
							OR NULLIF(TRIM(r.review_comment_message), '') IS NOT NULL
							THEN 1 ELSE 0
							END,								
		comment_rate = CASE 
							WHEN r.review_score = 4 or r.review_score = 5 THEN 'good'
							WHEN r.review_score = 1 or r.review_score = 2 THEN 'bad'
							ELSE 'normal' END
	FROM stg.reviews_cleaned r
	LEFT JOIN dw.fact_reviews f
	ON r.review_id = f.review_id
	WHERE f.review_id IS NULL;
END;
GO


















