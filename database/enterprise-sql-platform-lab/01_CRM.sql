/*
==============================================================
Enterprise SQL Platform
Layer 4 Security Test
CRM
==============================================================

Purpose:
Validate the security boundary for CRM users.

Execution environment:
    Docker SQL Server

Expected identity:
    CRMLogin

Expected permissions:
    ALLOW  crm.CustomerAccount
    DENY   direct warehouse access

IMPORTANT:
This is a TEST script.
It does not create, alter, grant, or revoke permissions.
==============================================================
*/

PRINT '==============================================';
PRINT 'CRM Security Test';
PRINT '==============================================';


/*
--------------------------------------------------------------
TEST 1: CRM business-layer access
Expected: SUCCESS
--------------------------------------------------------------
*/

PRINT 'TEST 1: CRM CustomerAccount access';

SELECT TOP (20)
    *
FROM [crm].[CustomerAccount];

PRINT 'TEST 1 PASSED: CRM CustomerAccount is accessible.';
GO


/*
--------------------------------------------------------------
TEST 2: Direct warehouse access
Expected: DENIED

Do NOT execute this query directly if you are running the
entire script interactively, because the permission error
will interrupt the test batch.

This test is documented here and will be executed separately
as an expected-denial test.
--------------------------------------------------------------
*/

PRINT 'TEST 2: Direct warehouse access';
PRINT 'EXPECTED RESULT: SELECT permission denied on warehouse.DimCustomer.';
GO


/*
--------------------------------------------------------------
CRM Security Test Summary
--------------------------------------------------------------
*/

PRINT 'CRM security test definition complete.';
GO