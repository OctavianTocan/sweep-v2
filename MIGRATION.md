# Migration Guide — From old `sweep` and `loop-review` to `sweep-v2`

## Why v2 Exists

`sweep-v2` is the official unified successor that combines:
- The powerful operational engine from the original `sweep` (thread resolution, rebase analysis, autonomous batch, scripts, learning system)
- The hard quality discipline from `loop-review` (mandatory coverage preflight, elevated polish pass, "coverage over scores" philosophy)

The goal is to give you the best of both without the fragmentation.

## Current Command Surface (During Transition)

During the v2 rollout, the recommended way to use the new skill is:

```bash
npx skills add OctavianTocan/sweep-v2
```

Then use:

- `/sweep-v2`
- `/sweep-v2 ls`
- `/sweep-v2 123`
- `/sweep-v2 polish`
- `/sweep-v2 changes requested`
- etc.

The old local `sweep` and `loop-review` skills can continue to coexist while you evaluate v2.

## Migration Recommendations

### If you were primarily a `loop-review` user

You will feel very at home. The coverage gate and polish pass are now even more central.

Recommended first commands:
1. `/sweep-v2 polish` on your current PR (you already know and love this step).
2. `/sweep-v2` for the full guided flow (now includes the powerful engine capabilities you didn't have before).

### If you were primarily an original `sweep` user

You get all your favorite power tools (scripts, autonomous batch, rebase analysis, learning system) plus much stronger guardrails.

Key mindset shifts:
- Coverage preflight will stop you by default on weak-test PRs. This is intentional and is the biggest philosophical upgrade.
- You will be asked (or have to explicitly pre-approve) before visual changes or risky rebase fixes.
- The polish pass is now a standard part of the workflow, not an optional extra.

### Running Both During Transition

You can safely have all three installed:
- Old local `sweep`
- Old local `loop-review`
- New `sweep-v2` (via npx skills add)

Use `sweep-v2` for new work. Fall back to the old ones only if you hit a genuine gap (and please report it so we can close it).

## What Changed in Behavior

| Area                        | Old sweep behavior                  | sweep-v2 behavior                                      |
|----------------------------|-------------------------------------|--------------------------------------------------------|
| Coverage                    | Not a hard gate                     | Mandatory preflight with explicit risk acceptance      |
| Polish Pass                 | Optional / afterthought             | First-class, high-leverage step (strongly recommended) |
| Visual changes              | Could be auto-fixed in some modes   | Hard gate — always requires human approval or skip     |
| Rebase impact               | Powerful but could auto-fix risky things | Same power + strict "never auto-fix stale/conflict"   |
| Autonomous batch            | Very aggressive                     | Same power + quality gates enforced                    |
| Rationalization             | Possible                            | Strongly prevented via citation requirement            |
| Learning system             | Present                             | Same + better integrated with quality gates            |

## Updating Your Workflows

Most people will simply replace their old `/sweep` or `/loop-review` muscle memory with `/sweep-v2`.

If you have custom scripts or aliases that call the old skills, update them to point at `sweep-v2` when you are ready.

## Feedback & Rollback

If something important from the old skills is missing or broken in v2, please report it. The intent is that v2 is strictly better for almost everyone.

You can always fall back to the old local skills while issues are resolved.

## Future

Once v2 is proven stable and widely adopted, we may:
- Make `/sweep` an alias that points to the v2 implementation
- Deprecate the separate `loop-review` skill
- Publish a clean `sweep` release under the original name

For now, `sweep-v2` is the canonical home of the unified skill.

Welcome to the new standard.
