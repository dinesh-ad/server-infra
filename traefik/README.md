# Traefik

Reverse proxy and TLS termination for all apps on this server.

## Services

| Container | Purpose |
|---|---|
| `traefik` | Reverse proxy, HTTPS, Let's Encrypt ACME |
| `socket-proxy` | Filtered Docker API proxy — Traefik never touches the raw socket |

## Networks

| Network | Owner | Purpose |
|---|---|---|
| `traefik-public` | This stack | Shared network all app containers join |
| `socket-proxy` | This stack | Isolated — Traefik ↔ socket-proxy only |

## First-time setup

```bash
cd /opt/server-infra
bash scripts/bootstrap.sh
```

Then edit `traefik/.env`:

```bash
ACME_EMAIL=your@email.com
```

Then start:

```bash
cd /opt/server-infra/traefik
docker compose up -d
```

## Subsequent deploys

```bash
cd /opt/server-infra
git pull
cd traefik
docker compose up -d
```

Traefik reloads dynamic config (Docker labels) automatically.
Static config changes (`traefik.yml`) require a container restart.

## Files

| File | Committed | Purpose |
|---|---|---|
| `docker-compose.yml` | ✅ | Stack definition |
| `traefik.yml` | ✅ | Static config |
| `.env.example` | ✅ | Env var template |
| `.env` | ❌ | Real values — server only |
| `acme.json` | ❌ | TLS certs — server only |
