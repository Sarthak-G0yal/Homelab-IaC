# Homelab Infrastructure as Code

This repository manages the complete lifecycle of my homelab — from bare-metal VM/LXC provisioning with Terraform to service configuration with Ansible, K3s Kubernetes cluster setup, and declarative Kubernetes workload management.

## Stack

| Layer | Tool | Purpose |
|---|---|---|
| Provisioning | Terraform (`bpg/proxmox`) | Creates LXC containers and Cloud-Init VMs on Proxmox VE |
| Configuration | Ansible | Installs and configures services on provisioned hosts |
| Kubernetes Infra | Ansible (`install-k3s`) | Deploys a K3s cluster on dedicated VMs |
| Kubernetes Workloads | kubectl manifests | Deploys apps and observability stack into the cluster |

## Current Services

| Service | Type | Category |
|---|---|---|
| Technitium DNS | LXC | Networking |
| Traefik Reverse Proxy | LXC | Networking |
| PostgreSQL | LXC | Database |
| Plex / Jellyfin | LXC | Media |
| Jenkins CI/CD | LXC | Application |
| Server Docker | LXC | Application |
| Gitea | LXC | Infrastructure |
| BastionVault | LXC | Infrastructure |
| k3s-control | VM | Kubernetes |
| k3s-worker-1 | VM | Kubernetes |

## Kubernetes Cluster

The K3s cluster runs on Ubuntu 24.04 Cloud-Init VMs provisioned via Terraform. Ansible provisions the cluster using the `install-k3s` role and `playbooks/k3s.yaml`. Workloads are declared in `k8s/`.

**Cluster nodes:**
- `k3s-control` — Control plane
- `k3s-worker-1` — Worker node

**Applications running in cluster:**
- ASAP (frontend + backend)
- Firefly III
- Uptime Kuma
- Prometheus, Grafana, Loki, Alloy (observability stack)

## Quick Start

### 1. Provision Infrastructure
```bash
cd terraform/environments/homelab118
terraform init
terraform apply
```

### 2. Configure Services
```bash
cd ansible
ansible-playbook -i inventory/hosts.ini playbooks/k3s.yaml       # K3s cluster
ansible-playbook -i inventory/hosts.ini playbooks/databases.yml   # Databases
```

### 3. Deploy Kubernetes Workloads
```bash
kubectl apply -f k8s/namespace/
kubectl apply -f k8s/apps/asap/
kubectl apply -f k8s/apps/firefly3/
kubectl apply -f k8s/apps/uptimekuma/
kubectl apply -f k8s/observability/prometheus/
kubectl apply -f k8s/observability/loki/
kubectl apply -f k8s/observability/alloy/
kubectl apply -f k8s/observability/grafana/
```

Kubernetes Secret manifests are required for workloads that use credentials. Do not document secret values in README files; keep them in local secret manifests or an external secret management workflow.

## SSH Key Setup

```bash
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_proxmox -C "homelab"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519_proxmox
```

Add to `~/.ssh/config`:
```sshconfig
Host 192.168.1.*
   User root
   IdentityFile ~/.ssh/id_ed25519_proxmox
   ForwardAgent yes
```

## Notes

- `secrets.auto.tfvars` is gitignored — copy from `.example` template.
- Ansible secrets stored in `inventory/group_vars/all/` — encrypt with `ansible-vault`.
- Docker-in-LXC (Jenkins, Server Docker) requires `keyctl` to be enabled on the Proxmox host:
  ```bash
  pct set <vmid> -features keyctl=1
  ```
