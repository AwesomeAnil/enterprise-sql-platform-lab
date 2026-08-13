CREATE TABLE [security].[SalesRegionAccess]
(
    [PrincipalName] NVARCHAR(128) NOT NULL,
    [SalesTerritory] NVARCHAR(50) NOT NULL,

    CONSTRAINT [PK_SalesRegionAccess]
        PRIMARY KEY ([PrincipalName], [SalesTerritory])
);
GO