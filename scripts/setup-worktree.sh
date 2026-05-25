#!/usr/bin/env bash
# Creates a git worktree for a PR branch, copies env files, and installs deps.
# Usage: setup-worktree.sh WORKTREE_PATH BRANCH_NAME [REPO_ROOT]
# Output: "ready" on success, error details on failure.
set -euo pipefail

WORKTREE_PATH="$1"
BRANCH_NAME="$2"
REPO_ROOT="${3:-$(git rev-parse --show-toplevel)}"

# Fetch the branch
git fetch origin "$BRANCH_NAME" 2>/dev/null || {
  echo "ERROR: could not fetch origin/$BRANCH_NAME" >&2
  exit 1
}

# Remove existing worktree at this path if present
if [ -d "$WORKTREE_PATH" ]; then
  git worktree remove "$WORKTREE_PATH" --force 2>/dev/null || true
fi

# Create the worktree
git worktree add "$WORKTREE_PATH" "origin/$BRANCH_NAME" || {
  echo "ERROR: could not create worktree at $WORKTREE_PATH" >&2
  exit 1
}

# Copy gitignored env/config files from repo root
for f in .env .env.local .env.development .env.development.local .npmrc .yarnrc .yarnrc.yml; do
  [ -f "$REPO_ROOT/$f" ] && cp "$REPO_ROOT/$f" "$WORKTREE_PATH/$f"
done

# Detect package manager and install dependencies
cd "$WORKTREE_PATH"
if [ -f bun.lock ] || [ -f bun.lockb ]; then
  bun install 2>&1 || echo "WARNING: bun install failed" >&2
elif [ -f pnpm-lock.yaml ]; then
  pnpm install --frozen-lockfile 2>&1 || echo "WARNING: pnpm install failed" >&2
elif [ -f yarn.lock ]; then
  yarn install --frozen-lockfile 2>&1 || echo "WARNING: yarn install failed" >&2
elif [ -f package-lock.json ]; then
  npm ci 2>&1 || echo "WARNING: npm ci failed" >&2
fi

echo "ready"
