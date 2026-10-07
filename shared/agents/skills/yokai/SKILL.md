---
name: yokai
description: >-
  Prepare Yokai execution: create or repair repository-backed sensor checks, assess
  phase weight and execution mode in YAML, or prepare sandbox images. Use for
  /yokai sensors, /yokai assess, /yokai sandbox, or requests to improve checks or
  assign model tiers and plain/swarm strategy. Does not plan or execute Junji phases.
license: MIT
metadata:
  author: matheusps
  version: "0.6.0"
---

# Yokai — execution preparation

Junji owns the method and Markdown scope. Yokai owns executable checks and runtime
choices. Read only the reference for the requested operation:

- **sensors**: [Sensor policy](references/sensors.md). Inspect real project checks,
  propose coverage and any justified removals, obtain permission to smoke-run
  temporary scripts, then review the results before saving. Keep failed product
  checks intact. Report missing coverage instead of inventing assertions.
- **assess**: [Phase assessment](references/assessment.md). Assess each unfinished
  BACKLOG phase; propose tier, strategy and reason under `phases` in
  `.koi/run/yokai.yml`. Preserve other settings and reviewed choices. Never write
  these choices into PLAN, phase-plan Markdown or backlog headings.
- **sandbox**: [Sandbox recipes](references/sandbox.md). Match the execution
  environment to the selected backend and the actual sensor prerequisites.

These policy references are also bundled into the executable. `yokai setup` opens
the shared preparation wizard without an installed skill, as does the cockpit's Setup control.
It can save runtime preferences before a Junji plan exists. Bare `yokai` prepares missing inputs
and starts when ready; explicit setup waits for Start run or Save and exit.
`yokai guidance sensors|assess|sandbox` prints the corresponding policy without setup.

Show proposed changes before saving. A human-approved assessment saves `tier`,
`strategy` and `reason` directly; Yokai accepts that mapping without another approval
or fingerprints. Do not create `reviewed_sha256` fields. After command review and selected-environment smoke checks, save the complete
gate and shared version-2 `gate_review` metadata in `.koi/yokai.yml`, following the sensor
reference. Ask for Approve and test: approval to save is conditional on every check passing; any
failure needs explicit review. The wizard accepts unchanged skill-approved gates. Never fabricate approval or
create gate-review.yml. Setup never authorizes gated phases or overrides standing directives.
