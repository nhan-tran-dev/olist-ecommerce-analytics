USE master;
GO

-- drop and recreate the "Olist_ECommerce_WH" database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'Olist_ECommerce_WH')
BEGIN 
    ALTER DATABASE Olist_ECommerce_WH 
        SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Olist_ECommerce_WH;
END;
GO

-- create "Olist_ECommerce_WH" database 
CREATE DATABASE Olist_ECommerce_WH;
GO

USE Olist_ECommerce_WH;
GO

-- create schemas 
CREATE SCHEMA stg;
GO

CREATE SCHEMA dw;
GO
