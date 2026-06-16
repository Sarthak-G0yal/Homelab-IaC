# Homelab Infrastructure as Code

This repository manages a modular Homelab environment on Proxmox using **Terraform** for LXC provisioning and **Ansible** for configuration management. It is designed around modular, category-based deployments to maintain a small state "blast radius" and clear separation of concerns.

## Current Services

- **Networking**: Dedicated reverse proxy container running Traefik (VMID 110).
- **Databases**: Unified database server running PostgreSQL 16 and MongoDB 4.4 (VMID 300).
- **Applications**: 
  - Plex Media Server running in a Privileged LXC with Intel QuickSync GPU Passthrough and UFW firewall (VMID 202).
  - Jenkins CI/CD Server running in an Unprivileged LXC with Docker-in-LXC (VMID 207).

## Repository Structure

```text
infra/
├── terraform/
│   ├── environments/
│   │   └── homelab/
│   │       ├── secrets.auto.tfvars        # Centralized secrets (API keys, SSH paths)
│   │       ├── applications/              # Plex Media Server
│   │       │   ├── main.tf
│   │       │   ├── secrets.auto.tfvars -> ../secrets.auto.tfvars
│   │       │   └── terraform.tfvars       # App-specific configs
│   │       ├── databases/                 # Postgres & MongoDB
│   │       │   ├── main.tf
│   │       │   └── secrets.auto.tfvars -> ../secrets.auto.tfvars
│   │       └── networking/                # Traefik Reverse Proxy
│   │           ├── main.tf
│   │           └── secrets.auto.tfvars -> ../secrets.auto.tfvars
│   └── modules/
│       └── lxc/                           # Reusable Proxmox LXC Module
├── ansible/
│   ├── ansible.cfg
│   ├── inventory/
│   │   ├── hosts.ini                      # Defines [databases], [applications], [reverse_proxy]
│   │   ├── group_vars/                    # Configs like Traefik routing
│   │   │   └── all/
│   │   │       ├── main.yml               # Base variables
│   │   │       └── secrets.yml            # Centralized Ansible Secrets (IPs, DB passwords)
│   ├── playbooks/
│   │   ├── applications.yml               # Runs Plex & Jenkins roles
│   │   ├── databases.yml                  # Runs Postgres & MongoDB roles
│   │   └── reverse-proxy.yml              # Runs Traefik role
│   └── roles/
│       ├── jenkins/                       # Installs Java 21, Jenkins, Docker for CI/CD
│       ├── mongodb/                       # Installs MongoDB 4.4 (Non-AVX compatible)
│       ├── plex/                          # Installs Plex & UFW, configures QuickSync groups
│       ├── backup/                        # Configures automated daily backups
│       ├── database/                      # Installs Postgres 16, configures SCRAM-SHA-256
│       └── traefik/                       # Installs Traefik natively
└── README.md
```

## Terraform Architecture: Centralized Variables

To prevent duplicating sensitive API tokens and Proxmox credentials across multiple Terraform states, we use a centralized `secrets.auto.tfvars` file located at `terraform/environments/homelab/secrets.auto.tfvars`.

Each subdirectory (`applications/`, `databases/`, `networking/`) contains a **symbolic link** to this central file. 
When you run `terraform apply` inside any of the directories, Terraform automatically loads the global variables from the symlink, while allowing you to define local app configurations in the directory's specific `terraform.tfvars`.

## Ansible Architecture: Centralized Secrets

Similarly, Ansible is configured to use a single source of truth for all sensitive environment variables, credentials, and IP addresses. These are stored in `ansible/inventory/group_vars/all/secrets.yml`. 
Roles dynamically consume variables from this file, ensuring you only ever have to update an IP address or password in one place. It is highly recommended to encrypt this file using `ansible-vault`.

## Deployment Workflow

### 1. Provision Infrastructure (Terraform)
1. Navigate to the specific category you want to deploy (e.g., Databases):
   ```bash
   cd terraform/environments/homelab/databases
   ```
2. Ensure the `secrets.auto.tfvars` symlink exists and your local configurations are set.
3. Apply the infrastructure:
   ```bash
   terraform init
   terraform apply
   ```

> [!TIP]
> **Targeted Deployments (Create only what is needed)**: To prevent Terraform from checking or modifying other existing LXC containers that might have drifted, use the `-target` flag to only plan or apply a specific module (e.g., `server_docker`):
> ```bash
> terraform plan -target=module.server_docker
> terraform apply -target=module.server_docker
> ```
> This will ignore the rest of the containers and only focus on the target.

> [!IMPORTANT]
> **Importing Existing Containers**: If a container already exists on Proxmox but is not tracked in the current Terraform state (which would cause a collision or a recreate plan), import it before applying:
> ```bash
> terraform import module.<module_name>.proxmox_virtual_environment_container.this <node_name>/<vmid>
> ```
> For example, to import the Jenkins container on node `proxmox` with VMID `207`:
> ```bash
> terraform import module.jenkins.proxmox_virtual_environment_container.this proxmox/207
> ```
> *Note: If importing new modules, always run `terraform init` first to download the necessary provider blocks.*

*Note: If deploying the **Plex** LXC, you must manually add the Intel QuickSync device mappings to `/etc/pve/lxc/202.conf` on the Proxmox host after Terraform finishes.*


### 2. Configure Services (Ansible)
1. Navigate to the Ansible directory: `cd ansible`
2. Update the credentials and variables in `inventory/group_vars/` (e.g., `databases.yml`).
3. Run the corresponding playbook:
   ```bash
   ansible-playbook playbooks/databases.yml -i inventory/hosts.ini
   ```

---

## Bootstrap: SSH Agent Forwarding (Local -> LXC1 -> LXC2)

This workflow keeps the private key only on your local machine. LXC1 (`infra-mgmt`) stores the public key for Terraform to inject into new LXCs (LXC2), and Ansible uses SSH agent forwarding to authenticate without private keys on LXC1 or LXC2.

### 1. Local machine: create key + enable agent forwarding
Generate a dedicated ED25519 key for the homelab if it does not exist:
```bash
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_proxmox -C "homelab-proxmox"
```

Add a wildcard SSH config so all `192.168.1.*` hosts use the key and forward the agent:
```sshconfig
Host 192.168.1.*
   User root
   IdentityFile ~/.ssh/id_ed25519_proxmox
   IdentitiesOnly yes
   ForwardAgent yes
```

Start the agent and load the key:
```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519_proxmox
```

### 2. Local machine: authorize access to LXC1
Authorize your public key on LXC1 so you can log in:
```bash
ssh-copy-id -i ~/.ssh/id_ed25519_proxmox.pub root@192.168.1.150
```

### 3. Local machine -> LXC1: copy the public key for Terraform
Copy only the public key to LXC1 so Terraform can read it:
```bash
scp ~/.ssh/id_ed25519_proxmox.pub infra@192.168.1.150:~/.ssh/id_ed25519_proxmox.pub
```

### 4. LXC1 (infra-mgmt): Terraform key injection
Set the public key path used by Terraform in your `secrets.auto.tfvars`:
```hcl
ssh_public_key_path = "~/.ssh/id_ed25519_proxmox.pub"
```
Terraform injects this public key into each new LXC at creation time via the Proxmox initialization block. No private keys are stored on the LXCs.

### 5. LXC1 (infra-mgmt): Ansible with SSH agent forwarding
Ensure Ansible keeps agent forwarding enabled in `ansible.cfg`:
```ini
[ssh_connection]
ssh_args = -o ControlMaster=auto -o ControlPersist=60s -o ForwardAgent=yes -o IdentitiesOnly=no
```

### 6. Verify agent forwarding and key-only SSH
After logging into LXC1 with agent forwarding enabled:
```bash
infra@infra-mgmt:~$ ssh-add -l
infra@infra-mgmt:~$ cd ~/infra/ansible
infra@infra-mgmt:~$ ansible -m ping all -i inventory/hosts.ini
```

---

## Traefik Trust (Local Browser)
Since we are using a self-signed wildcard certificate for our homelab domain (`homelab118.home`), we must explicitly trust it on our local machine to remove browser security warnings.

```bash
# 1. Pull the newly generated cert to your local machine
scp root@192.168.1.122:/etc/traefik/certs/traefik.crt ./traefik.crt

# 2. Clean out old conflicting certs from Chrome's database
certutil -d sql:$HOME/.pki/nssdb -D -n "traefik" || true

# 3. Import the new correct cert into Chrome's trust store
certutil -d sql:$HOME/.pki/nssdb -A -t "C,," -n "traefik" -i ./traefik.crt

# 4. Add to OS System Trust (Ubuntu/Debian) securely
sudo cp ./traefik.crt /usr/local/share/ca-certificates/traefik.crt
sudo update-ca-certificates
```
*Note: Fully close and reopen Chrome for the trusted certificate to take effect.*

---

## Jenkins Post-Deployment (Manual)

The Jenkins CI/CD server is fully provisioned by Terraform and Ansible but remains isolated from the Traefik reverse proxy by design. 

### External Access (Cloudflare Tunnels)
To expose Jenkins to the internet securely without port-forwarding, you must manually run the `cloudflared` daemon inside the Jenkins container:
1. Log into your Cloudflare Zero Trust Dashboard and create a new Tunnel.
2. Add a Public Hostname pointing to `http://localhost:8080` (or `http://192.168.1.132:8080`).
3. SSH into Jenkins (`192.168.1.132`) and run the exact `cloudflared service install ...` command provided by the Cloudflare Dashboard.

### Docker-in-LXC (Host Configuration)
Since the Proxmox API token is restricted from modifying security feature flags other than `nesting` via the API, the `keyctl` feature must be enabled manually on the Proxmox host (`proxmox`) using the CLI to support Docker inside the container:
```bash
# Run this on your Proxmox host CLI (proxmox)
# For Jenkins (VMID 207)
pct set 207 -features keyctl=1

# For Server Docker (VMID 206)
pct set 206 -features keyctl=1
```

### Security / Firewall
If you decide to enable UFW on the Jenkins server in the future, run the following manually on the LXC to ensure you don't lock yourself out:
```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp     # SSH
sudo ufw allow 8080/tcp   # Jenkins UI
sudo ufw enable
```
