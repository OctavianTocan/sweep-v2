# sweep-v2

The unified PR review skill.

**Powerful GitHub automation + hard opinionated quality gates.**

This is the v2 successor that merges the best of the original `sweep` (thread resolution, rebase impact analysis, autonomous batch, operational tooling) with `loop-review` (mandatory coverage preflight, elevated polish pass, clean progressive disclosure architecture, and "coverage over scores" philosophy).

## Install

```bash
npx skills add OctavianTocan/sweep-v2
```

## Commands

See the full command table in `SKILL.md`.

Quick start:

```bash
/sweep-v2          # Full guided flow on current PR
/sweep-v2 ls       # Discover PRs with review comments
/sweep-v2 polish   # Just the high-signal polish pass
```

## Philosophy

- Coverage is a first-class gate, not an afterthought.
- Polish > chasing reviewer metrics.
- Never leave a PR with unexamined rebase drift or weak tests.
- Automation is a tool, not a substitute for judgment (especially on visual changes and complex rebase impacts).

## Development

This skill follows the strict create-skill format (lean `SKILL.md` + detailed cookbooks + references + examples).

Contributions and feedback are welcome.

## License

MIT
