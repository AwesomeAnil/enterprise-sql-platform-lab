CREATE VIEW [dataquality].[vFinancialExceptions]
AS

SELECT
    SalesID,
    SalesOrderNumber,
    InvoiceNumber,
    CustomerID,
    ProductID,
    Quantity,
    UnitPrice,
    GrossSalesAmount,
    DiscountAmount,
    NetSalesAmount,
    CostAmount,
    GrossMarginAmount,
    GrossMarginPercent
FROM warehouse.FactSales
WHERE
       Quantity <= 0
    OR UnitPrice <= 0
    OR GrossSalesAmount <= 0
    OR NetSalesAmount <= 0
    OR CostAmount < 0
    OR GrossMarginAmount < 0
    OR GrossMarginPercent < 0;
GO