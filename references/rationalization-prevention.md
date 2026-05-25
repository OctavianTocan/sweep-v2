# Rationalization Prevention

## The Problem

A common failure mode in review tools (including early versions of sweep) is "resolving everything to make the dashboard green" while the actual code problems remain untouched or only superficially addressed.

This is called **rationalization**.

## Rule

**Every resolved review thread must be able to cite a specific, verifiable file:line where the fix (or deliberate decision) was made.**

Before calling the thread resolution script (or marking a thread resolved), the agent must:

1. Re-read the exact line(s) in the current working tree.
2. Confirm that the change at that location actually addresses the reviewer's concern.
3. If it cannot verify, **do not resolve the thread**.

## Acceptable Outcomes

- **Fixed**: Real code change at a specific location. Cite `path:line`.
- **Deliberate decision with evidence**: The concern was considered, a tradeoff was made, and the reasoning is documented in a reply (and ideally in code comments or PR description). Still cite the relevant location.
- **Out of scope / stale**: Clearly documented why it no longer applies.

## Unacceptable Outcomes

- "Fixed." with no citation
- Resolving a thread because "the reviewer will probably be happy"
- Mass-resolving after a superficial change
- Resolving questions as if they were actionable code requests

## Implementation Notes

- Single mode: The human sees the proposed resolution and can override.
- Autonomous/batch mode: Any thread that cannot be verified with a concrete location is left in `REMAINING` with a clear reason. The final report surfaces these for human review.

This rule is a core part of sweep v2's integrity.
