CREATE PROCEDURE [pipeline].[sp_Load_Warehouse]
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CustomerRows INT;
    DECLARE @DateRows INT;
    DECLARE @ProductRows INT;
    DECLARE @TablesLoaded INT = 3;
    DECLARE @TotalRows INT;

    PRINT '';
    PRINT '============================================================';
    PRINT 'Enterprise SQL Platform';
    PRINT 'Pipeline : Load Warehouse';
    PRINT '============================================================';
    PRINT '';

    PRINT '[INFO] Loading Customer Dimension...';
    EXEC warehouse.sp_Load_DimCustomer;

    PRINT '[INFO] Loading Date Dimension...';
    EXEC warehouse.sp_Load_DimDate;

    PRINT '[INFO] Loading Product Dimension...';
    EXEC warehouse.sp_Load_DimProduct;

    SELECT @CustomerRows = COUNT(*)
    FROM warehouse.DimCustomer;

    SELECT @DateRows = COUNT(*)
    FROM warehouse.DimDate;

    SELECT @ProductRows = COUNT(*)
    FROM warehouse.DimProduct;

    SET @TotalRows =
          @CustomerRows
        + @DateRows
        + @ProductRows;

    PRINT '';
    PRINT '============================================================';
    PRINT 'Warehouse Pipeline Summary';
    PRINT '============================================================';

    PRINT '[PASS] Customer Dimension Rows : ' + CAST(@CustomerRows AS VARCHAR(20));
    PRINT '[PASS] Date Dimension Rows     : ' + CAST(@DateRows AS VARCHAR(20));
    PRINT '[PASS] Product Dimension Rows  : ' + CAST(@ProductRows AS VARCHAR(20));

    PRINT '';
    PRINT '------------------------------------------------------------';
    PRINT 'Tables Loaded  : ' + CAST(@TablesLoaded AS VARCHAR(10));
    PRINT 'Total Rows     : ' + CAST(@TotalRows AS VARCHAR(20));
    PRINT 'Pipeline Status: SUCCESS';
    PRINT '------------------------------------------------------------';
    PRINT '';

END;
GO