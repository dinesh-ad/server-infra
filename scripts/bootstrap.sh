#!/usr/bin/env bash
# bootstrap.sh — run once on a fresh server before starting any stack.
# Safe to re-run — all operations are idempotent.
#
# What this does:
#   1. Creates acme.json with correct permissions (Let's Encrypt requirement)
#   2. Confirms traefik-public network will be created by Traefik compose (no manual step needed)
#
# Usage:
#   cd /opt/server-infra/traefik
#   bash ../scripts/bootstrap.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TRAEFIK_DIR="${SCRIPT_DIR}/../traefik"
ACME_FILE="${TRAEFIK_DIR}/acme.json"

echo "==> Checking acme.json..."
if [ ! -f "${ACME_FILE}" ]; then
  touch "${ACME_FILE}"
  chmod 600 "${ACME_FILE}"
  echo "    Created acme.json with chmod 600"
else
  chmod 600 "${ACME_FILE}"
  echo "    acme.json already exists — permissions enforced (chmod 600)"
fi

echo "==> Checking .env..."
ENV_FILE="${TRAEFIK_DIR}/.env"
ENV_EXAMPLE="${TRAEFIK_DIR}/.env.example"
if [ ! -f "${ENV_FILE}" ]; then
  cp "${ENV_EXAMPLE}" "${ENV_FILE}"
  echo "    .env created from .env.example — fill in ACME_EMAIL before starting Traefik"
else
  echo "    .env already exists — skipping"
fi

echo ""
echo "==> Bootstrap complete."
echo "    Next steps:"
echo "      1. Edit traefik/.env and set ACME_EMAIL"
echo "      2. cd /opt/server-infra/traefik && docker compose up -d"
echo "      3. Start app stacks (nexdue, scrift) — traefik-public is created by Traefik"
