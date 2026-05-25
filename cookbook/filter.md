# Filter Mode — Status-Based PR Discovery & Processing

## Context

Use when the user runs commands like:

- `/sweep-v2 changes requested`
- `/sweep-v2 cr`
- `/sweep-v2 approved`
- `/sweep-v2 review required`

This mode discovers all matching PRs (usually authored by the current user) and then offers to sweep them, either interactively or in batch/autonomous mode.

## Behavior

1. Parse the status keyword (case-insensitive, multi-word variants supported: "changes requested", "changes_requested", "cr", etc.).
2. Use GitHub search to find open PRs with the matching review status.
3. Present a clean list with PR number, title, branch, and unresolved comment count.
4. Ask the user whether to:
   - Sweep them one by one (single mode)
   - Sweep them all autonomously (batch mode)
   - Just list them (no action)

## Implementation Notes (v2)

This reuses the same discovery primitives as `ls.md` plus GitHub's review status filters.

In v2 we apply the same quality standards:
- Coverage preflight is still required for any PR that will be heavily modified.
- Visual changes gate remains in effect.
- Rebase impact analysis is performed where relevant.

## Relationship to Batch Mode

Filter mode is often the entry point into batch/autonomous sweeps. After discovery, it hands off to the batch machinery described in `cookbook/batch.md`.

## Future Enhancements

- Support for organization-wide filters (not just "my PRs")
- Time-based filters ("changes requested in last 7 days")
- Integration with the learning system to prioritize PRs that match known high-value patterns

For now, this provides a very practical way to "sweep the queue" of pending review work.
