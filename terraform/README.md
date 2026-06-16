# Terraform Homelab Infrastructure

This directory contains the Terraform configurations used to provision LXC containers and VMs on Proxmox for the homelab.

## Structure

The infrastructure is broken down into separate environments to minimize the "blast radius" during state changes.

- `environments/homelab/`: The root of the homelab environment.
  - `secrets.auto.tfvars`: The central source of truth for all Proxmox API tokens, URLs, and SSH keys.
  - `applications/`: Provisions application servers like Plex Media Server, Jenkins, and Docker hosts.
  - `databases/`: Provisions the database server (PostgreSQL/MongoDB).
  - `networking/`: Provisions the reverse proxy (Traefik).

## Secrets Management

To prevent duplicating sensitive credentials, the `environments/homelab/secrets.auto.tfvars` file holds all the shared variables:
```hcl
proxmox_api_url      = "..."
proxmox_token_id     = "..."
proxmox_token_secret = "..."
ssh_public_key_path  = "..."
```

Each sub-environment (`applications`, `databases`, `networking`) contains a **symbolic link** (`secrets.auto.tfvars -> ../secrets.auto.tfvars`). Terraform automatically loads these variables when you run commands inside the sub-environment.

## Deployment Workflow

To deploy or update a specific component:

1. Navigate to the component's directory:
   ```bash
   cd environments/homelab/databases
   ```
2. Initialize Terraform (if not already done):
   ```bash
   terraform init
   ```
3. Plan and apply:
   ```bash
   terraform apply
   ```

*Terraform will automatically read the `secrets.auto.tfvars` symlink and any local `terraform.tfvars` specific to that environment.*
