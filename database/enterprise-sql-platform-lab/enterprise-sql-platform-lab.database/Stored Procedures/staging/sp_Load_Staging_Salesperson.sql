CREATE PROCEDURE [staging].[sp_Load_Staging_Salesperson]
AS
BEGIN
    SET NOCOUNT ON;

    PRINT 'Loading staging.Salesperson...';

    TRUNCATE TABLE staging.Salesperson;

    BULK INSERT staging.Salesperson
    FROM 'C:\D Drive\Anil\GitHub\enterprise-sql-platform-lab\datasets\salesperson\salesperson_500.csv'
    WITH
    (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0A',
        TABLOCK
    );

    PRINT 'Salesperson staging load completed.';
END;
GO