# Native loading-resource provider preparation

This is a bounded **preparation**, not an integrated provider or loading screen. No Rust compiler or client was run. No production or source-deployment file was modified. The source PE is the 4.20 `League of Legends.exe` with SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.

## Executed results

| Evidence | Actual outcome | Scope |
|---|---|---|
| `directory_lifecycle_oracle.json` | `passed=true`, 4 lifetimes, 8 lookups, 17 allocations and 17 frees per lifetime | Ahri/Annie, fill 00/A5, global search-context list explicitly null. Native directory32 creation, cached hit and real manager teardown. |
| `provider_probe_state.json` | `passed=false`, `complete=false`, intentional stop before `CreateDirectoryA` | Native default-context fragment, manager and part of real directory population executed. 18 real filesystem searches, 15 actual attribute queries, one explicit emulated-CWD response. No completed provider. |
| `empty_context_provider_oracle.json` | `passed=false`, `complete=false`, `UcError` at `BB40E64E` | Exploratory full miss with context null reaches native bounded formatting; uninitialized CRT thread/locale state prevents completion. |
| `asset_inventory.json` | Read-only inventory: 16 INIBIN, 15 DDS | Actual Ahri/Annie source paths, hashes, DDS headers and community-parser metadata. No INI values returned into the native provider. |

The directory-only probe uses actual `90B4A0 -> 90B360 -> 903030 -> 9030C0`, then a second `90B4A0` hit. Its three additional owned blocks are directory32, sentinel48 and manager index-node44. All 17 blocks, including the original manager and sentinels, are freed by real native `90A760/90A800/90AAB0` cleanup. The scalar destructor does not clear the manager global; the harness performs that distinct caller action after destruction. The null context is a named input profile, not a claim that a functioning game has no context list. 1,840 unique native instruction addresses executed.

The filesystem probe executes the existing default branch `906487..9065D8`, including `9062A0` and publication of its caller-supplied 148-byte context. This reproduces the prior `search_context_defaults_contract.json` scope: XML selection and full startup remain outside it. Context strings are `now`, `Content/Src`, `Content/Built`, `Content/Loadable`, `DATA`, `-data_overlay_now`.

It then calls the true `90AD00` miss for Ahri/base skin. Native `901F60 -> 905620 -> 8B4830 -> 8B4400` reaches the default physical-filesystem factory `8BC440`, virtual `8B6380`, then `8B9E30`. `FindFirstFileA`, `FindNextFileA`, `FindClose` and attribute adapters call actual Windows Unicode filesystem APIs, with ASCII conversion for native records. Native handles are mapped to opaque 32-bit labels. The original native instruction bytes are checked against the PE at each instruction; only IAT data and explicit primitive hooks are rebound.

All 18 searches observed are under `DATA/Shared/GlobalCharacter` and return actual error 3 (path not found). Ahri's own directory has not yet been reached. Native path initialization calls `CreateDirectoryA` through IAT `00FA41A8`, caller `008B38E6`, for the source root's `Config` directory. The adapter stops **before calling it**. The existing directory was separately observed as present (creation time 18 April 2026); this probe did not create it. The 28 live emulated allocations at the abandoned boundary are retained as evidence, not reported as native cleanup success. No real enumeration handles remain open. `GetLastError` on successful calls is unspecified/stale; use the recorded code only for actual failed Win32 calls.

The empty-context full-provider experiment is also retained as failed evidence. It reaches `903590 -> 993860 -> C9B551` with format `%02d`, output size 3, count `FFFFFFFF`, skin 0. It temporarily adapts the CRT errno-cell accessor `C9B780` to a caller-owned cell; this does not initialize the CRT thread/locale/encoded-function-pointer machinery. Execution later reaches `CA91A9/CABCC2` and fails through `BB40E64E`. No provider return, inheritance, callback registration or populated-provider destruction was qualified. It is not an oracle to use as expected success.

## Resources available on disk

All paths below are relative to the source deployment given by `asset_inventory.json`:

* Ahri: `DATA/Characters/Ahri/Ahri.inibin`, `Skins/Base/Base.inibin`, `Skins/Base/AhriLoadScreen.dds`, plus `Skins/Skin01` through `Skin04` containing their INIBIN and `AhriLoadScreen_1.dds` through `_4.dds`.
* Annie: `DATA/Characters/Annie/Annie.inibin`, `Skins/Base/Base.inibin`, `Skins/Base/AnnieLoadScreen.dds`, plus `Skins/Skin01` through `Skin08`. Skin01/02 use `.DDS` uppercase; Skin07 also has `AnnieLoadScreen_7_LE.dds`.

The full 31-file inventory retains exact path casing, byte counts and SHA256. No matching loose filename was found in `E:/OpenLeague/assets` or `E:/OpenLeague/data/4.20`; no matching item was found in the five archives of `native_zip_catalog.json`. The recovered global catalog also contains no matching character rows. This is a bounded filename/catalog search, not proof that no renamed or embedded representation exists. Existing `native_champion_portraits.json` entries are different IconSquare resources, not these LoadScreen files. Existing champion resource metadata refers to the source INIBIN but does not prove physical import.

The existing community decoder `tools/references/lolpytools/lolpytools_inibin2.py` can hash `Package*FallbackPackage` and read these files. None of the 16 inspected files contains that exact key. This is an inventory observation; native `8B0630/8B0380` was not called with those files. `map10_native_config.rs` only qualifies five INIBIN types from Map10; the character files include other flags and cannot be accepted under that existing narrow qualification. `map_resource_provider.rs` has qualified alias/lookup algorithms and a recovered-global snapshot, but does not implement this full character-provider constructor or `FallbackPackage` producer.

## Exact remaining native chain

`90B520` creates provider56 (`9034D0`) from a directory32 produced by `90B4A0`, reloading global manager `2D78F1C` for the constructor. Provider owns its own tree and String24; directory32 at provider+14 is borrowed. Provider scalar delete is `901D40 -> 901CD0`; it does not free directory32.

The factory publishes the provider in the manager cache before INI lookup. It builds `<original name>.ini`, calls virtual+28 (`9041E0`) and virtual+1C (`903EE0`), and reads `[Package]FallbackPackage` through `8B0630`. Empty fallback selects the manager's shared provider; nonempty fallback recursively calls `90AD00` for the same skin. `905000` assigns the parent; a manager hash entry and callback24 (`90B270`) follow. No synthetic parent/cache/INI result should bypass these steps. Partially published provider cleanup and recursive inheritance must be qualified before host integration.

Next executable environment: see `SCRATCH_ENVIRONMENT.md`. First resolve the path-initialization write boundary using strict mappings; then qualify physical iterator successes with real files, CRT formatting/thread state, INI loading/aliasing, callback ownership, and teardown. This package supplies no texture upload, rendering, standard UI completion, startup activation or new production code.

## Reproduction

Use the bundled Python at `C:/Users/loicd/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/python.exe`. The scripts import the frozen extractor/harness prefix read-only; they do not execute the frozen harness's main section. `sys.dont_write_bytecode` avoids cache writes beside imported references. Native memory/allocation primitives are explicit in each oracle. `freeze.py` verifies region bytes against the pinned PE and pins every package file plus external dependencies. The package is frozen after that script runs; further work belongs in a new directory.
