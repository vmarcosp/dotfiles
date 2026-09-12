---
alwaysApply: true
---

## Remote Dev / SSH Mode

When the user mentions they are connected via SSH, working remotely, accessing from their iPhone/iPad/another device, or when the environment variable `SSH_CONNECTION` or `SSH_CLIENT` is present:

- Bind all local web servers, preview ports, and APIs to `0.0.0.0` (or the host's Tailscale IP) instead of `127.0.0.1`.
- When providing access links, provide the Tailscale MagicDNS and IP URL (e.g. `http://pc:<port>` or `http://<tailscale-ip>:<port>`) in addition to localhost.
