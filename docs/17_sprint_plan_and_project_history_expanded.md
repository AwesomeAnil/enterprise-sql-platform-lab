# 17 --- Sprint Plan and Project History

## 1. Purpose

This document defines the sprint planning model and historical delivery
record for the Enterprise SQL Platform Lab.

It serves as the project's **chronological delivery record**.

Its purpose is to answer:

-   What work was planned?
-   What work was completed?
-   In which sprint was it completed?
-   What major architectural decisions were made?
-   What remains planned?
-   Where can the implementation evidence be found?

This document should remain useful to a future engineer who returns to
the repository and needs to understand how the platform evolved.

------------------------------------------------------------------------

## 2. Sprint Management Principles

The project follows several basic Agile and DevOps principles:

1.  **A sprint has a clear objective.**
2.  **Work is grouped around a meaningful outcome rather than arbitrary
    file changes.**
3.  **Completed work should leave the repository in a coherent state.**
4.  **Architectural decisions should be recorded when they become
    stable.**
5.  **Git history records implementation activity.**
6.  **This document records sprint-level delivery history.**
7.  **Architecture documentation records the enduring design.**
8.  **Future work is clearly distinguished from completed work.**

The sprint record is therefore a management and historical layer, not a
substitute for technical documentation.

------------------------------------------------------------------------

## 3. Sprint History Versus Git History

Sprint history and Git history answer different questions.

### Sprint history

Answers:

> **What outcome did the team intend to deliver, and what was
> accomplished?**

### Git history

Answers:

> **What source-controlled changes were actually committed?**

### Architecture documentation

Answers:

> **What is the resulting design and how does it work?**

The three should not be conflated.

``` text
SPRINT
  |
  | delivery objective
  v
GIT
  |
  | implementation history
  v
ARCHITECTURE
  |
  | enduring technical baseline
  v
OPERATING MODEL
```

A sprint may contain multiple commits.

A single sprint may also produce several documents.

A document may remain relevant long after the sprint in which it was
created has ended.

------------------------------------------------------------------------

## 4. Sprint Lifecycle

The recommended lifecycle is:

``` text
Sprint Planning
      |
      v
Define Objective
      |
      v
Break Into Work
      |
      v
Develop
      |
      v
Validate
      |
      v
Document
      |
      v
Commit
      |
      v
Review
      |
      v
Sprint Close
```

A sprint should end with a coherent baseline rather than merely a
collection of partially completed tasks.

------------------------------------------------------------------------

## 5. Sprint Naming

Sprint titles should communicate the dominant outcome.

A useful format is:

``` text
Sprint <number> — <Outcome>
```

Examples:

``` text
Sprint 10 — Security Architecture, Provisioning and Testing
Sprint 11 — Documentation and Operational Baseline
```

The sprint number provides chronological ordering.

The title provides immediate context.

------------------------------------------------------------------------

## 6. Sprint Numbering

Sprint numbers are sequential.

They should not be reused.

If the scope of a sprint changes during execution, the sprint number
remains the same and the final record explains the change.

The objective is to preserve a trustworthy chronological history.

------------------------------------------------------------------------

## 7. Sprint Scope

Each sprint should ideally define:

``` text
Objective
Scope
Expected deliverables
Validation criteria
Architectural decisions
Completed work
Deferred work
Result
```

This provides enough information for a future reader to understand both
the intention and the outcome.

------------------------------------------------------------------------

# Part I --- Project Sprint History

## 8. Sprint 1--8 --- Historical Foundation

The project predates the current documentation baseline.

These early sprints established the foundation from which the current
platform evolved.

However, this document deliberately does **not** fabricate detailed
historical records where the original sprint evidence has not been
formally captured.

The repository should distinguish between:

``` text
Confirmed historical fact
        |
        v
Documented project record
```

and:

``` text
Reasonable reconstruction
        |
        v
Historical assumption
```

Only the former should be presented as authoritative sprint history.

The detailed Sprint 1--8 records should therefore be completed from
actual Git history, project notes, commits, and other authoritative
project evidence rather than invented retrospectively.

### Historical baseline

The early project phase established the major database development
foundation that later sprints built upon.

The resulting platform subsequently evolved into the structured
database, deployment, security and DevOps architecture documented in the
later project documents.

------------------------------------------------------------------------

## 9. Sprint 9 --- Security Milestone

Sprint 9 was originally identified as the security milestone.

The intended scope included the introduction and development of the
platform's security model.

During subsequent work, the security implementation expanded
substantially beyond the original expectations.

This included:

``` text
Database roles
Database users
Role membership
Schema permissions
Object permissions
Security predicates
Row-level security
Security mapping data
Security validation
Environment-specific provisioning
```

### Important historical observation

Sprint 9 was the original target for the security work.

The later security reconciliation demonstrated that the implementation
had grown into a larger architectural milestone than originally
anticipated.

Rather than forcing the expanded work into an artificial historical
boundary, the project moved the substantial completed security baseline
into Sprint 10.

------------------------------------------------------------------------

## 10. Sprint 10 --- Security Architecture, Provisioning and Testing

### Sprint objective

Establish a clean, repeatable and environment-independent security
architecture.

### Major outcomes

Sprint 10 produced the security baseline that is now considered part of
the project's stable architecture.

Major outcomes included:

``` text
1. Login/user mappings reconciled
2. Database roles reconciled
3. Role memberships verified
4. LocalDB security state cleaned
5. Docker security state cleaned
6. Provision-Security.sql established
7. Security.sql separated from environment provisioning
8. Security tests moved outside DACPAC deployment
9. Role-based access validated
10. Sales row-level security validated
11. ETL security validated
12. Developer security validated
13. Security baseline tests completed
```

### Architectural decision

The most important Sprint 10 decision was the explicit separation of:

``` text
Database deployment
        |
        v
Environment provisioning
        |
        v
Security testing
```

Security provisioning was deliberately removed from the DACPAC
deployment boundary.

### Result

The project now has:

``` text
database/
deployment/
tests/
```

as distinct operational boundaries.

------------------------------------------------------------------------

## 11. Sprint 10 --- Security State Established

The final security model established during Sprint 10 includes the
following functional roles:

``` text
role_crm
role_customersuccess
role_dataquality
role_developer
role_etl
role_finance
role_reporting
role_sales
```

Validated role memberships include:

``` text
role_crm
 ├── CRMAMERUser
 ├── CRMAPACUser
 ├── CRMEMEAUser
 └── CRMLogin

role_customersuccess
 └── CustomerSuccessUser

role_dataquality
 └── DataQualityUser

role_developer
 └── DeveloperUser

role_etl
 └── ETLUser

role_finance
 └── FinanceUser

role_reporting
 └── ReportingUser

role_sales
 ├── SalesAMERUser
 ├── SalesAPACUser
 └── SalesEMEAUser
```

The detailed security architecture is maintained in:

``` text
docs/14_security_architecture.md
```

The testing methodology is maintained in:

``` text
docs/15_security_testing.md
```

------------------------------------------------------------------------

## 12. Sprint 11 --- Documentation and Operational Baseline

### Sprint objective

Create the durable documentation baseline for the platform so that a
future engineer can understand, operate and extend the project without
relying on conversation history.

This is not simply a Markdown-writing sprint.

It is the **Documentation and Operational Baseline milestone**.

### Core objective

Capture the stable architecture and operating model that emerged from
the preceding development work.

The intended learning path is:

``` text
What is this platform?
        |
        v
How is the database developed?
        |
        v
How is it deployed?
        |
        v
How are environments provisioned?
        |
        v
How does security work?
        |
        v
How is security tested?
        |
        v
How does Git development work?
        |
        v
How are changes promoted?
```

### Sprint 11 deliverables

The documentation sequence includes:

``` text
Architecture
Database Development
Deployment
Environment Provisioning
Security Architecture
Security Testing
Git Development Workflow
Sprint Planning / History
```

The numbered documentation structure provides a predictable route
through the platform.

------------------------------------------------------------------------

## 13. Sprint 11 --- Documentation Principles

The documentation created during Sprint 11 follows these principles:

### Clear

A future engineer should be able to understand the architecture without
access to the original development conversation.

### Operational

The documents should explain what to do, not merely describe concepts.

### Explicit

Important boundaries should be stated directly.

### Reproducible

Another engineer should be able to reconstruct the intended workflow.

### Honest

Historical facts should not be invented.

### Durable

The documents should describe stable architecture rather than transient
implementation details.

------------------------------------------------------------------------

## 14. Sprint 11 --- Architectural Baseline

The documentation now establishes the following architectural
boundaries:

``` text
Database project
    |
    +--> Database objects
    +--> Database roles
    +--> Database permissions
    +--> DACPAC
```

Separate:

``` text
deployment/
    |
    +--> Provision-Security.sql
```

Separate:

``` text
tests/Security/
    |
    +--> Security validation
```

And:

``` text
docs/
    |
    +--> Architecture
    +--> Development
    +--> Deployment
    +--> Security
    +--> Git
    +--> Sprint history
```

This separation is one of the most important outcomes of the
documentation milestone.

------------------------------------------------------------------------

# Part II --- How Sprints Relate to the Repository

## 15. Sprint Versus Repository Structure

A sprint is a delivery unit.

A repository folder is a technical organization unit.

They should not be forced to correspond one-to-one.

For example:

``` text
Sprint 10
   |
   +--> database/
   +--> deployment/
   +--> tests/
   +--> docs/
```

The work from one sprint may touch multiple areas.

Likewise, a repository folder may contain work from many sprints.

------------------------------------------------------------------------

## 16. Sprint Versus Documentation

Documentation should reflect the current architecture.

It does not need to be rewritten every sprint merely because the sprint
number changed.

For example:

``` text
Sprint 10
    |
    +--> Security architecture established

Sprint 11
    |
    +--> Security architecture documented
```

The Sprint 10 record explains **when the architecture was established**.

`14_security_architecture.md` explains **what that architecture is**.

------------------------------------------------------------------------

## 17. Sprint Versus Git Commit

A sprint may contain:

``` text
Commit A
Commit B
Commit C
Pull Request
Merge
```

A sprint-level commit can also be appropriate when a large coherent body
of work is complete.

The project should choose commit boundaries based on logical change
rather than mechanically creating one commit per task.

This principle is documented in:

``` text
docs/16_git_development_workflow.md
```

------------------------------------------------------------------------

## 18. Sprint Commit Model

For substantial sprint outcomes, a commit can summarize the completed
milestone.

Example:

``` text
Sprint 10 — Security Architecture, Provisioning and Testing
```

A strong sprint-level commit description should identify:

``` text
What was delivered
Why it was delivered
What architecture changed
What was tested
```

However, the sprint record and Git commit remain separate records.

The sprint document should not attempt to reproduce every commit.

------------------------------------------------------------------------

# Part III --- Best-Practice Sprint Planning

## 19. Sprint Objective

Every sprint should begin with one dominant objective.

Example:

``` text
Sprint 11
Objective:
Establish the durable documentation and operational baseline.
```

The objective should be specific enough to determine whether the sprint
succeeded.

------------------------------------------------------------------------

## 20. Sprint Deliverables

Deliverables should be concrete.

Examples:

``` text
Database object
SQL script
Test suite
Documentation
Deployment capability
Architectural baseline
```

Avoid vague deliverables such as:

``` text
Improve things
Work on security
Clean up database
```

------------------------------------------------------------------------

## 21. Definition of Done

A sprint item should not be considered complete merely because the code
exists.

A practical Definition of Done is:

``` text
Implemented
   |
   v
Build succeeds
   |
   v
Relevant environment validated
   |
   v
Tests pass
   |
   v
Documentation updated where required
   |
   v
Git changes reviewed
   |
   v
Committed
```

For security-related work:

``` text
Provisioned
   |
   v
Tested
   |
   v
Expected access confirmed
```

------------------------------------------------------------------------

## 22. Sprint Closure

At sprint close, record:

``` text
Objective
Completed deliverables
Major decisions
Tests performed
Outstanding work
Deferred work
Resulting baseline
```

This provides a lightweight retrospective without creating excessive
administrative overhead.

------------------------------------------------------------------------

## 23. Deferred Work

Not all work identified during a sprint must be completed within that
sprint.

Deferred work should be explicitly recorded.

Example:

``` text
Deferred:
Automated CI/CD security testing
```

is preferable to leaving the reader wondering whether the capability was
forgotten.

Deferred work can then become future sprint scope.

------------------------------------------------------------------------

## 24. Changes in Sprint Scope

Real development changes scope.

If a sprint expands or contracts:

``` text
Original objective
      |
      v
Scope change
      |
      v
Final outcome
```

The sprint record should preserve the distinction.

This prevents the historical record from being rewritten to make the
sprint appear to have been perfectly planned from the beginning.

------------------------------------------------------------------------

## 25. Sprint Planning and Git Branches

A sprint can use one or more feature branches.

Example:

``` text
Sprint 11
 |
 +--> feature/documentation-architecture
 |
 +--> feature/security-documentation
 |
 +--> feature/git-workflow-documentation
```

These branches can eventually merge into `main`.

The branch structure is an implementation mechanism.

The sprint is the delivery boundary.

------------------------------------------------------------------------

# Part IV --- Future Sprint Planning

## 26. Sprint 12 and Beyond

Future sprint numbers should be assigned as new work is planned.

The project should avoid prematurely creating a large sequence of
speculative sprint commitments.

Instead:

``` text
Current baseline
      |
      v
Identify next objective
      |
      v
Plan next sprint
      |
      v
Deliver
      |
      v
Record result
```

This keeps the roadmap useful without creating artificial certainty.

------------------------------------------------------------------------

## 27. Potential Future Sprint Themes

Potential future work may include:

``` text
CI/CD pipeline implementation
Automated database deployment
Automated security provisioning
Automated security testing
TEST environment integration
Production deployment workflow
Deployment approvals
Release management
Drift detection
Observability
Data loading automation
Performance testing
```

These are candidate themes, not committed sprint scope until formally
planned.

------------------------------------------------------------------------

## 28. Production as a Future Delivery Stage

Production is an environment, not necessarily a separate sprint.

The intended model is:

``` text
Approved source
      |
      v
Build artifact
      |
      v
TEST
      |
      v
Approval
      |
      v
PROD
```

A production deployment may therefore be part of a release sprint
without requiring a separate "Production Sprint."

The production environment should consume the approved artifact rather
than introducing a separate implementation.

------------------------------------------------------------------------

# Part V --- Historical Integrity

## 29. Do Not Invent Historical Detail

The sprint history should be treated as an engineering record.

If a historical fact is not supported by:

``` text
Git history
Project notes
Existing documentation
Recorded implementation
```

it should not be presented as confirmed fact.

Use wording such as:

``` text
Historical record not formally captured
```

rather than manufacturing exact dates, tasks, commits or outcomes.

This is especially important for Sprints 1--8.

------------------------------------------------------------------------

## 30. Reconstructing Older Sprints

If historical detail is required later, the project can reconstruct
earlier sprints from:

``` text
Git log
Commit messages
Pull requests
Repository structure
Database project history
Existing project artifacts
```

The reconstruction should distinguish:

``` text
Confirmed
Inferred
Unknown
```

This preserves the integrity of the project history.

------------------------------------------------------------------------

## 31. Sprint Evidence

Useful evidence includes:

``` text
Git commits
Pull requests
Build results
Deployment results
Test output
Architecture documents
Security test results
Release records
```

The sprint record should summarize the evidence rather than duplicate
it.

------------------------------------------------------------------------

# Part VI --- Current Project Baseline

## 32. Current Development State

At the completion of the current documentation milestone, the project
has established:

``` text
Database development workflow
        |
        v
Database deployment
        |
        v
Environment provisioning
        |
        v
Security architecture
        |
        v
Security testing
        |
        v
Git development workflow
        |
        v
Sprint history
```

This represents a significantly more mature development model than the
original database-only project.

------------------------------------------------------------------------

## 33. Current Operational Boundaries

The current repository architecture is:

``` text
database/
    Database artifact definition

deployment/
    Environment provisioning

tests/
    Runtime validation

docs/
    Architecture and operating knowledge

.git/
    Version history
```

Each boundary has a different responsibility.

------------------------------------------------------------------------

## 34. Current Sprint Baseline

The current sprint is:

``` text
Sprint 11 — Documentation and Operational Baseline
```

Its central outcome is the establishment of durable project knowledge.

The documentation should allow a future engineer to begin from the
repository rather than from the original development conversation.

That is the practical definition of success for this milestone.

------------------------------------------------------------------------

# Part VII --- Sprint Governance

## 35. Recommended Sprint Record Template

Future sprint entries should follow this structure:

``` markdown
## Sprint N — <Title>

### Objective

<One clear objective>

### Scope

<Major work included>

### Deliverables

- <Deliverable>
- <Deliverable>

### Architectural Decisions

- <Decision>
- <Decision>

### Validation

- <Build/test/deployment evidence>

### Completed

- <Completed item>

### Deferred

- <Deferred item>

### Result

<Short statement of the resulting baseline>
```

This keeps future sprint entries consistent.

------------------------------------------------------------------------

## 36. Sprint Review Checklist

At sprint close:

``` text
[ ] Objective achieved
[ ] Deliverables identified
[ ] Build validated
[ ] Relevant tests passed
[ ] Architectural decisions captured
[ ] Documentation updated
[ ] Git changes committed
[ ] Pull request completed where applicable
[ ] Deferred work recorded
[ ] Sprint history updated
```

------------------------------------------------------------------------

## 37. Relationship to Git Development Workflow

Document 16 defines **how source changes move through Git**.

Document 17 defines **how work is grouped and recorded as delivery
milestones**.

The relationship is:

``` text
Sprint
  |
  +--> Work items
          |
          v
      Git branches
          |
          v
       Commits
          |
          v
      Pull Request
          |
          v
        main
```

The sprint provides the planning context.

Git provides the implementation history.

------------------------------------------------------------------------

## 38. Relationship to Architecture Documentation

The architecture documents should describe the current stable state.

Sprint history explains when that state emerged.

For example:

``` text
Sprint 10
    |
    +--> Security architecture established
              |
              v
14_security_architecture.md
    |
    +--> Current security reference
```

This prevents architecture documents from becoming chronological
diaries.

------------------------------------------------------------------------

# Part VIII --- Final Project Delivery Model

## 39. Complete Model

The project now has a complete relationship between planning,
development, version control, deployment, testing and documentation:

``` text
                     SPRINT
                       |
                       v
                  WORK ITEMS
                       |
                       v
                FEATURE BRANCH
                       |
                       v
                  DEVELOPMENT
                       |
                       v
                  LOCALDB
                       |
                       v
                    BUILD
                       |
                       v
                   DOCKER
                       |
                       v
                PROVISIONING
                       |
                       v
               SECURITY TESTS
                       |
                       v
                    COMMIT
                       |
                       v
                PULL REQUEST
                       |
                       v
                     MAIN
                       |
                       v
               RELEASE ARTIFACT
                       |
                 +-----+-----+
                 |           |
                TEST        PROD
```

Documentation runs alongside the entire lifecycle:

``` text
                    DOCUMENTATION
                         |
        +----------------+----------------+
        |                |                |
   Architecture      Operations        History
        |                |                |
        +----------------+----------------+
                         |
                         v
                   Git Repository
```

------------------------------------------------------------------------

## 40. The Three Records of Truth

The project intentionally maintains three complementary records.

### 1. Git history

``` text
What changed?
```

### 2. Sprint history

``` text
What work was planned and delivered?
```

### 3. Architecture documentation

``` text
What is the current system and how should it operate?
```

Together:

``` text
Git
 |
 +--> Implementation history

Sprints
 |
 +--> Delivery history

Documentation
 |
 +--> Technical knowledge
```

None should be treated as a replacement for the others.

------------------------------------------------------------------------

## 41. Final Governance Principle

The governing principle for sprint management is:

> **Plan meaningful outcomes, implement them through disciplined Git
> workflows, validate them against the appropriate environments,
> document stable architectural decisions, and record the completed
> sprint without rewriting history.**

The sprint record should tell the story of the project's evolution.

The Git repository should preserve the implementation.

The documentation should preserve the knowledge.

Together they make the platform maintainable beyond the original
development effort.

------------------------------------------------------------------------

## 42. Current Document Sequence

The operational documentation sequence now culminates in:

``` text
13 — Environment Provisioning
14 — Security Architecture
15 — Security Testing
16 — Git Development Workflow
17 — Sprint Plan and Project History
```

This sequence is deliberate:

``` text
Prepare the environment
        ↓
Understand the security model
        ↓
Prove the security model
        ↓
Control source changes
        ↓
Understand the delivery history
```

A future engineer should be able to enter the documentation at the
beginning and progressively build a complete mental model of the
platform.

------------------------------------------------------------------------

## 43. Closing Statement

Sprint management is not merely a list of dates and tasks.

For this project, it is the bridge between **engineering activity and
institutional knowledge**.

A well-maintained sprint history allows the repository to answer:

``` text
Where did this architecture come from?
Why was this boundary introduced?
When was this security model established?
Which work remains?
What should I read next?
```

That is the standard this document establishes for all future sprints.
