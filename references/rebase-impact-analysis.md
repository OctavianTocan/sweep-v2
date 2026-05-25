# Rebase Impact Analysis

## Context

A clean `git rebase` does **not** mean the PR is still correct.

When the base branch changes files that the PR also touches, the PR's approach can become stale even if the text merge succeeds.

This reference defines the two-pass process (fast triage + deep agent analysis) and the strict safety rules (never auto-fix `stale_approach` or `behavioral_conflict` in autonomous mode).

Full details and agent prompt will be ported from the original sweep's `references/rebase-analysis-agent.md` and `cookbook/rebase-triage.md`.

This is one of the most valuable capabilities being preserved in v2.
