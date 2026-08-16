# Terraform — Homelab Infrastructure

Provisions all LXC containers and VMs on Proxmox VE using the `bpg/proxmox` provider. The environment is structured as a single root module (`homelab118`) that calls service modules.

## Modules

- **`modules/lxc`** — Reusable Proxmox LXC container module with Cloud-Init network, SSH key injection, and resource configuration.
- **`modules/vm`** — Reusable Proxmox VM module using Ubuntu Cloud-Init images for unattended installation (no interactive installer). Configures static IP, SSH keys, disk, and CPU via Cloud-Init.

## Services

| Service | Module | Type |
|---|---|---|
| k3s-control | vm | VM |
| k3s-worker-1 | vm | VM |
| reverseproxy | lxc | LXC |
| dns | lxc | LXC |
| databases | lxc | LXC |
| gitea | lxc | LXC |
| jenkins | lxc | LXC |
| media | lxc | LXC |
| server-docker | lxc | LXC |
| bastionvault | lxc | LXC |

## Secrets

Copy `secrets.auto.tfvars.example` to `secrets.auto.tfvars` and fill in your Proxmox endpoint, API token, and SSH key paths. This file is gitignored.

The `platform` variable includes `iso_file_id` pointing to the Ubuntu 24.04 Cloud Image (`local:iso/ubuntu-24.04-minimal-cloudimg-amd64.img`) stored on the Proxmox node.

## Deployment

```bash
cd environments/homelab118
terraform init
terraform apply
```

To target a specific service:
```bash
terraform apply -target=module.k3s-control
```

To import an already-existing resource:
```bash
# LXC
terraform import module.<name>.proxmox_virtual_environment_container.this <node>/<vmid>
# VM
terraform import module.<name>.module.vm.proxmox_virtual_environment_vm.this <vmid>
```

## Notes

- VMs use Ubuntu 24.04 minimal cloud images — no interactive installation. Cloud-Init handles IP, SSH keys, and hostname.
- `qemu_agent_enabled` defaults to `false` because the minimal cloud image does not include `qemu-guest-agent` out of the box.
- LXC containers requiring Docker (`keyctl`) need the following set manually on the Proxmox host CLI:
  ```bash
  pct set <vmid> -features keyctl=1
  ```
