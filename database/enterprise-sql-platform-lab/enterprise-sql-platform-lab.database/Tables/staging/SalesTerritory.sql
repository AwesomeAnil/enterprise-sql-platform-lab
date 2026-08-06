CREATE TABLE [staging].[SalesTerritory]
(
    [TerritoryID] INT NOT NULL,
    [TerritoryCode] VARCHAR(20) NOT NULL,
    [TerritoryName] VARCHAR(100) NOT NULL,
    [Region] VARCHAR(50) NOT NULL,
    [Country] VARCHAR(100) NOT NULL,
    [TerritoryManager] VARCHAR(100) NOT NULL,
    [Status] VARCHAR(20) NOT NULL,
    [SourceSystem] VARCHAR(50) NOT NULL,
    [CreatedDate] DATETIME2 NOT NULL,
    [ModifiedDate] DATETIME2 NOT NULL,

    PRIMARY KEY CLUSTERED (TerritoryID)
);
GO