--- RBAC, Security test scripts 

SELECT
    name,
    type_desc,
    authentication_type_desc
FROM sys.database_principals
WHERE type <> 'R'
ORDER BY name;


SELECT
    name
FROM sys.database_principals
WHERE type = 'R'
ORDER BY name;


SELECT
    pr.name AS Principal,
    pe.permission_name,
    pe.state_desc,
    SCHEMA_NAME(pe.major_id) AS SchemaName
FROM sys.database_permissions pe
JOIN sys.database_principals pr
    ON pe.grantee_principal_id = pr.principal_id
WHERE pr.name LIKE 'role_%'
ORDER BY pr.name;



/* Test 1 - Execute as user */ 

EXECUTE AS USER = 'ReportingUser';

SELECT USER_NAME() AS CurrentUser;

REVERT;


/* Test 2 - Reporting schema access */ 

EXECUTE AS USER = 'ReportingUser';
SELECT TOP (10) *
FROM reporting.Customer;

REVERT;

/* Test 3 - Warehouse Access */ 

EXECUTE AS USER = 'ReportingUser';
SELECT TOP (10) *
FROM warehouse.DimCustomer;

REVERT;

/* Phase 3 - Data Quality */ 

EXECUTE AS USER = 'DataQualityUser';
SELECT *
FROM dataquality.vPipelineHealth;

REVERT;

/* Phase 4 - ETL */ 

EXECUTE AS USER = 'ETLUser';
SELECT COUNT(*)
FROM staging.Sales;

/* Phase 5 - developer */ 

EXECUTE AS USER = 'DeveloperUser';
SELECT TOP (5) *
FROM warehouse.FactSales;

REVERT;

/* Additional tests */ 

EXECUTE AS USER = 'ReportingUser';
SELECT TOP (5) *
FROM reporting.Sales;

REVERT;

EXECUTE AS USER = 'ReportingUser';
SELECT TOP (5) *
FROM warehouse.FactSales;

REVERT;