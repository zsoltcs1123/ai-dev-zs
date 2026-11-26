#!/usr/bin/env python3
"""Bundle helpers for skills/install.sh (stdlib only)."""

from __future__ import annotations

import sys
from pathlib import Path


def parse_bundle_yaml(path: Path) -> dict:
    cfg = {
        "id": None,
        "description": "",
        "allow_global": True,
        "patch_disable_model_invocation": True,
        "include": [],
    }
    if not path.is_file():
        return cfg

    in_include = False
    for raw in path.read_text(encoding="utf-8").splitlines():
        line = raw.strip()
        if not line or line.startswith("#"):
            continue
        if line == "include:":
            in_include = True
            continue
        if in_include:
            if line.startswith("- "):
                item = line[2:].strip()
                if item.startswith("ref:"):
                    item = item[4:].strip()
                cfg["include"].append(item)
                continue
            in_include = False
        if ":" not in line:
            continue
        key, val = line.split(":", 1)
        key, val = key.strip(), val.strip()
        if key == "id":
            cfg["id"] = val
        elif key == "description":
            cfg["description"] = val
        elif key == "allow_global":
            cfg["allow_global"] = val.lower() == "true"
        elif key == "patch_disable_model_invocation":
            cfg["patch_disable_model_invocation"] = val.lower() == "true"
    return cfg


def bundle_skill_dirs(bundle_dir: Path) -> list[Path]:
    out: list[Path] = []
    for child in sorted(bundle_dir.iterdir()):
        if not child.is_dir():
            continue
        if (child / "SKILL.md").is_file():
            out.append(child)
    return out


def exclusive_names(bundles_root: Path) -> list[str]:
    names: list[str] = []
    if not bundles_root.is_dir():
        return names
    for bundle_dir in sorted(bundles_root.iterdir()):
        if not bundle_dir.is_dir() or not (bundle_dir / "bundle.yaml").is_file():
            continue
        for skill_dir in bundle_skill_dirs(bundle_dir):
            names.append(skill_dir.name)
    return names


def cmd_exclusive(bundles_root: Path) -> None:
    for name in exclusive_names(bundles_root):
        print(name)


def cmd_config(bundle_dir: Path) -> None:
    cfg = parse_bundle_yaml(bundle_dir / "bundle.yaml")
    allow = "true" if cfg["allow_global"] else "false"
    patch = "true" if cfg["patch_disable_model_invocation"] else "false"
    print(f"{allow}\t{patch}")


def cmd_members(bundle_dir: Path, skills_dir: Path) -> None:
    cfg = parse_bundle_yaml(bundle_dir / "bundle.yaml")
    bundle_id = cfg["id"] or bundle_dir.name

    for skill_dir in bundle_skill_dirs(bundle_dir):
        name = skill_dir.name
        print(f"{name}\t{skill_dir.as_posix()}\tbundle")

    for ref_name in cfg["include"]:
        src = skills_dir / ref_name
        if not (src / "SKILL.md").is_file():
            print(f"Bundle {bundle_id}: missing shared skill skills/{ref_name}", file=sys.stderr)
            sys.exit(1)
        print(f"{ref_name}\t{src.as_posix()}\tshared")


def cmd_list(bundles_root: Path) -> None:
    if not bundles_root.is_dir():
        return
    print("Bundles:")
    for bundle_dir in sorted(bundles_root.iterdir()):
        if not bundle_dir.is_dir() or not (bundle_dir / "bundle.yaml").is_file():
            continue
        cfg = parse_bundle_yaml(bundle_dir / "bundle.yaml")
        bundle_id = cfg["id"] or bundle_dir.name
        members: list[str] = []
        for skill_dir in bundle_skill_dirs(bundle_dir):
            members.append(skill_dir.name)
        for ref_name in cfg["include"]:
            members.append(f"{ref_name} (shared)")
        desc = cfg.get("description") or ""
        print(f"  - {bundle_id}: {', '.join(members) or '(no skills yet)'}")
        if desc:
            print(f"      {desc}")


def main() -> None:
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(newline="\n")
    if hasattr(sys.stderr, "reconfigure"):
        sys.stderr.reconfigure(newline="\n")

    if len(sys.argv) < 3:
        print("usage: install-bundle.py <command> <path> [skills_dir]", file=sys.stderr)
        sys.exit(2)

    command = sys.argv[1]
    path = Path(sys.argv[2])

    if command == "exclusive":
        cmd_exclusive(path)
    elif command == "config":
        cmd_config(path)
    elif command == "members":
        if len(sys.argv) < 4:
            print("members requires skills_dir", file=sys.stderr)
            sys.exit(2)
        cmd_members(path, Path(sys.argv[3]))
    elif command == "list":
        cmd_list(path)
    else:
        print(f"unknown command: {command}", file=sys.stderr)
        sys.exit(2)


if __name__ == "__main__":
    main()