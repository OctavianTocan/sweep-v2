# Pre-flight Coverage Gate (Hard Opinionated)

## Context

This is the most important gate in the entire skill.

Weak test coverage is the fastest way for AI-driven fixes to introduce regressions that no reviewer will catch until production.

## Philosophy

We do **not** chase perfect reviewer scores at the expense of test coverage.

A PR with:
- 98% reviewer approval
- 0 new unit tests on 400 lines of new logic
- 1 happy "LGTM" from a human

...is a **liability**, not a win.

This gate exists to protect long-term code health.

## When to Run

- As part of the main `/sweep-v2` flow (mandatory by default)
- Manually via `/sweep-v2 preflight`
- Before opening a PR

## Process

(Full detailed steps from the original loop-review preflight will be integrated here.)

For now: this gate must be run and the user must explicitly accept risk on Yellow/Red findings before heavy iteration or batch execution proceeds.

## Why This Gate Exists

AI reviewers optimize for what they can see in the diff.

They cannot see the 2am production incident caused by an untested edge case.

Use this gate.
