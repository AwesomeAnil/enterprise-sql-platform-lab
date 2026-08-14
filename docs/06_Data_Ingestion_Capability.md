# 07 — Data Ingestion Capability

## 1. Purpose

This document describes the data-ingestion capability currently implemented in the Enterprise SQL Platform.

The ingestion design is intentionally simple:

```text
Source Data
    |
    v
Staging
    |
    v
Pipeline / ETL
    |
    v
Warehouse
```

The platform separates data landing and processing from downstream analytical consumption.

---

## 2. Ingestion Architecture

The ingestion capability is built around the `staging` and `pipeline` schemas.

```text
                 Source Data
                     |
                     v
              staging schema
                     |
                     v
             pipeline / ETL
                     |
                     v
              warehouse schema
```

### Staging

The staging layer provides the controlled landing area for source-oriented data.

### Pipeline

The pipeline layer provides higher-level processing entry points.

### Warehouse

The warehouse receives data after the appropriate staging and processing steps.

---

## 3. Implemented Staging Tables

The current staging implementation contains:

```text
staging.Calendar
staging.Customer
staging.Geography
staging.Product
staging.Sales
staging.Salesperson
staging.SalesTerritory
```

These tables establish the relational staging foundation for the implemented dataset.

Primary keys and other database constraints provide structural integrity where defined.

---

## 4. Implemented Ingestion Procedures

Entity-level staging procedures have been implemented for:

```text
Calendar
Customer
Geography
Product
Sales
Salesperson
SalesTerritory
```

The procedures follow the established naming pattern:

```text
staging.sp_Load_Staging_<Entity>
```

Docker-specific variants were also implemented where required:

```text
staging.sp_Load_Staging_<Entity>_Docker
```

This keeps the ingestion logic discoverable and separates normal development execution from Docker-oriented processing where necessary.

---

## 5. Incremental Ingestion

The platform includes an incremental customer-loading capability:

```text
staging.sp_Load_Staging_Customer_Incremental
```

This provides a foundation for processing changed customer data without treating every load as a complete rebuild.

The current implementation therefore supports both:

```text
Full / standard ingestion
```

and:

```text
Incremental customer ingestion
```

Incremental processing can be expanded to additional entities when a clear requirement exists.

---

## 6. Pipeline Orchestration

The `pipeline` schema provides higher-level ingestion entry points:

```text
pipeline.sp_Load_Staging
pipeline.sp_Load_Staging_Docker
pipeline.sp_Load_Warehouse
pipeline.sp_Load_Warehouse_Docker
```

The intended flow is:

```text
Load Staging
     |
     v
Validate / Process
     |
     v
Load Warehouse
```

This provides a clear separation between entity-level procedures and broader pipeline execution.

---

## 7. LocalDB and Docker

Two execution environments were established during development.

### LocalDB

Used primarily for:

- rapid development;
- database project publishing;
- object validation;
- fast iteration.

### Docker SQL Server

Used for:

- broader SQL Server validation;
- integration testing;
- security provisioning;
- ETL and pipeline testing.

The ingestion implementation is therefore developed quickly in LocalDB and validated more broadly in Docker.

---

## 8. ETL Security Boundary

ETL execution is represented by the database role:

```text
role_etl
```

The role is granted appropriate access to the staging and pipeline processing areas.

The operational principle is:

```text
ETL User
    |
    v
role_etl
    |
    +--> staging
    |
    +--> pipeline
```

This keeps ETL responsibilities separate from reporting, sales, finance and other functional access.

Security provisioning remains outside the DACPAC and is applied through:

```text
deployment/Provision-Security.sql
```

---

## 9. Data Integrity

Ingestion does not bypass relational database controls.

The staging layer includes primary-key constraints and other structural controls where required.

This provides a basic integrity boundary:

```text
Incoming Data
      |
      v
Staging Structure
      |
      v
Constraint Validation
      |
      v
Downstream Processing
```

Data-quality testing and business-specific validation remain separate concerns.

---

## 10. Ingestion Validation

After ingestion changes, validation should establish:

- expected staging tables exist;
- expected ingestion procedures exist;
- procedures execute successfully;
- expected records reach staging;
- constraints behave correctly;
- pipeline procedures remain executable;
- downstream warehouse processing remains intact where affected.

The validation principle is:

> Successful procedure execution is not, by itself, proof that ingestion is correct.

---

## 11. Failure Handling

Ingestion failures should be diagnosed by layer.

```text
Source / Input
      |
      v
Staging
      |
      v
Procedure
      |
      v
Pipeline
      |
      v
Warehouse
```

Typical failures include:

- invalid source data;
- constraint violations;
- procedure errors;
- permission failures;
- staging-state issues;
- downstream processing failures.

The preferred response is to identify and correct the source-controlled implementation, then rebuild, redeploy and retest rather than manually altering the target environment.

---

## 12. Current Capability

The platform currently provides:

- relational staging tables;
- entity-level staging procedures;
- Docker-specific ingestion procedures where required;
- pipeline-level staging and warehouse procedures;
- incremental customer ingestion;
- ETL-specific security;
- LocalDB development;
- Docker integration validation;
- structural database constraints;
- repeatable ingestion testing.

This is the implemented ingestion capability today.

---

## 13. Future Evolution

The current design provides a foundation for future capabilities such as:

- additional incremental-load procedures;
- richer data-quality controls;
- ingestion audit metadata;
- load logging;
- restartability;
- automated pipeline execution;
- CI/CD-integrated ingestion testing.

These are future extensions, not capabilities assumed to already exist.

---

## 14. Definition of Done

An ingestion change is considered complete when:

1. The required source-controlled objects are implemented.
2. The database project builds successfully.
3. The implementation is deployed to the target development/integration environment.
4. Relevant ingestion procedures execute successfully.
5. Expected staging results are verified.
6. Security requirements are satisfied.
7. Relevant downstream processing is validated.
8. The change is committed to Git.

---

## 15. Capability Outcome

The Enterprise SQL Platform has a clear and deliberately layered ingestion capability:

```text
Source
  |
  v
Staging
  |
  v
Pipeline
  |
  v
Warehouse
```

The implementation favors **simple, explicit, repeatable database ingestion** over unnecessary framework complexity.

The governing principle is:

> Land data in a controlled staging layer, process it through explicit database procedures, validate the result, and promote only proven ingestion logic.
