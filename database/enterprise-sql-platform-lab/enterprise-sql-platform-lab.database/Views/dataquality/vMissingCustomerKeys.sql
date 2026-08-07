CREATE VIEW [dataquality].[vMissingCustomerKeys]
AS

SELECT
    s.SalesID,
    s.InvoiceNumber,
    s.CustomerID
FROM warehouse.FactSales s
LEFT JOIN warehouse.DimCustomer c
ON s.CustomerID = c.CustomerID
WHERE c.CustomerID IS NULL;
GO