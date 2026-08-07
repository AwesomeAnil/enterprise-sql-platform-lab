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

GRANT EXECUTE
ON SCHEMA::pipeline
TO [role_etl];
GO

GRANT SELECT
ON SCHEMA::staging
TO [role_etl];
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