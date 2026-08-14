# 15 --- Security Testing

## 1\. Purpose

This document defines how the Enterprise SQL Platform Lab validates its
database security model.

Security testing is deliberately separate from:

* database object deployment
* DACPAC deployment
* environment provisioning

The governing model is:

``` text
Database deployment
        |
        v
Environment provisioning
        |
        v
Security testing
        |
        v
PASS / FAIL
```

The purpose of the test suite is to provide evidence that the security
configuration actually behaves as designed.

A successful deployment is **not** considered sufficient evidence of
correct security.

\---

## 2\. Testing Principles

The security test suite follows these principles:

1. **Tests validate; they do not provision.**
2. **Tests should be repeatable.**
3. **Tests should execute against the intended environment.**
4. **Tests should verify both permitted and restricted behavior where
appropriate.**
5. **Tests should identify the security boundary being validated.**
6. **A failed test should lead to diagnosis rather than an automatic
security repair.**
7. **The same logical security tests should be usable against Docker
and future managed environments.**

The test suite is therefore an independent verification layer.

\---

## 3\. Test Location

Security tests are maintained outside the database project's DACPAC
deployment path:

``` text
tests/
└── Security/
    ├── 01\_CRM.sql
    ├── 02\_CustomerSuccess.sql
    ├── ...
```

The exact file names may evolve as the suite grows, but the principle
remains:

> \*\*Security tests are executable verification scripts, not deployment
> scripts.\*\*

\---

## 4\. Current Execution Environment

The security model is currently validated primarily against the Docker
SQL Server environment.

The reason is architectural.

LocalDB is useful for:

* database development
* database object validation
* DACPAC build validation
* rapid publishing

Docker SQL Server provides the stronger environment for:

* server login integration
* database-user mapping
* environment provisioning
* security integration testing
* runtime security validation

The current local security lifecycle is therefore:

``` text
LocalDB
  |
  | database development
  v
Build / Publish
  |
  v
Docker SQL Server
  |
  | Provision-Security.sql
  v
Provisioned environment
  |
  v
Security tests
```

\---

## 5\. Test Execution Rules

Before running a security test:

### Confirm the target

Always verify the active connection.

A useful diagnostic query is:

``` sql
SELECT
    @@SERVERNAME AS ServerName,
    DB\_NAME() AS DatabaseName,
    SUSER\_SNAME() AS LoginName,
    USER\_NAME() AS DatabaseUser;
```

This prevents a test from accidentally being executed against LocalDB
when Docker is the intended target, or vice versa.

### Confirm provisioning

The target environment should already have been provisioned.

That means:

``` text
Logins
Users
Mappings
Role memberships
Database permissions
```

should already exist.

### Confirm deployment

The current database artifact must already be deployed.

A security test should not be used to determine whether the database
itself was successfully deployed.

\---

## 6\. Test Categories

The security suite validates several distinct areas:

``` text
1. Identity
2. Role membership
3. Schema permissions
4. Object permissions
5. Functional access
6. Restricted access
7. Row-level security
8. ETL permissions
9. Developer permissions
10. Security baseline
```

Each category tests a different part of the security architecture.

\---

## 7\. Identity Testing

Identity tests confirm that the expected security principal is being
evaluated.

Typical diagnostic information includes:

``` sql
SELECT
    SUSER\_SNAME() AS LoginName,
    USER\_NAME() AS DatabaseUser;
```

This is particularly useful when executing tests manually under
different logins.

A successful identity test confirms that the SQL Server connection is
operating under the intended security context.

\---

## 8\. Role Membership Testing

Role membership tests verify that users have been assigned to the
correct functional roles.

The expected state is:

``` text
role\_crm
 ├── CRMAMERUser
 ├── CRMAPACUser
 ├── CRMEMEAUser
 └── CRMLogin

role\_customersuccess
 └── CustomerSuccessUser

role\_dataquality
 └── DataQualityUser

role\_developer
 └── DeveloperUser

role\_etl
 └── ETLUser

role\_finance
 └── FinanceUser

role\_reporting
 └── ReportingUser

role\_sales
 ├── SalesAMERUser
 ├── SalesAPACUser
 └── SalesEMEAUser
```

A useful inspection query is:

``` sql
SELECT
    r.name AS RoleName,
    m.name AS MemberName
FROM sys.database\_role\_members drm
JOIN sys.database\_principals r
    ON drm.role\_principal\_id = r.principal\_id
JOIN sys.database\_principals m
    ON drm.member\_principal\_id = m.principal\_id
ORDER BY
    r.name,
    m.name;
```

The test should compare the actual state with the expected architecture.

\---

## 9\. CRM Security Test

The CRM test validates the CRM access boundary.

Expected role:

``` text
role\_crm
```

Expected members include:

``` text
CRMLogin
CRMAMERUser
CRMAPACUser
CRMEMEAUser
```

Expected capability:

``` text
SELECT
  |
  v
crm schema
  |
  v
CRM data
```

The test should be executed using the relevant CRM principals and should
confirm that the expected CRM data can be read.

The test should not create the role, user or permission if something is
missing.

\---

## 10\. Customer Success Security Test

The Customer Success test validates:

``` text
CustomerSuccessUser
       |
       v
role\_customersuccess
       |
       v
customersuccess schema
```

Expected capability:

``` text
SELECT
```

The test should verify that the intended Customer Success data is
accessible.

\---

## 11\. Finance Security Test

The Finance test validates:

``` text
FinanceUser
       |
       v
role\_finance
       |
       v
finance schema
```

Expected capability:

``` text
SELECT
```

The `FinanceLedger` object is part of the validated Finance security
boundary.

The test confirms that the intended Finance principal can read the
required data.

\---

## 12\. Sales Security Test

The Sales test validates:

``` text
SalesAMERUser
SalesAPACUser
SalesEMEAUser
        |
        v
    role\_sales
        |
        v
    sales schema
```

Expected capability:

``` text
SELECT
```

The test also validates the more restrictive Sales territory model
described in the following section.

\---

## 13\. Sales Row-Level Security Test

The Sales RLS test is one of the most important security tests in the
suite.

The expected mapping is:

Principal         Territory

\---

`SalesAMERUser`   `AMER`
`SalesAPACUser`   `APAC`
`SalesEMEAUser`   `EMEA`

The test must establish that:

``` text
SalesAMERUser
    -> can only see AMER rows

SalesAPACUser
    -> can only see APAC rows

SalesEMEAUser
    -> can only see EMEA rows
```

and that a regional principal cannot see another region's restricted
rows.

This verifies the distinction between:

``` text
Object permission
```

and:

``` text
Row-level authorization
```

\---

## 14\. Sales Predicate

The underlying predicate is:

``` text
security.fn\_SalesTerritoryPredicate
```

Its logic considers:

``` text
role\_developer
role\_finance
dbo
security.SalesRegionAccess
```

Conceptually:

``` text
Privileged role?
       |
   Yes +----> Allow
       |
      No
       |
dbo?
       |
   Yes +----> Allow
       |
      No
       |
Matching SalesRegionAccess row?
       |
   Yes +----> Allow
       |
      No
       |
      Deny
```

The test suite validates the resulting runtime behaviour rather than
merely checking that the function exists.

\---

## 15\. Reporting Security Test

The Reporting test validates:

``` text
ReportingUser
       |
       v
role\_reporting
       |
       v
reporting schema
```

Expected capability:

``` text
SELECT
```

The test confirms that the reporting principal can read the reporting
layer as intended.

\---

## 16\. Data Quality Security Test

The Data Quality test validates:

``` text
DataQualityUser
       |
       v
role\_dataquality
       |
       v
dataquality schema
```

Expected capability:

``` text
SELECT
```

The test confirms that the Data Quality principal can access the
intended data-quality objects.

\---

## 17\. ETL Security Test

The ETL test validates:

``` text
ETLUser
    |
    v
role\_etl
    |
    +--> staging
    |
    +--> warehouse
    |
    +--> pipeline
```

Expected permissions include:

``` text
staging
    SELECT
    ALTER
    EXECUTE

warehouse
    EXECUTE

pipeline
    EXECUTE
```

The test should validate the ability to execute the required ETL
procedures.

It should also confirm that the ETL principal does not receive
unrestricted developer-level warehouse modification rights unless
explicitly designed.

\---

## 18\. Developer Security Test

The Developer test validates:

``` text
DeveloperUser
      |
      v
role\_developer
      |
      +--> warehouse
      |
      +--> pipeline
```

Expected warehouse capabilities:

``` text
SELECT
INSERT
UPDATE
DELETE
```

Expected pipeline capability:

``` text
EXECUTE
```

The test confirms that the developer role has the intended development
privileges without assuming unrestricted server administration.

\---

## 19\. Negative Security Tests

Positive tests confirm what a principal **can** do.

Negative tests confirm what a principal **cannot** do.

Both are important.

For example:

``` text
SalesAMERUser
    |
    +--> AMER access: ALLOWED
    |
    +--> APAC access: DENIED
    |
    +--> EMEA access: DENIED
```

Negative tests should be used where the security boundary is meaningful
and deterministic.

They provide stronger evidence of least privilege than positive tests
alone.

\---

## 20\. Security Baseline Test

The security baseline test verifies the overall security state.

It can inspect:

* database users
* login mappings
* roles
* role memberships
* schema permissions
* selected object permissions
* security predicates
* RLS mapping data

Useful catalog views include:

``` text
sys.database\_principals
sys.database\_role\_members
sys.database\_permissions
sys.objects
sys.schemas
sys.sql\_modules
```

The baseline test is particularly useful after deployment or
provisioning changes.

\---

## 21\. Test Execution Order

The recommended order is:

``` text
1. Verify target connection
        |
        v
2. Verify database deployment
        |
        v
3. Verify environment provisioning
        |
        v
4. Verify role memberships
        |
        v
5. Run functional security tests
        |
        v
6. Run RLS tests
        |
        v
7. Run negative/restriction tests
        |
        v
8. Run security baseline
```

This order moves from infrastructure state toward application behaviour.

\---

## 22\. Why Tests Should Be Run Under the Appropriate Login

A security test is meaningful only when executed under the security
context it is intended to evaluate.

For example:

``` text
ETL test
    |
    v
ETLLogin
```

rather than an administrative account.

Likewise:

``` text
Sales RLS test
    |
    +--> SalesAMERUser
    +--> SalesAPACUser
    +--> SalesEMEAUser
```

Using an administrator for these tests can invalidate the test because
the administrator may legitimately bypass restrictions.

The exception is a test specifically intended to validate privileged or
`dbo` behaviour.

\---

## 23\. `dbo` Is Not the Same as `sa`

`dbo` is a database principal/context.

`sa` is a SQL Server login.

They are not interchangeable concepts.

A test requiring `dbo` should establish the appropriate database-owner
context rather than assuming that every test must be executed by `sa`.

This distinction matters especially for RLS testing, because the
predicate explicitly recognizes the `dbo` context.

\---

## 24\. What a Passing Test Means

A passing security test means:

``` text
Expected security context
        |
        v
Expected authorization decision
        |
        v
Expected runtime result
```

It does not mean that the entire SQL Server environment is universally
secure.

The test proves the specific security contract that it was designed to
validate.

\---

## 25\. What a Failed Test Means

A failure should be classified before changing anything.

### Category A --- Wrong connection

The test ran against the wrong server or database.

**Action:** reconnect and rerun.

### Category B --- Missing provisioning

The login, user, mapping or role membership is missing.

**Action:** inspect `Provision-Security.sql` and the environment.

### Category C --- Database deployment problem

The expected role, schema, object or predicate does not exist.

**Action:** inspect the database deployment/DACPAC.

### Category D --- Permission problem

The principal exists but lacks the required authorization.

**Action:** inspect the database security configuration.

### Category E --- RLS problem

Object access works but row filtering is incorrect.

**Action:** inspect the predicate and security mapping data.

### Category F --- Test problem

The implementation is correct but the test expectation or execution
context is wrong.

**Action:** review the test before changing production configuration.

\---

## 26\. Do Not Repair During Testing

A security test should not contain remediation such as:

``` sql
CREATE LOGIN ...
CREATE USER ...
ALTER ROLE ... ADD MEMBER ...
GRANT ...
```

Those belong to provisioning or database security configuration.

A test should instead report the failure.

This maintains the clean separation:

``` text
Configuration
      |
      v
Provisioning
      |
      v
Testing
      |
      v
Evidence
```

\---

## 27\. Test Repeatability

Tests should be safe to run repeatedly.

A test should preferably:

* inspect state
* execute a read/authorization operation
* return a clear result
* avoid changing persistent security state

This allows the same tests to be run:

* after a local deployment
* after provisioning
* after a security change
* before a Git commit
* during CI/CD
* after promotion to TEST
* after production deployment where appropriate

\---

## 28\. Current Manual Workflow

The current local workflow is:

``` text
1. Build database project
        |
        v
2. Publish to LocalDB
        |
        v
3. Validate database
        |
        v
4. Publish database to Docker
        |
        v
5. Execute deployment/Provision-Security.sql
        |
        v
6. Verify environment security
        |
        v
7. Execute tests/Security/\*.sql
        |
        v
8. Record PASS / investigate FAIL
```

This is the current reference workflow.

\---

## 29\. Relationship to DACPAC Deployment

Security testing does not replace deployment validation.

The layers are:

``` text
DACPAC
  |
  +--> Database object correctness

Provision-Security.sql
  |
  +--> Environment principal correctness

Security tests
  |
  +--> Runtime authorization correctness
```

A release should therefore be considered healthy only when the relevant
layers have succeeded.

\---

## 30\. Future CI/CD Model

The current manual process can later become pipeline automation:

``` text
Build
  |
  v
Deploy DACPAC
  |
  v
Provision environment
  |
  v
Run security tests
  |
  v
PASS
  |
  v
Promote
```

The automation should preserve the same boundaries.

It should not combine provisioning and testing into a single opaque SQL
script.

\---

## 31\. Security Test Checklist

Before declaring security validation complete:

``` text
\[ ] Correct server verified
\[ ] Correct database verified
\[ ] Database deployment successful
\[ ] Environment provisioning successful
\[ ] Login/user mappings verified
\[ ] Role memberships verified
\[ ] CRM test passed
\[ ] Customer Success test passed
\[ ] Finance test passed
\[ ] Sales test passed
\[ ] Sales RLS test passed
\[ ] Reporting test passed
\[ ] Data Quality test passed
\[ ] ETL test passed
\[ ] Developer test passed
\[ ] Relevant negative tests passed
\[ ] Security baseline passed
```

\---

## 32\. Evidence and Troubleshooting

Security test output should be retained as evidence when the project
moves toward automated deployment.

Useful evidence includes:

``` text
Test name
Target server
Target database
Execution principal
Expected result
Actual result
Timestamp
PASS / FAIL
```

When a test fails, capture enough information to reproduce the failure
before changing the environment.

\---

## 33\. Security Testing Philosophy

The security suite is deliberately designed as a separate verification
layer.

The principle is:

> \*\*Do not prove security by looking at configuration alone. Prove it by
> exercising the authorization model under the intended security
> contexts.\*\*

For example, seeing:

``` text
SalesAMERUser -> role\_sales
```

is useful configuration evidence.

Actually connecting as `SalesAMERUser` and demonstrating:

``` text
AMER rows -> visible
APAC rows -> restricted
EMEA rows -> restricted
```

is runtime security evidence.

Both forms of evidence are valuable.

\---

## 34\. Final Testing Model

The complete model is:

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
             Provision-Security.sql
                       |
                       v
                SECURITY TESTS
                       |
          +------------+------------+
          |            |            |
       Positive      Negative      RLS
        Tests         Tests        Tests
          |            |            |
          +------------+------------+
                       |
                       v
                  PASS / FAIL
```

The governing principle is:

> \*\*Provisioning creates the expected security state. Security testing
> independently proves that the state produces the expected runtime
> behaviour.\*\*

That distinction is essential to maintaining a clean, repeatable and
eventually automatable DevOps architecture.

