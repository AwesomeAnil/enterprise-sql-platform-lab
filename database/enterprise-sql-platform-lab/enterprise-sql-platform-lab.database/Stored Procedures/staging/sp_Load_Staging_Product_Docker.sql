CREATE PROCEDURE [staging].[sp_Load_Staging_Product_Docker]
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '[DOCKER] Loading staging.Product...';

    TRUNCATE TABLE staging.Product;

    BULK INSERT staging.Product
    FROM '/var/opt/mssql/import/product/product_5000.csv'
    WITH
    (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0A',
        TABLOCK
    );

    PRINT '[DOCKER] Product staging load completed.';
END;
GO