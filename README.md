# Homelab Infrastructure as Code

This repository contains the Infrastructure as Code (IaC) for my personal homelab. It uses Terraform to provision infrastructure on Proxmox VE and Ansible to configure and manage the operating systems and services running within the environment.

The objective of this project is to build and maintain a production-inspired homelab using modern infrastructure engineering practices. Every component is managed as code to ensure the environment is reproducible, version controlled, and easy to maintain.

## Overview

This repository is responsible for provisioning and managing the homelab infrastructure, including:

* Provisioning LXC containers on Proxmox
* Managing networking and core infrastructure services
* Configuring operating systems with Ansible
* Deploying and maintaining self-hosted applications
* Providing reusable Terraform modules
* Maintaining a scalable repository structure for future services

## Current Infrastructure

### Networking

* Technitium DNS Server
* Traefik Reverse Proxy

### Infrastructure

* BastionVault
* Docker Host
* Kubernetes Host

### Databases

* PostgreSQL
* MongoDB

### Applications

* Gitea
* Jenkins
* Plex Media Server

Additional services will be incorporated as the homelab evolves.

## Repository Structure

```text
infra/
├── terraform/
│   ├── environments/
│   │   └── homelab118/
│   ├── modules/
│   │   └── lxc/
│   └── services/
│       ├── bastionvault/
│       ├── databases/
│       ├── dns/
│       ├── gitea/
│       ├── jenkins/
│       ├── media/
│       ├── reverseproxy/
│       └── server-docker/
│
├── ansible/
│   ├── inventory/
│   ├── playbooks/
│   └── roles/
│
├── configs/
├── docs/
└── README.md
```

## Design Principles

The repository is organized around the following principles:

* Infrastructure should be reproducible.
* Configuration should be version controlled.
* Services should remain isolated from one another.
* Infrastructure provisioning and configuration management should be clearly separated.
* New services should be added with minimal impact on existing deployments.
* The repository should scale as the homelab grows.

## Terraform Architecture

Terraform is used to provision the infrastructure.

The repository consists of:

* A single environment (`homelab118`)
* Reusable infrastructure modules
* A dedicated service directory for each workload
* A root environment that manages dependencies between services

This structure allows the entire environment to be provisioned with a single `terraform apply` while also supporting the deployment of individual services when required.

## Configuration Management

Ansible is used after infrastructure provisioning to configure each system by:

* Installing required packages
* Configuring operating systems
* Managing Docker hosts
* Deploying application-specific configuration
* Applying system updates
* Executing reusable roles across multiple services

## Secrets Management

Infrastructure secrets are currently supplied through `secrets.auto.tfvars`, while Ansible uses encrypted group variables.

The planned approach is to migrate infrastructure and application secrets to BastionVault, allowing Terraform, Ansible, Docker, and future CI/CD pipelines to retrieve credentials from a centralized secrets management platform.

## Roadmap

Planned improvements include:

* Remote Terraform state backend
* State locking
* BastionVault integration
* CI/CD automation
* Kubernetes cluster provisioning
* Automated backups
* Monitoring and observability
* Multi-environment support
* GitOps-based deployments

## Purpose

This repository serves as the source of truth for my personal homelab.

It is also an ongoing infrastructure engineering project where I explore technologies such as Terraform, Ansible, Proxmox, Docker, Kubernetes, observability, secrets management, and automation while applying practices commonly used in production environments.

As the homelab evolves, this repository evolves with it, documenting the infrastructure, automation, and operational decisions that support the environment.
