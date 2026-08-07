PRINT '==================================================';
PRINT 'Staging Sales Validation';
PRINT '==================================================';

SELECT
    COUNT(*) AS SalesRows
FROM staging.Sales;

SELECT
    COUNT(DISTINCT SalesID) AS DistinctInvoices,
    COUNT(DISTINCT CustomerID) AS Customers,
    COUNT(DISTINCT ProductID) AS Products,
    COUNT(DISTINCT GeographyID) AS Geographies,
    COUNT(DISTINCT TerritoryID) AS Territories,
    COUNT(DISTINCT SalespersonID) AS Salespersons
FROM staging.Sales;

SELECT
    SUM(GrossSalesAmount) AS GrossSales,
    SUM(NetSalesAmount) AS NetSales,
    SUM(GrossMarginAmount) AS GrossMargin
FROM staging.Sales;