# Learning System (.sweep-lessons.json)

## Purpose

Sweep v2 captures recurring patterns (both violations and positive examples) so the skill and the team get better over time.

## Schema

See the original sweep's `references/lessons-schema.md` for the full structure (patterns with id, type, category, occurrences, has_regression_test, etc.).

## Integration in v2

- Pattern grouping during fix loops reuses existing lesson IDs when possible.
- Structured fix records feed the learning system.
- Regression tests are generated for blocking/important patterns.
- Stats and pattern-learning cookbooks will be ported.

This is a major long-term value multiplier being preserved.
