CREATE VIEW [dataquality].[vDuplicateInvoiceLines]
AS

SELECT
    SalesID,
    SalesOrderNumber,
    SalesOrderLineNumber,
    InvoiceNumber,
    COUNT(*) AS DuplicateCount
FROM warehouse.FactSales
GROUP BY
    SalesID,
    SalesOrderNumber,
    SalesOrderLineNumber,
    InvoiceNumber
HAVING COUNT(*) > 1;
GO