CREATE FUNCTION [security].[fn_SalesTerritoryPredicate]
(
    @SalesTerritory NVARCHAR(50)
)
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN
(
    SELECT 1 AS [AccessResult]
    WHERE
        IS_ROLEMEMBER('role_developer') = 1
        OR IS_ROLEMEMBER('role_finance') = 1
        OR IS_ROLEMEMBER('role_reporting') = 1
        OR USER_NAME() = 'dbo'
        OR EXISTS
        (
            SELECT 1
            FROM [security].[SalesRegionAccess] AS A
            WHERE A.[PrincipalName] = USER_NAME()
              AND A.[SalesTerritory] = @SalesTerritory
        )
);
GO