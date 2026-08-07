CREATE PROCEDURE [staging].[sp_Load_Staging_Geography_Docker]
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '[DOCKER] Loading staging.Geography...';

    TRUNCATE TABLE staging.Geography;

    BULK INSERT staging.Geography
    FROM '/var/opt/mssql/import/geography/geography_250.csv'
    WITH
    (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0A',
        TABLOCK
    );

    PRINT '[DOCKER] Geography staging load completed.';
END;
GO