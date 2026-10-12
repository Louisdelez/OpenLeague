# Current boundary: HeapReAlloc

Both final profiles stop at the genuine HeapReAlloc import during native atexit
table growth from128 to256 bytes. The argument is an exact owned process-heap
allocation, with flags0. No realloc result was supplied. Five C and45 C++
initializers returned; the46th C++ initializer is interrupted. The DLL remains
attaching, the EXE loader has not published its module handle, and no RADS
initialization or INI/provider return is claimed.

The next fresh copy must qualify the complete host/guest allocation ownership
transition. Guest writes have diverged from the initial host backing contents
and must be synchronized before the real HeapReAlloc. The real call can retain
or move the pointer; guest pointer identity must follow that result. A stable
old guest address must have enough reserved capacity if the real block grows
in place. The current dense primitive arena cannot promise that. A failed real
reallocation leaves the original owner alive. A successful call followed by
mirror/publication failure must retain the resulting owner and must never free
the obsolete raw address. Preserve zero-fill, shrink/copy and flags contracts,
real return/errors, original data and interrupted ownership explicitly.

This requires a separately qualified reserve/reallocation design, not returning
a new guest label for every case or silently increasing the recorded capacity.
The present frozen lot intentionally leaves HeapReAlloc unimplemented.

## Previous boundary: LCMapStringEx (subsequently qualified)

The empty-environment composition reached the dynamically resolved export at
the guest stub `0x3E0001C0`. Native wrapper `0x1010B82F` loads the encoded export
from `0x10199A90`, XORs with cookie `0x101902C0`, then calls it at `0x1010B856`.
Instructions `0x1010B83F..0x1010B843` explicitly push three zero optional
arguments. Six ordinary arguments follow. Source: RiotRadsIO.dll, SHA256
`60833cd552d93b93304d4937912951e144e38db5d70793eb60a0c5f5d579e521`.

Observed arguments: locale NULL, flags `0x100` (lowercase), source of 256 WCHAR,
destination NULL, destination capacity zero. The seven-argument stop trace
does not itself record arguments eight/nine; their zero values are established
by the source wrapper above, not by invented execution results.

The final bounded adapter implements and tests this contract:

- x86 stdcall nine arguments, pop36; real Kernel32 call through typed ctypes.
- Restrict to lowercase/uppercase flags, explicit positive source length at
  most32768 WCHAR and a bounded output capacity. Reject sort-key/hash/handle
  modes rather than confusing character and byte capacities.
- Translate NULL locale unchanged. For a nonnull locale, copy only a bounded
  terminated UTF16 name; preserve distinction NULL/default versus empty/invariant.
- Require optional version/reserved/sortHandle all zero.
- Read guest source and prior output into separate owned host buffers; query
  capacity0 uses NULL destination. Reject overlapping guest buffers initially.
- Copy the complete bounded destination back even when the OS returns failure:
  Microsoft explicitly permits partial output on failure. Preserve real return
  and GetLastError. Do not derive mappings using Python strings.
- Compare size queries, sufficient and insufficient buffers, both case modes,
  embedded NULs and explicit lengths against direct Win32 calls, with guards.

Source contract:
https://learn.microsoft.com/en-us/windows/win32/api/winnls/nf-winnls-lcmapstringex

The intermediate LCMapStringEx stop remains in the historical attempts. It is
not the final boundary. Final host cleanup is successful in both profiles,
with zero handles/CRT backing/pending callbacks;959/962 emulated allocations
remain without native teardown.
