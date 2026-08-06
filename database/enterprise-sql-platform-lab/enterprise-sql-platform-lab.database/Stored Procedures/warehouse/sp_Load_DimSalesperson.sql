CREATE PROCEDURE [warehouse].[sp_Load_DimSalesperson]
AS
BEGIN
    SET NOCOUNT ON;

    TRUNCATE TABLE warehouse.DimSalesperson;

    INSERT INTO warehouse.DimSalesperson
    (
        SalespersonID,
        EmployeeCode,
        FirstName,
        LastName,
        FullName,
        Email,
        TerritoryID,
        JobTitle,
        HireDate,
        Status,
        SourceSystem,
        CreatedDate,
        ModifiedDate
    )
    SELECT
        SalespersonID,
        EmployeeCode,
        FirstName,
        LastName,
        FullName,
        Email,
        TerritoryID,
        JobTitle,
        HireDate,
        Status,
        SourceSystem,
        CreatedDate,
        ModifiedDate
    FROM staging.Salesperson;

END;
GO