CREATE PROCEDURE [pipeline].[sp_Load_Staging]
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @RunID INT;
    DECLARE @StartTime DATETIME2 = SYSUTCDATETIME();

    DECLARE @CustomerRows INT;
    DECLARE @CalendarRows INT;
    DECLARE @ProductRows INT;
    DECLARE @GeographyRows INT;
    DECLARE @SalesTerritoryRows INT;
    DECLARE @SalespersonRows INT;
    DECLARE @SalesRows INT;

    DECLARE @TablesLoaded INT = 7;
    DECLARE @TotalRows INT;

    /*
    ============================================================
    Create ETL Run History record
    ============================================================
    */

    INSERT INTO metadata.ETL_RunHistory
    (
        PipelineName,
        SourceSystem,
        LoadType,
        StartTime,
        Status
    )
    VALUES
    (
        'Load Staging',
        'CRM',
        'Full',
        @StartTime,
        'Running'
    );

    SET @RunID = SCOPE_IDENTITY();

    BEGIN TRY

        PRINT '';
        PRINT '============================================================';
        PRINT 'Enterprise SQL Platform';
        PRINT 'Pipeline : Load Staging';
        PRINT '============================================================';
        PRINT '';

        PRINT '[INFO] Loading Customer Staging...';
        EXEC staging.sp_Load_Staging_Customer;

        PRINT '[INFO] Loading Calendar Staging...';
        EXEC staging.sp_Load_Staging_Calendar;

        PRINT '[INFO] Loading Product Staging...';
        EXEC staging.sp_Load_Staging_Product;

        PRINT '[INFO] Loading Geography Staging...';
        EXEC staging.sp_Load_Staging_Geography;

        PRINT '[INFO] Loading Sales Territory Staging...';
        EXEC staging.sp_Load_Staging_SalesTerritory;

        PRINT '[INFO] Loading Salesperson Staging...';
        EXEC staging.sp_Load_Staging_Salesperson;

        PRINT '[INFO] Loading Sales Staging...';
        EXEC staging.sp_Load_Staging_Sales;


        /*
        ========================================================
        Capture loaded row counts
        ========================================================
        */

        SELECT @CustomerRows = COUNT(*)
        FROM staging.Customer;

        SELECT @CalendarRows = COUNT(*)
        FROM staging.Calendar;

        SELECT @ProductRows = COUNT(*)
        FROM staging.Product;

        SELECT @GeographyRows = COUNT(*)
        FROM staging.Geography;

        SELECT @SalesTerritoryRows = COUNT(*)
        FROM staging.SalesTerritory;

        SELECT @SalespersonRows = COUNT(*)
        FROM staging.Salesperson;

        SELECT @SalesRows = COUNT(*)
        FROM staging.Sales;


        SET @TotalRows =
              @CustomerRows
            + @CalendarRows
            + @ProductRows
            + @GeographyRows
            + @SalesTerritoryRows
            + @SalespersonRows
            + @SalesRows;


        /*
        ========================================================
        Update successful ETL run
        ========================================================
        */

        UPDATE metadata.ETL_RunHistory
        SET
            EndTime = SYSUTCDATETIME(),
            RowsExtracted = @TotalRows,
            RowsInserted = @TotalRows,
            RowsUpdated = 0,
            RowsRejected = 0,
            Status = 'Success',
            ErrorMessage = NULL
        WHERE RunID = @RunID;


        /*
        ========================================================
        Pipeline Summary
        ========================================================
        */

        PRINT '';
        PRINT '============================================================';
        PRINT 'Staging Pipeline Summary';
        PRINT '============================================================';

        PRINT '[PASS] Customer Rows Loaded : ' + CAST(@CustomerRows AS VARCHAR(20));
        PRINT '[PASS] Calendar Rows Loaded : ' + CAST(@CalendarRows AS VARCHAR(20));
        PRINT '[PASS] Product Rows Loaded  : ' + CAST(@ProductRows AS VARCHAR(20));
        PRINT '[PASS] Geography Rows Loaded : ' + CAST(@GeographyRows AS VARCHAR(20));
        PRINT '[PASS] Sales Territory Rows Loaded : ' + CAST(@SalesTerritoryRows AS VARCHAR(20));
        PRINT '[PASS] Salesperson Rows Loaded : ' + CAST(@SalespersonRows AS VARCHAR(20));
        PRINT '[PASS] Sales Rows Loaded : ' + CAST(@SalesRows AS VARCHAR(20));

        PRINT '';
        PRINT '------------------------------------------------------------';
        PRINT 'Tables Loaded  : ' + CAST(@TablesLoaded AS VARCHAR(10));
        PRINT 'Total Rows     : ' + CAST(@TotalRows AS VARCHAR(20));
        PRINT 'Pipeline Status: SUCCESS';
        PRINT '------------------------------------------------------------';
        PRINT '';

    END TRY

    BEGIN CATCH

        /*
        ========================================================
        Update failed ETL run
        ========================================================
        */

        UPDATE metadata.ETL_RunHistory
        SET
            EndTime = SYSUTCDATETIME(),
            Status = 'Failed',
            ErrorMessage = LEFT(ERROR_MESSAGE(), 2000)
        WHERE RunID = @RunID;

        PRINT '';
        PRINT '============================================================';
        PRINT 'Staging Pipeline FAILED';
        PRINT '============================================================';
        PRINT 'Error: ' + ERROR_MESSAGE();
        PRINT '';

        THROW;

    END CATCH;

END;
GO