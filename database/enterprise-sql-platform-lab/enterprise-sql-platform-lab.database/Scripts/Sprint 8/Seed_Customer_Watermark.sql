INSERT INTO metadata.Watermark
(
    PipelineName,
    SourceObject,
    WatermarkColumn,
    LastWatermarkValue,
    LastSuccessfulRun
)
VALUES
(
    'Load_Staging_Customer',
    'Customer',
    'ModifiedDate',
    NULL,
    NULL
);
GO


SELECT *
FROM metadata.Watermark;