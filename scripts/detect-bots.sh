#!/usr/bin/env bash
# Detects bot reviewers on a PR.
# Usage: detect-bots.sh OWNER REPO PR_NUMBER
# Output: One bot login per line. Empty if no bots found.
#   Also outputs the latest bot review's submitted_at on stderr
#   for use in polling (e.g., LATEST_BOT_REVIEW=$(detect-bots.sh ... 2>&1 1>/dev/null))
set -euo pipefail

OWNER="$1"
REPO="$2"
PR_NUMBER="$3"

REVIEWS=$(gh api "repos/$OWNER/$REPO/pulls/$PR_NUMBER/reviews" \
  --jq '[.[] | {author: .user.login, state: .state, body: .body, submitted_at: .submitted_at}]')

# Filter for bot patterns: *[bot], *-apps[bot], *-staging[bot]
BOT_LOGINS=$(echo "$REVIEWS" \
  | jq -r '[.[].author | select(test("\\[bot\\]$"))] | unique | .[]')

echo "$BOT_LOGINS"

# Output latest bot review timestamp on stderr for polling
if [ -n "$BOT_LOGINS" ]; then
  LATEST=$(echo "$REVIEWS" \
    | jq -r '[.[] | select(.author | test("\\[bot\\]$"))] | sort_by(.submitted_at) | last | .submitted_at')
  echo "$LATEST" >&2
fi
