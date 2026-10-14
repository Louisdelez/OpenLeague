"""Regression checks for inputs that must not silently pass repository policy."""
import json
import unittest
from unittest.mock import patch

import check_repo


class PolicyTests(unittest.TestCase):
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

    def test_corrupt_utf8_document_is_rejected(self):
        with patch.object(check_repo, "diff_paths", side_effect=[[], ["docs/workflow.md"]]), patch.object(check_repo, "git", return_value="Probl\ufffdme".encode()):
            self.assertIn("encoding", check_repo.file_errors(None, True)[0])


if __name__ == "__main__":
    unittest.main()
