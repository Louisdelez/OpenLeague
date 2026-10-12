# Original lowIO startup: static integration notes

This package contains a **static extraction**, not an executed oracle or a Rust port. It reads the original 4.20 PE with SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. No Windows I/O, compiler, native emulation or production writes were performed. `lowio_source.json` contains exact region bytes, hashes, call targets, resolved IAT names and the limits of the bounded destructor search. `lowio_disassembly.txt` is the corresponding instruction listing. `extract_lowio.py` reproduces these two files using the existing read-only PE extractor.

## Entry and prerequisites

`CAFF53..CB01FD` is 683 bytes. It takes no explicit arguments and returns `0` on its normal path or `FFFFFFFF` when the first descriptor-block allocation returns null. Source startup fragment `CA0F8E..CA0FC9` calls process-heap startup `CABB83`, thread startup `CA92CB`, `CB0207`, then `CAFF53`; a negative lowIO result takes the source error helper with argument `1B`. This fragment is not the complete process entry point.

LowIO first calls `CB0247(11)`. The original lock table has **entry11 `{0,0}`**, whereas entries1 and10 have `{0,1}`. Therefore the already ported static `CB0378` initializer does not create lock11. `CB0247` must enter `CB02CF` on the initial path:

1. Require process-heap global `14AE87C` to be nonzero; the null case invokes source diagnostics/termination helpers.
2. Recheck the requested lock pointer; if null, allocate **24 bytes via `CA86BB`**.
3. Allocation null calls `C9B780`, writes errno12 and returns0. `CB0247` then invokes `C99FE7(11h)` before its eventual entry instruction; that failure policy is not implemented here.
4. Acquire static lock10, recheck the requested pointer, then call `CABD7A(storage,4000,0)` and publish it, or free the redundant allocation through `C98528` if another initializer published first.
5. Release lock10 through `CB036F`, return1, then `CB0247` calls real `EnterCriticalSection` on the selected pointer.

No existing Rust port of `CB0247/CB02CF` was found in the CRT modules during this audit. Existing `audio_crt_thread_system_startup::cleanup_lock_table` can retire a dynamic lock, but its constructor must not be replaced by a prefilled fixture. `CA86BB` is a distinct allocation entry; the existing zero-initialized process-heap adapter does not by itself prove its allocation/error semantics.

`CABD7A` decodes `2DA5310 XOR 1222ED0`. Nonzero dispatch invokes `InitializeCriticalSectionEx(storage,spin,flags)` through the resolved pointer. Zero dispatch invokes imported `InitializeCriticalSectionAndSpinCount(storage,spin)` and then returns1 **regardless of that imported API's returned value**. LowIO ignores the helper return on both branches.

## Initial table and inherited descriptors

The first allocation is `CA8673(32,64)`: **2048 bytes** for 32 records. Only after a nonnull result does startup publish `14AE888[0]` and set `2DA52EC=32`. The global pointer array has 64 slots, allowing 2048 records. Both globals initially contain zero in this PE.

Each initial record receives, in source order:

| Offset | Write |
|---|---|
| `+04` | u16 `0A00` (flags byte0 followed by lookahead byte0A) |
| `+00` | OR u32 with `FFFFFFFF` |
| `+08` | u32 zero, used as critical-section-initialized state |
| `+24` | byte AND80, then on the first block a read/AND7F/write |
| `+25` | u16 `0A0A` |
| `+38` | u32 zero |
| `+34` | byte0 |

Record stride is `40h`. All other bytes retain the actual calloc output. Additional inherited-data blocks use the same writes except the second `+24` AND7F sequence is absent. Do not collapse the writes/read order merely because successful calloc supplies zeros. Per-record critical-section storage is at `+0C` and its actual Windows bytes are opaque.

`GetStartupInfoW` (`IAT FA426C`) fills a 32-bit STARTUPINFO view. The native gate tests only nonzero `cbReserved2` at offset32h and nonnull `lpReserved2` at offset34h. It does not perform a bounds check against the inherited buffer's count.

For a supplied buffer, the first signed32-bit integer is the descriptor count, followed by count flag bytes, then count32-bit handle values. **The handle-array start uses the original count before clamping the processing count to 2048.** Signed negative counts skip both the growth and descriptor-processing loops. Malformed pointers/counts are unqualified native inputs, not silently repaired values.

While `2DA52EC < effective_count`, allocate another `(32,64)` block. Publish the block pointer and increment capacity by32 before initializing its records. If an additional allocation returns null, reduce the effective processing count to the currently allocated capacity and continue; startup can still return0. Already allocated blocks stay live.

For each inherited descriptor: ignore handle `FFFFFFFF` or `FFFFFFFE`, and ignore entries without flag mask01h. Flag mask08h bypasses `GetFileType`; otherwise its returned value must be nonzero. Accepted entries publish the OS handle then the flags byte, call `CABD7A(record+0C,4000,0)`, then increment `record+08` even when the helper returned0. No handle duplication occurs in this function. The Windows adapter must translate full-width host handles to canonical32 labels explicitly; the host x64 STARTUPINFO payload must not be reinterpreted as this x86 packed buffer.

## Standard descriptors and return cleanup

Descriptors0,1,2 are processed after inheritance. If an entry already holds a value other than `FFFFFFFF/FFFFFFFE`, startup only ORs its flags with80h.

Otherwise it writes flags81h first and calls `GetStdHandle` (`IAT FA4328`) with -10/-11/-12. A return of `FFFFFFFF` or0, or a subsequent `GetFileType` result0, takes the missing-handle path: OR flags40h and publish handle `FFFFFFFE`. If global `2DA63A0` is nonzero, it also follows that FILE-pointer array entry and writes `FILE+10h=FFFFFFFE`; the individual FILE pointer is not null-checked.

For a valid standard handle, publish it, then inspect only the low byte of `GetFileType`: type2 adds flag40h, type3 adds flag8, other nonzero types add neither. Then initialize the per-record critical section and increment `+08`. There is no imported CloseHandle/SetStdHandle during startup.

Normal return releases lock11 via `CB01FE -> CB03B1(11)` and returns0. First-calloc failure invokes the SEH local-unwind helper `CAE970(cookie_address,frame,-2)` before returning `FFFFFFFF`; the original scope table `11C2CF8` names the same unlock continuation. No descriptor block has yet been published on that path. Exception/abnormal-exit behavior still requires execution qualification; this audit does not emulate SEH.

## Closures actually identified

`CAF488` is a descriptor close wrapper: validate fd/flags, take the descriptor lock (`CA717C`), recheck flags and call `CAF563`, then unlock through `CA7638`. `CAF563` obtains the OS handle with `CA7439`. For stdout/stderr, it avoids closing the shared underlying handle when descriptors1 and2 are both open and resolve to the same value. Otherwise it calls `CloseHandle` (`IAT FA4398`) and captures `GetLastError` on failure.

After that call, it invokes `CA73B3` and clears the descriptor flags **even if CloseHandle failed**, then maps the saved error through `C9B75F` and returns -1, or returns0. `CA73B3` optionally calls `SetStdHandle(-10/-11/-12,0)` when global `14AEAD8==1`, before storing `FFFFFFFF` as the descriptor's handle. The invalidation helper's return value is not used by `CAF563`. This source behavior is not an atomic host-release contract; a future Rust failure owner must distinguish a Windows false return from a pre-call adapter rejection.

These functions do not free the 2048-byte lowIO block or delete its per-record critical section. `CA717C` can lazily initialize a previously untouched record lock under static lock10; `CA7638` only leaves it.

Separate **stdio** cleanup is visible at `C9ADE5`: call `C9A452`, conditionally call `CB124E` when byte `14AE5E0` is nonzero, free the FILE-pointer table `2DA63A0` and clear that pointer. `CB124E` visits FILE entries3 through `2DA63A4-1`, closes active streams through `C99855`, then for entries>=20 deletes `FILE+20h` critical sections, frees FILE objects and clears their array entries. `C997E9` shows the fclose body eventually calling `CAF488` for its descriptor. **These are not lowIO-block destruction.** The exact `C9ADE5` registration/startup termination chain and the flush helper are not qualified by this package.

A bounded operand-candidate search over CRT addresses `C97000..CCFFFF` found the table and capacity consumers; no global lowIO block destructor was identified. This is not proof that none exists elsewhere or through an indirect path, nor a proof of a leak. Do not invent a native destructor from the host cleanup performed by the exploratory oracle.

## Integration boundary

Reuse the existing single `Application -> Root/Bridge` CRT bank and its Windows heap, FLS and critical-section ownership. Table `14AE888` is already inside the current CRT data region. New exact regions are needed for count `2DA52EC`, stdio globals `2DA63A0/2DA63A4` if that path is connected, and the static FILE objects `12225B0..122282F` for actual stdio initialization; these are absent from the current73-region image. Existing cookie/dispatch/lock/heap globals must not be seeded a second time.

Before a Rust/Windows lifecycle is accepted: qualify dynamic lock11 construction, startup allocation failures, inherited-handle layout/type results, standard handle alias/missing cases, actual fopen/descriptor population and appropriate close ordering. Preserve explicit errno/new-handler and abnormal-exit boundaries. Only connect a provider once its owned handles and descriptor/FILE state can be retired without mixing source CRT labels with the unrelated UCRT or private-msvcrt FILE domains.
