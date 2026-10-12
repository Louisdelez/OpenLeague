"""Read-only installed-source/document preflight, never a qualification runner.

Extract only explicit pure guards. Do not import or invoke recorder main/publish,
client verification, native code, or any compiler. Save results in scratch only.
"""
from pathlib import Path
import ast, hashlib, json, re

S = Path(__file__).resolve().parent
R = Path('E:/OpenLeague')
source = S / 'record_validation.py'
syntax = ast.parse(source.read_text(encoding='utf-8'))
names = {'sha', 'digest', 'load', 'within', 'verify_test_correction', 'verify_native',
         'verify_repair', 'verify_source_set', 'verify_repair_installation', 'interrupted_compile',
         'verify_provider_preparation', 'verify_provider_io_preparation',
         'verify_test_order_repair', 'verify_test_order_installation',
         'verify_metadata_cache_repair', 'verify_metadata_cache_installation',
         'verify_test_binding_repair', 'verify_test_binding_installation'}
nodes = [n for n in syntax.body if isinstance(n, ast.FunctionDef) and n.name in names]
assert {n.name for n in nodes} == names
ns = {'Path': Path, 'hashlib': hashlib, 'json': json, 're': re, 'S': S, 'R': R}
for node in syntax.body:
    if isinstance(node, ast.Assign) and len(node.targets) == 1 and isinstance(node.targets[0], ast.Name):
        if node.targets[0].id in {'NATIVE_SHA', 'CORRECTION_SHA', 'EXCLUDED', 'REPAIR_REL', 'ARCHIVE',
                                 'IMAGE_SHA', 'VERIFIER_SHA', 'HISTORICAL_CLIENT_RECEIPT', 'HISTORICAL_CLIENT_SHA',
                                 'PROVIDER_PREPARATION_SHA', 'NEXT_PROVIDER_ACTION',
                                 'PROVIDER_IO_SHA', 'PROVIDER_IO_REVIEW_SHA', 'NEXT_PROVIDER_IO_ACTION',
                                 'TEST_ORDER_PATH', 'TEST_ORDER_NAME'}:
            ns[node.targets[0].id] = ast.literal_eval(node.value)
exec(compile(ast.Module(body=nodes, type_ignores=[]), str(source) + ':read-only-guards', 'exec'), ns)
assert 'main' not in ns and 'publish' not in ns
sha, load = ns['sha'], ns['load']
assembled, installed = load(S / 'assembled.json'), load(S / 'installed.json')
assert sha(S / 'assembled.json') == installed['assembled_sha256']
assert installed['files'] == assembled['files'] and len(installed['files']) == 24
correction = ns['verify_test_correction'](assembled, installed)
reviewed = '467914aefc209b70c01212083728447cbc8302e0abc167f674d1d1d233e9bec6'
repair = ns['verify_repair'](assembled, installed, correction, reviewed)
application, stable = ns['verify_repair_installation'](repair, reviewed)
test_order_reviewed = 'b17f1699ebb35154690809891d34090f828706223b30787f4dfafb8ba3c74c86'
test_order, test_order_stable = ns['verify_test_order_repair'](assembled, installed, repair, test_order_reviewed)
test_order_application, test_order_install_stable = ns['verify_test_order_installation'](test_order, test_order_reviewed)
cache_reviewed = '18e6be63baf5e88858bd16671a6399c587845c0e7092ab74d731329ae9ca7b04'
cache_repair, cache_stable = ns['verify_metadata_cache_repair'](assembled, installed, repair, test_order, cache_reviewed)
cache_application, cache_install_stable = ns['verify_metadata_cache_installation'](cache_repair, cache_reviewed)
binding_reviewed = 'a5ca67871ebe3e79b91b7b6056b2ec19ea4173f80f3d0f830b6dfcead48885a5'
binding_repair, binding_stable = ns['verify_test_binding_repair'](cache_repair, binding_reviewed)
binding_application, binding_install_stable = ns['verify_test_binding_installation'](binding_repair, binding_reviewed)
hashes, deltas = ns['verify_source_set'](installed, repair, test_order, cache_repair, binding_repair)
native = ns['verify_native'](assembled)
interrupted = ns['interrupted_compile']()
provider_preparation, provider_stable = ns['verify_provider_preparation']()
provider_io, provider_io_stable = ns['verify_provider_io_preparation']()
for relative, expected in assembled['candidate_manifests'].items():
    path = S / relative
    assert sha(path) == expected
    for child, row in load(path)['files'].items():
        candidate = ns['within'](path.parent, child)
        assert sha(candidate) == row['sha256'] and candidate.stat().st_size == row['bytes']
image = load(S / 'independent_image_verification.json')
assert image['passed'] is True and image['errors'] == []
assert image['region_count'] == 73 and image['package_bytes'] == 21110
assert image['native_source_sha256'] == ns['NATIVE_SHA']
assert image['package_sha256'] == assembled['image'] == ns['IMAGE_SHA']
assert sha(R / 'data/4.20/runtime/replay_runtime_image.bin') == ns['IMAGE_SHA']
verifier = S.parent / 'loading_clock_integration/verify_client_commands.py'
assert sha(verifier) == ns['VERIFIER_SHA']
previous = R / assembled['previous_qualification']
assert sha(previous) == assembled['previous_receipt_sha256']
history = R / ns['HISTORICAL_CLIENT_RECEIPT']
assert sha(history) == ns['HISTORICAL_CLIENT_SHA']
assert load(previous)['prior_client_unit_test_receipt'] == ns['HISTORICAL_CLIENT_RECEIPT']
historical = load(history)
assert historical['client_tests']['passed'] == 14 and historical['client_tests']['failed'] == 0
for relative in ['crates/client/src/main.rs', 'crates/client/src/native_effect_clock.rs']:
    assert sha(R / relative) == historical['source_hashes'][relative]
doc_hashes = {}
for name in ['coverage.json', 'resume_checkpoint.json', 'completion_plan.json']:
    path = R / 'docs' / name
    d = load(path)
    assert all(isinstance(d[field], dict) for field in ['prepared_loading_resource_next', 'prepared_loading_resource_port_plan'])
    assert isinstance(d['prepared_next_evidence']['string24_ownership'], dict)
    if name == 'resume_checkpoint.json':
        p = d['in_progress']
        assert p['assembled_sha256'] == installed['assembled_sha256'] and Path(p['stage']).resolve() == S.resolve()
        a = p['index_read_repair']
        assert a['sha256'] == reviewed and a['tests_pending'] is True
        assert Path(a['manifest']).resolve() == (S / ns['REPAIR_REL']).resolve()
        assert Path(a['backup']).resolve() == Path(application['backup']).resolve()
        a = p['test_order_repair']
        assert a['sha256'] == test_order_reviewed and a['tests_pending'] is True
        assert Path(a['manifest']).resolve() == (S / 'test_order_repair.json').resolve()
        assert Path(a['backup']).resolve() == Path(test_order_application['backup']).resolve()
        a = p['metadata_cache_repair']
        assert a['sha256'] == cache_reviewed and a['tests_pending'] is True
        assert Path(a['manifest']).resolve() == (S / 'metadata_cache_repair.json').resolve()
        assert Path(a['backup']).resolve() == Path(cache_application['backup']).resolve()
        a = p['test_binding_repair']
        assert a['sha256'] == binding_reviewed and a['tests_pending'] is True
        assert Path(a['manifest']).resolve() == (S / 'test_binding_repair.json').resolve()
        assert Path(a['backup']).resolve() == Path(binding_application['backup']).resolve()
        assert isinstance(d.get('communication_preferences', {}), dict)
    if name == 'completion_plan.json':
        assert len(d['next_execution_steps']) > 0
        selected = [domain for domain in d['domains'] if domain['id'] in ['17', '21']]
        assert len(selected) == 2
        tasks = {task['id']: task for domain in selected for task in domain['tasks']}
        assert all(isinstance(tasks[key]['evidence'], list) for key in ['17.3', '21.3', '21.4'])
    doc_hashes[name] = sha(path)
html = R / 'docs/completion_plan.html'
body = html.read_text(encoding='utf-8')
assert body.count('</body>') == 1 and 'loading-resource-manager-validation' not in body
doc_hashes[html.name] = sha(html)
report = {
    'preflight_passed': True, 'qualification_passed': False, 'complete': False,
    'scope': 'read-only installed sources and future recorder inputs; no pipeline result validation',
    'recorder_sha256': sha(source), 'preflight_sha256': sha(Path(__file__)),
    'repair_manifest_sha256': reviewed, 'repair_installation': application,
    'test_order_manifest_sha256': test_order_reviewed, 'test_order_installation': test_order_application,
    'metadata_cache_manifest_sha256': cache_reviewed, 'metadata_cache_installation': cache_application,
    'test_binding_manifest_sha256': binding_reviewed, 'test_binding_installation': binding_application,
    'source_file_count': len(hashes), 'explicit_repairs': deltas,
    'expected_core_passed_not_observed_here': 890 + len(repair['added_tests']),
    'expected_required_tests': len(correction['effective_required_core_tests']) + len(repair['added_tests']),
    'expected_new_tests': 25 + len(repair['added_tests']),
    'native_proof_hashes': native, 'image_regions': 73, 'image_bytes': 21110,
    'source_hashes': hashes, 'document_snapshot_hashes': doc_hashes,
    'interrupted_diagnostic_not_a_test_run': interrupted,
    'provider_preparation': provider_preparation,
    'provider_inputs_checked': len(provider_stable),
    'provider_io': provider_io, 'provider_io_inputs_checked': len(provider_io_stable),
    'real_recorder_main_executed': False, 'publication_executed': False,
    'production_modified': False, 'compiler_or_client_executed': False,
}
(S / 'recorder_inputs_preflight.json').write_text(json.dumps(report, indent=2) + '\n', encoding='utf-8')
print(json.dumps({key: report[key] for key in ['preflight_passed', 'qualification_passed', 'source_file_count',
      'expected_core_passed_not_observed_here', 'expected_required_tests', 'expected_new_tests', 'recorder_sha256']}))
