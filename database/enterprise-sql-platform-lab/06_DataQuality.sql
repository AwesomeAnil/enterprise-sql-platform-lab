/*
==============================================================
Enterprise SQL Platform
Layer 4 Security Test
Data Quality
==============================================================

Execution environment:
    Docker SQL Server

Expected identity:
    DataQualityLogin

Security boundary:
    ALLOW  dataquality schema
    DENY   direct warehouse access
==============================================================
*/

PRINT '==============================================';
PRINT 'Data Quality Security Test';
PRINT '==============================================';


/*
--------------------------------------------------------------
TEST 1: Data Quality schema access
Expected: SUCCESS
--------------------------------------------------------------
*/

PRINT 'TEST 1: Data Quality schema access';

SELECT TOP (100)
    *
FROM [dataquality].[vDimensionCoverage];

SELECT TOP (100)
    *
FROM [dataquality].[vDuplicateInvoiceLines];

SELECT TOP (100)
    *
FROM [dataquality].[vETLRunStatus];

SELECT TOP (100)
    *
FROM [dataquality].[vFinancialExceptions];

SELECT TOP (100)
    *
FROM [dataquality].[vMissingCustomerKeys];

SELECT TOP (100)
    *
FROM [dataquality].[vPipelineHealth];

SELECT TOP (100)
    *
FROM [dataquality].[vReferentialIntegrity];

PRINT 'TEST 1: Data Quality schema access completed.';
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


PRINT 'Data Quality security test complete.';
GO