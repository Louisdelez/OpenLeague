# Final state: isolated HeapReAlloc bridge

The following old working notes are retained as historical context only.
FINAL RESULT supersedes them: both native profiles passed real HeapReAlloc128to256
and stopped at GetModuleHandleA("kernel32"). Final suite: 1034 checks /17 reports,
including 667 bounded adapter/ABI checks,13 original Windows x86 SList checks and
354 original RADS strlen checks (68 complete invocations,3 interrupted,2 manual
contexts). Both final oracles share12 generator hashes. Terminal host cleanup
leaves zero CRT raw owners/mappings/interrupted owners/strlen contexts, while928
engine primitive allocations remain in each emulator. No native full teardown,
DLL attach, INI return, provider return or Rust integration is claimed.
README.md and manifest.json are authoritative. Continue in a fresh copy only.

## Historical working notes, superseded by final result above

This is the only mutable heap work copy. Production and all frozen preparations
are unchanged. Parent authorized two full provider profiles after independent
review and the isolated suite. They have now run but stopped at a new, explicit
requested-range guard; this is intermediate evidence, not the final lot result.

Baseline: 24 Python sources copied and verified against the commandline lot,
manifest `de3171f52c7387491f4be3883996bbee71209270f3f64293ae4679a85ba1c71c`.
The separate static contract remains frozen under
`E:\mapslol3v3\loading_rads_reallocation_preparation` with manifest
`e01c0e15e4c4d81ad6bf5d17b308def0d428ad51d4ee1327bb6208ad6ef0741f`.

## Implemented candidate

- `heap_mirrors.py`: fixed owner records; bounded separate guest reservations;
  guarded native and Python reads/writes; actual HeapAlloc/HeapSize/HeapFree and
  flags0 HeapReAlloc; pre-call synchronization and preserved incoming last-error;
  raw/mapping retirement and interrupted ownership tracked independently.
- `crt_os.py`: uses derived readonly live/retained views, guarded machine memory,
  x86 argument/result publication; event/finish faults retain an interrupted
  owner after real success. The primitive free route checks arena membership,
  so stale/interrupted CRT addresses cannot enter the engine allocator.
- `probe_rads_provider.py`: wiring executed in two bounded attempts. Cleanup verdict
  includes retained mappings, interrupted owners and cleanup errors. Engine
  allocation counts are explicitly separate from the new CRT mirror counts.
  `heap_mirrors.py` is included in final generator hashes.

## Executed evidence

1. `test_heap_mirrors.py` / `heap_mirrors_tests.json`: 244 checks passed, including
   20 actual Windows reallocations (12 moved, 8 same-address in this execution),
   guest-written pattern preservation, requested-range guards, preserved incoming
   last-error, 12 injection phases and raw/mapping cleanup retries. Zero remaining
   raw owners or mappings. Two tiny x86 snippets test cross-arena guard accesses;
   no original EXE/DLL executes here.
2. `test_heap_boundary.py` / `heap_boundary_tests.json`: 29 checks passed through
   CrtOs dispatch, including pop16, explicit Python NLS/FILETIME/string bounds,
   stale/interrupted free routing, and allocation/reallocation event/finish faults.
   Zero remaining resources. It collects the finish callback; the separate root
   ABI test now additionally inspects actual EAX/ESP changes.
3. `test_heap_realloc_x86.py`: root-supplied independent test passes 23 checks.
   It extracts only the real `finish` helper AST from the pinned original probe,
   then runs synthetic x86 call instructions through the real CrtOs/Windows heap
   boundary. It does not execute the original game or DLL body.
4. The complete local suite currently passes 679 checks across 16 reports. The
   inherited heap tests have been replaced with the reviewed 30/83-check versions.
   Two early suite failures are preserved: the new bridge correctly rejected its
   stale copied WORKSPACE allowlist; the FLS test's old minimal fake guest lacked
   Unicorn/memory hooks. Only this copy's root/test setup were corrected.

## Intermediate native boundary

Both latest native profiles use matching generator hashes and complete host
cleanup with no raw owners or heap mappings remaining. They stop before realloc
at the original DWORD strlen instruction `100F8700`, because the requested-size
guard refuses its aligned read past a valid terminator:

- Empty environment: read4 at `50C00000`, owner12 requested2, valid bytes `43 00`.
- Controlled environment: read4 at `50100030`, owner1 base`50100000` requested51,
  valid bytes `3D 00 00`; one additional byte would be accessed.

The exact 139-byte function `100F86D0..100F875A` is statically pinned by
`extract_strlen_source.py` / `strlen_source.json`, SHA256
`5044fc769fb26ae1772d18e3e1ef5ffc16757c910207278cab8d90af3557a7f0`.
The two read instructions are `100F8700` and `100F8718`. EDX depends on the
DWORD, including padding, so arbitrary fill must not be described as complete
register parity. No padding allowance or new API has been implemented yet.
Root and reviewer are examining a narrowly bounded real ReadProcessMemory
observation of alignment bytes; wait for that contract before implementation.

The injected null realloc and failed HeapFree are ownership tests, not actual OS
failure observations. Flags0 is the only admitted HeapReAlloc mode; zero-fill and
in-place-only requests remain rejected. No OOM was forced. Partial/failed local
evidence is retained under `attempts`; previous240/17-check captures predate the
current last four/twelve assertions and must not be counted as new suites.

## Coordination and next steps

- `/root/replay_path_registry` supplied the two inherited test replacements; they
  are integrated and have rerun successfully here. It now prepares the publisher.
- `/root/receive_adapter_review` found no unresolved ownership defect and now
  audits the exact strlen read boundary with root.
- The current native boundary must be resolved by a qualified precise contract,
  then all affected suites and both native profiles rerun on common final hashes.
  Unknown effectful APIs remain explicit stops.

No freeze manifest has been written for this working copy. Existing successful
DLL attachment, RadsInitialize, INI return or provider completion is NOT claimed.
