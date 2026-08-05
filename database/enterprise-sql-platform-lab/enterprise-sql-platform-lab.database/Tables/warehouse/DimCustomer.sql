CREATE TABLE [warehouse].[DimCustomer]
(
    [CustomerKey] INT IDENTITY(1,1) NOT NULL,
    [CustomerID] INT NOT NULL,
    [CustomerCode] VARCHAR(50) NOT NULL,
    [CustomerName] VARCHAR(200) NOT NULL,
    [CustomerType] VARCHAR(50) NOT NULL,
    [Industry] VARCHAR(50) NOT NULL,
    [SalesTerritory] VARCHAR(50) NOT NULL,
    [Country] VARCHAR(20) NOT NULL,
    [StateProvince] VARCHAR(100) NULL,
    [City] VARCHAR(100) NOT NULL,
    [Status] VARCHAR(20) NOT NULL,
    [SourceSystem] VARCHAR(20) NOT NULL,

    [CreatedDate] DATETIME2 NOT NULL,
    [ModifiedDate] DATETIME2 NOT NULL,

    [LoadDate] DATETIME2 NOT NULL
        CONSTRAINT [DF_DimCustomer_LoadDate]
        DEFAULT (SYSUTCDATETIME()),

    CONSTRAINT [PK_DimCustomer]
        PRIMARY KEY CLUSTERED ([CustomerKey]),

    CONSTRAINT [UQ_DimCustomer_CustomerID]
        UNIQUE ([CustomerID])
);
GO