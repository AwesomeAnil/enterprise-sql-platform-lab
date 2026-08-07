USE SalesDW;
GO

IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name='ReportingLoginUser')
    DROP USER ReportingLoginUser;
GO

IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name='DataQualityLoginUser')
    DROP USER DataQualityLoginUser;
GO

IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name='ETLLoginUser')
    DROP USER ETLLoginUser;
GO

IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name='DeveloperLoginUser')
    DROP USER DeveloperLoginUser;
GO

USE master;
GO

IF EXISTS (SELECT 1 FROM sys.server_principals WHERE name='ReportingLogin')
    DROP LOGIN ReportingLogin;
GO

IF EXISTS (SELECT 1 FROM sys.server_principals WHERE name='DataQualityLogin')
    DROP LOGIN DataQualityLogin;
GO

IF EXISTS (SELECT 1 FROM sys.server_principals WHERE name='ETLLogin')
    DROP LOGIN ETLLogin;
GO

IF EXISTS (SELECT 1 FROM sys.server_principals WHERE name='DeveloperLogin')
    DROP LOGIN DeveloperLogin;
GO

PRINT 'Docker Integration Test Logins Removed Successfully.';
GO