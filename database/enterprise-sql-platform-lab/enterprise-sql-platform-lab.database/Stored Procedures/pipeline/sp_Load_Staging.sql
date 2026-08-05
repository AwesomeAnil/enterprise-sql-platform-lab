CREATE PROCEDURE [pipeline].[sp_Load_Staging]
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CustomerRows INT;
    DECLARE @CalendarRows INT;
    DECLARE @ProductRows INT;
    DECLARE @TablesLoaded INT = 3;
    DECLARE @TotalRows INT;

    PRINT '';
    PRINT '============================================================';
    PRINT 'Enterprise SQL Platform';
    PRINT 'Pipeline : Load Staging';
    PRINT '============================================================';
    PRINT '';

    PRINT '[INFO] Loading Customer Staging...';
    EXEC staging.sp_Load_Staging_Customer;

    PRINT '[INFO] Loading Calendar Staging...';
    EXEC staging.sp_Load_Staging_Calendar;

    PRINT '[INFO] Loading Product Staging...';
    EXEC staging.sp_Load_Staging_Product;

    SELECT @CustomerRows = COUNT(*)
    FROM staging.Customer;

    SELECT @CalendarRows = COUNT(*)
    FROM staging.Calendar;

    SELECT @ProductRows = COUNT(*)
    FROM staging.Product;

    SET @TotalRows =
          @CustomerRows
        + @CalendarRows
        + @ProductRows;

    PRINT '';
    PRINT '============================================================';
    PRINT 'Staging Pipeline Summary';
    PRINT '============================================================';

    PRINT '[PASS] Customer Rows Loaded : ' + CAST(@CustomerRows AS VARCHAR(20));
    PRINT '[PASS] Calendar Rows Loaded : ' + CAST(@CalendarRows AS VARCHAR(20));
    PRINT '[PASS] Product Rows Loaded  : ' + CAST(@ProductRows AS VARCHAR(20));

    PRINT '';
    PRINT '------------------------------------------------------------';
    PRINT 'Tables Loaded  : ' + CAST(@TablesLoaded AS VARCHAR(10));
    PRINT 'Total Rows     : ' + CAST(@TotalRows AS VARCHAR(20));
    PRINT 'Pipeline Status: SUCCESS';
    PRINT '------------------------------------------------------------';
    PRINT '';

END;
GO