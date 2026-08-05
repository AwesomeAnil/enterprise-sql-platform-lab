USE SalesDW;
GO

TRUNCATE TABLE staging.Product;
GO

BULK INSERT staging.Product
FROM 'C:\D Drive\Anil\GitHub\enterprise-sql-platform-lab\datasets\product\product_5000.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    TABLOCK
);
GO

SELECT COUNT(*) AS ProductRows
FROM staging.Product;
GO