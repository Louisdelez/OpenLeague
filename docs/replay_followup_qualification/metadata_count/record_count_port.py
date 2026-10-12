"""Record already-executed scratch qualification without running more tests."""
from pathlib import Path
import hashlib
import json
import re

root = Path(__file__).resolve().parent
core = Path('E:/OpenLeague/crates/core/src')
def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()
text = (root / 'metadata_count_tests.log').read_text(encoding='utf-8-sig')
assert '4 passed; 0 failed; 0 ignored; 0 measured; 8 filtered out' in text
elapsed = re.search(r'finished in ([0-9.]+)s', text).group(1)
files = ['audio_replay_metadata.rs', 'audio_replay_metadata_tests.rs', 'count_functions.rs',
         'count_tests.rs', 'metadata_count.patch', 'metadata_count_harness.rs',
         'metadata_count_harness.exe', 'metadata_count_build.log', 'metadata_count_tests.log',
         'prepare_count_port.py', 'replay_metadata_count_probe.json']
result = {
    'passed': True, 'complete': False, 'production_modified': False,
    'scope': 'Scratch-only generic metadata728150/7281C0 scalar port',
    'tests': {'passed': 4, 'failed': 0, 'filtered': 8, 'seconds': float(elapsed),
              'new_tests': 2, 'lifecycle_regressions': 2,
              'native_setter_calls_compared': 72, 'native_getter_calls_compared': 360},
    'native_sha256': '402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862',
    'oracle': 'E:/mapslol3v3/replay_manager_agent/replay_metadata_setters_audit.json',
    'oracle_sha256': 'c261df7c77265c610f85c39546367a89dd2c6d959dafc50dd3f7a0f22c68aa73',
    'production_base_sha256': {name: sha(core / name) for name in ['audio_replay_metadata.rs', 'audio_replay_metadata_tests.rs']},
    'hashes': {name: sha(root / name) for name in files},
    'compile': ['C:/Users/loicd/.cargo/bin/rustc.exe', '--edition=2024', '--test',
                str(root / 'metadata_count_harness.rs'), '--extern',
                'serde_json=E:/OpenLeague/target/debug/deps/libserde_json-06e1b1b57f0ae5f7.rlib',
                '-L', 'dependency=E:/OpenLeague/target/debug/deps', '-o', str(root / 'metadata_count_harness.exe')],
    'run': [str(root / 'metadata_count_harness.exe'), 'audio_replay_metadata', '--nocapture'],
    'limits': ['No production integration, Windows dispatch, frame consumer729D70 or string-map changes.',
               'Native limit48 preserved; this does not qualify count-driven frame copying beyond the24-entry fixed arrays.',
               'Result cleanup follows the existing metadata clear pattern; injected boundary read/write/lock failures are not covered by the native parity fixtures.',
               'Only the selected metadata tests ran; this is not the full core test suite.'],
}
(root / 'metadata_count_receipt.json').write_text(json.dumps(result, indent=2) + '\n', encoding='utf-8')
print(json.dumps({'passed': True, 'tests': result['tests'], 'production_modified': False}))
