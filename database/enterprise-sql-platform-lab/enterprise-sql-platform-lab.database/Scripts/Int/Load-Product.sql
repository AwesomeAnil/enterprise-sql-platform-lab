USE SalesDW;
GO

TRUNCATE TABLE staging.Product;
GO

BULK INSERT staging.Product
FROM '/tmp/product_5000.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    TABLOCK
);
GO