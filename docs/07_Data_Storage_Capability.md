# 07 — Data Storage Capability

## 1. Purpose

This document describes the data-storage capability currently implemented in the Enterprise SQL Platform.

The storage design separates data according to its purpose:

```text
Source Data
    |
    v
Staging Storage
    |
    v
Warehouse Storage
```

The design provides a clear boundary between data being loaded and data being prepared for downstream consumption.

---

## 2. Storage Architecture

The platform uses separate database schemas to organize stored data.

```text
staging
   |
   | Load / Process
   v
warehouse
```

### Staging

`staging` provides the controlled landing area for incoming and intermediate data.

### Warehouse

`warehouse` provides the downstream storage layer for processed data.

This separation keeps ingestion concerns distinct from warehouse consumption and processing.

---

## 3. Implemented Staging Storage

The current staging layer contains:

```text
staging.Calendar
staging.Customer
staging.Geography
staging.Product
staging.Sales
staging.Salesperson
staging.SalesTerritory
```

These tables form the relational storage foundation for the implemented dataset.

Primary keys and other defined constraints provide structural integrity.

---

## 4. Warehouse Storage

The `warehouse` schema provides the destination for processed data.

Warehouse loading is exposed through the established pipeline procedures:

```text
pipeline.sp_Load_Warehouse
pipeline.sp_Load_Warehouse_Docker
```

The storage architecture therefore follows:

```text
Source
  |
  v
Staging
  |
  v
Warehouse
```

The warehouse is intentionally separated from the staging layer rather than using staging tables as the final analytical storage location.

---

## 5. Relational Integrity

The storage model uses SQL Server relational structures and constraints.

Where defined, primary keys provide:

- entity uniqueness;
- referential structure;
- protection against duplicate key values.

Storage integrity is therefore enforced by the database rather than relying solely on application or pipeline logic.

---

## 6. Storage and Security

Storage access is controlled through the platform's database security model.

Relevant roles include:

```text
role_etl
role_developer
role_reporting
role_dataquality
```

Access is granted according to responsibility rather than giving every user unrestricted access to every storage layer.

The key principle is:

```text
User
  |
  v
Role
  |
  v
Storage Permission
```

Security provisioning remains outside the DACPAC deployment and is applied through the established security provisioning process.

---

## 7. LocalDB and Docker Storage

The storage implementation is developed and validated across two environments.

### LocalDB

Used for:

- database project development;
- rapid publishing;
- structural validation;
- fast iteration.

### Docker SQL Server

Used for:

- integration validation;
- ETL testing;
- security testing;
- broader SQL Server behaviour validation.

The database project provides the source-controlled definition of the storage model across these environments.

---

## 8. Storage and Deployment

Storage structures are delivered through the Database Project and DACPAC deployment process.

The normal flow is:

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
Target Database
      |
      v
Storage Validation
```

This keeps storage structures source-controlled and repeatable.

---

## 9. Storage Validation

After deployment, storage should be validated by confirming:

- expected schemas exist;
- expected tables exist;
- expected constraints exist;
- expected procedures are available;
- data can be loaded successfully;
- expected records are present;
- downstream processing can access the required storage.

Structural metadata and functional tests are used together.

---

## 10. Failure Handling

Storage problems should be diagnosed by layer.

```text
Source
  |
  v
Staging
  |
  v
Warehouse
```

Typical issues include:

- constraint violations;
- missing tables;
- incorrect schema placement;
- failed loads;
- permission failures;
- unexpected data state.

The preferred response is to correct the source-controlled implementation and redeploy rather than manually modifying the target database.

---

## 11. Current Capability

The platform currently provides:

- dedicated staging storage;
- warehouse storage;
- relational tables;
- primary-key constraints where required;
- controlled schema separation;
- ETL and role-based access;
- LocalDB development;
- Docker validation;
- source-controlled deployment through the Database Project;
- repeatable storage validation.

This represents the implemented storage capability today.

---

## 12. Future Evolution

The current storage model provides a foundation for future capabilities such as:

- additional warehouse structures;
- indexing and performance optimization;
- partitioning where justified;
- storage monitoring;
- archival strategies;
- retention policies;
- automated storage-health checks.

These should be introduced when actual workload and business requirements justify them.

---

## 13. Definition of Done

A storage change is considered complete when:

1. The required structures are defined in source control.
2. The database project builds successfully.
3. The target database is deployed successfully.
4. Schemas, tables and constraints are validated.
5. Relevant data-loading procedures execute successfully.
6. Required security access is verified.
7. Relevant downstream processing is tested.
8. The change is committed to Git.

---

## 14. Capability Outcome

The Enterprise SQL Platform has a deliberately simple storage architecture:

```text
Source
  |
  v
Staging
  |
  v
Warehouse
```

Storage is separated by responsibility, protected by database controls, and delivered through the source-controlled deployment process.

The governing principle is:

> Store incoming data in a controlled staging layer, promote processed data into the warehouse, and keep the storage model simple, relational and source-controlled.
