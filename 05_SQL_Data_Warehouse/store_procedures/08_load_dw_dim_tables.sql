/* =========================================================
   DIM_CUSTOMERS
   ========================================================= */
IF OBJECT_ID ('dw.usp_load_dim_customers', 'P') IS NOT NULL
	DROP PROCEDURE dw.usp_load_dim_customers;
GO

CREATE PROCEDURE dw.usp_load_dim_customers 
AS
BEGIN
	SET NOCOUNT ON;
	
	WITH cte AS 
(
    SELECT
        *
    FROM (
        SELECT
            c.customer_unique_id,
            c.customer_id,
            c.customer_zip_code_prefix,
            c.customer_lat,
            c.customer_lng,
            c.customer_city,
            c.customer_state,
            s.region_name as customer_region,
            ROW_NUMBER() OVER (
                PARTITION BY customer_unique_id 
                ORDER BY customer_id
            ) as rn
        FROM stg.customers_cleaned c
        LEFT JOIN ref.state_region_map s
            ON c.customer_state = s.state_code
    ) as t1
    WHERE rn = 1
	)
	INSERT INTO dw.dim_customers (
		customer_unique_id,
		customer_id,
		customer_zip_code_prefix,
		customer_lat,
		customer_lng,
		customer_city,
		customer_state,
		customer_region
	)
	SELECT
		c.customer_unique_id,
		c.customer_id,
		c.customer_zip_code_prefix,
		c.customer_lat,
		c.customer_lng,
		c.customer_city,
		c.customer_state,
		c.customer_region
	FROM cte c
	LEFT JOIN dw.dim_customers dc                                   -- lấy tất cả c.customer_unique_id
		ON c.customer_unique_id = dc.customer_unique_id             -- Kiểm tra với dim_customers.customer_unique_id có tồn tại chưa?
	WHERE dc.customer_unique_id is NULL;                            -- nếu dc.customer_unique_id là null thì insert vào (những customer mới)
END;
GO

/* ============================================
   DIM_SELLERS
   ============================================ */
IF OBJECT_ID ('dw.usp_load_dim_sellers', 'P') IS NOT NULL
	DROP PROCEDURE dw.usp_load_dim_sellers;
GO

CREATE PROCEDURE dw.usp_load_dim_sellers
AS
BEGIN
	SET NOCOUNT ON;
	
	INSERT INTO dw.dim_sellers (
		seller_id,
		seller_zip_code_prefix,
		seller_lat,
		seller_lng,
		seller_city,
		seller_state,
		seller_region
	)
	SELECT
		s.seller_id,
		s.seller_zip_code_prefix,
		s.seller_lat,
		s.seller_lng,
		s.seller_city,
		s.seller_state,
		sr.region_name as seller_region
	FROM stg.sellers_cleaned s
	LEFT JOIN ref.state_region_map sr
	ON s.seller_state = sr.state_code
	LEFT JOIN dw.dim_sellers ds					-- lấy toàn bộ sellers của stg.sellers_cleaned
	ON s.seller_id = ds.seller_id				-- kiểm tra với dim_sellers.seller_id có tồn tại chưa?
	WHERE ds.seller_id IS NULL;					-- nếu ds.seller_id is null chưa có thì thêm vào.
END;
GO

/* ============================================
   DIM_PRODUCTS
   ============================================ */
IF OBJECT_ID ('dw.usp_load_dim_products', 'P') IS NOT NULL
	DROP PROCEDURE dw.usp_load_dim_products;
GO

CREATE PROCEDURE dw.usp_load_dim_products
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO dw.dim_products (
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
		p.product_id,
		p.product_category_pt,
		p.product_category_en,
		p.product_name_length,
		p.product_description_length,
		p.product_photos_qty,
		p.product_weight,
		p.product_length,
		p.product_height,
		p.product_width
	FROM stg.products_cleaned p
	LEFT JOIN dw.dim_products dp
	ON p.product_id = dp.product_id
	WHERE dp.product_id IS NULL;
END;
GO


/* =========================================================
   DIM_DATE
   ========================================================= */
IF OBJECT_ID ('dw.usp_load_dim_date', 'P') IS NOT NULL
	DROP PROCEDURE dw.usp_load_dim_date;
GO

CREATE PROCEDURE dw.usp_load_dim_date
AS
BEGIN
	SET NOCOUNT ON;
	
	-- Tạo dữ liệu dim_date từ min date đến ngày hiện tại
	DECLARE @StartDate DATE;
	DECLARE @EndDate   DATE;

	-- Lấy ngày nhỏ nhất từ dữ liệu (từ bảng orders trong staging)
	SELECT @StartDate = CAST(MIN(order_purchase_date) AS DATE)
	FROM stg.orders_cleaned;   

	-- Ngày lớn nhất từ dữ liệu (từ bảng orders trong staging)
	SELECT @EndDate = CAST(MAX(order_purchase_date) AS DATE)
	FROM stg.orders_cleaned;

	;WITH Dates AS (
		SELECT @StartDate AS full_date
		UNION ALL
		SELECT DATEADD(DAY, 1, full_date)
		FROM Dates
		WHERE full_date < @EndDate
	)
	INSERT INTO dw.dim_date (
		full_date,
		[year],
		[quarter],
		month_number,
		month_name,
		day_of_month,
		day_of_week,
		day_name,
		is_weekend,
		is_holiday
	)
	SELECT
		d.full_date,
		YEAR(d.full_date)                           AS [year],
		DATEPART(QUARTER, d.full_date)              AS [quarter],
		MONTH(d.full_date)                          AS month_number,
		DATENAME(MONTH, d.full_date)                AS month_name,
		DAY(d.full_date)                            AS day_of_month,
		-- Chuẩn hoá: 1 = Monday, ..., 7 = Sunday
		((DATEPART(WEEKDAY, d.full_date) + @@DATEFIRST - 2) % 7) + 1 AS day_of_week,
		DATENAME(WEEKDAY, d.full_date)              AS day_name,
		CASE 
			-- 6 = Saturday, 7 = Sunday theo mapping ở trên
			WHEN ((DATEPART(WEEKDAY, d.full_date) + @@DATEFIRST - 2) % 7) + 1 IN (6, 7) 
				THEN 1 
			ELSE 0 
		END AS is_weekend,
		COALESCE(r.is_holiday, 0) as is_holiday
	FROM Dates d
	LEFT JOIN ref.holidays r
	ON d.full_date = r.holiday_date
	LEFT JOIN dw.dim_date dd
    ON dd.full_date = d.full_date          -- check existing dim
    WHERE dd.full_date IS NULL
	OPTION (MAXRECURSION 0);
END;
GO

