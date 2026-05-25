# Rebase Analysis Agent — Prompt Template & Verdict Schema

## Purpose

This is the prompt template for deep-analysis agents spawned during rebase impact analysis. One agent is spawned per `needs_deep_analysis` file, run **sequentially** (not in parallel) to control token costs. Agents are **READ-ONLY analyzers** — they never edit files.

This is one of the most sophisticated and valuable pieces of intellectual property from the original sweep.

## Agent Prompt Template

The prompt below should be used verbatim with placeholders replaced. Wrap it in a code fence when dispatching.

~~~
You are analyzing whether a PR's changes are still correct after rebasing
onto {BASE_BRANCH}.

## Your File: {overlap_file}

### What main changed in this file:
{base_diff}

### What the PR changes in this file:
{pr_diff}

### Current state of the file (post-rebase):
{full_file_content_or_truncated}

### Functions in dependent files that reference this file:
{dependent_references}

### All overlap files (for cross-file awareness):
{summary_of_all_overlaps}

## Your Task

1. Check for STALE APPROACHES: Did main introduce new patterns, utilities,
   or abstractions that the PR should be using instead of its current
   approach? Look for new exports, wrapper functions, or refactored
   patterns that supersede what the PR does.

2. Check for BEHAVIORAL CONFLICTS: Did main change function signatures,
   return types, side effects, or contracts that the PR's code assumes?
   Check both the overlap file and its dependents for assumption
   mismatches.

3. For each issue found, explain:
   - What main changed (specific lines/functions)
   - What the PR assumes (specific lines/functions)
   - Why this is a regression risk
   - How to fix it (preserve PR's intent while adopting main's changes)

4. Return a structured JSON verdict with these exact fields:
   - "file": string — the overlap file path
   - "verdict": "stale_approach" | "behavioral_conflict" | "safe" | "trivial_fix"
   - "confidence": "high" | "medium" | "low"
   - "summary": string — one-paragraph explanation
   - "stale_patterns": string[] — patterns main introduced that PR should adopt
   - "behavioral_changes": string[] — behavioral changes PR doesn't account for
   - "suggested_fix": string — how to fix (minimal, preserving PR intent)
   - "affected_lines": string[] — file:line references for affected code
   - "cross_file_note": string | null — notes about other overlap files

## Rules
- You are a READ-ONLY analyzer. Do not suggest rewriting the PR.
  Suggest minimal changes that align the PR with main's new state.
- If you're uncertain, set confidence to "low" — false negatives
  (missing a real issue) are worse than false positives.
- Check dependents: a function signature change in the overlap file
  may break callers that the PR also modified.
- Return ONLY the JSON object. No markdown, no explanation outside the JSON.
~~~

## Input Preparation

Instructions for the caller on how to prepare each placeholder:

### `{full_file_content_or_truncated}`
- If the file is 500 lines or fewer: include the complete file content.
- If the file exceeds 500 lines: extract only the functions touched by either diff, plus 50 lines of context above and below each function. Use the `@@` hunk headers from both diffs to identify which functions were touched. Separate extracted sections with `// ... (truncated) ...` markers.

### `{dependent_references}`
- Use the grep-based heuristic from `cookbook/rebase-triage.md` to find files that import the overlap file.
- For each dependent (max 5), include:
  - The import statement(s) referencing the overlap file
  - The function bodies that use imports from the overlap file (not the entire file)
- Prioritize dependents the PR also modifies over unmodified dependents.

### `{summary_of_all_overlaps}`
- One line per overlap file in the format:
  ```
  src/api/fetcher.ts — main: refactored fetch() to use apiClient wrapper
  src/api/types.ts — main: renamed ApiResponse to ApiResponseV2, added retryCount field
  src/hooks/useData.ts — main: added retry logic with exponential backoff
  ```
- Keep summaries to one sentence each. The agent uses this for cross-file awareness, not deep analysis of other files.

## Verdict JSON Schema

| Field | Type | Description |
|-------|------|-------------|
| `file` | `string` | The overlap file path being analyzed |
| `verdict` | `"stale_approach" \| "behavioral_conflict" \| "safe" \| "trivial_fix"` | The classification of the overlap |
| `confidence` | `"high" \| "medium" \| "low"` | How confident the agent is in this verdict |
| `summary` | `string` | One-paragraph explanation of the finding |
| `stale_patterns` | `string[]` | Patterns main introduced that PR should adopt. Empty if verdict is not `stale_approach`. |
| `behavioral_changes` | `string[]` | Behavioral changes the PR doesn't account for. Empty if verdict is not `behavioral_conflict`. |
| `suggested_fix` | `string` | Minimal fix description preserving the PR's intent |
| `affected_lines` | `string[]` | `file:line` references for code that needs changing |
| `cross_file_note` | `string \| null` | Notes about how other overlap files relate to this finding |

### Example Verdicts

**stale_approach:**
```json
{
  "file": "src/api/fetcher.ts",
  "verdict": "stale_approach",
  "confidence": "high",
  "summary": "Main introduced an apiClient wrapper that replaces raw fetch() calls with centralized error handling and retry logic. The PR adds custom error handling directly to raw fetch() calls, duplicating what apiClient already provides.",
  "stale_patterns": ["raw fetch() calls should use apiClient.get()/apiClient.post() instead"],
  "behavioral_changes": [],
  "suggested_fix": "Replace fetch() calls in the PR with apiClient equivalents. Preserve the PR's custom error messages by passing them as options to apiClient.",
  "affected_lines": ["src/api/fetcher.ts:45-67", "src/api/fetcher.ts:112-130"],
  "cross_file_note": "types.ts also changed — ApiResponse now has a retryCount field that apiClient populates automatically"
}
```

**behavioral_conflict:**
```json
{
  "file": "src/hooks/useData.ts",
  "verdict": "behavioral_conflict",
  "confidence": "high",
  "summary": "Main changed useData to return { data, error, isRetrying } instead of { data, error }. The PR destructures the return value as { data, error } and renders a loading spinner based on !data && !error, which will now show during retries when isRetrying is true but data is temporarily null.",
  "stale_patterns": [],
  "behavioral_changes": ["useData return type expanded: now includes isRetrying boolean", "data is temporarily null during retry cycles"],
  "suggested_fix": "Update the PR's destructuring to include isRetrying. Change the loading condition to !data && !error && !isRetrying to avoid showing spinner during retries.",
  "affected_lines": ["src/hooks/useData.ts:23", "src/components/DataView.tsx:45"],
  "cross_file_note": null
}
```

**safe:**
```json
{
  "file": "src/utils/format.ts",
  "verdict": "safe",
  "confidence": "high",
  "summary": "Main added a new formatCurrency() export. The PR modified formatDate() in the same file. The functions are independent — different imports, no shared state, no overlapping logic.",
  "stale_patterns": [],
  "behavioral_changes": [],
  "suggested_fix": "No changes needed.",
  "affected_lines": [],
  "cross_file_note": null
}
```

**trivial_fix:**
```json
{
  "file": "src/api/types.ts",
  "verdict": "trivial_fix",
  "confidence": "high",
  "summary": "Main renamed ApiResponse to ApiResponseV2. The PR uses ApiResponse in two places. This is a mechanical rename.",
  "stale_patterns": [],
  "behavioral_changes": [],
  "suggested_fix": "Replace ApiResponse with ApiResponseV2 in the two locations.",
  "affected_lines": ["src/api/types.ts:12", "src/api/client.ts:78"],
  "cross_file_note": null
}
```

## Safety Rules (Critical)

- **Never auto-fix** `stale_approach` or `behavioral_conflict` in autonomous/batch mode. These require human judgment about PR intent.
- Low confidence or malformed output → always escalate.
- Sequential spawning (one file at a time) prevents token explosion.
- Agents have a 2-minute timeout.

This mechanism has prevented multiple production regressions in the past.
