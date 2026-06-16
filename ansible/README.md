# Ansible Homelab Infrastructure

This repository contains the Ansible playbooks and roles for managing the homelab infrastructure.

## Structure

- `inventory/hosts.ini`: Contains the list of hosts and their respective groups.
- `playbooks/`: Contains the main playbooks to apply configurations to specific groups of hosts.
- `roles/`: Modular configurations for different applications and services.
- `group_vars/`: Global and group-specific variables.

## Important Roles

### 1. Database (`roles/database`)
Installs and configures PostgreSQL (and potentially other databases like MongoDB).
*Note: This role was formerly named `postgres` but was renamed to represent the broader database server.*

### 2. Backup (`roles/backup`)
Configures an automated daily backup system for both the PostgreSQL databases and the Docker Compose configurations.

**Features:**
- Dumps PostgreSQL databases using `pg_dump` and `pg_dumpall`.
- Clones the private `docker-files` repository using SSH keys to backup the latest configurations.
- Syncs the backups to Google Drive using `rclone`.
- Enforces local retention (1 day) and remote retention (7 days).

## Variables and Secrets

Sensitive variables, such as the `rclone_gdrive_token`, are stored in `group_vars/all/secrets.yml`. 
You can use `ansible-vault` to encrypt this file:
```bash
ansible-vault encrypt group_vars/all/secrets.yml
```

When running playbooks, use the `--ask-vault-pass` flag to decrypt the secrets.

## Running Playbooks

Example: To configure the database server and install the backup scripts:
```bash
ansible-playbook -i inventory/hosts.ini playbooks/databases.yml --ask-vault-pass
```
