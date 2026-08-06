CREATE TABLE [staging].[Geography]
(
    [GeographyID] INT NOT NULL,
    [GeographyCode] VARCHAR(20) NOT NULL,
    [Country] VARCHAR(100) NOT NULL,
    [StateProvince] VARCHAR(100) NOT NULL,
    [City] VARCHAR(100) NOT NULL,
    [Region] VARCHAR(50) NOT NULL,
    [PostalCode] VARCHAR(20) NOT NULL,
    [Latitude] DECIMAL(9,6) NOT NULL,
    [Longitude] DECIMAL(9,6) NOT NULL,
    [SourceSystem] VARCHAR(50) NOT NULL,
    [CreatedDate] DATETIME2 NOT NULL,
    [ModifiedDate] DATETIME2 NOT NULL,

    PRIMARY KEY CLUSTERED (GeographyID)
);
GO