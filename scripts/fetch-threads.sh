#!/usr/bin/env bash
# Fetches all unresolved review threads for a PR via GitHub GraphQL API.
# Handles pagination automatically.
# Usage: fetch-threads.sh OWNER REPO PR_NUMBER
# Output: JSON array of unresolved threads with comments, path, line info.
set -euo pipefail

OWNER="$1"
REPO="$2"
PR_NUMBER="$3"

ALL_THREADS="[]"
CURSOR=""

while true; do
  CURSOR_ARG=""
  if [ -n "$CURSOR" ]; then
    CURSOR_ARG="-f cursor=$CURSOR"
  fi

  # shellcheck disable=SC2086
  RESPONSE=$(gh api graphql $CURSOR_ARG -f query='
query($cursor: String) {
  repository(owner: "'"$OWNER"'", name: "'"$REPO"'") {
    pullRequest(number: '"$PR_NUMBER"') {
      reviewThreads(first: 100, after: $cursor) {
        pageInfo { hasNextPage endCursor }
        nodes {
          id
          isResolved
          comments(first: 3) {
            nodes {
              body
              path
              line
              startLine
              originalLine
              diffHunk
              author { login }
              createdAt
            }
          }
        }
      }
    }
  }
}')

  # Extract unresolved threads from this page
  PAGE_THREADS=$(echo "$RESPONSE" \
    | jq '[.data.repository.pullRequest.reviewThreads.nodes[] | select(.isResolved == false)]')

  # Merge into accumulator
  ALL_THREADS=$(echo "$ALL_THREADS $PAGE_THREADS" | jq -s '.[0] + .[1]')

  # Check pagination
  HAS_NEXT=$(echo "$RESPONSE" \
    | jq -r '.data.repository.pullRequest.reviewThreads.pageInfo.hasNextPage')

  if [ "$HAS_NEXT" != "true" ]; then
    break
  fi

  CURSOR=$(echo "$RESPONSE" \
    | jq -r '.data.repository.pullRequest.reviewThreads.pageInfo.endCursor')
done

echo "$ALL_THREADS"
