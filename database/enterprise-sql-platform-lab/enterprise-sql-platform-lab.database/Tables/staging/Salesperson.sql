CREATE TABLE [staging].[Salesperson]
(
    [SalespersonID] INT NOT NULL,
    [EmployeeCode] VARCHAR(20) NOT NULL,
    [FirstName] VARCHAR(100) NOT NULL,
    [LastName] VARCHAR(100) NOT NULL,
    [FullName] VARCHAR(200) NOT NULL,
    [Email] VARCHAR(200) NOT NULL,
    [TerritoryID] INT NOT NULL,
    [JobTitle] VARCHAR(100) NOT NULL,
    [HireDate] DATE NOT NULL,
    [Status] VARCHAR(20) NOT NULL,
    [SourceSystem] VARCHAR(50) NOT NULL,
    [CreatedDate] DATETIME2 NOT NULL,
    [ModifiedDate] DATETIME2 NOT NULL,

    PRIMARY KEY CLUSTERED (SalespersonID)
);
GO