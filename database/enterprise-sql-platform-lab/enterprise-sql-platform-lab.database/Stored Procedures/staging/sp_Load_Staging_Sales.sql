CREATE PROCEDURE [staging].[sp_Load_Staging_Sales]
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '[INFO] Loading staging.Sales...';

    TRUNCATE TABLE staging.Sales;

    BULK INSERT staging.Sales
    FROM 'C:\D Drive\Anil\GitHub\enterprise-sql-platform-lab\datasets\sales\sales_500000.csv'
    WITH
    (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0A',
        TABLOCK
    );

    DECLARE @RowCount INT;

    SELECT @RowCount = COUNT(*)
    FROM staging.Sales;

    PRINT '[PASS] Sales staging load completed.';
    PRINT '[PASS] Sales Rows Loaded : '
        + CAST(@RowCount AS VARCHAR(20));

END;
GO