# Original RADS heap growth: bounded native preparation

Both original EXE/RADS compositions passed actual Windows HeapReAlloc128to256
growth and stopped at GetModuleHandleA with the native literal "kernel32" at
0x10176C64 and IAT slot0x101311C4. No Rust integration or production edit occurred.

| Profile | Distinct addresses before cleanup | DLL addresses | Actual growth | RPM tail observations | Native strlen returns |
| --- | ---: | ---: | --- | ---: | ---: |
| Empty environment | 19167 | 5536 | 128 to256, moved | 2 | 3 |
| Controlled public environment | 19254 | 5624 | 128 to256, moved | 7 | 12 |

These are distinct address counts, not executed instruction totals. Stdout counts
include cleanup (19337 /19424). Both final JSON oracles share12 generator hashes.
Five C and50 C++ initializers returned; the51st C++ call is interrupted (56 calls,
55 returns). LowIO, argv and environment constructors returned0. Module state is
still attaching, handle unpublished. RadsSetLogger/RadsInitialize were not reached.
INI entry was observed but neither INI nor provider returned. Native semaphore and
event creation were not reached; their isolated tests remain separate evidence.

heap_mirrors.py owns actual Windows blocks and separate bounded guest mappings.
It synchronizes guest bytes before HeapReAlloc and preserves real moved/retained
identity. Raw ownership, mappings and interrupted publication are tracked separately
for safe cleanup retries. LastError survives host preparation. Native hooks and
Python accesses enforce requested ranges. Stale/interrupted CRT addresses never
fall through to the engine allocator. Publication errors keep their owner.

NATIVE_STRLEN_TAIL.md defines the sole opt-in read exception: original139-byte
strlen100F86D0, its two aligned DWORD instructions, identified invocation and
unchanged live owner, with NUL inside requested bytes. Its1to3 alignment bytes
come from exact successful ReadProcessMemory and are cached for that invocation.
No synthetic padding or historical x86/x64 padding equality is claimed. EDX is
computed by native code from those actual bytes. Python reads, writes, HeapSize
and other native accesses stay strict.

adapter_checks.json:1034 checks across17 reports. Of these667 are bounded adapter
and ABI checks (including real Windows calls/synthetic x86),13 are original Windows
x86 SList checks,354 are original RADS strlen checks (68 completed invocations,
3 interrupted,2 manual contexts). The ABI test extracts the pinned real finish
helper by AST and runs synthetic calls to verify EAX/ESP/EIP and pop16.
The20 actual isolated reallocations moved13 times and retained addresses7 times.
Null realloc, free failure, publication faults and failed/incomplete RPM are
explicit injections, not observed OS failures. Only flags0 HeapReAlloc is admitted.
Historical guard stops/setup failures/revisions remain under attempts and are not
counted again as final tests.

At stop, empty/controlled own36/39 CRT backing blocks and mappings. Terminal host
hygiene retires all raw owners, mappings, interrupted owners, strlen contexts,
slots, locks and host handles. The928 engine primitive allocations remaining in
each emulator are outside the CRT backing count. This does not prove complete
native atexit/DLL detach/provider destruction or resumption after a native fault.

The virtual commandline/environment are explicit public resource-loading profiles;
host arguments/environment are not imported. x86 code runs only in Unicorn, never
inside host64. Source files stay read-only; writes stay within private Config/Logs.
Confinement assumes no concurrent external filesystem mutation. Prior limitations,
including unqualified successful truncation modes, remain. The local diagnostic
pipe attempt sends no data. No UI/textures/provider/game completion is claimed.

Continue in a new copy with real borrowed GetModuleHandleA and A/W identity, without
adding LoadLibrary/FreeLibrary. Keep this lot and earlier contracts frozen.
