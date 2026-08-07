CREATE PROCEDURE [pipeline].[sp_Load_Warehouse_Docker]
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '============================================================';
    PRINT 'DOCKER WAREHOUSE PIPELINE';
    PRINT '============================================================';

    ------------------------------------------------------------
    -- Dimensions
    ------------------------------------------------------------

    EXEC warehouse.sp_Load_DimCustomer;
    EXEC warehouse.sp_Load_DimDate;
    EXEC warehouse.sp_Load_DimProduct;
    EXEC warehouse.sp_Load_DimGeography;
    EXEC warehouse.sp_Load_DimSalesTerritory;
    EXEC warehouse.sp_Load_DimSalesperson;
    EXEC warehouse.sp_Load_FactSales;

    ------------------------------------------------------------
    -- Fact
    ------------------------------------------------------------

    EXEC warehouse.sp_Load_FactSales;

    PRINT '';
    PRINT '============================================================';
    PRINT 'DOCKER WAREHOUSE LOAD COMPLETE';
    PRINT '============================================================';

    PRINT '';

    SELECT 'DimCustomer'        AS TableName, COUNT(*) AS RowsLoaded FROM warehouse.DimCustomer
    UNION ALL
    SELECT 'DimCalendar',       COUNT(*) FROM warehouse.DimDate
    UNION ALL
    SELECT 'DimProduct',        COUNT(*) FROM warehouse.DimProduct
    UNION ALL
    SELECT 'DimGeography',      COUNT(*) FROM warehouse.DimGeography
    UNION ALL
    SELECT 'DimSalesTerritory', COUNT(*) FROM warehouse.DimSalesTerritory
    UNION ALL
    SELECT 'DimSalesperson',    COUNT(*) FROM warehouse.DimSalesperson
    UNION ALL
    SELECT 'FactSales',         COUNT(*) FROM warehouse.FactSales;
END;
GO