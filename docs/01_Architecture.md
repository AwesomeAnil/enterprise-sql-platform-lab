# 01 — Architecture

## 1. Purpose

This document describes the technical architecture of the Enterprise SQL Platform.

It explains how the database, data layers, development environments, deployment artifacts, environment provisioning and security model fit together.

The document is intentionally architectural rather than procedural.

For step-by-step development, deployment, Git and security-testing instructions, refer to the corresponding workflow and testing documents in this documentation set.

---

## 2. Architectural Overview

The Enterprise SQL Platform is a source-controlled SQL Server data platform built around a SQL Server Database Project and a repeatable build-and-deploy model.

At a high level:

```text
                         Git Repository
                              |
                              v
                    SQL Server Database Project
                              |
                              v
                            Build
                              |
                              v
                           DACPAC
                              |
                +-------------+-------------+
                |             |             |
                v             v             v
             LocalDB         TEST          PROD
             Development    Integration   Promotion
                |             |             |
                +-------------+-------------+
                              |
                              v
                    Environment Provisioning
                              |
                              v
                    Security / Environment State
                              |
                              v
                       Validation / Tests
```

The architecture deliberately separates:

1. database implementation;
2. deployment artifacts;
3. environment state;
4. security provisioning;
5. validation.

This separation is one of the central architectural characteristics of the platform.

---

## 3. Logical Data Architecture

The database is organized into functional schemas and data-processing layers.

The principal data flow is:

```text
Source Data
    |
    v
Staging
    |
    v
ETL / Transformation
    |
    v
Warehouse
    |
    v
Reporting / Consumption
```

The architecture also contains business-domain schemas and a dedicated security schema.

### 3.1 Business-domain schemas

The platform includes:

```text
crm
customersuccess
finance
sales
reporting
dataquality
```

These schemas provide logical ownership and access boundaries around business functionality.

### 3.2 Processing schemas

The processing layers are:

```text
staging
warehouse
pipeline
```

`staging` represents source-oriented landing and processing structures.

`warehouse` represents the controlled analytical state.

`pipeline` contains database-side procedures responsible for orchestrating or executing processing.

### 3.3 Security schema

The `security` schema contains security-related database objects required by the platform.

Security is treated as a cross-cutting concern rather than as another business-data layer.

---

## 4. Data Flow Architecture

The GreenPear Labs dataset is used as the working data domain through which the platform is developed and validated.

The intended data movement is:

```text
                 Source Dataset
                       |
                       v
                  +---------+
                  | Staging |
                  +---------+
                       |
                       v
                 ETL / Pipeline
                       |
                       v
                  +---------+
                  |Warehouse|
                  +---------+
                       |
                       v
                 +-----------+
                 | Reporting |
                 +-----------+
```

### Staging

The staging layer provides a controlled landing point for source-oriented data.

The established staging model includes entities such as:

```text
Calendar
Customer
Geography
Product
Sales
Salesperson
SalesTerritory
```

### Warehouse

The warehouse is the controlled analytical state of the platform.

It is intentionally separated from source-oriented staging so that ingestion and analytical consumption remain distinct concerns.

### Pipeline

The `pipeline` schema provides executable database-side processing.

The implementation includes procedures for loading staging and warehouse structures.

The architectural relationship is:

```text
Staging
   ^
   |
Pipeline / ETL
   |
   v
Warehouse
```

---

## 5. Database Schema Architecture

Schemas are architectural boundaries, not merely naming conventions.

The established schema model is:

| Schema | Architectural responsibility |
|---|---|
| `crm` | CRM business-domain data |
| `customersuccess` | Customer-success business-domain data |
| `finance` | Finance business-domain data |
| `sales` | Sales business-domain data |
| `reporting` | Reporting and consumption boundary |
| `dataquality` | Data-quality functionality |
| `staging` | Source-oriented landing and processing |
| `warehouse` | Analytical warehouse structures |
| `pipeline` | ETL and orchestration procedures |
| `security` | Security-related database objects |

This structure also provides the foundation for role-based authorization.

---

## 6. ETL and Pipeline Architecture

The platform uses database-side stored procedures to perform repeatable loading and processing.

The architecture contains both orchestration-level procedures and entity-specific staging procedures.

Examples include:

```text
pipeline.sp_Load_Staging
pipeline.sp_Load_Staging_Docker
pipeline.sp_Load_Warehouse
pipeline.sp_Load_Warehouse_Docker
```

The staging layer contains entity-oriented procedures such as:

```text
staging.sp_Load_Staging_Calendar
staging.sp_Load_Staging_Customer
staging.sp_Load_Staging_Geography
staging.sp_Load_Staging_Product
staging.sp_Load_Staging_Sales
staging.sp_Load_Staging_Salesperson
staging.sp_Load_Staging_SalesTerritory
```

Incremental processing is also represented where required, for example:

```text
staging.sp_Load_Staging_Customer_Incremental
```

The pipeline architecture therefore separates:

```text
What is being loaded?
        |
        v
Entity-specific staging procedures

How is processing orchestrated?
        |
        v
Pipeline procedures
```

---

## 7. Database Project Architecture

The SQL Server Database Project is the authoritative source-controlled representation of database implementation.

The project contains database objects that are intended to be represented in the DACPAC.

The build relationship is:

```text
SQL Source
    |
    v
Database Project
    |
    v
Build Validation
    |
    v
DACPAC
```

The DACPAC represents the database artifact that can be deployed to an environment.

This provides a repeatable mechanism for moving database implementation between environments.

---

## 8. DACPAC Boundary

The DACPAC boundary is a critical architectural boundary.

### Belongs in the database project

Database implementation such as:

- schemas;
- tables;
- views;
- stored procedures;
- functions;
- database roles;
- database-level objects;
- appropriate post-deployment database operations.

### Does not automatically belong in the DACPAC

Environment-specific state such as:

- server-level login configuration;
- environment-specific security provisioning;
- environment-specific operational configuration;
- validation scripts.

The principle is:

> A database object belongs to the database artifact when it is part of the database implementation. Environment state belongs outside the artifact when it is environment-specific or requires a broader server-level context.

---

## 9. Post-Deployment Architecture

The database project contains a Post-Deployment area.

Its purpose is to execute database-level deployment SQL that legitimately belongs to the database artifact.

The established structure uses a post-deployment entry point which can include subordinate SQL files.

Conceptually:

```text
Database Project
      |
      +-- Post-Deployment
              |
              +-- Script
                    |
                    +-- Security.sql
```

However, the existence of a Post-Deployment folder does not mean all security operations belong there.

The project deliberately moved environment-level security provisioning outside the DACPAC boundary.

This distinction prevents server/environment configuration from becoming entangled with database artifact deployment.

---

## 10. Environment Architecture

Two principal development environments have been established with different responsibilities.

```text
                    Database Project
                           |
                         DACPAC
                           |
              +------------+------------+
              |                         |
              v                         v
           LocalDB              Docker SQL Server
              |                         |
        Development               Integration
        / Build                    / Security
        Validation                 Validation
```

### 10.1 LocalDB

LocalDB is the rapid development environment.

It is used for:

- database project publishing;
- database-object validation;
- build verification;
- routine schema development;
- fast development feedback.

LocalDB is intentionally not treated as the universal environment for every SQL Server capability.

### 10.2 Docker SQL Server

Docker SQL Server provides the broader SQL Server environment used for:

- DACPAC deployment;
- login and user validation;
- role membership;
- security provisioning;
- security testing;
- integration validation;
- runtime behavior requiring the broader SQL Server environment.

The architectural principle is:

> Use the environment that provides the capability being validated.

---

## 11. Deployment Architecture

The deployment architecture separates artifact creation from environment provisioning.

```text
Developer Change
       |
       v
Git
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
Database Deployment
       |
       v
Environment Provisioning
       |
       v
Testing
```

This sequence means that deployment is not simply:

```text
Publish database
```

It is:

```text
Deploy database artifact
        +
Provision environment
        +
Validate resulting state
```

Those are related activities but distinct responsibilities.

---

## 12. Environment Provisioning Architecture

Environment provisioning is maintained outside the database project where it represents environment-level state.

The established repository boundary is:

```text
deployment/
    Provision-Security.sql
```

`Provision-Security.sql` is responsible for establishing the intended security state in the target environment.

It is not part of the DACPAC.

The architectural flow is:

```text
DACPAC Deployment
       |
       v
Provision-Security.sql
       |
       v
Environment Security State
```

This allows the same provisioning model to be applied against the appropriate SQL Server environment without creating separate `LocalDB-Security.sql` and `Docker-Security.sql` implementations.

---

## 13. Security Architecture

Security follows the SQL Server security hierarchy:

```text
Server Login
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

The project uses database roles to group permissions and users to receive membership in those roles.

The principal role model includes:

```text
role_crm
role_customersuccess
role_dataquality
role_developer
role_etl
role_finance
role_reporting
role_sales
```

Business users are therefore associated with functional roles rather than being given an arbitrary collection of direct permissions.

---

## 14. Security Provisioning vs Security Testing

This distinction is fundamental.

### Security provisioning

Provisioning establishes the desired security state.

```text
deployment/
    Provision-Security.sql
```

Its responsibility is to perform operations such as:

```text
CREATE / ALTER LOGIN
CREATE / ALTER USER
ALTER ROLE ... ADD MEMBER
GRANT ...
```

where those operations are appropriate to the environment.

### Security testing

Security tests prove that the provisioned state behaves correctly.

```text
tests/
    security/
        *.sql
```

The responsibilities must not be confused.

```text
Provision
    |
    v
Security State
    |
    v
Test
```

Provisioning answers:

> What security state should exist?

Testing answers:

> Does the resulting security state behave correctly?

This boundary is deliberately maintained outside the DACPAC.

---

## 15. Security Role Model

The established role model provides functional separation.

Conceptually:

```text
role_crm
    |
    +-- CRM users

role_customersuccess
    |
    +-- Customer Success users

role_dataquality
    |
    +-- Data Quality user

role_developer
    |
    +-- Developer user

role_etl
    |
    +-- ETL user

role_finance
    |
    +-- Finance user

role_reporting
    |
    +-- Reporting users

role_sales
    |
    +-- Sales users
```

The roles are then granted permissions appropriate to their responsibilities.

The project has validated role membership and permission behavior through dedicated security tests.

---

## 16. Row-Level Security Architecture

The platform also includes row-level security logic for sales territory access.

The established predicate function is:

```text
security.fn_SalesTerritoryPredicate
```

The predicate evaluates access using role membership, database identity and explicit territory mappings.

Conceptually:

```text
Requesting User
       |
       v
Sales Territory Predicate
       |
       +--> Developer / Finance?
       |        |
       |        +--> Allow
       |
       +--> dbo?
       |        |
       |        +--> Allow
       |
       +--> Explicit SalesRegionAccess mapping?
                |
                +--> Allow / Deny
```

The associated access mapping includes:

```text
SalesAMERUser  -> AMER
SalesAPACUser  -> APAC
SalesEMEAUser  -> EMEA
```

This architecture demonstrates that security testing extends beyond object permissions into data-level authorization.

---

## 17. Security Testing Architecture

Security tests are maintained separately from provisioning and database deployment.

The test suite validates areas such as:

- role membership;
- schema access;
- object access;
- ETL permissions;
- developer permissions;
- reporting permissions;
- sales territory restrictions;
- row-level security;
- expected denials;
- execution permissions.

The testing architecture is therefore:

```text
Provision
   |
   v
Security State
   |
   +--> Role Tests
   |
   +--> Permission Tests
   |
   +--> RLS Tests
   |
   +--> Access Denial Tests
   |
   v
Security Validation
```

A successful script execution alone is not considered sufficient evidence of correct security.

---

## 18. Git and Repository Architecture

Git provides the authoritative history of database development.

The repository separates implementation from deployment and testing concerns.

Conceptually:

```text
Repository
|
+-- Database Project
|      |
|      +-- Database objects
|      +-- Post-deployment database scripts
|
+-- deployment
|      |
|      +-- Provision-Security.sql
|
+-- tests
|      |
|      +-- security
|             |
|             +-- Security validation scripts
|
+-- docs
       |
       +-- Architecture
       +-- Development
       +-- Deployment
       +-- Security
       +-- Testing
       +-- Git
       +-- Sprint history
```

This organization makes architectural boundaries visible in the repository itself.

---

## 19. End-to-End Architecture

The complete platform can be represented as:

```text
                         GIT REPOSITORY
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
               +---------------+---------------+
               |                               |
               v                               v
            LOCALDB                     DOCKER SQL SERVER
         Development /                    Integration /
         Build Validation                 Security Validation
                                               |
                                               v
                                  Provision-Security.sql
                                               |
                                               v
                                      Security State
                                               |
                                               v
                                      Security Tests
                                               |
                                               v
                                          Validation
```

Within the database:

```text
                     ENTERPRISE SQL PLATFORM
                               |
          +--------------------+--------------------+
          |                    |                    |
          v                    v                    v
     BUSINESS DOMAINS       DATA PLATFORM       SECURITY
          |                    |                    |
          |              +-----+-----+              |
          |              |     |     |              |
          v              v     v     v              v
     CRM / Sales /    Staging ETL Warehouse     Roles
     Finance / CS /              |              Users
     Reporting /                 v              Logins
     DataQuality            Reporting          Permissions
```

---

## 20. Architectural Boundaries

The platform depends on several boundaries remaining clear.

### Boundary 1 — Source vs database implementation

Source data is loaded into the platform; it is not itself the database
implementation.

### Boundary 2 — Staging vs warehouse

Staging represents source-oriented data.

The warehouse represents controlled analytical state.

### Boundary 3 — Database artifact vs environment state

The DACPAC represents database implementation.

Environment provisioning establishes environment-specific state.

### Boundary 4 — Provisioning vs testing

Provisioning establishes the intended state.

Testing proves that the state behaves correctly.

### Boundary 5 — LocalDB vs Docker

LocalDB provides rapid development feedback.

Docker provides broader integration and security validation.

### Boundary 6 — Development vs promotion

Development produces the database artifact.

Promotion moves the approved artifact through environments.

These boundaries are architectural controls, not merely organizational preferences.

---

## 21. Architectural Principles

The platform is governed by the following principles:

1. **Database objects are software artifacts.**
2. **Git is the authoritative implementation history.**
3. **Schemas represent meaningful responsibility boundaries.**
4. **Staging and warehouse layers remain distinct.**
5. **Deployment artifacts are separated from environment state.**
6. **Security provisioning is outside the DACPAC boundary where environment state is involved.**
7. **Security provisioning and security testing are separate activities.**
8. **LocalDB is optimized for development and fast feedback.**
9. **Docker SQL Server provides broader integration and security validation.**
10. **The same coherent provisioning model is preferred over environment-specific security scripts.**
11. **Testing validates behavior, not merely script execution.**
12. **Documentation is part of the platform's maintainability strategy.**

---

## 22. Architecture Evolution

The architecture was not established as a single design exercise.

It evolved through the project's development sprints.

The progression was broadly:

```text
Database Foundation
        |
        v
Schema Architecture
        |
        v
Staging
        |
        v
Warehouse
        |
        v
ETL / Pipeline
        |
        v
Database Project / DACPAC
        |
        v
LocalDB + Docker
        |
        v
Deployment Boundaries
        |
        v
Security Architecture
        |
        v
Security Provisioning + Testing
        |
        v
Documented Engineering Baseline
```

This evolution is documented in `17_sprint_plan_and_project_history.md`.

---

## 23. Architectural Outcome

The resulting architecture provides a coherent separation between:

```text
What the database is
        |
        v
Database Project / DACPAC

Where it is deployed
        |
        v
Environment

What environment state it requires
        |
        v
Provisioning

Whether the resulting state is correct
        |
        v
Testing
```

That separation is the central architectural control of the Enterprise SQL Platform.

It allows the database implementation to remain portable and repeatable while allowing environment-specific state and security validation to be handled explicitly.

The platform is therefore designed not merely to contain data, but to provide a **repeatable engineering architecture for developing, deploying, securing and validating a SQL Server data platform**.
