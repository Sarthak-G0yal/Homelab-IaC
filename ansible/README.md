# Ansible — Homelab Configuration Management

Configures all homelab services after Terraform provisioning. Playbooks are organized per service; roles are reusable.

## Playbooks

| Playbook | Purpose |
|---|---|
| `k3s.yaml` | Deploy K3s control plane and worker nodes |
| `k8s-master.yaml` | Post-K3s master node configuration |
| `databases.yml` | Install PostgreSQL & MongoDB & rclone backup config|
| `reverse-proxy.yml` | Install and configure Traefik |
| `dns.yml` | Install Technitium DNS |
| `gitea.yaml` | Install Gitea |
| `server-docker.yml` | Install Docker CE |
| `streaming.yml` | Install Plex / Jellyfin |
| `bastion-vault.yml` | Install BastionVault |

## Key Roles

- **`install-k3s`** — Installs K3s server and agent. Configures UFW firewall ports (`6443`, `8472`, `10250`, pod/service CIDRs), provisions the server, extracts node-token, registers workers, and labels them with `node-role.kubernetes.io/worker=worker`.
- **`install-docker`** — Installs Docker CE.
- **`postgres`** — Installs and initializes PostgreSQL.
- **`traefik`** — Deploys Traefik as a reverse proxy with TLS.
- **`technitium`** — Installs Technitium DNS server.
- **`backup`** — Automated database + config backups synced via rclone.
- **`bastionvault`** — HashiCorp Vault deployment.

## Inventory

Hosts are defined in `inventory/hosts.ini`. Relevant groups:
- `[k3s_server]` — K3s control plane node
- `[k3s_agents]` — K3s worker nodes

Global variables live in `inventory/group_vars/all/main.yml`.

## Running

```bash
# Deploy K3s cluster
ansible-playbook -i inventory/hosts.ini playbooks/k3s.yaml

# Deploy a specific service
ansible-playbook -i inventory/hosts.ini playbooks/databases.yml
```
