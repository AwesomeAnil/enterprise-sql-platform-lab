CREATE PROCEDURE [warehouse].[sp_Load_DimCustomer]
AS
BEGIN
    SET NOCOUNT ON;

    TRUNCATE TABLE [warehouse].[DimCustomer];

    INSERT INTO [warehouse].[DimCustomer]
    (
        CustomerID,
        CustomerCode,
        CustomerName,
        CustomerType,
        Industry,
        SalesTerritory,
        Country,
        StateProvince,
        City,
        Status,
        SourceSystem,
        CreatedDate,
        ModifiedDate
    )
    SELECT
        CustomerID,
        CustomerCode,
        CustomerName,
        CustomerType,
        Industry,
        SalesTerritory,
        Country,
        StateProvince,
        City,
        Status,
        SourceSystem,
        CreatedDate,
        ModifiedDate
    FROM staging.Customer;

END;
GO