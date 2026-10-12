"""Freeze the scratch-only candidate; no compiler, test or installation."""
from pathlib import Path
import ast, datetime, hashlib, json
D = Path(__file__).resolve().parent
S = D.parent.parent
def sha(path): return hashlib.sha256(path.read_bytes()).hexdigest()
def load(path): return json.loads(path.read_text(encoding='utf-8-sig'))
REL = 'crates/core/src/audio_replay_windows_loading_retirement_tests.rs'
order = load(S / 'test_order_repair.json')
decision = load(D / 'decision.json')
candidate = D / Path(REL).name
assert decision['before_sha256'] == order['files'][REL]['after_sha256']
assert decision['after_sha256'] == sha(candidate)
for script in [D / 'prepare_candidate.py', Path(__file__), S / 'apply_metadata_cache_repair.py']:
    ast.parse(script.read_text(encoding='utf-8'))
proofs = {}
for path in [*sorted(D.iterdir()), S / 'apply_metadata_cache_repair.py']:
    if not path.is_file(): continue
    proofs[path.relative_to(S).as_posix()] = {'bytes': path.stat().st_size, 'sha256': sha(path)}
failed = dict(decision['failed_run']);failed['log'] = (D / failed['log']).relative_to(S).as_posix()
value = {
    'schema': 1, 'complete': False, 'saved_utc': datetime.datetime.now(datetime.timezone.utc).isoformat(),
    'assembled_sha256': sha(S / 'assembled.json'), 'installed_sha256': sha(S / 'installed.json'),
    'index_repair_manifest_sha256': sha(S / 'review/index_read_repair/repair_manifest.json'),
    'index_repair_installed_sha256': sha(S / 'index_repair_installed.json'),
    'test_order_repair_manifest_sha256': sha(S / 'test_order_repair.json'),
    'test_order_repair_installed_sha256': sha(S / 'test_order_repair_installed.json'),
    'files': {REL: {'before_sha256': decision['before_sha256'], 'after_sha256': sha(candidate),
                   'bytes': candidate.stat().st_size, 'candidate': candidate.relative_to(S).as_posix()}},
    'added_tests': [], 'proof_files': proofs, 'failed_run': failed,
    'production_modified': False, 'rust_compiled': False, 'rust_tests_executed': False,
    'qualification_required': {'exact_test_first': decision['failed_run']['failed_test'],
                               'then_full_core_passed': 892, 'filtered': 480, 'required_names': 51,
                               'rebuilt_client_commands': 11},
    'limits': ['Only the existing diagnostic test changes; no runtime ownership guard is relaxed.',
               'The cold cache pointer is required to be the only added persistent owner and to retire exactly once.',
               'This candidate has not been compiled or executed. The full previous run failed891/1 and is not a qualification.',
               'No actual provider, native INI, full startup or complete loading UI is claimed.'],
}
path = S / 'metadata_cache_repair.json'
path.write_text(json.dumps(value, indent=2) + '\n', encoding='utf-8')
print(json.dumps({'manifest': str(path), 'sha256': sha(path), 'proof_files': len(proofs), 'tests_added': 0}))
