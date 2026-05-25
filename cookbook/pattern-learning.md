# Pattern Learning & Lessons System

## Purpose

Sweep v2 doesn't just fix the current PR — it gets smarter over time by capturing recurring patterns (both problems and good solutions).

The learning system lives in `.sweep-lessons.json` at the root of the target repository. It is committed with the PR so the whole team benefits.

## Core Concepts

- **Violation patterns**: Bad things we keep fixing (unguarded refs, missing error handling, misleading names, etc.)
- **Positive patterns**: Good solutions worth replicating (clean ErrorBoundary implementation, excellent test setup, etc.)
- **Structured fix records**: What we emit during a sweep that feed this system (see references/structured-fix-records.md)

## When to Use / Update Lessons

### During a Sweep (Single or Batch)

1. Before fixing a pattern group, read `.sweep-lessons.json` (if it exists).
2. Reuse an existing `pattern_id` when the root cause matches.
3. After successfully fixing a group (especially with related instances), emit a structured fix record.
4. If this is a new pattern or a significant positive example, consider adding it to the lessons file.

### After the Sweep

The parent agent (or you in interactive mode) can propose updates to `.sweep-lessons.json`:

- Increment `occurrences`
- Update `last_seen` and add the PR to the `prs` list
- Set `has_regression_test: true` if a regression test was added
- For positive patterns, record the `file` location

## Creating New Patterns

When you encounter a recurring issue that doesn't have a lesson yet:

- Give it a clear, stable `kebab-case` ID.
- Write a one-line `description` that explains both what and why.
- Decide the `category` and `scope` (file / project / universal).
- Add it via a structured fix record during the sweep.

Example new violation:
```json
{
  "id": "missing-retry-on-429",
  "type": "violation",
  "category": "error-handling",
  "scope": "project",
  "description": "Fetch calls to our APIs must retry on 429 with exponential backoff",
  "occurrences": 1,
  "first_seen": "2026-05-25",
  "last_seen": "2026-05-25",
  "prs": ["#842"],
  "has_rule": false,
  "has_regression_test": true
}
```

## Using Lessons Proactively

In future sweeps, the system (and you) can scan the current diff for known patterns from `.sweep-lessons.json` and apply fixes before reviewers even comment.

This is one of the highest-leverage long-term benefits of sweep v2.

## Stats & Reporting

See `cookbook/stats.md` (to be expanded) for querying pattern frequency, rule coverage, and outcome metrics across the team's history.

## Best Practices

- Keep descriptions short but specific.
- Prefer reusing IDs over creating near-duplicates.
- Positive patterns are just as valuable as violation patterns.
- Always tie lessons back to real PRs and (ideally) regression tests.
- Deprecate patterns with `"deprecated": true` when they no longer apply instead of deleting them.

The learning system turns every sweep into an investment in the team's future velocity and code quality.
