CREATE VIEW [finance].[vw_FinanceLedger]
AS
SELECT
    fs.SalesKey,
    fs.SalesID,
    fs.SalesOrderNumber,
    fs.SalesOrderLineNumber,
    fs.InvoiceNumber,

    fs.DateKey,
    dd.CalendarDate,
    dd.CalendarYear,
    dd.FiscalYear,
    dd.FiscalQuarter,
    dd.FiscalMonth,

    fs.CustomerID,
    dc.CustomerCode,
    dc.CustomerName,
    dc.CustomerType,
    dc.Industry,
    dc.Country AS CustomerCountry,

    fs.ProductID,
    dp.ProductCode,
    dp.ProductName,
    dp.Category,
    dp.SubCategory,
    dp.Brand,

    fs.GeographyID,
    dg.Country AS GeographyCountry,
    dg.StateProvince AS GeographyStateProvince,
    dg.City AS GeographyCity,
    dg.Region AS GeographyRegion,

    fs.TerritoryID,
    dst.TerritoryCode,
    dst.TerritoryName,
    dst.Region AS TerritoryRegion,
    dst.Country AS TerritoryCountry,

    fs.SalespersonID,
    dsp.EmployeeCode,
    dsp.FullName AS SalespersonName,

    fs.Quantity,
    fs.UnitPrice,
    fs.GrossSalesAmount,
    fs.DiscountPercent,
    fs.DiscountAmount,
    fs.NetSalesAmount,
    fs.CostAmount,
    fs.GrossMarginAmount,
    fs.GrossMarginPercent,

    fs.SalesChannel,
    fs.OrderStatus,
    fs.CurrencyCode,
    fs.SourceSystem,
    fs.CreatedDate,
    fs.ModifiedDate,
    fs.LoadDate
FROM [warehouse].[FactSales] AS fs
INNER JOIN [warehouse].[DimCustomer] AS dc
    ON fs.CustomerID = dc.CustomerID
INNER JOIN [warehouse].[DimDate] AS dd
    ON fs.DateKey = dd.DateKey
INNER JOIN [warehouse].[DimProduct] AS dp
    ON fs.ProductID = dp.ProductID
INNER JOIN [warehouse].[DimGeography] AS dg
    ON fs.GeographyID = dg.GeographyID
INNER JOIN [warehouse].[DimSalesTerritory] AS dst
    ON fs.TerritoryID = dst.TerritoryID
INNER JOIN [warehouse].[DimSalesperson] AS dsp
    ON fs.SalespersonID = dsp.SalespersonID;
GO