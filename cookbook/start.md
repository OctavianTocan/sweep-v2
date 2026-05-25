# Start the Unified Sweep Flow

## Context

You have an open PR (or a branch ready for one) with feedback from any combination of reviewers.

You want the full power of the original sweep engine (thread resolution, rebase analysis, learning system, autonomous batch) **without ever compromising** the quality standards from loop-review.

## Recommended Entry Points

Most people start with one of these:

- `/sweep-v2` (or `/sweep-v2 <PR#>` / branch) → Full guided single-PR flow
- `/sweep-v2 ls` → See what needs attention
- `/sweep-v2 polish` → Just run the highest-leverage quality step
- `/sweep-v2 changes requested` → Process your entire review queue

## What the Full Flow Guarantees (v2)

1. Coverage preflight is run and risk is explicitly accepted when necessary.
2. Rebase impact is analyzed (not ignored).
3. Visual/styling changes require human approval.
4. Rationalization is prevented — resolved threads have real citations.
5. A high-signal polish pass is performed.
6. All checks (typecheck/build/lint/test) are green at the end.
7. Structured learning records are emitted for future sweeps.

This is the new standard for turning review feedback into production-ready code.

See `SKILL.md` for the complete decision tree and command reference.
