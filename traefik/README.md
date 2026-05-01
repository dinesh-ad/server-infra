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
CF_DNS_API_TOKEN_NEXDUE=your_cloudflare_dns_edit_token
```

`CF_DNS_API_TOKEN_NEXDUE` is a Cloudflare **API token** (not the global API key) with **Zone → DNS → Edit**, scoped to **nexdue.app** only. Create it at [Cloudflare API Tokens](https://dash.cloudflare.com/profile/api-tokens).

At runtime, `docker-compose.yml` maps that variable to **`CF_DNS_API_TOKEN`**, which is the environment variable [Lego’s Cloudflare provider](https://go-acme.github.io/lego/dns/cloudflare/) reads for DNS-01. Use one token per zone in `.env` (e.g. `CF_DNS_API_TOKEN_OTHERDOMAIN=…`) and add a matching line under the Traefik service `environment` block when you host more domains from this stack.

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

**Static config** (`traefik.yml`, including ACME / DNS challenge settings) is read at process start only. After any change to `traefik.yml`, restart Traefik so it picks up the new file, for example:

```bash
cd /opt/server-infra/traefik
docker compose up -d --force-recreate traefik
```

## Files

| File | Committed | Purpose |
|---|---|---|
| `docker-compose.yml` | ✅ | Stack definition; maps `CF_DNS_API_TOKEN_NEXDUE` → `CF_DNS_API_TOKEN` for Lego |
| `traefik.yml` | ✅ | Static config |
| `.env.example` | ✅ | Env var template |
| `.env` | ❌ | Real values — server only |
| `acme.json` | ❌ | TLS certs — server only |
