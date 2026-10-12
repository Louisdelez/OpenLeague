"""Prepare scratch metadata count port and lossless scalar oracle projection."""
from pathlib import Path
import difflib
import hashlib
import json

HERE = Path(__file__).resolve().parent
CORE = Path('E:/OpenLeague/crates/core/src')
ORACLE = Path('E:/mapslol3v3/replay_manager_agent/replay_metadata_setters_audit.json')
original = (CORE / 'audio_replay_metadata.rs').read_text(encoding='utf-8')
addition = (HERE / 'count_functions.rs').read_text(encoding='utf-8')
needle = '///5C65C0 visits right subtree, then current string/node, then left subtree.'
assert original.count(needle) == 1
updated = original.replace(needle, addition + '\n' + needle)
(HERE / 'audio_replay_metadata.rs').write_text(updated, encoding='utf-8')
original_tests = (CORE / 'audio_replay_metadata_tests.rs').read_text(encoding='utf-8')
updated_tests = original_tests.rstrip() + '\n\n' + (HERE / 'count_tests.rs').read_text(encoding='utf-8')
(HERE / 'audio_replay_metadata_tests.rs').write_text(updated_tests, encoding='utf-8')
patch = ''
for name, before, after in [('audio_replay_metadata.rs', original, updated), ('audio_replay_metadata_tests.rs', original_tests, updated_tests)]:
    patch += ''.join(difflib.unified_diff(before.splitlines(True), after.splitlines(True),
                                        fromfile='a/crates/core/src/' + name, tofile='b/crates/core/src/' + name))
(HERE / 'metadata_count.patch').write_text(patch, encoding='utf-8')
native = json.loads(ORACLE.read_text(encoding='utf-8'))
assert native['passed'] is True
cases = []
for case in native['cases']:
    pointer = case['metadata']
    block = next(b for b in case['initial']['snapshot']['blocks'] if b['pointer'] == pointer)
    assert block['bytes'] == 512
    # The audit explicitly seeds these two independent counters before its loop.
    # Its first unknown-id setter is a no-op and captures their seeded values.
    assert case['scalar_steps'][0]['selector'] == 0 and case['scalar_steps'][0]['value'] == 0
    seed = case['initial']['counts'][:2] + case['scalar_steps'][0]['counts'][2:]
    assert seed == [0, 0, 0x11223344, 0x55667788]
    cases.append({'fill': case['fill'], 'metadata': pointer, 'initial_metadata_hex': block['hex'],
                  'initial_scalar_counts': seed, 'scalar_steps': case['scalar_steps']})
projection = {'passed': native['passed'], 'native_sha256': native['native_sha256'],
              'source_oracle': str(ORACLE), 'source_oracle_sha256': hashlib.sha256(ORACLE.read_bytes()).hexdigest(),
              'projection': 'Exact scalar_steps, metadata initial block, and native pre-loop scalar seed; no regenerated expectations.',
              'cases': cases}
assert sum(len(c['scalar_steps']) for c in cases) == 72
assert sum(len(s['getters']) for c in cases for s in c['scalar_steps']) == 360
(HERE / 'replay_metadata_count_probe.json').write_text(json.dumps(projection, indent=2) + '\n', encoding='utf-8')
print(json.dumps({'prepared': True, 'native_setters': 72, 'native_getters': 360, 'production_modified': False}))
