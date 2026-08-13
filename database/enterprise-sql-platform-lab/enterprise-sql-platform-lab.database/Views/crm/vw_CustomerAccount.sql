CREATE VIEW [crm].[vw_CustomerAccount]
AS
WITH OrderMetrics AS
(
    SELECT
        f.CustomerID,
        COUNT(DISTINCT f.SalesOrderNumber) AS TotalOrders,
        COUNT(*) AS TotalOrderLines,
        SUM(f.Quantity) AS TotalQuantity,
        SUM(f.GrossSalesAmount) AS TotalGrossSalesAmount,
        MIN(d.CalendarDate) AS FirstOrderDate,
        MAX(d.CalendarDate) AS LastOrderDate
    FROM [warehouse].[FactSales] AS f
    INNER JOIN [warehouse].[DimDate] AS d
        ON d.DateKey = f.DateKey
    GROUP BY
        f.CustomerID
),
LatestSale AS
(
    SELECT
        f.CustomerID,
        f.SalespersonID,
        f.TerritoryID,
        f.OrderStatus,
        f.SalesChannel,
        ROW_NUMBER() OVER
        (
            PARTITION BY f.CustomerID
            ORDER BY
                d.CalendarDate DESC,
                f.SalesOrderNumber DESC,
                f.SalesOrderLineNumber DESC,
                f.SalesKey DESC
        ) AS rn
    FROM [warehouse].[FactSales] AS f
    INNER JOIN [warehouse].[DimDate] AS d
        ON d.DateKey = f.DateKey
)
SELECT
    -- Customer master: all columns
    c.CustomerKey,
    c.CustomerID,
    c.CustomerCode,
    c.CustomerName,
    c.CustomerType,
    c.Industry,
    c.SalesTerritory,
    c.Country,
    c.StateProvince,
    c.City,
    c.Status,
    c.SourceSystem,
    c.CreatedDate,
    c.ModifiedDate,
    c.LoadDate,

    -- Current/latest sales assignment
    sp.FullName AS SalespersonFullName,
    st.TerritoryName,

    -- Order activity
    om.TotalOrders,
    om.TotalOrderLines,
    om.TotalQuantity,
    om.TotalGrossSalesAmount,
    om.FirstOrderDate,
    om.LastOrderDate,
    ls.OrderStatus AS LastOrderStatus,
    ls.SalesChannel AS LastSalesChannel

FROM [warehouse].[DimCustomer] AS c

LEFT JOIN OrderMetrics AS om
    ON om.CustomerID = c.CustomerID

LEFT JOIN LatestSale AS ls
    ON ls.CustomerID = c.CustomerID
   AND ls.rn = 1

LEFT JOIN [warehouse].[DimSalesperson] AS sp
    ON sp.SalespersonID = ls.SalespersonID

LEFT JOIN [warehouse].[DimSalesTerritory] AS st
    ON st.TerritoryID = ls.TerritoryID;
GO