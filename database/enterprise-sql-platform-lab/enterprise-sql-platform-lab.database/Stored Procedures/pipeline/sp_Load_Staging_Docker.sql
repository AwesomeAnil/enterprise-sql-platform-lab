CREATE PROCEDURE [pipeline].[sp_Load_Staging_Docker]
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '============================================================';
    PRINT 'DOCKER STAGING PIPELINE';
    PRINT '============================================================';

    ------------------------------------------------------------
    -- Customer
    ------------------------------------------------------------
    EXEC staging.sp_Load_Staging_Customer_Docker;

    ------------------------------------------------------------
    -- Calendar
    ------------------------------------------------------------
    EXEC staging.sp_Load_Staging_Calendar_Docker;

    ------------------------------------------------------------
    -- Product
    ------------------------------------------------------------
    EXEC staging.sp_Load_Staging_Product_Docker;

    ------------------------------------------------------------
    -- Geography
    ------------------------------------------------------------
    EXEC staging.sp_Load_Staging_Geography_Docker;

    ------------------------------------------------------------
    -- Sales Territory
    ------------------------------------------------------------
    EXEC staging.sp_Load_Staging_SalesTerritory_Docker;

    ------------------------------------------------------------
    -- Salesperson
    ------------------------------------------------------------
    EXEC staging.sp_Load_Staging_Salesperson_Docker;

    ------------------------------------------------------------
    -- Sales
    ------------------------------------------------------------
    EXEC staging.sp_Load_Staging_Sales_Docker;

    PRINT '';
    PRINT '============================================================';
    PRINT 'DOCKER STAGING LOAD COMPLETE';
    PRINT '============================================================';

    PRINT '';

    SELECT
        'Customer' AS TableName,
        COUNT(*) AS RowsLoaded
    FROM staging.Customer

    UNION ALL

    SELECT
        'Calendar',
        COUNT(*)
    FROM staging.Calendar

    UNION ALL

    SELECT
        'Product',
        COUNT(*)
    FROM staging.Product

    UNION ALL

    SELECT
        'Geography',
        COUNT(*)
    FROM staging.Geography

    UNION ALL

    SELECT
        'Sales Territory',
        COUNT(*)
    FROM staging.SalesTerritory

    UNION ALL

    SELECT
        'Salesperson',
        COUNT(*)
    FROM staging.Salesperson

    UNION ALL

    SELECT
        'Sales',
        COUNT(*)
    FROM staging.Sales;
END;
GO