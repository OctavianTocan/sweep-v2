# Start the Unified Sweep Flow

## Context

You have an open PR (or a branch ready for one) with feedback from reviewers.

You want the full power of automated thread resolution + rebase analysis + batch capabilities, **without ever compromising** on coverage or code quality.

## Steps (High Level)

1. Confirm branch and PR context.
2. **Mandatory**: Run the hard coverage preflight gate (see cookbook/preflight.md).
   - User must explicitly accept risk on any Yellow/Red findings.
3. Rebase + rebase impact analysis (see references/rebase-analysis-agent.md and cookbook/rebase-triage.md).
4. Process review feedback (single or batch mode).
5. Run the high-signal self-review polish pass (see cookbook/polish-pass.md).
6. Build verification loop (mandatory — never ship broken checks).
7. Update PR, re-request reviews, resolve threads where appropriate.
8. Final hygiene and push.

## Exit Criteria

- All blocking/important reviewer comments addressed or deliberately deferred with evidence.
- Coverage gate passed or risk explicitly accepted.
- Polish pass completed.
- All checks (typecheck/build/lint/test) green.
- No rationalization — every resolved thread cites a real fix location.

This is the new standard.
