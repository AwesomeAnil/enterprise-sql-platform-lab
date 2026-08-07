CREATE VIEW [dataquality].[vReferentialIntegrity]
AS

SELECT

'Customer'

AS Dimension,

COUNT(*)

AS MissingRows

FROM warehouse.FactSales f

LEFT JOIN warehouse.DimCustomer d

ON f.CustomerID=d.CustomerID

WHERE d.CustomerID IS NULL

UNION ALL

SELECT

'Product',

COUNT(*)

FROM warehouse.FactSales f

LEFT JOIN warehouse.DimProduct d

ON f.ProductID=d.ProductID

WHERE d.ProductID IS NULL

UNION ALL

SELECT

'Geography',

COUNT(*)

FROM warehouse.FactSales f

LEFT JOIN warehouse.DimGeography d

ON f.GeographyID=d.GeographyID

WHERE d.GeographyID IS NULL

UNION ALL

SELECT

'Sales Territory',

COUNT(*)

FROM warehouse.FactSales f

LEFT JOIN warehouse.DimSalesTerritory d

ON f.TerritoryID=d.TerritoryID

WHERE d.TerritoryID IS NULL

UNION ALL

SELECT

'Salesperson',

COUNT(*)

FROM warehouse.FactSales f

LEFT JOIN warehouse.DimSalesperson d

ON f.SalespersonID=d.SalespersonID

WHERE d.SalespersonID IS NULL;
GO