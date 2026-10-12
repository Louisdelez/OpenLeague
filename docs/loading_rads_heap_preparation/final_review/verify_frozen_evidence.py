"""Read/hash/JSON/static-PE checks only; never imports or executes probe code."""
from pathlib import Path
import collections, hashlib, json, struct, sys

sys.dont_write_bytecode = True
ROOT = Path(r'E:\mapslol3v3\loading_rads_heap_probe')
OUT = Path(__file__).resolve().parent
verified = {}

def read(path):
    path = Path(path)
    raw = path.read_bytes()
    verified[str(path)] = {'bytes': len(raw), 'sha256': hashlib.sha256(raw).hexdigest()}
    return raw

def pin(path, expected):
    raw = read(path)
    assert hashlib.sha256(raw).hexdigest() == expected, str(path)
    return raw

def document(path):
    return json.loads(read(path))

def pe_reader(raw):
    header = struct.unpack_from('<I', raw, 0x3c)[0]
    assert raw[header:header+4] == b'PE\0\0'
    count = struct.unpack_from('<H', raw, header+6)[0]
    optional_size = struct.unpack_from('<H', raw, header+20)[0]
    optional = header+24
    assert struct.unpack_from('<H', raw, optional)[0] == 0x10b
    base = struct.unpack_from('<I', raw, optional+28)[0]
    sections = []
    for index in range(count):
        entry = optional+optional_size+40*index
        virtual_size, rva, raw_size, offset = struct.unpack_from('<IIII', raw, entry+8)
        sections.append((rva, raw_size, offset))
    def at(va, size):
        rva = va-base
        for start, length, offset in sections:
            if start <= rva and rva+size <= start+length:
                result = raw[offset+rva-start:offset+rva-start+size]
                assert len(result) == size
                return result
        raise AssertionError(('PE range outside file-backed section', hex(va), size))
    return at

def main(expected_manifest):
    manifest_path = ROOT/'manifest.json'
    manifest = json.loads(pin(manifest_path, expected_manifest))
    files = manifest['files']
    for name, entry in files.items():
        assert len(pin(ROOT/name, entry['sha256'])) == entry['bytes'], name
    for path, entry in manifest['external_dependencies'].items():
        pin(path, entry['sha256'])
    assert not any(manifest[key] for key in ('integrated', 'complete', 'rust_compiled', 'provider_complete', 'dll_attached'))
    suite = document(ROOT/'adapter_checks.json')
    assert suite['passed'] and len(suite['runs']) == 17
    assert suite['checks'] == sum(x['checks'] for x in suite['runs']) == 1034
    pin(ROOT/'run_checks.py', suite['generator_sha256'])
    for run in suite['runs']:
        report = json.loads(pin(ROOT/run['report'], run['report_sha256']))
        assert run['passed'] and run['exit_code'] == 0 and report['passed']
        count = report['check_count'] if 'check_count' in report else len(report.get('checks', []))
        assert run['checks'] == count
        for field in ('source_hashes', 'source_hashes_after'):
            for name, digest in report.get(field, {}).items():
                pin(ROOT/name, digest)
    strlen = document(ROOT/'native_strlen_tail_tests.json')
    assert strlen['check_count'] == 354 and strlen['completed_original_strlen_invocations'] == 68
    assert strlen['interrupted_original_strlen_invocations'] == 3 and strlen['manual_invocation_context_setups'] == 2
    assert strlen['remaining']['raw_owners'] == strlen['remaining']['mapped_regions'] == 0
    heap = document(ROOT/'heap_mirrors_tests.json')
    assert heap['check_count'] == 245 and heap['real_moves'] == 13 and heap['real_same_address'] == 7
    assert heap['actual_OS_null_realloc_observed'] is False and heap['injected_null_separate'] is True
    abi = document(ROOT/'heap_realloc_x86_tests.json')
    pin(abi['external_finish_source']['path'], abi['external_finish_source']['sha256'])
    assert abi['check_count'] == 23 and abi['sources_unchanged'] and not abi['original_game_code_executed']
    assert abi['synthetic_x86_call_frames'] and abi['actual_heap_calls'] and not abi['simulated_heap_results']
    dll = pin(strlen['source']['path'], strlen['source']['dll_sha256'])
    at = pe_reader(dll)
    assert hashlib.sha256(at(0x100f86d0, 139)).hexdigest() == strlen['source']['sha256']
    def table(begin, end):
        return [(slot, struct.unpack('<I', at(slot, 4))[0]) for slot in range(begin, end, 4)
                if struct.unpack('<I', at(slot, 4))[0]]
    c_table = table(0x1013147c, 0x10131494)
    cpp_table = table(0x10131364, 0x10131478)
    assert len(c_table) == 5 and len(cpp_table) == 68
    facts = {}
    generators = None
    recorded_inputs = None
    for variant, filename, address_count, dll_count, rpm_count, strlen_returns in (
        ('empty', 'rads_provider_oracle.json', 19167, 5536, 2, 3),
        ('controlled', 'rads_provider_controlled_oracle.json', 19254, 5624, 7, 12)):
        report = document(ROOT/filename)
        pin(report['source'], report['source_sha256'])
        if recorded_inputs is None: recorded_inputs = report['verified_input_files']
        assert report['verified_input_files'] == recorded_inputs
        for path, digest in recorded_inputs.items(): pin(path, digest)
        assert report['declared_environment_variant'] == variant
        assert not any(report[key] for key in ('passed', 'complete', 'provider_returned', 'completed_path'))
        assert report['rads_module']['state'] == 'attaching'
        assert [e['operation'] for e in report['rads_module']['events']] == ['map', 'begin_native_attach']
        stop = report['stop']
        assert stop['kind'] == 'unimplemented_import' and stop['import']['name'] == 'GetModuleHandleA'
        module = at(stop['args'][0], 16).split(b'\0', 1)[0]
        assert module == b'kernel32'
        calls = report['dll_initializer_calls']
        c_calls = [x for x in calls if x['kind'] == 'C']
        cpp_calls = [x for x in calls if x['kind'] == 'C++']
        assert [(x['slot'], x['target']) for x in c_calls] == c_table
        assert [(x['slot'], x['target']) for x in cpp_calls] == cpp_table[:51]
        assert all(x['returned'] and x['eax_after'] == 0 for x in c_calls)
        assert [x['returned'] for x in cpp_calls] == [True]*50+[False]
        assert [x['eax'] for x in report['dll_crt_returns']] == [0, 0, 0]
        assert report['dll_process_state']['argc'] == 1 and report['dll_process_state']['argv_sentinel'] == 0
        assert len(report['dll_process_state']['environment_values_hex']) == (0 if variant == 'empty' else 3)
        assert report['dll_process_state']['environment_initialized'] == 1
        profile = report['process_profile_at_end']
        assert not profile['host_argv_imported'] and not profile['host_environment_imported']
        assert profile['memory_unchanged'] and report['process_profile_retired']
        reallocs = [x for x in report['crt_heap_mirror_events'] if x['operation'] == 'HeapReAlloc']
        assert len(reallocs) == 1
        realloc = reallocs[0]
        assert (realloc['old_size'], realloc['size'], realloc['moved']) == (128, 256, True)
        assert realloc['phase'] == 'live' and realloc['result'] == realloc['pointer'] != realloc['old_pointer']
        assert report['cleanup_passed'] and not any(report['crt_host_backing_after_cleanup'].values())
        after = report['crt_heap_mirrors_after_cleanup']
        assert after['raw_owners'] == after['mapped_regions'] == after['live_owners'] == 0 and not after['interrupted']
        assert not report['crt_heap_mirror_cleanup_errors'] and not report['crt_heap_bounds_events']
        assert report['emulated_live_count_after_host_cleanup'] == 928
        tail = report['native_strlen_tail']
        assert tail['unretired_invocations'] == report['strlen_invocations_abandoned_after_cleanup'] == 0
        assert len(tail['physical_reads']) == rpm_count
        assert all(not x['injected'] and x['success'] and 1 <= x['requested'] <= 3 and x['requested'] == x['transferred'] for x in tail['physical_reads'])
        counts = collections.Counter(x['kind'] for x in tail['events'])
        assert counts == {'entry': strlen_returns, 'native_return': strlen_returns, 'bounded_native_read': rpm_count*2}
        windows = {}
        for event in tail['events']:
            if event['kind'] == 'bounded_native_read':
                windows.setdefault(event['invocation'], []).append(event)
        assert len(windows) == rpm_count
        for pair, physical in zip(windows.values(), tail['physical_reads']):
            assert [event['pc'] for event in pair] == [0x100f8700, 0x100f8718]
            assert pair[0]['padding_hex'] == pair[1]['padding_hex'] == physical['bytes_hex']
            assert pair[0]['address'] == pair[1]['address'] and pair[0]['address'] % 4 == 0
            assert b'\0' in bytes.fromhex(pair[0]['valid_hex'])
            assert pair[0]['valid_bytes'] + physical['transferred'] == 4
        addresses = report['executed_instruction_addresses']
        assert len(addresses) == len(set(addresses)) == address_count
        assert sum(0x10000000 <= x < 0x101ac000 for x in addresses) == dll_count
        assert len(report['generator_hashes']) == 12
        if generators is None: generators = report['generator_hashes']
        assert report['generator_hashes'] == generators
        for name, digest in generators.items(): pin(ROOT/name, digest)
        facts[variant] = dict(before_cleanup_distinct_instruction_addresses=address_count,
            dll_distinct_instruction_addresses=dll_count, returned_c=5, returned_cpp=50,
            interrupted_cpp_ordinal=51, stop='GetModuleHandleA(kernel32)',
            real_realloc_old_size=128, real_realloc_new_size=256, real_realloc_moved=True,
            physical_tail_reads=rpm_count, completed_strlen_invocations=strlen_returns,
            crt_raw_and_mirrors_after_cleanup=0, engine_arena_allocations_without_native_teardown=928)
    return dict(schema=1, review_passed=True, unresolved_concrete_defects=[],
        method='Independent read-only delta review plus hashes, JSON assertions and static PE bytes; no probe/test/compiler executed by reviewer.',
        native_manifest_sha256=expected_manifest, archived_native_files=len(files),
        external_dependencies_hashed=len(manifest['external_dependencies']),
        documentary_review='README and NATIVE_STRLEN_TAIL distinguish real partial initialization, isolated checks, injected failures, CRT host cleanup and the surviving engine arena; no contradictory completion claim found.',
        suite=dict(reported_checks=1034, reports=17, strlen_checks=354, slist_checks=13,
                   remaining_adapter_checks=667, synthetic_x86_abi_checks_included=23),
        common_generator_count=12, profiles=facts,
        limits=['Neither native profile completes DLL attachment or returns a provider; no usable UI resource, INI or renderer is claimed.',
                'Host cleanup is separate from normal native shutdown. The 928 surviving engine-arena allocations are not the cleaned CRT mirrors.',
                'Observed x64 host heap padding is not historical x86 allocator parity. EDX depends on the observed DWORD; no transitive register independence is claimed.',
                '1034 checks aggregate isolated reports, not game integration tests. Synthetic ABI/guard snippets and original 19-byte SList/139-byte strlen tests remain distinguished.',
                'Actual OS null realloc was not observed; null/failure phases are separately injected tests.',
                'Review checks stored evidence and final source deltas; it does not independently replay the two native profiles.'],
        verified_files=verified)

if __name__ == '__main__':
    result = main(sys.argv[1])
    (OUT/'REVIEW.json').write_bytes((json.dumps(result, indent=2)+'\n').encode())
    print(json.dumps({'review_passed': True, 'verified_files': len(verified), 'native_files': result['archived_native_files']}))
