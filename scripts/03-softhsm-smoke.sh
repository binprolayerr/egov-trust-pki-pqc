#!/usr/bin/env bash
set -euo pipefail
command -v softhsm2-util >/dev/null || { echo "SoftHSM2 not installed; see docs/runbook.md"; exit 2; }
command -v pkcs11-tool >/dev/null || { echo "OpenSC pkcs11-tool not installed; see docs/runbook.md"; exit 2; }

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
mkdir -p build/softhsm
export SOFTHSM2_CONF="$ROOT/build/softhsm/softhsm2.conf"
printf 'directories.tokendir = %s\nobjectstore.backend = file\n' "$ROOT/build/softhsm/tokens" > "$SOFTHSM2_CONF"
mkdir -p "$ROOT/build/softhsm/tokens"
chmod 700 "$ROOT/build/softhsm/tokens"

# Disposable lab PINs only. Do not copy these values into production or commit them.
softhsm2-util --init-token --free --label "week1-test-token" --so-pin 12345678 --pin 1234
softhsm2-util --show-slots
echo "Token initialized. This confirms only local SoftHSM availability; no hardware security claim."
echo "Use a separate, disposable test key for any import/sign operation."
