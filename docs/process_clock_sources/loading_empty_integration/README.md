# Standard loading consumer: real empty metadata name

This stage contains four complete candidate Rust files, a minimal unified patch,
and the unchanged native fixture needed by their tests. Production and previously
frozen evidence have not been modified. Rust compilation and tests have not run
for this stage; integration acceptance remains pending.

## Behavior and API

`audio_loading_screen_packet::receive` retains its signature. Its standard
first-name branch now loads the global service, then the payload key, then the
vtable method48, and invokes the existing real service-name boundary. An empty
String24 skips the remaining UI and clock and completes after native57DCAE
cleanup. The nonempty branch still returns the explicit unavailable-UI error,
now identifying57D6FE, and destroys its name even on that error.

The standard stack-string cleanup reads capacity and, for a heap string, the
deallocator route and pointer, then frees. It does not reset string fields.
Tutorial564900 retains its existing reset of capacity, length and first byte.
Both failure paths retain the existing combined `Error::Cleanup` contract.
The service-name provider continues to own rollback if it returns an error.

`Boundary::initialize_standard_record` is unchanged in type but its contract now
receives an already constructed, nonempty String24 at scratch. The caller owns
that string and destroys it after the continuation, including on error. The
default remains an error; no standard UI result or resource is synthesized.

`NAME_SCRATCH_BYTES=24` is added. `TUTORIAL_SCRATCH_BYTES` remains an alias for
compatibility. The Windows adapter uses the common constant. The current clock
implementation and its files are not changed. There are no new native image
regions, globals, imports, modules, or production boundary implementations.

## Evidence and candidate tests

The frozen native oracle is copied from
`E:\mapslol3v3\loading_standard_empty_agent\standard_empty_name_probe.json` to
`loading_standard_empty_name_probe.json`. Install that identical file as
`E:\OpenLeague\data\4.20\loading_standard_empty_name_probe.json` when integrating.
Its SHA256 is
`fcae9c7cd40de101e6c75d7d6255fb09492202c9b862bc56599169b4c0d29538` (4,009,288 bytes).
The existing fixture loader reads it; no loader registration is required.

Its original PE execution covered16 lifetimes/64 consumer calls, fill00/A5,
four empty-name profiles, flags0/1/128/255, empty and retained heap caches,
reference counts and full teardown. It used real57D650,72AD90,728410,
729EC0/729730/738AC0/8F8CF0,72C780,7285B0 and actual parent/index controls.
Original executable SHA256:
`402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.
The exact authoritative hash is also copied from the oracle in the stage
manifest. No new PE execution is claimed by this stage.

The generic test file now contains6 tests (4 existing,2 added):

- `audio_loading_screen_packet_standard_matches64_native_empty_name_calls`
  compares all arena bytes, normalized ordered record/string caller operations,
  exact native returned String24 bytes and the global-before-key read order.
  Its explicit provider boundary replays the native returned string; this
  alone is not a provider integration test. UI and clock call counters stay0.
- `audio_loading_screen_packet_standard_drops_name_after_unsupported_ui_without_reset`
  covers short/heap nonempty names, cleanup failure and provider failure without
  reading an uninitialized output. These error cases are candidate Rust checks,
  not newly executed native error-path evidence.
- The existing unavailable-UI check now supplies a nonempty name so its intent
  remains valid. The tutorial cases and existing-record oracles remain in place.

The Windows test file now contains4 tests (3 existing,1 added):

- `audio_replay_windows_loading_standard_matches64_empty_names_through_real_metadata`
  uses the canonical parent, real index/control construction, real object/text
  producers, actual name getters and packet dispatch. It checks all120 record
  bytes for all64 native payloads, unchanged allocation/free counts, references
  returning1 to1, retained cache capacity/buffer and complete application cleanup.
- The existing missing-UI test now produces a real nonempty heap name and checks
  that each failed attempt releases exactly its output allocation. It also keeps
  explicit unsupported-target assertions. Truncation and48 hot-packet tests are
  retained.

The Windows fixture binds a diagnostic recipient, constructs a real record tree,
and seeds each recorded120-byte input so both native padding fills are compared.
It explicitly constructs/publishes the actual object index as the native oracle
does; normal stream startup and loading-screen factories are not being claimed.
For the long cache, the Windows test uses real object/text producers plus a name
query, whereas the oracle seeded the cache using native564C20. The live cache
layout/ownership and empty-name results are tested, not identical setup traces.

## Integration and limits

Copy the four `.rs` candidates to the corresponding existing core source files,
and the fixture to the data path above. Review `changes.patch`, especially any
concurrent source changes recorded against `baseline.json`. Then format, compile
and run the6 generic and4 Windows tests, followed by the root qualification chain.
These files must not be reported integrated or validated before that execution.

Remaining nonempty standard UI, resources, factory/global lifecycle and real
network/gameplay completion remain outside this stage. No provider result,
clock value, texture or UI behavior has been added as a fallback.
