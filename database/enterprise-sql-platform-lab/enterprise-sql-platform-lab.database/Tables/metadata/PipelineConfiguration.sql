CREATE TABLE [metadata].[PipelineConfiguration]
(
    [PipelineID]           INT IDENTITY(1,1) NOT NULL,
    [PipelineName]         VARCHAR(100) NOT NULL,
    [SourceSystem]         VARCHAR(50) NOT NULL,
    [SourceObject]         VARCHAR(200) NOT NULL,
    [TargetSchema]         VARCHAR(50) NOT NULL,
    [TargetTable]          VARCHAR(100) NOT NULL,
    [LoadType]             VARCHAR(20) NOT NULL,
    [IsActive]             BIT NOT NULL
        CONSTRAINT DF_PipelineConfiguration_IsActive
        DEFAULT (1),

    [ExecutionOrder]       INT NOT NULL,
    [CreatedDate]          DATETIME2 NOT NULL
        CONSTRAINT DF_PipelineConfiguration_CreatedDate
        DEFAULT (SYSUTCDATETIME()),

    CONSTRAINT PK_PipelineConfiguration
        PRIMARY KEY CLUSTERED (PipelineID)
);
GO