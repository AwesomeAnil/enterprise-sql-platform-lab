CREATE PROCEDURE [warehouse].[sp_Load_FactSales]
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '[INFO] Loading warehouse.FactSales...';

    TRUNCATE TABLE warehouse.FactSales;

    INSERT INTO warehouse.FactSales
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
        ModifiedDate
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
        ModifiedDate
    FROM staging.Sales;

    DECLARE @RowCount INT;

    SELECT @RowCount = COUNT(*)
    FROM warehouse.FactSales;

    PRINT '[PASS] FactSales loaded successfully.';
    PRINT '[PASS] FactSales Rows : '
        + CAST(@RowCount AS VARCHAR(20));

END;
GO