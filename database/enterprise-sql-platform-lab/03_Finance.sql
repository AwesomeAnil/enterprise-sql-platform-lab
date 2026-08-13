/*
==============================================================
Enterprise SQL Platform
Layer 4 Security Test
Finance
==============================================================

Execution environment:
    Docker SQL Server

Expected identity:
    FinanceLogin

Security boundary:
    ALLOW  finance.FinanceLedger
    DENY   direct warehouse access
==============================================================
*/

PRINT '==============================================';
PRINT 'Finance Security Test';
PRINT '==============================================';


/*
--------------------------------------------------------------
TEST 1: Finance business-layer access
Expected: SUCCESS
--------------------------------------------------------------
*/

PRINT 'TEST 1: FinanceLedger access';

SELECT TOP (100)
    *
FROM [finance].[FinanceLedger];

PRINT 'TEST 1: FinanceLedger access completed.';
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
FROM [warehouse].[FactSales];

GO


PRINT 'Finance security test complete.';
GO