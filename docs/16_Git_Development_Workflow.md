# 16 --- Git Development Workflow

## 1\. Purpose

This document defines how the Enterprise SQL Platform Lab is developed,
versioned, reviewed, committed, and promoted using Git.

The workflow is designed around one fundamental principle:

> \*\*Git records the source-controlled definition of the platform;
> deployment systems consume that definition to produce environment
> state.\*\*

The repository therefore contains source code, database definitions,
deployment/provisioning scripts, tests, and documentation.

Git does **not** represent the live state of LocalDB, Docker SQL Server,
TEST, or PROD.

\---

## 2\. The Repository as the Source of Truth

The Git repository is the authoritative source for the platform's
version-controlled implementation.

Conceptually:

``` text
Git Repository
      |
      +--> Database project
      +--> Deployment scripts
      +--> Security provisioning
      +--> Security tests
      +--> Documentation
      +--> Supporting assets
```

The environments are deployment targets:

``` text
Git
 |
 +--> LocalDB
 |
 +--> Docker SQL Server
 |
 +--> TEST
 |
 +--> PROD
```

Changes should therefore be made in source-controlled files rather than
directly in an environment whenever practical.

\---

## 3\. Repository Structure

The repository follows the approved documentation and development
structure.

A simplified representation is:

``` text
/
├── database/
│   └── EnterpriseSQLPlatform/
│       ├── Tables/
│       ├── Views/
│       ├── Stored Procedures/
│       ├── Functions/
│       ├── Security/
│       ├── Post-Deployment/
│       └── ...
│
├── deployment/
│   └── Provision-Security.sql
│
├── tests/
│   └── Security/
│       ├── 01\_CRM.sql
│       ├── ...
│       └── ...
│
├── docs/
│   ├── 01\_architecture\_overview.md
│   ├── 02\_...
│   ├── ...
│   ├── 13\_environment\_provisioning.md
│   ├── 14\_security\_architecture.md
│   ├── 15\_security\_testing.md
│   └── 16\_git\_development\_workflow.md
│
└── ...
```

The exact database-project subfolders may evolve as the platform grows,
but the separation between database deployment, environment
provisioning, testing, and documentation is intentional.

\---

## 4\. What Belongs in Git

The repository should contain:

### Database source

``` text
Tables
Views
Stored Procedures
Functions
Schemas
Database roles
Database permissions
Post-deployment database configuration
```

### Deployment source

``` text
Provision-Security.sql
```

and future environment-provisioning scripts.

### Test source

``` text
tests/Security/\*.sql
```

and future automated validation scripts.

### Documentation

``` text
docs/\*.md
```

### Configuration

Non-secret configuration required to reproduce the platform may be
version-controlled.

Secrets must not be committed.

\---

## 5\. What Does Not Belong in Git

Do not commit:

``` text
Passwords
Connection secrets
API keys
Certificates containing private keys
Personal credentials
Local machine secrets
Generated temporary files
Build output that is not intentionally versioned
Database backups unless explicitly required
User-specific IDE state
```

The repository should contain the instructions and configuration
required to reproduce an environment, not credentials that compromise
it.

\---

## 6\. Git Does Not Replace the Database Project

The SQL database project remains responsible for database artifact
definition.

Git provides version control around that project.

The relationship is:

``` text
Visual Studio Database Project
            |
            v
       SQL Source Files
            |
            v
           Git
            |
            v
        Build / DACPAC
            |
            v
       Database Target
```

Git is therefore not a replacement for the database project.

The database project is the buildable database artifact definition; Git
versions it.

\---

## 7\. Main Branch

The repository's `main` branch represents the controlled
integration/release baseline.

It should contain code that has passed the project's required validation
gates.

Conceptually:

``` text
feature branch
      |
      v
pull request
      |
      v
main
      |
      v
release / deployment
```

`main` should not be treated as an experimental workspace.

\---

## 8\. Feature Branches

Development work should normally occur on a feature branch.

Examples:

``` text
feature/security-architecture
feature/security-testing
feature/documentation-sprint-11
feature/customer-domain
feature/etl-pipeline
```

The branch should describe the unit of work rather than the developer's
name.

A feature branch isolates changes until they are ready to be integrated.

\---

## 9\. Branch Lifecycle

The standard lifecycle is:

``` text
main
  |
  +----> feature/<work>
               |
               v
           Development
               |
               v
             Build
               |
               v
          Local validation
               |
               v
        Docker validation
               |
               v
          Commit changes
               |
               v
        Push feature branch
               |
               v
          Pull Request
               |
               v
             Review
               |
               v
             main
```

The exact pull-request controls can become more sophisticated as CI/CD
is introduced.

\---

## 10\. Who Creates the Initial Repository?

The initial repository is normally created once by the project owner or
designated repository administrator.

The initial commit establishes the baseline:

``` text
database project
deployment
tests
docs
.gitignore
README
```

After that baseline exists, development proceeds through Git branches
and commits.

Git does not require every developer to recreate the repository.

\---

## 11\. Initial Commit

The initial commit should establish a reproducible project baseline.

Typical contents include:

``` text
Database project
Documentation structure
Deployment structure
Testing structure
Repository configuration
```

The commit should represent a deliberate baseline rather than an
accidental collection of files.

\---

## 12\. Commit Strategy

A commit should represent a coherent logical change.

Good examples:

``` text
Add CRM security roles and permissions
Add sales territory RLS predicate
Add Docker security provisioning
Add security test suite
Add security architecture documentation
```

Poor examples:

``` text
stuff
changes
updates
fix
more changes
```

A useful commit should answer:

> \*\*What changed and why?\*\*

\---

## 13\. Commit Granularity

Avoid both extremes.

### Too large

One commit containing:

``` text
database changes
security changes
deployment changes
documentation
unrelated cleanup
```

This becomes difficult to review or revert.

### Too small

Hundreds of trivial commits such as:

``` text
fix typo
fix another typo
add semicolon
change spacing
```

The preferred level is a coherent logical unit.

\---

## 14\. The Sprint Commit Model

The project can group a substantial completed body of work into a
meaningful sprint-level commit when that body of work forms a coherent
baseline.

This has already been used for the security implementation work.

For example:

``` text
Sprint 10 — Security Architecture, Provisioning and Testing
```

The important point is not the sprint number itself.

The important point is that the commit should describe the completed
body of work accurately.

\---

## 15\. Commit Before Pull Request

A typical sequence is:

``` bash
git status
git add .
git commit -m "Add security architecture and testing"
git push origin feature/security-architecture
```

Before committing:

``` text
Review changed files
Review the diff
Confirm no secrets are present
Confirm generated artifacts are not accidentally included
Confirm tests have passed
```

\---

## 16\. Review the Diff

The most important pre-commit discipline is reviewing what Git believes
changed.

Useful commands include:

``` bash
git status
git diff
git diff --staged
```

The objective is to detect:

* accidental files
* unwanted generated content
* credentials
* unrelated changes
* incomplete work
* unexpected database-project modifications

\---

## 17\. The `.gitignore` Boundary

The repository should use `.gitignore` to exclude machine-specific and
generated content where appropriate.

Typical exclusions may include:

``` text
.vs/
bin/
obj/
\*.user
\*.suo
```

The exact list should reflect the actual Visual Studio/database-project
environment.

A `.gitignore` rule should be intentional.

Do not blindly exclude files that are required to build or deploy the
project.

\---

## 18\. Pull Requests

A pull request is the controlled integration point between a feature
branch and `main`.

A good pull request should explain:

``` text
What changed?
Why was it changed?
How was it tested?
Are there deployment implications?
Are there security implications?
```

For database work, testing evidence is especially important.

\---

## 19\. Database Change Review

Database changes should be reviewed at source level.

Reviewers should examine:

``` text
Schema changes
Table changes
Procedure changes
Function changes
Security changes
Post-deployment scripts
```

The generated DACPAC is an output of the project, not the primary
human-readable source of the database design.

\---

## 20\. Security Change Review

Security changes require additional scrutiny.

Review:

``` text
Roles
Role membership
GRANT statements
RLS predicates
Security mapping data
Provisioning changes
Security tests
```

The reviewer should confirm that:

``` text
Provisioning
       !=
Database security definition
       !=
Security testing
```

The boundaries established in Documents 13--15 must remain intact.

\---

## 21\. Build Validation Before Integration

Before pushing a feature branch:

``` text
Build database project
       |
       v
Resolve errors
       |
       v
Publish to LocalDB
       |
       v
Validate database objects
       |
       v
Publish to Docker
       |
       v
Provision environment
       |
       v
Run security tests
```

This provides a practical development gate before the pull request.

\---

## 22\. LocalDB's Role in Git Workflow

LocalDB is primarily a development/build validation environment.

It provides fast feedback for:

``` text
Database project compilation
DACPAC generation
Database object deployment
Schema validation
Stored procedure validation
```

LocalDB should not be treated as the authoritative security-integration
environment.

The project deliberately separates:

``` text
LocalDB
  -> database development

Docker
  -> integrated SQL Server/security validation
```

\---

## 23\. Docker's Role in Git Workflow

Docker SQL Server provides the controlled local integration environment.

It is used for:

``` text
DACPAC deployment
Environment provisioning
Login/user validation
Role membership validation
Security tests
Runtime integration testing
```

The intended workflow is:

``` text
LocalDB
   |
   v
Build / publish
   |
   v
Docker
   |
   v
Provision
   |
   v
Test
```

\---

## 24\. Why Deployment Scripts Are Versioned Separately

`deployment/Provision-Security.sql` is source-controlled because
environment provisioning is part of the reproducible deployment process.

It is **not** part of the DACPAC.

Therefore:

``` text
Git
 |
 +--> Database project
 |       |
 |       +--> DACPAC
 |
 +--> deployment/Provision-Security.sql
 |
 +--> tests/Security/
```

This preserves the architecture established in the previous documents.

\---

## 25\. Why Security Tests Are Versioned Separately

Security tests are also source-controlled.

They are not database deployment artifacts.

Their purpose is to establish a repeatable verification suite.

``` text
Database source
      |
      v
Deployment
      |
      v
Provisioning
      |
      v
Security tests
```

This allows the same tests to be rerun after future changes.

\---

## 26\. Documentation as Code

The documentation is version-controlled alongside the implementation.

This means:

``` text
Code changes
      +
Architecture changes
      +
Security changes
      +
Workflow changes
      |
      v
Git history
```

A future engineer can therefore reconstruct not only what the system
does, but how it is supposed to be developed and deployed.

\---

## 27\. Documentation Numbering

The documentation uses numbered files to establish a deliberate learning
and operational sequence.

For example:

``` text
01\_architecture\_overview.md
11\_database\_development\_workflow.md
13\_environment\_provisioning.md
14\_security\_architecture.md
15\_security\_testing.md
16\_git\_development\_workflow.md
```

The numbering is navigational.

It is not intended to imply that every document is a software
dependency.

\---

## 28\. Sprint 11 Documentation Work

The current documentation milestone is Sprint 11.

The documentation work includes the architecture and operational
documents that establish the project's long-term reference model.

The completed documentation sequence now includes the security
architecture and testing documents immediately before this Git workflow
document.

This creates the intended progression:

``` text
Architecture
   |
   v
Development
   |
   v
Deployment
   |
   v
Provisioning
   |
   v
Security Architecture
   |
   v
Security Testing
   |
   v
Git Workflow
```

\---

## 29\. Git and Sprint Boundaries

A sprint is a planning and delivery boundary.

Git commits are implementation history.

They are related but not identical.

A sprint may contain:

``` text
multiple commits
multiple branches
multiple pull requests
```

Likewise, a single coherent commit may contain the final baseline for a
sprint.

The project should avoid forcing artificial commit boundaries simply
because a sprint has ended.

\---

## 30\. Git History as an Audit Trail

A useful Git history should allow a future engineer to understand:

``` text
What changed?
When did it change?
Why did it change?
Which security model was introduced?
Which deployment model was introduced?
Which tests accompanied the change?
```

This becomes increasingly valuable as the platform moves toward
automated CI/CD.

\---

## 31\. Tags and Release Points

As the project matures, stable deployment points can be tagged.

For example:

``` text
v0.1.0
v0.2.0
v1.0.0
```

Tags should represent meaningful release baselines rather than every
development commit.

A release tag can later provide a reliable reference for:

``` text
DACPAC version
Documentation version
Deployment scripts
Test suite
```

\---

## 32\. Promotion Through Environments

Git promotion and environment promotion should be conceptually
separated.

The source moves through Git:

``` text
feature
   |
   v
main
```

The validated artifact moves through environments:

``` text
DEV
 |
 v
TEST
 |
 v
PROD
```

The two processes are connected through the deployment pipeline.

They are not the same operation.

\---

## 33\. The Future CI/CD Model

The target model is:

``` text
Developer
    |
    v
Feature Branch
    |
    v
Commit
    |
    v
Pull Request
    |
    v
Build
    |
    v
Automated Tests
    |
    v
Merge to main
    |
    v
Deployment Pipeline
    |
    +--> DEV
    |
    +--> TEST
    |
    +--> PROD
```

Security provisioning and security testing remain explicit stages.

\---

## 34\. Production

Production does not require a separate Git branch merely because it is a
separate environment.

The production deployment should consume the approved release artifact.

Conceptually:

``` text
main
 |
 v
Approved release
 |
 v
Production deployment
```

Production-specific configuration belongs to the deployment environment
rather than being hard-coded into the database project.

\---

## 35\. Rollback Philosophy

Git provides source rollback.

Deployment systems provide environment rollback/redeployment mechanisms.

These are different concerns.

If a bad database change is introduced:

``` text
Git
 |
 +--> identify known-good commit
 |
 v
Build known-good artifact
 |
 v
Deploy through approved process
```

The project should avoid relying on ad-hoc manual database editing as
its normal rollback mechanism.

\---

## 36\. Handling Direct Database Changes

Direct changes to Docker, TEST or PROD should be treated as exceptions.

If an emergency manual change is necessary:

``` text
Manual change
      |
      v
Document immediately
      |
      v
Reproduce in source
      |
      v
Commit source change
      |
      v
Deploy through normal process
```

Otherwise Git and the environment can drift apart.

\---

## 37\. Configuration Drift

Drift occurs when:

``` text
Git state != Environment state
```

Examples:

``` text
Role exists in Docker but not in source
Permission manually granted in TEST
Procedure changed directly in PROD
Provisioning performed differently from the source script
```

The long-term objective is:

``` text
Source-controlled definition
            =
Expected environment state
```

Automation will make drift easier to detect.

\---

## 38\. Recommended Developer Daily Workflow

A practical development cycle is:

``` text
1. Pull latest main
2. Create feature branch
3. Make database changes
4. Build project
5. Publish to LocalDB
6. Validate database behaviour
7. Publish to Docker
8. Provision environment if required
9. Run relevant security/integration tests
10. Review Git diff
11. Commit
12. Push feature branch
13. Open pull request
14. Review / resolve feedback
15. Merge to main
```

\---

## 39\. Recommended Commit Gate

Before committing:

``` text
\[ ] Build succeeds
\[ ] LocalDB publish succeeds
\[ ] Database validation succeeds
\[ ] Docker publish succeeds where applicable
\[ ] Provisioning succeeds where applicable
\[ ] Relevant tests pass
\[ ] Git diff reviewed
\[ ] No secrets present
\[ ] No unrelated files present
\[ ] Documentation updated where architecture changed
```

\---

## 40\. Recommended Pull Request Gate

Before merging:

``` text
\[ ] Build succeeds
\[ ] Automated checks pass
\[ ] Database changes reviewed
\[ ] Security changes reviewed
\[ ] Tests reviewed
\[ ] Documentation updated
\[ ] Deployment implications understood
\[ ] No unresolved review comments
```

\---

## 41\. Git Workflow Failure Modes

### Failure: Commit contains unrelated files

**Cause:** `git add .` was used without reviewing the working tree.

**Action:**

``` bash
git status
git diff
git diff --staged
```

Remove unrelated files from the staged set.

\---

### Failure: Secret committed

**Cause:** Credentials or environment configuration entered source
control.

**Action:**

Treat this as a security incident. Remove the secret from source history
as appropriate and rotate the credential.

Do not assume deleting the file in a later commit is sufficient.

\---

### Failure: Database works locally but Docker fails

**Cause:** Environment differences.

**Action:**

Classify the problem:

``` text
database artifact
environment provisioning
server capability
permissions
connection context
```

Do not immediately modify the database project to accommodate an
environment-specific issue.

\---

### Failure: Security test fails after deployment

**Cause:** Could be:

``` text
deployment
provisioning
role membership
permissions
RLS
test context
```

Follow the troubleshooting model in `15\_security\_testing.md`.

\---

### Failure: Environment changed manually

**Cause:** Direct database administration.

**Action:** reconcile the source-controlled definition and redeploy
through the normal process.

\---

## 42\. What Git Should Not Become

Git should not become:

``` text
a database administration console
a password store
a production state database
a replacement for deployment pipelines
a substitute for security testing
```

It is the version-control system for the source and operational
definitions of the platform.

\---

## 43\. Complete Development Model

The complete architecture is:

``` text
                    GIT REPOSITORY
                          |
              +-----------+-----------+
              |           |           |
           Database    Deployment   Tests
            Source       Source      Source
              |           |           |
              v           v           v
           DACPAC    Provisioning   Validation
              |           |           |
              +-----------+-----------+
                          |
                          v
                 DOCKER / ENVIRONMENT
                          |
                          v
                       TEST
                          |
                          v
                       PROD
```

The Git repository holds the definitions.

The deployment process turns those definitions into environment state.

The test suite proves the resulting behaviour.

\---

## 44\. Final Git Workflow

The governing workflow is:

``` text
                    MAIN
                      |
                      v
              Feature Branch
                      |
                      v
                 Development
                      |
                      v
                 LocalDB Build
                      |
                      v
                Docker Publish
                      |
                      v
                Provisioning
                      |
                      v
                 Security Tests
                      |
                      v
                  Git Commit
                      |
                      v
                 Pull Request
                      |
                      v
                    REVIEW
                      |
                      v
                  MAIN MERGE
                      |
                      v
             RELEASE / DEPLOYMENT
                      |
              +-------+-------+
              |               |
             TEST            PROD
```

The central rule is:

> \*\*Develop in branches, validate before integration, commit coherent
> source-controlled changes, review through pull requests, and promote
> approved artifacts through environments rather than treating
> environments as the source of truth.\*\*

\---

## 45\. Relationship to Documents 13--15

The four operational documents now form a clear chain:

``` text
13 — Environment Provisioning
     How the environment is prepared

14 — Security Architecture
     What the security model is

15 — Security Testing
     How the security model is proven

16 — Git Development Workflow
     How all of the above are versioned, reviewed,
     integrated and ultimately promoted
```

This sequence is intentional.

It gives a future engineer a path from:

``` text
"How do I prepare the environment?"
```

through:

``` text
"What is the security model?"
```

to:

``` text
"How do I prove it works?"
```

and finally:

``` text
"How do I safely change and promote it?"
```

That is the development lifecycle this repository is designed to
preserve.

