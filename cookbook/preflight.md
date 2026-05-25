# Pre-flight Coverage Gate (Hard Opinionated)

## Context

This is the most important gate in the entire skill.

Weak test coverage is the fastest way for AI-driven fixes to introduce regressions that no reviewer will catch until production.

## Philosophy

We do **not** chase perfect reviewer scores at the expense of test coverage.

A PR with:
- 98% reviewer approval
- 0 new unit tests on 400 lines of new logic
- 1 happy "LGTM" from a human

...is a **liability**, not a win.

This gate exists to protect long-term code health and the humans who will maintain this code after you.

## When to Run

- Automatically as a required phase of the main `/sweep-v2` flow (single and batch)
- Manually via `/sweep-v2 preflight` on any branch you care about
- Before opening a PR (pre-PR mode)

## Process

### 1. Gather Context

Identify the PR (or branch if pre-PR):

```bash
gh pr view --json number,headRefName,baseRefName,additions,deletions,changedFiles
```

If no PR yet, note the branch and changed file count.

### 2. Launch Coverage Subagent

Use a fast, structured model with this prompt (or equivalent):

```
You are a senior test coverage auditor with 15+ years of experience shipping reliable production systems.

Analyze the PR diff for the current branch.

Answer these questions precisely and specifically:

1. Unit test coverage:
   - List every new or significantly modified function, class, or logic path.
   - For each, state whether it has direct unit test coverage (yes/no/partial).
   - If partial or missing, note the specific gap.

2. Integration / E2E coverage:
   - List every user-facing flow or critical path touched by this change.
   - For each, state whether it has at least one integration or E2E test path (yes/no).
   - If missing, note the specific flow that is uncovered.

3. Risk assessment:
   - What is the single highest-risk area in this change that lacks test coverage?
   - Why is it high-risk (blast radius, data loss, security boundary, etc.)?
   - If this change ships with the current coverage, what is the most likely class of regression?

Be specific. Reference file paths and function names.
```

### 3. Evaluate the Result

**Green light (proceed without discussion):**
- All new public APIs and important internal logic have direct unit test coverage.
- Critical user-facing flows have at least one integration/E2E test path.
- No high-risk areas (auth, payments, data migrations, security boundaries, financial calculations) are untested.

**Yellow light (proceed only with explicit risk acceptance):**
- New complex logic with partial or zero unit tests.
- User-facing flows with no test coverage on the changed behavior.
- Moderate-risk areas untested.

**Red light (strongly recommend adding tests before proceeding):**
- High-risk areas with zero test coverage.
- Large surface area changes with minimal or no test changes.
- New public contracts with no test coverage.

### 4. Decision

If coverage is insufficient (Yellow or Red):

1. Clearly state the gaps with specific file/function references.
2. Ask the user:
   - "Do you want to add tests first?"
   - "Do you want to accept the risk and continue anyway?"
   - "Do you want to reduce scope?"

**Default behavior:** Do not proceed with heavy iteration, polish, or batch execution until the user explicitly accepts the risk in writing.

Document the risk acceptance in the PR description if proceeding.

## Special Cases

- Pre-PR mode: Use `git diff main...HEAD`
- Trivial changes (<50 lines, no logic): Coverage analysis may be light but still run the gate.
- Generated code / config: Focus on the generator and integration points.
- Test-only changes: Inherently strong — green light quickly.

## Why This Gate Exists

AI reviewers optimize for what they can see in the diff and what patterns they've been trained on.

They cannot see the production incident at 2am, the future maintainer cursing your name, or the data loss scenario that only appears under load.

This gate is your last line of defense.

Use it.
