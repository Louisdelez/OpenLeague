"""Read-only repository and PR checks. Requires Python 3.11+ and Git."""
from __future__ import annotations

import argparse
import json
from pathlib import Path, PurePosixPath
import re
import subprocess
import sys
import tomllib

ROOT = Path(__file__).resolve().parents[2]
COMMIT = re.compile(r"^(feat|fix|docs|test|build|ci|chore|refactor|perf|revert)(\([a-z0-9][a-z0-9._/-]*\))?!?: \S.*$")
PRERELEASE = r"(?:0|[1-9]\d*|[0-9]*[A-Za-z-][0-9A-Za-z-]*)"
SEMVER = re.compile(r"^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)"
                    + rf"(?:-{PRERELEASE}(?:\.{PRERELEASE})*)?(?:\+[0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*)?$")
SECTIONS = ("Problème et résultat", "Périmètre et références", "Vérifications", "Limites")
MAX_FILE_BYTES = 5 * 1024 * 1024


def git(*args: str) -> bytes:
    return subprocess.run(["git", "-C", str(ROOT), *args], check=True, capture_output=True).stdout


def message_errors(message: str) -> list[str]:
    lines = message.splitlines()
    header = lines[0] if lines else ""
    if not COMMIT.fullmatch(header):
        return ["Use Conventional Commits, e.g. fix(map): correct relic animation"]
    return []


def pr_errors(event: dict) -> list[str]:
    pr = event.get("pull_request")
    if not pr:
        return []
    errors = message_errors(pr.get("title") or "")
    body = pr.get("body") or ""
    # Remove template hints so leaving the template unchanged cannot pass.
    body = re.sub(r"<!--.*?-->", "", body, flags=re.S)
    for section in SECTIONS:
        match = re.search(r"^## " + re.escape(section) + r"\s*\n(.*?)(?=^## |\Z)", body, re.M | re.S)
        if not match or not match.group(1).strip():
            errors.append(f"Fill PR section: {section}")
    return errors


def metadata_errors(staged: bool = False) -> list[str]:
    def read(name: str) -> str:
        return git("show", ":" + name).decode("utf-8") if staged else (ROOT / name).read_text(encoding="utf-8")

    workspace = tomllib.loads(read("Cargo.toml"))
    launcher = tomllib.loads(read("launcher/src-tauri/Cargo.toml"))
    tauri = json.loads(read("launcher/src-tauri/tauri.conf.json"))
    versions = [workspace["workspace"]["package"]["version"], launcher["package"]["version"], tauri["version"]]
    errors = []
    if len(set(versions)) != 1 or not all(SEMVER.fullmatch(v) for v in versions):
        errors.append(f"Align valid SemVer in workspace, launcher and Tauri: {versions}")
    for name in ("Cargo.lock", "launcher/src-tauri/Cargo.lock"):
        try:
            read(name)
        except (OSError, subprocess.CalledProcessError):
            errors.append(f"Missing application lockfile: {name}")
    manifest = json.loads(read("assets-manifest.json"))
    packs = manifest.get("packs", [])
    if not packs:
        errors.append("Asset manifest must contain packs")
    for pack in packs:
        if not re.fullmatch(r"[0-9a-f]{64}", pack.get("sha256", "")):
            errors.append(f"Invalid asset SHA-256: {pack.get('name')}")
        if not isinstance(pack.get("bytes"), int) or pack["bytes"] <= 0:
            errors.append(f"Invalid asset size: {pack.get('name')}")
        if not pack.get("url", "").startswith("https://github.com/Louisdelez/OpenLeague/releases/download/"):
            errors.append(f"Asset pack must reference an OpenLeague release: {pack.get('name')}")
    return errors


def forbidden_path(name: str) -> bool:
    path = PurePosixPath(name)
    parts = path.parts
    if any(p in {"target", "node_modules", "__pycache__", ".venv"} for p in parts):
        return True
    if parts and parts[0] in {"logs", "runtime", "backups", ".asset-cache", "artwork"}:
        return True
    if name.startswith("assets/") and not name.startswith("assets/shaders/"):
        return True
    if name.startswith("launcher/web/assets/"):
        return True
    return (path.name == ".env" or (path.name.startswith(".env.") and path.name != ".env.example")
            or path.suffix.lower() in {".key", ".pem", ".pdb", ".pyc", ".pyo", ".log"})


def diff_paths(base: str | None, staged: bool, added_only: bool = False) -> list[str]:
    command = ["diff", "--name-only", "-z", "--diff-filter=A" if added_only else "--diff-filter=ACMR"]
    if staged:
        command.append("--cached")
    elif base:
        # Resolve the object first; do not interpret a supplied ref as a Git option.
        sha = git("rev-parse", "--verify", "--end-of-options", base + "^{commit}").decode().strip()
        command.extend([sha, "HEAD"])
    else:
        return []
    command.append("--")
    return [p.decode("utf-8", errors="surrogateescape") for p in git(*command).split(b"\0") if p]


def file_errors(base: str | None, staged: bool) -> list[str]:
    errors = []
    for name in diff_paths(base, staged, added_only=True):
        if forbidden_path(name):
            errors.append(f"Do not add runtime files, private keys or asset-pack content: {name}")
    for name in diff_paths(base, staged):
        data = git("show", ":" + name) if staged else git("show", "HEAD:" + name)
        if len(data) > MAX_FILE_BYTES:
            errors.append(f"Changed file exceeds 5 MiB; use a release pack or reviewed exception: {name}")
        if PurePosixPath(name).suffix in {".md", ".py", ".json", ".toml", ".yaml", ".yml", ".js", ".wgsl"}:
            try:
                if "\ufffd" in data.decode("utf-8"):
                    errors.append(f"Replacement character indicates damaged text encoding: {name}")
            except UnicodeError:
                errors.append(f"Changed text file must be valid UTF-8: {name}")
        if name.endswith(".json"):
            try:
                json.loads(data)
            except (ValueError, UnicodeError) as exc:
                errors.append(f"Invalid JSON in {name}: {exc}")
    return errors


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    choice = parser.add_mutually_exclusive_group()
    choice.add_argument("--staged", action="store_true")
    choice.add_argument("--base", help="Compare a known commit/ref to HEAD")
    parser.add_argument("--commit-message", type=Path)
    parser.add_argument("--event", type=Path, help="Validate PR title/body from a GitHub event JSON")
    args = parser.parse_args()
    try:
        if args.commit_message:
            errors = message_errors(args.commit_message.read_text(encoding="utf-8-sig"))
        elif args.event:
            errors = pr_errors(json.loads(args.event.read_text(encoding="utf-8")))
        else:
            errors = metadata_errors(args.staged) + file_errors(args.base, args.staged)
    except (OSError, ValueError, KeyError, TypeError, subprocess.CalledProcessError) as exc:
        print(f"Repository checks unavailable: {exc}", file=sys.stderr)
        return 1
    for error in errors:
        print(error, file=sys.stderr)
    if not errors:
        print("Repository policy checks passed (not game acceptance).")
    return bool(errors)


if __name__ == "__main__":
    sys.exit(main())
