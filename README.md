# VPS Infrastructure

Infrastructure configuration for the production VPS hosting Nexdue and future SaaS applications.

This repository defines **server-level shared infrastructure**, not application code.

## Scope

This repo manages components that are shared across multiple apps running on the same server, including:

* Traefik reverse proxy
* TLS certificates (Let's Encrypt via Traefik)
* Shared Docker networks (e.g. `traefik-public`)
* Future shared infrastructure (monitoring, logging, etc.)

Application repositories such as **nexdue** attach to this infrastructure but do not manage it.

## Server Layout

Production server structure:

/opt
/infra
/traefik        ← deployed from this repository
/nexdue           ← Nexdue application repository
/<future-app>     ← future SaaS applications

## Deployment

This repo is manually deployed to the server.

Example deployment location:

/opt/infra

Traefik must be running before application stacks that rely on the `traefik-public` Docker network.

## Security Notes

The following files must **never be committed**:

* `acme.json` (contains TLS private keys)
* `.env` files
* secrets or API keys

These exist only on the server.

## Relationship to Application Repositories

Example:

nexdue repo
└ docker-compose.yml
└ attaches to traefik-public network

vps-infra repo
└ traefik/docker-compose.yml
└ manages reverse proxy and TLS

## Goal

Keep server infrastructure **version controlled, reproducible, and independent of any single application.**
