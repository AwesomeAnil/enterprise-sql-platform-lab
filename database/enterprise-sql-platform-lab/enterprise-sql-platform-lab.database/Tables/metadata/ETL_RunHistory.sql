CREATE TABLE [metadata].[ETL_RunHistory]
(
    [RunID] INT IDENTITY(1,1) NOT NULL,

    [PipelineName] VARCHAR(100) NOT NULL,

    [SourceSystem] VARCHAR(50) NOT NULL,

    [LoadType] VARCHAR(20) NOT NULL,

    [StartTime] DATETIME2 NOT NULL,

    [EndTime] DATETIME2 NULL,

    [RowsExtracted] INT NULL,

    [RowsInserted] INT NULL,

    [RowsUpdated] INT NULL,

    [RowsRejected] INT NULL,

    [Status] VARCHAR(20) NOT NULL,

    [ErrorMessage] VARCHAR(2000) NULL,

    [CreatedDate] DATETIME2 NOT NULL
        CONSTRAINT DF_ETLRunHistory_CreatedDate
        DEFAULT (SYSUTCDATETIME()),

    CONSTRAINT PK_ETL_RunHistory
        PRIMARY KEY CLUSTERED (RunID)
);
GO