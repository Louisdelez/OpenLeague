"""Scratch native audit only; executes original metadata setters and containers."""
from pathlib import Path
import json
import sys

ROOT = Path('E:/OpenLeague')
exec(compile((ROOT / 'tools/probe_replay_metadata.py').read_text().split('\ncases=[]')[0], 'metadata audit prerequisites', 'exec'))
assert digest == '402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'


def tree_rows(offset, strings):
    head = read32(metadata + offset)
    result, visited = [], set()
    def walk(node):
        if u.mem_read(node + 13, 1)[0]:
            return
        assert node not in visited
        visited.add(node)
        walk(read32(node))
        item = {'pointer': node, 'links': [read32(node + i) for i in [0, 4, 8]],
                'color': u.mem_read(node + 12, 1)[0], 'key': read32(node + 16)}
        if strings:
            length, capacity = read32(node + 40), read32(node + 44)
            raw = read32(node + 24) if capacity >= 16 else node + 24
            item.update(index=read32(node + 20), length=length, capacity=capacity,
                        string_hex=bytes(u.mem_read(raw, length)).hex())
            if offset == 8:
                item['extra'] = read32(node + 48)
        else:
            item['value'] = read32(node + 20)
        result.append(item)
        walk(read32(node + 8))
    walk(read32(head + 4))
    assert len(result) == read32(metadata + offset + 4)
    return result


def state():
    captured = capture()
    return {'snapshot': captured, 'counts': [read32(metadata + o) for o in [0x1a0, 0x1a4, 0x1a8, 0x1ac]],
            'map56': tree_rows(8, True), 'map48': tree_rows(16, True), 'map24': tree_rows(24, False)}


cases = []
try:
    for fill in [0, 165]:
        poison = fill
        cursor = arena
        allocations.clear()
        freed.clear()
        live = {}
        metadata = 0
        metadata_events.clear()
        write32(0x14bef40, 0)
        write32(0x14bef58, 0)
        manager = call(0x9933e0, 0, [68])
        call(0x728e20, manager, [])
        call(0x728fd0, manager, [])
        initial = state()
        write32(metadata + 0x1a8, 0x11223344)
        write32(metadata + 0x1ac, 0x55667788)
        scalar = []
        for selector in [0, 99, 100, 200, 201, 0xffffffff]:
            for value in [0, 1, 24, 48, 49, 0xffffffff]:
                result = call(0x728150, metadata, [selector, value]) & 255
                getters = {str(flag): call(0x7281c0, metadata, [selector, flag]) for flag in [0, 1, 256, 257, 0xffffffff]}
                captured = capture()
                expected = int(selector in [100, 200] and value <= 48)
                assert result == expected
                assert [event['op'] for event in captured['lock_events']] == ([] if value > 48 else ['enter', 'leave'])
                assert getters['0'] == getters['256'] and getters['1'] == getters['257'] == getters['4294967295']
                scalar.append({'selector': selector, 'value': value, 'returned_low_byte': result,
                               'getters': getters, 'lock_events': captured['lock_events'],
                               'counts': [read32(metadata + o) for o in [0x1a0, 0x1a4, 0x1a8, 0x1ac]]})
        # No update_metadata frame copy is requested with these independent count tests.
        string, text = heap + 0xc000, heap + 0xd000
        u.mem_write(string, bytes([fill]) * 24)
        write32(string + 16, 0)
        write32(string + 20, 15)
        u.mem_write(string, b'\0')
        keys = [(5, 0), (1, 0), (9, 0xffffffff), (5, 0xffffffff), (5, 1), (0xffffffff, 0),
                (0, 0x80000000), (0, 0x7fffffff), (2, 0), (8, 0), (3, 0), (7, 0)]
        strings = [b'', b'A', b'B' * 15, b'C' * 16, b'D' * 31, b'E' * 64, b'a\0embedded\0tail']
        steps = []
        for index, (key, second) in enumerate(keys + [(5, 0)] * 4):
            value = strings[index % len(strings)]
            if index >= len(keys):
                value = [b'short', b'long replacement' * 4, b'a\0b', b''][index - len(keys)]
            u.mem_write(text, value + b'\0')
            call(0x564c20, string, [text, len(value)])
            for function, arguments, map_key in [
                (0x7285b0, [key, second, string, 0x13570000 + index], 'map56'),
                (0x728830, [key, second, string], 'map48'),
            ]:
                call(function, metadata, arguments)
                captured = state()
                found = next(row for row in captured[map_key] if row['key'] == key and row['index'] == second)
                expected = value if map_key == 'map56' else value.split(b'\0')[0]
                assert bytes.fromhex(found['string_hex']) == expected
                assert [event['op'] for event in captured['snapshot']['lock_events']] == ['enter', 'leave']
                steps.append({'function': function, 'key': key, 'index': second, 'input_hex': value.hex(), 'state': captured})
        call(0x564900, string, [])
        capture()
        for key in [5, 1, 9, 3, 7, 0xffffffff, 0, 0x80000000, 2, 8, 5, 0xffffffff]:
            before = read32(metadata + 28)
            returned_slot = call(0x728a60, metadata, [key])
            captured = state()
            assert captured['snapshot']['lock_events'] == []
            node = next(row for row in captured['map24'] if row['key'] == key)
            assert node['value'] == 2 and returned_slot == node['pointer'] + 20
            steps.append({'function': 0x728a60, 'key': key, 'returned_slot': returned_slot,
                          'count_before': before, 'state': captured})
        call(0x728a40, metadata, [5])
        call(0x728a60, metadata, [5])
        changed = state()
        assert next(row for row in changed['map24'] if row['key'] == 5)['value'] == 2
        call(0x728ea0, manager, [1])
        shutdown = capture()
        assert not live
        cases.append({'fill': fill, 'manager': manager, 'metadata': metadata, 'initial': initial,
                      'scalar_steps': scalar, 'container_steps': steps, 'mark1_then2': changed, 'shutdown': shutdown})
    proof = {'passed': True, 'complete': False, 'native_sha256': digest, 'cases': cases,
             'limits': ['Original native methods and tree/string helpers execute. Existing allocator, byte-copy and single-thread lock primitives are supplied.',
                        'Two full parent lifetimes,72 scalar setter calls plus360 getter calls,64 text-map writes and24 mark2 calls plus two mark1-then2 overwrites. No Rust setter port or Windows event delivery is claimed.',
                        'OOM/custom allocators, count-driven frame-copy overflow, concurrent mutation and aliasing an incoming string into a node being erased are not exercised.']}
except Exception as error:
    import traceback
    traceback.print_exc()
    proof = {'passed': False, 'native_sha256': digest, 'error': repr(error), 'cases_completed': len(cases),
             'pc': hex(u.reg_read(UC_X86_REG_EIP)), 'calls': call_trail[-20:]}
Path(sys.argv[1]).write_text(json.dumps(proof, indent=2) + '\n', encoding='utf-8')
print(json.dumps({key: value for key, value in proof.items() if key not in ['cases', 'limits']}))
if not proof['passed']:
    sys.exit(1)
