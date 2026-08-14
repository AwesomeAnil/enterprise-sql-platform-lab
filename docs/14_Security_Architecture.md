# 14 --- Security Architecture

## 1. Purpose

This document defines the security architecture of the Enterprise SQL
Platform Lab.

It explains how SQL Server identities, database users, roles,
permissions, schemas, objects and row-level security work together.

It also records the concrete security model implemented and validated in
the project.

The central security chain is:

``` text
SQL Server Login
        |
        | maps to
        v
Database User
        |
        | member of
        v
Database Role
        |
        | receives
        v
Permissions
        |
        v
Schemas / Objects
        |
        v
Runtime Access
```

For row-level security, an additional decision layer is applied:

``` text
User / Role
     |
     v
Security Predicate
     |
     v
Allowed Rows
```

## 2. Security Design Principles

The platform follows these principles:

1.  **Least privilege** --- principals receive only the access required
    for their responsibilities.
2.  **Role-based access control** --- permissions are primarily granted
    to database roles rather than individually to every user.
3.  **Separation of concerns** --- database security and
    server/environment provisioning are distinct responsibilities.
4.  **Explicit validation** --- security configuration is tested rather
    than assumed to be correct.
5.  **Environment independence** --- server logins and
    environment-specific provisioning are not embedded unnecessarily in
    the DACPAC.
6.  **Auditable configuration** --- security definitions and
    provisioning logic are maintained as source-controlled SQL.
7.  **Row-level restriction where required** --- broad object access can
    be further constrained by row-level security.

## 3. Login, User, Role and Permission

### 3.1 SQL Server Login

A login is a server-level principal. It allows SQL Server to
authenticate an identity.

Application logins in this project include:

``` text
CRMLogin
CRMAMERUser
CRMAPACUser
CRMEMEAUser
CustomerSuccessLogin
DataQualityLogin
DeveloperLogin
ETLLogin
FinanceLogin
ReportingLogin
SalesAMERUser
SalesAPACUser
SalesEMEAUser
```

A login does not automatically define what that identity can access
inside a particular database.

### 3.2 Database User

A database user is a database-level principal.

A SQL login can be mapped to a database user:

``` text
Server
  |
  +-- Login: CRMLogin
             |
             v
Database
  |
  +-- User: CRMLogin
```

### 3.3 Database Role

A database role is a collection of database principals.

For example:

``` text
role_crm
 ├── CRMLogin
 ├── CRMAMERUser
 ├── CRMAPACUser
 └── CRMEMEAUser
```

Permissions can be assigned to the role and inherited by its members.

### 3.4 Permission

A permission defines an operation a principal is allowed to perform.

Examples include:

``` text
SELECT
INSERT
UPDATE
DELETE
EXECUTE
ALTER
```

The project primarily uses schema and object permissions.

## 4. Complete Security Chain

``` text
Login
  |
  v
Database User
  |
  v
Role Membership
  |
  v
Role Permissions
  |
  v
Schema / Object
  |
  v
Access Granted or Denied
```

For row-level security:

``` text
Login
  |
  v
Database User
  |
  v
Role / User context
  |
  v
Security Predicate
  |
  v
Permitted Rows
```

> **Permissions determine whether a principal may access an object.
> Row-level security can determine which rows within that object may be
> accessed.**

## 5. Implemented Server Logins

  Login                    Functional Area
  ------------------------ ------------------
  `CRMLogin`               CRM
  `CRMAMERUser`            CRM --- AMER
  `CRMAPACUser`            CRM --- APAC
  `CRMEMEAUser`            CRM --- EMEA
  `CustomerSuccessLogin`   Customer Success
  `DataQualityLogin`       Data Quality
  `DeveloperLogin`         Development
  `ETLLogin`               ETL
  `FinanceLogin`           Finance
  `ReportingLogin`         Reporting
  `SalesAMERUser`          Sales --- AMER
  `SalesAPACUser`          Sales --- APAC
  `SalesEMEAUser`          Sales --- EMEA

Built-in/system principals are not part of the platform's application
security model.

## 6. Implemented Database Users

  Database User           Mapped Login
  ----------------------- ------------------------
  `CRMLogin`              `CRMLogin`
  `CRMAMERUser`           `CRMAMERUser`
  `CRMAPACUser`           `CRMAPACUser`
  `CRMEMEAUser`           `CRMEMEAUser`
  `CustomerSuccessUser`   `CustomerSuccessLogin`
  `DataQualityUser`       `DataQualityLogin`
  `DeveloperUser`         `DeveloperLogin`
  `ETLUser`               `ETLLogin`
  `FinanceUser`           `FinanceLogin`
  `ReportingUser`         `ReportingLogin`
  `SalesAMERUser`         `SalesAMERUser`
  `SalesAPACUser`         `SalesAPACUser`
  `SalesEMEAUser`         `SalesEMEAUser`

## 7. Implemented Database Roles

``` text
role_crm
role_customersuccess
role_dataquality
role_developer
role_etl
role_finance
role_reporting
role_sales
```

These roles represent functional access boundaries.

## 8. Final Role Membership Model

The validated role membership state is:

``` text
role_crm
 ├── CRMAMERUser
 ├── CRMAPACUser
 ├── CRMEMEAUser
 └── CRMLogin

role_customersuccess
 └── CustomerSuccessUser

role_dataquality
 └── DataQualityUser

role_developer
 └── DeveloperUser

role_etl
 └── ETLUser

role_finance
 └── FinanceUser

role_reporting
 └── ReportingUser

role_sales
 ├── SalesAMERUser
 ├── SalesAPACUser
 └── SalesEMEAUser
```

This state was explicitly verified during security reconciliation.

## 9. Functional Permission Model

  -----------------------------------------------------------------------
  Role                                Primary Access
  ----------------------------------- -----------------------------------
  `role_crm`                          `SELECT` on `crm`

  `role_customersuccess`              `SELECT` on `customersuccess`

  `role_dataquality`                  `SELECT` on `dataquality`

  `role_finance`                      `SELECT` on `finance`

  `role_reporting`                    `SELECT` on `reporting`

  `role_sales`                        `SELECT` on `sales`

  `role_etl`                          `SELECT`, `ALTER`, `EXECUTE` on
                                      staging; `EXECUTE` on
                                      warehouse/pipeline

  `role_developer`                    `SELECT`, `INSERT`, `UPDATE`,
                                      `DELETE` on warehouse; `EXECUTE` on
                                      pipeline
  -----------------------------------------------------------------------

## 10. CRM Security

Role:

``` text
role_crm
```

Members:

``` text
CRMLogin
CRMAMERUser
CRMAPACUser
CRMEMEAUser
```

Schema access:

``` sql
GRANT SELECT
ON SCHEMA::crm
TO [role_crm];
```

The `CustomerAccount` object is part of the validated CRM access model.

## 11. Customer Success Security

Role:

``` text
role_customersuccess
```

Member:

``` text
CustomerSuccessUser
```

Schema access:

``` sql
GRANT SELECT
ON SCHEMA::customersuccess
TO [role_customersuccess];
```

The `Customer360` object is part of the validated access model.

## 12. Finance Security

Role:

``` text
role_finance
```

Member:

``` text
FinanceUser
```

Schema access:

``` sql
GRANT SELECT
ON SCHEMA::finance
TO [role_finance];
```

The `FinanceLedger` object is part of the validated access model.

## 13. Sales Security

Role:

``` text
role_sales
```

Members:

``` text
SalesAMERUser
SalesAPACUser
SalesEMEAUser
```

Schema access:

``` sql
GRANT SELECT
ON SCHEMA::sales
TO [role_sales];
```

The `SalesAccountPlanning` object is part of the validated access model.

Sales also implements row-level security.

## 14. Reporting Security

Role:

``` text
role_reporting
```

Member:

``` text
ReportingUser
```

Schema access:

``` sql
GRANT SELECT
ON SCHEMA::reporting
TO [role_reporting];
```

## 15. Data Quality Security

Role:

``` text
role_dataquality
```

Member:

``` text
DataQualityUser
```

Schema access:

``` sql
GRANT SELECT
ON SCHEMA::dataquality
TO [role_dataquality];
```

## 16. ETL Security

Role:

``` text
role_etl
```

Member:

``` text
ETLUser
```

Schema permissions:

``` sql
GRANT SELECT
ON SCHEMA::staging
TO role_etl;

GRANT ALTER
ON SCHEMA::staging
TO role_etl;

GRANT EXECUTE
ON SCHEMA::staging
TO role_etl;

GRANT EXECUTE
ON SCHEMA::warehouse
TO role_etl;

GRANT EXECUTE
ON SCHEMA::pipeline
TO role_etl;
```

The ETL role provides controlled staging operations and execution of the
required warehouse and pipeline routines.

Bulk-ingestion capabilities that require server-level configuration
belong to environment provisioning rather than ordinary database-object
deployment.

## 17. Developer Security

Role:

``` text
role_developer
```

Member:

``` text
DeveloperUser
```

Permissions:

``` sql
GRANT SELECT, INSERT, UPDATE, DELETE
ON SCHEMA::warehouse
TO [role_developer];

GRANT EXECUTE
ON SCHEMA::pipeline
TO [role_developer];
```

This provides controlled development access without making the developer
role equivalent to unrestricted server administration.

## 18. Row-Level Security

Row-level security (RLS) provides a second security boundary beyond
object permissions.

Object-level permission answers:

> May this principal access the table or view?

RLS answers:

> Which rows may this principal access?

The project implements:

``` text
security.fn_SalesTerritoryPredicate
```

The predicate accepts:

``` text
@SalesTerritory
```

and determines whether the current security context may access that
territory.

## 19. Sales Territory Security Model

The validated mapping is:

  Principal         Territory
  ----------------- -----------
  `SalesAMERUser`   `AMER`
  `SalesAPACUser`   `APAC`
  `SalesEMEAUser`   `EMEA`

Conceptually:

``` text
SalesAMERUser
      |
      +--> AMER

SalesAPACUser
      |
      +--> APAC

SalesEMEAUser
      |
      +--> EMEA
```

The predicate also recognizes the privileged functional roles:

``` text
role_developer
role_finance
```

and the `dbo` context.

## 20. Security Predicate Logic

The implemented predicate conceptually evaluates:

``` text
IF user is role_developer
    allow

OR user is role_finance
    allow

OR user is dbo
    allow

OR user has an entry in security.SalesRegionAccess
   matching the requested SalesTerritory
    allow

OTHERWISE
    deny
```

This combines role-based privileged access, database-owner context, and
explicit territory-to-principal mapping.

## 21. Security Schema and Access Mapping

The Sales territory predicate is backed by security data such as:

``` text
security.SalesRegionAccess
```

The validated mapping is:

``` text
PrincipalName      SalesTerritory
-----------------  --------------
SalesAMERUser      AMER
SalesAPACUser      APAC
SalesEMEAUser      EMEA
```

The row-level access model is therefore data-driven.

## 22. Database Security Versus Server Security

### Server/environment security

Examples:

-   SQL Server login
-   server-level role
-   login configuration
-   environment-specific principal provisioning

Primary operational location:

``` text
deployment/Provision-Security.sql
```

### Database security

Examples:

-   database user
-   database role
-   role membership
-   schema permissions
-   object permissions
-   RLS predicates

Primary source:

``` text
database project
```

where the configuration belongs to the database artifact.

## 23. Why Security Provisioning Is Outside DACPAC

The DACPAC should deploy the database without depending on
environment-specific server principals being pre-created.

The project therefore follows:

``` text
Database project
      |
      v
DACPAC
      |
      v
Database roles / permissions / objects
      |
      v
Provision-Security.sql
      |
      v
Logins / users / memberships
      |
      v
Security tests
```

This prevents the type of deployment failures encountered when role
membership statements were embedded directly in `Security.sql`.

It also makes the same database artifact usable across environments with
different security principals.

## 24. Why Security Tests Are Separate

Security tests are evidence, not configuration.

They live under:

``` text
tests/Security/
```

Their purpose is to verify role membership, schema access, object
access, denied access where appropriate, row-level security, ETL
permissions, developer permissions, and broader security-baseline
behaviour.

A test should not silently provision missing users or repair missing
permissions.

``` text
Provision
   |
   v
Test
   |
   v
Evidence
```

## 25. Security Test Coverage

The project has validated the security model through dedicated SQL test
scripts covering:

-   CRM access
-   Customer Success access
-   Finance access
-   Sales access
-   Sales territory row-level security
-   Reporting access
-   Data Quality access
-   ETL execution/access
-   Developer access
-   broader security baseline behaviour

The test scripts and expected results are documented separately in:

``` text
tests/Security/
```

This document defines the architecture; `15_Security_Testing.md` will
document the testing strategy and execution in detail.

## 26. Least-Privilege Model

The implemented design uses functional roles rather than broad
unrestricted permissions.

``` text
CRM
    -> CRM data

Finance
    -> Finance data

Sales
    -> Sales data + territory restriction

Reporting
    -> Reporting data

Data Quality
    -> Data-quality data

ETL
    -> Controlled ingestion/execution capabilities

Developer
    -> Controlled warehouse modification + pipeline execution
```

## 27. Security Boundaries

The platform has several distinct security boundaries:

``` text
1. Authentication
       |
       v
2. Server Login
       |
       v
3. Database User
       |
       v
4. Role Membership
       |
       v
5. Schema/Object Permission
       |
       v
6. Row-Level Security
       |
       v
7. Actual Data Returned
```

## 28. Operational Ownership of Security

  Responsibility                         Primary Location
  -------------------------------------- --------------------------
  Database roles                         Database project
  Database grants                        Database project
  Object permissions                     Database project
  RLS predicate definitions              Database project
  Server logins                          Environment provisioning
  Login/user mappings                    Environment provisioning
  Environment-specific role membership   Environment provisioning
  Security validation                    `tests/Security/`

## 29. Security Architecture in One Diagram

``` text
                         SQL SERVER
                             |
                    +--------+--------+
                    |                 |
                  Login          Server Security
                    |
                    v
                 DATABASE
                    |
                    v
             Database User
                    |
                    v
             Database Role
                    |
             +------+------+
             |             |
        Permissions       RLS
             |             |
             v             v
       Schema / Object   Predicate
             |             |
             +------+------+
                    |
                    v
                DATA ACCESS
```

Environment provisioning prepares the login/user/role relationships.

The database project defines database security.

The security test suite validates the resulting runtime behaviour.

## 30. Security Architecture Checklist

``` text
[ ] Required server logins exist
[ ] Required database users exist
[ ] Login/user mappings are correct
[ ] Required database roles exist
[ ] Role memberships are correct
[ ] Schema permissions are correct
[ ] Object permissions are correct
[ ] RLS predicates exist where required
[ ] Security mapping data is correct
[ ] Security tests pass
```

## 31. Future Security Extensions

Potential future extensions include:

-   additional row-level security policies
-   more granular object permissions
-   controlled application roles
-   environment-specific security configuration
-   centralized secrets management
-   automated security regression testing
-   pipeline-based provisioning
-   production security auditing
-   security drift detection

Any future extension should preserve the separation between:

``` text
Database security
Environment provisioning
Security testing
```

## 32. Relationship to Other Documentation

``` text
13 Environment Provisioning
        |
        | How security is provisioned
        v
14 Security Architecture
        |
        | What the security model means
        v
15 Security Testing
        |
        | How the model is proven
        v
16 Git Development Workflow
        |
        | How the implementation is versioned
```

`14_Security_Architecture.md` is the conceptual and reference document.

It should answer:

> **Who are the principals, how are they related, what can they access,
> and how is that access constrained?**

## 33. Final Security Model

``` text
LOGIN
  |
  v
DATABASE USER
  |
  v
DATABASE ROLE
  |
  v
PERMISSIONS
  |
  +------> SCHEMA / OBJECT ACCESS
  |
  +------> ROW-LEVEL SECURITY
                  |
                  v
             ALLOWED ROWS
```

Operationally:

``` text
Provision-Security.sql
        |
        v
Environment principals
        |
        v
Database security model
        |
        v
Security tests
        |
        v
Validated access
```

The governing principle is:

> **Authenticate at the server, authorize through database users and
> roles, constrain access through permissions and row-level security,
> provision environment-specific principals outside the DACPAC, and
> prove the resulting behaviour with independent security tests.**
