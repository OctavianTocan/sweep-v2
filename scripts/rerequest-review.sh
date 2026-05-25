#!/usr/bin/env bash
# Re-requests review from human reviewers on a PR.
# Usage: rerequest-review.sh OWNER REPO PR_NUMBER USERNAME [USERNAME ...]
# Output: Confirmation message.
set -euo pipefail

OWNER="$1"
REPO="$2"
PR_NUMBER="$3"
shift 3

if [ $# -eq 0 ]; then
  echo "No usernames provided" >&2
  exit 1
fi

# Get PR node ID
PR_NODE_ID=$(gh api "repos/$OWNER/$REPO/pulls/$PR_NUMBER" --jq '.node_id')

# Get user node IDs
USER_IDS=""
for USERNAME in "$@"; do
  NODE_ID=$(gh api "users/$USERNAME" --jq '.node_id' 2>/dev/null) || {
    echo "WARNING: could not find user '$USERNAME', skipping" >&2
    continue
  }
  if [ -n "$USER_IDS" ]; then
    USER_IDS="$USER_IDS, "
  fi
  USER_IDS="$USER_IDS\"$NODE_ID\""
done

if [ -z "$USER_IDS" ]; then
  echo "No valid users found" >&2
  exit 1
fi

gh api graphql -f query='
mutation {
  requestReviews(input: {
    pullRequestId: "'"$PR_NODE_ID"'"
    userIds: ['"$USER_IDS"']
  }) {
    pullRequest { id }
  }
}' >/dev/null

echo "Re-review requested from: $*"
