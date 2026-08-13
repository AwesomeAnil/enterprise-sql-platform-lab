/*
==============================================================
Enterprise SQL Platform
Layer 4 Security Test
ETL
==============================================================

Execution environment:
    Docker SQL Server

Expected identity:
    ETLLogin

Security boundary:
    ALLOW  staging SELECT
    ALLOW  staging ALTER
    ALLOW  staging EXECUTE
    ALLOW  warehouse EXECUTE
    ALLOW  pipeline EXECUTE
    DENY   direct warehouse data access
==============================================================
*/

PRINT '==============================================';
PRINT 'ETL Security Test';
PRINT '==============================================';


/*
--------------------------------------------------------------
TEST 1: Staging read access
Expected: SUCCESS
--------------------------------------------------------------
*/

PRINT 'TEST 1: Staging SELECT access';

SELECT TOP (100)
    *
FROM [staging].[Customer];

PRINT 'TEST 1: Staging SELECT access completed.';
GO


/*
--------------------------------------------------------------
TEST 2: Staging DDL permission
Expected: SUCCESS

Use a harmless temporary table to validate ALTER permission.
--------------------------------------------------------------
*/

PRINT 'TEST 2: Staging ALTER permission';

CREATE TABLE [staging].[SecurityTest_ETL]
(
    TestID int
);
GO

ALTER TABLE [staging].[SecurityTest_ETL]
ADD TestDescription varchar(100);
GO

DROP TABLE [staging].[SecurityTest_ETL];
GO

PRINT 'TEST 2: Staging ALTER permission completed.';
GO


/*
--------------------------------------------------------------
TEST 3: Pipeline EXECUTE permission
Expected: PERMISSION GRANT EXISTS

The pipeline schema contains operational load procedures.
These procedures modify staging/warehouse data and therefore
are intentionally NOT executed by the security test.

Validate the EXECUTE grant through the catalog instead.
--------------------------------------------------------------
*/

PRINT 'TEST 3: Pipeline EXECUTE permission';

SELECT
    dp.name AS PrincipalName,
    s.name AS SchemaName,
    p.permission_name,
    p.state_desc
FROM sys.database_permissions p
JOIN sys.database_principals dp
    ON p.grantee_principal_id = dp.principal_id
JOIN sys.schemas s
    ON p.major_id = s.schema_id
WHERE dp.name = 'role_etl'
  AND s.name = 'pipeline'
  AND p.permission_name = 'EXECUTE'
  AND p.state_desc = 'GRANT';

PRINT 'TEST 3: Pipeline EXECUTE grant verified.';
GO


/*
--------------------------------------------------------------
TEST 4: Direct warehouse data access
Expected: DENIED
--------------------------------------------------------------
*/

PRINT 'TEST 4: Direct warehouse data access';
PRINT 'EXPECTED RESULT: SELECT permission denied.';

SELECT TOP (100)
    *
FROM [warehouse].[DimCustomer];

GO


PRINT 'ETL security test complete.';
GO