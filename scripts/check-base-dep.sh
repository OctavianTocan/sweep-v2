#!/usr/bin/env bash
# Checks whether a PR's base branch has been merged into main and
# whether there's an open PR for the base branch.
# Usage: check-base-dep.sh OWNER REPO BASE_BRANCH
# Output: JSON object with fields:
#   merged_into_main: true|false
#   open_pr: {number, title, url} | null
set -euo pipefail

OWNER="$1"
REPO="$2"
BASE_BRANCH="$3"

# Check if base branch is merged into main
git fetch origin "$BASE_BRANCH" 2>/dev/null || true
if git merge-base --is-ancestor "origin/$BASE_BRANCH" origin/main 2>/dev/null; then
  MERGED="true"
else
  MERGED="false"
fi

# Check for open PR merging base into main
OPEN_PR=$(gh pr list --repo "$OWNER/$REPO" --base main --head "$BASE_BRANCH" --state open \
  --json number,title,url --jq '.[0] // empty' 2>/dev/null || echo "")

if [ -z "$OPEN_PR" ]; then
  OPEN_PR="null"
fi

jq -n \
  --argjson merged "$MERGED" \
  --argjson open_pr "$OPEN_PR" \
  '{merged_into_main: $merged, open_pr: $open_pr}'
