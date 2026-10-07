#!/usr/bin/env bash
# .koi/sensors/<name>.sh — one atomic check (exit 0 ⇒ pass).
# The gate is the aggregate of every *.sh in this folder (sorted by filename, fail-fast).
# Keep in lockstep with .koi/run/CONTEXT.md › Verification bar. Never weaken to pass.
set -euo pipefail

# Replace with a single concern, e.g.:
# cargo test
# npm run lint
# npx vitest run --coverage
<one command or short pipeline>
