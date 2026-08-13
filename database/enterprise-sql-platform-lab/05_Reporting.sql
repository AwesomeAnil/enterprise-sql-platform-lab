/*
==============================================================
Enterprise SQL Platform
Layer 4 Security Test
Reporting
==============================================================

Execution environment:
    Docker SQL Server

Expected identity:
    ReportingLogin

Security boundary:
    ALLOW  reporting schema
    DENY   direct warehouse access
==============================================================
*/

PRINT '==============================================';
PRINT 'Reporting Security Test';
PRINT '==============================================';


/*
--------------------------------------------------------------
TEST 1: Reporting layer access
Expected: SUCCESS
--------------------------------------------------------------
*/

PRINT 'TEST 1: Reporting schema access';

SELECT TOP (100)
    *
FROM [reporting].[Sales];

SELECT TOP (100)
    *
FROM [reporting].[Customer];

PRINT 'TEST 1: Reporting schema access completed.';
GO


/*
--------------------------------------------------------------
TEST 2: Direct warehouse access
Expected: DENIED
--------------------------------------------------------------
*/

PRINT 'TEST 2: Direct warehouse access';
PRINT 'EXPECTED RESULT: SELECT permission denied.';

SELECT TOP (20)
    *
FROM [warehouse].[DimCustomer];

GO


PRINT 'Reporting security test complete.';
GO