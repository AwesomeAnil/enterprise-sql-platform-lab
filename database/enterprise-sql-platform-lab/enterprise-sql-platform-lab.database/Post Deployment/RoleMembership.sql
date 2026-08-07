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