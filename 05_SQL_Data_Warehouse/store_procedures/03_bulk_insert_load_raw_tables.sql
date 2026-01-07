CREATE OR ALTER PROCEDURE stg.load_stg_raw AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME;
    DECLARE @batch_start_time DATETIME, @batch_end_time DATETIME;
    PRINT '=====================================';
    PRINT 'Loading stg_raw Layer';
    PRINT '=====================================';

    SET @batch_start_time = GETDATE();
    SET @start_time = GETDATE();
    PRINT '>> Truncating Table: stg.orders_raw';
    truncate table stg.orders_raw;

    PRINT '>> Inserting Data Into: stg.orders_raw';
    bulk insert stg.orders_raw
    from 'D:\Data Analysis\Furnix Data Analyst Course\Đồ án cuối khoá_phân tích dữ liệu\Source\E_commerce Data\olist_orders_dataset.csv'
    WITH (
      FORMAT='CSV',
      FIRSTROW = 2,                 -- bỏ header
      FIELDQUOTE = '"',
      FIELDTERMINATOR = ',',
      ROWTERMINATOR = '0x0a',       -- line feed
      TABLOCK,
      CODEPAGE = '65001'            -- UTF-8
    );
    SET @end_time = GETDATE();
    PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + 'seconds';
    PRINT '---------------'
    
    SET @start_time = GETDATE();
    PRINT '>> Truncating Table: stg.order_items_raw';
    truncate table stg.order_items_raw

    PRINT '>> Inserting Data Into: stg.order_items_raw';
    bulk insert stg.order_items_raw
    from 'D:\Data Analysis\Furnix Data Analyst Course\Đồ án cuối khoá_phân tích dữ liệu\Source\E_commerce Data\olist_order_items_dataset.csv'
    with (
    FORMAT='CSV',
      FIRSTROW = 2,                 -- bỏ header
      FIELDQUOTE = '"',
      FIELDTERMINATOR = ',',
      ROWTERMINATOR = '0x0a',       -- line feed
      TABLOCK,
      CODEPAGE = '65001'            -- UTF-8
    );
    SET @end_time = GETDATE();
    PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + 'seconds';
    PRINT '---------------'

    SET @start_time = GETDATE();   
    PRINT '>> Truncating Table: stg.payments_raw';
    truncate table stg.payments_raw;

    PRINT '>> Inserting Data Into: stg.payments_raw';
    bulk insert stg.payments_raw
    from 'D:\Data Analysis\Furnix Data Analyst Course\Đồ án cuối khoá_phân tích dữ liệu\Source\E_commerce Data\olist_order_payments_dataset.csv'
    with (
    FORMAT='CSV',
      FIRSTROW = 2,                 -- bỏ header
      FIELDQUOTE = '"',
      FIELDTERMINATOR = ',',
      ROWTERMINATOR = '0x0a',       -- line feed
      TABLOCK,
      CODEPAGE = '65001'            -- UTF-8
    );
    SET @end_time = GETDATE();
    PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + 'seconds';
    PRINT '---------------'

    SET @start_time = GETDATE();
    PRINT '>> Truncating Table: stg.reviews_raw';
    truncate table stg.reviews_raw;

    PRINT '>> Inserting Data Into: stg.reviews_raw';
    bulk insert stg.reviews_raw
    from N'D:\Data Analysis\Furnix Data Analyst Course\Đồ án cuối khoá_phân tích dữ liệu\Source\E_commerce Data\olist_order_reviews_dataset.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0D0A',
        CODEPAGE = '65001',
        TABLOCK
    );
    SET @end_time = GETDATE();
    PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + 'seconds';
    PRINT '---------------'

    SET @start_time = GETDATE()
    PRINT '>> Truncating Table: stg.products_raw';
    truncate table stg.products_raw;

    PRINT '>> Inserting Data Into: stg.products_raw';
    bulk insert stg.products_raw
    from 'D:\Data Analysis\Furnix Data Analyst Course\Đồ án cuối khoá_phân tích dữ liệu\Source\E_commerce Data\olist_products_dataset.csv'
    WITH (
        FORMAT = 'CSV',
        FIRSTROW = 2,                 -- bỏ header
        DATAFILETYPE = 'char',
        CODEPAGE = '65001',
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0A',
        KEEPNULLS,
        TABLOCK           -- UTF-8
    );
    SET @end_time = GETDATE();
    PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + 'seconds';
    PRINT '---------------'
 
    SET @start_time = GETDATE()
    PRINT '>> Truncating Table: stg.customers_raw';
    truncate table stg.customers_raw;

    PRINT '>> Inserting Data Into: stg.customers_raw';
    bulk insert stg.customers_raw
    from 'D:\Data Analysis\Furnix Data Analyst Course\Đồ án cuối khoá_phân tích dữ liệu\Source\E_commerce Data\olist_customers_dataset.csv'
    with (
        format = 'CSV',
        firstrow = 2,
        DATAFILETYPE = 'char',
        CODEPAGE = '65001',
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0A',
        KEEPNULLS,
        TABLOCK           -- UTF-8
    );
    SET @end_time = GETDATE();
    PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + 'seconds';
    PRINT '---------------'
    
    SET @start_time = GETDATE();
    PRINT '>> Truncating Table: stg.sellers_raw';
    truncate table stg.sellers_raw;

    PRINT '>> Inserting Data Into: stg.sellers_raw';
    bulk insert stg.sellers_raw
    from 'D:\Data Analysis\Furnix Data Analyst Course\Đồ án cuối khoá_phân tích dữ liệu\Source\E_commerce Data\olist_sellers_dataset.csv'
    with (
            format = 'CSV',
        firstrow = 2,
        DATAFILETYPE = 'char',
        CODEPAGE = '65001',
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0A',
        KEEPNULLS,
        TABLOCK           -- UTF-8
    );
    SET @end_time = GETDATE();
    PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + 'seconds';
    PRINT '---------------'
    
    SET @start_time = GETDATE();
    PRINT '>> Truncating Table: stg.geolocation_raw';
    TRUNCATE TABLE stg.geolocation_raw;

    PRINT '>> Inserting Data Into: stg.geolocation_raw';
    BULK INSERT stg.geolocation_raw
    FROM 'D:\Data Analysis\Furnix Data Analyst Course\Đồ án cuối khoá_phân tích dữ liệu\Source\E_commerce Data\olist_geolocation_dataset.csv'
    WITH (
         FORMAT = 'CSV',
         FIRSTROW = 2,
         FIELDTERMINATOR = ',',
         FIELDQUOTE = '"',
         ROWTERMINATOR = '0x0A',
         CODEPAGE = '65001',
         KEEPNULLS,
         TABLOCK
    );
    SET @end_time = GETDATE();
    PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + 'seconds';
    PRINT '---------------'

    SET @start_time = GETDATE();
    PRINT '>> Truncating Table: stg.product_category_translate_name_raw';
    TRUNCATE TABLE stg.product_category_translate_name_raw;

    PRINT '>> Inserting Data Into: stg.product_category_translate_name_raw';
    BULK INSERT stg.product_category_translate_name_raw
    FROM 'D:\Data Analysis\Furnix Data Analyst Course\Đồ án cuối khoá_phân tích dữ liệu\Source\E_commerce Data\product_category_name_translation.csv'
    WITH  (
          FORMAT = 'CSV',
          FIRSTROW = 2,
          FIELDTERMINATOR = ',',
          CODEPAGE = '65001',
          KEEPNULLS,
          TABLOCK
    );
    SET @end_time = GETDATE();
    PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + 'seconds';
    PRINT '---------------'

    SET @batch_end_time = GETDATE();
    PRINT '=========================================';
    PRINT 'Loading stg_raw Layer is completed:';
    PRINT '     - Total Load Duration:' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) as NVARCHAR) + ' seconds';
    PRINT '=========================================';
END