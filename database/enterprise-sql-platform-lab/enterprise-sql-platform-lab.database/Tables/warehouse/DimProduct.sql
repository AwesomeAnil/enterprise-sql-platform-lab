CREATE TABLE [warehouse].[DimProduct]
(
    ProductKey      INT IDENTITY(1,1) NOT NULL,
    ProductID       INT               NOT NULL,
    ProductCode     VARCHAR(20)       NOT NULL,
    ProductName     VARCHAR(200)      NOT NULL,
    Category        VARCHAR(50)       NOT NULL,
    SubCategory     VARCHAR(50)       NOT NULL,
    Brand           VARCHAR(50)       NOT NULL,
    UnitPrice       DECIMAL(18,2)     NOT NULL,
    StandardCost    DECIMAL(18,2)     NOT NULL,
    Status          VARCHAR(20)       NOT NULL,
    SourceSystem    VARCHAR(20)       NOT NULL,
    CreatedDate     DATE              NOT NULL,
    ModifiedDate    DATE              NOT NULL,
    LoadDate        DATETIME2         NOT NULL
        CONSTRAINT DF_DimProduct_LoadDate
        DEFAULT (SYSUTCDATETIME()),

    CONSTRAINT PK_DimProduct
        PRIMARY KEY CLUSTERED (ProductKey),

    CONSTRAINT UQ_DimProduct_ProductID
        UNIQUE (ProductID)
);
GO