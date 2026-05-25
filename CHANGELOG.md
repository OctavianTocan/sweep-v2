# Changelog

All notable changes to sweep-v2 will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [2.0.0] - 2026-05-25

### Added

- **Unified architecture**: Complete merger of original `sweep` (powerful engine) and `loop-review` (quality soul) into a single disciplined skill.
- **Mandatory Coverage Preflight**: Hard, non-skippable gate (with explicit risk acceptance) that must be passed before heavy iteration. This is now the #1 quality principle.
- **Elevated Polish Pass**: The high-signal self-review polish pass is now a first-class, strongly recommended (and in many flows effectively mandatory) step.
- **Architecture reference**: New `references/architecture.md` clearly documents the "Powerful Engine + Non-Negotiable Quality Soul" design (Option A).
- **Full rebase impact analysis**: Preserved and improved the sophisticated two-pass system (triage + sequential deep agents) with strict safety rules.
- **Visual Changes Gate**: Hard rule with different behavior in interactive vs autonomous modes.
- **Rationalization Prevention**: Core integrity rule — every resolved thread must cite a real file:line.
- **Structured Fix Records + Learning System**: Proper schema and flow for feeding `.sweep-lessons.json`.
- **Pattern Grouping**: First-class support for fixing root causes across entire PRs instead of isolated lines.
- **Autonomous Batch v2**: Worktree-based multi-PR execution that still enforces coverage, visual, rebase safety, and build verification gates.
- **Proven operational scripts**: All 11 battle-tested shell helpers from the original sweep are included and integrated.
- **High-quality examples**: Multiple realistic scenarios demonstrating stacked PRs, rebase impact, autonomous batch, and coverage decisions.
- **Progressive disclosure structure**: Follows strict create-skill format (lean SKILL.md + detailed cookbooks + references).

### Changed

- Commands now use the `/sweep-v2` prefix during the v2 transition period (see Migration guide).
- Build verification is now explicitly a mandatory final gate after the polish pass.
- Autonomous mode is deliberately more conservative on quality gates than the original sweep.

### Removed

- No major removals — all valuable capabilities from both predecessor skills have been preserved or improved.

## [Unreleased]

### Planned

- Dedicated `stats` command and cookbook for querying the learning system.
- Tighter proactive pattern application before reviewers comment.
- More framework-specific guidance and examples.
- Potential aliasing so `/sweep` can point to v2 for users who have fully migrated.
