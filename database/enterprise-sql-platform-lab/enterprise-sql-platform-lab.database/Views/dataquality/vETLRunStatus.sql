CREATE VIEW [dataquality].[vETLRunStatus]
AS
WITH LatestRun AS
(
    SELECT
        RunID,
        PipelineName,
        SourceSystem,
        LoadType,
        StartTime,
        EndTime,
        RowsExtracted,
        RowsInserted,
        RowsUpdated,
        RowsRejected,
        Status,
        ErrorMessage,
        ROW_NUMBER() OVER
        (
            PARTITION BY PipelineName
            ORDER BY RunID DESC
        ) AS RowNum
    FROM metadata.ETL_RunHistory
)
SELECT
    RunID,
    PipelineName,
    SourceSystem,
    LoadType,
    StartTime,
    EndTime,

    CASE
        WHEN EndTime IS NOT NULL
        THEN DATEDIFF(SECOND, StartTime, EndTime)
        ELSE NULL
    END AS DurationSeconds,

    RowsExtracted,
    RowsInserted,
    RowsUpdated,
    RowsRejected,
    Status,
    ErrorMessage
FROM LatestRun
WHERE RowNum = 1;
GO