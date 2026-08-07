CREATE PROCEDURE [staging].[sp_Load_Staging_Sales]
AS
BEGIN
    SET NOCOUNT ON;

    PRINT 'Loading staging.Sales...';

    TRUNCATE TABLE staging.Sales;

    BULK INSERT staging.Sales
    FROM 'C:\D Drive\Anil\GitHub\enterprise-sql-platform-lab\datasets\sales\full\sales_500000.csv'
    WITH
    (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0A',
        TABLOCK
    );

    PRINT 'Sales staging load completed.';
END;
GO