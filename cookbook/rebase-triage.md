# Rebase Triage Cookbook

Classifies overlap files after a rebase to determine whether each needs deep agent analysis or can be handled cheaply.

## 1. Context

This cookbook runs after a rebase when `$OVERLAP` is non-empty (files changed by both the base branch and the PR). It is shared by single mode and batch/autonomous modes. Its purpose is to classify each overlap file to determine whether it needs deep agent analysis or can be handled cheaply.

**This is one of the most valuable capabilities preserved from the original sweep.**

## 2. Batch-Mode Shortcut

If the total overlap file count is **3 or fewer**, skip triage entirely and classify **ALL** files as `needs_deep_analysis`. The token cost of analyzing 3 files is low and this eliminates the risk of triage misclassifying a file that actually needs deep analysis.

## 3. Triage Classification Table

| Classification | Criteria | Action |
|---|---|---|
| `likely_safe` | Diffs touch unrelated sections of the file (different functions, no overlapping hunks). No new exports or patterns introduced by main in this file. | Continue, no agent needed |
| `trivial_fix` | Main renamed an import, updated a path, or introduced a utility with an obvious 1:1 mapping to what the PR uses. The fix is mechanical substitution. | Fix inline without agent |
| `needs_deep_analysis` | Matches any deep-analysis heuristic (see next section). | Spawn analysis agent |

## 4. Deep-Analysis Heuristics

For each heuristic below, the detection method is described in terms of reading the actual diffs.

### Heuristic 1: Main introduced new exports/functions

In the base diff (`git diff $OLD_MERGE_BASE..origin/<BASE_BRANCH> -- <file>`), look for lines starting with `+export` or `+function` or `+const ... = () =>` that are adding new public API.

If main added new exports **and** the PR's diff uses any function or utility that serves the same purpose, classify as `needs_deep_analysis`.

### Heuristic 2: Main changed function signatures

In the base diff, look for modified function declarations: lines where parameters, return types, or generics changed (the `-` line has the old signature, the `+` line has the new one).

Then check the PR diff: does the PR call any of those changed functions? Use grep on the PR diff for the function name.

If yes, classify as `needs_deep_analysis`.

### Heuristic 3: Same function body modified by both

Parse the diff hunks from both diffs. Extract function names from the `@@` hunk headers (e.g., `@@ -45,12 +45,15 @@ function handleScroll`).

If any function name appears in **both** the base diff and the PR diff hunk headers, classify as `needs_deep_analysis`.

## 5. Resolving Dependents

Use a grep-based heuristic to find files that import or depend on an overlap file:

```bash
# Strip path to get the importable stem (e.g., src/api/fetcher.ts → api/fetcher or fetcher)
STEM=$(basename "<overlap_file>" | sed 's/\.\(ts\|tsx\|js\|jsx\)$//')

# Find files that import this module (adjust extensions for project language)
grep -rl "from.*['\"].*${STEM}['\"]" --include='*.ts' --include='*.tsx' --include='*.js' --include='*.jsx' . | head -20
```

**Prioritization rules:**

1. Files the PR also modifies (`$PR_CHANGED`) come first — they are most likely to have consistency issues
2. Then sort remaining by reference count (more references = more likely to be affected)
3. Max 5 dependents per overlap file to keep agent context manageable

## 6. Escape Hatch (Single Mode Only)

After presenting triage results, let the user promote any `likely_safe` file to `needs_deep_analysis` before agents run:

```
Promote any likely_safe file to deep analysis? (file names separated by space / no)
```

This catches cases where the heuristics miss a non-obvious relationship.

In batch/autonomous mode, the batch shortcut (section 2) handles this — for small overlap counts, all files get deep analysis regardless.

## 7. Trivial Fix Handling

For files classified as `trivial_fix`, fix inline without spawning an agent:

- **Renamed imports:** find the old import in the PR's code, replace with the new name from main's diff
- **Updated paths:** same approach — find old path references, replace with new
- **New utility with obvious 1:1 mapping:** replace the old utility call with the new one

Commit trivial fixes separately from agent-verified fixes:

```bash
git add -A
git commit -m "fix: align trivial imports with upstream changes

Co-Authored-By: Claude Opus 4.6 (1M context) <noreply@anthropic.com>"
```
