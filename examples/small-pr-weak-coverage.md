# Example: Small PR with Minor Feedback + Weak Coverage

## Scenario

A developer has a small PR with 3 review comments (two nits, one important null-guard request).

They run `/sweep-v2`.

## What Sweep v2 Does

1. Preflight coverage gate discovers that a new exported utility has zero unit tests.
2. Skill stops and clearly shows the gap.
3. User adds the test, re-runs.
4. Feedback is processed (important one fixed + expanded to related instances using pattern logic).
5. High-signal polish pass adds excellent TSDoc and removes a code smell.
6. Build verification loop passes cleanly.
7. Threads resolved with precise "Fixed in commit X, test added" comments.
8. PR description updated.

Result: Not just "reviewers happy", but actually better code with coverage.
