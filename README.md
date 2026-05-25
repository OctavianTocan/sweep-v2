# sweep-v2

**The unified PR review skill.**

Powerful GitHub automation (thread resolution, rebase impact analysis, autonomous batch with worktrees) + hard opinionated quality gates (mandatory coverage preflight + high-signal self-review polish pass).

This is the v2 successor that merges the best of the original `sweep` and `loop-review`.

## Install

```bash
npx skills add OctavianTocan/sweep-v2
```

After installation you can use commands like:

```bash
/sweep-v2
/sweep-v2 ls
/sweep-v2 123
/sweep-v2 polish
/sweep-v2 changes requested
```

## Philosophy

- **Coverage is non-negotiable.** Weak tests are a liability, not a win.
- **Polish is the highest-leverage step.** Reviewers find problems. You make the code excellent.
- **Automation is powerful but must be conservative** on visual changes, rebase impact, and risk acceptance.
- **Never rationalize.** Every resolved thread must cite a real fix location.
- We preserve and enhance the operational strength of the original sweep while adding the quality discipline of loop-review.

## Core Commands

| Command | Purpose |
|---------|---------|
| `/sweep-v2` | Full guided optimization flow on current PR |
| `/sweep-v2 ls` | Discover PRs with unresolved review comments |
| `/sweep-v2 <PR#>` | Interactive single-PR sweep (full gates) |
| `/sweep-v2 <PR#> <PR#> ...` | Autonomous batch across multiple PRs |
| `/sweep-v2 preflight` | Run only the hard coverage gate |
| `/sweep-v2 polish` | Run only the high-signal polish pass |
| `/sweep-v2 changes requested` | Process all PRs with "changes requested" status |

See `SKILL.md` for the full decision tree and argument parsing rules.

## Key Features Preserved & Improved

- Real GitHub thread fetching & batch resolution (GraphQL)
- Sophisticated rebase impact analysis (triage + deep agents)
- Isolated worktree execution for safe autonomous batch
- Pattern grouping + learning system (`.sweep-lessons.json`)
- Structured fix records
- Hard visual changes gate
- Mandatory build verification loop
- **New in v2**: Non-negotiable coverage preflight + elevated polish pass

## Development & Contribution

This skill follows the strict `create-skill` progressive disclosure format:

- Lean `SKILL.md`
- Detailed cookbooks
- High-signal references
- Realistic examples
- Proven scripts/ layer

All major capabilities from both predecessor skills have been integrated under one disciplined architecture (see `references/architecture.md`).

## License

MIT
