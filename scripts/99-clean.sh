#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
if [[ -d build ]]; then
  echo "This removes all generated test keys, CA state and evidence in build/."
  rm -rf build
  echo "Removed build/."
else
  echo "Nothing to clean."
fi
