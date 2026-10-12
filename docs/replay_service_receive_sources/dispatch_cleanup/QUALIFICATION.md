# Snapshot cleanup after a host boundary error

The scratch correction releases the owned callback snapshot when dispatch fails after allocation. It preserves the existing native success path: reload the source vector after allocation, copy it, invoke callbacks in order and OR their byte returns, re-read the current deallocator, free the snapshot, and return the accumulated byte.

All post-allocation reads, writes and callback calls now run inside a result-producing closure. A separate cleanup closure runs once whether dispatch succeeded or returned an error. A cleanup failure after success is an error. When dispatch and cleanup both fail, the new `audio_announcer_owner_metadata::Error::Cleanup { primary, cleanup }` retains both errors. This is a host error-handling contract; it does not claim to reproduce native C++ exception unwinding. Panics are outside this Result-based contract.

## Frozen integration files

- `audio_announcer_service_activation.rs`: corrected `dispatch`, plus the new test module include. `activate` is unchanged.
- `audio_announcer_owner_metadata.rs`: only the additional boxed `Cleanup` error variant.
- `audio_announcer_service_activation_cleanup_tests.rs`: four new tests.
- `cleanup.patch`: exact deltas to the two production module baselines, excluding the separate new test file.

The negative tests reconstruct a genuinely native activated graph from `replay_service_packet_probe.json`, with original PE regions from `replay_service_packet_sources.json`. They run the existing lookup and metadata callback Rust ports. The host injects an error at explicit boundaries; it does not supply successful registry or consumer results. The consumer-error test verifies that the real metadata flag update occurs before failure, that deallocator selection follows the failure, that a consumer-selected custom deallocator is reloaded, and that the source listener vector survives while the snapshot is released.

## Verification actually run

An isolated `rustc --test` harness compiled the two scratch modules, the frozen service receive proposal, and ten production dependency modules. No cargo command was run. Compilation completed successfully; warnings were an existing unused import and an unused constant in the isolated build.

Four new tests passed (`test_cleanup.log`, 0 failed):

- `audio_service_dispatch_cleanup_consumer_failure_releases_snapshot_after_real_metadata_effect`
- `audio_service_dispatch_cleanup_releases_snapshot_on_reload_copy_and_handler_read_errors` (three failure sites)
- `audio_service_dispatch_cleanup_preserves_primary_and_route_or_free_failures` (both cleanup failure sites)
- `audio_service_dispatch_cleanup_free_failure_after_success_is_not_a_success_result`

Three existing success regressions also passed:

- `audio_service_activation_dispatch_and_metadata_teardown_match8_native_lifetimes32_events` (`test_success_regression.log`)
- Both `audio_replay_service_receive_` tests (`test_receive_regression.log`), including 128 native return/effect comparisons and 16 explicit unsupported opcode95 errors in the frozen pre-integration receive proposal.

Seven distinct test functions passed in total. These are isolated results, not a production suite count. The new tests depend on the two packet fixture JSON files already delivered with the service receive proposal. No additional runtime PE image region is needed by this correction.

## Limits and ownership

The correction attempts cleanup once. If deallocator lookup or free itself fails, the snapshot may remain live and the error explicitly reports that failure. It does not retry a potentially partially completed free. It does not change ownership of callback entries, packet memory, or the source vector. Existing allocation failure, missing-descriptor, and empty-vector behavior is unchanged. Only host `Result` errors are covered; native allocator failure unwinding and Rust panics are not qualified.

No production files were written, and no native oracle was rerun for the injected error cases. Sources and tests are frozen; all local rustc/test processes have exited. Root owns production integration and its suite run.
