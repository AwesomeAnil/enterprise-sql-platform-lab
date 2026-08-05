CREATE PROCEDURE [staging].[sp_Load_Staging_Customer]
AS
BEGIN
    SET NOCOUNT ON;

    PRINT 'Loading staging.Customer...';

    TRUNCATE TABLE staging.Customer;

    BULK INSERT staging.Customer
    FROM 'C:\D Drive\Anil\GitHub\enterprise-sql-platform-lab\datasets\customer\customer_50000.csv'
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