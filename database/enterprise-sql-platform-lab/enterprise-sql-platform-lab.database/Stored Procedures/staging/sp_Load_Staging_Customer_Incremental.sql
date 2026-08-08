CREATE PROCEDURE [staging].[sp_Load_Staging_Customer_Incremental]
    @SourceFilePath VARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @RunID INT;
    DECLARE @StartTime DATETIME2 = SYSUTCDATETIME();
    DECLARE @LastWatermarkValue DATE;
    DECLARE @NewWatermarkValue DATE;

    DECLARE @RowsExtracted INT = 0;
    DECLARE @RowsInserted INT = 0;
    DECLARE @RowsUpdated INT = 0;

    BEGIN TRY

        ------------------------------------------------------------
        -- Start ETL audit record
        ------------------------------------------------------------
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
            'Load_Staging_Customer',
            'CRM',
            'Incremental',
            @StartTime,
            'Running'
        );

        SET @RunID = SCOPE_IDENTITY();

        ------------------------------------------------------------
        -- Read current watermark
        ------------------------------------------------------------
        SELECT
            @LastWatermarkValue = LastWatermarkValue
        FROM metadata.Watermark
        WHERE PipelineName = 'Load_Staging_Customer'
          AND SourceObject = 'Customer';

        ------------------------------------------------------------
        -- Temporary source table
        ------------------------------------------------------------
        CREATE TABLE #CustomerSource
        (
            CustomerID INT NOT NULL,
            CustomerCode VARCHAR(20) NOT NULL,
            CustomerName VARCHAR(200) NOT NULL,
            CustomerType VARCHAR(30) NOT NULL,
            Industry VARCHAR(50) NOT NULL,
            SalesTerritory VARCHAR(20) NOT NULL,
            Country VARCHAR(50) NOT NULL,
            StateProvince VARCHAR(100) NULL,
            City VARCHAR(100) NOT NULL,
            PostalCode VARCHAR(20) NULL,
            EmailAddress VARCHAR(255) NULL,
            PhoneNumber VARCHAR(50) NULL,
            Status VARCHAR(20) NOT NULL,
            CreatedDate DATE NOT NULL,
            ModifiedDate DATE NOT NULL,
            SourceSystem VARCHAR(20) NOT NULL
        );

        ------------------------------------------------------------
        -- Load incremental source file
        ------------------------------------------------------------
        DECLARE @BulkSQL NVARCHAR(MAX);

        SET @BulkSQL = N'
            BULK INSERT #CustomerSource
            FROM ''' + REPLACE(@SourceFilePath, '''', '''''') + N'''
            WITH
            (
                FIRSTROW = 2,
                FIELDTERMINATOR = '','',
                ROWTERMINATOR = ''0x0A'',
                TABLOCK
            );';

        EXEC sys.sp_executesql @BulkSQL;

       ------------------------------------------------------------
        -- Determine rows extracted
        ------------------------------------------------------------
        SELECT @RowsExtracted = COUNT(*)
        FROM #CustomerSource
        WHERE @LastWatermarkValue IS NULL
           OR ModifiedDate > @LastWatermarkValue;

        ------------------------------------------------------------
        -- Process source rows
        ------------------------------------------------------------
        BEGIN TRANSACTION;

        ------------------------------------------------------------
        -- UPDATE existing customers
        ------------------------------------------------------------
        UPDATE T
        SET
            T.CustomerCode    = S.CustomerCode,
            T.CustomerName    = S.CustomerName,
            T.CustomerType    = S.CustomerType,
            T.Industry        = S.Industry,
            T.SalesTerritory  = S.SalesTerritory,
            T.Country         = S.Country,
            T.StateProvince   = S.StateProvince,
            T.City            = S.City,
            T.PostalCode      = S.PostalCode,
            T.EmailAddress    = S.EmailAddress,
            T.PhoneNumber     = S.PhoneNumber,
            T.Status          = S.Status,
            T.CreatedDate     = S.CreatedDate,
            T.ModifiedDate    = S.ModifiedDate,
            T.SourceSystem    = S.SourceSystem
        FROM staging.Customer T
        INNER JOIN #CustomerSource S
            ON T.CustomerID = S.CustomerID
        WHERE @LastWatermarkValue IS NULL
           OR S.ModifiedDate > @LastWatermarkValue;

        SET @RowsUpdated = @@ROWCOUNT;

        ------------------------------------------------------------
        -- INSERT new customers
        ------------------------------------------------------------
        INSERT INTO staging.Customer
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
            PostalCode,
            EmailAddress,
            PhoneNumber,
            Status,
            CreatedDate,
            ModifiedDate,
            SourceSystem
        )
        SELECT
            S.CustomerID,
            S.CustomerCode,
            S.CustomerName,
            S.CustomerType,
            S.Industry,
            S.SalesTerritory,
            S.Country,
            S.StateProvince,
            S.City,
            S.PostalCode,
            S.EmailAddress,
            S.PhoneNumber,
            S.Status,
            S.CreatedDate,
            S.ModifiedDate,
            S.SourceSystem
        FROM #CustomerSource S
        WHERE
            (
                @LastWatermarkValue IS NULL
                OR S.ModifiedDate > @LastWatermarkValue
            )
            AND NOT EXISTS
            (
                SELECT 1
                FROM staging.Customer T
                WHERE T.CustomerID = S.CustomerID
            );

        SET @RowsInserted = @@ROWCOUNT;

        

        ------------------------------------------------------------
        -- Advance watermark only when rows were processed
        ------------------------------------------------------------
        IF @RowsExtracted > 0
        BEGIN
            SELECT @NewWatermarkValue = MAX(ModifiedDate)
            FROM #CustomerSource
            WHERE @LastWatermarkValue IS NULL
               OR ModifiedDate > @LastWatermarkValue;

            UPDATE metadata.Watermark
            SET
                LastWatermarkValue = @NewWatermarkValue,
                LastSuccessfulRun = SYSUTCDATETIME(),
                ModifiedDate = SYSUTCDATETIME()
            WHERE PipelineName = 'Load_Staging_Customer'
              AND SourceObject = 'Customer';
        END;

        COMMIT TRANSACTION;

        ------------------------------------------------------------
        -- Complete ETL audit record
        ------------------------------------------------------------
        UPDATE metadata.ETL_RunHistory
        SET
            EndTime = SYSUTCDATETIME(),
            RowsExtracted = @RowsExtracted,
            RowsInserted = @RowsInserted,
            RowsUpdated = @RowsUpdated,
            RowsRejected = 0,
            Status = 'Success'
        WHERE RunID = @RunID;

        PRINT 'Customer incremental load completed.';
        PRINT 'Rows Extracted : ' + CAST(@RowsExtracted AS VARCHAR(20));
        PRINT 'Rows Updated   : ' + CAST(@RowsUpdated AS VARCHAR(20));
        PRINT 'Rows Inserted  : ' + CAST(@RowsInserted AS VARCHAR(20));
        PRINT 'New Watermark  : ' + CONVERT(VARCHAR(10), @NewWatermarkValue, 120);

    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        UPDATE metadata.ETL_RunHistory
        SET
            EndTime = SYSUTCDATETIME(),
            RowsExtracted = @RowsExtracted,
            RowsInserted = @RowsInserted,
            RowsUpdated = @RowsUpdated,
            RowsRejected = 0,
            Status = 'Failed',
            ErrorMessage = ERROR_MESSAGE()
        WHERE RunID = @RunID;

        THROW;

    END CATCH
END;
GO