# Confined native resource-provider IO preparation

This is a separate scratch preparation. No production source, previous frozen package, D: deployment file, Rust build or game client was changed or executed.

## Results actually executed

* `io_isolation_tests.json`: **36 checks passed**, real Win32 calls. Covers case normalization, contained `..`, escaping paths, ADS, device/UNC/drive-relative names, source attributes/bytes, read-only handle write rejection, actual errors 2/3/18/183, scratch write/read-after-write, and no remaining handles. The actual source DDS has the same SHA256 before and after.
* `native_io_oracle.json`: a fresh execution of the genuine PE `90AD00` entry after the same real default-context fragment and manager construction as the previous probe. **Provider not completed** (`passed=false`, `complete=false`). It performs 18 actual `FindFirstFileA` queries, 15 `GetFileAttributesA`, a declared virtual CWD query and one actual scratch `CreateDirectoryA` returning 1. It then stops explicitly at **CABDA8**, called from C99F1A, before uninitialized CRT dispatch. 4,341 unique native code addresses observed.
* `native_io_uninitialized_crt.json`: the earlier failed execution is preserved. It made the same isolated directory creation and then raised Unicorn `UcError` at BB40E64E. This is not a successful provider oracle. The later probe adds an explicit stop before reaching that invalid dispatch.

The native program's `Config` path is mapped under `native_root_<id>/Config`. Its initial scratch profile is empty, so the real directory creation returns 1. The original D: Config already exists. Therefore this result proves an isolated IO continuation, **not parity with the historical Config state or complete startup**. No resource/INI/provider result is synthesized. The emulator retains 28 native allocations at its stopped boundary; no native teardown is claimed. Host handle cleanup is recorded separately and leaves zero handles open.

## Bridge contract

`isolated_io.py` gives `Bridge(root)` an explicit virtual deployment at `root/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy`. Read-only paths map to the corresponding original source root. Writes are allowed only below virtual `Config`, physically under the supplied fresh scratch root. After successful creation, its subtree is read consistently from scratch; there is no silent merged-directory view.

The resolver rejects escaping `..`, sibling-prefix tricks, rooted/UNC/device names, drive-relative forms, alternate streams, trailing dots/spaces and existing reparse components. Actual Windows APIs supply file attributes, enumeration order, errors, file bytes, creation and writes. Unsupported API flags, handles and interfaces remain explicit errors. Sources are opened read-only. Native handle labels retain the actual host handle and its read/write access class.

Before opening/writing, existing parent directories are checked and held without share-write/share-delete. Missing parents are allowed to reach the actual final API, preserving real error 3. An opened handle is matched to the validated path using its file ID and `lstat`; `GetFinalPathNameByHandleW` is unavailable in this sandbox (actual Win32 5). Reparse handles are rejected. CREATE_ALWAYS/TRUNCATE_EXISTING first obtain a nontruncating handle, check identity and hardlink count, and only then truncate that same handle. Thus a detected multi-link file is not truncated before rejection.

**Confinement assumes no concurrent external modification of this private filesystem tree.** It is not hardened against hostile cross-process rename/link races. Root directory setup is not pinned, absent ancestors cannot be pinned, and pins are released before subsequent handle writes. This is the explicit operating condition of this single-process evidence probe, not a general sandbox security claim.

## Limits of the reparse and hardlink tests

Creating even a scratch-to-scratch junction using FSCTL_SET_REPARSE_POINT was denied with Win32 5. Creating a scratch hardlink was also denied. No escalation or alternate privileged creation path was used. Consequently the full mapped-write injection cases for these links were **not executed**.

The tests instead inspect a genuine existing Windows junction (`C:/Users/loicd/Application Data`) using `lstat` and prove that the ancestor guard rejects it before target traversal. A genuine existing hardlink (`C:/Windows/System32/kernel32.dll`) is opened for attributes only, and its real multi-link metadata is rejected by the write-ownership guard. Neither path is written. These narrower checks do not replace the missing writable-link injection tests; both limitations are stored in the result JSON.

## Next native dependency

No formatting hook was added. Existing `tools/probe_replay_stream_opening.py` composes **CB0378** (CRT static locks) and **CAFF53** (low IO), after its inherited global setup. `tools/probe_replay_object_commands.py` supplies actual **C9A0B9** dispatch initialization; `tools/probe_native_audio_crt_thread_system_startup.py` qualifies **CA92CB**, calling actual C9A0B9/CABDE8 resolution, static lock initialization, TLS/FLS wrappers and CA9218 thread-context construction against declared OS boundaries.

The next task is to compose these genuine prerequisite bodies with this bridge and keep their process/thread state alive, then re-enter the provider from a fresh native machine. Existing probes include explicit OS adapters; their successful fixtures are not proof of this new composition. Do not return a hand-written formatted skin string or default INI value to skip it. Source regions around the stopped dispatch and path call are pinned in `source_regions.json`.

INI `8B0630`, provider56 completion, recursive inheritance, populated cache teardown, DDS decode/upload, startup activation and standard loading UI remain unqualified by this lot. The 18 native filesystem searches observed are the missing `DATA/Shared/GlobalCharacter` paths; native Ahri directory population has not yet completed.

## Reproduction and freezing

Run the bundled Python against `test_isolated_io.py`, then `probe_native_io.py`, only in a new copy of this preparation when extending it. The tests use UUID-named private roots and preserve their scratch files; they do not recursively remove any directory. The old errored trace was generated before the explicit CRT stop was introduced. It remains separate from the final bounded trace.

The native probe imports only the prelude of the frozen previous probe; that probe's body is not run. All source PE instruction bytes are checked during execution. The same pinned PE SHA256 is `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. `freeze.py` checks both outcomes, source equality and hashes. After manifest creation this folder's code/evidence is frozen; further work belongs in another directory.
