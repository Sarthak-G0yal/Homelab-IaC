# Homelab Docker Workspace

This repository contains multiple Docker Compose stacks, each isolated in its own folder.

## Directory Layout

```text
/home/server/docker
├── asap/
├── firefly3/
├── gitea/
├── homepage-dashboard/
├── n8n/
├── portainer/
├── postgres/
├── uptimekuma/
├── vaultwarden/
└── vert/
```

Key data/config directories:
- `gitea/gitea/` stores Gitea application data.
- `firefly3/` stores Firefly III stack config (`.env`, `.db.env`, and `compose.yaml`).
- `homepage-dashboard/config/` stores Homepage configuration files.
- `n8n/local-files/` is mounted into n8n at `/files`.
- `vaultwarden/vw-data/` stores Vaultwarden persistent data.

## Stack Summary

| Stack | Compose File | Service(s) | Published Port(s) | Network | Persistent Data |
|---|---|---|---|---|---|
| ASAP | `asap/compose.yaml` | `asap-server`, `asap_client` | `3005`, `5173` | default | image-based apps (no named volume in compose) |
| Firefly III | `firefly3/compose.yaml` | `firefly_iii_core`, `firefly_iii_cron` | `8080` | `firefly_iii` | `firefly_iii_upload` volume |
| Gitea | `gitea/compose.yaml` | `gitea` | `4000`, `222` | default | `gitea/gitea:/data` |
| Homepage Dashboard | `homepage-dashboard/compose.yaml` | `homepage` | `3000` | default | `homepage-dashboard/config`, `images`, `icons` |
| n8n | `n8n/compose.yaml` | `n8n` | `5678` | default | `n8n_data` volume and `n8n/local-files` bind mount |
| Portainer | `portainer/compose.yaml` | `portainer` | `9000` | `portainer_network` (compose default renamed) | `portainer_data` volume |
| Postgres | `postgres/compose.yaml` | `postgres` | `8001` (to container `5432`) | default | `postgres_data` volume |
| Uptime Kuma | `uptimekuma/compose.yaml` | `uptime-kuma` | `3001` | default | `uptime-kuma-data` volume |
| Vaultwarden | `vaultwarden/compose.yaml` | `vaultwarden` | `8000` (to container `80`) | default | `vaultwarden/vw-data` bind mount |
| Vert | `vert/compose.yaml` | `vert` | `${PORT:-3001}` | default | image/container state only |

## Environment Files

The following stacks currently use dedicated environment files:
- `asap/.env`
- `asap/.env.production`
- `firefly3/.env`
- `firefly3/.db.env`
- `gitea/.env`
- `gitea/.env.production`
- `n8n/.env`
- `n8n/.env.production`
- `postgres/.env`
- `postgres/.env.production`

Current pattern in this repo:
- `.env` stores active values used by Docker Compose interpolation.
- `.env.production` stores variable names as a production template.

## Run Commands

From a specific stack directory:

```bash
# Start
cd <stack-folder>
docker compose up -d

# Validate effective config
docker compose config

# Stop
docker compose down
```

Examples:

```bash
cd /home/server/docker/gitea && docker compose up -d
cd /home/server/docker/firefly3 && docker compose up -d
cd /home/server/docker/n8n && docker compose up -d
cd /home/server/docker/postgres && docker compose up -d
```

## Notes

- Gitea, n8n, and Firefly III are configured to use an external Postgres host via environment variables.
- The local Postgres stack is optional and isolated on its own compose default network, exposing `8001`.
- Keep sensitive values in `.env` private and rotate credentials regularly.
