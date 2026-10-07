# Sensor policy

Translate the prepared verification bar into thin wrappers around real checks.
Do not turn every sentence in CONTEXT into an executable assertion.

## Establish coverage

Read the verification bar, repository instructions, CI workflows, package scripts,
tool configuration and existing tests/sensors. For each proposed sensor report:
its source file and command, the requirement it covers, working directory,
prerequisites, and why it is new, retained or changed. Reference real files;
do not claim a command exists without inspecting it. Include a source comment in
new scripts so provenance survives the proposal.

Separate product verification from setup, environment prerequisites, manual
acceptance and workflow policies. A commit convention is normally enforced by
commit review or an existing commit-range check; it is not permission to validate
all historical commits or fail an unborn repository. Human approval requirements
remain human gates. List such exclusions explicitly.

If a required check does not exist, report the coverage gap and propose the missing
check as separate work. Do not invent grep/regex checks, inline test programs,
always-pass scripts, or new acceptance criteria just to finish setup. Required
coverage gaps block saving a complete gate. Existing tests that fail are not gaps.

## Script contract

One concern per visible `.sh` file in `.koi/sensors/`, usually `NN-concern.sh`.
Yokai runs scripts with the repository root as their working directory. Rely on
that cwd; explicitly `cd path/to/subproject` only for a subproject. Never derive
the root from `$0`, `BASH_SOURCE` or the script directory: temporary smoke copies
live at a different depth from saved sensors. For example, wrap an established
`package.json` test command as:

```bash
#!/usr/bin/env bash
set -euo pipefail
# Source: package.json scripts.test; covers unit tests.
exec npm test
```

Use bash with
`set -euo pipefail`; preserve the underlying command's exit status. Prefer the
project's package-manager/CI command over rebuilding its logic in shell.

Use syntax supported by the selected execution environment. Host macOS may have
Bash 3.2: avoid `${value,,}`, associative arrays and `mapfile` unless a newer Bash
is an explicit verified prerequisite. `bash -n` alone cannot prove portability.
Use the configured sandbox's toolchain when enabled, not the host's tools.

Checks must not install dependencies, fetch advisory databases, run formatters in
write mode, update snapshots/lockfiles, change settings, commit or push. Keep setup
in environment preparation. Quote paths. Do not add a clean-tree sensor: temporary
onboarding files and implementation work legitimately make the tree dirty.

## Repair and review

Keep legitimate failing checks. A replacement/removal must identify a concrete
wrong scope, duplicate, obsolete requirement or script defect, with a reason.
Failure alone never justifies weakening a check. Omitted scripts are retained;
removals are explicit, separately visible and require human approval.

For existing scripts, the Sensors screen in `yokai` offers direct review without
an agent proposal. The human confirms command sources, coverage and prerequisites
from the displayed bar and scripts. Missing metadata alone is no reason to
regenerate sensors. The same command approval and smoke requirements apply.

Review exact proposed commands and removals before execution. Smoke-run temporary
copies of every proposed check in the selected environment before saving; report
results individually, even after a failure. Distinguish script defects (shell
errors, wrong cwd, unavailable commands) from a correctly executed check reporting
a product failure. Fix defects through a new reviewed proposal. Preserve product
failures and their output; the human may approve such a gate but readiness remains
red. No sensor or review metadata is saved when approval is declined.

## Shared approval with the wizard

After the human approves exact commands, smoke every temporary script in the selected environment.
Ask for **Approve and test**, explaining that this approves saving the complete reviewed gate only
if every smoke check passes. When all pass, save without another confirmation. If any fail, stop:
fix defects through renewed review, or obtain explicit approval to retain genuine product failures.
Save the whole sensor set and merge `gate_review` into `.koi/yokai.yml`,
preserving all unrelated settings. Use [the metadata helper](../scripts/gate_metadata.py) only to
compute this value; it does not approve checks or write files:

```bash
python3 <skill-directory>/scripts/gate_metadata.py --repo "$PWD" --environment host
# For a sandbox, use the effective backend and image from layered Yokai settings:
python3 <skill-directory>/scripts/gate_metadata.py --repo "$PWD" --environment sandbox --backend docker --image project-sandbox
```

The emitted object is the value of `gate_review`, not the whole settings file. Version 2 contains
`bar_sha256`, a `scripts` filename-to-SHA-256 mapping, and `environment_sha256`. If the script is
unavailable, compute SHA-256 of UTF-8 bytes using this exact contract: the verification section
starts at `## Verification bar`, stops before the next `## ` heading, joins lines with LF and trims
trailing whitespace; script hashes cover exact contents. Environment hashes cover `host`, or the
LF-joined strings `sandbox:Docker:<image>` (use `Apple` for Apple),
`Dockerfile.sandbox:<sha256-or-missing>`, and `sandbox-setup.sh:<sha256-or-missing>`.
Environment file hashes cover exact UTF-8 contents; there is no trailing LF in the joined identity.
Project home is the parent of a working folder named `run`, otherwise the working folder itself.

Compare the bar, scripts, settings and environment inputs again before saving; changed inputs need
fresh review. Changing host/sandbox, image selection, Dockerfile or setup hook requires fresh smoke
checks and approval of the new environment, using existing scripts without regeneration. Before rebuilding an image
under the same tag, remove only `gate_review.environment_sha256` so interrupted rebuilds cannot
retain an obsolete smoke approval. Never refresh hashes simply to silence a review message.
Unchanged skill-approved version-2 metadata is accepted by the wizard and headless driver.
