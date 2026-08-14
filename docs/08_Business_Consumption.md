# 08 — Business Consumption Capability

## 1. Purpose

This document describes how business-facing consumption is currently supported by the Enterprise SQL Platform.

The current capability is database-level consumption of curated data through controlled schemas and permissions.

```text
Source
  |
  v
Staging
  |
  v
Warehouse
  |
  v
Reporting
  |
  v
Business Consumers
```

---

## 2. Current Consumption Model

The platform separates business consumption from ingestion and processing.

The `warehouse` layer contains processed data, while the `reporting` schema provides a controlled access boundary for reporting-oriented users.

This keeps business consumption away from the underlying ingestion mechanisms.

---

## 3. Reporting Schema

The implemented reporting layer includes:

```text
reporting
```

The reporting role is:

```text
role_reporting
```

The current security model grants the reporting role `SELECT` access to the reporting schema.

```text
Business User
      |
      v
role_reporting
      |
      v
reporting schema
```

This provides read-oriented access without granting unnecessary write or processing privileges.

---

## 4. Business Consumption Principles

The current design follows four simple principles:

- business consumers should primarily read curated data;
- ingestion and ETL permissions should remain separate;
- business users should not require direct access to pipeline internals;
- access should be granted through roles rather than individual permissions wherever practical.

This keeps the consumption boundary simple and controlled.

---

## 5. Data Quality

Business consumption depends on the quality of the underlying warehouse data.

The platform therefore keeps data-quality responsibilities separate from reporting access.

The `dataquality` role provides a dedicated security boundary for data-quality activities, while `role_reporting` provides business-facing read access.

The principle is:

```text
Data Quality
     |
     v
Validate
     |
     v
Warehouse / Reporting
     |
     v
Business Consumption
```

---

## 6. Consumption Validation

Business consumption should be validated by confirming:

- the reporting schema exists;
- the expected reporting objects exist;
- `role_reporting` exists;
- the appropriate permissions are present;
- reporting users can read permitted data;
- reporting users cannot perform unauthorized modifications.

The security test suite provides behavioural validation of the access model.

---

## 7. Current Capability

The platform currently provides:

- a dedicated reporting schema;
- a dedicated reporting role;
- read-oriented reporting access;
- separation from ETL and pipeline permissions;
- database-level security;
- source-controlled reporting structures;
- repeatable deployment and validation.

This represents the current implemented business-consumption capability.

---

## 8. Future Business Consumption

The database reporting layer provides the foundation for richer business-consumption technologies that have **not yet been implemented**.

Future capabilities may include:

```text
Warehouse / Reporting
        |
        +--> Power BI Semantic Models
        |
        +--> Power BI Reports
        |
        +--> Power BI Dashboards
        |
        +--> APIs / Data Services
        |
        +--> Other Analytical Consumers
```

These future layers can build on the controlled reporting boundary without changing the underlying ingestion and storage architecture.

They should be introduced when actual business requirements justify them.

---

## 9. Definition of Done

A business-consumption change is considered complete when:

1. Required reporting structures are defined in source control.
2. The database project builds successfully.
3. Reporting objects deploy successfully.
4. Reporting permissions are correctly provisioned.
5. Authorized users can consume the expected data.
6. Unauthorized operations remain blocked.
7. Relevant downstream validation passes.
8. The change is committed to Git.

---

## 10. Capability Outcome

The current platform provides a simple and controlled business-consumption boundary:

```text
Warehouse
   |
   v
Reporting
   |
   v
role_reporting
   |
   v
Business Consumers
```

The database provides the **trusted consumption foundation** today.

Power BI semantic models, reports, dashboards, APIs and other analytical delivery mechanisms remain future-state capabilities.

The governing principle is:

> Business consumers should receive controlled access to curated data without becoming dependent on the internal ingestion and processing layers.
