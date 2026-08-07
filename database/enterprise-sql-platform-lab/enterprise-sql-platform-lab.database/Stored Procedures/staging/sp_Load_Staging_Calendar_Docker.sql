CREATE PROCEDURE [staging].[sp_Load_Staging_Calendar_Docker]
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '[DOCKER] Loading staging.Calendar...';

    TRUNCATE TABLE staging.Calendar;

    BULK INSERT staging.Calendar
    FROM '/var/opt/mssql/import/calendar/calendar_3653.csv'
    WITH
    (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0A',
        TABLOCK
    );

    PRINT '[DOCKER] Calendar staging load completed.';
END;
GO