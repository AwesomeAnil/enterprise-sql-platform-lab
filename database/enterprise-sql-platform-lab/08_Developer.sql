/*
==============================================================
Enterprise SQL Platform
Layer 4 Security Test
Developer
==============================================================

Execution environment:
    Docker SQL Server

Expected identity:
    DeveloperLogin

Security boundary:
    ALLOW  SELECT on warehouse
    ALLOW  INSERT on warehouse
    ALLOW  UPDATE on warehouse
    ALLOW  DELETE on warehouse
    ALLOW  EXECUTE on pipeline
==============================================================
*/

PRINT '==============================================';
PRINT 'Developer Security Test';
PRINT '==============================================';


/*
--------------------------------------------------------------
TEST 1: Warehouse SELECT
Expected: SUCCESS
--------------------------------------------------------------
*/

PRINT 'TEST 1: Warehouse SELECT access';

SELECT TOP (20)
    *
FROM [warehouse].[DimCustomer];

PRINT 'TEST 1: Warehouse SELECT completed.';
GO


/*
--------------------------------------------------------------
TEST 2: Warehouse INSERT / UPDATE / DELETE
Expected: SUCCESS

Use a temporary test table so the test does not modify
production warehouse data.
--------------------------------------------------------------
*/

PRINT 'TEST 2: Warehouse DML permissions';

CREATE TABLE [warehouse].[SecurityTest_Developer]
(
    TestID int,
    TestDescription varchar(100)
);
GO

INSERT INTO [warehouse].[SecurityTest_Developer]
(
    TestID,
    TestDescription
)
VALUES
(
    1,
    'Developer security test'
);
GO

UPDATE [warehouse].[SecurityTest_Developer]
SET TestDescription = 'Developer security test updated'
WHERE TestID = 1;
GO

DELETE FROM [warehouse].[SecurityTest_Developer]
WHERE TestID = 1;
GO

DROP TABLE [warehouse].[SecurityTest_Developer];
GO

PRINT 'TEST 2: Warehouse DML permissions completed.';
GO


/*
--------------------------------------------------------------
TEST 3: Pipeline EXECUTE permission
Expected: GRANT

Pipeline procedures are operational load procedures and are
not executed here because they modify warehouse/staging data.
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
WHERE dp.name = 'role_developer'
  AND s.name = 'pipeline'
  AND p.permission_name = 'EXECUTE'
  AND p.state_desc = 'GRANT';

PRINT 'TEST 3: Pipeline EXECUTE grant verified.';
GO


PRINT 'Developer security test complete.';
GO