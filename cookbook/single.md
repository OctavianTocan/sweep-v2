# Single PR Sweep (Interactive with Full Quality Gates)

## Context

Use when the user invokes `/sweep-v2 <PR#>` or `/sweep-v2 <branch-name>`.

This is the primary interactive mode. The human stays in the loop for all judgment calls (visual changes, risk acceptance, rebase escalations, difficult feedback).

**Core contract in v2**: Every meaningful flow must pass through the mandatory quality gates (coverage preflight + strong encouragement of polish pass) while still leveraging the full power of the original sweep engine.

## Prerequisites

- `gh` authenticated
- Clean or intentionally stashed working tree
- Willingness to be honest about test coverage

## Steps

### 1. Identify the PR

**If given a PR number:**

```bash
gh pr view <PR_NUMBER> --json number,title,headRefName,baseRefName,url \
  --jq '{number: .number, title: .title, branch: .headRefName, base: .baseRefName, url: .url}'
```

**If given a branch name:**

```bash
gh pr list --head <BRANCH_NAME> --json number,title,headRefName,baseRefName,url \
  --jq '.[0] | {number: .number, title: .title, branch: .headRefName, base: .baseRefName, url: .url}'
```

If no PR is found, tell the user and stop (or offer to create one in pre-PR mode).

### 1b. Base Branch Dependency Check (Stacked PRs)

If the PR's `base` is not `main`/`master`:

```bash
bash scripts/check-base-dep.sh "$OWNER" "$REPO" "<BASE_BRANCH>"
```

Present findings and offer to sweep the dependency first when appropriate.

### 2. Mandatory: Coverage Preflight Gate

**This step is non-skippable by default.**

Read and execute: [cookbook/preflight.md](preflight.md)

- Launch coverage subagent on the diff.
- Present Green / Yellow / Red assessment with specific gaps.
- On Yellow or Red: **Stop** and require explicit user risk acceptance before proceeding to steps 3+.

Document any accepted risk in the PR description.

### 3. Rebase + Rebase Impact Analysis (Mandatory when behind)

```bash
git fetch origin <BASE_BRANCH>
git merge-base --is-ancestor origin/<BASE_BRANCH> HEAD
```

If not up to date:
- Capture `OLD_MERGE_BASE`
- Offer to rebase (recommended)
- If rebase happens, run the two-pass rebase impact analysis:

  1. **Triage** — Read [cookbook/rebase-triage.md](rebase-triage.md)
     - Classify overlap files as `likely_safe`, `trivial_fix`, or `needs_deep_analysis`
     - Batch shortcut: ≤3 overlap files → treat all as `needs_deep_analysis`

  2. **Deep Analysis** (for `needs_deep_analysis` files) — Use [references/rebase-analysis-agent.md](rebase-analysis-agent.md)
     - Spawn sequential read-only agents
     - Present findings grouped by severity
     - In single mode: human decides per finding (fix / skip / review in detail)
     - Never auto-fix `stale_approach` or `behavioral_conflict`

Apply trivial fixes mechanically and commit them separately.

### 4. Core Feedback Loop (max 5 iterations)

#### A. Fetch Unresolved Threads

```bash
bash scripts/fetch-threads.sh "$OWNER" "$REPO" "$PR_NUMBER"
```

Also detect bots:

```bash
bash scripts/detect-bots.sh "$OWNER" "$REPO" "$PR_NUMBER"
```

#### B. Exit Conditions

- Zero unresolved threads + (no bot reviewer OR latest bot review is 5/5 or clean)
- Max iterations reached

#### C. Classify + Group by Pattern

Classify each unresolved comment:
- Type: Actionable / Question / Informational / False positive / Outdated
- Severity: Blocking / Important / Nit / Suggestion

**MANDATORY: Apply the Visual Changes Gate** (see [references/visual-changes-gate.md](visual-changes-gate.md))

Group actionable comments by underlying pattern (kebab-case pattern IDs, reusing from `.sweep-lessons.json` when possible).

See pattern grouping logic in the original sweep SKILL.md (to be fully ported into a dedicated reference).

#### D. Fix Pattern Groups (in severity order)

For each group:

1. Visual gate check first.
2. Fix the flagged instance (use Code Location Strategy: line → diffHunk → originalLine → grep).
3. Decide whether to expand/scan for related instances (general concern → expand; one-off → usually not).
4. Fix confirmed related instances.
5. Emit a **structured fix record** (see [references/structured-fix-records.md](structured-fix-records.md)).
6. Reply on threads with precise language + citation of locations + regression test status.

**Rationalization gate** (see [references/rationalization-prevention.md](rationalization-prevention.md)): Never resolve a thread unless you can cite a real file:line fix or a deliberate documented decision.

#### E. Resolve Threads

Use:

```bash
bash scripts/resolve-threads.sh THREAD_ID_1 THREAD_ID_2 ...
```

Only resolve threads you have genuinely addressed or made a clear decision on.

#### F. Commit + Push

Use clear, pattern-aware conventional commits. Include `Co-Authored-By` for agent work when appropriate.

### 5. Strongly Recommended: Polish Pass

After the feedback loop:

Read and execute: [cookbook/polish-pass.md](polish-pass.md)

This is the highest-leverage step in the entire skill. Even on small PRs, run it.

### 6. Mandatory: Build Verification Loop

**Never ship a PR with broken checks.**

Use the ported tooling:

```bash
bash scripts/run-checks.sh
```

If failures:
- Fix all errors from the failing check.
- Re-run.
- Max 5 iterations.
- Research non-obvious framework errors properly (do not guess).

Only proceed when all checks are green.

### 7. Final Hygiene

- Update PR description (summary of changes, risk acceptances, test coverage notes).
- Re-request review from human reviewers when appropriate:

  ```bash
  bash scripts/rerequest-review.sh "$OWNER" "$REPO" "$PR_NUMBER" <user1> <user2>
  ```

- Push final state.

## Exit Criteria for a Good Single Sweep

- All blocking and important feedback addressed or deliberately deferred with evidence.
- Coverage preflight passed or risk explicitly accepted in writing.
- Polish pass completed.
- All quality gates (typecheck / build / lint / test) green.
- No rationalization — every resolved thread has a verifiable citation.
- Visual changes were either approved or skipped with clear notes.
- Rebase impact (if any) was analyzed and handled appropriately.

This is the new standard.
