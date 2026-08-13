/*
==============================================================
Enterprise SQL Platform
Database Role Permissions
==============================================================

Purpose:
Defines database-level permissions granted to application
database roles.

This script is executed by Post-Deployment.sql and therefore
forms part of the DACPAC deployment.

IMPORTANT:
User-to-role membership is intentionally NOT managed here.

Role membership is provisioned separately by:
    deployment\Provision-Security.sql

This separation prevents environment-specific identity
provisioning from interfering with DACPAC deployment.
==============================================================
*/

PRINT 'Applying Database Role Permissions...';
GO


/*
==============================================================
Reporting
==============================================================
*/

GRANT SELECT
ON SCHEMA::reporting
TO [role_reporting];
GO


/*
==============================================================
Data Quality
==============================================================
*/

GRANT SELECT
ON SCHEMA::dataquality
TO [role_dataquality];
GO


/*
==============================================================
CRM
==============================================================
*/

GRANT SELECT
ON OBJECT::[crm].[CustomerAccount]
TO [role_crm];
GO


/*
==============================================================
Customer Success
==============================================================
*/

GRANT SELECT
ON OBJECT::[customersuccess].[Customer360]
TO [role_customersuccess];
GO


/*
==============================================================
Finance
==============================================================
*/

GRANT SELECT
ON OBJECT::[finance].[FinanceLedger]
TO [role_finance];
GO


/*
==============================================================
Sales
==============================================================
*/

GRANT SELECT
ON OBJECT::[sales].[SalesAccountPlanning]
TO [role_sales];
GO


/*
==============================================================
ETL
Purpose:
ETL operators responsible for executing data ingestion
pipelines.

Database permissions are limited to the minimum required
for ETL execution.

Server-level permissions such as BULK INSERT / bulkadmin
are intentionally outside this database project.
==============================================================
*/

GRANT SELECT
ON SCHEMA::staging
TO [role_etl];
GO

GRANT ALTER
ON SCHEMA::staging
TO [role_etl];
GO

GRANT EXECUTE
ON SCHEMA::staging
TO [role_etl];
GO

GRANT EXECUTE
ON SCHEMA::warehouse
TO [role_etl];
GO

GRANT EXECUTE
ON SCHEMA::pipeline
TO [role_etl];
GO


/*
==============================================================
Developer
Purpose:
Developers require controlled DML access to the warehouse
and execution rights on pipeline objects.
==============================================================
*/

GRANT SELECT, INSERT, UPDATE, DELETE
ON SCHEMA::warehouse
TO [role_developer];
GO

GRANT EXECUTE
ON SCHEMA::pipeline
TO [role_developer];
GO


PRINT 'Database Role Permissions Complete.';
GO