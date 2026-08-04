TRUNCATE TABLE staging.Customer;
GO

BULK INSERT staging.Customer
FROM '/tmp/customer_50000.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    TABLOCK
);
GO