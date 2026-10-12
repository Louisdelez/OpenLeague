from pathlib import Path
from datetime import datetime, timezone
import hashlib, json, re

ROOT = Path(__file__).resolve().parent
PRODUCTION = Path('E:/OpenLeague/crates/core/src')
PACKET = Path('E:/mapslol3v3/replay_packet_agent')

def evidence(path):
    data = path.read_bytes()
    return {'path': str(path), 'bytes': len(data), 'sha256': hashlib.sha256(data).hexdigest()}

logs = [('test_cleanup.log', 4), ('test_success_regression.log', 1), ('test_receive_regression.log', 2)]
for name, count in logs:
    text = (ROOT / name).read_text(encoding='utf-8-sig')
    assert f'test result: ok. {count} passed; 0 failed;' in text, name

modules = re.findall(r'#\[path="([^"]+)"\]', (ROOT / 'cleanup_harness.rs').read_text())
assert len(modules) == 13
payload = {
    'schema': 'openleague-isolated-host-error-cleanup-qualification-v1',
    'recorded_utc': datetime.now(timezone.utc).isoformat(),
    'native_sha256': '402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862',
    'rust_tests_run': True,
    'rust_test_functions_passed': 7,
    'new_rust_test_functions': 4,
    'regression_rust_test_functions': 3,
    'production_integrated_by_this_agent': False,
    'cargo_run': False,
    'native_error_unwinding_claimed': False,
    'native_oracle_rerun': False,
    'new_runtime_pe_regions': [],
    'files': [evidence(ROOT / name) for name in [
        'audio_announcer_owner_metadata.rs', 'audio_announcer_service_activation.rs',
        'audio_announcer_service_activation_cleanup_tests.rs', 'cleanup.patch',
        'cleanup_harness.rs', 'cleanup_tests.exe', 'compile_cleanup.log',
        *(name for name, _ in logs), 'QUALIFICATION.md', 'record_qualification.py',
    ]],
    'production_baselines': [evidence(PRODUCTION / name) for name in [
        'audio_announcer_owner_metadata.rs', 'audio_announcer_service_activation.rs',
    ]],
    'harness_module_inputs': [evidence(Path(path)) for path in modules],
    'native_fixture_inputs': [evidence(PACKET / name) for name in [
        'replay_service_packet_probe.json', 'replay_service_packet_sources.json',
    ]],
    'limits': [
        'Result-based host boundary cleanup only; Rust panic and native C++ exception unwinding unqualified.',
        'Cleanup failure is explicit and may leave snapshot live; no unsafe retry.',
        'Production integration and suite checks belong to root.',
    ],
}
(ROOT / 'qualification_manifest.json').write_text(json.dumps(payload, indent=2) + '\n', encoding='utf-8')
print(json.dumps(evidence(ROOT / 'qualification_manifest.json')))
