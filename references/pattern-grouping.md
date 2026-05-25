# Pattern Grouping & Expansion

## Goal

When processing review comments, group them by the *underlying problem* rather than treating every comment as an isolated one-off. This allows us to fix the root cause across the whole PR (and sometimes the codebase) instead of just the exact line the reviewer pointed at.

This technique comes from the original sweep and is a major source of leverage.

## How to Group

1. Classify the comment as Actionable.
2. Identify the root pattern (give it a stable kebab-case `pattern_id`).
3. Before inventing a new ID, check `.sweep-lessons.json` and reuse an existing one if the root cause matches.
4. Examples of good pattern IDs:
   - `unguarded-dom-ref`
   - `unhandled-async-error`
   - `misleading-variable-name`
   - `missing-tsdoc-on-export`
   - `missing-effect-cleanup`

## Grouping Examples

| Comment A | Comment B | Same Pattern? | Reason |
|-----------|-----------|---------------|--------|
| "Add null check on scrollRef" | "inputRef could be null here too" | Yes | Both are `unguarded-dom-ref` |
| "This fetch needs error handling" | "Handle the 429 case on this API call" | Yes | Both `unhandled-async-error` |
| "Rename `data` to `userProfile`" | "This variable name is misleading" | Yes | Both `misleading-naming` |
| "Add error handling" | "This error leaks internal paths" | No | Different root concerns |

**Default rule when uncertain**: Split into separate groups. Over-splitting is safe; over-merging can cause incorrect fixes.

## Expand or Don't Expand?

After fixing the originally flagged instance, decide whether to proactively scan for related instances:

**Expand (general concern):**
- "Add a null check here" → scan other refs in modified files
- "This needs error handling" → scan other similar async calls

**Do not expand (one-off):**
- A very specific comment about one particular line that doesn't generalize

In single mode: Show the candidate related instances and ask the user.
In autonomous/batch mode: Auto-fix high-confidence matches (with a conservative limit, e.g. max 10 per group) and flag uncertain ones.

## Connection to Learning System

Every time you fix a pattern group (especially with related instances), emit a structured fix record. Over time these feed `.sweep-lessons.json`, making future sweeps faster and more accurate.

Pattern grouping + learning is one of the features that makes sweep v2 get better with use.
