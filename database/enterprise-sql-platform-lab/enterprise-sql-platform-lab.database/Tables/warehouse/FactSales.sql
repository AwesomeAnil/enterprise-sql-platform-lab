CREATE TABLE [warehouse].[FactSales]
(
    [SalesKey] BIGINT IDENTITY(1,1) NOT NULL,

    [SalesID] BIGINT NOT NULL,
    [SalesOrderNumber] VARCHAR(30) NOT NULL,
    [SalesOrderLineNumber] INT NOT NULL,
    [InvoiceNumber] VARCHAR(30) NOT NULL,

    [DateKey] INT NOT NULL,

    [CustomerID] INT NOT NULL,
    [ProductID] INT NOT NULL,
    [GeographyID] INT NOT NULL,
    [TerritoryID] INT NOT NULL,
    [SalespersonID] INT NOT NULL,

    [Quantity] INT NOT NULL,
    [UnitPrice] DECIMAL(18,2) NOT NULL,

    [GrossSalesAmount] DECIMAL(18,2) NOT NULL,

    [DiscountPercent] DECIMAL(5,2) NOT NULL,
    [DiscountAmount] DECIMAL(18,2) NOT NULL,

    [NetSalesAmount] DECIMAL(18,2) NOT NULL,

    [CostAmount] DECIMAL(18,2) NOT NULL,

    [GrossMarginAmount] DECIMAL(18,2) NOT NULL,
    [GrossMarginPercent] DECIMAL(5,2) NOT NULL,

    [SalesChannel] VARCHAR(30) NOT NULL,
    [OrderStatus] VARCHAR(20) NOT NULL,

    [CurrencyCode] CHAR(3) NOT NULL,

    [SourceSystem] VARCHAR(20) NOT NULL,

    [CreatedDate] DATETIME2 NOT NULL,
    [ModifiedDate] DATETIME2 NOT NULL,

    [LoadDate] DATETIME2 NOT NULL
        CONSTRAINT DF_FactSales_LoadDate
        DEFAULT (SYSUTCDATETIME()),

    CONSTRAINT PK_FactSales
        PRIMARY KEY CLUSTERED (SalesKey)
);
GO