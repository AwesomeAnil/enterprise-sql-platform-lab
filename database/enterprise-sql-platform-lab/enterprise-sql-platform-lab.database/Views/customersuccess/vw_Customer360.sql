CREATE VIEW [customersuccess].[vw_Customer360]
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
    c.Status,
    c.SalesTerritory,

    g.GeographyID,
    
    s.SalesOrderNumber,
    s.SalesOrderLineNumber,
    s.InvoiceNumber,
    s.DateKey,

    p.ProductID,

    s.Quantity,
    s.GrossSalesAmount,
    s.DiscountAmount,
    s.NetSalesAmount,
    s.CostAmount,
    s.GrossMarginAmount,
    s.GrossMarginPercent,

    s.SalesChannel,
    s.OrderStatus,
    s.CurrencyCode,

    s.CreatedDate AS SalesCreatedDate,
    s.ModifiedDate AS SalesModifiedDate,
    s.LoadDate AS SalesLoadDate

FROM [warehouse].[DimCustomer] AS c
INNER JOIN [warehouse].[FactSales] AS s
    ON c.CustomerID = s.CustomerID
LEFT JOIN [warehouse].[DimProduct] AS p
    ON s.ProductID = p.ProductID
LEFT JOIN [warehouse].[DimGeography] AS g
    ON s.GeographyID = g.GeographyID;
GO