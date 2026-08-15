# 🚀 Enterprise SQL Platform Lab

<div align="center">

![SQL Server](https://img.shields.io/badge/SQL%20Server-2022-red?style=for-the-badge&logo=microsoftsqlserver)
![Docker](https://img.shields.io/badge/Docker-Containerized-2496ED?style=for-the-badge&logo=docker)
![Windows](https://img.shields.io/badge/Windows-11-0078D6?style=for-the-badge&logo=windows)
![GitHub](https://img.shields.io/badge/GitHub-Version_Control-181717?style=for-the-badge&logo=github)
![SSDT](https://img.shields.io/badge/SSDT-Database_Projects-68217A?style=for-the-badge)
![Power BI](https://img.shields.io/badge/Power_BI-Integration-F2C811?style=for-the-badge&logo=powerbi)

**Enterprise SQL Engineering from First Principles**

*Build • Understand • Test • Inspect • Document • Automate*

---

*A complete engineering playbook for building modern SQL Server platforms using Docker, SQL Server Developer Edition, SSDT, DACPACs, CI/CD and enterprise data warehouse design.*

</div>

---

# 📖 Why This Repository Exists

Most SQL Server tutorials teach isolated technologies.

- Learn Docker
- Learn SQL
- Learn SSDT
- Learn CI/CD

Real enterprise data platforms are built differently.

Infrastructure, administration, metadata, data ingestion, dimensional modeling, deployment and governance are engineered together as one integrated platform.

This repository documents that engineering journey from the ground up.

Every component is:

✅ Built manually

✅ Understood conceptually

✅ Tested

✅ Inspected

✅ Documented

✅ Automated

The result is not another SQL tutorial.

It is an **Enterprise SQL Engineering Playbook**.

---

# 🎯 Project Objectives

- Build SQL Server Developer Edition inside Docker
- Learn SQL Server administration
- Design an enterprise data warehouse
- Build metadata-driven ETL
- Implement dimensional modeling
- Create SSDT Database Projects
- Deploy using DACPACs
- Automate deployments with GitHub Actions
- Apply enterprise engineering best practices

---

# 🏗 Enterprise Platform Architecture

```text
                    Windows 11
                         │
                         ▼
                  Docker Desktop
                         │
                         ▼
                SQL Server Developer
                         │
        ┌────────────────┼────────────────┐
        ▼                ▼                ▼
    sql-dev          sql-test          sql-dw
                         │
                         ▼
                     SalesDW
                         │
 ┌──────────────┬──────────────┬──────────────┐
 ▼              ▼              ▼              ▼
Metadata      Staging      Warehouse      Reporting
```

---

# 🧠 Engineering Methodology

Every component in this repository follows the same methodology.

```text
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

Automation is never introduced before understanding.

---

# 🏛 Enterprise Capability Model

Rather than building isolated SQL objects, this repository builds complete engineering capabilities.

| Capability | Status |
|------------|--------|
| Metadata Capability | ✅ |
| Data Ingestion Capability | 🚧 |
| Data Storage Capability | ⏳ |
| Business Consumption Capability | ⏳ |
| Platform Governance Capability | ⏳ |

---

# 📂 Repository Structure

```text
Enterprise-SQL-Platform-Lab

│
├── README.md
│
├── docs
│     │
│     ├── 00_Project_Vision.md
│     ├── 01_Architecture.md
│     ├── 02_Engineering_Methodology.md
│     ├── 03_Platform_Foundation.md
│     ├── 04_SQL_Server_Administration.md
│     ├── 05_Metadata_Capability.md
│     ├── 06_Data_Ingestion_Capability.md
│     ├── 07_Data_Storage_Capability.md
│     ├── 08_Business_Consumption.md
│     └── 09_Platform_Governance.md
│
├── docker
├── sql
├── scripts
├── architecture
├── datasets
└── images
```

---

# 📚 Learning Progression

The repository follows a structured engineering progression.

```text
Platform (Docker)

        ↓

SQL Server Instance

        ↓

Administration

        ↓

Database

        ↓

Schemas

        ↓

Operational Metadata

        ↓

Data Ingestion

        ↓

Dimensions

        ↓

Facts

        ↓

Reporting

        ↓

SSDT

        ↓

DACPAC

        ↓

Docker Compose

        ↓

CI/CD
```

---

# 🗂 Current Data Warehouse Architecture

```text
SalesDW

├── metadata
│     ├── ETL_RunHistory
│     ├── PipelineConfiguration
│     └── Watermark
│
├── staging
│     └── Customer
│
├── warehouse
│     └── DimCustomer
│
├── reporting
│
└── audit
```

---

# 🛠 Technology Stack

| Layer | Technology |
|---------|------------|
| Operating System | Windows 11 |
| Container Platform | Docker Desktop |
| Database Engine | SQL Server 2022 Developer Edition |
| Administration | SQL Server Management Studio |
| Database Projects | SSDT |
| Deployment | DACPAC |
| Source Control | Git & GitHub |
| Analytics | Power BI Desktop |
| Spreadsheet Integration | Microsoft Excel |

---

# 🚀 Project Roadmap

- [x] Docker Platform
- [x] SQL Server Container
- [x] SQL Server Administration
- [x] SalesDW
- [x] Enterprise Schemas
- [x] Metadata Capability
- [x] Data Ingestion
- [ ] Fact Tables
- [ ] Reporting Layer
- [ ] SSDT
- [ ] DACPAC
- [ ] Docker Compose
- [ ] CI/CD
- [ ] GitHub Actions

---

# ⭐ Engineering Principles

- Infrastructure as Code
- Capability-driven architecture
- Metadata-driven ETL
- Enterprise-first design
- Manual understanding before automation
- Reproducible engineering environments
- Documentation as code
- Best practices over shortcuts

---

# 🤝 Contributions

This repository is intended as an educational engineering project demonstrating modern SQL Server platform development and enterprise data warehouse engineering practices.

Contributions, discussions and suggestions are welcome.

---

---

## 👤 Author

**Anil Jacob**

*Enterprise Decision Intelligence & Governance Leader | Commercial Excellence | Revenue Intelligence | Business Intelligence | Data Platform Engineering*

📌 **LinkedIn:** https://www.linkedin.com/in/anil-jacobs

💻 **GitHub:** https://github.com/awesomeanil

---

<div align="center">

**Enterprise SQL Platform Lab**

Designed and engineered with a focus on modern SQL Server engineering, enterprise data platform architecture, and infrastructure as code.

### ⭐ If you found this repository useful, consider giving it a star.

**Happy Engineering! 🚀**

