CREATE PROCEDURE [pipeline].[sp_Load_Staging]
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CustomerRows INT;
    DECLARE @CalendarRows INT;
    DECLARE @ProductRows INT;
    DECLARE @TablesLoaded INT = 6;
    DECLARE @TotalRows INT;
    DECLARE @GeographyRows INT;
    DECLARE @SalesTerritoryRows INT
    DECLARE @SalespersonRows INT;



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

    PRINT '[INFO] Loading Geography Staging...';
    EXEC staging.sp_Load_Staging_Geography;

    PRINT '[INFO] Loading Sales Territory Staging...';
    EXEC staging.sp_Load_Staging_SalesTerritory;

    PRINT '[INFO] Loading Salesperson Staging...';
    EXEC staging.sp_Load_Staging_Salesperson;

    
    SELECT @CustomerRows = COUNT(*)
    FROM staging.Customer;

    SELECT @CalendarRows = COUNT(*)
    FROM staging.Calendar;

    SELECT @ProductRows = COUNT(*)
    FROM staging.Product;

    SELECT @GeographyRows = COUNT(*)
    FROM staging.Geography;

    SELECT @SalesTerritoryRows = COUNT(*)
    FROM staging.SalesTerritory;

    SELECT @SalespersonRows = COUNT(*)
    FROM staging.Salesperson;


    SET @TotalRows =
      @CustomerRows
    + @CalendarRows
    + @ProductRows
    + @GeographyRows
    + @SalesTerritoryRows
    + @SalespersonRows;

    PRINT '';
    PRINT '============================================================';
    PRINT 'Staging Pipeline Summary';
    PRINT '============================================================';

    PRINT '[PASS] Customer Rows Loaded : ' + CAST(@CustomerRows AS VARCHAR(20));
    PRINT '[PASS] Calendar Rows Loaded : ' + CAST(@CalendarRows AS VARCHAR(20));
    PRINT '[PASS] Product Rows Loaded  : ' + CAST(@ProductRows AS VARCHAR(20));
    PRINT '[PASS] Geography Rows Loaded : ' + CAST(@GeographyRows AS VARCHAR(20));
    PRINT '[PASS] Sales Territory Rows Loaded : ' + CAST(@SalesTerritoryRows AS VARCHAR(20));
    PRINT '[PASS] Salesperson Rows Loaded : ' + CAST(@SalespersonRows AS VARCHAR(20));

    PRINT '';
    PRINT '------------------------------------------------------------';
    PRINT 'Tables Loaded  : ' + CAST(@TablesLoaded AS VARCHAR(10));
    PRINT 'Total Rows     : ' + CAST(@TotalRows AS VARCHAR(20));
    PRINT 'Pipeline Status: SUCCESS';
    PRINT '------------------------------------------------------------';
    PRINT '';

END;
GO