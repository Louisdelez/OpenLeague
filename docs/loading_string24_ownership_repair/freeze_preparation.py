"""Verify immutable inputs and freeze this preparation; no compiler or PE execution."""
from pathlib import Path
import hashlib
import json
import sys

ROOT = Path(__file__).resolve().parent
sys.path.insert(0, r'E:\OpenLeague\tools\pythonlibs')
import pefile

def digest(path):
    data = path.read_bytes()
    return {'path': str(path), 'bytes': len(data), 'sha256': hashlib.sha256(data).hexdigest()}

native = Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe')
source = Path(r'E:\mapslol3v3\loading_metadata_stage\loading_metadata_sources.json')
oracle = Path(r'E:\mapslol3v3\loading_standard_ui_next\prefix_native_probe.json')
assert digest(native)['sha256'] == '402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
assert digest(oracle)['sha256'] == 'e321a049a6ef3af573549b578fa7f3f79dc51f302808a4dcbd29b2f061a6d521'
pe = pefile.PE(str(native), fast_load=True)
regions = []
for address, size in [(0x564af0, 288), (0x564f30, 407)]:
    record = next(r for r in json.loads(source.read_text())['regions'] if r['address'] == address)
    expected = bytes.fromhex(record['hex'])
    actual = pe.get_data(address - pe.OPTIONAL_HEADER.ImageBase, size)
    assert len(expected) == size and expected == actual
    assert hashlib.sha256(actual).hexdigest() == record['sha256']
    regions.append({'address': address, 'address_hex': hex(address), 'rva': address-pe.OPTIONAL_HEADER.ImageBase,
                    'bytes': size, 'sha256': record['sha256'], 'matches_native': True})
pe.close()
fixture = json.loads((ROOT/'loading_owned_string_probe.json').read_text())
assert fixture['native_cases'] == len(fixture['cases']) == 128
assert sum(c['assignment_called'] for c in fixture['cases']) == 96
assert {c['fill'] for c in fixture['cases']} == {0,165}
assert fixture['source_sha256'] == digest(oracle)['sha256']
for c in fixture['cases']:
    assert len(bytes.fromhex(c['source_descriptor_hex'])) == 24
    assert len(bytes.fromhex(c['destination_descriptor_hex'])) == 24
    assert len(bytes.fromhex(c['expected_descriptor_hex'])) == 24
    for field in ['source_heap','destination_heap','expected_heap']:
        if c[field] is not None:
            assert len(bytes.fromhex(c[field]['hex'])) == c[field]['bytes']

production = Path(r'E:\OpenLeague\crates\core\src')
observed_files = ['audio_loading_metadata.rs','audio_loading_screen_packet.rs',
                  'audio_replay_windows_loading_packets.rs','audio_replay_windows_transport.rs',
                  'audio_replay_windows_events.rs','audio_announcer_registry_init.rs',
                  'audio_replay_metadata.rs','audio_announcer_registry_remove.rs']
files = ['audio_loading_owned_string.rs','audio_loading_owned_string_tests.rs',
         'loading_owned_string_probe.json','prepare_fixture.py','README.md',
         'CALLER_INTEGRATION.md','freeze_preparation.py']
manifest = {
    'status': 'frozen_preparation_not_compiled_not_integrated',
    'production_modified': False, 'frozen_prior_stages_modified': False,
    'compiler_executed': False, 'rust_tests_executed': False,
    'new_native_execution': False,
    'native_source': digest(native), 'native_region_source': digest(source), 'regions': regions,
    'original_native_oracle': digest(oracle),
    'checks_actually_executed': [
        'Python fixture derivation after frozen native-oracle SHA check',
        'Full source PE SHA and both source regions compared byte-for-byte',
        'Derived fixture count, poison values, descriptor and heap sizes checked',
        'Static ownership review, including independent review by replay_path_registry',
    ],
    'native_success_evidence': {'original_lifetimes':128,'actual_assignments':96,'empty_override_skips':32,
                              'new_execution':False,'rust_comparison_executed':False},
    'proposed_tests': {'count':4,'executed':0,'post_old_free_write_fault_profiles':16,
                      'other_fault_scenarios':['primary plus cleanup error and explicit retry',
                                               'copy failure before old free','atomic old-free error']},
    'windows_reachability': 'Generic fallible-boundary defect; no demonstrated normal Windows failure for valid exclusive storage in a healthy bank. Returned atomic release contract excludes panic/OOM.',
    'integration_blockers': [
        'Candidate module and tests have not compiled or run',
        'Consumer must pass mutable ownership guard and preserve typed Failure',
        'Runtime must preserve scratch lease plus remaining guard before string-only error conversion',
        'Deferred retirement owner/slot must be reserved before the operation and qualified',
    ],
    'source_order': {'old_free_before_publish':True,'detached_switch_before_fallible_write':True,
                     'final_capacity_read_before_length_write':True,
                     'native_exception_unwind_claimed':False},
    'production_read_snapshot': [digest(production/f) for f in observed_files],
    'files': [digest(ROOT/f) for f in files],
}
target=ROOT/'preparation_manifest.json'
target.write_text(json.dumps(manifest,indent=2)+'\n')
print(json.dumps({'manifest':digest(target),'native_regions_verified':len(regions),
                  'native_bytes_verified':sum(r['bytes'] for r in regions),
                  'fixture_cases':len(fixture['cases']),'rust_tests_executed':0}))
