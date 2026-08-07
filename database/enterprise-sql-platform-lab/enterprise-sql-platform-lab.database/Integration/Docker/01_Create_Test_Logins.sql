USE master;
GO

------------------------------------------------------------
-- Create SQL Server Logins
------------------------------------------------------------

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'ReportingLogin')
BEGIN
    CREATE LOGIN ReportingLogin
    WITH PASSWORD = 'Reporting123!';
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'DataQualityLogin')
BEGIN
    CREATE LOGIN DataQualityLogin
    WITH PASSWORD = 'DataQuality123!';
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'ETLLogin')
BEGIN
    CREATE LOGIN ETLLogin
    WITH PASSWORD = 'Santorini123$';
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'DeveloperLogin')
BEGIN
    CREATE LOGIN DeveloperLogin
    WITH PASSWORD = 'Developer123!';
END
GO

USE SalesDW;
GO

------------------------------------------------------------
-- Reporting User
------------------------------------------------------------

IF NOT EXISTS (SELECT 1
               FROM sys.database_principals
               WHERE name='ReportingLoginUser')
BEGIN
    CREATE USER ReportingLoginUser
    FOR LOGIN ReportingLogin;
END
GO

ALTER ROLE role_reporting
ADD MEMBER ReportingLoginUser;
GO

------------------------------------------------------------
-- Data Quality User
------------------------------------------------------------

IF NOT EXISTS (SELECT 1
               FROM sys.database_principals
               WHERE name='DataQualityLoginUser')
BEGIN
    CREATE USER DataQualityLoginUser
    FOR LOGIN DataQualityLogin;
END
GO

ALTER ROLE role_dataquality
ADD MEMBER DataQualityLoginUser;
GO

------------------------------------------------------------
-- ETL User
------------------------------------------------------------

IF NOT EXISTS (SELECT 1
               FROM sys.database_principals
               WHERE name='ETLLoginUser')
BEGIN
    CREATE USER ETLLoginUser
    FOR LOGIN ETLLogin;
END
GO

ALTER ROLE role_etl
ADD MEMBER ETLLoginUser;
GO

------------------------------------------------------------
-- Developer User
------------------------------------------------------------

IF NOT EXISTS (SELECT 1
               FROM sys.database_principals
               WHERE name='DeveloperLoginUser')
BEGIN
    CREATE USER DeveloperLoginUser
    FOR LOGIN DeveloperLogin;
END
GO

ALTER ROLE role_developer
ADD MEMBER DeveloperLoginUser;
GO

PRINT 'Docker Integration Test Logins Created Successfully.';
GO