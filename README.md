# server-infra

Shared server infrastructure for the production VPS.
Hosts Scrift, Nexdue, and future applications.

## What this repo manages

Server-level infrastructure only — not application code.
App repos plug into this infrastructure but do not control it.

## Structure
server-infra/
├── traefik/                  ← Reverse proxy + TLS (see traefik/README.md)
│   ├── docker-compose.yml
│   ├── traefik.yml
│   └── .env.example
├── scripts/
│   └── bootstrap.sh          ← Run once on a fresh server
├── .gitignore
└── README.md

## Server layout
/opt/
├── server-infra/             ← this repository
│   ├── traefik/
│   └── scripts/
├── scrift/                   ← Scrift application
├── nexdue/                   ← Nexdue application
└── github-runner/            ← Self-hosted GitHub Actions runners

## How it works
Internet → Cloudflare → Traefik → app containers

Traefik owns `traefik-public` — the shared Docker network.
All app containers join it as `external: true`.
Traefik discovers them automatically via Docker labels.

## Fresh server setup

```bash
git clone git@github.com:dinesh-ad/server-infra.git /opt/server-infra
cd /opt/server-infra
bash scripts/bootstrap.sh
cd traefik
docker compose up -d
```

Then start app stacks. Traefik auto-routes immediately.

## Startup order

Traefik stack (this repo)
App stacks (scrift, nexdue, etc.)


Traefik must be running first — it owns `traefik-public`.

## Deploying changes

Manual only — no CI/CD on this repo by design.

```bash
cd /opt/server-infra
git pull
# if traefik.yml changed:
cd traefik && docker compose up -d
# Docker label changes on app containers take effect automatically
```

## Security

| File | Location | Never commit |
|---|---|---|
| `traefik/.env` | Server only | ✅ |
| `traefik/acme.json` | Server only | ✅ |

## Planned

- `monitoring/` — metrics and alerting
