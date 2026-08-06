CREATE PROCEDURE [warehouse].[sp_Load_DimSalesTerritory]
AS
BEGIN
    SET NOCOUNT ON;

    TRUNCATE TABLE warehouse.DimSalesTerritory;

    INSERT INTO warehouse.DimSalesTerritory
    (
        TerritoryID,
        TerritoryCode,
        TerritoryName,
        Region,
        Country,
        TerritoryManager,
        Status,
        SourceSystem,
        CreatedDate,
        ModifiedDate
    )
    SELECT
        TerritoryID,
        TerritoryCode,
        TerritoryName,
        Region,
        Country,
        TerritoryManager,
        Status,
        SourceSystem,
        CreatedDate,
        ModifiedDate
    FROM staging.SalesTerritory;

END;
GO