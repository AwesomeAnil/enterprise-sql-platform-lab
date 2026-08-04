CREATE PROCEDURE [warehouse].[sp_Load_DimProduct]
AS
BEGIN
    SET NOCOUNT ON;

    TRUNCATE TABLE [warehouse].[DimProduct];

    INSERT INTO [warehouse].[DimProduct]
    (
        ProductID,
        ProductCode,
        ProductName,
        Category,
        SubCategory,
        Brand,
        UnitPrice,
        StandardCost,
        Status,
        SourceSystem,
        CreatedDate,
        ModifiedDate
    )
    SELECT
        ProductID,
        ProductCode,
        ProductName,
        Category,
        SubCategory,
        Brand,
        UnitPrice,
        StandardCost,
        Status,
        SourceSystem,
        CreatedDate,
        ModifiedDate
    FROM staging.Product;
END;
GO