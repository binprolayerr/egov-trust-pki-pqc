#!/usr/bin/env bash
set -euo pipefail
command -v openssl >/dev/null || { echo "ERROR: openssl not found"; exit 1; }
command -v bash >/dev/null || { echo "ERROR: bash not found"; exit 1; }
echo "OpenSSL:"
openssl version -a
echo
echo "Required commands:"
for c in awk grep sed date mkdir chmod; do
  command -v "$c" >/dev/null || { echo "ERROR: missing $c"; exit 1; }
  echo "  $c: OK"
done
echo
echo "Prerequisite check passed."
