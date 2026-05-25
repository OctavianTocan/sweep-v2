# Sweep v2 Architecture — Unified Flows (Option A)

## Core Principle

**Sweep v2 = Powerful Engine + Non-Negotiable Quality Soul**

- The **engine** (from original sweep) provides real operational power: GitHub thread resolution at scale, worktree-based autonomous batch, rebase impact analysis, learning system, and production-grade scripting.
- The **soul** (from loop-review) enforces hard quality gates that cannot be bypassed without explicit risk acceptance: coverage preflight and high-signal polish pass.

The architecture must make the quality gates **mandatory phases** inside every significant flow while still allowing the engine to do the heavy lifting.

## High-Level Layering

```
SKILL.md (lean router + philosophy)
├── cookbook/
│   ├── start.md              ← Main entry point for single PR
│   ├── preflight.md          ← HARD GATE: Coverage (non-skippable by default)
│   ├── polish-pass.md        ← HIGH-VALUE: Self-review polish (strongly recommended)
│   ├── ls.md                 ← Discovery
│   ├── single.md             ← Interactive single-PR flow (engine + gates)
│   ├── batch.md              ← Multi-PR autonomous mode (engine + gates)
│   ├── rebase-triage.md      ← Rebase handling
│   ├── build-verify.md       ← Mandatory final check loop
│   └── ...
├── references/
│   ├── rebase-analysis-agent.md
│   ├── learning-system.md
│   ├── architecture.md       ← This file
│   ├── visual-changes-gate.md
│   └── ...
├── examples/
└── scripts/                  ← Proven operational primitives (do not bloat SKILL.md)
```

## Mandatory Quality Gates

These two gates are **non-negotiable** in v2:

1. **Coverage Preflight** (`cookbook/preflight.md`)
   - Runs early in single and batch flows.
   - Yellow/Red findings require explicit user "accept risk" before proceeding to heavy work or autonomous execution.
   - This is the #1 philosophical win from loop-review.

2. **Polish Pass** (`cookbook/polish-pass.md`)
   - Runs after feedback resolution and before final verification.
   - Even on "small" PRs, it is the highest-leverage step for long-term code health.
   - This is the #2 philosophical win from loop-review.

All other powerful machinery (thread resolution, pattern grouping, rebase analysis, autonomous batch) must **flow through or around** these two gates without weakening them.

## Flow Composition (Single Mode)

Typical happy path for `/sweep-v2 123`:

1. Identify PR + context (engine)
2. **Mandatory**: Coverage Preflight gate (soul) → user must accept risk if needed
3. Rebase + Rebase Impact Analysis (engine, using rebase-triage + rebase-analysis-agent)
4. Feedback consumption loop (engine + pattern grouping + visual gate)
5. **Strongly recommended**: Polish Pass (soul)
6. **Mandatory**: Build Verification Loop (engine, using run-checks.sh)
7. Thread resolution + PR hygiene + re-request reviews (engine)
8. Structured fix records → feed learning system

Single mode keeps the human in the loop for judgment calls (visual changes, rebase escalations, risk acceptance).

## Flow Composition (Batch / Autonomous Mode)

For `/sweep-v2 123 456 789` or status-based filters:

- Worktree isolation per PR (proven scripts)
- Parallel Opus subagents (references/autonomous-sweep.md will be ported)
- **Still enforces**:
  - Coverage preflight (can be run in the worktree before heavy work)
  - Visual changes gate (skip + escalate in autonomous mode)
  - Rebase impact safety rules (never auto-fix stale_approach / behavioral_conflict)
  - Build verification at the end
- Human receives a structured report with escalations

Autonomous mode is deliberately more conservative on quality gates than the old sweep.

## Rebase Impact Analysis (Preserved Strength)

This is one of sweep's most sophisticated features and must remain first-class.

- Two-pass: fast triage (`rebase-triage.md`) → deep agent analysis (`rebase-analysis-agent.md`)
- Clear safety rules: low confidence or dangerous verdicts → escalate, never auto-fix in batch
- Trivial fixes can be applied mechanically
- Integrated into both single and autonomous flows

## Learning System

The `.sweep-lessons.json` + pattern learning + regression test generation system is preserved and will be enhanced with the new quality gates (e.g., coverage gaps discovered during preflight can become learnable patterns).

## Visual Changes Gate (Hard Rule)

Any change that touches CSS, Tailwind, theme tokens, colors, shadows, focus states, animations, etc. requires explicit human approval.

- Single mode: ask the user
- Batch/autonomous mode: skip + flag as `VISUAL_CHANGE_SKIPPED` with the original reviewer comment

This rule comes from painful real-world experience and is non-negotiable.

## Rationalization Prevention

Every resolved review thread must be able to cite a specific file:line where the fix was made (or a deliberate decision with evidence).

This prevents the common failure mode of "resolving everything to make the dashboard green" while leaving the actual problems untouched.

## Commit & PR Hygiene

- Conventional commits preferred
- Co-Authored-By lines for agent work (as in the original sweep)
- PR description updates
- Re-request reviews from humans when appropriate

## Future Evolution

As this skill matures, we expect:
- Tighter integration between the learning system and the coverage gate
- Better support for stacked PR workflows (building on check-base-dep.sh)
- More opinionated defaults for common frameworks
- Richer structured output for reports and learning

The architecture prioritizes **long-term code health over short-term reviewer dashboard scores**.

This is the new standard.
