"""Read source PE and completed scratch artifacts; never modify production."""
from pathlib import Path
import collections
import difflib
import hashlib
import json
import re
import pefile

HERE = Path(__file__).resolve().parent
ROOT = Path('E:/OpenLeague')
def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

manifest = json.loads((ROOT / 'data/4.20/runtime/replay_runtime_image_manifest.json').read_text())
source = Path(manifest['native_source'])
raw = source.read_bytes()
digest = hashlib.sha256(raw).hexdigest()
assert digest == '402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
pe = pefile.PE(data=raw)
mapped = pe.get_memory_mapped_image()
regions = []
for address, length, role in [
    (0x64d040, 0x77, 'value_slot'), (0x661f80, 0x29, 'create_node'),
    (0x5d54a0, 0x37, 'allocate_initialize_links'), (0x663240, 0x20a, 'hinted_insert'),
    (0x5da5e0, 0x1b7, 'link_rebalance_capacity'), (0x5da8c0, 0x11f, 'fallback_unique_insert'),
    (0x5ccfe0, 0x5e, 'predecessor'), (0x5c23e0, 0x4f, 'successor'),
    (0x5c64e0, 0x60, 'rotate_left'), (0x5c6540, 0x60, 'rotate_right'),
    (0x728a40, 0x19, 'mark1'), (0x728a60, 0x19, 'mark2'),
]:
    start = address - pe.OPTIONAL_HEADER.ImageBase
    data = mapped[start:start + length]
    assert len(data) == length
    regions.append({'address': address, 'bytes': length, 'role': role,
                    'sha256': hashlib.sha256(data).hexdigest(), 'hex': data.hex()})
(HERE / 'metadata_state_sources.json').write_text(json.dumps({
    'native_source': str(source), 'native_sha256': digest, 'regions': regions,
    'limits': ['Source extraction only; rotation ranges include trailing padding. No image installation.']
}, indent=2) + '\n', encoding='utf-8')

proof = json.loads((HERE / 'replay_metadata_state_probe.json').read_text())
assert proof['passed'] and proof['native_sha256'] == digest
cases = proof['cases']
assert len(cases) == 20
steps = [step for case in cases for step in case['steps']]
functions = collections.Counter(hex(step['function']) for step in steps)
exceptions = collections.Counter(step['error'] for step in steps if 'error' in step)
assert exceptions == {'length_error': 4, 'bad_alloc': 2}
log = (HERE / 'metadata_state_tests.log').read_text(encoding='utf-8-sig')
assert '5 passed; 0 failed; 0 ignored; 0 measured; 8 filtered out' in log
elapsed = float(re.search(r'finished in ([0-9.]+)s', log).group(1))
patch = ''
for name in ['audio_replay_metadata_state.rs', 'audio_replay_metadata_state_tests.rs']:
    patch += ''.join(difflib.unified_diff([], (HERE / name).read_text().splitlines(True),
                                        fromfile='/dev/null', tofile='b/crates/core/src/' + name))
(HERE / 'metadata_state.patch').write_text(patch, encoding='utf-8')
files = ['audio_replay_metadata_state.rs', 'audio_replay_metadata_state_tests.rs', 'metadata_state_harness.rs',
         'metadata_state_harness.exe', 'metadata_state_build.log', 'metadata_state_tests.log',
         'probe_metadata_state.py', 'replay_metadata_state_probe.json', 'metadata_state_native.log',
         'metadata_state_sources.json', 'tree24_disassembly.txt', 'tree24_dependencies_disassembly.txt',
         'tree24_successor_disassembly.txt', 'metadata_state.patch']
receipt = {
    'passed': True, 'complete': False, 'production_modified': False,
    'native_sha256': digest, 'native_lifetimes': len(cases), 'native_operation_count': len(steps),
    'native_operation_counts': dict(functions), 'native_iterator_calls': sum(len(c['iterators']) for c in cases),
    'native_exception_boundaries': dict(exceptions),
    'all_parent_owned_allocations_released': all(c['shutdown']['blocks'] == [] for c in cases),
    'source_region_count': len(regions), 'source_bytes': sum(r['bytes'] for r in regions),
    'tests': {'passed': 5, 'failed': 0, 'filtered': 8, 'seconds': elapsed,
              'new_state_tests': 3, 'existing_metadata_regressions': 2},
    'compile_command': ['C:/Users/loicd/.cargo/bin/rustc.exe', '--edition=2024', '--test',
                        str(HERE / 'metadata_state_harness.rs'), '--extern',
                        'serde_json=E:/OpenLeague/target/debug/deps/libserde_json-06e1b1b57f0ae5f7.rlib',
                        '-L', 'dependency=E:/OpenLeague/target/debug/deps', '-o', str(HERE / 'metadata_state_harness.exe')],
    'test_command': [str(HERE / 'metadata_state_harness.exe'), 'audio_replay_metadata', '--nocapture'],
    'hashes': {name: sha(HERE / name) for name in files},
    'limits': proof['limits'] + ['Rust tests compare exact owned block bytes, allocation and free order, custom free callback/context, returned slot/value, and absence of locks. They do not compare every individual memory read/write instruction.',
                               'Search and iterator traversal detect repeated nodes; corrupt parent links during rebalancing and allocator-induced tree/key mutation are not qualified. This isolated harness is not the integrated core suite.'],
}
(HERE / 'metadata_state_receipt.json').write_text(json.dumps(receipt, indent=2) + '\n', encoding='utf-8')
print(json.dumps({key: value for key, value in receipt.items() if key not in ['hashes', 'limits', 'compile_command', 'test_command']}))
