/*
==============================================================
Sprint 7 - Pipeline Configuration
Staging Pipeline Configuration
==============================================================
*/

IF NOT EXISTS
(
    SELECT 1
    FROM metadata.PipelineConfiguration
    WHERE PipelineName = 'Load_Staging_Customer'
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
    ('Load_Staging_Customer','CRM','Customer','staging','Customer','Full',1,1),
    ('Load_Staging_Calendar','CRM','Calendar','staging','Calendar','Full',1,2),
    ('Load_Staging_Product','CRM','Product','staging','Product','Full',1,3),
    ('Load_Staging_Geography','CRM','Geography','staging','Geography','Full',1,4),
    ('Load_Staging_SalesTerritory','CRM','SalesTerritory','staging','SalesTerritory','Full',1,5),
    ('Load_Staging_Salesperson','CRM','Salesperson','staging','Salesperson','Full',1,6),
    ('Load_Staging_Sales','CRM','Sales','staging','Sales','Full',1,7);
END;
GO