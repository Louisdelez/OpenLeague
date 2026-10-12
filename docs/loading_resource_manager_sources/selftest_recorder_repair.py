"""Exercise only recorder pure guards extracted by AST, never main/publish/client.

All mutations target a fresh directory beneath mapslol3v3. Synthetic data here
qualifies rejection by the recorder, not Rust/native/game behavior.
"""
from pathlib import Path
import ast, copy, hashlib, json, re, tempfile

STAGE = Path(__file__).resolve().parent
SOURCE = STAGE / 'record_validation.py'
NATIVE = '402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
CORRECTION = '9be8760164910052f6c7ff44ca4e46568a01283d18e0ee63c34f89dd8788ce78'
REL = 'review/index_read_repair/repair_manifest.json'
ALLOWED = {'sha', 'digest', 'load', 'within', 'verify_repair',
           'verify_source_set', 'verify_repair_installation',
           'verify_test_order_repair', 'verify_test_order_installation'}
tree = ast.parse(SOURCE.read_text(encoding='utf-8'))
nodes = [node for node in tree.body if isinstance(node, ast.FunctionDef) and node.name in ALLOWED]
assert {node.name for node in nodes} == ALLOWED
namespace = {'Path': Path, 'hashlib': hashlib, 'json': json, 're': re,
             'NATIVE_SHA': NATIVE, 'CORRECTION_SHA': CORRECTION,
             'REPAIR_REL': REL, 'ARCHIVE': 'docs/loading_resource_manager_sources',
             'TEST_ORDER_PATH': 'crates/core/src/audio_replay_windows_loading_retirement_tests.rs',
             'TEST_ORDER_NAME': 'audio_replay_windows_loading_standard_packet_uses_real_resource_manager_and_retires_normalized_key_on_factory_boundary'}
exec(compile(ast.Module(body=nodes, type_ignores=[]), str(SOURCE) + ':guards-only', 'exec'), namespace)
assert 'main' not in namespace and 'publish' not in namespace

def sha(path): return hashlib.sha256(path.read_bytes()).hexdigest()
def write(path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(data)
def json_write(path, value): write(path, (json.dumps(value, indent=2) + '\n').encode())
def failed(label, operation):
    try: operation()
    except (AssertionError, FileNotFoundError, KeyError, ValueError): rejected.append(label)
    else: raise AssertionError('accepted invalid case: ' + label)

rejected = []
root = Path('E:/mapslol3v3/loading_resource_manager_recorder_selftest')
root.mkdir(exist_ok=True)
with tempfile.TemporaryDirectory(prefix='guards-', dir=root) as temporary:
    work = Path(temporary)
    assert work.resolve().is_relative_to(root.resolve())
    stage, production = work / 'stage', work / 'production'
    namespace.update(S=stage, R=production)
    index = 'crates/core/src/audio_loading_resource_manager_index.rs'
    tests = 'crates/core/src/audio_loading_resource_manager_index_read_tests.rs'
    fixture = 'data/4.20/loading_resource_index_read_contract.json'
    original = {index: b'original index\n'}
    original.update({f'crates/core/src/original_{i}.rs': f'original {i}\n'.encode() for i in range(23)})
    installed = {'assembled_sha256': '1' * 64, 'files': {p: {'after': hashlib.sha256(data).hexdigest()} for p, data in original.items()}}
    json_write(stage / 'installed.json', installed)
    assembled = {'required_core_tests': ['audio_original']}
    correction = {'filters': ['audio_', 'native_clock']}
    candidates = {
        index: b'mod index_read_tests;\n',
        tests: b'#[test]\nfn audio_first_new_test() {}\n#[test]\nfn audio_second_new_test() {}\n',
        fixture: json.dumps({'passed': True, 'source_sha256': NATIVE, 'insertions': 8, 'read_operations': 232}).encode(),
    }
    manifest = {
        'schema': 1, 'complete': False, 'assembled_sha256': '1' * 64,
        'installed_sha256': '', 'required_tests_correction_sha256': CORRECTION,
        'files': {}, 'added_tests': ['audio_first_new_test', 'audio_second_new_test'],
        'proof_files': {}, 'source_inputs': {},
        'native_proofs': {fixture: {'json_checks': {'passed': True, 'source_sha256': NATIVE, 'insertions': 8, 'read_operations': 232}}},
    }
    manifest['installed_sha256'] = sha(stage / 'installed.json')
    for path, data in original.items():
        write(production / path, data); write(stage / 'production' / path, data)
    for path, data in candidates.items():
        name = Path(path).name
        write((stage / REL).parent / name, data)
        row = {'before_sha256': installed['files'].get(path, {}).get('after'),
               'after_sha256': hashlib.sha256(data).hexdigest(), 'bytes': len(data), 'candidate': name}
        manifest['files'][path] = row
        manifest['proof_files'][name] = {'bytes': len(data), 'sha256': row['after_sha256']}
    manifest_path = stage / REL
    json_write(manifest_path, manifest)
    check = lambda current=None: namespace['verify_repair'](assembled, installed, correction, current or sha(manifest_path))
    assert check() == manifest
    failed('unreviewed manifest', lambda: namespace['verify_repair'](assembled, installed, correction, None))
    failed('wrong pinned manifest hash', lambda: check('0' * 64))

    mutations = [
        ('old installed before hash', lambda d: d['files'][index].update(before_sha256='0' * 64)),
        ('changed bytes hash', lambda d: d['files'][index].update(after_sha256='0' * 64)),
        ('changed byte count', lambda d: d['files'][index].update(bytes=0)),
        ('candidate escape', lambda d: d['files'][index].update(candidate='../outside.rs')),
        ('duplicate added test', lambda d: d.update(added_tests=['audio_first_new_test'] * 2)),
        ('invented added test', lambda d: d.update(added_tests=['audio_not_in_source'])),
        ('unselected added test', lambda d: d.update(added_tests=['not_selected'])),
        ('old required test reused', lambda d: d.update(added_tests=['audio_original'])),
        ('false oracle pass', lambda d: d['native_proofs'][fixture]['json_checks'].update(passed=False)),
        ('wrong oracle count', lambda d: d['native_proofs'][fixture]['json_checks'].update(insertions=9)),
        ('wrong oracle type', lambda d: d['native_proofs'][fixture]['json_checks'].update(insertions=True)),
        ('missing native proof', lambda d: d.update(native_proofs={})),
        ('wrong proof hash', lambda d: d['proof_files'][Path(tests).name].update(sha256='0' * 64)),
        ('outside source input', lambda d: d['source_inputs'].update({str(work / 'outside'): {'bytes': 1, 'sha256': '0' * 64}})),
    ]
    for label, mutate in mutations:
        altered = copy.deepcopy(manifest); mutate(altered); json_write(manifest_path, altered)
        failed(label, check)
    json_write(manifest_path, manifest)

    failed('manifest not yet installed', lambda: namespace['verify_source_set'](installed, manifest))
    for path, data in candidates.items():
        write(production / path, data); write(stage / 'production' / path, data)
    hashes, repairs = namespace['verify_source_set'](installed, manifest)
    assert len(hashes) == 26 and len(repairs) == 3
    untouched = 'crates/core/src/original_0.rs'
    for location in [production, stage / 'production']:
        write(location / untouched, b'unauthorized change\n')
    failed('undeclared equal production and stage delta', lambda: namespace['verify_source_set'](installed, manifest))
    for location in [production, stage / 'production']: write(location / untouched, original[untouched])
    unexpected = stage / 'production/crates/core/src/not_declared.rs'
    write(unexpected, b'new file\n')
    failed('undeclared new stage file', lambda: namespace['verify_source_set'](installed, manifest))
    unexpected.unlink()
    write(production / index, b'wrong production bytes\n')
    failed('production differs from repair', lambda: namespace['verify_source_set'](installed, manifest))
    write(production / index, candidates[index])

    backup = production / 'docs/plan_history/resource-index-read-repair-test'
    write(backup / 'repair_manifest.json', manifest_path.read_bytes())
    for label in ['installed', 'staged']: write(backup / label / index, original[index])
    application = {'manifest': str(manifest_path), 'manifest_sha256': sha(manifest_path),
                   'files': manifest['files'], 'tests_pending': True, 'backup': str(backup), 'installed_utc': 'synthetic'}
    applied_path = stage / 'index_repair_installed.json'
    json_write(applied_path, application)
    installation = lambda: namespace['verify_repair_installation'](manifest, sha(manifest_path))
    receipt, stable = installation()
    assert receipt['historical_tests_pending_flag_preserved'] is True and len(stable) == 4
    for label, mutate in [
        ('application wrong manifest hash', lambda d: d.update(manifest_sha256='0' * 64)),
        ('application missing changed file', lambda d: d['files'].pop(index)),
        ('application outside backup', lambda d: d.update(backup=str(work / 'outside'))),
        ('application falsely marked tested', lambda d: d.update(tests_pending=False)),
    ]:
        altered = copy.deepcopy(application); mutate(altered); json_write(applied_path, altered)
        failed(label, installation)
    json_write(applied_path, application)
    write(backup / 'staged' / index, b'not original\n')
    failed('backup mirror old bytes mismatch', installation)
    write(backup / 'staged' / index, original[index])
    namespace['verify_source_set'](installed, manifest); installation(); check()

with tempfile.TemporaryDirectory(prefix='test-order-', dir=root) as temporary:
    work = Path(temporary)
    assert work.resolve().is_relative_to(root.resolve())
    stage, production = work / 'stage', work / 'production'
    namespace.update(S=stage, R=production)
    for relative in ['assembled.json', 'installed.json', REL, 'index_repair_installed.json',
                     'test_order_repair.json', 'ownership/audio_replay_windows_loading_retirement_tests.rs']:
        write(stage / relative, (STAGE / relative).read_bytes())
    real_manifest = json.loads((stage / 'test_order_repair.json').read_text())
    for relative in real_manifest['proof_files']:
        write(stage / relative, (STAGE / relative).read_bytes())
    decision_path = stage / 'review/test_order_repair/decision.json'
    decision_bytes = decision_path.read_bytes()
    decision = json.loads(decision_bytes)
    for filename in decision['source_guards']:
        relative = 'crates/core/src/' + filename
        write(production / relative, (Path('E:/OpenLeague') / relative).read_bytes())
    assembled = json.loads((stage / 'assembled.json').read_text())
    installed = json.loads((stage / 'installed.json').read_text())
    index_repair = json.loads((stage / REL).read_text())
    manifest_path = stage / 'test_order_repair.json'
    check_order = lambda: namespace['verify_test_order_repair'](assembled, installed, index_repair, sha(manifest_path))
    assert check_order()[0] == real_manifest
    failed('test-order manifest not explicitly pinned', lambda: namespace['verify_test_order_repair'](assembled, installed, index_repair, None))
    failed('test-order manifest wrong pinned hash', lambda: namespace['verify_test_order_repair'](assembled, installed, index_repair, '0' * 64))
    mutations = [
        ('test-order tries to add test', lambda d: d.update(added_tests=['audio_extra'])),
        ('test-order changes another file', lambda d: d['files'].update({'crates/core/src/runtime.rs': copy.deepcopy(next(iter(d['files'].values())))})),
        ('test-order wrong prior index receipt', lambda d: d.update(index_repair_installed_sha256='0' * 64)),
        ('test-order wrong prior installed bytes', lambda d: next(iter(d['files'].values())).update(before_sha256='0' * 64)),
        ('test-order failed run falsely passed', lambda d: d['failed_run'].update(failed=0)),
        ('test-order wrong failed test', lambda d: d['failed_run'].update(failed_test='audio_other')),
        ('test-order failed run claims client build', lambda d: d['failed_run'].update(client_build_executed=True)),
    ]
    for label, mutate in mutations:
        altered = copy.deepcopy(real_manifest); mutate(altered); json_write(manifest_path, altered)
        failed(label, check_order)
    json_write(manifest_path, real_manifest)
    guard = production / 'crates/core/src/audio_replay_windows_service.rs'
    original_guard = guard.read_bytes();write(guard, original_guard + b'\n// unauthorized guard change\n')
    failed('test-order production ownership guard changed', check_order)
    write(guard, original_guard)
    # Even a freshly hash-pinned manifest may not broaden the exact two-line change.
    altered_decision = copy.deepcopy(decision)
    altered_decision['byte_replacement']['after_hex'] += '0d0a'
    json_write(decision_path, altered_decision)
    altered = copy.deepcopy(real_manifest)
    altered['proof_files']['review/test_order_repair/decision.json'] = {'bytes': decision_path.stat().st_size, 'sha256': sha(decision_path)}
    json_write(manifest_path, altered)
    failed('test-order replacement broadened despite refreshed proof hash', check_order)
    write(decision_path, decision_bytes);json_write(manifest_path, real_manifest)

    backup = production / 'docs/plan_history/resource-test-order-repair-test'
    write(backup / 'repair_manifest.json', manifest_path.read_bytes())
    relative = namespace['TEST_ORDER_PATH']
    old_bytes = (stage / 'ownership/audio_replay_windows_loading_retirement_tests.rs').read_bytes()
    for kind in ['installed', 'staged']: write(backup / kind / relative, old_bytes)
    application = {'manifest': str(manifest_path), 'manifest_sha256': sha(manifest_path),
                   'files': real_manifest['files'], 'tests_pending': True,
                   'backup': str(backup), 'installed_utc': 'synthetic'}
    applied_path = stage / 'test_order_repair_installed.json';json_write(applied_path, application)
    installation = lambda: namespace['verify_test_order_installation'](real_manifest, sha(manifest_path))
    assert installation()[0]['historical_tests_pending_flag_preserved'] is True
    altered = copy.deepcopy(application);altered['manifest_sha256'] = '0' * 64;json_write(applied_path, altered)
    failed('test-order install receipt wrong manifest hash', installation)
    json_write(applied_path, application)
    write(backup / 'staged' / relative, b'wrong mirror\n')
    failed('test-order installation mirror backup mismatch', installation)
    write(backup / 'staged' / relative, old_bytes)
    check_order();installation()

report = {'passed': True, 'scope': 'isolated AST-extracted recorder guards with synthetic temporary paths only',
          'recorder_sha256': sha(SOURCE), 'selftest_sha256': sha(Path(__file__)),
          'rejected_cases': rejected, 'rejected_count': len(rejected),
          'real_recorder_main_executed': False, 'publication_executed': False,
          'production_modified': False, 'client_executed': False, 'compiler_executed': False,
          'rust_or_native_qualification_claimed': False}
json_write(STAGE / 'recorder_repair_selftest.json', report)
print(json.dumps(report))
