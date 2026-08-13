/*
==============================================================
Enterprise SQL Platform
Layer 4 Security Test
Security Baseline
==============================================================

Execution environment:
    Docker SQL Server

Expected execution identity:
    dbo

Purpose:
    Validate that the expected database users, server-login
    mappings, and role memberships exist after provisioning.

This test does NOT create or modify security objects.
==============================================================
*/

PRINT '==============================================';
PRINT 'Security Baseline Test';
PRINT '==============================================';


/*
--------------------------------------------------------------
TEST 1: Expected database users exist
--------------------------------------------------------------
*/

PRINT 'TEST 1: Database users';

SELECT
    dp.name AS DatabaseUser,
    dp.type_desc AS DatabaseUserType,
    sp.name AS ServerLogin,
    sp.type_desc AS ServerLoginType,
    sp.is_disabled
FROM sys.database_principals dp
LEFT JOIN sys.server_principals sp
    ON dp.sid = sp.sid
WHERE dp.name IN
(
    'CRMLogin',
    'CRMAMERUser',
    'CRMAPACUser',
    'CRMEMEAUser',
    'CustomerSuccessUser',
    'DataQualityUser',
    'DeveloperUser',
    'ETLUser',
    'FinanceUser',
    'ReportingUser',
    'SalesAMERUser',
    'SalesAPACUser',
    'SalesEMEAUser'
)
ORDER BY dp.name;
GO


/*
--------------------------------------------------------------
TEST 2: Expected role memberships
--------------------------------------------------------------
*/

PRINT 'TEST 2: Role memberships';

SELECT
    r.name AS RoleName,
    m.name AS MemberName
FROM sys.database_role_members drm
JOIN sys.database_principals r
    ON drm.role_principal_id = r.principal_id
JOIN sys.database_principals m
    ON drm.member_principal_id = m.principal_id
WHERE r.name IN
(
    'role_crm',
    'role_customersuccess',
    'role_dataquality',
    'role_developer',
    'role_etl',
    'role_finance',
    'role_reporting',
    'role_sales'
)
ORDER BY
    r.name,
    m.name;
GO


/*
--------------------------------------------------------------
TEST 3: CRM role membership
Expected:
    CRMLogin
    CRMAMERUser
    CRMAPACUser
    CRMEMEAUser
--------------------------------------------------------------
*/

PRINT 'TEST 3: CRM role membership';

SELECT
    r.name AS RoleName,
    m.name AS MemberName
FROM sys.database_role_members drm
JOIN sys.database_principals r
    ON drm.role_principal_id = r.principal_id
JOIN sys.database_principals m
    ON drm.member_principal_id = m.principal_id
WHERE r.name = 'role_crm';

GO


/*
--------------------------------------------------------------
TEST 4: Sales role membership
Expected:
    SalesAMERUser
    SalesAPACUser
    SalesEMEAUser
--------------------------------------------------------------
*/

PRINT 'TEST 4: Sales role membership';

SELECT
    r.name AS RoleName,
    m.name AS MemberName
FROM sys.database_role_members drm
JOIN sys.database_principals r
    ON drm.role_principal_id = r.principal_id
JOIN sys.database_principals m
    ON drm.member_principal_id = m.principal_id
WHERE r.name = 'role_sales';

GO


/*
--------------------------------------------------------------
TEST 5: Security schemas exist
--------------------------------------------------------------
*/

PRINT 'TEST 5: Security schemas';

SELECT
    name AS SchemaName
FROM sys.schemas
WHERE name IN
(
    'security',
    'crm',
    'customersuccess',
    'finance',
    'sales',
    'reporting',
    'dataquality',
    'staging',
    'warehouse',
    'pipeline'
)
ORDER BY name;

GO


PRINT 'Security baseline test complete.';
GO