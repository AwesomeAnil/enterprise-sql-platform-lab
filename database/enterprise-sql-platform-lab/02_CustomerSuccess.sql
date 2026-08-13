/*
==============================================================
Enterprise SQL Platform
Layer 4 Security Test
Customer Success
==============================================================

Execution environment:
    Docker SQL Server

Expected identity:
    CustomerSuccessLogin

Security boundary:
    ALLOW  customersuccess.Customer360
    DENY   direct warehouse access
==============================================================
*/

PRINT '==============================================';
PRINT 'Customer Success Security Test';
PRINT '==============================================';


/*
--------------------------------------------------------------
TEST 1: Customer Success business-layer access
Expected: SUCCESS
--------------------------------------------------------------
*/

PRINT 'TEST 1: Customer360 access';

SELECT TOP (100)
    *
FROM [customersuccess].[Customer360];

PRINT 'TEST 1: Customer360 access completed.';
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


PRINT 'Customer Success security test complete.';
GO