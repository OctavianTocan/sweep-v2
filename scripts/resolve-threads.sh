#!/usr/bin/env bash
# Batch-resolves GitHub review threads via GraphQL mutation.
# Handles batches of 25 (GitHub complexity limit).
# Usage: resolve-threads.sh THREAD_ID [THREAD_ID ...]
# Output: Number of threads resolved.
set -euo pipefail

if [ $# -eq 0 ]; then
  echo "Usage: resolve-threads.sh THREAD_ID [THREAD_ID ...]" >&2
  exit 1
fi

THREAD_IDS=("$@")
TOTAL=${#THREAD_IDS[@]}
BATCH_SIZE=25
RESOLVED=0

for (( i=0; i<TOTAL; i+=BATCH_SIZE )); do
  # Build aliased mutation fields for this batch
  MUTATIONS=""
  for (( j=i; j<i+BATCH_SIZE && j<TOTAL; j++ )); do
    IDX=$((j - i + 1))
    MUTATIONS="${MUTATIONS}  t${IDX}: resolveReviewThread(input: {threadId: \"${THREAD_IDS[$j]}\"}) { thread { isResolved } }"$'\n'
  done

  gh api graphql -f query="
mutation {
${MUTATIONS}}" >/dev/null

  BATCH_COUNT=$(( j - i ))
  RESOLVED=$(( RESOLVED + BATCH_COUNT ))
done

echo "$RESOLVED"
