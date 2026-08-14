# 13 --- Environment Provisioning

## 1. Purpose

This document defines how an environment is prepared after the database
artifact has been deployed.

It establishes the boundary between:

-   database deployment
-   environment provisioning
-   security validation
-   future automated environment delivery

The central principle is:

> **Database deployment creates the database state. Environment
> provisioning prepares the target environment. Security testing proves
> that the resulting environment behaves as intended.**

For this project, the primary environment-provisioning script is:

``` text
deployment/Provision-Security.sql
```

------------------------------------------------------------------------

## 2. Why Environment Provisioning Is Separate

A database project is concerned primarily with the database.

An environment contains more than the database.

For example:

``` text
Environment
├── SQL Server instance
├── Database
├── Server logins
├── Database users
├── Role memberships
├── Credentials / operational configuration
└── Other environment-specific settings
```

A DACPAC is therefore not an appropriate container for every aspect of
environment configuration.

The project deliberately separates these responsibilities:

``` text
DATABASE PROJECT
      |
      v
    DACPAC
      |
      v
DATABASE DEPLOYMENT
      |
      v
ENVIRONMENT PROVISIONING
      |
      v
SECURITY TESTING
```

This boundary was established after the project encountered repeated
deployment failures caused by trying to perform environment-specific
security operations inside DACPAC deployment.

------------------------------------------------------------------------

## 3. The Provisioning Script

The primary provisioning script is:

``` text
deployment/Provision-Security.sql
```

Its responsibility is to prepare the target SQL Server/database
environment for the security model required by the platform.

The script is deliberately outside the database project.

It therefore does not become part of the DACPAC.

Conceptually:

``` text
database/
    ...
    Post-Deployment/
        Security.sql

deployment/
    Provision-Security.sql
```

The distinction is intentional.

------------------------------------------------------------------------

## 4. What Provision-Security.sql Does

The provisioning script is responsible for operations that require the
target environment's security context.

Examples include:

-   creating or preparing server logins
-   creating or preparing corresponding database users
-   mapping users to logins where required
-   assigning users to database roles
-   applying environment-specific security relationships
-   establishing the prerequisites required by the security test suite

The script should be idempotent where practical.

That means running it against an already-provisioned environment should
not unnecessarily break or duplicate the environment.

------------------------------------------------------------------------

## 5. What Provision-Security.sql Does Not Do

The provisioning script should not become a second database deployment
script.

It should not be used to create ordinary database objects that belong in
the database project.

For example, these normally remain in the database project:

-   tables
-   schemas
-   views
-   stored procedures
-   functions
-   database security predicates
-   database-level grants

The distinction is:

``` text
Database object definition
        |
        v
Database Project / DACPAC

Environment-specific setup
        |
        v
Provision-Security.sql
```

------------------------------------------------------------------------

## 6. Security.sql and Provision-Security.sql

The two scripts solve different problems.

### Database project --- Security.sql

``` text
database/.../Post-Deployment/Security.sql
```

Contains database-level security configuration that belongs with the
database artifact.

Examples:

``` sql
GRANT SELECT ON SCHEMA::reporting TO [role_reporting];
GRANT SELECT ON SCHEMA::dataquality TO [role_dataquality];
```

These permissions are part of the database's expected security state.

### Environment provisioning --- Provision-Security.sql

``` text
deployment/Provision-Security.sql
```

Contains environment-specific security provisioning.

Examples include:

``` sql
CREATE LOGIN ...
CREATE USER ...
ALTER USER ... WITH LOGIN = ...
ALTER ROLE ... ADD MEMBER ...
```

These operations prepare the environment's principals and memberships.

They are intentionally outside DACPAC deployment.

------------------------------------------------------------------------

## 7. Why Role Membership Belongs Here

A particularly important example is:

``` sql
ALTER ROLE [role_crm]
ADD MEMBER [CRMLogin];
```

This statement requires both:

1.  the database role to exist
2.  the principal to exist in the target database

The role may be delivered by the database project.

The login/user may be environment-specific.

Therefore the clean sequence is:

``` text
DACPAC
  |
  +--> role_crm exists
  |
  v
Provision-Security.sql
  |
  +--> CRMLogin exists
  |
  +--> CRMLogin mapped as database user
  |
  +--> CRMLogin added to role_crm
  |
  v
Security tests
```

This is the exact boundary that prevented the earlier DACPAC deployment
failures.

------------------------------------------------------------------------

## 8. Current Local Development Model

The current local development model uses two SQL Server environments.

### LocalDB

LocalDB is used for:

-   database project development
-   DACPAC build validation
-   rapid database publishing
-   database-object validation

We maintain the database users required for local development, but
LocalDB is not treated as the full security-integration environment.

### Docker SQL Server

Docker SQL Server is used for:

-   database deployment
-   environment provisioning
-   server/database security integration
-   security testing

The complete local security lifecycle is therefore:

``` text
Database project
      |
      v
Build
      |
      v
Publish to LocalDB
      |
      v
Validate database
      |
      v
Publish to Docker
      |
      v
Provision-Security.sql
      |
      v
Security tests
```

------------------------------------------------------------------------

## 9. How to Execute Provision-Security.sql

During the current development workflow, the script is executed manually
against the Docker SQL Server target.

The important point is not the editor from which the script is opened.

The important point is the **active SQL connection**.

The script must execute against the intended target environment.

Conceptually:

``` text
Open Provision-Security.sql
        |
        v
Select Docker SQL Server connection
        |
        v
Execute
        |
        v
Docker environment provisioned
```

Do not assume that the connection used by the database project or SQL
Server Object Explorer is automatically the correct execution target.

Before execution, verify the active server/database context.

A useful safety check is:

``` sql
SELECT
    @@SERVERNAME AS ServerName,
    DB_NAME() AS DatabaseName,
    SUSER_SNAME() AS LoginName,
    USER_NAME() AS DatabaseUser;
```

This should identify the intended environment before provisioning is
performed.

------------------------------------------------------------------------

## 10. Provisioning Order

Provisioning should occur after database deployment.

The preferred sequence is:

``` text
1. Deploy database artifact
2. Confirm database exists
3. Confirm database roles exist
4. Execute Provision-Security.sql
5. Verify users and role memberships
6. Run security tests
```

The script should not be used to compensate for a failed database
deployment.

If the expected database role does not exist, investigate the database
deployment first.

------------------------------------------------------------------------

## 11. Principal Model

The project has established a deliberate relationship between server
logins, database users and database roles.

Conceptually:

``` text
SERVER LOGIN
     |
     | mapped to
     v
DATABASE USER
     |
     | member of
     v
DATABASE ROLE
     |
     | receives
     v
DATABASE PERMISSIONS
```

For example:

``` text
CRMLogin
   |
   v
CRMLogin
   |
   v
role_crm
   |
   v
CRM schema/object permissions
```

Regional users follow the same pattern:

``` text
CRMAMERUser ──> role_crm
CRMAPACUser ──> role_crm
CRMEMEAUser ──> role_crm
CRMLogin     ──> role_crm
```

The provisioning layer establishes the environment-side principal
relationships.

The database project establishes the database-side objects and
permissions.

------------------------------------------------------------------------

## 12. Provisioning Versus Testing

This distinction is critical.

### Provisioning

Provisioning creates or configures the required environment state.

``` text
Provision-Security.sql
        |
        v
Environment state
```

### Testing

Testing verifies that the state is correct.

``` text
tests/Security/*.sql
        |
        v
PASS / FAIL
```

A test should not silently create a login, repair a role membership, or
grant a missing permission.

If a test fails because security is incorrectly configured, the
provisioning process should be corrected.

This creates a clean diagnostic boundary.

------------------------------------------------------------------------

## 13. Provisioning Versus Database Security

There are two related security layers.

### Database security

Examples:

-   database roles
-   schema permissions
-   object permissions
-   row-level security
-   security predicates

These are primarily database-project concerns.

### Environment security

Examples:

-   SQL Server logins
-   login-to-user mappings
-   environment-specific principals
-   role membership provisioning

These are environment-provisioning concerns.

The complete security model is:

``` text
                 SECURITY
                    |
        +-----------+-----------+
        |                       |
   DATABASE SECURITY      ENVIRONMENT SECURITY
        |                       |
   roles/grants/RLS        logins/users/
                           memberships
        |                       |
        +-----------+-----------+
                    |
                    v
             Runtime behaviour
                    |
                    v
             Security tests
```

------------------------------------------------------------------------

## 14. Idempotency

Provisioning scripts should preferably be safe to execute more than
once.

A robust pattern is:

``` sql
IF NOT EXISTS (...)
BEGIN
    CREATE ...
END;
```

Similarly, role membership operations should avoid failing simply
because the desired membership already exists.

The goal is:

``` text
First execution
    |
    v
Environment created

Second execution
    |
    v
Environment remains correct
```

Idempotency becomes increasingly important when the script is eventually
executed automatically by deployment pipelines.

------------------------------------------------------------------------

## 15. Environment-Specific Values

Provisioning scripts may eventually require environment-specific values.

Examples include:

-   login names
-   credentials
-   server-specific settings
-   database names
-   external integration principals

These values should not be hard-coded in a way that makes the same
provisioning logic unsafe across environments.

The long-term model is:

``` text
Common provisioning logic
          |
          +--> DEV values
          |
          +--> TEST values
          |
          +--> PROD values
```

The implementation mechanism may later use pipeline variables, SQLCMD
variables, secret stores, or another controlled configuration mechanism.

Secrets must never be committed to Git in plaintext.

------------------------------------------------------------------------

## 16. DEV, TEST and PROD

The same architectural boundary applies to managed environments.

### DEV

``` text
Deploy DACPAC
      |
      v
Provision environment
      |
      v
Validate
```

### TEST

``` text
Promote approved artifact
      |
      v
Provision TEST environment
      |
      v
Run integration/security tests
```

### PROD

``` text
Approve release
      |
      v
Deploy approved artifact
      |
      v
Provision production environment
      |
      v
Run controlled validation
```

The production deployment may eventually be a single pipeline action
from the developer's perspective, but provisioning remains a distinct
logical stage.

------------------------------------------------------------------------

## 17. Why We Do Not Create LocalDB-Security.sql and Docker-Security.sql

The project deliberately avoids maintaining separate copies such as:

``` text
LocalDB-Security.sql
Docker-Security.sql
```

This would create unnecessary duplication and drift.

Instead:

``` text
deployment/
    Provision-Security.sql
```

contains the provisioning model.

The execution environment determines the target.

Where behaviour genuinely differs by environment, that difference should
be explicit and controlled rather than hidden in duplicated scripts.

------------------------------------------------------------------------

## 18. Provisioning Failure Troubleshooting

### Login creation fails

Check:

-   target server
-   login existence
-   permissions
-   whether the login is intentionally managed elsewhere

Do not modify DACPAC deployment to solve a server-login problem.

### Database user does not exist

Check:

-   correct database
-   database deployment status
-   user name
-   whether the user belongs in the target environment

### Role does not exist

Check the database deployment.

The database role should normally come from the database project.

### `ALTER ROLE ... ADD MEMBER` fails

Check:

-   target database
-   role existence
-   database user existence
-   executing principal's permissions
-   whether the membership already exists

Do not immediately move the statement back into `Security.sql`.

### Provisioning succeeds but security tests fail

Treat this as a runtime security validation problem.

Inspect:

-   role membership
-   permissions
-   row-level security configuration
-   user context
-   test expectations

------------------------------------------------------------------------

## 19. Provisioning Checklist

Before executing:

``` text
[ ] Correct target server selected
[ ] Correct target database selected
[ ] Database deployment completed
[ ] Expected database roles exist
[ ] Script contains no obsolete workaround
[ ] No plaintext secrets are present
```

After executing:

``` text
[ ] Server logins verified
[ ] Database users verified
[ ] Login/user mappings verified
[ ] Role memberships verified
[ ] Applicable security tests executed
[ ] Results recorded
```

------------------------------------------------------------------------

## 20. Relationship to the Security Test Suite

Provisioning prepares the state.

The security test suite validates it.

``` text
deployment/
    Provision-Security.sql
             |
             v
       Provision state
             |
             v
tests/Security/
    01_CRM.sql
    02_CustomerSuccess.sql
    03_Finance.sql
    ...
             |
             v
        PASS / FAIL
```

The two areas should remain independent.

If a security test fails, the test should tell us what is wrong rather
than silently repairing it.

------------------------------------------------------------------------

## 21. Future Pipeline Automation

The current process is intentionally manual:

``` text
Developer
   |
   v
Publish Docker
   |
   v
Execute Provision-Security.sql
   |
   v
Run Security Tests
```

The long-term DevOps model can automate the same logical stages:

``` text
Pipeline
   |
   +--> Deploy DACPAC
   |
   +--> Provision environment
   |
   +--> Run security tests
   |
   +--> Report result
```

Automation should preserve the architectural boundaries rather than
combine everything into one opaque deployment script.

The goal is not merely fewer clicks.

The goal is a repeatable, auditable deployment process.

------------------------------------------------------------------------

## 22. Final Provisioning Model

The environment-provisioning model is:

``` text
                  DATABASE ARTIFACT
                         |
                         v
                    DACPAC DEPLOY
                         |
                         v
                    TARGET DATABASE
                         |
                         v
               Provision-Security.sql
                         |
          +--------------+--------------+
          |              |              |
       Logins          Users      Role Memberships
          |              |              |
          +--------------+--------------+
                         |
                         v
                  SECURITY TESTS
                         |
                         v
                    PASS / FAIL
```

The rule to retain is:

> **Provisioning creates the environment state; security tests verify
> the environment state.**

The database project remains responsible for the database.

`Provision-Security.sql` remains responsible for environment
provisioning.

`tests/Security/*.sql` remains responsible for security validation.

That separation is the foundation for safely extending the current
Docker workflow into automated DEV, TEST and PROD deployment pipelines.
