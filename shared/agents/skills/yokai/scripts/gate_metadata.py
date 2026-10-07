#!/usr/bin/env python3
"""Print the shared gate_review value after human review and environment smoke.

This computes metadata only: it neither approves checks nor writes settings.
Merge its JSON result under gate_review in .koi/yokai.yml only after approved smoke checks (all passing, or failures explicitly reviewed).
"""
import argparse
import hashlib
import json
from pathlib import Path


def digest(text):
    return hashlib.sha256(text.encode("utf-8")).hexdigest()


def metadata(repo, working_folder, environment, backend="docker", image=""):
    run = repo / working_folder
    home = run.parent if run.name == "run" else run
    lines = (run / "CONTEXT.md").read_text().splitlines()
    start = next(i for i, line in enumerate(lines) if line.startswith("## Verification bar"))
    bar = [lines[start]]
    for line in lines[start + 1:]:
        if line.startswith("## "):
            break
        bar.append(line)
    bar = "\n".join(bar).rstrip()
    if bar.strip() == lines[start].strip():
        raise ValueError("verification bar is empty")
    scripts = {}
    for path in sorted((home / "sensors").glob("*.sh")):
        if path.name.startswith(".") or not path.is_file():
            continue
        scripts[path.name] = digest(path.read_bytes().decode("utf-8"))
    if not scripts:
        raise ValueError("no sensor scripts")
    parts = ["host"]
    if environment == "sandbox":
        if not image:
            raise ValueError("sandbox image is required")
        parts = [f"sandbox:{backend.capitalize()}:{image}"]
        for name in ["Dockerfile.sandbox", "sandbox-setup.sh"]:
            path = home / name
            value = digest(path.read_bytes().decode("utf-8")) if path.exists() else "missing"
            parts.append(f"{name}:{value}")
    return {"version": 2, "bar_sha256": digest(bar), "scripts": scripts,
            "environment_sha256": digest("\n".join(parts))}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--repo", type=Path, default=Path.cwd())
    parser.add_argument("--working-folder", type=Path, default=Path(".koi/run"))
    parser.add_argument("--environment", choices=["host", "sandbox"], required=True)
    parser.add_argument("--backend", choices=["docker", "apple"], default="docker")
    parser.add_argument("--image", default="")
    args = parser.parse_args()
    print(json.dumps(metadata(args.repo, args.working_folder, args.environment,
                              args.backend, args.image), indent=2))


if __name__ == "__main__":
    main()
