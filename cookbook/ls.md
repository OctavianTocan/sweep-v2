# List PRs with Review Comments

## Context

Use `/sweep-v2 ls` (or `/sweep-v2 ls <repo-name>` for fuzzy search across repos).

Shows your open PRs enriched with:
- Number of unresolved review threads
- Reviewer names (including bots)
- Current review status when available

This is the fastest way to see where your attention is needed.

## Implementation (v2)

Uses the same proven scripts as the rest of the skill:
- `scripts/detect-repo.sh`
- `scripts/fetch-threads.sh`
- `scripts/detect-bots.sh`

Results are grouped and sorted to surface the most actionable PRs first.

## Next Actions from Here

From the list you can jump directly into:
- Single mode on a specific PR
- Batch mode on multiple PRs
- Filter mode for a particular status

This command is read-only and safe to run at any time.
