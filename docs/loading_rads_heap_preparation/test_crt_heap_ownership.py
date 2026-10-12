"""Real Win32 backing and explicitly injected bridge faults; no native provider execution."""
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
params, returns, checks, forbidden_legacy_calls = [], [], [], []


def forbidden(name):
    def call(*args):
        forbidden_legacy_calls.append((name, args))
        raise AssertionError('CRT backing must not use legacy emulated allocator: ' + name)
    return call


class IO:
    last_error = 0


machine = dict(u=u, UC_X86_REG_ESP=UC_X86_REG_ESP,
               read32=lambda a: params[(a - 0x30000004) // 4],
               write32=lambda *a: None, finish=lambda *a: returns.append(a),
               allocate=forbidden('allocate'), release=forbidden('release'))
crt = c.CrtOs(machine, IO())
lifetimes = [crt]
actual = c.K


class TracedHeap:
    def __init__(self):
        self.calls = []
        self.fail_free = False

    def __getattr__(self, name):
        return getattr(actual, name)

    def HeapAlloc(self, heap, flags, size):
        result = actual.HeapAlloc(heap, flags, size)
        self.calls.append(dict(api='HeapAlloc', injected=False, heap=heap, flags=flags,
                               size=size, result=int(result or 0)))
        return result

    def HeapFree(self, heap, flags, raw):
        if self.fail_free:
            ctypes.set_last_error(6)
            result = 0
        else:
            result = actual.HeapFree(heap, flags, raw)
        self.calls.append(dict(api='HeapFree', injected=self.fail_free, heap=heap,
                               flags=flags, raw=raw, result=int(result),
                               last_error=ctypes.get_last_error()))
        return result


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
    assert len(returns) == before + 1, name + ' returned exactly once'
    return returns[-1]


def rejected_before_os(name, operation):
    before = len(traced.calls)
    try:
        operation()
    except c.Rejected:
        check(name, len(traced.calls) == before)
        return
    raise AssertionError(name)


def real_frees_since(index, raw):
    return [r for r in traced.calls[index:] if r['api'] == 'HeapFree'
            and r['raw'] == raw and r['injected'] is False]


def fresh_lifetime():
    # Each post-stop scenario has its own guest and CrtOs. Never resume a native
    # lifetime after terminal host cleanup merely to share test setup.
    guest = unicorn.Uc(unicorn.UC_ARCH_X86, unicorn.UC_MODE_32)
    guest.mem_map(0x30000000, 0x1000)
    guest.reg_write(UC_X86_REG_ESP, 0x30000000)
    machine = dict(u=guest, UC_X86_REG_ESP=UC_X86_REG_ESP,
                   read32=lambda a: params[(a-0x30000004)//4], write32=lambda *a: None,
                   finish=lambda *a: returns.append(a),
                   allocate=forbidden('allocate'), release=forbidden('release'))
    runtime = c.CrtOs(machine, IO())
    lifetimes.append(runtime)
    return runtime, machine


try:
    c.K = traced
    pointer, pop = call('HeapAlloc', crt.heap_label, 8, 64)
    owner = crt.mirrors.owners[0]
    raw = owner.raw
    check('allocation adopts a real Win32 block and publishes exact mirror', pop == 12 and raw != 0
          and crt.heap_blocks == {pointer: raw} and crt.heap_sizes == {pointer: 64}
          and traced.calls[-1]['result'] == raw and traced.calls[-1]['injected'] is False)
    check('actual HeapSize proves raw backing capacity', actual.HeapSize(crt.heap, 0, raw) == 64)
    check('initial zero bytes are copied from real backing', bytes(machine['u'].mem_read(pointer, 64))
          == ctypes.string_at(raw, 64) == bytes(64))
    first_free = len(traced.calls)
    traced.fail_free = True
    check('injected HeapFree failure returns false with error six',
          call('HeapFree', crt.heap_label, 0, pointer) == (0, 12) and crt.io.last_error == 6)
    check('failed free keeps same raw owner and live mapped bytes', owner.raw == raw and owner.phase == 'live'
          and crt.heap_blocks == {pointer: raw} and crt.mirrors.snapshot()['mapped_regions'] == 1
          and bytes(machine['u'].mem_read(pointer, 64)) == bytes(64))
    try:
        crt.heap_free(pointer)
    except OSError as failure:
        check('helper preserves injected Windows failure', failure.winerror == 6)
    else:
        raise AssertionError('heap_free helper ignored injected failure')
    check('helper failure also preserves ownership', owner.raw == raw and owner.phase == 'live'
          and len(real_frees_since(first_free, raw)) == 0)
    traced.fail_free = False
    check('actual retry frees the same allocation successfully',
          call('HeapFree', crt.heap_label, 0, pointer) == (1, 12))
    check('successful retry frees once and retires raw plus mapping', len(real_frees_since(first_free, raw)) == 1
          and owner.raw == 0 and owner.phase == 'retired' and not crt.heap_blocks
          and not crt.heap_sizes and crt.mirrors.snapshot()['mapped_regions'] == 0)
    rejected_before_os('stale free is rejected before another Win32 call',
                       lambda: call('HeapFree', crt.heap_label, 0, pointer))
    crt.release_host_backing()

    for stage in ['allocate_after_os', 'allocate_before_publish']:
        crt, machine = fresh_lifetime()
        first = len(traced.calls)
        finished_before = len(returns)

        def fault(actual_stage, current, selected=stage):
            if actual_stage == selected:
                raise RuntimeError('injected ' + selected)

        crt.mirrors.fault = fault
        try:
            call('HeapAlloc', crt.heap_label, 8, 96)
        except RuntimeError as failure:
            check(stage + ': primary fault remains visible', str(failure) == 'injected ' + stage)
        else:
            raise AssertionError(stage + ': interruption ignored')
        owner = crt.mirrors.owners[crt.mirrors.next_owner - 1]
        raw = owner.raw
        pointer = owner.region.base
        saved_primary = owner.primary_error
        check(stage + ': no guest result published', len(returns) == finished_before)
        check(stage + ': actual allocation retained under interrupted owner',
              owner.phase == 'interrupted' and raw != 0 and actual.HeapSize(crt.heap, 0, raw) == 96
              and crt.unadopted_heap_blocks == {raw: 96} and not crt.heap_blocks
              and crt.mirrors.snapshot()['raw_owners'] == 1
              and crt.mirrors.snapshot()['mapped_regions'] == 1)
        rejected_before_os(stage + ': guest access to unpublished mirror rejected',
                           lambda: machine['u'].mem_read(pointer, 1))
        crt.mirrors.fault = lambda *args: None
        traced.fail_free = True
        crt.release_host_backing()
        cleanup = crt.events[-1]
        check(stage + ': injected terminal free failure is recorded',
              cleanup['api'] == 'host_cleanup_heap_mirrors' and len(cleanup['errors']) == 1
              and traced.calls[-1]['api'] == 'HeapFree' and traced.calls[-1]['injected'] is True)
        check(stage + ': failed cleanup retains raw and mapping plus primary',
              owner.raw == raw and crt.unadopted_heap_blocks == {raw: 96}
              and owner.primary_error == saved_primary
              and crt.mirrors.snapshot()['mapped_regions'] == 1 and not real_frees_since(first, raw))
        traced.fail_free = False
        crt.release_host_backing()
        check(stage + ': retry releases exact owner once', len(real_frees_since(first, raw)) == 1
              and real_frees_since(first, raw)[0]['result'] == 1 and owner.raw == 0
              and owner.phase == 'retired' and not crt.unadopted_heap_blocks
              and crt.mirrors.snapshot()['mapped_regions'] == 0 and crt.events[-1]['errors'] == [])
        count_after = len(traced.calls)
        crt.release_host_backing()
        check(stage + ': repeated cleanup performs no OS free', len(traced.calls) == count_after)

    crt, machine = fresh_lifetime()
    pointer, _ = call('HeapAlloc', crt.heap_label, 8, 128)
    owner = crt.mirrors.owners[crt.mirrors.next_owner - 1]
    raw = owner.raw
    first = len(traced.calls)

    def after_free(stage, current):
        if stage == 'free_after_os':
            raise RuntimeError('injected post-free mapping interruption')

    crt.mirrors.fault = after_free
    try:
        call('HeapFree', crt.heap_label, 0, pointer)
    except RuntimeError as failure:
        check('post-free interruption keeps original error', str(failure) == 'injected post-free mapping interruption')
    else:
        raise AssertionError('post-free fault ignored')
    check('successful OS free removes raw authority before fallible unmap',
          len(real_frees_since(first, raw)) == 1 and owner.raw == 0
          and owner.phase == 'interrupted' and not crt.heap_blocks and not crt.unadopted_heap_blocks
          and crt.mirrors.snapshot()['mapped_regions'] == 1)
    crt.mirrors.fault = lambda *args: None
    crt.release_host_backing()
    check('post-free retry only retires mapping without double free',
          len(real_frees_since(first, raw)) == 1 and owner.phase == 'retired'
          and crt.mirrors.snapshot()['raw_owners'] == crt.mirrors.snapshot()['mapped_regions'] == 0)
    check('legacy allocator and release were never used', forbidden_legacy_calls == [])
except Exception as failure:
    error = repr(failure)
finally:
    # Always retry with real Win32 and without injected faults before reporting.
    c.K = actual
    cleanup_errors = []
    for runtime in lifetimes:
        runtime.mirrors.fault = lambda *args: None
        try:
            runtime.release_host_backing()
        except Exception as failure:
            cleanup_errors.append(repr(failure))
    cleanup_error = cleanup_errors or None
    remaining = [runtime.mirrors.snapshot() for runtime in lifetimes]
    raw_count = sum(r['raw_owners'] for r in remaining)
    mapped_count = sum(r['mapped_regions'] for r in remaining)
    passed = error is None and cleanup_error is None and raw_count == mapped_count == 0
    result = dict(passed=passed, check_count=len(checks), checks=checks, error=error,
                  cleanup_error=cleanup_error, remaining_heap_backing=raw_count,
                  remaining_mapped_regions=mapped_count, remaining=remaining,
                  events=[event for runtime in lifetimes for event in runtime.events],
                  mirror_events=[event for runtime in lifetimes for event in runtime.mirrors.events],
                  os_calls=traced.calls,
                  native_pe_execution=False,
                  scope='Real Windows process-heap allocations/frees. Failure returns and interruption points are explicitly injected; no provider or CRT source body is executed.',
                  source_hashes={p.name: hashlib.sha256(p.read_bytes()).hexdigest()
                                 for p in [Path(__file__), SOURCE/'crt_os.py', SOURCE/'heap_mirrors.py', SOURCE/'isolated_io.py']})
    (OUT/'crt_heap_ownership_tests.json').write_bytes((json.dumps(result, indent=2) + '\n').encode())
    print(json.dumps(dict(passed=passed, checks=len(checks), error=error, cleanup_error=cleanup_error)))
if not passed:
    raise SystemExit(1)
