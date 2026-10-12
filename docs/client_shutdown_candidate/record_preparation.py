"""Read source evidence and record this uncompiled scratch preparation only."""
from pathlib import Path
import hashlib
import json

HERE = Path(__file__).resolve().parent
BASE = HERE.parent / 'process_clock_client_shutdown_review'

def record(path):
    path = Path(path)
    data = path.read_bytes()
    return {'path': str(path), 'bytes': len(data), 'sha256': hashlib.sha256(data).hexdigest()}

baseline_expected = {
    'native_runtime_shutdown.rs': '4831276c8902e7d602cdd334b975ea2617cd1cd15828e8be45ace4009be07499',
    'main_integration.rs.txt': '15e9238501d455c651644df85851306c4bdbc4527d817d654f97753740bb0049',
    'REVIEW.md': 'ec7e51536f61b541be06e70fec3d7a5334d087e8a04f40b7d2ad2f5b412bdfda',
    'manifest.json': '2d2c9618d276b012abce874cbd0b62f61448b2f88640418244f2c97045cc4015',
}
baseline = [record(BASE / name) for name in baseline_expected]
assert all(item['sha256'] == baseline_expected[Path(item['path']).name] for item in baseline)
prior = json.loads((BASE / 'manifest.json').read_text(encoding='utf-8-sig'))
sources = [record(item['path']) for item in prior['sources']]
for name in ['crates/client/src/native_user_settings.rs', 'crates/client/Cargo.toml', 'Cargo.toml', 'Cargo.lock']:
    sources.append(record(Path('E:/OpenLeague') / name))
tests = (HERE / 'native_runtime_shutdown_tests.rs').read_text(encoding='utf-8')
expected_tests = [
    'normal_shutdown_last_observes_exit_and_closes_initialized_owners_once',
    'normal_shutdown_keeps_injected_observation_error_and_error_exit_after_real_cleanup',
    'normal_shutdown_before_first_clock_consumer_does_not_initialize_a_clock',
]
assert tests.count('#[test]') == 3
assert all(f'fn {name}()' in tests for name in expected_tests)
source = (HERE / 'native_runtime_shutdown.rs').read_text(encoding='utf-8')
assert '.raw_clock_sample(' not in source and '.wall_clock_f32_bits(' not in source
assert '.raw_clock_sample(' not in tests and '.wall_clock_f32_bits(' not in tests
manifest = {
    'kind': 'normal_client_shutdown_uncompiled_candidate',
    'complete': False,
    'production_integrated': False,
    'rust_compiled': False,
    'rust_tests_run': False,
    'client_executed': False,
    'real_window_close_test_run': False,
    'process_exit_status_test_run': False,
    'native_allocation_failure_injected': False,
    'normal_drop_ordering_bug_demonstrated': False,
    'baseline_unchanged': True,
    'prepared_tests': expected_tests,
    'fault_scope': 'Local observer failure after real service close; not an OS cleanup fault.',
    'single_shutdown_scope': 'One guarded checkpoint and effective cleanup sequence; Application and Drop may call already-closed methods.',
    'post_close_clock_scope': 'Retained snapshots only; no producer sampling requested by checkpoint/tests after closure.',
    'source_checks_only': {
        'prepared_test_names_present': True,
        'no_direct_clock_producer_call_in_candidate_or_tests': True,
        'frozen_baseline_hashes_match': True,
    },
    'sources': sources,
    'baseline': baseline,
    'artifacts': [record(HERE / name) for name in [
        'native_runtime_shutdown.rs', 'native_runtime_shutdown_tests.rs',
        'main_integration.rs.txt', 'README.md', 'record_preparation.py',
    ]],
}
destination = HERE / 'manifest.json'
destination.write_text(json.dumps(manifest, indent=2) + '\n', encoding='utf-8')
print(json.dumps({'manifest': record(destination), 'prepared_tests': len(expected_tests),
                  'rust_compiled': False, 'rust_tests_run': False, 'baseline_unchanged': True}))
