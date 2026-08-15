# 🚀 Enterprise SQL Platform Lab

> **An enterprise-grade SQL Server platform engineering laboratory demonstrating architecture, database engineering, security, deployment, governance, reproducible development, and disciplined Git-based delivery.**

<br>

[![SQL Server](https://img.shields.io/badge/SQL%20Server-2022-red?logo=microsoftsqlserver&logoColor=white)](#)
[![Docker](https://img.shields.io/badge/Docker-Enabled-2496ED?logo=docker&logoColor=white)](#)
[![Database Project](https://img.shields.io/badge/Database%20Project-DACPAC-blue)](#)
[![Git](https://img.shields.io/badge/Git-Development%20Workflow-F05032?logo=git&logoColor=white)](#)
[![Documentation](https://img.shields.io/badge/Documentation-Complete-success)](#)
[![Project](https://img.shields.io/badge/Project-Sprints%201--11-purple)](#)

---

## 🧭 Engineering Documentation Portal

Welcome to the **Enterprise SQL Platform Lab** documentation portal.

This site provides a structured navigation layer across the project's architecture, engineering practices, platform capabilities, database development, deployment, security, governance, Git workflow, local Docker environment, and complete Sprint 1–11 project history.

### 🎯 Start Here

| | Area | Purpose |
|---|---|---|
| 🎯 | **Project Vision** | Why the platform exists, what it is intended to demonstrate, and the engineering objectives |
| 🏗️ | **Architecture** | Platform architecture, design principles, components, boundaries, and relationships |
| ⚙️ | **Engineering** | Development methodology, standards, workflows, and engineering practices |
| 🧱 | **Platform Capabilities** | Metadata, ingestion, storage, consumption, and governance capabilities |
| 🗄️ | **Database Engineering** | Database development, deployment, testing, and operational workflows |
| 🔐 | **Security** | Security architecture, database security model, roles, permissions, and security testing |
| 🐳 | **Local Development** | Reproducible SQL Server development environment using Docker |
| 🌱 | **Git & Delivery** | Git development workflow, commits, branches, releases, and Sprint delivery |
| 📅 | **Project History** | Detailed Sprint 1–11 journey and engineering evolution |

---

# 🎯 Project Vision

### [🎯 00 — Project Vision](00_Project_Vision.md)

The strategic foundation of the Enterprise SQL Platform Lab.

Covers:

- Project purpose
- Engineering objectives
- Platform vision
- Intended outcomes
- Scope and boundaries

---

# 🏗️ Architecture & Engineering

## 🏛️ Architecture

### [🏗️ 01 — Architecture](01_Architecture.md)

The high-level platform architecture and architectural principles.

### [🗺️ 10 — Architecture Overview](10_Architecture_Overview.md)

A consolidated architectural view of the platform and its major components.

---

## ⚙️ Engineering Methodology

### [⚙️ 02 — Engineering Methodology](02_Engineering_Methodology.md)

The engineering principles, standards, practices, and disciplined delivery approach used throughout the project.

### [🧱 03 — Platform Foundations](03_Platform_Foundations.md)

The foundational platform components and engineering decisions on which the solution is built.

### [🔧 04 — Platform Operations](04_Platform_Operations.md)

Operational practices supporting development, administration, deployment, and platform management.

---

# 🧩 Platform Capabilities

The platform capabilities describe **what the engineering platform actually implements**.

| Capability | Documentation |
|---|---|
| 🧭 **Metadata** | [05 — Metadata Capability](05_Metadata_Capability.md) |
| 📥 **Data Ingestion** | [06 — Data Ingestion Capability](06_Data_Ingestion_Capability.md) |
| 🗄️ **Data Storage** | [07 — Data Storage Capability](07_Data_Storage_Capability.md) |
| 📊 **Business Consumption** | [08 — Business Consumption](08_Business_Consumption.md) |
| 🛡️ **Platform Governance** | [09 — Platform Governance](09_Platform_Governance.md) |

> 💡 **Future State:** Business intelligence and broader consumption capabilities such as Power BI semantic models, dashboards, reports, and APIs are identified as future-state extensions where they have not yet been implemented.

---

# 🗄️ Database Engineering

The database engineering documentation captures the complete lifecycle from development through deployment and testing.

### 🛠️ [11 — Database Development Workflow](11_Database_Development_Workflow.md)

How database changes are designed, developed, validated, built, and prepared for deployment.

### 🚀 [12 — Deployment Workflow](12_Deployment_Workflow.md)

How database artefacts move through the deployment lifecycle.

### 🧪 [13 — Testing Workflow](13_Testing_Workflow.md)

How database functionality, deployment behaviour, and platform components are validated.

---

# 🔐 Security

Security is treated as an engineering capability rather than an afterthought.

### 🏰 [14 — Security Architecture](14_Security_Architecture.md)

Covers:

- Logins
- Users
- Database roles
- Permissions
- Role membership
- Schemas
- Row-Level Security
- Security boundaries

### 🧪 [15 — Security Testing](15_Security_Testing.md)

Documents the security validation approach and tests used to verify the implemented security model.

---

# 🐳 Local Development Environment

## 🐳 Docker SQL Server Environment

The repository includes a reproducible SQL Server development environment using Docker.

### [🐳 Docker Environment README](../docker/README.md)

The Docker environment provides:

- SQL Server 2022 Developer Edition
- Docker Compose configuration
- Persistent SQL Server storage
- Environment-based credentials
- Local development connectivity
- Database project deployment support

### 📦 Docker Repository Artefacts

```text
docker/
├── .env.example
├── .gitignore
├── README.md
└── compose.yaml
```

### 🌱 Git Development & Delivery
🌱 16 — Git Development Workflow

Documents the Git-based engineering workflow, including:

Repository structure
Branching
Commits
Commit strategy
Sprint commit model
Feature development
Integration
Release discipline
📅 Project Journey
🏃 Sprint 1 → Sprint 11
📅 17 — Sprint Plan & Project History

The complete engineering journey of the project.

The Sprint history captures the progression from initial platform foundations through database engineering, security, Git development, documentation, repository engineering, and final platform presentation.

### 🧭 Sprint Journey

Sprint 01 ──► Platform Foundations
     │
Sprint 02 ──► Database Architecture & Development
     │
Sprint 03 ──► Database Engineering
     │
Sprint 04 ──► Data & ETL Capabilities
     │
Sprint 05 ──► Metadata & Platform Capabilities
     │
Sprint 06 ──► Security Engineering
     │
Sprint 07 ──► Testing & Validation
     │
Sprint 08 ──► Platform Engineering Maturity
     │
Sprint 09 ──► Engineering Workflow & Delivery
     │
Sprint 10 ──► Project Consolidation
     │
Sprint 11 ──► Documentation & Repository Completion
     │
     ▼
🏆 Enterprise SQL Platform Lab

### 📊 Data & Experimentation
#### 📁 Curated Datasets

The repository contains the project's curated datasets used for development and platform validation.

datasets/
├── calendar/
├── customer/
├── geography/
├── product/
├── sales/
├── salesperson/
└── territory/

### 🧪 Google Colab

The repository also contains the data-generation notebook used to support the project's dataset creation and experimentation.

🧪 Open Google Colab Assets

### 🗃️ Database Project

The SQL Server database project contains the source-controlled database implementation

database/
└── enterprise-sql-platform-lab/
    └── enterprise-sql-platform-lab.database/

### 🔄 Database Engineering Lifecycle

💡 Design
   ↓
🧑‍💻 Develop
   ↓
🔍 Validate
   ↓
🏗️ Build
   ↓
📦 DACPAC
   ↓
🚀 Deploy
   ↓
🧪 Test


## 🧭 How to Navigate This Documentation
#### 👋 New to the project?

Start with:

🎯 Project Vision
↓
🏗️ Architecture
↓
⚙️ Engineering Methodology
↓
🧱 Platform Foundations

#### 👨‍💻 Interested in database engineering?

Start with:

🗄️ Database Development Workflow
↓
🚀 Deployment Workflow
↓
🧪 Testing Workflow

#### 🔐 Interested in security?

Start with:

🏰 Security Architecture
↓
🧪 Security Testing

#### 🐳 Want to run the platform locally?

Start with:

🐳 Docker Environment

#### 🌱 Want to understand how the project was delivered?

Start with:

🌱 Git Development Workflow
↓
📅 Sprint Plan & Project History

### 🏆 The Engineering Story

This project is more than a collection of SQL scripts.

It demonstrates an end-to-end engineering discipline:

🎯 Vision
   │
   ▼
🏗️ Architecture
   │
   ▼
⚙️ Engineering Methodology
   │
   ▼
🧱 Platform Foundations
   │
   ▼
🧩 Platform Capabilities
   │
   ▼
🗄️ Database Engineering
   │
   ▼
🔐 Security
   │
   ▼
🧪 Testing
   │
   ▼
🚀 Deployment
   │
   ▼
🌱 Git & Delivery
   │
   ▼
📅 Sprint Execution
   │
   ▼
📚 Engineering Documentation
   │
   ▼
🏆 Enterprise SQL Platform Lab

### 🧭 Repository Navigation

| 📚 Resource                          | 🔗 Purpose                                      |
| ------------------------------------ | ----------------------------------------------- |
| 📖 [Repository README](../README.md) | Project introduction and repository orientation |
| 📚 [Documentation](.)                | Engineering documentation portal                |
| 🗄️ [Database](../database/)         | SQL Server database project                     |
| 📊 [Datasets](../datasets/)          | Curated platform datasets                       |
| 🐳 [Docker](../docker/)              | Reproducible SQL Server development environment |
| 🧪 [Google Colab](../google-colab/)  | Data generation and experimentation             |
| 🖼️ [Images](../images/)             | Project documentation visuals                   |


### 🚀 Final Destination
**Build it. Secure it. Test it. Deploy it. Document it.**

The Enterprise SQL Platform Lab brings together the engineering disciplines required to build and operate a structured SQL Server data platform — from architectural vision through implementation, security, deployment, Git-based delivery, and project history.

Welcome to the lab. 🏗️ 🗄️ 🔐 🧪 🚀


🏆 Enterprise SQL Platform Lab
    by Anil Jacob | [![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0A66C2?logo=linkedin&logoColor=white)](https://www.linkedin.com/in/anil-jacobs/)
[![GitHub](https://img.shields.io/badge/GitHub-View%20Profile-181717?logo=github&logoColor=white)](https://github.com/AwesomeAnil)

Architecture • Engineering • Security • Data • Deployment • Governance

</p> ```













