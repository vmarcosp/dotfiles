---
name: remote-dev
description: >-
  Configures dev servers, web apps, and ports to bind to 0.0.0.0 (or Tailscale IP)
  so the user can access them from another device (iPhone, iPad, laptop) via Tailscale / MagicDNS.
  Activates when the user mentions working remotely, SSH session, iPhone, phone, Tailscale, or remote access.
user-invocable: true
---

# Remote Dev (Tailscale & SSH)

When the user works remotely (via SSH, from an iPhone/iPad, or another device over Tailscale):

## Core Rule
All dev servers, previews, and HTTP services must bind to `0.0.0.0` (all interfaces) rather than defaulting strictly to `127.0.0.1` / `localhost`. This allows access across the Tailscale mesh network.

## Common Framework Flags
- **Vite**: `vite --host 0.0.0.0` or set `server: { host: '0.0.0.0' }` in `vite.config.*`
- **Next.js**: `next dev -H 0.0.0.0`
- **Astro**: `astro dev --host 0.0.0.0`
- **Nuxt**: `npx nuxi dev --host 0.0.0.0`
- **Python http.server**: `python3 -m http.server <port> --bind 0.0.0.0`
- **FastAPI / Uvicorn**: `uvicorn <module>:<app> --host 0.0.0.0 --port <port>`
- **Flask**: `app.run(host='0.0.0.0', port=<port>)`
- **Express / Node**: `app.listen(<port>, '0.0.0.0')`
- **Go / Rust / others**: Bind listen address to `0.0.0.0:<port>` or `:<port>`

## Device Access URLs
When starting a service, always provide the MagicDNS and Tailscale IP URLs to the user:
- Hostname (MagicDNS): `http://pc:<port>` (or Mac hostname on macOS)
- Tailscale IP: `http://<tailscale-ip>:<port>` (e.g. check with `tailscale ip -4`)
