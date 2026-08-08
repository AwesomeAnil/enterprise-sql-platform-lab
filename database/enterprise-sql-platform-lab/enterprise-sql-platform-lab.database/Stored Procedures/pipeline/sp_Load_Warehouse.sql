CREATE PROCEDURE [pipeline].[sp_Load_Warehouse]
AS
BEGIN
    SET NOCOUNT ON;

    ------------------------------------------------------------
    -- Validate warehouse pipeline configuration
    ------------------------------------------------------------
    IF
    (
        SELECT COUNT(*)
        FROM metadata.PipelineConfiguration
        WHERE TargetSchema = 'warehouse'
          AND IsActive = 1
          AND ExecutionOrder BETWEEN 8 AND 14
    ) <> 7
    BEGIN
        THROW 50011,
            'Warehouse pipeline configuration is incomplete or invalid.',
            1;
    END;


    DECLARE @RunID INT;
    DECLARE @StartTime DATETIME2 = SYSUTCDATETIME();

    DECLARE @CustomerRows INT;
    DECLARE @DateRows INT;
    DECLARE @ProductRows INT;
    DECLARE @TablesLoaded INT = 7;
    DECLARE @TotalRows INT;
    DECLARE @GeographyRows INT;
    DECLARE @SalesTerritoryRows INT;
    DECLARE @SalespersonRows INT;
    DECLARE @FactSalesRows INT;

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
        'Load Warehouse',
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
        PRINT 'Pipeline : Load Warehouse';
        PRINT '============================================================';
        PRINT '';

        PRINT '[INFO] Loading Customer Dimension...';
        EXEC warehouse.sp_Load_DimCustomer;

        PRINT '[INFO] Loading Date Dimension...';
        EXEC warehouse.sp_Load_DimDate;

        PRINT '[INFO] Loading Product Dimension...';
        EXEC warehouse.sp_Load_DimProduct;

        PRINT '[INFO] Loading Geography Dimension...';
        EXEC warehouse.sp_Load_DimGeography;

        PRINT '[INFO] Loading Sales Territory Dimension...';
        EXEC warehouse.sp_Load_DimSalesTerritory;

        PRINT '[INFO] Loading Salesperson Dimension...';
        EXEC warehouse.sp_Load_DimSalesperson;

        PRINT '[INFO] Loading FactSales...';
        EXEC warehouse.sp_Load_FactSales;


        /*
        ========================================================
        Capture loaded row counts
        ========================================================
        */

        SELECT @CustomerRows = COUNT(*)
        FROM warehouse.DimCustomer;

        SELECT @DateRows = COUNT(*)
        FROM warehouse.DimDate;

        SELECT @ProductRows = COUNT(*)
        FROM warehouse.DimProduct;

        SELECT @GeographyRows = COUNT(*)
        FROM warehouse.DimGeography;

        SELECT @SalesTerritoryRows = COUNT(*)
        FROM warehouse.DimSalesTerritory;

        SELECT @SalespersonRows = COUNT(*)
        FROM warehouse.DimSalesperson;

        SELECT @FactSalesRows = COUNT(*)
        FROM warehouse.FactSales;


        SET @TotalRows =
              @CustomerRows
            + @DateRows
            + @ProductRows
            + @GeographyRows
            + @SalesTerritoryRows
            + @SalespersonRows
            + @FactSalesRows;


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
        PRINT 'Warehouse Pipeline Summary';
        PRINT '============================================================';

        PRINT '[PASS] Customer Dimension Rows : ' + CAST(@CustomerRows AS VARCHAR(20));
        PRINT '[PASS] Date Dimension Rows     : ' + CAST(@DateRows AS VARCHAR(20));
        PRINT '[PASS] Product Dimension Rows  : ' + CAST(@ProductRows AS VARCHAR(20));
        PRINT '[PASS] Geography Dimension Rows : ' + CAST(@GeographyRows AS VARCHAR(20));
        PRINT '[PASS] Sales Territory Dimension Rows : ' + CAST(@SalesTerritoryRows AS VARCHAR(20));
        PRINT '[PASS] Salesperson Dimension Rows : ' + CAST(@SalespersonRows AS VARCHAR(20));
        PRINT '[PASS] FactSales Rows : ' + CAST(@FactSalesRows AS VARCHAR(20));

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
        PRINT 'Warehouse Pipeline FAILED';
        PRINT '============================================================';
        PRINT 'Error: ' + ERROR_MESSAGE();
        PRINT '';

        THROW;

    END CATCH;

END;
GO