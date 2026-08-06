CREATE PROCEDURE [warehouse].[sp_Load_DimGeography]
AS
BEGIN
    SET NOCOUNT ON;

    TRUNCATE TABLE warehouse.DimGeography;

    INSERT INTO warehouse.DimGeography
    (
        GeographyID,
        GeographyCode,
        Country,
        StateProvince,
        City,
        Region,
        PostalCode,
        Latitude,
        Longitude,
        SourceSystem,
        CreatedDate,
        ModifiedDate
    )
    SELECT
        GeographyID,
        GeographyCode,
        Country,
        StateProvince,
        City,
        Region,
        PostalCode,
        Latitude,
        Longitude,
        SourceSystem,
        CreatedDate,
        ModifiedDate
    FROM staging.Geography;

END;
GO