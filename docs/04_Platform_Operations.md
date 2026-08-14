# 05 — Platform Operations

## 1. Purpose

This document defines the operational model for the Enterprise SQL Platform.

It explains how the platform is operated across its development, integration and production lifecycle once the database implementation has been built.

The purpose is to establish a predictable operational model for:

- environments;
- database deployment;
- environment provisioning;
- validation;
- security state;
- operational checks;
- failure handling;
- promotion;
- repeatability;
- maintenance.

This document describes the operating model rather than replacing the detailed procedures in the deployment, development, security and testing workflow documents.

---

## 2. Operational Model

The platform operates through a controlled sequence:

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
Validate
  |
  v
Promote
```

The operational model deliberately separates the concerns represented by each stage.

A database artifact is deployed.

Environment-specific state is provisioned.

The resulting environment is validated.

Only then is the implementation considered ready for promotion.

---

## 3. Environment Model

The platform uses distinct environments with distinct operational responsibilities.

```text
                    Database Project
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
           DEV           TEST          PROD
             |             |             |
             v             v             v
        Development    Integration    Promotion
```

The project has established LocalDB and Docker SQL Server as important development and integration environments.

Production is conceptually the final deployment target of the approved artifact.

---

## 4. LocalDB Operations

LocalDB is the rapid development environment.

Its operational purpose is to provide fast feedback while developing the database.

Typical operations include:

- build the database project;
- publish the project;
- inspect schemas and objects;
- execute development validation;
- correct implementation issues;
- repeat the development cycle.

The operational loop is:

```text
Change
  |
  v
Build
  |
  v
Publish to LocalDB
  |
  v
Inspect
  |
  v
Validate
```

LocalDB is therefore optimized for developer productivity rather than as the final integration environment.

---

## 5. Docker SQL Server Operations

Docker SQL Server provides the broader SQL Server environment used for integration and security validation.

Operational activities include:

- deploying the database artifact;
- provisioning security;
- validating logins and users;
- validating role membership;
- executing security tests;
- validating ETL and pipeline behavior;
- testing SQL Server capabilities that require the broader environment.

The operational distinction is:

```text
LocalDB
    |
    +--> Rapid development

Docker
    |
    +--> Integration
    +--> Security provisioning
    +--> Security testing
    +--> Broader SQL Server validation
```

---

## 6. Database Deployment Operations

Database deployment is based on the built database artifact.

The operational sequence is:

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
Deploy
      |
      v
Validate
```

The DACPAC is the deployment artifact.

The target environment should not be treated as the place where database implementation is manually reconstructed.

This ensures that deployment remains tied to the source-controlled implementation.

---

## 7. Deployment and Provisioning Boundary

The platform maintains a deliberate boundary between database deployment and environment provisioning.

```text
                 DACPAC
                   |
                   v
          Database Implementation
                   |
                   +
                   |
                   v
       Provision-Security.sql
                   |
                   v
          Environment State
```

The DACPAC establishes the database implementation.

`deployment/Provision-Security.sql` establishes the environment security state that is intentionally maintained outside the DACPAC.

This boundary is one of the most important operational controls in the platform.

---

## 8. Security Provisioning Operations

Security provisioning is an explicit operational activity.

The provisioning script establishes the required security state for the target environment.

The operational model includes:

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

Provisioning may include:

- login configuration;
- database-user configuration;
- role membership;
- database permissions;
- environment-specific security state.

The provisioning process should be executed against the intended target environment rather than accidentally against the developer's LocalDB instance.

---

## 9. Security State Verification

Provisioning should be followed by verification.

The verification model is:

```text
Provision
   |
   v
Inspect Security State
   |
   +--> Login exists
   |
   +--> User exists
   |
   +--> User maps correctly
   |
   +--> Role membership exists
   |
   +--> Permissions exist
   |
   v
Run Security Tests
```

Inspection establishes that the intended configuration exists.

Behavioral tests establish that the configuration actually produces the intended access behavior.

Both are valuable operational checks.

---

## 10. Security Testing Operations

Security tests are maintained separately under:

```text
tests/security/
```

Operationally, the tests should be executed against the environment whose security state is being validated.

The test model includes:

```text
Expected access
Expected denial
Role membership
Schema access
Object access
Procedure execution
Row-level security
```

The principle is:

> Do not infer correct security behavior from successful provisioning alone.

A provisioned environment is not considered security-validated until the appropriate tests pass.

---

## 11. Data Processing Operations

The platform's ETL and pipeline procedures provide repeatable processing operations.

The principal pipeline procedures include:

```text
pipeline.sp_Load_Staging
pipeline.sp_Load_Staging_Docker
pipeline.sp_Load_Warehouse
pipeline.sp_Load_Warehouse_Docker
```

The staging layer also provides entity-specific procedures for:

```text
Calendar
Customer
Geography
Product
Sales
Salesperson
SalesTerritory
```

Operationally, processing follows:

```text
Source
  |
  v
Staging
  |
  v
Pipeline / ETL
  |
  v
Warehouse
  |
  v
Reporting
```

The operational procedures should be executed according to the established ETL workflow and appropriate environment.

---

## 12. Incremental Processing Operations

The platform contains an incremental customer-loading procedure:

```text
staging.sp_Load_Staging_Customer_Incremental
```

Incremental processing provides an operational pattern for handling changes without necessarily rebuilding the complete entity.

Conceptually:

```text
Existing Staging State
        |
        +--> New / Changed Source Data
        |
        v
Incremental Procedure
        |
        v
Updated Staging State
```

The operational use of incremental loading should be controlled by the applicable ETL process and validated before promotion.

---

## 13. Operational Validation

Operational validation should be layered.

### Database state

Verify that expected objects exist.

### Processing state

Verify that ETL and pipeline operations complete as expected.

### Security state

Verify logins, users, roles and permissions.

### Data behavior

Verify expected data movement and access behavior.

### Deployment state

Verify that the intended artifact has been deployed.

The overall model is:

```text
Deployment
    |
    v
Object Check
    |
    v
Processing Check
    |
    v
Security Check
    |
    v
Behavior Check
```

---

## 14. Operational Health Checks

A practical post-deployment health check should establish that the environment is structurally and functionally usable.

A health-check sequence can be represented as:

```text
1. Confirm database is available
          |
          v
2. Confirm expected schemas exist
          |
          v
3. Confirm key tables and procedures exist
          |
          v
4. Confirm required security state exists
          |
          v
5. Execute relevant processing checks
          |
          v
6. Execute relevant security tests
          |
          v
7. Confirm expected business behavior
```

The exact tests depend on what was changed.

A documentation or non-functional change does not require the same validation depth as a change to ETL, warehouse logic or security.

---

## 15. Change Impact Assessment

Before operating a deployment, determine what the change affects.

A useful classification is:

```text
Schema / object change
        |
        +--> Object validation

ETL change
        |
        +--> Processing validation

Security change
        |
        +--> Security provisioning
        +--> Security testing

Deployment change
        |
        +--> Artifact / deployment validation

Documentation change
        |
        +--> Documentation review
```

This prevents unnecessary testing while ensuring that high-impact changes receive appropriate validation.

---

## 16. Operational Change Control

Changes should progress through the established engineering lifecycle.

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

Operationally, a target environment should not be used as a substitute for development.

If a defect is discovered, the preferred response is:

```text
Identify defect
      |
      v
Correct source
      |
      v
Rebuild
      |
      v
Redeploy
      |
      v
Retest
```

This preserves source-of-truth discipline.

---

## 17. Failure Handling

Operational failures should be classified before corrective action is taken.

### Build failure

The database project cannot produce a valid artifact.

Response:

```text
Inspect build error
      |
      v
Correct source
      |
      v
Rebuild
```

### Deployment failure

The DACPAC cannot be deployed successfully.

Response:

```text
Inspect deployment error
      |
      v
Determine artifact / target issue
      |
      v
Correct source or environment
      |
      v
Redeploy
```

### Provisioning failure

Environment security cannot be established.

Response:

```text
Inspect target environment
      |
      v
Confirm login / user / role state
      |
      v
Correct provisioning
      |
      v
Re-run
```

### Security-test failure

The provisioned security state does not behave as intended.

Response:

```text
Identify failing permission boundary
      |
      v
Determine source of defect
      |
      v
Correct role / permission / predicate
      |
      v
Rebuild / reprovision
      |
      v
Retest
```

### Data-processing failure

ETL or pipeline execution fails.

Response:

```text
Identify failing procedure
      |
      v
Inspect source / staging / warehouse state
      |
      v
Correct implementation
      |
      v
Rebuild / redeploy
      |
      v
Reprocess / retest
```

---

## 18. Avoiding Operational Drift

Operational drift occurs when the target environment is changed independently of the repository and those changes are not reconciled.

The preferred model is:

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
Target Environment
```

Manual emergency changes may occasionally be necessary in real operational circumstances, but they should not become the normal development method.

Important changes must ultimately be represented in the appropriate source-controlled artifact or provisioning mechanism.

---

## 19. Rollback and Recovery Philosophy

The operational model favors controlled redeployment and correction from source over ad-hoc manipulation of target databases.

When a deployment introduces a defect:

```text
Identify failure
      |
      v
Determine safe recovery action
      |
      +--> Correct forward
      |
      +--> Redeploy known-good artifact
      |
      +--> Restore environment state where required
```

The correct recovery method depends on the nature of the failure.

The key principle is:

> Recovery should restore a known, understood state rather than introduce additional undocumented changes.

Database backup and restore strategy, where applicable to a production operational implementation, should be defined as part of the production platform's broader operational controls.

---

## 20. Production Operations

Production represents the final controlled deployment target.

The production operating model is:

```text
Approved Database Artifact
          |
          v
Production Deployment
          |
          v
Environment Provisioning
          |
          v
Validation
          |
          v
Operational Use
```

Production should not be treated as a development environment.

The implementation promoted to production should be the approved artifact produced through the established engineering process.

Where the deployment mechanism is automated or represented by a controlled deployment pipeline, the operational principle remains the same:

> Production receives a promoted artifact; it is not independently developed.

---

## 21. Promotion Model

Promotion should increase confidence at each stage.

```text
Development
     |
     v
Build Validation
     |
     v
Integration Validation
     |
     v
Security Validation
     |
     v
Approval
     |
     v
Production
```

The exact automation of these stages may evolve.

The underlying operational model does not change.

Each stage should provide evidence that the artifact is suitable for the next stage.

---

## 22. Production Security Considerations

Production security provisioning should remain controlled and deliberate.

The same architectural distinction applies:

```text
Database Artifact
       |
       +--> Database implementation

Environment Provisioning
       |
       +--> Production security state

Security Tests
       |
       +--> Behavioral validation
```

Production security should not be assumed to be correct merely because development security tests passed.

The target environment must still be provisioned and validated appropriately.

---

## 23. Operational Documentation

Operational knowledge must be retained in the repository.

Important operational decisions should be documented rather than preserved only in individual developer knowledge.

Relevant documentation includes:

```text
00_Project_Vision.md
01_Architecture.md
02_Engineering_Methodology.md
03_Platform_Foundations.md
05_Platform_Operations.md
```

Together these establish:

```text
Why
 |
 v
Architecture
 |
 v
Method
 |
 v
Foundations
 |
 v
Operations
```

The later workflow documents provide detailed execution instructions.

---

## 24. Operational Ownership

Operational responsibilities should be understood by function rather than by one individual.

Conceptually:

```text
Database Development
        |
        v
Database Project / Source

Deployment
        |
        v
DACPAC / Deployment Process

Environment Provisioning
        |
        v
Deployment Scripts

Security Validation
        |
        v
Security Tests

Data Processing
        |
        v
Pipeline / ETL

Documentation
        |
        v
Repository Documentation
```

The repository structure should make the responsibility of each artifact clear.

---

## 25. Operational Repeatability

A mature operational process should be executable repeatedly with the same expected outcome.

The desired model is:

```text
Known Source
     +
Known Artifact
     +
Known Provisioning
     +
Known Tests
     |
     v
Predictable Environment
```

This is one of the primary reasons the platform maintains separate source, deployment, provisioning and testing concerns.

---

## 26. Operational Readiness

Before promoting a meaningful database change, the following questions should be answerable:

### Implementation

- Is the change represented in source control?
- Does the database project build?

### Deployment

- Has the artifact been deployed successfully?
- Are the expected database objects present?

### Processing

- If ETL or pipeline behavior changed, has it been validated?

### Security

- If security changed, has provisioning been applied?
- Have relevant security tests passed?

### Data behavior

- Does the changed functionality behave as expected?

### Traceability

- Is the change committed?
- Is the relevant documentation updated?

This provides a practical operational readiness gate.

---

## 27. Operational Separation of Concerns

The platform maintains the following operational boundaries:

| Concern | Primary mechanism |
|---|---|
| Database implementation | Database Project |
| Build | Database Project build |
| Deployment artifact | DACPAC |
| Database deployment | Deployment process |
| Environment security | `Provision-Security.sql` |
| Security validation | `tests/security/` |
| Data processing | Pipeline / staging procedures |
| Source history | Git |
| Engineering knowledge | `docs/` |

These boundaries should remain stable unless an explicit architectural decision changes them.

---

## 28. Operational Principles

The platform is operated according to the following principles:

1. **Deploy artifacts, not manually reconstructed databases.**
2. **Use the appropriate environment for the capability being validated.**
3. **Keep environment provisioning separate from database implementation where appropriate.**
4. **Provision security explicitly.**
5. **Test security behavior independently.**
6. **Validate meaningful changes at the level affected.**
7. **Diagnose failures by architectural layer.**
8. **Correct source rather than normalizing manual target changes.**
9. **Promote approved artifacts rather than developing directly in production.**
10. **Maintain operational knowledge in source control.**
11. **Prefer repeatable operations over one-off fixes.**
12. **Treat production as a controlled deployment target.**

---

## 29. Relationship to the Development Workflow

The operational model complements the development workflow.

Development answers:

> How do we create and validate a change?

Operations answers:

> How do we move and maintain that change across environments?

The relationship is:

```text
Development
     |
     v
Build
     |
     v
Artifact
     |
     v
Operations
     |
     +--> Deploy
     |
     +--> Provision
     |
     +--> Validate
     |
     v
Promotion
```

The two disciplines are therefore connected but should not be conflated.

---

## 30. Relationship to Security Testing

Security testing is an operational control as well as a development activity.

The operational sequence is:

```text
Deploy
   |
   v
Provision Security
   |
   v
Verify Security State
   |
   v
Run Security Tests
   |
   v
Approve / Correct
```

This sequence ensures that the target environment's actual security state is tested rather than merely assuming that the provisioning script represents reality.

---

## 31. Relationship to Git

Git provides operational traceability.

An operational change should be explainable through the repository history.

The relationship is:

```text
Requirement
    |
    v
Implementation
    |
    v
Commit
    |
    v
Artifact
    |
    v
Deployment
    |
    v
Validation
```

This creates a chain of evidence from source change to deployed behavior.

---

## 32. Long-Term Operational Evolution

The current operational model establishes the foundation for stronger automation.

A future mature implementation can automate:

```text
Commit
  |
  v
Build
  |
  v
Artifact
  |
  v
Automated Deployment
  |
  v
Environment Provisioning
  |
  v
Automated Tests
  |
  v
Approval
  |
  v
Production Promotion
```

Potential future operational capabilities include:

- automated build validation;
- automated DACPAC deployment;
- automated security provisioning;
- automated regression tests;
- deployment approvals;
- environment health checks;
- deployment audit trails;
- rollback automation;
- operational monitoring.

These capabilities can be added without changing the core architectural boundaries.

---

## 33. Operational Definition of Done

A deployment operation is considered complete when:

- the intended artifact has been deployed;
- the target database is available;
- expected database objects exist;
- required environment provisioning has completed;
- required security state has been established;
- relevant tests have passed;
- any data-processing changes have been validated;
- the deployment is traceable to the source-controlled change.

For production, the appropriate approval and release controls must also be satisfied.

---

## 34. Operational Outcome

The platform's operational model turns database delivery into a controlled lifecycle:

```text
SOURCE
   |
   v
BUILD
   |
   v
ARTIFACT
   |
   v
DEPLOY
   |
   v
PROVISION
   |
   v
VALIDATE
   |
   v
PROMOTE
   |
   v
OPERATE
```

The objective is not to eliminate every operational problem.

The objective is to make problems:

- detectable;
- diagnosable;
- recoverable;
- traceable;
- reproducible.

The Enterprise SQL Platform therefore operates on a simple principle:

> A database is operationally trustworthy when its implementation, deployment, environment state and validation are all explicit and repeatable.
