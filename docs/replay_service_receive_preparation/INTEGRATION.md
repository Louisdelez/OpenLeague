# Proposed service packet receive port

Source-only handoff during root compilation. **Rust has not been compiled or tested for this new module.** Native Python oracle passed144 wrapper calls over8 complete service-member/metadata lifetimes. See `AUDIT.md` for exact source behavior, known effects, dependencies and limitations.

Files to stage:

- `audio_replay_service_receive.rs` and `audio_replay_service_receive_tests.rs` beside existing core modules; register the new module in lib.rs.
- `replay_service_packet_probe.json` and `replay_service_packet_sources.json` as data/4.20 fixtures.
- `probe_service_packet.py` and `extract_packet_sources.py` as provenance generators (adjust scratch output/source paths on production integration).
- `packet_switch_map.json`, `allowed_packet_branches.txt` and `AUDIT.md` as audit evidence.

The old `packet_sources.json` is an identical archival copy of the source fixture at handoff; the named fixture consumed by tests is `replay_service_packet_sources.json`.

## API

`receive(b, service, context, packet, scratch)` implements72B2F0. `invoke_virtual(...)` adds738A3A's source vtable+34 validation and the72B2D0 forwarding wrapper. Both return `Result<u8, audio_announcer_owner_metadata::Error>`.

`Boundary` extends Storage + RemovalBackend + PendingBoundary + ConsumerBoundary and adds `packet_fallback(event: u16, packet: u32, context: u32) -> Result<u8, Error>`. It invokes existing `audio_announcer_service_activation::{activate,dispatch}` directly, so handlers are real ports and may allocate, free, mutate metadata and reach the existing borrowed-actor boundary. The future production fallback must execute qualified588290 branches or return an explicit error. No successful generic fallback is provided.

Caller-owned scratch24 bytes: descriptor+0..11, activation+12..23. Preserve bytes+10/+11 and+22/+23 as opaque stack-padding inputs. All other fields are written by the relevant native ports. Scratch must not alias any live allocation, service or packet. Context is not a packet size. Packet pointer is never shifted when forwarded to registry consumers or fallback.

`packet_target(b, event)` reads original588290 switch tables and returns the exact branch entry. Out-of-range and default codes return58830A, which is proven AL0/no packet-specific effects. Nondefault target identity is not execution. If using this optional classifier, supply image regions58C1AC length496 and58C39C length301. The receive path additionally needs global2D62878 and service.vtable slot+34=72B2D0. Existing registry/metadata ports retain their existing vtable/global requirements, including service VT+84/+88/+B0 and owner metadata callback tables.

## Prepared tests (not yet executed)

`audio_replay_service_receive_matches_native_registry_effects_and_rejects_unported_packet95` intends to compare128 native return values, complete owned live bytes, all392 service bytes, allocation/free order, actor boundary calls and fallback dispatch across8 lifetimes. The remaining16 native opcode95 calls deliberately return `UnknownCallback(0x58A6F2)` in the Rust test boundary; their registry/service effects are compared, but their native AL1 is not represented as a implemented consumer. Full source0x95 executes only in Python with its source-empty global pair.

The second test covers early filtering with only one readable packet byte, no owner/fallback reads, and rejection of an unknown service vtable target.

No actor-body simulation, full switch port, actual live replay delivery, native exception unwind or concurrency is claimed. Native fixtures use supplied allocator/copy primitives and actor virtual operations; all intermediate registry and four metadata consumer bodies execute unchanged.

Pre-format hashes:

| File | SHA256 |
| --- | --- |
| audio_replay_service_receive.rs | 2a950b0365e40d9751e877a40e7b627190b131d650e4808f68c45850dfd806ba |
| audio_replay_service_receive_tests.rs | d9f449a7a28bfe16e9d92c9e7879c68ec29e51708e7b2c4c8c69926d6e213b98 |
| replay_service_packet_sources.json | 6c79a459004c9d7f9d9d5850e1c49fe0326858bed314355d14591573cc0fbc68 |
| replay_service_packet_probe.json | 9038da51847c951a1d5020c98c64c004dbc13d678d67cc9ac6106488cd1d95ee |
