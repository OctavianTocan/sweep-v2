#!/usr/bin/env bash
# Runs the project's check scripts (typecheck, build, lint, test) in order.
# Stops at the first failure and reports which check failed.
# Usage: run-checks.sh [project_dir]
# Output: Per-check PASS/FAIL status. Exit code 0 if all pass, 1 if any fail.
set -uo pipefail

DIR="${1:-.}"
cd "$DIR"

# Detect package manager
if [ -f bun.lock ] || [ -f bun.lockb ]; then
  PM="bun"
elif [ -f pnpm-lock.yaml ]; then
  PM="pnpm"
elif [ -f yarn.lock ]; then
  PM="yarn"
elif [ -f package-lock.json ]; then
  PM="npm"
else
  echo "ERROR: no lockfile found" >&2
  exit 1
fi

# Discover available check scripts from package.json
AVAILABLE=$(cat package.json | jq -r '.scripts // {} | keys[]' 2>/dev/null || echo "")

# Map to canonical checks in order
CHECKS=()
for SCRIPT in typecheck type-check; do
  if echo "$AVAILABLE" | grep -qx "$SCRIPT"; then
    CHECKS+=("$SCRIPT")
    break
  fi
done
# Fallback: if no typecheck script, try tsc directly
if [ ${#CHECKS[@]} -eq 0 ] && command -v tsc &>/dev/null; then
  CHECKS+=("__tsc_direct__")
fi

for SCRIPT in build lint test; do
  if echo "$AVAILABLE" | grep -qx "$SCRIPT"; then
    CHECKS+=("$SCRIPT")
  fi
done

if [ ${#CHECKS[@]} -eq 0 ]; then
  echo "WARNING: no check scripts found in package.json" >&2
  exit 0
fi

# Run each check sequentially, stop at first failure
FAILED=""
for CHECK in "${CHECKS[@]}"; do
  if [ "$CHECK" = "__tsc_direct__" ]; then
    LABEL="typecheck (tsc --noEmit)"
    if tsc --noEmit 2>&1; then
      echo "PASS: $LABEL"
    else
      echo "FAIL: $LABEL"
      FAILED="$LABEL"
      break
    fi
  else
    LABEL="$CHECK"
    if $PM run "$CHECK" 2>&1; then
      echo "PASS: $LABEL"
    else
      echo "FAIL: $LABEL"
      FAILED="$LABEL"
      break
    fi
  fi
done

if [ -n "$FAILED" ]; then
  echo "---"
  echo "STOPPED_AT: $FAILED"
  exit 1
fi

echo "---"
echo "ALL_CHECKS_PASSED"
exit 0
