# Loading-screen packet consumers, scratch qualification

Status: generic Rust caller qualified in isolation; no production or Windows adapter changes. This delivery does not claim a complete loading screen or game.

## API

`audio_loading_screen_packet::receive(b, kind, recipient, payload, scratch) -> Result<(), audio_replay_metadata::Error>` composes the real `audio_loading_record_tree::record_slot` and accepts its `Kind::{Standard, Tutorial}`. Payload exposes 25 bytes; tutorial scratch is a fresh, disjoint 24-byte String24 slot.

The boundary extends the tree/metadata boundary with:

- `service_name(service, target, out24, key_value)`: call the actual service virtual slot +48 and construct its returned String24. Success transfers cleanup responsibility to this consumer. On failure, the provider owns rollback of its partial output.
- `clock_f32_bits()`: return the final stored f32 bits from native 993CE0. This file does not implement QPC.
- `initialize_standard_record(recipient, record, payload, scratch)`: remaining standard UI continuation at 57D6CB. The default returns an explicit error after the native record update. No successful UI response is fabricated.

## Source order

Standard 57D650 looks up `recipient+1C` with 5BE170; tutorial 5B3230 looks up `recipient+4` with 5BE1F0. Both perform six ordered dword copies then one byte, test bit 0 of record+18 and clear record+10 if set. SSO length at standard+40 or tutorial+38 determines the next branch; it is not an asset-readiness flag.

For tutorial first-name lookup, the source rereads payload key before global service 2D787B8, reads its vtable and slot +48, and constructs a temporary String24. Nonempty output causes x87 copies record+10 to +44, +0C to +40, then 993CE0 to +48. A provider mutation oracle proves these reads occur after the provider call. Native 564900 destroys the temporary on both empty/nonempty successful provider paths: capacity test, deallocator selection before buffer pointer, release if heap-backed, then capacity 15, length 0, first byte 0.

The port also cleans a successfully constructed string when a later Rust read/write/clock boundary fails. A double primary/cleanup failure is retained as `Error::Cleanup`. Such Rust error paths are safety behavior, not a claim about native C++ exception parity.

## Evidence actually executed

- Frozen existing-record PE oracle: 1,600 calls, 800 per consumer, all 256 flag bytes, nine unsigned key boundaries, four payload patterns, fills 00/A5. Original consumers and lookups execute without provider adapters. Rust compares record bytes and the full 16 KiB host arena after each copy; only expected record bytes may change. The host adds synthetic provider addresses, so it does not claim equality with the oracle's whole-arena SHA.
- New tutorial first-name PE caller oracle: 256 calls and 7,136 ordered events. Original 5B3230, 5BE1F0, 564900 and security-cookie code execute. The service method, clock and CRT free are explicit boundaries. Cases cover empty/short/heap strings, both fills, flags 0/1/128/255, float patterns and provider-side record mutations. Rust compares output record, destroyed temporary, ordered caller reads/writes/calls and frees exactly.
- Physical x87 helper: 26 load/store cases on local AMD64 with masked control word 037F. Positive/negative signaling NaNs acquire the quiet bit; remaining f32 values preserve their bits. Unicorn does not correctly quiet signaling NaNs, so 32 potentially divergent caller cases are excluded from its fixture rather than labeled matching. Hardware results qualify the separate Rust conversion function. x87 status/exception-flag side effects and alternate control words are outside this port.
- Isolated rustc harness: **4 passed, 0 failed, 15 filtered**, 5.57 seconds. Compile exits 0. Only path-canonicalization warnings from the Rust launcher were emitted. No Cargo or production executable was built.

The 1,600 existing-record fixture and sibling tree proof remain unchanged. Missing-key insertion/rotations/constructors/destruction are qualified separately by the sibling tree module (48 native lifetimes, 480 calls, 3 isolated tests); the current consumer tests use existing records.

## Integration and limits

Required files: module, tests, `tutorial_first_name_probe.json`, `x87_copy_hardware.json`, and the existing frozen `replay_loading_existing_record_probe.json`. The harness resolves them from scratch for local testing; production fixture placement is the integrator's responsibility.

The real provider chain is being implemented by root: 72AD90 to parent 729C80, metadata 728410, virtual resolver 729EC0/729730 and object lookup 8F8CF0. This delivery exercises its caller contract, not that actual provider implementation.

Standard first-record UI remains explicitly unresolved. The static source calls the service slots +48/+4C, configuration 90AD00, 57C590 and texture/UI routines including 98A7F0, cached lookups 72E390/815CF0/5CE3A0, 98F2F0/9879D0, string helpers and diagnostics 991E60; it ultimately stores x87 fields at +50/+4C and time at +54. No replacement renderer or UI object is invented here. Complete source bytes are retained in the referenced source extraction for later branch qualification.

No Windows lifetime pool, global publication, render thread, network frame or visible loading-screen acceptance was tested by this scratch delivery.
