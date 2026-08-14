# 09 — Platform Governance

## 1. Purpose

This document describes the governance principles currently established for the Enterprise SQL Platform.

Governance provides the rules that keep development, security, deployment and operational changes controlled and repeatable.

```text
Governance
    |
    +-- Development
    +-- Security
    +-- Deployment
    +-- Testing
    +-- Documentation
    +-- Change Control
```

---

## 2. Governance Principles

The platform follows a small set of core principles:

- source control is the authoritative record of database implementation;
- database changes are developed through the Database Project;
- changes are built and validated before promotion;
- security provisioning is kept outside DACPAC deployment;
- testing is performed before changes are considered complete;
- documentation is maintained alongside the platform;
- production changes should be deliberate and traceable.

The objective is control without unnecessary bureaucracy.

---

## 3. Source Control

Git is the source-control mechanism for the platform.

The repository contains the database implementation, deployment assets, tests and documentation.

The basic governance model is:

```text
Change
  |
  v
Git
  |
  v
Build / Test
  |
  v
Deployment
```

The database itself is not treated as the source of truth.

---

## 4. Database Change Governance

Database changes should be made in the source-controlled Database Project rather than directly against shared environments.

The expected process is:

```text
Modify Source
     |
     v
Build
     |
     v
Deploy
     |
     v
Test
     |
     v
Commit
```

Direct manual changes to deployed environments should be avoided because they create database drift.

---

## 5. Security Governance

Security follows a deliberate separation between database structure and environment-specific provisioning.

The DACPAC defines the database objects and security structure that belong in deployment.

Login and user provisioning, together with role membership where environment-specific, are handled separately through the security provisioning process.

The principle is:

```text
Database Project
      |
      +--> Database Structure
      +--> Roles / Permissions

Provision-Security.sql
      |
      +--> Environment Security
      +--> Role Membership
```

This prevents environment-specific principals from becoming tightly coupled to the DACPAC.

---

## 6. Testing Governance

Testing is part of the development process rather than an optional final activity.

The project includes dedicated test scripts covering areas such as:

- database structure;
- ingestion;
- security;
- role and permission behaviour;
- row-level security;
- pipeline functionality.

A change is not considered complete simply because the database project builds successfully.

```text
Build Success
     |
     v
Deployment
     |
     v
Functional / Security Tests
     |
     v
Approved Change
```

---

## 7. Deployment Governance

Deployment is controlled through the established database project and DACPAC process.

The deployment model separates:

```text
Schema / Object Deployment
            +
Security Provisioning
```

This allows the database implementation to remain portable while environment-specific security is provisioned explicitly.

Promotion should occur only after the relevant development and integration validation has passed.

---

## 8. Environment Governance

The platform currently uses development and integration-style environments for progressive validation, including:

```text
LocalDB
   |
   v
Docker SQL Server
   |
   v
Promoted Environment
```

LocalDB supports rapid development.

Docker provides broader SQL Server validation, including integration and security testing.

Production is treated as a controlled deployment target rather than a separate development workspace.

---

## 9. Documentation Governance

Documentation is maintained as part of the repository.

The documentation explains:

- platform architecture;
- engineering methodology;
- development workflow;
- security model;
- testing approach;
- sprint history;
- platform capabilities.

Documentation should describe the platform as it actually exists and clearly identify future-state capabilities.

---

## 10. Change Traceability

A platform change should be traceable from implementation through validation and Git history.

```text
Requirement
    |
    v
Source Change
    |
    v
Test
    |
    v
Commit
    |
    v
Deployment
```

Commit messages and sprint-based organization provide additional context for why changes were made.

---

## 11. Governance and Drift

Database drift occurs when the deployed database differs from the source-controlled implementation.

The preferred governance response is:

```text
Detect Drift
    |
    v
Identify Cause
    |
    v
Correct Source
    |
    v
Rebuild / Redeploy
    |
    v
Retest
```

Manual fixes should not become the permanent solution.

---

## 12. Current Governance Capability

The platform currently provides:

- Git-based source control;
- a source-controlled Database Project;
- repeatable database builds;
- DACPAC deployment;
- separate security provisioning;
- structured testing;
- documented development workflows;
- sprint-based change history;
- environment-aware validation;
- traceable database changes.

This represents the governance capability implemented today.

---

## 13. Future Evolution

As the platform matures, governance may evolve to include:

- automated CI/CD quality gates;
- formal change approvals;
- automated drift detection;
- deployment audit reporting;
- policy-as-code;
- expanded compliance controls;
- automated documentation validation.

These are future enhancements rather than current capabilities.

---

## 14. Definition of Done

A governed database change is considered complete when:

1. The implementation exists in source control.
2. The database project builds successfully.
3. Relevant tests pass.
4. Required security provisioning is validated.
5. The change is documented where appropriate.
6. The change is committed to Git.
7. The deployment path is repeatable and traceable.

---

## 15. Governance Outcome

The platform uses lightweight governance built around a simple principle:

```text
Source Control
      +
Testing
      +
Security Separation
      +
Repeatable Deployment
      +
Documentation
```

The objective is not bureaucracy.

It is to ensure that database changes are **controlled, testable, traceable and reproducible**.

The governing principle is:

> Every meaningful platform change should have a known source, a validated outcome and a traceable path to deployment.
