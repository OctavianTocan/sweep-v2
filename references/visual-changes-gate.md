# Visual Changes Gate (Hard Rule)

## Definition

A change is a **visual/styling change** if it would modify any of:

- CSS classes, Tailwind utilities, or inline styles
- Theme tokens, CSS custom properties, or color values
- Shadow, border, opacity, blur, or backdrop values
- Focus indicators, hover states, or animation properties
- Adding or removing CSS class names that affect appearance (e.g. `dark`, `popover-styled`)
- Any CSS rule definition (adding, removing, or modifying selectors/properties)

## Why This Gate Exists

Bot reviewers (and sometimes even human reviewers) lack full design context. Suggested "fixes" for visual issues have repeatedly broken intentional design systems in production.

**Example from history:** Multiple cases where removing a `dark` class, changing focus styles, or deleting CSS rules destroyed carefully crafted UI that matched a specific design spec.

## Enforcement

### Single / Interactive Mode

Present the proposed change and ask explicitly:

```
Visual change requested by @reviewer on file.tsx:45:
  "Remove the `dark` class — it forces dark mode variables in light mode"

This would change the visual appearance. Apply this change? (yes / no)
```

Only proceed if the user says yes.

### Batch / Autonomous Mode

- **Skip** the visual change automatically.
- Flag it in the report as `VISUAL_CHANGE_SKIPPED`.
- Include the original reviewer comment text so the human can decide later.

## Scope

This gate applies **regardless of reviewer severity**, even if the comment is marked `[blocking]`.

It is one of the few places where automation must be deliberately conservative.
