#!/usr/bin/env bash
# Detects OWNER and REPO from the git remote origin URL.
# Usage: detect-repo.sh
# Output: Two lines — OWNER then REPO
#   Example:
#     thirdear-ai
#     web-app
set -euo pipefail

REMOTE_URL=$(git remote get-url origin 2>/dev/null) || {
  echo "ERROR: not a git repo or no 'origin' remote" >&2
  exit 1
}

# Strip protocol prefix and .git suffix, extract owner/repo
OWNER_REPO=$(echo "$REMOTE_URL" \
  | sed 's#.*github\.com[:/]##' \
  | sed 's/\.git$//')

OWNER=$(echo "$OWNER_REPO" | cut -d'/' -f1)
REPO=$(echo "$OWNER_REPO" | cut -d'/' -f2)

echo "$OWNER"
echo "$REPO"
