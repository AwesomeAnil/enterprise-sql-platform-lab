# 02 — Engineering Methodology

## 1. Purpose

This document defines the engineering methodology used to develop, change, validate, deploy and maintain the Enterprise SQL Platform.

The methodology treats SQL Server database development as software engineering.

The objective is not simply to make a database work.

The objective is to make database changes:

- understandable;
- source-controlled;
- repeatable;
- testable;
- deployable;
- traceable;
- maintainable.

This document describes the engineering principles and development discipline behind the platform.

Detailed operational procedures are documented separately in the development, deployment, Git and security-testing workflow documents.

---

## 2. Core Methodology

The platform follows a controlled engineering loop:

```text
Understand
    |
    v
Design
    |
    v
Implement
    |
    v
Build
    |
    v
Publish
    |
    v
Validate
    |
    v
Commit
    |
    v
Promote
    |
    v
Test
```

The loop is iterative.

A change is not considered complete merely because the SQL executes successfully once.

It is complete when the implementation is represented correctly in source control, builds successfully, deploys successfully and passes the appropriate validation.

---

## 3. Database as Code

The central methodology is to treat the database as code.

Database objects are maintained in the SQL Server Database Project rather than being treated as undocumented state that exists only inside a running database.

The authoritative relationship is:

```text
Source-controlled SQL
        |
        v
Database Project
        |
        v
Build
        |
        v
DACPAC
        |
        v
Database
```

The live database is therefore a deployment target, not the primary source of implementation truth.

This distinction is fundamental to reproducibility.

---

## 4. Source-Controlled Development

Every meaningful database implementation change should be represented in the repository.

Examples include:

- new schemas;
- tables;
- constraints;
- stored procedures;
- functions;
- views;
- database roles;
- database-level permissions;
- post-deployment database scripts;
- documentation.

A change made manually against a database without corresponding source changes creates configuration drift.

The preferred rule is:

> If a database implementation change matters, it belongs in source control.

---

## 5. Design Before Implementation

Database changes should begin with an understanding of the architectural responsibility of the object being changed.

Before creating or modifying an object, determine:

1. Which schema owns it?
2. Which layer does it belong to?
3. Who consumes it?
4. What permissions should apply?
5. Does it belong in the DACPAC?
6. Does it require environment-specific configuration?
7. How will it be tested?

This prevents implementation decisions from being made solely because they are convenient in the immediate development environment.

---

## 6. Schema-First Organization

Schemas are used as architectural boundaries.

The established platform separates responsibilities across schemas such as:

```text
crm
customersuccess
finance
sales
reporting
dataquality
staging
warehouse
pipeline
security
```

The methodology therefore asks:

> What responsibility does this object have?

before asking:

> What SQL should I write?

This encourages coherent ownership and makes permissions easier to reason about.

---

## 7. Small, Understandable Changes

Database changes should be developed in focused increments.

A useful change should have a clear purpose.

Examples:

```text
Add a table
Add a procedure
Change a permission
Add a security predicate
Add a test
Update documentation
```

Large unrelated changes make build failures, deployment failures and Git history harder to diagnose.

Focused changes make it easier to determine:

```text
What changed?
Why did it change?
What broke?
What needs to be tested?
```

---

## 8. Build Before Publish

The database project should be built before publishing changes to a database.

The preferred loop is:

```text
Edit
  |
  v
Build
  |
  +---- Failure ----> Fix
  |
  v
Publish
  |
  v
Validate
```

Build errors should be resolved before deployment is treated as meaningful validation.

This creates an important distinction between:

- source compilation/build correctness;
- database deployment correctness;
- runtime behavior.

All three matter.

---

## 9. LocalDB Development Loop

LocalDB is the rapid development feedback environment.

The methodology uses it for:

- database project publishing;
- object creation and modification;
- build validation;
- schema validation;
- routine development;
- rapid feedback.

The development loop is therefore:

```text
Developer Change
      |
      v
Build
      |
      v
Publish to LocalDB
      |
      v
Inspect / Validate
      |
      v
Continue
```

LocalDB is not required to provide every SQL Server capability.

Its value is speed and developer feedback.

---

## 10. Docker Integration Loop

Docker SQL Server provides the broader SQL Server environment required for integration and security validation.

The methodology uses Docker for capabilities such as:

- server-level login validation;
- database-user validation;
- role membership;
- environment security provisioning;
- security testing;
- integration behavior.

The relationship is:

```text
LocalDB
    =
Rapid development feedback

Docker SQL Server
    =
Broader integration and security validation
```

The project deliberately avoids forcing one environment to perform every role.

---

## 11. DACPAC as the Deployment Artifact

The database project produces a DACPAC.

The DACPAC represents the deployable database implementation.

The methodology therefore separates:

```text
Implementation
      |
      v
DACPAC
      |
      v
Deployment
```

from:

```text
Environment State
      |
      v
Provisioning
```

This separation is critical to deployment repeatability.

---

## 12. Database Deployment vs Environment Provisioning

The platform does not treat database deployment and environment provisioning as one operation.

The conceptual sequence is:

```text
Database Project
       |
       v
Build
       |
       v
DACPAC
       |
       v
Database Deployment
       |
       v
Environment Provisioning
       |
       v
Validation
```

The database deployment establishes the database artifact.

Environment provisioning establishes state required by the target environment.

This prevents environment-specific configuration from being unnecessarily embedded into the database artifact.

---

## 13. Security Engineering Methodology

Security is developed as an explicit engineering concern.

The methodology follows:

```text
Design security model
        |
        v
Define logins/users/roles
        |
        v
Define permissions
        |
        v
Provision environment
        |
        v
Test behavior
```

The security model uses:

```text
Login
  |
  v
User
  |
  v
Role
  |
  v
Permission
```

The project favors role-based permission assignment over indiscriminate direct grants.

---

## 14. Provisioning Is Not Testing

A crucial methodology rule is that security provisioning and security testing have different purposes.

### Provisioning

`deployment/Provision-Security.sql` establishes the intended security state.

It may perform operations such as:

```text
CREATE / ALTER LOGIN
CREATE / ALTER USER
ALTER ROLE ... ADD MEMBER
GRANT ...
```

### Testing

`tests/security/*.sql` verifies the resulting behavior.

Tests may verify:

- expected access;
- expected denial;
- role membership;
- schema permissions;
- object permissions;
- execution permissions;
- row-level security;
- data-access boundaries.

The methodology is:

```text
Provision
    |
    v
State
    |
    v
Test
    |
    v
Evidence
```

Running a provisioning script successfully is not evidence that the security design is correct.

---

## 15. Test the Behavior, Not the Script

A successful SQL statement proves only that SQL Server accepted the statement.

It does not necessarily prove that the intended system behavior exists.

For example:

```text
ALTER ROLE role_sales ADD MEMBER SalesAMERUser;
```

proves that role membership was established.

A security test must additionally establish whether:

```text
SalesAMERUser
    |
    +--> receives intended access
    |
    +--> cannot access unintended data
```

The methodology therefore distinguishes configuration validation from behavioral validation.

---

## 16. Layered Validation

Validation occurs at multiple levels.

### Level 1 — Build validation

Does the database project compile successfully?

### Level 2 — Deployment validation

Can the resulting DACPAC be published successfully?

### Level 3 — Object validation

Do the expected schemas, tables, procedures, functions and other objects exist?

### Level 4 — Data / processing validation

Do ETL and pipeline operations behave correctly?

### Level 5 — Security validation

Do users and roles receive the intended access?

### Level 6 — Integration validation

Does the broader SQL Server environment behave as expected?

The methodology is therefore:

```text
Build
  ↓
Deploy
  ↓
Inspect
  ↓
Execute
  ↓
Test
```

---

## 17. Failure-Driven Development

Failures are treated as diagnostic information rather than as reasons to bypass the engineering process.

When a step fails, the methodology is:

```text
Failure
  |
  v
Identify layer
  |
  v
Determine root cause
  |
  v
Correct source / configuration
  |
  v
Rebuild
  |
  v
Republish
  |
  v
Retest
```

The first question should be:

> At which architectural boundary did the failure occur?

Possible boundaries include:

```text
Source
Database Project
Build
DACPAC
Database Deployment
Environment Provisioning
Security
Runtime
Test
```

This prevents random trial-and-error changes against live database state.

---

## 18. Drift Prevention

Database drift occurs when the deployed database differs from the source-controlled implementation.

The methodology reduces drift by maintaining:

```text
Repository
    |
    v
Database Project
    |
    v
DACPAC
    |
    v
Environment
```

Manual changes should therefore be minimized and, where necessary, reconciled back into the authoritative source.

The goal is:

> The repository should explain the database.

If the database contains important behavior that the repository does not represent, the platform has lost reproducibility.

---

## 19. Documentation as Engineering

Documentation is treated as part of implementation quality.

A significant architectural or operational decision should eventually be represented in the repository documentation.

Documentation should explain:

- what exists;
- why it exists;
- how it works;
- how it is changed;
- how it is deployed;
- how it is tested.

This is especially important for boundaries that are not obvious from SQL source alone.

For example:

```text
Provision-Security.sql
```

is easier to understand when the documentation explicitly explains why it exists outside the DACPAC.

---

## 20. Git Methodology

Git is used to preserve the history of meaningful engineering changes.

A commit should represent a coherent unit of work.

Good commit boundaries answer:

```text
What did this commit accomplish?
```

rather than:

```text
What happened to be changed in my working directory?
```

The project also uses sprint-level organization to provide broader historical context.

The relationship is:

```text
Individual Change
      |
      v
Git Commit
      |
      v
Sprint
      |
      v
Project History
```

This allows both detailed and high-level historical reconstruction.

---

## 21. Sprint-Based Engineering

The project uses sprints as meaningful development milestones.

A sprint represents a coherent engineering objective rather than merely a calendar period.

Examples include:

```text
Database foundation
Schema architecture
Staging
Warehouse
ETL / pipeline
DACPAC deployment
Environment architecture
Security
Documentation
```

Later sprints may contain multiple related implementation and documentation changes.

The sprint history provides context for why the platform looks the way it does today.

---

## 22. Promotion Discipline

Development and promotion are separate activities.

The methodology is:

```text
Develop
   |
   v
Build
   |
   v
Validate
   |
   v
Commit
   |
   v
Create Artifact
   |
   v
Deploy
   |
   v
Validate
   |
   v
Promote
```

The next environment should not become a place where unresolved development problems are discovered for the first time whenever those problems could have been detected earlier.

Each environment should increase confidence.

---

## 23. Change Classification

Before implementing a change, classify it.

### Database implementation change

Examples:

```text
Table
Procedure
Function
Schema
View
Database role
Database object permission
```

These normally belong in the database project.

### Environment configuration change

Examples:

```text
Server login
Environment-specific provisioning
Server-level configuration
```

These may belong outside the DACPAC.

### Validation change

Examples:

```text
Security test
Integration test
Permission test
Regression test
```

These belong in the testing structure.

### Documentation change

Examples:

```text
Architecture documentation
Workflow documentation
Sprint history
Design rationale
```

These belong in the documentation structure.

Classification prevents different concerns from becoming mixed together.

---

## 24. Repository Separation

The engineering methodology is reflected in repository organization.

Conceptually:

```text
Database Project
    |
    +-- Database implementation

deployment/
    |
    +-- Environment provisioning

tests/
    |
    +-- Behavioral validation

docs/
    |
    +-- Engineering knowledge
```

The repository therefore communicates architectural responsibility through its folder structure.

---

## 25. Reproducibility Standard

A process should be considered mature when another engineer can reproduce it without relying on undocumented personal knowledge.

The desired outcome is:

```text
Clone repository
       |
       v
Understand architecture
       |
       v
Build project
       |
       v
Deploy artifact
       |
       v
Provision environment
       |
       v
Run validation
       |
       v
Understand results
```

This standard drives both engineering discipline and documentation.

---

## 26. Maintainability Standard

Maintainability means that future changes can be made without reconstructing the project's historical reasoning from scratch.

A maintainable change should leave behind:

- source code;
- appropriate tests;
- appropriate documentation;
- a meaningful Git history;
- clear architectural ownership.

The project therefore treats maintainability as a design requirement rather than an optional cleanup activity.

---

## 27. What the Methodology Deliberately Avoids

The methodology avoids:

- using the live database as the primary source of truth;
- making large unrelated database changes;
- publishing before resolving build errors;
- treating successful SQL execution as sufficient validation;
- putting all environment configuration into the DACPAC;
- creating separate security implementations merely because environments differ;
- mixing provisioning scripts with security tests;
- relying on undocumented manual fixes;
- using Git only as a backup mechanism;
- allowing documentation to become detached from architecture.

---

## 28. End-to-End Engineering Method

The complete methodology can be summarized as:

```text
1. Understand the requirement
          |
          v
2. Identify the architectural boundary
          |
          v
3. Design the change
          |
          v
4. Implement in source control
          |
          v
5. Build the database project
          |
          v
6. Publish to the appropriate development environment
          |
          v
7. Validate database behavior
          |
          v
8. Deploy to broader integration environment when required
          |
          v
9. Provision environment-specific state
          |
          v
10. Execute appropriate tests
          |
          v
11. Commit the coherent change
          |
          v
12. Promote the approved artifact
          |
          v
13. Document significant architectural knowledge
```

---

## 29. Engineering Definition of Done

A database change should not be considered complete merely because the developer can demonstrate it working locally.

The appropriate definition of done includes:

- implementation exists in the database project where applicable;
- the project builds successfully;
- the change publishes successfully;
- the relevant environment has been validated;
- required security provisioning has been applied separately;
- relevant tests have passed;
- source control contains the intended change;
- documentation has been updated where the change affects architecture or operating procedure.

The exact validation depth depends on the nature of the change.

---

## 30. Methodology Outcome

The engineering methodology produces a platform in which:

```text
Design
  |
  v
Source
  |
  v
Build
  |
  v
Artifact
  |
  v
Deploy
  |
  v
Provision
  |
  v
Test
  |
  v
Commit
  |
  v
Promote
```

is a controlled engineering process rather than a sequence of disconnected manual actions.

The enduring objective is **repeatability, traceability and confidence**.

A future engineer should be able to understand not only how to make a database change, but also why the change belongs where it does, how it should be validated, how it should be committed, and how it should progress toward deployment.
