# Docker Services — Network & Port Allocation

This document tracks all host ports used by Docker Compose stacks on `server-docker` (`192.168.1.131`).
All services sit behind Cloudflare Tunnels and are not directly exposed to the internet.

---

## Port Map

| Host Port | Stack | Service | Container Port | Category | Domain |
|---|---|---|---|---|---|
| **3000** | homepage-dashboard | homepage | 3000 | Apps | `dashboard.homelab118.home` |
| **3001** | uptimekuma | uptime-kuma | 3001 | Monitoring | `uptime.homelab118.home` |
| **3002** | wud | wud | 3000 | Infra | (internal only) |
| **3005** | asap | asap-server | 3000 | Apps | `asap.homelab118.home` |
| **3080** | vert | vert | 80 | Apps | `vert.homelab118.home` |
| **4000** | gitea | gitea | 3000 | Apps | `git.homelab118.home` |
| **222** | gitea | gitea SSH | 22 | Apps | SSH: `git.homelab118.home:222` |
| **5173** | asap | asap-client | 80 | Apps | (served via asap-server) |
| **5230** | memos | memos | 5230 | Apps | `memos.homelab118.home` |
| **5432** | postgres | postgres | 5432 | DB | (LAN only — no tunnel) |
| **5678** | n8n | n8n | 5678 | Apps | `n8n.homelab118.home` |
| **8000** | vaultwarden | vaultwarden | 80 | Apps | `vault.homelab118.home` |
| **8080** | firefly3 | firefly_iii_core | 8080 | Apps | `money.homelab118.home` |
| **9000** | portainer | portainer | 9000 | Infra | (LAN only) |

---

## Category Summary

### 🔧 Infrastructure (LAN only — do NOT tunnel)
| Port | Service |
|------|---------|
| 3002 | WUD |
| 5432 | Postgres |
| 9000 | Portainer |

### 📊 Monitoring
| Port | Service |
|------|---------|
| 3001 | Uptime Kuma |

### 🚀 Applications (expose via Cloudflare Tunnel)
| Port | Service |
|------|---------|
| 3000 | Homepage Dashboard |
| 3005 | ASAP Server |
| 3080 | Vert |
| 4000 | Gitea Web |
| 5230 | Memos |
| 5678 | n8n |
| 8000 | Vaultwarden |
| 8080 | Firefly III |

---

## Notes

- **Postgres** (`5432`) was moved from non-standard `8001` to the standard port `5432`. Update any external service `.env` files that previously pointed to port `8001`.
- **Vert** was changed from `3001` to `3080` to avoid collision with Uptime Kuma.
- **Gitea SSH** (`222`) is a non-standard host port mapping to container port `22`.
- Keep Postgres, Portainer, and WUD accessible on LAN only. Do not create Cloudflare Tunnels for these.
- Reserve ports `9100–9199` for future monitoring exporters (e.g., Prometheus node-exporter).
