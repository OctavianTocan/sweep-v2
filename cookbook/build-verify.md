# Build Verification Loop (Mandatory Final Gate)

## Context

This is a **non-negotiable** final gate that runs after all reviewer fixes **and** the self-review polish pass.

Sweep v2 must **never** leave a PR in a broken build state.

## Why This Exists

Even excellent fixes and polish work can introduce:
- Type errors from removed/renamed exports
- Lint failures from new code
- Test failures from behavior changes
- Build breaks from framework-level issues

The loop catches these before the human (or CI) does.

## When to Run

- After the polish pass in single mode
- At the end of each PR's autonomous work in batch mode
- As a standalone command if needed: `/sweep-v2 build-verify` (future)

## Process

### 1. Detect and Run Checks

Use the proven script:

```bash
bash scripts/run-checks.sh
```

This script:
- Detects the package manager (bun / pnpm / yarn / npm)
- Discovers available check scripts in package.json
- Runs them in the correct order: **typecheck → build → lint → test**
- Stops at the first failure and reports exactly which check failed

### 2. The Fix Loop (max 5 iterations)

For each iteration:

**A.** Run `scripts/run-checks.sh`

**B.** If all pass → exit successfully.

**C.** If any check fails:
   1. Read the full error output carefully.
   2. Identify **every distinct error** (not just the first one).
   3. Fix **all** errors from that check before re-running.
   4. Stage changes but do **not** commit yet (final commit happens at the end of the loop or with the polish work).

### Common Failure Patterns & Fixes

- **Type errors after removing code**: An import or type was actually still used elsewhere. Restore or update the reference.
- **Type errors from signature changes**: Update all call sites (use the rebase impact lessons here).
- **Build errors from missing exports**: Re-export from the correct barrel/index file.
- **Lint errors**: Run the auto-fixer first (`<pkg> run lint -- --fix`), then fix remaining manually.
- **Test failures**: Update expectations to match the new correct behavior. **Never weaken tests** (no `.skip`, no removing assertions, no lowering coverage thresholds).

### 3. Research Before Guessing (MANDATORY for non-obvious errors)

When you encounter a framework-level, SSR, config, or previously unseen error:

**Do NOT:**
- Guess at config options
- Remove functionality to make the error go away
- Invent API flags

**Do:**
- Use search tools (or your knowledge) to find authoritative sources for the exact error message + your framework + version.
- Read 2–3 sources.
- Verify the fix applies to the project's actual setup.
- Apply the minimal change that preserves all existing behavior.

### 4. Final Commit

Once all checks are green:

```bash
git add -A
git commit -m "chore: pass full build verification (typecheck/build/lint/test)"
git push
```

Or fold the verification fixes into the polish commit if they are small and related.

## Integration with v2 Quality Gates

This loop always runs **after** the polish pass.

Any fixes made here are part of delivering production-ready code, not "just making CI happy."

In autonomous/batch mode, a failing build verification is always escalated to the human.

## Exit Criteria

- All four categories (typecheck, build, lint, test) are green.
- No new warnings were introduced that the project treats as errors.
- The changes are committed and pushed.

This gate is the last line of defense before a PR is considered "ready for final review or merge."
