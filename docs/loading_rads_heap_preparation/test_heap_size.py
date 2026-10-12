"""Real HeapSize and CrtOs guards over owned guest mirrors; no native PE execution."""
from pathlib import Path
import argparse
import ctypes
import hashlib
import json
import sys

sys.dont_write_bytecode = True
OUT = Path(__file__).resolve().parent
parser = argparse.ArgumentParser()
parser.add_argument('--implementation-dir', type=Path, default=OUT)
options = parser.parse_args()
SOURCE = options.implementation_dir.resolve()
sys.path.insert(0, str(SOURCE))
sys.path.insert(0, r'E:\OpenLeague\tools\pythonlibs')
import unicorn
from unicorn.x86_const import UC_X86_REG_ESP
import crt_os as c

u = unicorn.Uc(unicorn.UC_ARCH_X86, unicorn.UC_MODE_32)
u.mem_map(0x30000000, 0x1000)
u.reg_write(UC_X86_REG_ESP, 0x30000000)
params, returns, checks, legacy_calls = [], [], [], []


def legacy(name):
    def fail(*args):
        legacy_calls.append((name, args))
        raise AssertionError('legacy emulated allocator unexpectedly used: ' + name)
    return fail


class IO:
    last_error = 0


machine = dict(u=u, UC_X86_REG_ESP=UC_X86_REG_ESP,
               read32=lambda a: params[(a - 0x30000004)//4], write32=lambda *a: None,
               finish=lambda *a: returns.append(a), allocate=legacy('allocate'), release=legacy('release'))
crt = c.CrtOs(machine, IO())
actual = c.K


class TracedHeap:
    def __init__(self):
        self.calls = []

    def __getattr__(self, name):
        if name not in ['HeapAlloc', 'HeapReAlloc', 'HeapFree', 'HeapSize']:
            return getattr(actual, name)

        def invoke(*args):
            result = getattr(actual, name)(*args)
            self.calls.append(dict(api=name, args=list(args), result=int(result or 0),
                                   last_error=ctypes.get_last_error(), injected=False))
            return result
        return invoke


traced = TracedHeap()
error = None
cleanup_error = None


def check(name, value):
    assert value, name
    checks.append(name)


def call(name, *args):
    params[:] = args
    before = len(returns)
    assert crt.dispatch(name), name
    assert len(returns) == before+1, name + ' returned exactly once'
    return returns[-1]


def reject(name, operation):
    before = len(traced.calls)
    old_returns = len(returns)
    old_owners = (crt.heap_blocks, crt.heap_sizes, crt.unadopted_heap_blocks, crt.mirrors.snapshot())
    try:
        operation()
    except c.Rejected:
        check(name, len(traced.calls) == before and len(returns) == old_returns
              and old_owners == (crt.heap_blocks, crt.heap_sizes, crt.unadopted_heap_blocks, crt.mirrors.snapshot()))
        return
    raise AssertionError(name)


try:
    c.K = traced
    reject('wrong heap allocation rejected before Win32', lambda: call('HeapAlloc', crt.heap_label+4, 8, 32))
    for size in [1, 4, 128, 544, 2048]:
        pointer, pop = call('HeapAlloc', crt.heap_label, 8, size)
        raw = crt.heap_blocks[pointer]
        direct = actual.HeapSize(crt.heap, 0, raw)
        result = call('HeapSize', crt.heap_label, 0, pointer)
        check('actual HeapSize equals bridge result and fits requested mirror ' + str(size),
              pop == 12 and result == (direct, 12) and direct <= crt.heap_sizes[pointer] == size
              and traced.calls[-1]['api'] == 'HeapSize' and traced.calls[-1]['args'] == [crt.heap, 0, raw])
        check('fresh mirror contains actual zeroed bytes ' + str(size),
              bytes(machine['u'].mem_read(pointer, size)) == ctypes.string_at(raw, size) == bytes(size))
        payload = bytes((j*29+7) & 255 for j in range(size))
        machine['u'].mem_write(pointer, payload)
        check('HeapSize leaves guest payload unchanged ' + str(size),
              call('HeapSize', crt.heap_label, 0, pointer) == (direct, 12)
              and bytes(machine['u'].mem_read(pointer, size)) == payload)
        for api in ['HeapSize', 'HeapFree']:
            reject(api + ' wrong heap rejected before Win32 ' + str(size),
                   lambda api=api: call(api, crt.heap_label+4, 0, pointer))
            reject(api + ' nonzero flags rejected before Win32 ' + str(size),
                   lambda api=api: call(api, crt.heap_label, 1, pointer))
            reject(api + ' interior pointer rejected before Win32 ' + str(size),
                   lambda api=api: call(api, crt.heap_label, 0, pointer+1))
        reject('HeapReAlloc wrong heap rejected before Win32 ' + str(size),
               lambda: call('HeapReAlloc', crt.heap_label+4, 0, pointer, size+1))
        reject('read beyond requested mirror rejected even inside mapped page ' + str(size),
               lambda: machine['u'].mem_read(pointer+size, 1))
        check('guard rejections leave payload and raw ownership unchanged ' + str(size),
              crt.heap_blocks[pointer] == raw and bytes(machine['u'].mem_read(pointer, size)) == payload)
        check('actual HeapFree retires owned block ' + str(size), call('HeapFree', crt.heap_label, 0, pointer) == (1, 12))
        for api in ['HeapSize', 'HeapFree']:
            reject(api + ' stale pointer rejected before Win32 ' + str(size),
                   lambda api=api: call(api, crt.heap_label, 0, pointer))
        reject('stale guest read rejected after free ' + str(size), lambda: machine['u'].mem_read(pointer, 1))
    check('all five real blocks and mirrors retired exactly once',
          sum(r['api'] == 'HeapAlloc' for r in traced.calls) == 5
          and sum(r['api'] == 'HeapFree' for r in traced.calls) == 5
          and all(r['result'] == 1 for r in traced.calls if r['api'] == 'HeapFree')
          and not crt.heap_blocks and not crt.heap_sizes and not crt.unadopted_heap_blocks
          and crt.mirrors.snapshot()['raw_owners'] == crt.mirrors.snapshot()['mapped_regions'] == 0)
    check('heap mirrors do not use legacy allocator callbacks', legacy_calls == [])
except Exception as failure:
    error = repr(failure)
finally:
    c.K = actual
    try:
        crt.release_host_backing()
    except Exception as failure:
        cleanup_error = repr(failure)
    remaining = crt.mirrors.snapshot()
    passed = error is None and cleanup_error is None and remaining['raw_owners'] == remaining['mapped_regions'] == 0
    result = dict(passed=passed, error=error, cleanup_error=cleanup_error, checks=checks,
                  check_count=len(checks), events=crt.events, mirror_events=crt.mirrors.events,
                  os_calls=traced.calls, native_pe_execution=False, injected_os_returns=False,
                  remaining=remaining['raw_owners'], remaining_mapped_regions=remaining['mapped_regions'],
                  scope='CrtOs boundary checks using real Windows HeapAlloc/HeapSize/HeapFree and real Unicorn memory. No PE consumer or fake OS result.',
                  source_hashes={p.name: hashlib.sha256(p.read_bytes()).hexdigest()
                                 for p in [Path(__file__), SOURCE/'crt_os.py', SOURCE/'heap_mirrors.py', SOURCE/'isolated_io.py']})
    (OUT/'heap_size_tests.json').write_bytes((json.dumps(result, indent=2)+'\n').encode())
    print(json.dumps(dict(passed=passed, checks=len(checks), error=error, cleanup_error=cleanup_error)))
if not passed:
    raise SystemExit(1)
