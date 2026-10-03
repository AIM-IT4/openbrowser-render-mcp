#!/usr/bin/env bash
set -euo pipefail

BROKER_ROOT="${OPENBROWSER_BROKER_ROOT:-/data/openbrowser-broker}"
POOL_DIR="${OPENBROWSER_BROWSER_POOL_DIR:-/data/openbrowser-pool}"

mkdir -p "$BROKER_ROOT" "$POOL_DIR" "$BROKER_ROOT/logs"

# The pool supervisor expects browser_pool scripts under BROKER_ROOT.
rm -rf "$BROKER_ROOT/browser_pool"
cp -a /opt/openbrowser/browser_pool "$BROKER_ROOT/browser_pool"

# Use the Chromium binary installed by Playwright in this image.
OPENBROWSER_CHROME_BIN="$(python - <<'PY'
from playwright.sync_api import sync_playwright
p = sync_playwright().start()
try:
    print(p.chromium.executable_path)
finally:
    p.stop()
PY
)"
export OPENBROWSER_CHROME_BIN

echo "Starting OpenBrowser Chrome pool with $OPENBROWSER_CHROME_BIN"
bash "$BROKER_ROOT/browser_pool/bin/supervisor.sh" >>"$BROKER_ROOT/logs/pool-supervisor.log" 2>&1 &

exec openbrowser-broker
