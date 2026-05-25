# List PRs with Review Comments

## Context

Use when you run `/sweep-v2 ls` (or with a repo name for fuzzy search).

Shows your open PRs enriched with unresolved review thread counts and reviewer names.

## Implementation Notes (v2)

This will use the proven `scripts/fetch-threads.sh` + `scripts/detect-bots.sh` machinery from the original sweep, presented cleanly.

For now this is a stub — full implementation coming in the merge.
