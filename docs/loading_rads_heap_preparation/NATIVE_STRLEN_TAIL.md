# Narrow native strlen alignment read

The strict mirror discovered a genuine source access at `100F8700`: the native
strlen reads an aligned DWORD containing a valid NUL and up to three bytes past
the requested heap length. The empty profile read `C\0` from a two-byte block;
the controlled profile read `=\0\0` at the end of a 51-byte block. Both original
stops and successful host cleanup are retained as intermediate evidence.

`native_strlen_tail.py` is an optional policy; `HeapMirrors` has no default tail
permission. It identifies entry `100F86D0` by all139 original PE bytes, tracks the
actual return PC/ESP and original argument, and retires the context after return.
Abandoned calls are recorded and cleared before terminal cleanup. Only READ4,
aligned, at exact original opcodes `100F8700`/`100F8718` can use this policy.

The active owner, raw address, region and requested length must match entry.
The read must reach only the last aligned DWORD and encounter NUL within that
DWORD's valid requested portion. The extra1..3bytes are copied from the actual
current-process host backing through a successful exact-count ReadProcessMemory.
Failure or incomplete transfer stops the call. The same observed padding snapshot
serves both loads of that invocation. LastError is restored around this helper;
its OS observation/error is separately recorded and is never a guest API result.

This initializes only a private physical read window. HeapSize, logical capacity,
all guest writes, Python mem_read/mem_write and other instruction reads remain
strictly requested-size bounded. No host pointer from the guest is passed to
Windows; the host address comes solely from the live owner registry. The process
handle is borrowed, with no new owned handle or callback.

EDX retains a value derived from the DWORD, including padding. Therefore we do not
claim that arbitrary padding preserves every register. The tests execute the
original139bytes over real small allocations, then compare its registers with
the same code over a reference buffer containing the same observed padding.
This is a current-host physical observation, not a claim that Windows x64 and
historical Windows x86 heap padding are identical.

The checks also retain strict rejection after return/abandon, unknown PC, source
modification, missing NUL, changed owner/length, writes and explicit Python tail
access. Injected RPM failure/incomplete-transfer cases are distinguished from the
successful real Windows observations. No INI, texture or provider value is created
by this helper, and these tests do not execute full DLL attachment.

Primary OS contract:
https://learn.microsoft.com/en-us/windows/win32/api/memoryapi/nf-memoryapi-readprocessmemory

Source provenance is pinned in `strlen_source.json`; the earlier frozen
REALLOCATION_CONTRACT remains unchanged.
