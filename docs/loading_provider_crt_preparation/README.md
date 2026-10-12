# Native CRT to resource provider: bounded execution

This is scratch evidence, not an integrated Rust provider. `provider_returned=false`, `completed_path=false`, `complete=false`. The final run stops before the actual `LoadLibraryA` call at `9529F4` (IAT `FA43D4`) for the mapped, present, original **RiotRadsIO.dll**. No DLL is loaded into the Python64 host, no invented module handle or failed-load result is returned.

## Executed

- A fresh Unicorn x86 machine executes the verified 4.20 EXE (`402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`). Each reached instruction is compared with the mapped PE bytes before execution, except declared memory/allocation/OS boundaries.
- Exactly one native `CA92CB` returns1, including `C9A0B9/CABDE8`, `CB0378`, actual Windows FLS allocation and native thread construction. The same machine, memory, OS thread, handles and locks continue into `CAFF53`, which returns0. Its first lowIO block is32 records of64 bytes; `14AE888` holds the block and `2DA52EC` is32. No lock11 is seeded; the native dynamic-lock creation path is reached.
- The bounded context fragment `906487..9065D8`, four hash initializers, producer `90B7C0`, and caller backpointer fragment `592E49..592E6A` execute before **`90AD00(Ahri, skin0)`**.
- Actual source filesystem enumeration reaches `8B0630(Package, FallbackPackage, "", out, 5024, DATA/Characters/Ahri/Ahri.ini, 0)`. It has **not read or returned INIBIN content**: its logger/RADS initialization is still in progress.
- The sole exact local diagnostic call `CreateFileA("\\\\.\\pipe\\LogViewerPipe", GENERIC_WRITE, 0, NULL, OPEN_EXISTING, FILE_FLAG_OVERLAPPED, NULL)` returns actual `INVALID_HANDLE_VALUE`, Windows error2. No IPC data operation occurs. A successful open would be closed and stop the probe without exposing its handle to native code.
- Native directory creation succeeds for the private `Config`, `Logs`, and `Logs/Game - R3d Logs`; the second Config mkdir returns actual error183. No source directory is modified.
- **36 original bridge checks** pass against this new bridge, plus **23 checks** for Logs create/write/close/reopen/read, initial Config/Logs shadowing, exact containment and rejected pipe/path variants. Another **9 ownership checks** inject bridge allocation/free failures around real heap blocks. None supplies a simulated provider result.

`crt_provider_oracle.json` retains full native stop/trail, executed addresses, native allocations/frees, live bytes, imported-API trace, path observations and generator hashes. Its final sample has13,629 unique native instruction addresses,1,916 allocations,987 native frees and929 live emulated allocations at the stop. The console instruction count includes subsequent callback cleanup and is therefore larger. `host_cleanup_native_frees` separately records the thread buffer release;928 emulated allocations remain. Neither those allocations nor registered native process callbacks have undergone complete native shutdown.

## Ownership and ABI boundaries

The process heap global is seeded with a label for the actual host heap; legacy allocator globals are explicit inputs. Engine allocation/free, memcpy/memmove/memset, `CA8673` calloc and atexit registration are declared primitive boundaries. This is not normal application startup or allocator failure qualification.

FLS/TLS, critical sections, process services, conversion APIs and time calls use actual Windows APIs. Opaque32-bit labels represent64-bit host handles/pointers; `EncodePointer` values and native lock bytes are ABI translations, not original x86 OS representations. StartupInfo is translated to exactly68 x86 bytes. Inherited lowIO tables are unsupported and explicitly rejected; the actual host profile has none.

Windows invokes retained FLS host callbacks, which queue the genuine x86 callback; the runner executes it on a separate emulated stack after the OS function returns. Final cleanup calls actual FlsFree and executes native `CA9026`, then retires host backing separately. It is **host hygiene after an interrupted native call**, not normal native CRT/provider/SEH destruction. The final result has `cleanup_passed=true`, with0 host file/find/pipe handles,0 slots,0 lock backing,0 heap backing and0 pending callbacks. Borrowed standard handles and the process heap are never closed.

## Confinement and observed limits

The new filesystem bridge maps source reads to the original D deployment and permits writes only below Config/Logs within a fresh private E scratch root. Config/Logs are shadowed from the first lookup, before mkdir; their initial missing attributes are the actual private paths' result, despite source Config existing. Older attempts predate this profile correction. Case/dotdot/ADS/device checks, existing reparse checks, parent pinning and opened-file identity/hardlink checks remain in force. **No concurrent external filesystem mutation is assumed**; this is not a hostile cross-process race defense.

Successful `CREATE_ALWAYS`/`TRUNCATE_EXISTING` remain untested. Writable junction/hardlink fixture creation was denied by actual Windows5; read-only guards against existing system examples were exercised, as recorded by the36-check receipt. The native path here has created directories but no disk log file yet. No `RemoveDirectoryA` adapter exists; such a request remains a stop. No network or IPC payload is sent.

`attempts/001.json` onward preserve failed/stopped prior runs, including the uninitialized/unsupported CRT paths, pre-allowed pipe stop, actual pipe-error2/Config-only stop, and earlier RADS stops. An old attempt's `passed` or snapshot layout must not be treated as the final schema. `input_hashes.json` is the initial copy receipt; `input_verification.json` is the current comprehensive verification (36 preserved input/dependency files).

## Resource semantics and next dependency

Original RiotRadsIO.dll is x86,1,707,520 bytes, SHA256 `60833cd552d93b93304d4937912951e144e38db5d70793eb60a0c5f5d579e521`; its13 exports and source loader bytes are in `rads_dependency.json`. Continue in a new copy with a qualified x86 PE loader/entry/import/relocation contract inside the **same Unicorn machine**, then real RADS exports. A host64 LoadLibrary failure is not a substitute for the native32 environment.

Publication at90B651 precedes INI. Parent905000 is borrowed without retain/cycle checks. **90B270 is a synchronous visitor**, not persistent callback registration: active entries are visited with a temporary callable and the callable is destroyed. This corrects earlier frozen preparation prose without editing it. Full fallback recursion, active-context provider refresh, populated destruction and provider-before-directory ordering still need qualification.

No Rust source, executable, production image, original deployment or previously frozen lot has been changed by this package. No texture/rendering/UI completion is implied.
