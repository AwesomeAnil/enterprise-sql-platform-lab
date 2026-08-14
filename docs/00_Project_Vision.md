# 00 — Project Vision

## 1\. Purpose

The Enterprise SQL Platform project exists to establish a disciplined, repeatable approach to building, deploying, securing, testing and maintaining a SQL Server data platform as software.

The GreenPear Labs dataset provides the working business domain through which the platform is designed and validated. The long-term value of the project, however, is the engineering platform and development practices built around that dataset.

The project therefore treats database development as an engineering discipline rather than as a collection of manually maintained database objects.

\---

## 2\. Project Context

The platform brings together:

* relational database development;
* staging and warehouse architecture;
* ETL and pipeline processing;
* database-project source control;
* repeatable builds;
* DACPAC-based deployment;
* LocalDB development;
* Docker SQL Server integration;
* environment provisioning;
* security architecture;
* security testing;
* Git-based development;
* documented development and deployment workflows.

The objective is to make these concerns understandable, repeatable and maintainable by engineers who were not present during the original development.

\---

## 3\. Vision

The vision is to build an enterprise-quality SQL Server development platform in which:

1. database objects are developed as source-controlled software;
2. database changes can be built and deployed repeatably;
3. environments have clearly defined responsibilities;
4. database artifacts are separated from environment-specific state;
5. security is explicitly provisioned and independently tested;
6. Git provides the authoritative history of database development;
7. documentation explains both the architecture and the operating model.

The desired outcome is not merely a functioning database.

It is a platform that can be **understood, reproduced, validated, deployed and evolved**.

\---

## 4\. Core Objectives

### 4.1 Build the database as software

Database objects should be represented in the SQL Server Database Project and managed through the same disciplined engineering practices applied to other software assets.

The intended development cycle is:

```text
Change
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
Deploy
  |
  v
Test
```

### 4.2 Establish clear architectural boundaries

The platform separates concerns into meaningful layers:

```text
Source Data
    |
    v
Staging
    |
    v
Warehouse
    |
    v
Reporting / Consumption
```

Cross-cutting engineering concerns such as deployment, security and testing are kept explicit rather than hidden inside unrelated layers.

### 4.3 Make deployment repeatable

A database build should produce a deployable artifact that can move through environments without manually reconstructing database objects.

The core model is:

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
Environment Deployment
```

### 4.4 Separate artifact deployment from environment provisioning

A fundamental project principle is:

> The database artifact and the environment state are not the same thing.

Database objects that belong to the application/database artifact are maintained in the database project.

Environment-specific state that should not be embedded in the DACPAC is handled separately.

This distinction is particularly important for security provisioning.

\---

## 5\. Engineering Principles

### Principle 1 — Source control is authoritative

The database project is the source-controlled representation of database implementation.

Manual database changes must not become an undocumented alternative source of truth.

### Principle 2 — Prefer repeatability over convenience

A process that works once manually is not sufficient as the engineering baseline.

The preferred solution is one that can be repeated consistently.

### Principle 3 — Separate concerns explicitly

Database objects, deployment, environment provisioning and testing have different responsibilities and should remain distinguishable.

### Principle 4 — Validate where the capability exists

Not every capability needs to be tested in every environment.

LocalDB is valuable for rapid database development and build validation.

Docker SQL Server provides the broader environment used for integration and security validation.

### Principle 5 — Security must be proven

Creating logins, users, roles and permissions is configuration.

Testing that those permissions actually produce the intended access behavior is validation.

Both are required.

### Principle 6 — Documentation is part of the platform

Documentation is not an afterthought.

The repository should explain how the platform works, how it is developed, how it is deployed, how it is secured and how it is tested.

\---

## 6\. Target Platform

The platform is organized around the following conceptual architecture:

```text
                    Git Repository
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
             +------------+------------+
             |            |            |
             v            v            v
            DEV          TEST         PROD
             |            |            |
             v            v            v
       Provisioning   Provisioning  Provisioning
             |            |            |
             v            v            v
       Validation     Validation    Validation
```

The exact implementation of environment deployment may evolve, but the separation of responsibilities remains fundamental.

\---

## 7\. Data Platform Vision

The data architecture is based on controlled movement through distinct layers.

```text
Source
  |
  v
Staging
  |
  v
Transformation / ETL
  |
  v
Warehouse
  |
  v
Reporting
```

### Staging

Staging provides a controlled landing area for source-oriented data.

### Warehouse

The warehouse represents the controlled analytical state of the platform.

### Pipeline

Pipeline procedures provide repeatable database-side processing between the appropriate layers.

### Reporting and domain access

Reporting and business-domain schemas provide controlled consumption boundaries.

The architecture therefore supports both data movement and differentiated access.

\---

## 8\. Development Environment Vision

Two development environments have deliberately different purposes.

### LocalDB

LocalDB is optimized for rapid development feedback:

* database project publishing;
* database-object validation;
* build verification;
* routine development;
* fast iteration.

### Docker SQL Server

Docker SQL Server provides the broader SQL Server integration environment:

* DACPAC deployment;
* login and user validation;
* role and permission provisioning;
* security validation;
* integration testing;
* runtime behavior requiring the broader SQL Server environment.

The project does **not** attempt to force every test into LocalDB.

The correct principle is:

> Use each environment for the capabilities it is intended to validate.

\---

## 9\. Security Vision

Security is treated as a first-class architectural concern.

The security model separates:

```text
Login
   |
   v
Database User
   |
   v
Database Role
   |
   v
Permission
```

The project uses role-based access rather than assigning large numbers of direct permissions to individual users.

Security provisioning is intentionally outside DACPAC deployment where environment state is involved.

The established model is:

```text
Database deployment
        |
        v
Provision-Security.sql
        |
        v
Security state
        |
        v
Security tests
```

This distinction is essential.

### Provisioning

`Provision-Security.sql` establishes the intended environment security state.

### Testing

The `tests/security/` scripts verify that the state behaves as designed.

A provisioning script is therefore **not** a security test.

A security test is not a provisioning script.

That boundary is a permanent architectural principle of the platform.

\---

## 10\. Deployment Vision

The deployment model is designed around promotion of a built database artifact rather than rebuilding the database independently for every environment.

The conceptual flow is:

```text
Developer Change
       |
       v
Git Commit
       |
       v
Build
       |
       v
DACPAC
       |
       v
DEV
       |
       v
TEST
       |
       v
PROD
```

Each environment provides an opportunity for validation.

Production is therefore the final deployment target of an approved artifact, not a separately developed database implementation.

\---

## 11\. Git and Development Vision

Git provides the authoritative history of database development.

Changes should be:

* focused;
* understandable;
* reviewable;
* attributable to a meaningful piece of work;
* associated with the appropriate sprint or development objective.

The project uses a sprint-based development model in which commits provide a meaningful historical record of how the platform evolved.

The repository should allow a future engineer to understand both:

```text
What exists now
```

and:

```text
How and why it evolved
```

without depending on private development-session knowledge.

\---

## 12\. Testing Vision

Testing is not limited to determining whether a database builds.

The platform validates multiple dimensions:

```text
Build
  |
  +--> Database object validity

Deployment
  |
  +--> Artifact can be published

Data / ETL
  |
  +--> Processing behaves correctly

Security
  |
  +--> Intended access is granted
  +--> Unintended access is denied

Integration
  |
  +--> Runtime environment behaves correctly
```

Security testing is particularly important because successful provisioning does not prove that the resulting security model is correct.

\---

## 13\. Documentation and Maintainability

The repository documentation is intended to become the durable operating manual for the platform.

The documentation set should answer, independently of the original development conversation:

* What is this project?
* How is the database architected?
* How is database development performed?
* How is the database built?
* How is it deployed?
* How are environments provisioned?
* How does security work?
* How is security tested?
* How does Git development work?
* How did the platform evolve?

This is why the documentation set begins with the project vision and architecture and progresses into development, deployment, security, testing and project history.

\---

## 14\. What This Project Is Not

This project is not intended to be:

* a collection of manually maintained production database objects;
* a database where the live environment is the only source of truth;
* a DACPAC containing every conceivable environment configuration;
* a security model validated solely by checking that scripts execute;
* a development process dependent on one engineer's memory;
* a collection of undocumented environment-specific fixes.

The project instead aims for explicit boundaries, repeatability and traceability.

\---

## 15\. Definition of Success

The platform is successful when a competent SQL Server engineer can enter the repository without prior knowledge of the development history and determine:

1. what the platform is intended to achieve;
2. how the database is structured;
3. how to develop database changes;
4. how to build the database project;
5. how to produce and deploy the DACPAC;
6. what LocalDB is used for;
7. what Docker SQL Server is used for;
8. how environment provisioning works;
9. how security is provisioned;
10. how security is tested;
11. how changes are committed and promoted;
12. how the project's development history is organized.

The strongest measure of success is therefore **reproducibility and understandability**, not merely whether the database currently works.

\---

## 16\. Long-Term Direction

The platform provides a foundation for progressively stronger DevOps practices.

Future evolution may include:

* automated database builds;
* automated deployment pipelines;
* automated security validation;
* environment-specific configuration management;
* pull-request validation;
* automated regression testing;
* deployment approvals;
* richer operational monitoring.

These are extensions of the established architecture rather than replacements for it.

The enduring design principle is:

```text
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
Promote
```

The Enterprise SQL Platform is therefore intended to be more than a database implementation.

It is a **repeatable engineering system for developing, deploying, securing and validating SQL Server data platforms**.

