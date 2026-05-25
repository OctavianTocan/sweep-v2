# Structured Fix Records

## Purpose

During fix loops, sweep v2 emits structured records for every meaningful change. These records power:

- Pattern grouping and learning (`.sweep-lessons.json`)
- Regression test generation
- Stats and reporting
- Long-term improvement of the skill itself

## Record Shape (Current)

```json
{
  "fix_id": "uuid-or-sequential",
  "pattern_id": "kebab-case-pattern-name (reused from lessons when possible)",
  "severity": "blocking" | "important" | "nit" | "suggestion",
  "category": "null-safety" | "error-handling" | "naming" | "performance" | ...,
  "reviewer": "login or 'human' or bot name",
  "flagged_file": "path:line",
  "additional_instances": ["path:line", ...],
  "fix_description": "One-sentence description of what was done",
  "has_regression_test": boolean,
  "rationale": "Why this change was made (especially important for pushback decisions)",
  "thread_ids": ["node_id_1", ...]
}
```

## When to Emit

- After successfully fixing a pattern group (including any expanded related instances)
- After a deliberate decision not to fix something (for learning)
- After discovering a positive pattern worth capturing

## Usage in v2

These records are the bridge between the powerful engine (thread resolution, pattern scanning) and the quality soul (they feed into polish considerations and coverage awareness over time).

Full schema and persistence rules will be aligned with the original `references/lessons-schema.md`.
