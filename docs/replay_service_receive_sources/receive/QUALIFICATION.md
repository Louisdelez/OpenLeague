# Isolated Rust qualification completed

The archived preparation remains unchanged. On this follow-up, a13-module standalone rustc harness compiled successfully using the current12 production dependency modules read-only. The two new receive tests passed;25 dependency tests were filtered. No cargo command, production edit or production integration was performed.

`test_receive.log` records **2 passed,0 failed**,0.07s. `compile_receive.log` contains only existing dependency unused-import/dead-code warnings. `qualification_manifest.json` records exact source, test, oracle, executable, harness, log and production dependency hashes. Both proposed source files are byte-identical to the archived preparation.

## APIs ready to integrate

- `audio_replay_service_receive::receive(b, service, context, packet, scratch) -> Result<u8, audio_announcer_owner_metadata::Error>`:72B2F0.
- `invoke_virtual(...)` with the same arguments:738A3A virtual slot+34 checked against72B2D0 before forwarding.
- `packet_target(b, event:u16) -> Result<u32, Error>`: source588290 switch classification only; default58830A is provenAL0. Other targets require a real consumer.
- `Boundary`: existing Storage, RemovalBackend, PendingBoundary, ConsumerBoundary plus `packet_fallback(event, packet, context)`. No new allocation or actor semantics are hidden behind this trait.

The caller supplies24 writable scratch bytes disjoint from packet/service/live allocations. Descriptor12 at+0 and activation12 at+12 preserve their two trailing padding bytes. Context is opaque32-bit data, not a length; no packet-size validation is added or claimed. Service is the full base for Rust activation/dispatch APIs, which perform native+C/+18 adjustments internally.

## Exact executed tests

`audio_replay_service_receive_matches_native_registry_effects_and_rejects_unported_packet95`:128 native return values matched across8 complete service-member and owner-metadata lifetimes. Complete live allocation bytes, allocation/free order, all392 service bytes, callback actor calls and general fallback calls match the native oracle. The16 opcode95 paths deliberately return `UnknownCallback(0x58A6F2)` in Rust, while retaining native registry/service effects. They are explicit unsupported cases, not16 implemented native returns.

`audio_replay_service_receive_filtered_headers_need_no_packet_owner_or_fallback`: DD succeeds with only its one readable header byte and no service access; a disabled ordinary event does not read owner/global/scratch or invoke fallback; an unknown virtual target returns an error.

## Runtime data and integration dependencies

Direct receive requires global2D62878, service byte184, service u32+5C, and service.vtable slot+34=72B2D0 for virtual invocation. Header/owner words may be unaligned. The optional source-backed fallback classifier requires58C1AC length496 and58C39C length301 (797 bytes total). Source bytes are archived in `replay_service_packet_sources.json`; do not regenerate them from assumed mappings.

The reused registries require caller-owned service+C pending vector, service+18 compound registry and service+38 owner registry, with the existing native constructors/lifetimes. Native owner metadata lifecycle/callback ports retain global2D787B8 (service),2D5F448 (owner sentinel),123B12C (constructor default), metadata vtables10A0360..10A038F and callback vtable1086078 (12 bytes). Service slots+84/+88 dispatch registration/removal and+B0=718AD0 supplies the spectator byte122. Allocation/free boundaries must preserve the existing engine/pointer-array behavior.

Four existing consumers were reused unchanged:6B27A0/6B27D0 clear owner metadata flags36/37 and invoke borrowed actor VT+24/+2C when the service gate is zero;6B2800/6B2850 set/clear bits in metadata u32+40. Actual actor bodies remain a simulation dependency. The general588290 nondefault handlers remain explicit boundaries; packet95 is being handled by the sibling assignment and can be integrated separately once qualified.

This receipt does not change root's803 production tests or10 CLI commands. It establishes two new isolated tests only. Source-tree changes after this receipt, including the future packet95 connection, require their own validation.
