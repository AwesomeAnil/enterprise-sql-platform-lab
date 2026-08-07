CREATE PROCEDURE [staging].[sp_Load_Staging_SalesTerritory_Docker]
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '[DOCKER] Loading staging.SalesTerritory...';

    TRUNCATE TABLE staging.SalesTerritory;

    BULK INSERT staging.SalesTerritory
    FROM '/var/opt/mssql/import/territory/salesterritory_50.csv'
    WITH
    (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0A',
        TABLOCK
    );

    PRINT '[DOCKER] Sales Territory staging load completed.';
END;
GO