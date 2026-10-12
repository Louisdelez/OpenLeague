from pathlib import Path
import difflib
import hashlib
import json
import re

ROOT = Path(__file__).resolve().parent
PRODUCTION = Path(r'E:\OpenLeague\crates\core\src')
BASELINE = json.loads((ROOT / 'baseline.json').read_text(encoding='utf-8-sig'))
FIXTURE = ROOT / 'loading_standard_empty_name_probe.json'
oracle = json.loads(FIXTURE.read_text(encoding='utf-8'))
assert oracle['passed'] is True
assert len(oracle['cases']) == 16
calls = 0
caller_events = 0
for case in oracle['cases']:
    assert [s['flags'] for s in case['steps']] == [0, 1, 128, 255]
    for step in case['steps']:
        record = step['record']
        scratch = step['temporary_string']
        before = bytes.fromhex(step['record_before_hex'])
        after = bytes.fromhex(step['record_after_hex'])
        payload = bytes.fromhex(step['payload_hex'])
        expected = bytearray(before)
        expected[:25] = payload
        if payload[24] & 1:
            expected[16:20] = bytes(4)
        assert bytes(expected) == after
        assert len(after) == 120 and len(payload) == 25
        returned = next(e for e in step['events'] if e['op'] == 'provider_return')
        assert returned['hex'] == step['temporary_string_hex']
        string = bytes.fromhex(returned['hex'])
        assert len(string) == 24
        assert int.from_bytes(string[16:20], 'little') == 0
        assert int.from_bytes(string[20:24], 'little') == 15
        assert step['reference_counts_before'] == [1, 1]
        assert step['reference_counts_after'] == [1, 1]
        caller = False
        trace = []
        for e in step['events']:
            if e['op'] in ('record_ready', 'provider_return'):
                caller = True
            elif e['op'] == 'call' and e['method'] == 0x72ad90:
                caller = False
            if caller and e['op'] in ('read', 'write'):
                p = e['pointer']
                if record <= p < record + 120:
                    trace.append((e['op'], 'record', p - record, e['bytes'], e['value']))
                elif scratch <= p < scratch + 24:
                    trace.append((e['op'], 'scratch', p - scratch, e['bytes'], e['value']))
        expected_trace = [('write', 'record', offset, 4, int.from_bytes(payload[offset:offset+4], 'little'))
                          for offset in range(0, 24, 4)]
        expected_trace += [('write', 'record', 24, 1, payload[24]), ('read', 'record', 24, 1, payload[24])]
        if payload[24] & 1:
            expected_trace += [('write', 'record', 16, 4, 0)]
        expected_trace += [('read', 'record', 64, 4, 0), ('read', 'scratch', 16, 4, 0), ('read', 'scratch', 20, 4, 15)]
        assert trace == expected_trace
        caller_events += len(trace)
        calls += 1
assert calls == 64

files = []
patch = []
for old in BASELINE:
    current = PRODUCTION / old['file']
    assert hashlib.sha256(current.read_bytes()).hexdigest() == old['sha256'], f'Production changed: {current}'
    candidate = ROOT / old['file']
    before = current.read_text(encoding='utf-8').splitlines(keepends=True)
    after = candidate.read_text(encoding='utf-8').splitlines(keepends=True)
    patch.extend(difflib.unified_diff(before, after,
        fromfile='a/crates/core/src/' + old['file'], tofile='b/crates/core/src/' + old['file']))
    files.append({'file': old['file'], 'bytes': candidate.stat().st_size,
                  'sha256': hashlib.sha256(candidate.read_bytes()).hexdigest(),
                  'baseline_sha256': old['sha256']})
(ROOT / 'changes.patch').write_text(''.join(patch), encoding='utf-8', newline='\n')
tests = {}
for name in ['audio_loading_screen_packet_tests.rs', 'audio_replay_windows_loading_packets_tests.rs']:
    tests[name] = re.findall(r'#\[test\]\s*fn\s+(\w+)', (ROOT / name).read_text(encoding='utf-8'))
assert list(map(len, tests.values())) == [6, 4]
manifest = {
    'status': 'candidate_prepared_not_compiled_not_integrated',
    'production_modified': False, 'compilers_run': False, 'rust_tests_run': False,
    'native_execution_reused_only': True,
    'oracle': {'file': FIXTURE.name, 'source': r'E:\mapslol3v3\loading_standard_empty_agent\standard_empty_name_probe.json',
               'production_destination': r'E:\OpenLeague\data\4.20\loading_standard_empty_name_probe.json',
               'bytes': FIXTURE.stat().st_size, 'sha256': hashlib.sha256(FIXTURE.read_bytes()).hexdigest(),
               'native_sha256': oracle['native_sha256'], 'lifetimes': 16, 'calls': calls},
    'stage_checks_executed': {'fixture_schema_and_record_bytes': True,
        'normalized_caller_trace_projection': True, 'caller_events': caller_events,
        'production_baseline_unchanged': True, 'native_provider_return_string_preserved': True},
    'candidate_tests': tests,
    'files': files,
    'limitations': ['No Rust compilation or test execution in this stage',
        'Generic test uses explicit provider output replay; Windows test exercises real provider',
        'Diagnostic recipients and explicit real index setup do not qualify normal factories/startup',
        'Nonempty standard UI remains an explicit error; no UI, clock or resource fallback']
}
(ROOT / 'candidate_manifest.json').write_text(json.dumps(manifest, indent=2) + '\n', encoding='utf-8')
print(json.dumps({'status':manifest['status'], 'calls':calls, 'caller_events':caller_events,
                  'candidate_generic_tests':6, 'candidate_windows_tests':4,
                  'manifest_sha256':hashlib.sha256((ROOT/'candidate_manifest.json').read_bytes()).hexdigest()}))
