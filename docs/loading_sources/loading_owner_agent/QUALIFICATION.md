# Loading wrapper ownership: isolated implementation and native comparison

The proposed module implements source576280/576410 wrapper construction and destruction,5C74A0 sentinels, the whole-range5C2AB0 and recursive5C1ED0 string-tree destruction, fresh564C20 string copies, both shared-owner factories5D7750/5D7680 and their publication wrappers5C7E30/5C7D10, and control disposal5DDB80/5DDB70. It reuses the actual existing owner_control factory body and5D5B40/5D6840 control release, plus shared_pair reference release.

Native evidence is loading_owner_probe.json.48 complete constructor/destructor lifetimes cover fill00/A5, six language byte strings including ASCII case variants/non-ASCII/long allocations, two44-byte trees empty or explicitly populated, short/long string destruction, standard/custom frees and an explicitly supplied close/delete UI terminal boundary.96 publication cases cover global/internal destinations, old strong0/1/2 and weak1/2, successful/null control allocations and both free routes. All native owned allocations and supplied locks are retired.

The2 isolated Rust tests compare all live allocation bytes, allocations and free order, bytes observed at each free, lock events, both publication pairs and recipient boundary observations. The current receipt records compilation/testing separately from production integration. Tree population is fixture input to destruction: no tree insertion claim. UI close/delete boundaries in the oracle/tests record the call and retire the explicitly supplied fixture recipient; they are not original UI consumers.

## APIs and prerequisites

- construct(b, wrapper, scratch24) returns the original wrapper address. wrapper requires128 caller-owned bytes. scratch24 must be disjoint and writable. Constructor preserves opaque bytes, creates two44-byte sentinels, initializes the source24-byte string and the lock at+68, reads the language string through global2D78D08, and selects flag+5C using the original case-insensitive comparison with zh_CN. The C-locale path reproduces unsigned-byte ASCII folding. A non-default CRT locale is an explicit compare_locale_nocase boundary and remains unconnected by default.
- destroy(b, wrapper) does not free the wrapper. If byte+C is nonzero, it clears+C and global2D77E44 then calls the current recipient virtual+C. It destroys lock+68, tree+50 then tree+48, string+2C and the nested shared pair. It does not zero that pair after release.
- dispose_wrapper(b, control) reads control+C, runs the complete wrapper destructor if nonnull, then selects the current free route and frees the wrapper.
- dispose_recipient(b, control) reads control+C and dispatches recipient virtual+10 with scalar-delete flags1. Unknown UI must remain an error; slot0 is not a destructor.
- replace_control(b, pair, object, recipient) reuses source-identical owner_control::replace_pair_with_vtable. Old control release precedes pair publication. This low-level constructor requires a valid owning pair, and object ownership transfer must be supplied by the caller.
- publish(b, destination, object, recipient, scratch8) reproduces5C7E30 or5C7D10, including their distinct read order. destination is GLOBAL_PAIR for the global wrapper or the actual nested pair for a recipient. New control is published before raw object; both precede old control release, so callbacks see the new pair. scratch8 is a disjoint temporary. Raw object reuse without a valid ownership transfer is not authorized by this API.

Allocation-null controls preserve the original result(object,0); this does not constitute a successfully owned object. Tests explicitly retire the raw object afterward. Native constructor44-byte allocation failures and C++ unwind are not claimed. Normal-return destruction only: unsupported UI errors can stop destruction with remaining resources live. Do not call these paths in normal startup before source factories, providers, complete recipient teardown and shutdown ownership are implemented.

## Windows preparation (not compiled or integrated)

windows_adapter contains an additive integration.patch, a Backend implementation and one proposed Windows lifetime test. Existing core source files must not be replaced with older copies. The adapter dispatches the two concrete control dispose targets and reuses existing physical Windows critical sections. Native UI close/delete remains an explicit error. It publishes no language, screen or owner from normal startup.

CRT global14AE870 already lives in the application's CRT bank, inside initial region14AE5B0..14AF1AF. Never create a second type1 copy. The proposed fixed Bridge getter reads the current canonical context; the generic Boundary default reads the native word for standalone backends. Runtime image additions are supplied separately in windows_adapter/runtime_image_additions.json with exact PE bytes.14C761C/20 already exists and is not duplicated.

The proposed Windows test explicitly supplies a diagnostic language string, constructs an empty wrapper, publishes its genuine control, restores the global and destroys it. No recipient or screen is supplied. It checks all engine allocations and physical locks return to baseline. Its test globals and publication are confined to the diagnostic; this is not an application startup implementation.

The real producer of2D78D08, screen selection5765F0, factory resolution, renderer/providers, recipient close/delete bodies, global owner shutdown and full packet-driven UI remain separate work. A populated real wrapper must not be published using fixture callbacks.
