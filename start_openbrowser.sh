#!/usr/bin/env bash
set -euo pipefail

BROKER_ROOT="${OPENBROWSER_BROKER_ROOT:-/data/openbrowser-broker}"
POOL_DIR="${OPENBROWSER_BROWSER_POOL_DIR:-/data/openbrowser-pool}"

mkdir -p "$BROKER_ROOT" "$POOL_DIR" "$BROKER_ROOT/logs"

# The pool supervisor expects browser_pool scripts under BROKER_ROOT.
rm -rf "$BROKER_ROOT/browser_pool"
cp -a /opt/openbrowser/browser_pool "$BROKER_ROOT/browser_pool"

# Resolve the Chromium binary installed during the Docker build without
# starting a Playwright driver process.
OPENBROWSER_CHROME_BIN="$(find /root/.cache/ms-playwright -type f -path '*/chrome-linux64/chrome' -print -quit)"
if [[ -z "$OPENBROWSER_CHROME_BIN" ]]; then
  echo "Playwright Chromium binary not found" >&2
  exit 1
fi
export OPENBROWSER_CHROME_BIN

echo "Starting OpenBrowser Chrome pool with $OPENBROWSER_CHROME_BIN"
bash "$BROKER_ROOT/browser_pool/bin/supervisor.sh" >>"$BROKER_ROOT/logs/pool-supervisor.log" 2>&1 &

exec openbrowser-broker
