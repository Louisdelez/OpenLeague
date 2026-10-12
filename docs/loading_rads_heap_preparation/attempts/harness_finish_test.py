"""Actual synthetic x86 call frames through CrtOs and real Windows realloc.

This verifies the adapter ABI; it does not execute original game instructions.
No heap result is injected. Unknown requests must stop before Windows.
"""
from pathlib import Path
import argparse
import ctypes
import hashlib
import json
import struct
import sys

sys.dont_write_bytecode = True
OUT = Path(__file__).resolve().parent
parser = argparse.ArgumentParser()
parser.add_argument('--source-dir', type=Path, default=OUT)
args = parser.parse_args()
SOURCE = args.source_dir.resolve()
paths = [Path(__file__), SOURCE / 'crt_os.py', SOURCE / 'heap_mirrors.py', SOURCE / 'isolated_io.py']
before = {p.name: hashlib.sha256(p.read_bytes()).hexdigest() for p in paths}
sys.path.insert(0, str(SOURCE))
sys.path.insert(0, 'E:/OpenLeague/tools/pythonlibs')
import unicorn
from unicorn.x86_const import UC_X86_REG_ESP, UC_X86_REG_EAX, UC_X86_REG_EIP
import crt_os as c

assert Path(c.__file__).resolve() == SOURCE / 'crt_os.py'
CODE, STUB, STACK = 0x30000000, 0x30001000, 0x31000800
raw = unicorn.Uc(unicorn.UC_ARCH_X86, unicorn.UC_MODE_32)
raw.mem_map(CODE, 0x2000)
raw.mem_map(STACK & ~0xfff, 0x1000)
raw.mem_write(STUB, b'\xc3')
checks, observations, api_calls, finishes = [], [], [], []
error, cleanup_error = None, None
machine = {'u': raw, 'UC_X86_REG_ESP': UC_X86_REG_ESP}


def read32(address):
    return struct.unpack('<I', machine['u'].mem_read(address, 4))[0]


def write32(address, value):
    machine['u'].mem_write(address, struct.pack('<I', value & 0xffffffff))


def finish(value=None, pop=0):
    u = machine['u']
    sp = u.reg_read(UC_X86_REG_ESP)
    return_pc = read32(sp)
    finishes.append({'value': value, 'pop': pop, 'stack_before': sp, 'return_pc': return_pc})
    if value is not None:
        u.reg_write(UC_X86_REG_EAX, value & 0xffffffff)
    u.reg_write(UC_X86_REG_ESP, sp + 4 + pop)
    u.reg_write(UC_X86_REG_EIP, return_pc)


machine.update(read32=read32, write32=write32, finish=finish)


class IO:
    last_error = 0


crt = c.CrtOs(machine, IO())
actual = c.K


class ObserveActual:
    def __getattr__(self, name):
        return getattr(actual, name)

    def HeapReAlloc(self, heap, flags, pointer, size):
        result = actual.HeapReAlloc(heap, flags, pointer, size)
        last_error = ctypes.get_last_error()
        api_calls.append({'old_raw': pointer, 'new_raw': int(result or 0),
                          'size': size, 'flags': flags, 'last_error': last_error,
                          'injected': False})
        ctypes.set_last_error(last_error)
        return result


def check(name, condition):
    if not condition:
        raise AssertionError(name)
    checks.append(name)


def on_instruction(uc, pc, size, user):
    if pc == STUB:
        check('guest call reaches import stub with four stack arguments',
              uc.reg_read(UC_X86_REG_ESP) == STACK - 20)
        if not crt.dispatch('HeapReAlloc'):
            raise AssertionError('HeapReAlloc dispatch unsupported')


raw.hook_add(unicorn.UC_HOOK_CODE, on_instruction)


def invoke(heap, flags, pointer, size):
    # push size; push pointer; push flags; push heap; call import stub.
    code = b''.join(b'\x68' + struct.pack('<I', v) for v in [size, pointer, flags, heap])
    code += b'\xe8' + struct.pack('<i', STUB - (CODE + 25))
    machine['u'].mem_write(CODE, code + b'\x90')
    raw.ctl_remove_cache(CODE, CODE + 0x1000)
    machine['u'].reg_write(UC_X86_REG_ESP, STACK)
    machine['u'].reg_write(UC_X86_REG_EAX, 0xcccccccc)
    raw.emu_start(CODE, CODE + len(code), count=32)
    return raw.reg_read(UC_X86_REG_EAX)


try:
    c.K = ObserveActual()
    pointer = crt.mirrors.allocate(128, 8)
    for requested in [256, 64]:
        old_pointer = pointer
        owner = crt.mirrors._owner(pointer)
        old_size, old_raw = owner.requested, owner.raw
        pattern = bytes((i * 17 + requested + 9) & 255 for i in range(old_size))
        machine['u'].mem_write(pointer, pattern)
        pointer = invoke(crt.heap_label, 0, pointer, requested)
        row = api_calls[-1]
        check('real Win32 realloc returned nonnull ' + str(requested), bool(row['new_raw']))
        check('x86 return EIP and ESP after stdcall ' + str(requested),
              raw.reg_read(UC_X86_REG_EIP) == CODE + 25 and raw.reg_read(UC_X86_REG_ESP) == STACK)
        check('dispatch returns four-argument pop16 ' + str(requested), finishes[-1]['pop'] == 16)
        check('EAX is the live guest result ' + str(requested),
              pointer in crt.heap_blocks and finishes[-1]['value'] == pointer)
        check('guest pointer identity follows actual Win32 identity ' + str(requested),
              (pointer != old_pointer) == (row['new_raw'] != old_raw))
        check('new guest bytes preserve prior writes ' + str(requested),
              bytes(machine['u'].mem_read(pointer, min(old_size, requested))) == pattern[:min(old_size, requested)])
        check('actual Win32 request matches x86 call frame ' + str(requested),
              row['old_raw'] == old_raw and row['size'] == requested and row['flags'] == 0)
        observations.append({'old_guest': old_pointer, 'new_guest': pointer,
                             'old_size': old_size, 'new_size': requested,
                             'actual': row.copy(), 'finish': finishes[-1].copy()})
    for name, params in [
        ('foreign heap', (crt.heap_label + 4, 0, pointer, 32)),
        ('interior base', (crt.heap_label, 0, pointer + 1, 32)),
        ('unsupported flags', (crt.heap_label, 8, pointer, 32)),
    ]:
        before_calls, before_finishes = len(api_calls), len(finishes)
        try:
            invoke(*params)
        except c.Rejected:
            check(name + ' rejected before OS and return',
                  len(api_calls) == before_calls and len(finishes) == before_finishes)
        else:
            raise AssertionError(name + ' accepted')
    check('rejected requests preserve live allocation', pointer in crt.heap_blocks)
except Exception as caught:
    error = repr(caught)
finally:
    c.K = actual
    try:
        crt.release_host_backing()
    except Exception as caught:
        cleanup_error = repr(caught)
    snapshot = crt.mirrors.snapshot()
    after = {p.name: hashlib.sha256(p.read_bytes()).hexdigest() for p in paths}
    unchanged = before == after
    passed = (error is None and cleanup_error is None and unchanged
              and snapshot['raw_owners'] == 0 and snapshot['mapped_regions'] == 0
              and not snapshot['interrupted'])
    result = {'passed': passed, 'error': error, 'cleanup_error': cleanup_error,
              'check_count': len(checks), 'checks': checks,
              'source_hashes': before, 'source_hashes_after': after, 'sources_unchanged': unchanged,
              'observations': observations, 'remaining': snapshot,
              'original_game_code_executed': False, 'synthetic_x86_call_frames': True,
              'actual_heap_calls': True, 'simulated_heap_results': False}
    (OUT / 'heap_realloc_x86_tests.json').write_bytes((json.dumps(result, indent=2) + '\n').encode())
    print(json.dumps({k: result[k] for k in ['passed', 'check_count', 'error', 'cleanup_error', 'sources_unchanged']}))
if not passed:
    raise SystemExit(1)
