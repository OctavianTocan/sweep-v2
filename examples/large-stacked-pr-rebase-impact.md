# Example: Large Stacked PR with Rebase Impact + Coverage Gap

## Scenario

A large feature PR (#842) stacked on another PR. After rebasing onto main, several files now overlap with changes from the base branch. Reviewers (including Greptile) left 14 comments. Coverage on a new payment utility is weak.

## What Sweep v2 Does

1. Detects the stacked dependency and recommends sweeping the base PR first.
2. Runs coverage preflight → surfaces the payment utility gap as **Red**. User accepts risk temporarily to unblock.
3. Captures old merge-base, rebases, then runs full rebase impact analysis.
   - Triage finds 4 overlap files.
   - 1 trivial import rename → fixed mechanically.
   - 1 `needs_deep_analysis` file → agent identifies a stale approach (main introduced a new `PaymentClient` the PR should use).
   - Human reviews the agent verdict and approves the fix.
4. Processes all 14 review comments with pattern grouping (several related null-guard issues are found and fixed together).
5. Visual change suggestion from Greptile is automatically skipped and flagged.
6. Runs the full polish pass (excellent docs + removal of debug code + consistent error handling).
7. Mandatory build verification loop fixes two type errors introduced during the rebase fixes.
8. Emits structured fix records that improve the team's learning system.
9. All resolvable threads are resolved with precise citations. Two threads left open with clear notes.

Result: The PR is not just "reviewer clean" — it has proper coverage decisions documented, rebase drift handled correctly, and high-quality code.
