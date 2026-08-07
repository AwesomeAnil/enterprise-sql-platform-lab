PRINT '==================================================';
PRINT 'Warehouse FactSales Validation';
PRINT '==================================================';

SELECT
    COUNT(*) AS FactSalesRows
FROM warehouse.FactSales;

SELECT
    COUNT(DISTINCT SalesID) AS DistinctInvoices,
    COUNT(DISTINCT CustomerID) AS Customers,
    COUNT(DISTINCT ProductID) AS Products,
    COUNT(DISTINCT GeographyID) AS Geographies,
    COUNT(DISTINCT TerritoryID) AS Territories,
    COUNT(DISTINCT SalespersonID) AS Salespersons
FROM warehouse.FactSales;

SELECT
    SUM(GrossSalesAmount) AS GrossSales,
    SUM(NetSalesAmount) AS NetSales,
    SUM(GrossMarginAmount) AS GrossMargin
FROM warehouse.FactSales;

SELECT
    COUNT(*) AS NegativeMarginRows
FROM warehouse.FactSales
WHERE GrossMarginAmount < 0;

SELECT
    COUNT(*) AS NullCustomerRows
FROM warehouse.FactSales
WHERE CustomerID IS NULL;