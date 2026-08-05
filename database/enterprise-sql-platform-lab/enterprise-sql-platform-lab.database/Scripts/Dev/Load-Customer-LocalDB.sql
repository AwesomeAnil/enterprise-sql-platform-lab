USE SalesDW;
GO

TRUNCATE TABLE staging.Customer;
GO

BULK INSERT staging.Customer
FROM 'C:\D Drive\Anil\GitHub\enterprise-sql-platform-lab\datasets\customer\customer_50000.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    TABLOCK
);
GO

SELECT COUNT(*) AS CustomerRows
FROM staging.Customer;
GO