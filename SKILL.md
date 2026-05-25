---
name: sweep-v2
description: >
  The unified PR review skill. Combines powerful GitHub automation
  (thread resolution, rebase impact analysis, autonomous batch with worktrees)
  with hard opinionated quality gates (mandatory coverage preflight + high-signal
  self-review polish pass). Works with any reviewer (human, Devin, Codex, Greptile, etc.).
  Successor to both the original sweep and loop-review skills.
argument-hint: ls | <PR# or branch> | changes requested | cr | approved | [PR# PR# ...]
license: MIT
metadata:
  author: OctavianTocan
  version: "2.0"
allowed-tools: Bash(gh:*) Bash(git:*)
---

# Sweep v2

The unified PR review resolution skill.

## Philosophy (Best of Both Worlds)

- **Powerful engine** from original sweep: real GitHub thread fetching & resolution, sophisticated rebase impact analysis, autonomous batch execution across multiple PRs using isolated worktrees, structured learning system, and production-grade operational tooling.
- **Non-negotiable quality soul** from loop-review: hard coverage gate (preflight) that stops weak-test PRs by default, elevated high-signal polish pass as the highest-leverage step, and a ruthless focus on "coverage over reviewer scores" and "polish over metrics."

Sweep v2 never leaves a PR with broken tests or unexamined coverage. It also never leaves review threads dangling when automation can help.

**Never force-pushes.** All changes are committed on top of existing history.

## Quick Reference

| Command                    | Mode     | What it does |
|----------------------------|----------|--------------|
| `/sweep-v2 ls`             | list     | Show open PRs with unresolved review counts |
| `/sweep-v2 123`            | single   | Fix PR #123 interactively with full quality gates |
| `/sweep-v2 feat/branch`    | single   | Fix by branch name |
| `/sweep-v2 123 456 789`    | batch    | Autonomous parallel sweep across multiple PRs |
| `/sweep-v2 changes requested` | filter | Find and process all PRs with "changes requested" |
| `/sweep-v2 cr`             | filter   | Shorthand for changes requested |
| `/sweep-v2 preflight`      | gate     | Run only the hard coverage gate |
| `/sweep-v2 polish`         | quality  | Run only the high-signal self-review polish pass |

## Structure

This skill follows the strict create-skill progressive disclosure format:

- `SKILL.md` — Lean router + philosophy (this file)
- `cookbook/` — Detailed step-by-step workflows
- `references/` — Models, patterns, schemas, and agent prompts
- `examples/` — Realistic public examples
- `scripts/` — Proven executable shell helpers (GitHub GraphQL, worktrees, checks, etc.)

## Core Principles

1. Coverage is non-negotiable (see cookbook/preflight.md)
2. Polish is the highest-leverage step (see cookbook/polish-pass.md)
3. Rebase impact must be analyzed, not ignored (see references/rebase-analysis-agent.md)
4. Visual/styling changes require explicit human approval (hard gate)
5. Rationalization is forbidden — every resolved thread must cite a real fix location
6. The learning system improves over time (.sweep-lessons.json)

## Getting Started

```bash
# Install the skill
npx skills add OctavianTocan/sweep-v2

# On a branch with an open PR that has review feedback:
/sweep-v2
```

See the README for full installation and usage details.

## Decision Tree (High Level)

```
Input
  |
  +-- No args or "help" → Show quick reference + link to README
  |
  +-- "ls" or "ls <name>" → cookbook/ls.md (discovery)
  |
  +-- "preflight" → cookbook/preflight.md (standalone gate)
  |
  +-- "polish" → cookbook/polish-pass.md (standalone polish)
  |
  +-- Review status keyword (changes requested / cr / approved / etc.) → filter mode
  |
  +-- Single PR# or branch → single mode (interactive, full gates)
  |     1. Identify PR
  |     2. Mandatory: Coverage preflight (user accepts risk if needed)
  |     3. Rebase + rebase impact analysis
  |     4. Feedback loop (pattern grouping + visual gate)
  |     5. Strongly recommended: Polish pass
  |     6. Mandatory: Build verification
  |     7. Thread resolution + PR hygiene
  |
  +-- Multiple PR#s or status filter → batch / autonomous mode
        - Worktree per PR
        - Parallel subagents (conservative on quality gates)
        - Coverage preflight still required (pre-approval or per-PRK)
        - Rich structured report back to parent
```

Full routing logic lives in the individual cookbooks. This SKILL.md stays lean by design.

## Predecessor Skills

This is the spiritual and functional successor to:
- Original `sweep` (heavy automation, thread resolution, autonomous batch)
- `loop-review` (coverage gate, polish pass, clean architecture)

All valuable capabilities from both have been preserved and integrated under a single, disciplined structure.
