# 🚀 Enterprise SQL Platform Lab

<div align="center">

![SQL Server](https://img.shields.io/badge/SQL%20Server-2022-red?style=for-the-badge&logo=microsoftsqlserver)
![Docker](https://img.shields.io/badge/Docker-Containerized-2496ED?style=for-the-badge&logo=docker)
![Windows](https://img.shields.io/badge/Windows-11-0078D6?style=for-the-badge&logo=windows)
![GitHub](https://img.shields.io/badge/GitHub-Version_Control-181717?style=for-the-badge&logo=github)
![SSDT](https://img.shields.io/badge/SSDT-Database_Projects-68217A?style=for-the-badge)
![Power BI](https://img.shields.io/badge/Power_BI-Future_State-F2C811?style=for-the-badge&logo=powerbi)

**Enterprise SQL Engineering from First Principles**

*Build • Understand • Test • Inspect • Document • Automate*

<br>

<a href="docs/00_Project_Vision.md"><img src="https://img.shields.io/badge/📖%20Project%20Vision-00_Project_Vision-2F81F7?style=for-the-badge" alt="Project Vision"></a>
<a href="docs/01_Architecture.md"><img src="https://img.shields.io/badge/🏗%20Architecture-01_Architecture-6F42C1?style=for-the-badge" alt="Architecture"></a>
<a href="docs/14_Security_Architecture.md"><img src="https://img.shields.io/badge/🔐%20Security-14_Security-8B5CF6?style=for-the-badge" alt="Security"></a>
<a href="docs/13_Testing_Workflow.md"><img src="https://img.shields.io/badge/🧪%20Testing-13_Testing-238636?style=for-the-badge" alt="Testing"></a>
<a href="docs/16_Git_Development_Workflow.md"><img src="https://img.shields.io/badge/🌿%20Git%20Workflow-16_Git-8250DF?style=for-the-badge" alt="Git Workflow"></a>
<a href="docs/17_Sprint_Plan_and_Project_History.md"><img src="https://img.shields.io/badge/📋%20Sprint%20History-17_Sprints-0969DA?style=for-the-badge" alt="Sprint History"></a>

</div>

---

## 📖 What This Project Is

The **Enterprise SQL Platform Lab** is a practical engineering project for designing, building, securing, testing, documenting, and deploying a SQL Server data platform.

It is deliberately more than a collection of SQL scripts.

The project demonstrates an end-to-end engineering approach:

```text
Design
  ↓
Build
  ↓
Understand
  ↓
Test
  ↓
Inspect
  ↓
Document
  ↓
Automate
```

Automation is introduced only after the underlying platform behaviour is understood and validated.

---

## 🎯 Why This Repository Exists

Most SQL Server learning resources teach isolated technologies.

This project takes a different approach.

Infrastructure, administration, database development, metadata, data ingestion, storage, security, testing, deployment, source control and governance are engineered together as one integrated platform.

Every major component follows the same discipline:

- ✅ Built
- 🧠 Understood
- 🧪 Tested
- 🔎 Inspected
- 📚 Documented
- ⚙️ Prepared for automation

The result is an **Enterprise SQL Engineering Playbook** rather than another SQL tutorial.

---

## 🏗 Architecture at a Glance

The current engineering lifecycle is:

```text
                    SOURCE CONTROL
                         |
                         v
                 DATABASE PROJECT
                         |
                         v
                    BUILD / DACPAC
                         |
              +----------+----------+
              |                     |
           LOCALDB              DOCKER SQL
              |                     |
              +----------+----------+
                         |
                         v
                  SECURITY
                PROVISIONING
                         |
                         v
                      TESTS
                         |
                         v
                    COMMIT
                         |
                         v
                 RELEASE ARTIFACT
                         |
                    +----+----+
                    |         |
                   TEST      PROD
```

The important architectural boundary is that **database deployment and environment-specific security provisioning are separate concerns**.

The DACPAC delivers the database implementation. Security provisioning handles environment-specific principals and role membership outside the DACPAC scope.

---

## 🏛 Enterprise Capability Model

Rather than building isolated SQL objects, this repository builds complete engineering capabilities.

| Capability | Status |
|---|---|
| 🧱 Platform Foundations | ✅ Implemented |
| 🗂 Metadata | ✅ Implemented |
| 📥 Data Ingestion | ✅ Implemented |
| 💾 Data Storage | ✅ Implemented |
| 📊 Business Consumption | 🟡 Database foundation implemented |
| 🛡️ Platform Governance | ✅ Established |
| 🔐 Security | ✅ Implemented |
| 🧪 Testing | ✅ Implemented |
| 🌿 Git Development Workflow | ✅ Established |
| ⚙️ CI/CD Automation | 🔵 Future |
| 📈 Power BI Consumption | 🔵 Future |

### ✅ Implemented Platform Capabilities

The current platform includes:

- source-controlled SQL Server Database Project;
- relational schemas and storage;
- staging and warehouse layers;
- entity-level ingestion procedures;
- pipeline procedures;
- incremental Customer ingestion;
- database roles and permissions;
- row-level security;
- security provisioning outside DACPAC deployment;
- LocalDB development;
- Docker SQL Server validation;
- structured security and functional testing;
- Git-based development and sprint history;
- structured engineering documentation.

---

## 🔄 Development Lifecycle

The platform follows a controlled development path:

```text
Requirement
    ↓
Source Change
    ↓
Database Project Build
    ↓
LocalDB Validation
    ↓
Docker SQL Server Validation
    ↓
Security Provisioning
    ↓
Functional / Security Tests
    ↓
Git Commit
    ↓
Release / Promotion
```

The database project remains the source-controlled definition of the database implementation.

Deployed databases are runtime environments, not the source of truth.

---

## 🔐 Security Model

Security is built around roles, permissions and controlled provisioning.

The platform uses database roles such as:

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

The general model is:

```text
User
  ↓
Role
  ↓
Permission
  ↓
Database Object
```

Row-level security is also implemented for sales territory access.

Security provisioning is deliberately kept outside DACPAC deployment so that environment-specific principals do not become tightly coupled to the database artifact.

👉 See **[14 — Security Architecture](docs/14_Security_Architecture.md)** and **[15 — Security Testing](docs/15_Security_Testing.md)**.

---

## 🧪 Testing

Testing is treated as part of development rather than as a final activity.

The project includes validation for:

- 🏗 database structure;
- 📥 ingestion;
- 🔄 pipeline execution;
- 👥 roles and permissions;
- 🔑 role membership;
- 🛡️ row-level security;
- ⚙️ ETL access;
- 📊 reporting access;
- 🚀 deployment behaviour.

The principle is simple:

```text
Build Success
     ↓
Deployment
     ↓
Functional Validation
     ↓
Security Validation
     ↓
Approved Change
```

👉 See **[13 — Testing Workflow](docs/13_Testing_Workflow.md)** and **[15 — Security Testing](docs/15_Security_Testing.md)**.

---

## 🚀 Deployment

The database is deployed through the Database Project and DACPAC model.

```text
Database Project
      ↓
Build
      ↓
DACPAC
      ↓
Target Database
      ↓
Security Provisioning
      ↓
Validation
```

🧪 **LocalDB** is used for rapid development and structural validation.

🐳 **Docker SQL Server** provides broader integration and SQL Server behaviour validation.

🏭 **Production** is treated as a controlled deployment target rather than a development workspace.

👉 See **[12 — Deployment Workflow](docs/12_Deployment_Workflow.md)**.

---

## 📂 Repository Structure

The repository is organized around implementation, testing, deployment and documentation.

```text
Enterprise-SQL-Platform-Lab
│
├── README.md
│
├── docs/
│   ├── 00_Project_Vision.md
│   ├── 01_Architecture.md
│   ├── 02_Engineering_Methodology.md
│   ├── 03_Platform_Foundations.md
│   ├── 05_Metadata_Capability.md
│   ├── 07_Data_Ingestion_Capability.md
│   ├── 07_Data_Storage_Capability.md
│   ├── 08_Business_Consumption.md
│   ├── 09_Platform_Governance.md
│   ├── 11_Database_Development_Workflow.md
│   ├── 12_Deployment_Workflow.md
│   ├── 13_Testing_Workflow.md
│   ├── 14_Security_Architecture.md
│   ├── 15_Security_Testing.md
│   ├── 16_Git_Development_Workflow.md
│   └── 17_Sprint_Plan_and_Project_History.md
│
├── database/
├── deployment/
├── tests/
├── docker/
├── datasets/
├── architecture/
└── images/
```

The README is the project landing page.

The `docs/` directory is the detailed engineering reference.

🌿 Git history records implementation changes.

📋 Sprint history records how the platform evolved.

---

# 📚 Documentation

## 🧭 Start Here

New to the project? Follow this sequence:

| Document | Purpose |
|---|---|
| 📖 [`00_Project_Vision.md`](docs/00_Project_Vision.md) | Project purpose, direction and guiding principles |
| 🏗 [`01_Architecture.md`](docs/01_Architecture.md) | Platform architecture and major boundaries |
| 🧠 [`02_Engineering_Methodology.md`](docs/02_Engineering_Methodology.md) | Engineering approach and working principles |
| 🧱 [`03_Platform_Foundations.md`](docs/03_Platform_Foundations.md) | Core platform foundations |
| 🗄️ [`11_Database_Development_Workflow.md`](docs/11_Database_Development_Workflow.md) | How database changes are developed |
| 🌿 [`16_Git_Development_Workflow.md`](docs/16_Git_Development_Workflow.md) | Git, commits and development workflow |
| 📋 [`17_Sprint_Plan_and_Project_History.md`](docs/17_Sprint_Plan_and_Project_History.md) | Complete Sprint 1–11 project history |

## 🧩 Capability Documentation

| Document | Capability |
|---|---|
| 🗂 [`05_Metadata_Capability.md`](docs/05_Metadata_Capability.md) | Database metadata and inspection |
| 📥 [`07_Data_Ingestion_Capability.md`](docs/07_Data_Ingestion_Capability.md) | Staging and ingestion |
| 💾 [`07_Data_Storage_Capability.md`](docs/07_Data_Storage_Capability.md) | Staging and warehouse storage |
| 📊 [`08_Business_Consumption.md`](docs/08_Business_Consumption.md) | Reporting and business-facing database consumption |
| 🛡️ [`09_Platform_Governance.md`](docs/09_Platform_Governance.md) | Governance and change control |

## ⚙️ Engineering and Operational Documentation

| Document | Purpose |
|---|---|
| 🚀 [`12_Deployment_Workflow.md`](docs/12_Deployment_Workflow.md) | Deployment process |
| 🧪 [`13_Testing_Workflow.md`](docs/13_Testing_Workflow.md) | Testing process |
| 🔐 [`14_Security_Architecture.md`](docs/14_Security_Architecture.md) | Security architecture |
| 🛡️ [`15_Security_Testing.md`](docs/15_Security_Testing.md) | Security validation |
| 🌿 [`16_Git_Development_Workflow.md`](docs/16_Git_Development_Workflow.md) | Git workflow |
| 📋 [`17_Sprint_Plan_and_Project_History.md`](docs/17_Sprint_Plan_and_Project_History.md) | Sprint history and delivery milestones |

---

## 📈 Current State

The platform has progressed from foundational SQL Server development into a structured engineering solution.

Today, the repository provides a source-controlled database implementation with:

```text
Database Project
      +
DACPAC Deployment
      +
Security Provisioning
      +
Functional Testing
      +
Security Testing
      +
Git Workflow
      +
Engineering Documentation
```

The platform is intentionally designed so that future capabilities can be added without changing the underlying engineering principles.

---

## 🔮 Future State

The following capabilities are intentionally identified as future evolution rather than current implementation.

### ⚙️ Automation

- CI/CD pipelines;
- automated quality gates;
- automated deployment;
- automated security provisioning;
- automated drift detection.

### 📊 Business Consumption

- Power BI semantic models;
- Power BI reports;
- Power BI dashboards;
- APIs and data services;
- additional analytical consumers.

### 🧠 Metadata and Operations

- richer metadata management;
- automated lineage;
- data dictionary capabilities;
- deployment audit reporting;
- broader observability;
- performance and storage monitoring.

Future capabilities should be introduced when there is a genuine engineering or business requirement.

---

## 🛠 Technology Stack

| Layer | Technology |
|---|---|
| 💻 Operating System | Windows 11 |
| 🐳 Container Platform | Docker |
| 🗄️ Database Engine | SQL Server 2022 Developer Edition |
| 🛠 Administration | SQL Server Management Studio |
| 🧩 Database Projects | SQL Server Database Projects / SSDT |
| 📦 Deployment | DACPAC |
| 🌿 Source Control | Git & GitHub |
| 📊 Analytics | Power BI — Future State |
| 📝 Documentation | Markdown |

---

## ⭐ Engineering Principles

- 🏗 **Infrastructure as Code**
- 🧩 **Capability-driven architecture**
- 🧠 **Manual understanding before automation**
- 🔐 **Security by design**
- 🧪 **Test behaviour, not just structure**
- 🔁 **Reproducible engineering environments**
- 📚 **Documentation as code**
- 🎯 **Best practices over shortcuts**
- 🔎 **Inspect before assuming**
- 📦 **Deploy repeatably**
- 🌿 **Source control as the source of truth**

---

## 🗺️ Project History

The project has evolved through eleven structured sprints.

```text
Sprints 1–8
    |
    v
Platform foundations, database development,
storage, ingestion, security and validation

Sprint 9
    |
    v
Security architecture and implementation maturity

Sprint 10
    |
    v
Security validation, deployment readiness
and platform hardening

Sprint 11
    |
    v
Documentation, governance and engineering
knowledge consolidation
```

For the complete reconstruction of Sprint 1 through Sprint 11, see:

👉 **[17 — Sprint Plan and Project History](docs/17_Sprint_Plan_and_Project_History.md)**

---

## 🤝 Contributions

This repository is primarily an engineering learning and platform-development project.

The emphasis is on disciplined implementation, reproducibility, documentation and engineering practice.

Suggestions and constructive discussion are welcome.

---

## 👤 Author

**GreenPear Labs**

*Enterprise SQL Engineering from First Principles*

---

<div align="center">

**Enterprise SQL Platform Lab**

Designed and engineered with a focus on modern SQL Server engineering, enterprise data platform architecture, security, reproducible development and infrastructure as code.

<br>

<a href="docs/00_Project_Vision.md"><img src="https://img.shields.io/badge/📖%20Read%20the%20Docs-Start%20Here-0969DA?style=for-the-badge" alt="Read the Docs"></a>
<a href="docs/17_Sprint_Plan_and_Project_History.md"><img src="https://img.shields.io/badge/📋%20Explore%20the%20Sprints-Sprint%201--11-6F42C1?style=for-the-badge" alt="Explore the Sprints"></a>
<a href="docs/16_Git_Development_Workflow.md"><img src="https://img.shields.io/badge/🌿%20Development-Git%20Workflow-238636?style=for-the-badge" alt="Git Workflow"></a>

### ⭐ If you found this repository useful, consider giving it a star.

**Happy Engineering! 🚀**

</div>
