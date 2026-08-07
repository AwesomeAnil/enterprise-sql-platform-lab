PRINT 'Applying Security Configuration...';

ALTER ROLE [role_reporting]
ADD MEMBER [ReportingUser];
GO

ALTER ROLE [role_dataquality]
ADD MEMBER [DataQualityUser];
GO

ALTER ROLE [role_etl]
ADD MEMBER [ETLUser];
GO

ALTER ROLE [role_developer]
ADD MEMBER [DeveloperUser];
GO

GRANT SELECT
ON SCHEMA::reporting
TO [role_reporting];
GO

GRANT SELECT
ON SCHEMA::dataquality
TO [role_dataquality];
GO

/*==============================================================
  ROLE: role_etl
  Purpose:
      ETL operators responsible for executing the data
      ingestion pipelines.

  Notes:
      - BULK INSERT requires ETLLogin to be a member of the
        server-level bulkadmin role (Integration only).
      - Database permissions below are limited to the minimum
        required for ETL execution.
==============================================================*/

------------------------------------------------------------
-- Staging Schema
------------------------------------------------------------

GRANT SELECT
ON SCHEMA::staging
TO role_etl;
GO

GRANT ALTER
ON SCHEMA::staging
TO role_etl;
GO

GRANT EXECUTE
ON SCHEMA::staging
TO role_etl;
GO

------------------------------------------------------------
-- Warehouse Schema
------------------------------------------------------------

GRANT EXECUTE
ON SCHEMA::warehouse
TO role_etl;
GO

------------------------------------------------------------
-- Pipeline Schema
------------------------------------------------------------

GRANT EXECUTE
ON SCHEMA::pipeline
TO role_etl;
GO


GRANT SELECT, INSERT, UPDATE, DELETE
ON SCHEMA::warehouse
TO [role_developer];
GO

GRANT EXECUTE
ON SCHEMA::pipeline
TO [role_developer];
GO

PRINT 'Security Configuration Complete.';
GO