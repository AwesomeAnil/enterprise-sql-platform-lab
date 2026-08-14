# 11 --- Database Development Workflow

## 1\. Purpose

This document defines the repeatable development workflow for the
Enterprise SQL Platform Lab database.

It is intended to allow a developer to return to the repository at any
future point, understand the workflow, and reproduce the database
development process without relying on undocumented historical
knowledge.

The workflow separates:

* database object development
* database artifact validation
* environment provisioning
* security testing
* solution deployment
* source-control commit

The workflow is designed around the architectural boundaries established
in `10\_Architecture\_Overview.md`.

\---

## 2\. Development Lifecycle

The standard database development lifecycle is:

``` text
CHANGE
  |
  v
BUILD
  |
  v
PUBLISH TO LOCALDB
  |
  v
VALIDATE
  |
  v
PUBLISH TO DOCKER SQL
  |
  v
PROVISION ENVIRONMENT
  |
  v
RUN SECURITY TESTS
  |
  v
BUILD SOLUTION
  |
  v
DEPLOY SOLUTION
  |
  v
COMMIT TO GIT
```

Not every change requires every validation step. However, changes
affecting database security, deployment behaviour, stored procedures,
schemas, or other integration-sensitive components should follow the
complete workflow.

\---

## 3\. Step 1 --- Make the Database Change

Database objects are developed inside the database project:

``` text
database/
└── enterprise-sql-platform-lab/
```

Examples include:

* tables
* schemas
* views
* stored procedures
* functions
* database roles
* security predicates
* row-level security objects
* database-level grants

The database project remains the source of truth for objects that belong
in the DACPAC.

Environment provisioning scripts and runtime security tests do not
belong in this project.

\---

## 4\. Step 2 --- Build the Database Project

After making a database change, build the database project.

The build verifies that the database project can be compiled into a
deployable database artifact.

Conceptually:

``` text
Database source
      |
      v
Database project build
      |
      v
DACPAC
```

A successful build is the first gate.

If the build fails, deployment and security testing should not proceed
until the database project is corrected.

\---

## 5\. Step 3 --- Publish to LocalDB

Publish the database project to LocalDB.

LocalDB is the fast developer validation environment.

Use it to confirm:

* database objects deploy correctly
* schemas are present
* tables and relationships are correct
* unit testing stored procedures - compilation and execution
* database roles exist
* DACPAC publishing behaves as expected
* database-level permissions are valid within the capabilities of the
environment

The LocalDB cycle is deliberately fast:

``` text
Edit
 ↓
Build
 ↓
Publish LocalDB
 ↓
Validate
```

This allows database development problems to be detected before moving
to the integration environment.

\---

## 6\. Step 4 --- Validate LocalDB

Validation should be proportionate to the change.

Typical validation includes:

* checking object existence
* checking stored procedure execution
* checking row counts where appropriate
* checking schema and role existence
* checking database permissions
* checking that the expected database state was produced by the
publish operation

LocalDB is not required to reproduce every SQL Server security
capability.

Its role is rapid database development and DACPAC validation, not
complete server-security simulation.

\---

## 7\. Step 5 --- Publish to Docker SQL Server

Once the LocalDB validation is successful, publish the database project
to the Docker SQL Server environment.

Docker SQL Server provides the reproducible SQL Server integration
environment used by the project for security provisioning and runtime
security validation.

The workflow becomes:

``` text
LocalDB validation
       |
       v
Docker SQL Server
```

This environment should receive the same database implementation rather
than a separately maintained Docker-specific database codebase.

\---

## 8\. Step 6 --- Provision the Docker Environment

Environment provisioning occurs outside the database project.

The provisioning script is:

``` text
deployment/Provision-Security.sql
```

It is executed manually against Docker during the current local
development workflow.

The script is responsible for environment-specific security
provisioning, including the server/database security relationships
required by the environment.

The important boundary is:

``` text
DACPAC
  |
  v
Database deployed
  |
  v
Provision-Security.sql
  |
  v
Environment ready for security testing
```

Security provisioning is therefore not part of the database project's
DACPAC deployment.

\---

## 9\. Step 7 --- Run Security Tests

After provisioning, execute the security tests under:

``` text
tests/Security/
```

The tests validate the resulting environment.

They do not provision or repair security.

The current security test suite is organized as:

``` text
01\_CRM.sql
02\_CustomerSuccess.sql
03\_Finance.sql
04\_Sales.sql
05\_Reporting.sql
06\_DataQuality.sql
07\_ETL.sql
08\_Developer.sql
09\_SecurityBaseline.sql
```

The tests cover role membership, object/schema access, row-level
security, ETL permissions, developer permissions, and broader
security-baseline behaviour as appropriate.

A successful test suite provides evidence that:

``` text
Database
   +
Provisioned security
   =
Expected runtime behaviour
```

\---

## 10\. Step 8 --- Build the Complete Solution

Once the database and security validation are successful, build the
complete solution at the solution/project level.

This provides an additional validation gate beyond the individual
database-project build.

The distinction is:

``` text
Database project build
        |
        v
Database artifact validation

Solution build
        |
        v
Solution-level integration validation
```

A successful solution build does not replace runtime testing. It is an
additional engineering gate.

\---

## 11\. Step 9 --- Deploy the Solution

After the complete solution builds successfully, deploy the solution
using the project's established deployment mechanism.

The exact deployment target depends on the current stage of the project.

The architectural model remains:

``` text
Build
  ↓
Artifact
  ↓
Target environment
  ↓
Environment provisioning
  ↓
Validation
```

For local development, Docker is the principal environment used for full
security integration validation.

For managed environments, the same conceptual sequence becomes:

``` text
DEV
 ↓
TEST
 ↓
PROD
```

with promotion and provisioning controlled by the deployment process.

\---

## 12\. Step 10 --- Review the Change

Before committing, review the complete change set.

Check:

* database project changes
* deployment scripts
* security test scripts
* documentation changes
* generated or temporary files
* accidental environment-specific files
* obsolete scripts
* commented-out deployment workarounds

In particular, do not reintroduce the old pattern of embedding
server-login or role-membership operations into `Security.sql` merely
because a deployment requires those operations.

The correct location is:

``` text
deployment/Provision-Security.sql
```

\---

## 13\. Step 11 --- Commit to Git

Once the change has passed the appropriate validation gates, commit it
to Git.

A useful commit should describe the logical unit of work rather than
merely stating that files changed.

For example:

``` text
Add security provisioning and validation workflow
```

The commit should contain the source changes and documentation necessary
to reproduce the validated state.

The Git repository is the durable record of the engineering
implementation.

\---

## 14\. LocalDB and Docker: Why Both Exist

The two local environments serve different purposes.

Capability                                           LocalDB   Docker SQL Server

\---

Database development                                     Yes                 Yes
DACPAC build validation                                  Yes                 Yes
Rapid publish cycle                                      Yes                 Yes
Database object validation                               Yes                 Yes
Server-login provisioning                     Not the target                 Yes
Full security integration testing                    Limited                 Yes
`Provision-Security.sql`              Not the primary target                 Yes
Security test suite                   Not the primary target                 Yes

This distinction prevents the project from attempting to force LocalDB
to behave like a complete SQL Server integration environment.

\---

## 15\. What Must Remain Separate

The following responsibilities must not be collapsed into a single
deployment script.

### Database deployment

Responsible for deploying the database artifact.

``` text
Database project → DACPAC → Database
```

### Environment provisioning

Responsible for preparing the target environment.

``` text
deployment/Provision-Security.sql
```

### Security validation

Responsible for proving the environment behaves correctly.

``` text
tests/Security/\*.sql
```

The three stages are intentionally independent.

\---

## 16\. Handling Database Security Changes

Security-related database changes require particular care because
security can cross multiple deployment boundaries.

For example, a change might involve:

``` text
Database role
      |
      v
Database permission
      |
      v
Server login
      |
      v
Database user
      |
      v
Role membership
      |
      v
Runtime access
```

The database portion belongs in the database project when appropriate.

The environment-specific login/user/membership provisioning belongs in
`Provision-Security.sql`.

The expected runtime behaviour belongs in the security test suite.

This separation prevents a change in one layer from unnecessarily
destabilizing another.

\---

## 17\. Failure Handling

When a deployment or validation step fails, diagnose the failing
boundary before modifying scripts.

### Build failure

Inspect the database project.

### LocalDB publish failure

Inspect the database artifact and database-project deployment
compatibility.

### Docker publish failure

Inspect the target Docker database and deployment compatibility.

### Provisioning failure

Inspect:

``` text
deployment/Provision-Security.sql
```

and the Docker SQL Server environment.

Do not modify the DACPAC merely to work around a server-level
provisioning problem.

### Security test failure

Inspect the deployed database, provisioning state, and expected security
model.

Do not automatically modify the test to make it pass.

### Solution deployment failure

Inspect the solution deployment configuration and target environment
separately from the database artifact.

This boundary-oriented troubleshooting approach is intended to prevent
the deployment/security problems encountered earlier in the project from
recurring.

\---

## 18\. Repeatable Developer Checklist

For a normal database change:

``` text
\[ ] Modify database project
\[ ] Build database project
\[ ] Publish to LocalDB
\[ ] Validate LocalDB
\[ ] Publish to Docker SQL Server
\[ ] Run Provision-Security.sql when required
\[ ] Run applicable security tests
\[ ] Build complete solution
\[ ] Deploy solution when required
\[ ] Review Git changes
\[ ] Commit validated changes
```

For a purely local database-object change, the complete security cycle
may not be necessary.

For changes involving security, deployment configuration, stored
procedures, schemas, roles, permissions, or integration behaviour, the
full workflow should be preferred.

\---

## 19\. Clean Development State

A clean development state means:

* the database project builds successfully
* LocalDB publishes successfully
* Docker SQL Server publishes successfully
* required environment provisioning succeeds
* applicable security tests pass
* the solution builds successfully
* deployment completes successfully
* Git contains the intended source and documentation changes
* no obsolete workaround scripts remain

The goal is not simply to achieve a successful deployment.

The goal is to leave the repository and environments in a state that
another developer can reproduce.

\---

## 20\. Relationship to the Remaining Documentation

This document explains the day-to-day development workflow.

The following documents provide deeper treatment of individual stages:

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

In particular:

* `12\_Database\_Deployment.md` will explain DACPAC build, publish, and
deployment mechanics.
* `13\_Environment\_Provisioning.md` will explain
`Provision-Security.sql` in detail.
* `14\_Security\_Architecture.md` will explain the security model
itself.
* `15\_Security\_Testing.md` will explain the test suite and validation
strategy.
* `16\_Git\_Development\_Workflow.md` will explain source control,
branches, commits, and promotion.

This document therefore remains the practical starting point for
database development.

\---

## 21\. Final Workflow

The repeatable engineering pattern is:

``` text
                  DATABASE DEVELOPMENT
                           |
                           v
                       BUILD
                           |
                           v
                       LOCALDB
                           |
                     Validate quickly
                           |
                           v
                    DOCKER SQL SERVER
                           |
                           v
                  PROVISION ENVIRONMENT
                           |
                           v
                    SECURITY TESTS
                           |
                           v
                    BUILD SOLUTION
                           |
                           v
                   DEPLOY / VALIDATE
                           |
                           v
                        GIT COMMIT
                           |
                           v
                 READY FOR PROMOTION
```

The workflow deliberately separates **creating the database**,
**preparing the environment**, and **proving the environment**.

That separation is the foundation of the platform's database DevOps
model.

