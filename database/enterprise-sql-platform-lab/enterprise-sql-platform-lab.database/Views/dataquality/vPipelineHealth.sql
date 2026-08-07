CREATE VIEW [dataquality].[vPipelineHealth]
AS

SELECT

    COUNT(*) AS FactSalesRowCount,

    MIN(LoadDate) AS FirstLoadDate,

    MAX(LoadDate) AS LastLoadDate,

    SUM(NetSalesAmount) AS TotalNetSales,

    SUM(GrossMarginAmount) AS TotalGrossMargin

FROM warehouse.FactSales;
GO