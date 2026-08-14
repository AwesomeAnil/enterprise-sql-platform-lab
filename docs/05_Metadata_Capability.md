# 05 — Metadata Capability

## 1. Purpose

This document describes the metadata capability currently available in the Enterprise SQL Platform.

Metadata provides visibility into the database's structure and security state.

```text
Metadata = information about what exists in the database
```

---

## 2. Current Metadata Capability

The platform already has useful metadata capabilities through:

- the SQL Server system catalog;
- the Database Project;
- source-controlled database objects;
- database security metadata;
- validation queries.

This provides practical database visibility without requiring a separate metadata repository.

---

## 3. What We Can Inspect

The current capability allows engineers to inspect:

```text
Database
  |
  +-- Schemas
  +-- Tables
  +-- Stored Procedures
  +-- Functions
  +-- Constraints
  +-- Users
  +-- Roles
  +-- Role Membership
  +-- Permissions
```

This provides a practical view of what is actually deployed.

---

## 4. Schema and Object Metadata

The platform uses clearly defined schemas, including:

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

Metadata queries can confirm which schemas exist and which objects belong to them.

This is useful for:

- deployment validation;
- troubleshooting;
- understanding database structure.

---

## 5. Staging and Pipeline Metadata

The current staging implementation includes:

```text
staging.Calendar
staging.Customer
staging.Geography
staging.Product
staging.Sales
staging.Salesperson
staging.SalesTerritory
```

It also includes the staging and pipeline stored procedures used by the ingestion process.

Metadata inspection can confirm that these objects exist and are in the expected schemas.

---

## 6. Security Metadata

Security is an important part of the metadata capability.

The established database roles include:

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

Metadata can be used to inspect:

- database users;
- database roles;
- role membership;
- permissions.

The basic security model is:

```text
User
  |
  v
Role
  |
  v
Permission
```

---

## 7. Metadata and Security Testing

Metadata and security testing serve different purposes.

```text
Metadata
   |
   v
Does the configuration exist?

Security Test
   |
   v
Does the configuration behave correctly?
```

For example, metadata can confirm that a user belongs to `role_sales`.

The security tests then confirm that the user receives the expected access.

This distinction is important.

---

## 8. Row-Level Security Metadata

The platform includes the security predicate:

```text
security.fn_SalesTerritoryPredicate
```

The associated access mapping includes:

```text
SalesAMERUser     AMER
SalesAPACUser     APAC
SalesEMEAUser     EMEA
```

Metadata can confirm that the relevant security objects exist.

Actual row-level access behavior is validated through the security test suite.

---

## 9. Metadata and Deployment

Metadata provides a simple post-deployment validation mechanism.

After deploying the database, we can inspect:

```text
Schemas
Objects
Tables
Procedures
Functions
Security
```

The basic process is:

```text
Deploy
  |
  v
Inspect Metadata
  |
  v
Confirm Expected State
  |
  v
Run Relevant Tests
```

This provides evidence that the deployed database contains the expected implementation.

---

## 10. Metadata and Troubleshooting

Metadata is particularly useful when something does not work.

Before changing the database, we can first ask:

- Does the schema exist?
- Does the object exist?
- Is it in the correct schema?
- Is the expected user present?
- Is the expected role present?
- Is the role membership correct?

This makes metadata a practical troubleshooting tool.

---

## 11. Metadata and Source Control

Metadata does **not** replace Git or the Database Project.

The distinction is:

```text
Source Control
    =
What we intend to build

Runtime Metadata
    =
What currently exists
```

Comparing these views helps identify unexpected differences or database drift.

---

## 12. Current Capability Boundary

The platform currently has a **structural metadata capability**.

We should not describe it as having a separate enterprise metadata-management system because we have not built one.

The current implementation does not include:

- a metadata warehouse;
- an enterprise data catalog;
- automated lineage;
- a business glossary;
- a custom metadata repository.

These may be future capabilities, but they are not part of the current implementation.

---

## 13. Future Evolution

If the platform eventually requires richer metadata capabilities, these could include:

```text
Object Inventory
      |
      v
Dependency Mapping
      |
      v
Data Lineage
      |
      v
Data Dictionary
      |
      v
Metadata Governance
```

These should be introduced only when there is a genuine business or engineering requirement.

---

## 14. Definition of Done

The current metadata capability is considered adequate when:

1. Database structures can be inspected.
2. Expected schemas and objects can be verified.
3. Security principals and role relationships can be inspected.
4. Metadata can support deployment validation.
5. Metadata can support troubleshooting.
6. Runtime state can be compared with the intended source-controlled implementation.

---

## 15. Capability Outcome

The platform has a practical metadata capability built from:

```text
Database Project
      +
SQL Server System Catalog
      +
Security Metadata
      +
Validation Queries
```

It provides the visibility needed to inspect and validate the current database without adding unnecessary metadata infrastructure.

The governing principle is:

> Metadata should make the database easy to inspect, verify and understand — without becoming a substitute for source control, documentation or testing.
