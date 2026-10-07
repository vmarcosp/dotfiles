# Sandbox Dockerfile (`.koi/Dockerfile.sandbox`)

Language- and framework-agnostic. The repo owns the OCI image (ADR-0027/0028): bake the
**coding agent CLI** and whatever tools the gate needs into the image. Optional
`.koi/sandbox-setup.sh` is a once-per-sandbox escape hatch only: not the primary
install path.

### Match the launcher, not the base-image habit

Yokai copies Linux `yokai` into a fixed in-VM directory, then `chmod +x` via
`exec` as the image’s **default USER**. That user must be allowed to write that directory.

| Backend | Install dir for harness ELFs | Default USER the recipe should leave |
|---------|------------------------------|--------------------------------------|
| `apple` | `/usr/local/bin` | **root** (scaffold has no final `USER`) |
| `docker` | `/home/agent/.local/bin` | template **`agent`** (writable home) |

Rules:

- **Final USER must own (or can write) the harness install dir.** Switching to a
  non-root runtime user is fine for Docker’s `agent` layout; it breaks Apple when
  `/usr/local/bin` stays root-owned (`chmod: … Operation not permitted`).
- **`USER root` during `RUN` is fine** on either backend. The constraint is the
  **last** `USER` (the default for `container exec` / `sbx exec`).
- **Do not assume a framework base image’s default user is safe.** Dev images often
  drop privileges for interactive work; that conflicts with Apple’s `/usr/local/bin`
  install. Prefer leaving Apple images as root, or only switch user if you also make
  the harness install dir writable by that user (and keep `yokai` on PATH).
- **Bake the toolchain the sensors need** (compiler, runtime, package manager, linters)
  the same way you bake the agent: stack-specific `RUN` lines; the USER/install-dir
  rules above stay the same for Rust, Node, Go, Python, etc.
- **After rebuilding or changing the image tag**, recreate the named sandbox
  (`container rm` / `sbx rm`, then re-run `yokai`). An existing VM keeps the old
  filesystem and USER.

### Symptom → fix

| Symptom | Likely cause |
|---------|----------------|
| `chmod … Operation not permitted` on harness path | default USER cannot write the backend’s install dir (common on Apple + non-root final USER) |
| agent CLI not found in-VM | agent not baked into the image (or wrong `image:` tag) |
| sensors fail for missing toolchain | gate tools not in the image |
| stale agent / tools after rebuild | named sandbox not recreated |

Site walkthroughs: Apple sandbox / Docker sbx / USAGE → Sandboxes.


Bare `yokai` inspects the environment automatically and proposes needed Dockerfile changes.
Review the proposal, then choose Approve and build. Details offers editing; jobs show live logs and Cancel. Rebuild replaces the named sandbox after confirmation. Clear environment smoke
approval before rebuilding a mutable image tag. After environment changes, re-smoke the existing
gate and approve the new environment; do not regenerate sensors just because metadata is stale.
