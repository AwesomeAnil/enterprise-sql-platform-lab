CREATE PROCEDURE [staging].[sp_Load_Staging_Sales_Docker]
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '[DOCKER] Loading staging.Sales...';

    TRUNCATE TABLE staging.Sales;

    BULK INSERT staging.Sales
    FROM '/var/opt/mssql/import/sales/full/sales_500000.csv'
    WITH
    (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0A',
        TABLOCK
    );

    PRINT '[DOCKER] Sales staging load completed.';
END;
GO