# Windows loading consumer adapter preparation

Prepared in scratch only. No Rust compilation, Cargo command or Windows test was run for these new files.

Install `audio_replay_windows_loading.rs` and its `_tests.rs` beside the existing Windows transport modules. Apply the small `integration.patch`: declare the child module, delegate packet95 `receive_payload`, and call the loading preflight from the existing decoded event95 preflight. The complete receive-file copy is a review aid, not an instruction to overwrite concurrent root changes.

The root-owned adapter must supply `Backend::loading_clock_f32_bits() -> Result<u32, &'static str>` and `audio_loading_metadata::Boundary` (including real key resolution). The supplied service-name boundary verifies 72AD90, acquires a separate eight-byte temporary and calls `audio_loading_metadata::service_name(b, out24, key, scratch8)`. Metadata acquires/releases the real parent shared pair; no host-generated name is substituted.

The target dispatch admits 57D650 and 5B3230 only. Unknown targets return an explicit error without reading payload. Standard first-record UI remains the generic consumer's explicit unsupported error. Hot standard records and tutorial records use the same native-qualified generic consumer and tree implementation.

The preflight runs under the existing launch lock before source context writes, activation, or scratch allocation. A null global wrapper object preserves native577E90's payload-free success. A nonnull wrapper whose recipient method is one of the two connected consumers requires 30 packet bytes: native58A6F2 passes `packet+5` even for an extended FE header. Unknown methods retain their own explicit error; no invented payload minimum is attached to them. Invalid wrapper/recipient/table reads fail before runtime mutation.

Three Windows tests are prepared against the actual `Application`, `Runtime` and `Backend`:

- 48 compact/extended hot packets over standard/tutorial trees, three key profiles, four full flag bytes. Tree construction/insertion are real; whole record bytes, context, stable live allocation count and complete teardown are asserted.
- 96 truncated packet cases with connected recipients. Context, tree header, global pair, allocation/release records, owned labels and scratch pool/cursor must all remain unchanged. Null-global compact five-byte and extended seven-byte source paths remain accepted.
- Missing standard record inserts/copies through native ports and returns the explicit absent-UI error. Retry must not insert or leak another record. Unknown recipient and name-method targets fail without accessing null payload/output pointers. All diagnostic storage is freed and runtime allocation count must reach zero after shutdown.

Recipients, one-slot method tables and borrowed wrapper bindings in these tests are explicitly diagnostic memory. The tests do not call or qualify the full UI factories, recipient constructors, publication ownership or normal gameplay initialization. Only record trees are constructed using source ports. Global control is explicitly null; no shared-ownership claim is made by this adapter test.

Required native image addition for a missing tutorial key is byte14C758B, already identified by the sibling tree port. The root's name-provider/clock image regions are separate dependencies. No normal runtime automatically creates a diagnostic receiver.

Qualification is pending root integration and actual Windows execution. The earlier generic consumer proof (4 tests, 1600 existing records, 256 tutorial caller contracts and 26 physical x87 conversions) is frozen separately under `loading_consumer_agent` and is not relabeled as this Windows test result.
