CREATE PROCEDURE [staging].[sp_Load_Staging_SalesTerritory]
AS
BEGIN
    SET NOCOUNT ON;

    PRINT 'Loading staging.SalesTerritory...';

    TRUNCATE TABLE staging.SalesTerritory;

    BULK INSERT staging.SalesTerritory
    FROM 'C:\D Drive\Anil\GitHub\enterprise-sql-platform-lab\datasets\territory\salesterritory_50.csv'
    WITH
    (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0A',
        TABLOCK
    );

    PRINT 'Sales Territory staging load completed.';
END;
GO