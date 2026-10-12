# Original RADS CRT process-profile composition

This frozen preparation advances the original EXE/provider and RiotRadsIO.dll
in the same Unicorn x86 machine. No Rust or production files were modified and
no x86 DLL executed inside the host64 Python process.

Two final profiles use exactly the same generator hashes: an explicitly empty
environment and three explicitly declared nonsecret variables. Both execute
the native lowIO, argv and environment-table constructors successfully. Native
argc is1; environment entries are zero/three; the converted contiguous ACP block
is freed by the native table builder. The command-line page remains a borrowed
process-profile owner until after deferred cleanup callbacks.

Both profiles execute all five C initializer calls and return from45 C++ calls.
The46th C++ initializer reaches an unimplemented HeapReAlloc request growing the
atexit table128→256 bytes. This is a dependency boundary, not a successful
provider result. No module handle is published, DLL attach is incomplete, and
RadsSetLogger/RadsInitialize are not called. INI8B0630 was entered earlier by the
real provider path but has not returned; no fallback/package/texture value is
fabricated.

| Final profile | Distinct native addresses before cleanup | DLL addresses | Emulated allocations after host hygiene |
| --- | ---: | ---: | ---: |
| Empty |19043|5426|959|
| Controlled |19127|5514|962|

These address counts include the19-byte x86 Windows SList leaf but exclude
cleanup execution. They count distinct instruction addresses, not instruction
executions. Terminal host hygiene passes in both profiles with zero tracked
file/sync/pipe handles, CRT locks/slots/heap backing and pending/interrupted
callbacks. The remaining emulated allocations have not undergone native
provider, DLL detach, static destructor or CRT teardown.

The isolated suite reports300 checks:287 static/ABI/adapter checks and13 checks
across three executions of the pinned Windows x86 SList leaf (three fill profiles).
The full provider compositions are additional evidence, not300 completed game
features. Real unnamed synchronization owners pass15 isolated checks, including
preservation after injected guest-return/logging errors, but are not reached
by the final provider traces. Valid-owner CloseHandle failure and native wrapper
allocation failure are not executed. Other waits, signals, threads and ETW stay
unsupported.

`attempts/` preserves earlier stops and a suite-report serialization failure.
The latter was caused by a local buffer variable masking the API name in the
LCMap log; it was corrected before the final suite and final two profiles.
Each historical native report has its own generator hashes. Only the two final
reports are required to match the current source files. Existing frozen input
lots remain unchanged and are verified before execution.

The filesystem bridge keeps source reads on D: and writes only to its fresh
private Config/Logs overlay. It assumes no concurrent external filesystem
mutation. Existing limitations remain: successful CREATE_ALWAYS/TRUNCATE_EXISTING
were not qualified; junction/hardlink fixture creation was denied on this host.
The only local LogViewerPipe attempt returned the real error2 and sent no data.
No normal game environment, normal startup, replay game, loading UI, texture
rendering or provider completion is established by this preparation.

See `PROCESS_PROFILE.md` for ABI/lifetime contracts and primary OS references,
`NEXT_API.md` for the real realloc dependency, and `manifest.json` for exact
source/report hashes. The next work must use a fresh copy.
