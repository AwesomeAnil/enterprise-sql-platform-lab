CREATE PROCEDURE [staging].[sp_Load_Staging_Geography]
AS
BEGIN
    SET NOCOUNT ON;

    PRINT 'Loading staging.Geography...';

    TRUNCATE TABLE staging.Geography;

    BULK INSERT staging.Geography
    FROM 'C:\D Drive\Anil\GitHub\enterprise-sql-platform-lab\datasets\geography\geography_250.csv'
    WITH
    (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0A',
        TABLOCK
    );

    PRINT 'Geography staging load completed.';
END;
GO