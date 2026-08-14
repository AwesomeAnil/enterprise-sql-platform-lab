# 10 --- Architecture Overview

## 1\. Purpose

This document defines the implemented and planned architecture of the
Enterprise SQL Platform Lab.

It establishes clear boundaries between database development, database
deployment, environment provisioning, security validation, source
control, and environment promotion.

**Architecture status:** LocalDB and Docker SQL Server
development/integration architecture is implemented. DEV → TEST → PROD
is the target managed deployment architecture and is documented as such
where automation has not yet been implemented.

## 2\. Architectural Principles

### Database objects are deployed as a database artifact

The database project is the source of truth for database objects that
belong inside the DACPAC deployment boundary, including schemas, tables,
views, stored procedures, functions, database roles, and appropriate
database-level permissions.

### Environment provisioning is separate from database deployment

Environment-specific configuration is not embedded in DACPAC deployment.

The principal provisioning script is:

`deployment/Provision-Security.sql`

It is executed against the target environment after the database has
been deployed and is responsible for environment-dependent security
provisioning such as server logins, database user mappings, and role
memberships.

### Provisioning and testing are separate

`Provision-Security.sql` provisions the environment.

`tests/Security/\*.sql` validates the environment.

The security tests do not create or repair security configuration.

### One provisioning model, multiple environments

The project does not maintain separate LocalDB, Docker, DEV, TEST, or
PROD copies of the security provisioning script. The same provisioning
model is applied to the appropriate target environment.

## 3\. High-Level Architecture

``` text
                         SOURCE CONTROL
                              Git
                               |
                               v
                    +---------------------+
                    | Database Project    |
                    | database/           |
                    +----------+----------+
                               |
                         Build / DACPAC
                               |
                               v
                    +---------------------+
                    | Database Artifact   |
                    |      DACPAC         |
                    +----------+----------+
                               |
                  +------------+------------+
                  |                         |
                  v                         v
             LocalDB                  Docker SQL Server
          Development               Integration / Security
             Validation                  Validation
                  |                         |
                  |                         v
                  |                 Provision-Security.sql
                  |                         |
                  |                         v
                  |                 Security Test Suite
                  |                         |
                  +------------+------------+
                               |
                         Validated Artifact
                               |
                               v
                            DEV
                               |
                           Promotion
                               v
                             TEST
                               |
                       Approval / Promote
                               v
                             PROD
```

LocalDB and Docker SQL Server are engineering environments. DEV, TEST,
and PROD are the target managed deployment environments.

## 4\. Repository Architecture

``` text
enterprise-sql-platform-lab/
|
+-- database/
|   +-- enterprise-sql-platform-lab/
|
+-- datasets/
|   +-- calendar/
|   +-- customer/
|   +-- geography/
|   +-- product/
|   +-- sales/
|   |   +-- sample/
|   +-- salesperson/
|   +-- territory/
|
+-- deployment/
|   +-- Provision-Security.sql
|
+-- tests/
|   +-- Security/
|       +-- 01\_CRM.sql
|       +-- 02\_CustomerSuccess.sql
|       +-- 03\_Finance.sql
|       +-- 04\_Sales.sql
|       +-- 05\_Reporting.sql
|       +-- 06\_DataQuality.sql
|       +-- 07\_ETL.sql
|       +-- 08\_Developer.sql
|       +-- 09\_SecurityBaseline.sql
|
+-- docs/
|   +-- 00\_Project\_Vision.md
|   +-- 01\_Architecture.md
|   +-- 02\_Engineering\_Methodology.md
|   +-- 03\_Platform\_Foundation.md
|   +-- 04\_Platform\_Operations.md
|   +-- 05\_Metadata\_Capability.md
|   +-- 06\_Data\_Ingestion\_Capability.md
|   +-- 07\_Data\_Storage\_Capability.md
|   +-- 08\_Business\_Consumption.md
|   +-- 09\_Platform\_Governance.md
|   +-- 10\_Architecture\_Overview.md
|   +-- 11\_Database\_Development\_Workflow.md
|   +-- 12\_Database\_Deployment.md
|   +-- 13\_Environment\_Provisioning.md
|   +-- 14\_Security\_Architecture.md
|   +-- 15\_Security\_Testing.md
|   +-- 16\_Git\_Development\_Workflow.md
|
+-- google-colab/
+-- .gitignore
+-- LICENSE
+-- README.md
```

The repository boundaries are:

Area            Responsibility

\---

`database/`     Database objects and DACPAC source
`datasets/`     Controlled development/sample data
`deployment/`   Environment provisioning
`tests/`        Runtime validation
`docs/`         Platform and engineering documentation
`README.md`     Repository entry point

## 5\. Database Project Boundary

The database project owns database-native objects that can be reliably
represented and promoted as a database artifact.

The normal lifecycle is:

``` text
Edit database object
        |
        v
Build database project
        |
        v
Generate DACPAC
        |
        v
Publish database
        |
        v
Validate
```

Environment-specific operational provisioning must not be added to the
database project simply because it is written in T-SQL.

The governing question is whether the logic belongs to the database
artifact or configures the environment in which the artifact runs.

## 6\. LocalDB Architecture

LocalDB is the developer-oriented database environment.

It is used for:

* database object development
* schema validation
* stored procedure development
* DACPAC build validation
* database publishing
* validating database roles and database-level permissions supported
by the environment

LocalDB is not treated as a complete simulation of every server-level
security capability available in full SQL Server.

Therefore:

``` text
LocalDB = database development + DACPAC validation
```

It is not a substitute for full SQL Server security integration testing.

## 7\. Docker SQL Server Architecture

Docker SQL Server provides a reproducible local SQL Server environment
beyond the limitations of LocalDB.

It is used for:

* publishing the database artifact
* environment provisioning
* server login creation
* database user mapping
* role membership validation
* security integration testing
* runtime security validation

The local engineering flow is:

``` text
LocalDB
   |
   v
Build / Publish validation
   |
   v
Docker SQL Server
   |
   v
Provision-Security.sql
   |
   v
Security tests
```

## 8\. Environment Provisioning Boundary

The deployment directory contains scripts that configure the target
environment after database deployment.

The primary security provisioning script is:

`deployment/Provision-Security.sql`

It is deliberately outside the database project and outside the DACPAC
deployment boundary.

``` text
DATABASE DEPLOYMENT
        |
        v
      DACPAC
        |
        v
   Database exists
        |
        v
ENVIRONMENT PROVISIONING
        |
        v
Provision-Security.sql
```

This separation prevents server-level login and role-membership
operations from destabilizing DACPAC deployment.

## 9\. Security Architecture Boundary

Security is implemented across several layers:

``` text
SQL Server Login
       |
       v
Database User
       |
       v
Database Role
       |
       v
Schema / Object Permissions
       |
       v
Row-Level Security / Predicate
       |
       v
Runtime Access
```

The model distinguishes server principals, database principals, role
membership, database permissions, row-level security, and runtime
authorization behaviour.

The security model is not complete merely because the objects exist. It
must be provisioned and tested.

Detailed security architecture is documented in
`14\_Security\_Architecture.md`.

## 10\. Security Testing Boundary

Security tests live outside the database project:

`tests/Security/`

They validate the deployed and provisioned environment.

They answer questions such as:

* Can the intended principal access the intended schema?
* Can the principal access the intended object?
* Is unauthorized access denied?
* Does row-level security restrict the correct territory?
* Does ETL have the required permissions?
* Does a developer have the intended permissions?
* Are role memberships correct?
* Does the security baseline remain intact?

The lifecycle is:

``` text
Build
  |
  v
Deploy
  |
  v
Provision
  |
  v
Test
```

not a combined deployment/provisioning/testing operation.

## 11\. DEV, TEST and PROD Deployment Model

The target managed lifecycle is:

``` text
                  Git
                   |
                   v
              Build Artifact
                   |
                   v
                  DEV
                   |
               Validation
                   |
                   v
                  TEST
                   |
                Approval
                   |
                   v
                  PROD
```

The database artifact should be promoted rather than independently
rebuilt from different source states for each environment.

### DEV

DEV is the first managed deployment environment.

### TEST

TEST receives the promoted artifact for formal integration and
acceptance validation. Environment provisioning and security validation
are performed against TEST.

### PROD

PROD is the final managed deployment target. It does not require a
separate database implementation.

``` text
Approved artifact
       |
       v
PROD deployment
       |
       v
PROD provisioning
       |
       v
Production validation
```

The eventual pipeline may reduce production deployment to an approval
and deployment action, but the production environment remains an
explicit architectural boundary.

## 12\. Promotion Versus Provisioning

Promotion and provisioning are different operations.

**Promotion** moves the approved database artifact:



``` text
DEV -> TEST -> PROD
```

**Provisioning** prepares the target environment:

``` text
Environment
    |
    v
Provision security
    |
    v
Configure environment
    |
    v
Run validation
```

Production being a click-and-deploy target does not eliminate
provisioning. It means the deployment process should eventually automate
those provisioning steps.

## 13\. What Does Not Belong in the DACPAC

Where they are environment/server-specific, the following remain outside
DACPAC deployment:

* server login creation
* server-level role membership
* environment-specific credentials
* environment-specific connection configuration
* operational provisioning
* deployment-time security setup dependent on the target SQL Server
instance

## 14\. What Does Belong in the DACPAC

The database project remains responsible for database-native objects and
configuration that form part of the database artifact, including:

* schemas
* tables
* views
* stored procedures
* functions
* database roles
* appropriate database-level grants
* security predicates and row-level security objects

The distinction is therefore not simply security versus non-security.
Some security belongs in the database artifact; other security belongs
in environment provisioning.

## 15\. Architecture Decision Summary

\---

Decision                              Status

\---

Database objects are managed through  Implemented
the database project

DACPAC is the database deployment     Implemented
artifact

LocalDB is used for developer         Implemented
database validation

Docker SQL Server is used for local   Implemented
integration/security validation

Environment security provisioning is  Implemented
outside DACPAC

`deployment/Provision-Security.sql`   Implemented
is the provisioning mechanism

Security tests are outside DACPAC     Implemented

`tests/Security/\*.sql` validates      Implemented
runtime security

Separate LocalDB/Docker security      Implemented
scripts are not maintained

DEV -> TEST -> PROD is the managed  Target architecture
promotion model

Production receives a promoted        Target architecture
database artifact

CI/CD automation of promotion and     Future implementation
provisioning
---

## 16\. Non-Negotiable Architectural Boundaries

### Boundary 1 --- Database versus environment

Do not place environment provisioning into the database project merely
because the provisioning logic is written in T-SQL.

### Boundary 2 --- Provisioning versus testing

Do not use security tests to create or repair security configuration.

### Boundary 3 --- Local development versus managed environments

Do not treat LocalDB or Docker SQL Server as replacements for DEV, TEST,
or PROD.

### Boundary 4 --- Artifact versus environment

Promote the database artifact. Configure the environment independently.

### Boundary 5 --- One security provisioning model

Do not create environment-specific copies of `Provision-Security.sql`
unless a genuine architectural requirement emerges.

### Boundary 6 --- Documentation versus implementation status

Documentation must distinguish what is implemented from what is planned.
Future DEV → TEST → PROD automation must not be represented as an
existing capability until it is actually implemented.

## 17\. Relationship to Remaining Engineering Documentation

This document establishes the architectural baseline.

The remaining engineering documents provide operational detail:

``` text
10 Architecture Overview
        |
        +-- 11 Database Development Workflow
        |
        +-- 12 Database Deployment
        |
        +-- 13 Environment Provisioning
        |
        +-- 14 Security Architecture
        |
        +-- 15 Security Testing
        |
        +-- 16 Git Development Workflow
```

Each document should explain one responsibility without duplicating the
entire platform architecture.

## 18\. Final Architecture Statement

The Enterprise SQL Platform Lab uses a layered delivery model in which
the database artifact, environment configuration, and validation process
are independently controlled.

The database project produces the deployable database artifact.

The deployment layer provisions the target environment.

The security test layer proves that the resulting environment behaves
according to the security model.

LocalDB provides fast database development and DACPAC validation. Docker
SQL Server provides a reproducible SQL Server environment for
provisioning and security validation. The eventual managed deployment
lifecycle promotes the validated artifact through DEV, TEST, and PROD.

The fundamental lifecycle is:

``` text
DEVELOP
   |
   v
BUILD
   |
   v
DEPLOY
   |
   v
PROVISION
   |
   v
VALIDATE
   |
   v
PROMOTE
```

This separation is the foundation for reliable database DevOps and
prevents environment-specific security configuration from destabilizing
database artifact deployment.

