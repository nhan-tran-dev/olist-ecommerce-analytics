--CREATE SCHEMA mart;


IF OBJECT_ID ('mart.customer_rfm_clusters', 'U') IS NOT NULL
	DROP TABLE mart.customer_rfm_clusters;
GO
CREATE TABLE mart.customer_rfm_clusters (
	customer_key INT PRIMARY KEY NOT NULL,
	recency_days INT NOT NULL,
	frequency INT NOT NULL,
	amount Decimal(10,2) NOT NULL,
	clusters INT,
	cluster_name NVARCHAR(50),
	description NVARCHAR(225)
);
GO




