CREATE PROCEDURE [staging].[sp_Load_Staging_Customer_Docker]
AS
BEGIN
    SET NOCOUNT ON;

    PRINT 'Loading staging.Customer (Docker)...';

    TRUNCATE TABLE staging.Customer;

    BULK INSERT staging.Customer
    FROM '/var/opt/mssql/import/customer/full/customer_50000.csv'
    WITH
    (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0A',
        TABLOCK
    );

    PRINT 'Customer staging load completed.';
END;
GO