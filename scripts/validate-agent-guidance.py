#!/usr/bin/env python3
"""Validate local guidance structure; no network, Terraform, or tenant operations."""

import hashlib
import json
from pathlib import Path
import re
import sys

import yaml

ROOT = Path(__file__).resolve().parents[1]
SKILLS = ROOT / ".github/skills"
BACKUP = ROOT / "docs/skill-backups/2026-09-21"


def main():
    errors = []
    active = list(SKILLS.glob("*/SKILL.md"))
    for path in active:
        text = path.read_text()
        match = re.match(r"\A---\n(.*?)\n---(?:\n|$)", text, re.S)
        if not match:
            errors.append(f"Missing frontmatter: {path.relative_to(ROOT)}")
            continue
        try:
            data = yaml.safe_load(match[1])
        except yaml.YAMLError as exc:
            errors.append(f"Invalid YAML: {path}: {exc}")
            continue
        if not isinstance(data, dict):
            errors.append(f"Frontmatter is not a mapping: {path}")
            continue
        name = data.get("name", "")
        if name != path.parent.name or not re.fullmatch(r"[a-z0-9]+(?:-[a-z0-9]+)*", name) or len(name) > 64:
            errors.append(f"Invalid name: {path}")
        description = data.get("description", "")
        if not isinstance(description, str) or not 1 <= len(description.strip()) <= 1024:
            errors.append(f"Invalid description: {path}")
        compatibility = data.get("compatibility")
        if compatibility is not None and (not isinstance(compatibility, str) or not 1 <= len(compatibility) <= 500):
            errors.append(f"Invalid compatibility: {path}")

    expected = {"entra-terraform", "entra-conditional-access", "entra-security-audit"}
    if {p.parent.name for p in active if p.parent.name.startswith("entra-")} != expected:
        errors.append("Expected three active Entra skills")
    if list(SKILLS.glob("terraform-*/SKILL.md")) or list(BACKUP.rglob("SKILL.md")):
        errors.append("Historical skills remain discoverable")

    discovery = ROOT / ".agents/skills"
    if not discovery.is_symlink() or discovery.resolve() != SKILLS.resolve():
        errors.append("Codex discovery link does not resolve to canonical skills")

    documents = [ROOT / "AGENTS.md", ROOT / "README.md", ROOT / "CONTRIBUTING.md", ROOT / ".github/copilot-instructions.md", BACKUP / "README.md"]
    documents += list((BACKUP / "corrected").rglob("*.md"))
    documents += list(SKILLS.rglob("*.md")) + list((ROOT / "docs/agent-guidance").glob("*.md"))
    documents += list((ROOT / "terraform").glob("*.md"))
    for path in documents:
        for target in re.findall(r"\]\(([^)]+)\)", path.read_text()):
            if "://" in target or target.startswith(("#", "mailto:")):
                continue
            target_path = target.split("#", 1)[0]
            if target_path and not (path.parent / target_path).exists():
                errors.append(f"Broken link: {path.relative_to(ROOT)} -> {target}")

    manifest = json.loads((BACKUP / "original-sha256.json").read_text())
    original = BACKUP / "original"
    actual = {str(p.relative_to(original)) for p in original.rglob("*") if p.is_file()}
    if actual != set(manifest):
        errors.append("Original archive file list differs from manifest")
    for name, digest in manifest.items():
        path = original / name
        if not path.is_file() or hashlib.sha256(path.read_bytes()).hexdigest() != digest:
            errors.append(f"Original archive changed: {name}")

    if errors:
        print("\n".join(errors))
        return 1
    print(f"Passed: {len(active)} active skills, local links, archive isolation and hashes, and discovery link.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
