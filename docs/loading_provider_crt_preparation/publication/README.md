# Publication candidate — not executed

`install.py` prepares and publishes only the frozen native CRT/provider preparation and static audits. It does not execute a native probe, compiler, client, original EXE or DLL. The parent reviews and executes it; this agent has not invoked it.

Inputs, all verified before any write:

- `E:/mapslol3v3/loading_provider_crt_integration/manifest.json`, SHA256 `c3a585b8ec8fd5e1b9859680fdbc7e588563be1c9d1c42e24b3c4a0c978fd486`: all 34 listed files, including 13 preserved attempts, plus 36 external dependencies. Final oracle is stopped (`passed=false`); 59 filesystem/pipe checks and 9 bridge-heap checks are separate passing checks.
- `E:/mapslol3v3/loading_provider_semantics_review/manifest.json`, SHA256 `b6a75c6820c67f903e007a960e86dcff8ad2362927e121fe56dd98716a6dd0f1`: five listed files and all source inputs. Static only; the synchronous visitor90B270 interpretation supersedes older callback-registration prose without altering its frozen bytes.
- `E:/mapslol3v3/loading_provider_rust_readiness/readiness.json`, SHA256 `924ed4867ce7e26d9349af4d841b0d5db4627a4b0fa2fc0e0cc75af1d819b183`: source hashes, historical logs and fixtures checked; these are not new Rust tests.
- The four exact files pinned in `LOWIO` under `E:/mapslol3v3/loading_lowio_source_review`. Static only; original PE provenance and extractor checked. No global lowIO-block destructor is claimed.
- `E:/mapslol3v3/loading_rads_loader_next/manifest.json`, SHA256 `ccb4ef66d7e34406f3d039b6d8254a93cafe3783b86e7aab60a782cfc3145d78`: five listed files under archive `rads_next/`. Static only: 210 imports/7 DLLs; no TLS/delay-import directory; base0x10000000 and size0x1AC000. The separate next DLL-probe directory is excluded.
- Original EXE SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862` and RiotRadsIO.dll SHA256 `60833cd552d93b93304d4937912951e144e38db5d70793eb60a0c5f5d579e521` at their recorded D: deployment paths; read/hash only, never copied or executed.
- Current `E:/OpenLeague/docs/{coverage.json,resume_checkpoint.json,completion_plan.json,completion_plan.html}`; existing 1178-file/122-champion import manifest and receipt. Their asset summary, active state, user communication preferences, complete=false and all domain/task/test states are preserved. The HTML is appended byte-for-byte; old historical sections are not rewritten.

Output archive: `E:/OpenLeague/docs/loading_provider_crt_preparation/` with CRT files at root, `semantics/`, `readiness/`, `lowio/`, `rads_next/`, and publication-script copies. Receipt: `E:/OpenLeague/docs/loading_provider_crt_preparation_receipt.json`. Both must be absent; an existing receipt/archive is never overwritten. The three JSON documents receive a preparation summary and the current next action; the plan's remaining next steps stay unchanged. Domains02/17 receive only a link in `progress_evidence`; their statuses and tasks remain identical. No domain is closed or new Rust test counted.

All payloads are assembled and JSON decoded before any mutation; inputs and destination baselines are rechecked before backup. Timestamped backups go to `docs/plan_history/loading-provider-crt-<UTC>`. Each file uses checked temporary bytes plus atomic replace, receipt last. Caught exceptions restore changed originals and remove individual newly written files; no recursive directory deletion. Backups/empty newly created directories remain recoverable. This is not a cross-file power-loss transaction or protection against concurrent external writers.

After review, the parent may execute:

```powershell
& 'C:\Users\loicd\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe' -B 'E:\mapslol3v3\loading_provider_crt_publication\install.py' c3a585b8ec8fd5e1b9859680fdbc7e588563be1c9d1c42e24b3c4a0c978fd486
```

This command has **not** been run. The native phase results CA92CB=1/CAFF53=0 and clean host backing do not complete native teardown: 928 emulated allocations remain after host hygiene. The final provider run stops before LoadLibraryA for the original x86 RiotRadsIO.dll. Provider return, INIBIN content/fallback, populated destruction, Rust integration and UI rendering remain pending.
