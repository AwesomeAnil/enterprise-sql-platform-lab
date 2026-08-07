CREATE PROCEDURE [staging].[sp_Load_Staging_Salesperson_Docker]
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '[DOCKER] Loading staging.Salesperson...';

    TRUNCATE TABLE staging.Salesperson;

    BULK INSERT staging.Salesperson
    FROM '/var/opt/mssql/import/salesperson/salesperson_500.csv'
    WITH
    (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0A',
        TABLOCK
    );

    PRINT '[DOCKER] Salesperson staging load completed.';
END;
GO