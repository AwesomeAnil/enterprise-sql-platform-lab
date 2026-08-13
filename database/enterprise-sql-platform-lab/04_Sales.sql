/*
==============================================================
Enterprise SQL Platform
Layer 4 Security Test
Sales / Row-Level Security
==============================================================

Execution environment:
    Docker SQL Server

Sales users:
    SalesAMERUser
    SalesAPACUser
    SalesEMEAUser

RLS mapping:
    SalesAMERUser -> AMER
    SalesAPACUser -> APAC
    SalesEMEAUser -> EMEA

Security boundary:
    ALLOW  sales.SalesAccountPlanning
    ALLOW  only the user's assigned territory through RLS
    DENY   direct warehouse access
==============================================================
*/


/*
==============================================================
TEST 1: AMER
Execute this section while connected as SalesAMERUser.
==============================================================
*/

PRINT '==============================================';
PRINT 'TEST 1: Sales AMER';
PRINT '==============================================';

SELECT
    USER_NAME() AS DatabaseUser,
    COUNT(*) AS VisibleRows
FROM [sales].[SalesAccountPlanning];

SELECT DISTINCT
    SalesTerritory
FROM [sales].[SalesAccountPlanning];

PRINT 'Expected: SalesAMERUser sees AMER rows only.';
GO


/*
==============================================================
TEST 2: APAC
Execute this section while connected as SalesAPACUser.
==============================================================
*/

PRINT '==============================================';
PRINT 'TEST 2: Sales APAC';
PRINT '==============================================';

SELECT
    USER_NAME() AS DatabaseUser,
    COUNT(*) AS VisibleRows
FROM [sales].[SalesAccountPlanning];

SELECT DISTINCT
    SalesTerritory
FROM [sales].[SalesAccountPlanning];

PRINT 'Expected: SalesAPACUser sees APAC rows only.';
GO


/*
==============================================================
TEST 3: EMEA
Execute this section while connected as SalesEMEAUser.
==============================================================
*/

PRINT '==============================================';
PRINT 'TEST 3: Sales EMEA';
PRINT '==============================================';

SELECT
    USER_NAME() AS DatabaseUser,
    COUNT(*) AS VisibleRows
FROM [sales].[SalesAccountPlanning];

SELECT DISTINCT
    SalesTerritory
FROM [sales].[SalesAccountPlanning];

PRINT 'Expected: SalesEMEAUser sees EMEA rows only.';
GO


/*
==============================================================
TEST 4: Direct warehouse access
Expected: DENIED

Execute while connected as any Sales user.
==============================================================
*/

PRINT '==============================================';
PRINT 'TEST 4: Direct Warehouse Access';
PRINT '==============================================';

PRINT 'EXPECTED RESULT: SELECT permission denied.';

SELECT TOP (20)
    *
FROM [warehouse].[DimCustomer];

GO


PRINT 'Sales security test complete.';
GO