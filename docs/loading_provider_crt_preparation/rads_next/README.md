# Next step: original x86 RADS module

Static preparation only. No DLL is loaded, no DllMain or export is executed, and no module handle is returned by this package. The preceding execution evidence remains frozen in `loading_provider_crt_integration`.

Original `RADS/RiotRadsIO.dll`: SHA256 `60833cd552d93b93304d4937912951e144e38db5d70793eb60a0c5f5d579e521`, x86, preferred image base **10000000**, SizeOfImage **1AC000**, entry **100F2C22** (RVA F2C22). Five sections: .text, .rdata, .data, .rsrc, .reloc. The inventory records exact raw/virtual extents and permissions. There is no PE TLS directory and no delay-import directory; this does not rule out dynamic CRT TLS/FLS initialization. The relocation table has356 blocks/30,620 entries including padding entries. Mapping at the available preferred base avoids relocation changes for the first profile; any other base requires correctly applying supported relocation types and rejecting the rest.

There are210 imports across KERNEL32(153), USER32(5), ole32(1), OLEAUT32(1), ADVAPI32(6), WS2_32(28), WLDAP32(16). Import resolution must not execute all imported functionality: an unknown reached call remains a stop. The presence of socket, thread, delete or registry imports is not authorization to perform them. Existing isolated filesystem permissions remain source reads and private Config/Logs writes; exact local diagnostic pipe open has no IPC payload permission.

Use one Unicorn machine with the existing EXE/CRT/objects. Validate nonoverlap, map headers/sections and zero-filled tails at10000000, bind each import to a tracked boundary, preserve instruction provenance for both PE images, and invoke the genuine entry with `(mapped_base, DLL_PROCESS_ATTACH=1, reserved=0)` on an isolated emulator stack. No native x86 function is a host ctypes callback. Exports and HMODULE become usable only after the native entry returns success; interruption/failure must preserve partially initialized ownership rather than pretend a successful Windows load. Normal detach/shutdown requires its own qualification.

## Original EXE order

`953480` constructs the DLL path and current working-directory buffer. At953524 it calls `9529B0` with ECX=path, EDX=current directory and three stack words. `9529B0` clears module global2D7118C, calls LoadLibraryA at9529F4, then publishes the returned handle at9529FA. This is the current native stop.

On a nonzero module, GetProcAddress results are published sequentially at2D77890..2D778B4 for: RadsInitialize, RadsSetLogger, RadsFileExists, RadsOpenFile, RadsCloseFile, RadsGetFileSize, RadsRead, RadsFindFirstFile, RadsFindNextFile, RadsFindClose. Exact literal addresses and globals are in `EXE_resolved_export_slots`.

At952C6F it calls **RadsSetLogger(10DE968)**. The DLL implementation1003E210 stores the borrowed EXE logger pointer in101998E0 and immediately calls the callback at logger+44; this cross-image callback must remain genuine. Then952C81 calls **RadsInitialize(108B5EC, stack_arg2, stack_arg3, current_directory)**. This DLL's export1003E3D0 reads only argument4, calling1003E250 with ECX=1019846C; do not infer semantics of the unused words. The EXE marks2D778B8=1 only after the result is nonnegative. A cached nonzero module follows a different branch and must not be initialized again.

DLL entry100F2C22 performs cookie initialization100FF70C for process attach, then calls100F2C45. These bodies, static initializers, CRT lock/TLS state, actual archive open and logger callback lifecycle still need execution. DLL static CRT globals must remain distinct from the EXE CRT globals even when both use the same real host services.

Export addresses: RadsInitialize1003E3D0, RadsSetLogger1003E210, RadsOpenFile1003DF10, RadsRead1003E170, RadsShutdown1003E3F0. The inventory contains all13 exports; none is a forwarder. RadsShutdown clears globals10198470/1019846C and releases shared ownership; this static fact does not establish complete CRT module destruction.

Search of current repository Rust/Python sources found no implemented/qualified RadsInitialize or RadsOpenFile loader. `tools/record_game_service_lifecycle.py` already records the real DLL's path/hash and warns against blindly executing copied DLLs; it is a prior dependency pointer, not loader qualification.

Frozen test caveat for the next copy: `test_logs_bridge.py` should require attributes != FFFFFFFF before checking directory bit16. The source Config directory was independently confirmed to exist, so this test-expression weakness does not change the recorded native result. Do not modify the frozen prior lot to correct it.
