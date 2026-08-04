CREATE TABLE [metadata].[Watermark]
(
    [PipelineName]          VARCHAR(100) NOT NULL,
    [SourceObject]          VARCHAR(200) NOT NULL,
    [WatermarkColumn]       VARCHAR(100) NOT NULL,
    [LastWatermarkValue]    DATETIME2 NULL,
    [LastSuccessfulRun]     DATETIME2 NULL,
    [ModifiedDate]          DATETIME2 NOT NULL
        CONSTRAINT DF_Watermark_ModifiedDate
        DEFAULT (SYSUTCDATETIME()),

    CONSTRAINT PK_Watermark
        PRIMARY KEY CLUSTERED
        (
            PipelineName,
            SourceObject
        )
);
GO