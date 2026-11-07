import copy
import json
import pathlib
import tempfile
import unittest

from source_versions import (SourceVersionError, historical_record, identity,
                             prepare_version, validate_history)


class SourceVersionsTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = pathlib.Path(self.temp.name)
        self.path = self.root / 'data/4.20/animation_manifest.json'
        self.path.parent.mkdir(parents=True)
        self.path.write_bytes(b'original')
        self.event_path = self.root / 'docs/change.json'
        self.event_path.parent.mkdir()
        self.event_path.write_bytes(b'{"event":"qualified change"}')
        self.event = {'path': 'docs/change.json', **identity(self.event_path.read_bytes())}
        self.source = {'source_id': 'OLS-00000000-0000-0000-0000-000000000001',
                       'path': str(self.path), 'kind': 'local_conversion',
                       'origin': {'kind': 'preserved local source'}, 'version': 'old',
                       **identity(b'original'), 'source_identity_verified': True,
                       'expected_sha256': identity(b'original')['sha256'],
                       'expected_identity_matches': True,
                       'identity_history': [{'unrelated_old_proof': 'preserve me'}]}

    def version(self, source=None, new=b'corrected'):
        source = source or self.source
        old = self.path.read_bytes()
        record, archive = prepare_version(source, self.root, old, new, self.event,
                                           'Native-qualified precision correction',
                                           '2026-10-21T08:00:00+00:00')
        target = self.root / archive
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_bytes(old)
        self.path.write_bytes(new)
        return record, target

    def test_01_old_full_record_and_bytes_remain_resolvable(self):
        record, archive = self.version()
        self.assertEqual(validate_history(record, self.root, True), 1)
        self.assertEqual(historical_record(record, self.source['sha256']), self.source)
        self.assertEqual(archive.read_bytes(), b'original')
        self.assertFalse(record['expected_identity_matches'])
        self.assertEqual(record['source_id'], self.source['source_id'])

    def test_02_two_versions_preserve_full_prefix_without_recursive_copies(self):
        first, _ = self.version()
        second, _ = self.version(first, b'second correction')
        self.assertEqual(validate_history(second, self.root, True), 2)
        self.assertEqual(historical_record(second, first['sha256']), first)
        self.assertEqual(historical_record(second, self.source['sha256']), self.source)
        self.assertNotIn('version_history', second['version_history'][1]['previous_record'])

    def test_03_unrecorded_current_drift_refused(self):
        record, _ = self.version()
        self.path.write_bytes(b'unrecorded change')
        with self.assertRaisesRegex(SourceVersionError, 'Current versioned source changed'):
            validate_history(record, self.root, True)

    def test_04_missing_and_divergent_archives_refused(self):
        record, archive = self.version()
        archive.write_bytes(b'other old bytes')
        with self.assertRaisesRegex(SourceVersionError, 'Historical source bytes'):
            validate_history(record, self.root, True)
        archive.unlink()
        with self.assertRaisesRegex(SourceVersionError, 'Historical source bytes'):
            validate_history(record, self.root, True)

    def test_05_changed_previous_metadata_refused(self):
        record, _ = self.version()
        record['version_history'][0]['previous_record']['origin']['kind'] = 'invented'
        with self.assertRaisesRegex(SourceVersionError, 'Historical source record changed'):
            validate_history(record, self.root)

    def test_06_path_escape_and_rebound_identity_refused(self):
        record, _ = self.version()
        unsafe = copy.deepcopy(record)
        unsafe['version_history'][0]['archive_path'] = '../escape'
        with self.assertRaisesRegex(SourceVersionError, 'archive path'):
            validate_history(unsafe, self.root)
        record['source_id'] = 'OLS-00000000-0000-0000-0000-000000000002'
        with self.assertRaisesRegex(SourceVersionError, 'rebound'):
            validate_history(record, self.root)

    def test_07_changed_evidence_refused(self):
        record, _ = self.version()
        self.event_path.write_bytes(b'changed evidence')
        with self.assertRaisesRegex(SourceVersionError, 'evidence missing or changed'):
            validate_history(record, self.root, True)

    def test_08_native_and_proof_sources_cannot_be_adopted(self):
        for path in [self.root.parent / 'native.inibin', self.root / 'docs/prior-proof.json']:
            source = {**self.source, 'path': str(path)}
            with self.assertRaises(SourceVersionError):
                prepare_version(source, self.root, b'original', b'new', self.event,
                                'reason', '2026-10-21T08:00:00+00:00')

    def test_09_wrong_old_bytes_or_concurrent_drift_refused(self):
        for old in [b'wrong', b'original']:
            if old == b'original':
                self.path.write_bytes(b'concurrent')
            with self.assertRaises(SourceVersionError):
                prepare_version(self.source, self.root, old, b'new', self.event,
                                'reason', '2026-10-21T08:00:00+00:00')

    def test_10_missing_reason_timezone_and_duplicate_identity_refused(self):
        for new, reason, utc in [(b'new', '', '2026-10-21T08:00:00+00:00'),
                                 (b'new', 'reason', '2026-10-21T08:00:00'),
                                 (b'original', 'reason', '2026-10-21T08:00:00+00:00')]:
            with self.assertRaises(SourceVersionError):
                prepare_version(self.source, self.root, b'original', new, self.event, reason, utc)

    def test_11_unknown_historical_sha_and_truncated_prefix_refused(self):
        first, _ = self.version()
        second, _ = self.version(first, b'second correction')
        with self.assertRaisesRegex(SourceVersionError, 'Unknown historical'):
            historical_record(second, '0' * 64)
        second['version_history'][1]['prior_history_count'] = 0
        with self.assertRaisesRegex(SourceVersionError, 'truncated'):
            validate_history(second, self.root)

    def test_12_no_history_is_backward_compatible(self):
        self.assertEqual(validate_history(self.source, self.root, True), 0)
        self.assertEqual(historical_record(self.source, self.source['sha256']), self.source)


if __name__ == '__main__':
    unittest.main(verbosity=2)
