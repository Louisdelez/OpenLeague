"""Regression checks for inputs that must not silently pass repository policy."""
import json
import hashlib
import unittest
from unittest.mock import patch

import check_repo


class PolicyTests(unittest.TestCase):
    def pack_manifest(self, **changes):
        pack = {"name": "local.zip", "bytes": 1, "sha256": "a" * 64,
                "url": "https://github.com/Louisdelez/OpenLeague/releases/download/assets/local.zip"}
        pack.update(changes)
        return {"packs": [pack]}

    def test_explicit_documented_local_pack_is_not_a_remote_release(self):
        manifest = self.pack_manifest(local_only=True, url=None)
        manifest["local_derivation"] = {"base_release": "assets-original", "scope": "Local corrected image; not uploaded"}
        self.assertEqual(check_repo.asset_pack_errors(manifest), [])
        manifest["packs"][0]["url"] = "https://github.com/Louisdelez/OpenLeague/releases/download/assets/local.zip"
        self.assertTrue(check_repo.asset_pack_errors(manifest))

    def test_local_pack_without_provenance_is_rejected(self):
        self.assertTrue(check_repo.asset_pack_errors(self.pack_manifest(local_only=True, url=None)))

    def test_null_remote_url_and_non_boolean_local_flag_are_rejected(self):
        self.assertTrue(check_repo.asset_pack_errors(self.pack_manifest(url=None)))
        self.assertTrue(check_repo.asset_pack_errors(self.pack_manifest(local_only="true", url=None)))

    def test_private_agent_state_is_not_publishable(self):
        self.assertTrue(check_repo.forbidden_path(".ai-tools/state/handoffs/private.json"))
        self.assertFalse(check_repo.forbidden_path(".ai-tools/project.mjs"))

    def test_boolean_asset_size_is_rejected(self):
        self.assertTrue(check_repo.asset_pack_errors(self.pack_manifest(bytes=True)))

    def test_breaking_commit_with_multiline_body(self):
        self.assertEqual(check_repo.message_errors("feat(network)!: change packet format\n\nRequires matching clients."), [])

    def test_unspecific_commit_is_rejected(self):
        self.assertTrue(check_repo.message_errors("update everything"))

    def test_empty_pr_template_does_not_count_as_evidence(self):
        body = "\n".join(f"## {s}\n<!-- fill this -->\n" for s in check_repo.SECTIONS)
        self.assertEqual(len(check_repo.pr_errors({"pull_request": {"title": "docs: clarify workflow", "body": body}})), 4)

    def test_documented_limits_can_pass_without_false_game_claim(self):
        body = "## Problème et résultat\nAlign versions.\n## Périmètre et références\nManifests only.\n## Vérifications\nRepository checks passed.\n## Limites\nNo game or GPU test run.\n"
        self.assertEqual(check_repo.pr_errors({"pull_request": {"title": "chore: align versions", "body": body}}), [])

    def test_asset_pack_and_private_runtime_paths_rejected(self):
        for name in ("runtime/session.json", "assets/champions/a.glb", "launcher/web/assets/logo.dds", ".env.local", "tools/__pycache__/a.pyc"):
            with self.subTest(name=name):
                self.assertTrue(check_repo.forbidden_path(name))
        for name in ("assets/shaders/map.wgsl", ".env.example", "docs/runtime-notes.md"):
            with self.subTest(name=name):
                self.assertFalse(check_repo.forbidden_path(name))

    def test_invalid_prerelease_versions_are_rejected(self):
        for version in ("0.1.0-alpha..1", "0.1.0-01", "01.0.0"):
            with self.subTest(version=version):
                self.assertIsNone(check_repo.SEMVER.fullmatch(version))
        self.assertIsNotNone(check_repo.SEMVER.fullmatch("0.1.0-alpha.1"))

    def test_unstaged_manifest_cannot_hide_staged_version_mismatch(self):
        files = {
            "Cargo.toml": '[workspace.package]\nversion="0.1.0"\n',
            "launcher/src-tauri/Cargo.toml": '[package]\nversion="0.2.0"\n',
            "launcher/src-tauri/tauri.conf.json": '{"version":"0.1.0"}',
            "Cargo.lock": "", "launcher/src-tauri/Cargo.lock": "",
            "assets-manifest.json": json.dumps({"packs": [{"name": "a.zip", "bytes": 1, "sha256": "a" * 64,
                "url": "https://github.com/Louisdelez/OpenLeague/releases/download/assets/a.zip"}]}),
        }
        def index_read(*args):
            return files[args[1][1:]].encode()
        with patch.object(check_repo, "git", side_effect=index_read):
            errors = check_repo.metadata_errors(staged=True)
        self.assertEqual(len(errors), 1)
        self.assertIn("Align valid SemVer", errors[0])

    def test_malformed_json_is_checked_from_index(self):
        with patch.object(check_repo, "diff_paths", side_effect=[[], ["docs/evidence.json"]]), patch.object(check_repo, "git", return_value=b'{"passed":'):
            self.assertTrue(check_repo.file_errors(None, True))

    def test_modified_large_file_is_rejected(self):
        with patch.object(check_repo, "diff_paths", side_effect=[[], ["docs/capture.png"]]), patch.object(check_repo, "git", return_value=b"x" * (check_repo.MAX_FILE_BYTES + 1)):
            self.assertIn("5 MiB", check_repo.file_errors(None, True)[0])

    def test_reviewed_dataset_requires_exact_identity(self):
        data = b"native archived cases"
        entry = {"bytes": len(data), "sha256": hashlib.sha256(data).hexdigest(), "reason": "Fixed native comparison archive"}
        with patch.object(check_repo, "git", return_value=json.dumps({"data/cases.json": entry}).encode()):
            self.assertTrue(check_repo.reviewed_large_file("data/cases.json", data, True))
            self.assertFalse(check_repo.reviewed_large_file("data/cases.json", data + b"changed", True))
            self.assertFalse(check_repo.reviewed_large_file("data/unlisted.json", data, True))

    def test_reviewed_dataset_cannot_allow_private_paths(self):
        data = b"private"
        entry = {"bytes": len(data), "sha256": hashlib.sha256(data).hexdigest(), "reason": "Not sufficient"}
        with patch.object(check_repo, "git", return_value=json.dumps({"runtime/private.json": entry}).encode()):
            self.assertFalse(check_repo.reviewed_large_file("runtime/private.json", data, True))

    def test_invalid_exception_manifest_is_rejected(self):
        with patch.object(check_repo, "git", return_value=b"not json"):
            self.assertFalse(check_repo.reviewed_large_file("data/cases.json", b"cases", True))

    def test_corrupt_utf8_document_is_rejected(self):
        with patch.object(check_repo, "diff_paths", side_effect=[[], ["docs/workflow.md"]]), patch.object(check_repo, "git", return_value="Probl\ufffdme".encode()):
            self.assertIn("encoding", check_repo.file_errors(None, True)[0])


if __name__ == "__main__":
    unittest.main()
