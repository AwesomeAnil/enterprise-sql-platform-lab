CREATE VIEW [dataquality].[vDimensionCoverage]
AS

SELECT

'Customer' AS DimensionName,

COUNT(*) AS RecordCount

FROM warehouse.DimCustomer

UNION ALL

SELECT

'Date',

COUNT(*)

FROM warehouse.DimDate

UNION ALL

SELECT

'Product',

COUNT(*)

FROM warehouse.DimProduct

UNION ALL

SELECT

'Geography',

COUNT(*)

FROM warehouse.DimGeography

UNION ALL

SELECT

'Sales Territory',

COUNT(*)

FROM warehouse.DimSalesTerritory

UNION ALL

SELECT

'Salesperson',

COUNT(*)

FROM warehouse.DimSalesperson

UNION ALL

SELECT

'Sales',

COUNT(*)

FROM warehouse.FactSales;
GO