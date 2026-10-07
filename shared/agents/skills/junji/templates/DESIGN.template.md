# Design — <project or run title>

**Reference: binding visual / experiential contract** for this run's human-facing surfaces. Tokens
and checkable rules, not an essay. `CONTEXT.md › Design contract` points here. A fresh window that
ships UI must obey this file. If a project/root design doc exists, this file **inherits** it and
records only this-run deltas: never a silent fork.

**Aesthetic direction:** <one named direction — e.g. "hand-crafted pixel dusk", "clinical density",
"quiet editorial">

## Atmosphere

<Evocative but concrete: light, material, mood, density. What the surface should *feel* like.>

## Color

| Role | Hex | Notes |
|------|-----|-------|
| Background | `#______` | |
| Surface | `#______` | |
| Text | `#______` | |
| Muted text | `#______` | |
| Accent | `#______` | |
| Border / rule | `#______` | |
| Danger / warn | `#______` | optional |

<Add rows as needed. Prefer named roles over anonymous swatches.>

## Typography

- **Display:** <family, weight, optical size / tracking if load-bearing>
- **Body:** <family, size scale, line length stance>
- **Mono / code:** <family if relevant>
- **Scale notes:** <what must stay tight vs airy; what never uses the display face>

## Layout principles

<Composition rules: hierarchy, margins, grid or anti-grid, density, what belongs in the first viewport,
how sections stack. Universal: not framework-specific utility classes.>

## Component feel

<How interactive pieces should read: borders, radius (or none), elevation/atmosphere vs flat, focus,
density of chrome. Describe *feel*, not component library APIs.>

## Motion stance

<What moves, what stays still, reduced-motion fallback. Prefer one orchestrated idea over scattered
effects: or explicitly none.>

## Do / Don't

**Do:**

- <concrete, checkable guidance>

**Don't:**

- <anti-patterns — especially generic AI-template looks, clichéd palettes, decorative chrome that
  doesn't serve the subject>

## Sources

- **Project design (parent):** `<path or "none">` — <what this run inherits>
- **References:**
  - `<URL or path>` — see `.koi/run/designs/NN-<slug>.md`
  - …
