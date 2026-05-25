# Autonomous Sweep — Subagent Prompt Template (Batch Mode)

This reference contains the core prompt and orchestration rules for running sweep autonomously across one or more PRs using isolated worktrees and subagents.

**This is the heart of the original sweep's autonomous power.** It will be adapted for sweep v2 to enforce the new mandatory quality gates (coverage preflight + polish) even in autonomous execution.

## Key Differences in v2 (vs original sweep)

- Coverage preflight is run inside each worktree before heavy iteration (user risk acceptance can be pre-approved for the batch or handled per-PRK).
- Polish pass is strongly encouraged (or made mandatory with a flag).
- Visual changes gate is strictly skip + escalate.
- Rebase impact safety rules are enforced (never auto-fix stale approaches or behavioral conflicts).
- Structured reporting back to the parent agent is richer.

Full detailed prompt and step-by-step autonomous flow will be ported and updated here from the original `references/autonomous-sweep.md`.

## Current Status

The capability exists in the scripts (worktree setup/cleanup, thread tools, run-checks).

The prompt and orchestration logic are being integrated with the new architecture (see `references/architecture.md`).
