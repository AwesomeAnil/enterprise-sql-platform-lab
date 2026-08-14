# 12 --- Database Deployment

## 1\. Purpose

This document defines how the Enterprise SQL Platform Lab database is
converted from source code into a deployable database artifact and then
deployed to a target SQL Server environment.

It establishes the boundary between database project development,
database build, DACPAC creation, database publishing/deployment,
post-deployment database configuration, environment provisioning,
security validation, and future DEV → TEST → PROD promotion.

> \*\*The DACPAC deploys the database artifact. Environment provisioning
> prepares the environment in which that artifact runs.\*\*

## 2\. Deployment Architecture

``` text
Database Project
      |
      v
    BUILD
      |
      v
    DACPAC
      |
      v
   PUBLISH
      |
      v
Target Database
      |
      v
Environment Provisioning
      |
      v
Security Validation
```

The database project is the source of the DACPAC. The DACPAC is the
deployable database artifact. The target environment is configured
separately.

## 3\. Build, Publish and Deploy

**Build** compiles the database project and produces the deployable
database artifact.

``` text
Database project source
        |
        v
       Build
        |
        v
      DACPAC
```

**Publish** applies the database artifact to a selected database target.

``` text
DACPAC
  |
  +--> LocalDB
  |
  +--> Docker SQL Server
```

**Deploy** is the broader delivery operation of applying the database
artifact to an environment.

``` text
Build   = produce artifact
Publish = apply artifact to target
Deploy  = overall delivery operation
```

## 4\. What the DACPAC Represents

The DACPAC represents the database schema and database-level deployment
state defined by the database project.

It can contain:

* schemas
* tables
* views
* stored procedures
* functions
* database roles
* appropriate database-level permissions
* row-level security objects
* database post-deployment actions explicitly included in the project

The DACPAC is not a complete representation of an entire SQL Server
instance.

## 5\. What Does Not Belong in the DACPAC

Where they are environment/server-specific, the following remain outside
the database deployment artifact:

* server login creation
* server-level role membership
* environment-specific credentials
* target-server configuration
* operational environment provisioning
* security setup requiring server-level context

For this project, the security provisioning boundary is:

``` text
deployment/Provision-Security.sql
```

This separation prevents environment-specific server security from
becoming a prerequisite for successful DACPAC deployment.

## 6\. Database Project Post-Deployment Scripts

The database project contains a post-deployment mechanism:

``` text
Post-Deployment
      |
      v
Post-Deployment.sql
      |
      +--> Security.sql
```

The post-deployment script uses SQLCMD-style inclusion:

``` sql
:r .\\Security.sql
```

This causes the referenced SQL to become part of the generated
deployment script used by the database project.

This mechanism is appropriate for database-level configuration that
belongs to the database artifact.

It is **not** the mechanism for environment-specific server login
provisioning.

## 7\. Security.sql Versus Provision-Security.sql

These files have different responsibilities.

### `Security.sql`

Location:

``` text
database/.../Post-Deployment/
```

Purpose:

* database-level grants
* database roles where appropriate
* schema/object permissions that belong in the database artifact

It participates in DACPAC deployment.

### `Provision-Security.sql`

Location:

``` text
deployment/Provision-Security.sql
```

Purpose:

* environment-specific security provisioning
* server login configuration
* database user/login relationships
* role membership provisioning
* other target-environment security preparation

It does **not** participate in DACPAC deployment.

The boundary is:

``` text
                    DACPAC
                      |
          +-----------+-----------+
          |                       |
     Database objects       Database-level
                            security
          |                       |
          +-----------+-----------+
                      |
                Target database
                      |
                      v
            Provision-Security.sql
                      |
                      v
              Environment ready
```

## 8\. Why Role Membership Provisioning Was Removed from Security.sql

The project previously attempted to execute
`ALTER ROLE ... ADD MEMBER ...` statements as part of database
deployment.

This caused repeated deployment failures because the deployment context
and target environment did not consistently provide the required
principals and security context.

The architecture was corrected by moving role membership provisioning
to:

``` text
deployment/Provision-Security.sql
```

The database project no longer attempts to solve an environment
provisioning problem inside DACPAC deployment.

## 9\. LocalDB Deployment

LocalDB is the first deployment target used during database development.

``` text
Modify database project
        |
        v
Build
        |
        v
Publish to LocalDB
        |
        v
Validate database
```

LocalDB provides rapid feedback on database-object changes and is
particularly useful for schema development, stored procedure
development, DACPAC validation, database-object compatibility, and
supported database-level permissions.

LocalDB is not the authoritative environment for full server-level
security integration.

## 10\. Docker SQL Server Deployment

Docker SQL Server is the local integration deployment target.

``` text
Build database project
        |
        v
Publish DACPAC to Docker
        |
        v
Database deployed
        |
        v
Provision-Security.sql
        |
        v
Security tests
```

Docker should receive the same database implementation validated through
the database project. There should not be a separate Docker database
codebase.

## 11\. Complete Solution Deployment

The established engineering sequence is:

``` text
1. Build database project
2. Publish to LocalDB
3. Validate LocalDB
4. Publish database to Docker
5. Provision Docker environment
6. Run applicable security tests
7. Build complete solution
8. Deploy solution
```

A successful database build confirms that the database artifact can be
produced. A successful solution build confirms that the broader solution
can be built. Neither replaces runtime testing.

## 12\. Deployment Targets

\---

Target                              Purpose

\---

LocalDB                             Developer database and DACPAC
validation

Docker SQL Server                   Integration, provisioning and
security validation

DEV                                 Managed development deployment

TEST                                Promoted integration and acceptance
validation

## PROD                                Approved production deployment

LocalDB and Docker are engineering environments used before managed
promotion.

## 13\. DEV → TEST → PROD Promotion

The target managed deployment model is:

``` text
                 Source Control
                       |
                       v
                  Build DACPAC
                       |
                       v
                      DEV
                       |
                   Validate
                       |
                       v
                      TEST
                       |
                   Approve
                       |
                       v
                      PROD
```

The objective is to promote the approved database artifact rather than
rebuild different versions for each environment.

``` text
One source state
      |
      v
One validated artifact
      |
      +--> DEV
      |
      +--> TEST
      |
      +--> PROD
```

Environment-specific configuration is applied separately.

## 14\. Production Deployment

Production is a deployment target, not a separate database-development
project.

The intended future sequence is:

``` text
Approved artifact
       |
       v
Production deployment
       |
       v
Production provisioning
       |
       v
Production validation
```

A pipeline may eventually make this appear as a single approval/deploy
action. That does not mean provisioning disappears; it means the
pipeline automates the provisioning and validation steps.

## 15\. Deployment and Environment Provisioning Are Different

### Database deployment

Answers:

> What database objects should exist?

``` text
DACPAC
  |
  v
Database objects
```

### Environment provisioning

Answers:

> What does this target environment require to run those objects
> correctly?

``` text
Target environment
       |
       v
Provision-Security.sql
       |
       v
Runtime-ready environment
```

### Security testing

Answers:

> Does the resulting environment behave correctly?

``` text
Provisioned environment
       |
       v
Security tests
       |
       v
Pass / Fail
```

The three operations form a chain but are not the same operation.

## 16\. Deployment Validation Gates

### Gate 1 --- Build

Database project builds successfully.

### Gate 2 --- LocalDB publish

DACPAC publishes successfully to LocalDB.

### Gate 3 --- LocalDB validation

Expected database state exists.

### Gate 4 --- Docker publish

Database artifact publishes successfully to Docker SQL Server.

### Gate 5 --- Environment provisioning

`Provision-Security.sql` executes successfully against Docker.

### Gate 6 --- Security validation

Applicable security tests pass.

### Gate 7 --- Solution build

Complete solution builds successfully.

### Gate 8 --- Solution deployment

Deployment completes successfully against the intended target.

Each gate answers a different question.

## 17\. Troubleshooting by Deployment Boundary

### Build failure

Inspect the database project.

### LocalDB publish failure

Inspect the DACPAC, database project, LocalDB target, and deployment
compatibility.

### Docker publish failure

Inspect the DACPAC, Docker target, target database state, and deployment
compatibility.

### Provisioning failure

Inspect `deployment/Provision-Security.sql` and the Docker SQL Server
security state.

Do not move provisioning logic into `Security.sql` simply to make DACPAC
deployment succeed.

### Security test failure

Inspect database state, provisioning state, role membership,
permissions, and expected security behaviour.

Do not weaken or bypass the test merely to obtain a pass.

### Solution deployment failure

Inspect solution deployment configuration and the selected target
independently from the database project's internal objects.

## 18\. Deployment Cleanliness

A successful deployment should leave a clean repository and environment.

Verify:

* database project builds
* target database contains expected objects
* post-deployment database configuration is correct
* provisioning has completed where required
* security tests pass
* no obsolete workaround remains
* no environment-specific security script has been added to the
database project
* Git contains only intentional changes

The objective is:

> \*\*The correct artifact was deployed, the target environment was
> correctly provisioned, and the resulting state was validated.\*\*

## 19\. Developer Deployment Checklist

### Database artifact

``` text
\[ ] Database project builds
\[ ] DACPAC generated
\[ ] Expected database objects included
```

### LocalDB

``` text
\[ ] Publish succeeds
\[ ] Database state validated
```

### Docker

``` text
\[ ] Publish succeeds
\[ ] Provision-Security.sql executed when required
\[ ] Security tests pass
```

### Solution

``` text
\[ ] Complete solution builds
\[ ] Solution deployment succeeds
```

### Source control

``` text
\[ ] Changes reviewed
\[ ] No obsolete workaround remains
\[ ] Commit created
```

## 20\. Deployment Anti-Patterns

Avoid:

* environment-specific DACPAC security scripts such as
`LocalDB-Security.sql`, `Docker-Security.sql`, `DEV-Security.sql`,
`TEST-Security.sql`, and `PROD-Security.sql`
* server-login provisioning inside `Security.sql`
* security tests that repair security
* treating LocalDB as production-equivalent
* rebuilding separately for every environment

The target model is promotion of an approved artifact, not independent
source builds for DEV, TEST and PROD.

## 21\. Relationship to Other Documentation

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

`11\_Database\_Development\_Workflow.md` explains the complete developer
journey.

This document explains the database artifact and deployment stage in
greater depth.

`13\_Environment\_Provisioning.md` will explain what happens after the
database has been deployed.

## 22\. Final Deployment Model

``` text
SOURCE
  |
  v
DATABASE PROJECT
  |
  v
BUILD
  |
  v
DACPAC
  |
  v
DEPLOY
  |
  v
DATABASE
  |
  v
PROVISION ENVIRONMENT
  |
  v
VALIDATE
```

The DACPAC is responsible for the database.

Provisioning is responsible for the environment.

Testing is responsible for proving the result.

This separation keeps database deployment predictable, makes failures
easier to diagnose, and provides the foundation for eventual automated
promotion through DEV, TEST and PROD.

