CREATE PROCEDURE [warehouse].[sp_Load_FactSales]
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '==================================================';
    PRINT 'Loading Warehouse FactSales';
    PRINT '==================================================';

    TRUNCATE TABLE [warehouse].[FactSales];

    INSERT INTO [warehouse].[FactSales]
    (
        SalesID,
        SalesOrderNumber,
        SalesOrderLineNumber,
        InvoiceNumber,
        DateKey,
        CustomerID,
        ProductID,
        GeographyID,
        TerritoryID,
        SalespersonID,
        Quantity,
        UnitPrice,
        GrossSalesAmount,
        DiscountPercent,
        DiscountAmount,
        NetSalesAmount,
        CostAmount,
        GrossMarginAmount,
        GrossMarginPercent,
        SalesChannel,
        OrderStatus,
        CurrencyCode,
        SourceSystem,
        CreatedDate,
        ModifiedDate,
        LoadDate
    )
    SELECT
        SalesID,
        SalesOrderNumber,
        SalesOrderLineNumber,
        InvoiceNumber,
        DateKey,
        CustomerID,
        ProductID,
        GeographyID,
        TerritoryID,
        SalespersonID,
        Quantity,
        UnitPrice,
        GrossSalesAmount,
        DiscountPercent,
        DiscountAmount,
        NetSalesAmount,
        CostAmount,
        GrossMarginAmount,
        GrossMarginPercent,
        SalesChannel,
        OrderStatus,
        CurrencyCode,
        SourceSystem,
        CreatedDate,
        ModifiedDate,
        SYSUTCDATETIME()
    FROM staging.Sales;

    DECLARE @RowsLoaded INT;

    SELECT @RowsLoaded = COUNT(*)
    FROM warehouse.FactSales;

    PRINT '';
    PRINT 'FactSales loaded successfully.';
    PRINT CONCAT('Rows Loaded : ', @RowsLoaded);
    PRINT '';

    SELECT
        RowsLoaded = @RowsLoaded,
        TotalGrossSales = SUM(GrossSalesAmount),
        TotalNetSales = SUM(NetSalesAmount),
        TotalGrossMargin = SUM(GrossMarginAmount)
    FROM warehouse.FactSales;

END;
GO