IF OBJECT_ID ('mart.usp_build_customers_rfm', 'P') IS NOT NULL
	DROP PROCEDURE mart.usp_build_customers_rfm;
GO

CREATE PROCEDURE mart.usp_build_customers_rfm
AS
BEGIN
	SET NOCOUNT ON;
	TRUNCATE TABLE mart.customer_rfm_clusters;

	DECLARE @max_date date;
	SELECT @max_date = max(order_purchase_date) FROM dw.fact_orders;

	INSERT INTO mart.customer_rfm_clusters (
		customer_key,
		recency_days,
		frequency,
		amount
	)
	SELECT 
		c.customer_key,
		recency_days = DATEDIFF(day, max(o.order_purchase_date), @max_date),
		Frequency = COUNT(DISTINCT o.order_id),
		amount = SUM(p.total_order_paid_amount)
	FROM dw.dim_customers c
	JOIN dw.fact_orders o
	ON o.customer_key = c.customer_key
	AND o.order_purchase_date IS NOT NULL
	JOIN dw.fact_payments p
	ON o.order_id = p.order_id
	GROUP BY c.customer_key;
END;
GO


