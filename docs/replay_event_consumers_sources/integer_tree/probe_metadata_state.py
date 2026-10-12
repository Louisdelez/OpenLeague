"""Execute original metadata state-map code, including real RB tree helpers."""
from pathlib import Path
import itertools
import json
import sys
import types

ROOT = Path('E:/OpenLeague')
exec(compile((ROOT / 'tools/probe_replay_metadata.py').read_text().split('\ncases=[]')[0],
             'metadata state prerequisites', 'exec'))
assert digest == '402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
state_original_boundary = types.FunctionType(boundary.__code__, globals())
null_next = False
primitive_events = []
trace_state = []
custom_free = end + 0x2300
custom_context = 0x12344321

class NativeExceptionBoundary(Exception):
    pass

def state_boundary(uc, address, size, user):
    global null_next, cursor
    if address == 0x5d54aa and null_next:
        null_next = False
        # The shared primitive allocator hook runs before this observer. Replace
        # that primitive result before the native allocation check executes.
        supplied = allocations.pop()
        assert supplied['bytes'] == 24
        cursor = supplied['pointer']
        primitive_events.append({'op': 'null_allocate', 'bytes': 24})
        u.reg_write(UC_X86_REG_EAX, 0)
    if address == custom_free:
        sp = u.reg_read(UC_X86_REG_ESP)
        pointer, context = read32(sp + 4), read32(sp + 8)
        assert context == custom_context
        primitive_events.append({'op': 'custom_free', 'callback': custom_free, 'pointer': pointer, 'context': context})
        freed.append(pointer)
        finish()
        return
    if address in [0xce0b9f, 0xce0c22]:
        # Stop at the genuine throwing boundary, never synthesize a return.
        raise NativeExceptionBoundary('bad_alloc' if address == 0xce0b9f else 'length_error')
    return state_original_boundary(uc, address, size, user)

boundary.__code__ = state_boundary.__code__

def observe_helpers(uc, address, size, user):
    if address in [0x64d040, 0x661f80, 0x5d54a0, 0x663240, 0x5da5e0, 0x5ccfe0,
                   0x5da8c0, 0x5c23e0, 0x5c64e0, 0x5c6540, 0x5da695, 0x5da71f]:
        trace_state.append(address)

u.hook_add(unicorn.UC_HOOK_CODE, observe_helpers)

def state_snapshot():
    observed = capture()
    observed['primitives'] = list(primitive_events)
    primitive_events.clear()
    observed['helpers'] = list(trace_state)
    trace_state.clear()
    return observed

def invoke(function, key):
    if function == 0x64d040:
        write32(heap + 0xe000, key)
        return call(function, metadata + 0x18, [heap + 0xe000])
    return call(function, metadata, [key])

sequences = {
    'ascending': list(range(24)),
    'descending': list(reversed(range(24))),
    'zigzag_left': [30, 10, 20, 5, 15, 12, 14, 13, 40, 35, 37, 36],
    'zigzag_right': [10, 30, 20, 35, 25, 28, 26, 27, 0, 5, 3, 4],
    'unsigned_limits': [0xffffffff, 0, 0x80000000, 0x7fffffff, 1, 0xfffffffe, 0x80000001,
                        0x7ffffffe, 0, 0xffffffff, 0x80000000, 1],
    'repeated': [42] * 9 + [0, 0xffffffff, 42, 0, 0xffffffff],
    'capacity': [11],
    'capacity_custom_free': [11],
    'null_allocation': [11],
    'hint_dependencies': [20, 10, 30, 5, 15, 25, 35],
}
cases = []
try:
    for fill, (profile, keys) in itertools.product([0, 165], sequences.items()):
        poison = fill
        cursor = arena
        allocations.clear()
        freed.clear()
        live = {}
        metadata = 0
        metadata_events.clear()
        primitive_events.clear()
        trace_state.clear()
        write32(0x14bef40, 0)
        write32(0x14bef58, 0)
        manager = call(0x9933e0, 0, [68])
        call(0x728e20, manager, [])
        call(0x728fd0, manager, [])
        initial = state_snapshot()
        steps = []
        for index, key in enumerate(keys):
            function = [0x64d040, 0x728a40, 0x728a60][index % 3]
            result = invoke(function, key)
            observed = state_snapshot()
            assert observed['lock_events'] == []
            assert read32(result - 4) == key
            expected = {0x728a40: 1, 0x728a60: 2}.get(function)
            if expected is not None:
                assert read32(result) == expected
            steps.append({'function': function, 'key': key, 'slot': result,
                          'value': read32(result), 'snapshot': observed})
        if profile == 'hint_dependencies':
            operations = [(1, 'minimum'), (40, 'head'), (13, 15), (17, 15), (16, 15),
                          (12, 20), (33, 'minimum'), (20, 'head'), (35, 30), (0, 40), (50, 20)]
            for key, hint_kind in operations:
                head = read32(metadata + 0x18)
                if hint_kind == 'head':
                    hint = head
                elif hint_kind == 'minimum':
                    hint = read32(head)
                else:
                    hint = read32(head + 4)
                    while not u.mem_read(hint + 13, 1)[0] and read32(hint + 16) != hint_kind:
                        hint = read32(hint + (0 if hint_kind < read32(hint + 16) else 8))
                    assert not u.mem_read(hint + 13, 1)[0]
                write32(heap + 0xe000, key)
                write32(heap + 0xe004, heap + 0xe000)
                node = call(0x661f80, metadata + 0x18, [heap + 0xe000, heap + 0xe004, 0])
                is_custom = key == 20
                if is_custom:
                    write32(0x14bef40, custom_free)
                    write32(0x14bef44, custom_context)
                output = heap + 0xe008
                assert call(0x663240, metadata + 0x18, [output, hint, node + 16, node]) == output
                result = read32(output) + 20
                observed = state_snapshot()
                steps.append({'function': 0x663240, 'key': key, 'hint': hint, 'slot': result,
                              'value': read32(result), 'custom_free': is_custom,
                              'custom_free_address': custom_free if is_custom else None, 'snapshot': observed})
                write32(0x14bef40, 0)
        if profile.startswith('capacity'):
            write32(metadata + 0x1c, 0xaaaaaa8)
            # A missing key still allocates and links at max_size-1.
            result = invoke(0x728a60, 12)
            observed = state_snapshot()
            assert read32(metadata + 0x1c) == 0xaaaaaa9
            steps.append({'function': 0x728a60, 'key': 12, 'slot': result, 'value': 2,
                          'seed_count': 0xaaaaaa8, 'snapshot': observed})
            # Existing keys bypass allocation/capacity checks entirely.
            result = invoke(0x728a40, 11)
            observed = state_snapshot()
            assert observed['allocations'] == [] and observed['freed'] == []
            steps.append({'function': 0x728a40, 'key': 11, 'slot': result, 'value': 1,
                          'snapshot': observed})
            if profile == 'capacity_custom_free':
                write32(0x14bef40, custom_free)
                write32(0x14bef44, custom_context)
            try:
                invoke(0x728a60, 13)
                raise AssertionError('length_error boundary was not reached')
            except NativeExceptionBoundary as failure:
                assert str(failure) == 'length_error'
            observed = state_snapshot()
            assert len(observed['allocations']) == len(observed['freed']) == 1
            steps.append({'function': 0x728a60, 'key': 13, 'error': 'length_error',
                          'custom_free': profile == 'capacity_custom_free',
                          'custom_free_address': custom_free if profile == 'capacity_custom_free' else None,
                          'snapshot': observed})
            write32(0x14bef40, 0)
        if profile == 'null_allocation':
            null_next = True
            try:
                invoke(0x728a40, 12)
                raise AssertionError('bad_alloc boundary was not reached')
            except NativeExceptionBoundary as failure:
                assert str(failure) == 'bad_alloc'
            observed = state_snapshot()
            assert observed['allocations'] == observed['freed'] == []
            assert observed['primitives'] == [{'op': 'null_allocate', 'bytes': 24}]
            steps.append({'function': 0x728a40, 'key': 12, 'error': 'bad_alloc', 'snapshot': observed})
        # Qualify iterator helpers including header++ (identity), header--,
        # minimum-- and maximum++, without changing the owned tree.
        head = read32(metadata + 0x18)
        iterator_nodes = [head]
        def collect_nodes(node):
            if u.mem_read(node + 13, 1)[0]:
                return
            collect_nodes(read32(node))
            iterator_nodes.append(node)
            collect_nodes(read32(node + 8))
        collect_nodes(read32(head + 4))
        iterator_steps = []
        for node, forward in itertools.product(iterator_nodes, [False, True]):
            output = heap + 0xe010
            write32(output, node)
            function = 0x5c23e0 if forward else 0x5ccfe0
            assert call(function, output, []) == output
            iterator_steps.append({'node': node, 'forward': forward, 'returned': read32(output)})
        iterators_snapshot = state_snapshot()
        # Destruction executes original tree traversal and frees on metadata only.
        control = read32(manager + 0x38)
        call(0x729d20, metadata, [1])
        destroyed = state_snapshot()
        call(0x5d5b40, control, [])
        write32(manager + 0x34, 0)
        write32(manager + 0x38, 0)
        call(0x728ea0, manager, [1])
        shutdown = state_snapshot()
        assert not live
        cases.append({'fill': fill, 'profile': profile, 'metadata': metadata, 'initial': initial,
                      'steps': steps, 'iterators': iterator_steps, 'iterators_snapshot': iterators_snapshot,
                      'destroyed': destroyed, 'shutdown': shutdown})
    helpers = {a for c in cases for s in c['steps'] for a in s['snapshot']['helpers']}
    assert {0x5c64e0, 0x5c6540, 0x5da695, 0x5da71f, 0x5ccfe0, 0x5da8c0, 0x5c23e0} <= helpers
    proof = {'passed': True, 'complete': False, 'native_sha256': digest, 'cases': cases,
             'helper_addresses_executed': sorted(helpers),
             'limits': ['Native64D040/728A40/728A60, allocation construction, hinted insertion, rotations and metadata teardown execute unchanged.',
                        'Only allocation/free and single-thread OS primitives are supplied. Native exceptions stop at CE0B9F/CE0C22; MSVC exception unwinding is not simulated or qualified.',
                        'Capacity tests seed the count near max_size without allocating that many nodes. Concurrent mutation or custom allocator mutation of the tree/key is not covered. No Windows/service/frame delivery is claimed.']}
except Exception as failure:
    import traceback
    traceback.print_exc()
    proof = {'passed': False, 'error': repr(failure), 'cases_completed': len(cases),
             'pc': hex(u.reg_read(UC_X86_REG_EIP)), 'calls': call_trail[-20:]}
Path(sys.argv[1]).write_text(json.dumps(proof, indent=2) + '\n', encoding='utf-8')
print(json.dumps({k: v for k, v in proof.items() if k not in ['cases', 'limits']}))
if not proof['passed']:
    sys.exit(1)
