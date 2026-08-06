CREATE PROCEDURE [pipeline].[sp_Load_Warehouse]
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CustomerRows INT;
    DECLARE @DateRows INT;
    DECLARE @ProductRows INT;
    DECLARE @TablesLoaded INT = 7;
    DECLARE @TotalRows INT;
    DECLARE @GeographyRows INT;
    DECLARE @SalesTerritoryRows INT;
    DECLARE @SalespersonRows INT;
    DECLARE @FactSalesRows INT;




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

    PRINT '[INFO] Loading Geography Dimension...';
    EXEC warehouse.sp_Load_DimGeography;

    PRINT '[INFO] Loading Salesperson Dimension...';
    EXEC warehouse.sp_Load_DimSalesperson;

    PRINT '[INFO] Loading FactSales...';
    EXEC warehouse.sp_Load_FactSales;


    SELECT @CustomerRows = COUNT(*)
    FROM warehouse.DimCustomer;

    SELECT @DateRows = COUNT(*)
    FROM warehouse.DimDate;

    SELECT @ProductRows = COUNT(*)
    FROM warehouse.DimProduct;

    SELECT @GeographyRows = COUNT(*)
    FROM warehouse.DimGeography;

    SELECT @SalesTerritoryRows = COUNT(*)
    FROM warehouse.DimSalesTerritory;

    SELECT @SalespersonRows = COUNT(*)
    FROM warehouse.DimSalesperson;

    SELECT @FactSalesRows = COUNT(*)
    FROM warehouse.FactSales;


    SET @TotalRows =
      @CustomerRows
    + @DateRows
    + @ProductRows
    + @GeographyRows
    + @SalesTerritoryRows
    + @SalespersonRows
    + @FactSalesRows;

    PRINT '';
    PRINT '============================================================';
    PRINT 'Warehouse Pipeline Summary';
    PRINT '============================================================';

    PRINT '[PASS] Customer Dimension Rows : ' + CAST(@CustomerRows AS VARCHAR(20));
    PRINT '[PASS] Date Dimension Rows     : ' + CAST(@DateRows AS VARCHAR(20));
    PRINT '[PASS] Product Dimension Rows  : ' + CAST(@ProductRows AS VARCHAR(20));
    PRINT '[PASS] Geography Dimension Rows : ' + CAST(@GeographyRows AS VARCHAR(20));
    PRINT '[PASS] Sales Territory Dimension Rows : ' + CAST(@SalesTerritoryRows AS VARCHAR(20));
    PRINT '[PASS] Salesperson Dimension Rows : ' + CAST(@SalespersonRows AS VARCHAR(20));
    PRINT '[PASS] FactSales Rows : ' + CAST(@FactSalesRows AS VARCHAR(20));

    PRINT '';
    PRINT '------------------------------------------------------------';
    PRINT 'Tables Loaded  : ' + CAST(@TablesLoaded AS VARCHAR(10));
    PRINT 'Total Rows     : ' + CAST(@TotalRows AS VARCHAR(20));
    PRINT 'Pipeline Status: SUCCESS';
    PRINT '------------------------------------------------------------';
    PRINT '';

END;
GO