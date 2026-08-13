CREATE VIEW [sales].[vw_SalesAccountPlanning]
AS
SELECT
    c.CustomerKey,
    c.CustomerID,
    c.CustomerCode,
    c.CustomerName,
    c.CustomerType,
    c.Industry,
    c.Country,
    c.StateProvince,
    c.City,
    c.SalesTerritory,
    c.Status,

    f.SalesKey,
    f.SalesID,
    f.SalesOrderNumber,
    f.SalesOrderLineNumber,
    f.InvoiceNumber,
    f.DateKey,
    f.ProductID,
    f.GeographyID,
    f.TerritoryID,
    f.SalespersonID,
    f.Quantity,
    f.UnitPrice,
    f.GrossSalesAmount,
    f.DiscountPercent,
    f.DiscountAmount,
    f.NetSalesAmount,
    f.CostAmount,
    f.GrossMarginAmount,
    f.GrossMarginPercent,
    f.SalesChannel,
    f.OrderStatus,
    f.CurrencyCode,

    p.ProductName,
    p.Category,

    g.Country AS GeographyCountry,
    g.Region,

    st.TerritoryName,

    sp.FullName

FROM [warehouse].[DimCustomer] AS c
INNER JOIN [warehouse].[FactSales] AS f
    ON c.CustomerID = f.CustomerID
LEFT JOIN [warehouse].[DimProduct] AS p
    ON f.ProductID = p.ProductID
LEFT JOIN [warehouse].[DimGeography] AS g
    ON f.GeographyID = g.GeographyID
LEFT JOIN [warehouse].[DimSalesTerritory] AS st
    ON f.TerritoryID = st.TerritoryID
LEFT JOIN [warehouse].[DimSalesperson] AS sp
    ON f.SalespersonID = sp.SalespersonID;
GO