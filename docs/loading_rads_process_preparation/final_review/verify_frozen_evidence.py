"""Read-only consistency review. Does not import or execute any probe/adapter."""
from pathlib import Path
import hashlib
import json

OUT = Path(__file__).resolve().parent
NATIVE = Path('E:/mapslol3v3/loading_rads_commandline_probe')
STATIC = Path('E:/mapslol3v3/loading_rads_commandline_review')
ENTRY = Path('E:/mapslol3v3/loading_rads_entry_review/entry_static.json')
EXPECTED_NATIVE = 'de3171f52c7387491f4be3883996bbee71209270f3f64293ae4679a85ba1c71c'
EXPECTED_STATIC = 'a09060fecef18a5f4ad7b639cccf9bb349e762db451a6cc5374ed233e906250f'
EARLIER_LF_SHA = 'f08e3142b01e933efd9467a1d2a1b3e897b837988e742f5bc0a79e568b48bda7'
verified = {}

def digest(raw):
    return hashlib.sha256(raw).hexdigest()

def read(path):
    return json.loads(path.read_bytes().decode('utf-8-sig'))

def verify(path, expected, size=None):
    raw = path.read_bytes()
    assert digest(raw) == expected, ('hash', str(path))
    assert size is None or len(raw) == size, ('size', str(path))
    verified[str(path)] = {'sha256': expected, 'bytes': len(raw)}
    return raw

def check_package(root, expected):
    data = json.loads(verify(root / 'manifest.json', expected))
    for name, row in data['files'].items():
        path = root / name
        assert path.resolve().is_relative_to(root.resolve())
        verify(path, row['sha256'], row.get('bytes'))
    for name, row in data.get('source_inputs', {}).items():
        verify(Path(name), row['sha256'], row.get('bytes'))
    for name, row in data.get('external_dependencies', {}).items():
        verify(Path(name), row['sha256'], row.get('bytes'))
    return data

def write_new(name, data):
    raw = (json.dumps(data, ensure_ascii=False, indent=2) + '\n').encode('utf-8')
    with (OUT / name).open('xb') as target:
        target.write(raw)
    assert (OUT / name).read_bytes() == raw
    return {'bytes': len(raw), 'sha256': digest(raw)}

manifest = check_package(NATIVE, EXPECTED_NATIVE)
static = check_package(STATIC, EXPECTED_STATIC)
static_raw = (STATIC / 'manifest.json').read_bytes()
assert digest(static_raw.replace(b'\r\n', b'\n')) == EARLIER_LF_SHA
assert static_raw.count(b'\r\n') == 50
entry = read(ENTRY)
verify(ENTRY, static['source_inputs'][str(ENTRY)]['sha256'])
for key in ('source_exe', 'source_dll'):
    verify(Path(manifest[key]), manifest[key + '_sha256'])
assert all(manifest[key] is False for key in
           ('integrated', 'complete', 'rust_compiled', 'provider_complete', 'dll_attached'))

suite = read(NATIVE / 'adapter_checks.json')
assert suite['passed'] is True
assert len(suite['runs']) == 13
assert suite['checks'] == sum(row['checks'] for row in suite['runs']) == 300
verify(NATIVE / 'run_checks.py', suite['generator_sha256'])
for row in suite['runs']:
    verify(NATIVE / row['report'], row['report_sha256'])
    report = read(NATIVE / row['report'])
    assert row['passed'] is True and row['exit_code'] == 0 and report['passed'] is True
    assert row['checks'] == report.get('check_count', len(report.get('checks', [])))
    assert manifest['tests'][row['report']] == row['checks']
    for name, expected in report.get('source_hashes', {}).items():
        path = Path(name)
        verify(path if path.is_absolute() else NATIVE / path, expected)
assert manifest['test_checks'] == 300
assert manifest['static_adapter_checks'] == 287
assert manifest['windows_x86_leaf_checks'] == 13
assert manifest['windows_x86_leaf_profiles'] == 3
assert len(read(NATIVE / 'native_slist_tests.json')['cases']) == 3

expected_tables = {}
for kind, table_name in [('C', 'c_error_initializers'), ('C++', 'cpp_initializers')]:
    expected_tables[kind] = [(int(row['slot'], 16), int(row['target'], 16))
                            for row in entry['initializer_tables'][table_name]['entries']
                            if int(row['target'], 16)]
assert [len(expected_tables[k]) for k in ('C', 'C++')] == [5, 68]
profile_results = []
for row in manifest['oracles']:
    verify(NATIVE / row['file'], row['sha256'])
    oracle = read(NATIVE / row['file'])
    assert oracle['generator_hashes'] == manifest['common_generator_hashes']
    for name, expected in oracle['generator_hashes'].items():
        verify(NATIVE / name, expected)
    assert oracle['stop']['kind'] == 'unimplemented_import'
    assert oracle['stop']['import']['name'] == 'HeapReAlloc'
    assert oracle['stop']['args'][:2] == [0x71000000, 0]
    assert oracle['stop']['args'][3] == 256
    old_pointer = oracle['stop']['args'][2]
    old_allocation = [e for e in oracle['crt_events']
                      if e['api'] == 'HeapAlloc' and e['result'] == old_pointer]
    assert len(old_allocation) == 1 and old_allocation[0]['size'] == 128
    assert not any(e['api'] == 'HeapReAlloc' for e in oracle['crt_events'])
    assert oracle['rads_module']['state'] == 'attaching'
    assert [e['operation'] for e in oracle['rads_module']['events']] == ['map', 'begin_native_attach']
    assert all(oracle[key] is False for key in ('passed', 'complete', 'provider_returned', 'completed_path'))
    assert [(v['stage'], v['eax']) for v in oracle['dll_crt_returns']] == [
        ('low_io100FB602', 0), ('argv100FF3FC', 0), ('environment_table100FF62B', 0)]
    for kind, count, returned in [('C', 5, 5), ('C++', 46, 45)]:
        calls = [v for v in oracle['dll_initializer_calls'] if v['kind'] == kind]
        assert len(calls) == count and sum(v['returned'] for v in calls) == returned
        assert [(v['slot'], v['target']) for v in calls] == expected_tables[kind][:count]
        assert all(v['returned'] for v in calls[:returned])
        if kind == 'C':
            assert all(v['eax_after'] == 0 for v in calls)
    state = oracle['dll_process_state']
    profile = oracle['process_profile_at_end']
    expected_path = oracle['virtual_cwd'] + '\\League of Legends.exe'
    assert state['argc'] == 1 and state['argv_sentinel'] == 0
    assert state['argv_values_hex'] == [(expected_path.encode('ascii') + b'\0').hex()]
    assert profile['value'] == '"' + expected_path + '"'
    assert digest((profile['value'] + '\0').encode('ascii')) == profile['sha256']
    assert state['commandline_pointer'] == profile['pointer'] == 0x3b000000
    assert state['argv'] != profile['pointer'] and profile['memory_unchanged'] is True
    assert profile['host_argv_imported'] is False and profile['host_environment_imported'] is False
    assert profile['closed'] is False and oracle['process_profile_retired'] is True
    assert state['environment_acp_block'] == 0 and state['environment_initialized'] == 1
    assert state['lowio_records'] == 32 and state['attach_counter'] == 0
    expected_env = [] if row['profile'] == 'empty' else [
        'OL_PROFILE=resource_probe', 'OL_VALUE=caf\u00e9', 'OL_EMPTY=']
    assert state['environment_values_hex'] == [(v.encode('cp1252') + b'\0').hex() for v in expected_env]
    declared = ('\0'.join(expected_env) + '\0\0').encode('utf-16le')
    assert profile['declared_environment_utf16_hex'] == declared.hex()
    assert profile['environment_live_allocations'] == 0
    assert [e['api'] for e in profile['environment_events']] == ['GetEnvironmentStringsW', 'FreeEnvironmentStringsW']
    assert profile['environment_events'][1]['result'] == 1
    assert profile['environment_events'][0]['pointer'] == profile['environment_events'][1]['pointer']
    converter = oracle['environment_native_observations'][-1]
    expected_acp = b'\0' if not expected_env else ('\0'.join(expected_env) + '\0\0').encode('cp1252')
    assert converter['stage'] == 'converter_return' and converter['converted_bytes'] == len(expected_acp)
    assert converter['hex'] == expected_acp.hex()
    assert oracle['sync_handles_at_stop'] == {} and oracle['sync_events'] == []
    assert oracle['cleanup_passed'] is True
    assert not any(oracle['crt_host_backing_after_cleanup'].values())
    assert not any(oracle[k] for k in ('open_host_handles_after_cleanup', 'diagnostic_pipe_handles_after_cleanup',
                                     'sync_handles_after_cleanup', 'sync_cleanup_errors',
                                     'unstarted_callbacks_at_end', 'interrupted_callbacks'))
    assert oracle['emulated_live_count_after_host_cleanup'] == row['emulated_remaining']
    addresses = oracle['executed_instruction_addresses']
    assert addresses == sorted(set(addresses))
    assert len(addresses) == row['native_addresses_before_cleanup']
    assert sum(0x10000000 <= a < 0x101ac000 for a in addresses) == row['dll_addresses_before_cleanup']
    ini = oracle['ini_observations']
    assert any(v['stage'] == 'entry' for v in ini) and not any(v['stage'] == 'return' for v in ini)
    before = oracle['crt_before_host_cleanup']
    profile_results.append({
        'profile': row['profile'], 'report_sha256': row['sha256'],
        'manifest_facts_match': True, 'original_initializer_table_prefix_matches': True,
        'argc': 1, 'native_environment_entries': len(expected_env),
        'native_converted_acp_bytes': len(expected_acp),
        'before_cleanup': {'distinct_addresses': len(addresses),
            'dll_addresses': row['dll_addresses_before_cleanup'], 'fls_slots': before['slots'],
            'crt_locks': before['locks'], 'crt_heap_blocks': before['heap_blocks'],
            'nonzero_native_lock_depths': {k:v for k,v in before['lock_depths'].items() if v}},
        'host_hygiene_remaining': oracle['crt_host_backing_after_cleanup'],
        'emulated_blocks_without_native_teardown': oracle['emulated_live_count_after_host_cleanup'],
    })

review = {
    'schema': 1, 'kind': 'independent_read_only_source_and_evidence_review',
    'native_execution_by_reviewer': False, 'adapter_execution_by_reviewer': False,
    'tests_reexecuted_by_reviewer': False, 'production_modified': False,
    'frozen_native_manifest_sha256': EXPECTED_NATIVE,
    'static_review_manifest_sha256': EXPECTED_STATIC,
    'evidence_consistency_passed': True, 'unresolved_concrete_defects': [],
    'profiles': profile_results,
    'separate_suite': {'recorded_checks': 300, 'static_or_adapter_checks': 287,
        'native_windows_leaf_checks': 13, 'native_windows_leaf_profiles': 3,
        'game_tests_added': 0, 'sync_checks': 15, 'sync_reached_by_native_profiles': False},
    'resolved_reporting_issues': [
        {'issue': 'README controlled DLL count was 5510; corrected to 5514 before author freeze.',
         'evidence': 'Distinct address filter of final controlled JSON inside [0x10000000,0x101AC000).'},
        {'issue': 'Earlier static audit SHA announcement hashed LF payload, not physical CRLF file.',
         'physical_sha256': EXPECTED_STATIC, 'physical_bytes': len(static_raw), 'crlf_count': 50,
         'earlier_lf_payload_sha256': EARLIER_LF_SHA, 'lf_bytes': len(static_raw.replace(b'\r\n', b'\n')),
         'frozen_package_modified_for_correction': False}],
    'source_review_conclusions': [
        'Process-profile command line has a distinct stable readonly owner; native argv/environment are built by original CRT instructions.',
        'GetThreadTimes preserves output alias topology; GetCurrentThread exposes the borrowed -2 pseudo-handle without ownership.',
        'HeapSize requires exact owned allocation bases and stops before returning capacity beyond the guest mirror.',
        'Sync creation reserves ownership before real acquisition and removes owners only after successful CloseHandle.',
        'The SList helper validates pinned x86 OS images and executes only their exact 19-byte leaf, not host64 structure layout.',
        'LoadLibrary handle publication still requires real successful DLL entry return; neither final profile reaches publication.',
        'Host cleanup is explicitly separate from native detach, provider retirement, static destructors and CRT teardown.'],
    'limits': [
        'Read-only consistency/source review; no independent reproduction of any native/adapter execution.',
        'Only 5 C and first 45 of 68 C++ initializers returned; 46th C++ is interrupted at actual unimplemented HeapReAlloc.',
        'HeapReAlloc, DLL attach/detach, RadsSetLogger, RadsInitialize and the entered INI/provider return remain unqualified.',
        '15 isolated synchronization checks do not prove that native constructors reached events or semaphores.',
        'Valid-owner CloseHandle failure and native wrapper allocation failure were not executed.',
        'Terminal host hygiene leaves 959/962 emulated allocations without native ownership retirement.',
        'The original filesystem confinement limitations and absence of hostile concurrent mutations remain.',
        'Distinct address counts are before cleanup; no new aggregate after-cleanup execution count is inferred.',
        'Source review is bounded to changed adapters, process ownership, observers, handle publication and cleanup; no whole-game completion claim.'],
    'verified_files': verified,
}
write_new('REVIEW.json', review)
files = {p.name: {'bytes': p.stat().st_size, 'sha256': digest(p.read_bytes())}
         for p in sorted(OUT.iterdir()) if p.is_file() and p.name != 'manifest.json'}
final = {'schema': 1, 'kind': 'read_only_review_only', 'native_execution': False,
         'production_modified': False, 'reviewed_native_manifest_sha256': EXPECTED_NATIVE,
         'reviewed_static_manifest_sha256': EXPECTED_STATIC, 'files': files}
meta = write_new('manifest.json', final)
print(json.dumps({'review_passed': True, 'verified_files': len(verified),
                  'manifest_sha256': meta['sha256'], 'manifest_bytes': meta['bytes']}))
