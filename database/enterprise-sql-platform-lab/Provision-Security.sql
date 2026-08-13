PRINT '==============================================';
PRINT 'Enterprise SQL Platform';
PRINT 'Environment Security Provisioning';
PRINT '==============================================';

PRINT 'Applying role memberships...';

ALTER ROLE [role_crm]
ADD MEMBER [CRMLogin];
GO

ALTER ROLE [role_crm]
ADD MEMBER [CRMAMERUser];
GO

ALTER ROLE [role_crm]
ADD MEMBER [CRMAPACUser];
GO

ALTER ROLE [role_crm]
ADD MEMBER [CRMEMEAUser];
GO

ALTER ROLE [role_customersuccess]
ADD MEMBER [CustomerSuccessUser];
GO

ALTER ROLE [role_dataquality]
ADD MEMBER [DataQualityUser];
GO

ALTER ROLE [role_developer]
ADD MEMBER [DeveloperUser];
GO

ALTER ROLE [role_etl]
ADD MEMBER [ETLUser];
GO

ALTER ROLE [role_finance]
ADD MEMBER [FinanceUser];
GO

ALTER ROLE [role_reporting]
ADD MEMBER [ReportingUser];
GO

ALTER ROLE [role_sales]
ADD MEMBER [SalesAMERUser];
GO

ALTER ROLE [role_sales]
ADD MEMBER [SalesAPACUser];
GO

ALTER ROLE [role_sales]
ADD MEMBER [SalesEMEAUser];
GO

PRINT 'Environment Security Provisioning Complete.';
GO