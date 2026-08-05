CREATE PROCEDURE [staging].[sp_Load_Staging_Product]
AS
BEGIN
    SET NOCOUNT ON;

    PRINT 'Loading staging.Product...';

    TRUNCATE TABLE staging.Product;

    BULK INSERT staging.Product
    FROM 'C:\D Drive\Anil\GitHub\enterprise-sql-platform-lab\datasets\product\product_5000.csv'
    WITH
    (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0A',
        TABLOCK
    );

    PRINT 'Product staging load completed.';
END;
GO