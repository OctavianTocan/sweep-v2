#!/usr/bin/env bash
# Detects the project's package manager from lockfiles.
# Usage: detect-pkg-manager.sh [project_dir]
# Output: One of: bun, pnpm, yarn, npm
#   Exits 1 if no lockfile found.
set -euo pipefail

DIR="${1:-.}"

if [ -f "$DIR/bun.lock" ] || [ -f "$DIR/bun.lockb" ]; then
  echo "bun"
elif [ -f "$DIR/pnpm-lock.yaml" ]; then
  echo "pnpm"
elif [ -f "$DIR/yarn.lock" ]; then
  echo "yarn"
elif [ -f "$DIR/package-lock.json" ]; then
  echo "npm"
else
  echo "ERROR: no lockfile found in $DIR" >&2
  exit 1
fi
