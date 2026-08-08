/*
==============================================================
Sprint 7 - Pipeline Configuration
Warehouse Pipeline Configuration
==============================================================
*/

IF NOT EXISTS
(
    SELECT 1
    FROM metadata.PipelineConfiguration
    WHERE PipelineName = 'Load_Warehouse_DimCustomer'
)
BEGIN
    INSERT INTO metadata.PipelineConfiguration
    (
        PipelineName,
        SourceSystem,
        SourceObject,
        TargetSchema,
        TargetTable,
        LoadType,
        IsActive,
        ExecutionOrder
    )
    VALUES
    ('Load_Warehouse_DimCustomer','CRM','Customer','warehouse','DimCustomer','Full',1,8),
    ('Load_Warehouse_DimCalendar','CRM','Calendar','warehouse','DimCalendar','Full',1,9),
    ('Load_Warehouse_DimProduct','CRM','Product','warehouse','DimProduct','Full',1,10),
    ('Load_Warehouse_DimGeography','CRM','Geography','warehouse','DimGeography','Full',1,11),
    ('Load_Warehouse_DimSalesTerritory','CRM','SalesTerritory','warehouse','DimSalesTerritory','Full',1,12),
    ('Load_Warehouse_DimSalesperson','CRM','Salesperson','warehouse','DimSalesperson','Full',1,13),
    ('Load_Warehouse_FactSales','CRM','Sales','warehouse','FactSales','Full',1,14);
END;
GO