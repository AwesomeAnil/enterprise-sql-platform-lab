# 03 — Platform Foundations

## 1. Purpose

This document describes the foundational database and development capabilities on which the Enterprise SQL Platform is built.

Where `00_Project_Vision.md` explains why the platform exists, `01_Architecture.md` explains how the major components fit together, and `02_Engineering_Methodology.md` explains how the platform is engineered, this document explains the foundational building blocks that make the platform operational.

The foundations include:

- the SQL Server database platform;
- the database project;
- schemas;
- core database objects;
- staging structures;
- warehouse structures;
- pipeline procedures;
- development environments;
- deployment artifacts;
- foundational data and integrity controls.

These foundations were established progressively during Sprints 1–8 and subsequently hardened through deployment, security and documentation work.

---

## 2. Foundation Model

The platform rests on several interconnected foundations:

```text
                    Enterprise SQL Platform
                             |
        +--------------------+--------------------+
        |                    |                    |
        v                    v                    v
   Database Model       Development Model     Delivery Model
        |                    |                    |
        v                    v                    v
   Schemas / Objects     LocalDB / Docker     Database Project
        |                    |                    |
        v                    v                    v
   Data Layers          Validation            Build / DACPAC
        |                                         |
        +----------------------+------------------+
                               |
                               v
                         Deployable Platform
```

The database foundation provides the implementation.

The development foundation provides the environment in which implementation is created and validated.

The delivery foundation provides the mechanism by which that implementation becomes a deployable artifact.

---

## 3. SQL Server Foundation

The platform is implemented as a SQL Server relational database.

The database provides the foundational capabilities required by the project:

- schemas;
- tables;
- keys and constraints;
- stored procedures;
- functions;
- database roles;
- users;
- permissions;
- data-level security;
- transactional database behavior.

The project uses these capabilities as deliberate engineering primitives rather than treating the database as a flat collection of tables.

---

## 4. Database Project Foundation

The SQL Server Database Project is the primary implementation foundation.

It provides a source-controlled representation of the database schema and database-level objects.

The fundamental relationship is:

```text
Database Project
       |
       +--> Schemas
       +--> Tables
       +--> Constraints
       +--> Procedures
       +--> Functions
       +--> Roles
       +--> Other database objects
       |
       v
     Build
       |
       v
    DACPAC
```

This foundation makes the database buildable and deployable as a software artifact.

---

## 5. Schema Foundation

Schemas establish logical ownership and security boundaries.

The platform uses the following principal schemas:

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

The schema model prevents unrelated responsibilities from being collapsed into a single namespace.

It also provides a natural foundation for role-based authorization.

For example:

```text
reporting
    |
    v
role_reporting
    |
    v
Reporting users
```

and:

```text
staging
    |
    v
role_etl
    |
    v
ETL user
```

The schema is therefore both a structural and security foundation.

---

## 6. Business-Domain Foundation

The platform uses business-domain schemas to provide logical separation of business functionality.

### CRM

The `crm` schema represents CRM-related business data.

### Customer Success

The `customersuccess` schema represents customer-success information.

### Finance

The `finance` schema represents financial data.

### Sales

The `sales` schema represents sales-domain information.

### Reporting

The `reporting` schema provides a controlled reporting and consumption boundary.

### Data Quality

The `dataquality` schema provides a dedicated location for data-quality functionality.

This structure establishes domain boundaries before downstream reporting and consumption are considered.

---

## 7. Staging Foundation

The staging layer is one of the core data-platform foundations.

Its responsibility is to provide a controlled landing and processing area for source-oriented data.

The established staging model includes:

```text
staging.Calendar
staging.Customer
staging.Geography
staging.Product
staging.Sales
staging.Salesperson
staging.SalesTerritory
```

The staging layer therefore provides a consistent relational representation of the source-domain entities before they participate in downstream warehouse processing.

---

## 8. Staging Integrity

The staging layer is not merely a collection of imported records.

It includes database integrity structures such as primary keys.

The established implementation contains primary-key constraints for relevant staging entities, including:

```text
Geography
Salesperson
SalesTerritory
Sales
```

and other staging structures as defined by the database project.

These constraints provide a foundational level of structural data integrity.

The engineering principle is:

> Data-processing layers should still enforce appropriate relational integrity.

---

## 9. Warehouse Foundation

The warehouse layer provides the controlled analytical state of the platform.

The architectural distinction is:

```text
Staging
    |
    | source-oriented representation
    v
Pipeline / ETL
    |
    | controlled transformation / loading
    v
Warehouse
    |
    | analytical representation
    v
Reporting
```

The warehouse is therefore downstream of ingestion and processing rather than being used as the initial landing point for source data.

This separation establishes a stable foundation for analytical consumption.

---

## 10. Pipeline Foundation

The `pipeline` schema provides database-side orchestration and processing procedures.

The established platform includes:

```text
pipeline.sp_Load_Staging
pipeline.sp_Load_Staging_Docker
pipeline.sp_Load_Warehouse
pipeline.sp_Load_Warehouse_Docker
```

These procedures provide higher-level entry points for data-processing operations.

The distinction between pipeline and staging procedures is deliberate:

```text
Pipeline procedures
        |
        v
Orchestration / process entry points
        |
        v
Staging procedures
        |
        v
Entity-level processing
```

This provides a foundation for repeatable ETL execution.

---

## 11. Entity-Level Staging Procedures

The staging layer contains procedures associated with individual source entities.

The established implementation includes procedures for:

```text
Calendar
Customer
Geography
Product
Sales
Salesperson
SalesTerritory
```

For example:

```text
staging.sp_Load_Staging_Customer
staging.sp_Load_Staging_Product
staging.sp_Load_Staging_Sales
```

Docker-oriented variants are also present where the implementation requires them:

```text
staging.sp_Load_Staging_Customer_Docker
staging.sp_Load_Staging_Product_Docker
staging.sp_Load_Staging_Sales_Docker
```

This naming and organization makes the processing responsibility discoverable from the database object itself.

---

## 12. Incremental Processing Foundation

The platform also contains an incremental staging procedure:

```text
staging.sp_Load_Staging_Customer_Incremental
```

This establishes the foundation for processing patterns in which only the required changes are handled rather than always rebuilding an entire entity.

Incremental loading is important because it provides a path toward scalable data-processing patterns as source volumes increase.

The methodology is:

```text
Initial Load
    |
    v
Established Staging State
    |
    v
Incremental Changes
    |
    v
Controlled Update
```

The specific implementation and operational use of incremental processing should remain governed by the relevant ETL workflow documentation.

---

## 13. Core Relational Foundation

The database uses standard relational structures to establish integrity and predictable access.

The foundational object types include:

```text
Schemas
Tables
Primary Keys
Constraints
Stored Procedures
Functions
Database Roles
Users
```

These objects form the base on which higher-level capabilities such as ETL, security and reporting are built.

The dependency direction is generally:

```text
Schema
  |
  v
Tables / Objects
  |
  v
Procedures / Functions
  |
  v
Security / Consumption
```

---

## 14. Database Security Foundation

Security is built on the SQL Server hierarchy:

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

The platform established functional roles including:

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

These roles provide the foundation for controlled access.

The platform also established corresponding database users and tested their relationship to server logins.

---

## 15. Development Environment Foundation

The development model uses two important SQL Server environments.

```text
                Database Project
                       |
              +--------+--------+
              |                 |
              v                 v
           LocalDB            Docker
              |                 |
        Fast development    Integration /
        and validation      security validation
```

### LocalDB

LocalDB provides fast development feedback.

It is used for:

- project publishing;
- object validation;
- build verification;
- rapid development iteration.

### Docker SQL Server

Docker provides the broader SQL Server runtime required for:

- integration;
- server-level security;
- environment provisioning;
- security testing.

This separation is part of the platform foundation, not merely a developer preference.

---

## 16. Deployment Artifact Foundation

The build process produces a DACPAC.

The fundamental delivery chain is:

```text
Source-controlled database project
             |
             v
           Build
             |
             v
          DACPAC
             |
             v
      Database deployment
```

The DACPAC provides the repeatable database artifact required for deployment.

It establishes a stable boundary between:

```text
How the database is built
```

and:

```text
Where the database is deployed
```

---

## 17. Environment Provisioning Foundation

The deployment model also requires environment-specific state.

This is handled separately from the DACPAC where appropriate.

The established security provisioning script is:

```text
deployment/Provision-Security.sql
```

The architectural relationship is:

```text
DACPAC
   |
   v
Database implementation
   |
   +
   |
Provision-Security.sql
   |
   v
Environment security state
```

This separation is a foundational design decision.

It prevents environment-specific security state from becoming inseparable from the database artifact.

---

## 18. Testing Foundation

Testing is treated as an independent platform capability.

The repository contains dedicated security tests under:

```text
tests/security/
```

These tests validate behavior after provisioning.

The foundation is therefore:

```text
Implementation
      |
      v
Deployment
      |
      v
Provisioning
      |
      v
Testing
```

This provides evidence that the platform behaves as intended rather than merely proving that deployment scripts execute.

---

## 19. Data-Level Security Foundation

The platform includes row-level security for sales territory access.

The principal predicate function is:

```text
security.fn_SalesTerritoryPredicate
```

The associated access mapping includes:

```text
PrincipalName     SalesTerritory
---------------   --------------
SalesAMERUser     AMER
SalesAPACUser     APAC
SalesEMEAUser     EMEA
```

The predicate also provides elevated access for appropriate roles and database principals.

The resulting model establishes a foundation for:

```text
User
  |
  v
Territory Authorization
  |
  v
Permitted Rows
```

This demonstrates that the platform foundation includes both object-level authorization and data-level authorization.

---

## 20. Reporting Foundation

The `reporting` schema provides a controlled consumption boundary.

The established permission model grants:

```text
GRANT SELECT
ON SCHEMA::reporting
TO role_reporting;
```

This establishes the principle that reporting consumers should receive access through the reporting boundary rather than unrestricted access to underlying implementation structures.

The architecture is:

```text
Warehouse / Business Data
          |
          v
      Reporting
          |
          v
    Reporting Role
          |
          v
      Consumers
```

---

## 21. ETL Security Foundation

The ETL role provides controlled access to processing structures.

The established security model includes access to the staging and pipeline layers appropriate to ETL execution.

Conceptually:

```text
role_etl
   |
   +--> staging access
   |
   +--> staging execution
   |
   +--> pipeline execution
```

This provides a foundation for separating ETL responsibilities from ordinary reporting or business-domain access.

---

## 22. Developer Foundation

The developer role provides controlled development-oriented access.

The established model includes access to appropriate warehouse and pipeline capabilities.

Conceptually:

```text
role_developer
      |
      +--> warehouse data modification
      |
      +--> pipeline execution
```

The developer role is therefore distinct from ETL, reporting, sales and other functional roles.

This separation supports least-privilege design.

---

## 23. Build and Deployment Foundation

The platform's build foundation follows:

```text
Edit Source
    |
    v
Build Database Project
    |
    v
Resolve Build Errors
    |
    v
Publish / Deploy
    |
    v
Validate
```

The build is the first major quality gate.

The deployment is the second.

Runtime and security tests provide subsequent validation.

This layered approach means a failure can be located more precisely.

---

## 24. Foundational Quality Gates

The platform establishes several quality gates.

### Gate 1 — Source integrity

Is the intended implementation represented in source control?

### Gate 2 — Build integrity

Does the database project build successfully?

### Gate 3 — Deployment integrity

Can the resulting artifact be deployed?

### Gate 4 — Object integrity

Do expected database objects exist?

### Gate 5 — Processing integrity

Do ETL and pipeline operations behave correctly?

### Gate 6 — Security integrity

Do permissions and row-level security behave correctly?

The overall model is:

```text
Source
  |
  v
Build
  |
  v
Deploy
  |
  v
Process
  |
  v
Secure
  |
  v
Validate
```

---

## 25. Foundation for Reproducibility

The platform foundations support reproducibility by making the major components explicit.

A future engineer should be able to identify:

```text
Database implementation
       |
       +--> Database Project

Deployment artifact
       |
       +--> DACPAC

Environment provisioning
       |
       +--> deployment/

Validation
       |
       +--> tests/

Engineering knowledge
       |
       +--> docs/
```

This structure reduces dependence on undocumented local state.

---

## 26. Foundation for Future Automation

The current foundations also provide the prerequisites for future automation.

Because the project has:

- source-controlled SQL;
- a buildable database project;
- a DACPAC;
- deployment scripts;
- provisioning scripts;
- validation scripts;
- documented workflows;

the platform can progressively introduce automated CI/CD.

The future automation path is:

```text
Git Commit
    |
    v
Automated Build
    |
    v
DACPAC
    |
    v
Automated Deployment
    |
    v
Automated Provisioning
    |
    v
Automated Tests
    |
    v
Promotion
```

Automation is therefore an extension of the existing foundations rather than a prerequisite for them.

---

## 27. Foundation Principles

The platform foundations are governed by these principles:

1. **Database implementation belongs in source control.**
2. **Schemas establish responsibility boundaries.**
3. **Relational integrity is established at the database layer.**
4. **Staging and warehouse have distinct responsibilities.**
5. **Pipeline procedures provide repeatable processing entry points.**
6. **Incremental processing is supported where required.**
7. **Security is role-based and hierarchical.**
8. **Data-level security is treated as a first-class capability.**
9. **LocalDB provides rapid development feedback.**
10. **Docker provides broader integration and security validation.**
11. **The DACPAC represents the deployable database artifact.**
12. **Environment-specific provisioning remains separate where appropriate.**
13. **Testing provides behavioral evidence.**
14. **Documentation preserves the knowledge required to operate the platform.**

---

## 28. Relationship to the Earlier Sprints

The foundations were established progressively.

At a high level:

```text
Sprints 1–2
    |
    v
Database and schema foundation

Sprints 3–4
    |
    v
Staging and data structures

Sprints 5–6
    |
    v
Warehouse and processing foundation

Sprints 7–8
    |
    v
Deployment / environment / engineering hardening

Sprints 9–10
    |
    v
Security and validation hardening

Sprint 11
    |
    v
Documentation baseline
```

The detailed historical account is maintained in:

```text
17_Sprint_Plan_and_Project_History.md
```

This document focuses on the resulting foundations rather than repeating the full sprint history.

---

## 29. Architectural Dependency Chain

The platform foundations can be understood as a dependency chain:

```text
SQL Server
    |
    v
Database
    |
    v
Schemas
    |
    v
Tables / Constraints / Objects
    |
    v
Staging / Warehouse
    |
    v
Pipeline / ETL
    |
    v
Reporting
    |
    +-------------------+
    |                   |
    v                   v
Security            Deployment
    |                   |
    v                   v
Roles / Users       DACPAC
    |                   |
    +---------+---------+
              |
              v
          Validation
```

Each layer provides capabilities used by the layer above it.

---

## 30. Platform Foundation Outcome

The platform foundations establish a coherent base for the rest of the Enterprise SQL Platform.

They provide:

- a structured relational database;
- logical schema boundaries;
- source-oriented staging;
- analytical warehouse processing;
- repeatable ETL procedures;
- controlled reporting access;
- role-based security;
- row-level security;
- development environments;
- a buildable database project;
- a deployable DACPAC;
- separate environment provisioning;
- dedicated validation.

The result is a platform that can support progressively stronger deployment automation, security controls, testing and operational practices without requiring a redesign of its fundamental structure.

The foundational principle is:

> Build the database as an engineered platform, not as an unmanaged collection of database objects.

These foundations are what make the subsequent development, deployment, security and testing workflows possible.
