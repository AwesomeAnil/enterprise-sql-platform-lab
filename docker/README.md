# Docker SQL Server Environment

## Purpose

This directory defines the containerised SQL Server environment used for
integration, deployment and platform validation.

The Docker environment provides a reproducible SQL Server runtime for the
Enterprise SQL Platform Lab.

## SQL Server

- Image: `mcr.microsoft.com/mssql/server:2022-latest`
- Edition: Developer
- Container port: `1433`
- Host port: `1434` during initial validation
- Dataset mount: `../datasets:/var/opt/mssql/import`

## Prerequisites

- Docker Desktop
- Git
- A valid SQL Server SA password

## Configuration

Copy:

```text
.env.example