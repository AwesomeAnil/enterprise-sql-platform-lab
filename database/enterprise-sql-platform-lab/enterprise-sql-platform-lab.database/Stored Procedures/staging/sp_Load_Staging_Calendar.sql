CREATE PROCEDURE [staging].[sp_Load_Staging_Calendar]
AS
BEGIN
    SET NOCOUNT ON;

    PRINT 'Loading staging.Calendar...';

    TRUNCATE TABLE staging.Calendar;

    BULK INSERT staging.Calendar
    FROM 'C:\D Drive\Anil\GitHub\enterprise-sql-platform-lab\datasets\calendar\calendar_3653.csv'
    WITH
    (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0A',
        TABLOCK
    );

    PRINT 'Calendar staging load completed.';
END;
GO