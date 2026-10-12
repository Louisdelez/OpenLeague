# First original x86 RADS attach, stopped before command line

This is an unintegrated Python/Unicorn preparation. No Rust build, production edit or host DLL load is performed. The original x86 RiotRadsIO.dll is mapped and its native CRT entry begins executing in the same Unicorn machine as the original EXE. **The module has not finished attaching, no module handle is published, no RADS export or INIBIN result is supplied.**

The final native stop is `GetCommandLineA` from DLL address **100F2AE9**, IAT **10131230**. The bridge stops before returning a command-line pointer; the Python host command line is not substituted. Final fields: `state=attaching`, `provider_returned=false`, `completed_path=false`, `passed=false`, `cleanup_passed=true`. The612 distinct DLL instruction addresses before this stop demonstrate partial execution only. The EXE and DLL together have14,229 distinct addresses at the stop; the console's larger count also includes final callback hygiene.

## What was run

The pinned EXE first executes the already qualified CRT composition `CA92CB=1`, `CAFF53=0`, bounded context/manager fragments and `90AD00(Ahri,skin0)`. Private Config/Logs are shadowed from the first lookup. The exact diagnostic pipe open still returns actual Windows2 without any data operation.

At the native EXE's LoadLibraryA boundary, the mapper validates the actual DLL SHA256, PE32 machine, sections, exports, IAT slots and relocations. It maps the preferred base10000000/size1AC000, exact headers/section bytes, zero-filled virtual tails and appropriate page permissions.210 IAT entries point to separate, module-identified boundary stubs. Unknown imported APIs stop; importing a socket, thread, registry or deletion function does not execute or authorize it.

The native CRT entry100F2C22 runs with `(10000000,1,0)` on a lower emulator stack. The caller registers/context are saved and would be restored only after successful return; only then could9529FA publish a module handle. The interrupted entry remains owned in state `attaching`. The preferred-base profile applies no relocations; arbitrary relocation profiles, PE TLS and delayed imports are rejected. This original DLL has no PE TLS or delay-import directory, but it creates dynamic CRT FLS state.

Cookie initialization uses real Windows GetCurrentProcessId and QueryPerformanceCounter, including the actual signed64-bit QPC output buffer. DLL and EXE CRT globals remain separate. They share the explicit OS bridge and same host thread. Both native FLS callbacks are queued by retained Python callbacks and executed as x86 instructions in Unicorn, never passed to ctypes as native host function pointers.

## Checks and ownership

- 21 structural PE/mapping checks, without executing a DLL instruction.
- 59 filesystem/pipe checks:36 inherited plus23 for the new private Logs/profile and rejected inputs.
- 9 injected heap-ownership checks using actual host allocations.
- 12 actual Windows FLS/TLS checks, including both namespaces simultaneously owning numeric index17 with distinct values.
- 8 Python callback-queue checks for reentrancy and injected simple/nested faults. These are bridge adaptation tests, not native fault-path parity.

`CrtOs.slots` is keyed by `(Fls|Tls,index)`. Host export adapters are keyed by `(module,name)`; the emulated RADS image has a separate identity and export table. A null FLS callback remains truly null. `GetFileAttributesW` test preconditions reject FFFFFFFF before checking the directory bit.

The callback batch helper owns each unstarted entry exactly once. Reentrant invocations cannot consume its siblings. If a callback raises, unstarted entries return to the queue and the interrupted entry is retained in a separate failure record, never implicitly restarted. `cleanup_passed` requires both queues to be empty. Native stack/SEH failure recovery is not inferred from these adapter tests.

Retained entries after a native callback error are diagnostic ownership records: final host-backing retirement ends this machine's execution. They are not a resumable native checkpoint and must not be run again after that retirement.

Final hygiene executes both genuine FLS callbacks: EXE CA9026 and DLL100F5E10. It then retires host lock/heap backing. All file/find/pipe handles, slots, locks, heap backing, unadopted allocations, unstarted callbacks and interrupted callbacks are0. This is **host hygiene after an interrupted attach**, not DLL_PROCESS_DETACH, full native CRT shutdown or provider teardown.928 emulated allocations remain from the stopped application state; the mapped module is retained until the probe machine ends.

`attempts/001.json` preserves the first real GetCommandLineA stop with `cleanup_passed=false` due to the earlier duplicate queue drain. `attempts/002.json` preserves the successful drain before adding fault retention. The final oracle adds the qualified queue guard; earlier evidence is not rewritten.

## Scope and next step

Only the declared private virtual game CWD/path and real source resources are used. Source D and production E:/OpenLeague are read-only. Config/Logs writes share normalization, existing reparse, opened-file identity/hardlink and parent-pinning checks. No concurrent external filesystem mutation is assumed. Successful truncation and writable injected junction/hardlink cases remain outside the qualified profiles. No network, thread launch, registry modification, deletion or IPC payload occurs.

First define a legitimate virtual game command-line lifetime/profile for GetCommandLineA; never return the Python process arguments. Continue the same x86 DLL CRT initialization from source, retaining ownership. Static review in `loading_rads_entry_review` identifies further real initialization dependencies (semaphore, four events and Advapi32 ETW registration/callbacks); none is crossed by this probe. Stop before new boundaries until their exact contracts and lifetimes are understood. The provider's INI/fallback, resources and full loading screen remain incomplete.

Sources: EXE SHA402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862; DLL SHA60833cd552d93b93304d4937912951e144e38db5d70793eb60a0c5f5d579e521. The prior CRT package remains unchanged under manifestc3a585b8ec8fd5e1b9859680fdbc7e588563be1c9d1c42e24b3c4a0c978fd486.
