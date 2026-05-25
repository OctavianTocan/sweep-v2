# Batch / Autonomous Sweep (Multi-PR with Worktrees)

## Context

Use when the user invokes `/sweep-v2 <PR#> <PR#> ...` or a status filter like "changes requested".

This mode uses isolated git worktrees + parallel Opus subagents to process multiple PRs autonomously.

**v2 contract**: Even in autonomous mode, we still enforce the core quality gates (coverage preflight, visual changes gate, rebase safety rules, build verification). We are deliberately more conservative than the original sweep on quality.

## High-Level Flow

1. Validate the list of PRs.
2. Analyze dependencies (stacked PRs via `check-base-dep.sh`).
3. For each PR:
   - Create isolated worktree (using `scripts/setup-worktree.sh`)
   - Copy env files and install dependencies
   - Run the autonomous subagent with the adapted prompt (see references/autonomous-sweep.md)
4. Parent agent monitors progress and aggregates a rich report.
5. Human reviews the report, handles escalations, and decides on final actions.

## Validation & Dependency Analysis

- Confirm all PRs exist and are open.
- For each PR whose base is not main/master, run `scripts/check-base-dep.sh`.
- Detect intra-batch dependencies (PR A is the base of PR B) → process in correct order.
- Offer to include missing dependency PRs when relevant.

Present a clear summary and ask for confirmation before launching worktrees.

## Per-PRK Autonomous Execution

Inside each worktree the subagent follows the prompt in [references/autonomous-sweep.md](autonomous-sweep.md), with these v2 adaptations:

- **Coverage preflight** is executed early. 
  - If the batch was pre-approved for risk, proceed.
  - Otherwise, surface Yellow/Red findings for the parent agent to escalate.
- **Polish pass** is strongly encouraged (can be made mandatory with a flag in the future).
- **Visual changes gate**: Always skip + flag as `VISUAL_CHANGE_SKIPPED`.
- **Rebase impact analysis**: Full two-pass (triage + sequential agents). Never auto-fix `stale_approach` or `behavioral_conflict`.
- **Rationalization prevention**: Strict citation requirement before resolving any thread.
- **Build verification**: Mandatory at the end of each PR's work. Failures are escalated.
- Output structured status lines so the parent can track progress in real time.

Worktrees are cleaned up via `scripts/cleanup-worktrees.sh` after each PR (success or failure).

## Reporting

The parent agent produces a consolidated report containing, for each PR:

- Status (clean / partial / escalations)
- Coverage preflight result + any risk acceptances
- Rebase impact findings (especially escalated ones)
- Visual changes skipped
- Threads left unresolved (with reasons)
- Build verification outcome
- Structured fix records summary
- Recommendations for the human

## Safety & Human Oversight

- Autonomous mode is powerful but never fully unsupervised on high-stakes changes.
- All dangerous categories (visual, low-confidence rebase impacts, coverage risk, build failures) are escalated to the human.
- The human makes the final decision on whether to land the changes from the worktrees.

## When to Prefer Batch vs Single

- Use **batch** when you have many similar, low-to-medium risk PRs and want leverage.
- Use **single** when the PR is large, high-risk, has complex rebase impact, or involves significant design/visual decisions.

Batch mode amplifies good process — it does not replace judgment.
