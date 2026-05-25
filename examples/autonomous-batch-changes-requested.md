# Example: Autonomous Batch on "Changes Requested" PRs

## Scenario

Developer has 6 open PRs showing "changes requested". They want to make progress on all of them overnight.

Command:
```
/sweep-v2 changes requested
```

## What Sweep v2 Does

1. Discovers the 6 PRs.
2. Runs dependency analysis — two of them form a stack. Orders execution correctly.
3. Creates 6 isolated worktrees, installs deps in each.
4. Launches parallel autonomous subagents with the v2 prompt.
5. Each subagent:
   - Runs coverage preflight (surfaces one Yellow finding — escalated)
   - Performs rebase impact analysis where needed
   - Fixes feedback with pattern grouping
   - Skips all visual suggestions
   - Runs polish pass
   - Passes build verification on 5/6 PRs (one failure escalated)
6. Parent agent collects structured output and produces a rich report:
   - 4 PRs reached clean state with all threads resolved
   - 1 PR has a coverage risk acceptance needed
   - 1 PR has a build failure + one rebase escalation
   - Several visual changes were skipped for human review

The developer reviews the report the next morning, accepts the one risk, fixes the build failure, and lands the clean PRs.

This is how sweep v2 gives massive leverage without sacrificing the quality standards.
