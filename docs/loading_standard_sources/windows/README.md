# Windows standard loading prefix and deferred String24 ownership

Scratch candidate only. No Rust compiler or client was run here. No production file or frozen preparation was modified. Root must compile and execute the prepared tests before calling this integrated or qualified.

## Files and integration

Copy the five Rust files into the core source directory together with parent_order's generic lot. The parent consumer returns `ReceiveFailure::{Operation, Owned}`; `Owned` may contain a live `Temporary` in `remaining`. The Windows wrapper does not format and drop that value until its ownership is either retired or stored with the lease.

Transport changes are limited to adding the `loading_retirement` child module, `Shared::loading_retirements: Mutex<Ledger<N>>`, its empty initialization, and `retire_loading_temporaries()` after transport worker drain and before game-manager/service/global teardown. A failed retry returns an error before `closed` is published. `Application::close` then retains its Runtime and reports `closed=false`.

The new public `Runtime::loading_retirement_snapshot()` returns active/pending slot counts, owned guard count, retained scratch bytes and ledger poison state. It does not run cleanup or sample a clock.

## Slot and lease lifetime

1. Under the ledger lock, choose a vacant slot or reserve Vec capacity and publish a Reserved slot before acquiring any descriptor or invoking any consumer.
2. Acquire32 canonical scratch bytes from the same bank/pool as event_temporary, publish a Live active record, and retain an Arc of that exact Shared bank. Bytes0..23 are String24; bytes24..31 are the prefix's shared-pair scratch. There is no extra fallible scratch closure around the typed prefix.
3. Run standard receive. Move the entire returned failure into the already-present record before conversion to a text error. Mark the record inactive.
4. If `remaining` exists, keep the guard, complete descriptor, typed primary/cleanup errors and bank alive. Do not re-read a partially published descriptor through another destructor. If it does not exist, release/recycle scratch and vacate the slot.
5. At shutdown, retry `Temporary::retire` through the explicit atomic release contract, then retire the lease. Keep the original failure and latest retry/scratch error in the record until retirement succeeds. Log each retry error by reference before returning it, so successful recovery cannot erase the earlier cause. Vacating the slot drops its Arc; no keepalive remains in Vacant or Reserved slots.

The Arc retained by an unresolved record is an intentional lifetime cycle. It prevents a caller that drops its last external handle after failed close from destroying a bank/CRT that still owns deferred resources. A successful retry breaks this cycle. If the last external owner is abandoned without a successful retry, the unresolved bank remains retained; this is not reported as successful closure. Arbitrary panic recovery and external memory corruption are not qualified.

Nested events reserve distinct slots and cannot reuse an active or deferred descriptor. Bank and ledger locks are never held across the user consumer. Settlement takes ledger then bank; acquisition releases bank before publishing into ledger. Normal game-event dispatch and Runtime shutdown already serialize through launch.

## Atomic release

`owned::Boundary::release_owned` is an explicit implementation for Backend, not a blanket impl. It supports Standard only, rejects unsupported routes or missing ownership before release, reserves the release-log capacity while the block is still owned, removes the block and removes its owned entry under one bank lock. A returned error means no block was released. Null is a no-op. Panic/abort are outside this returned-Result contract.

Lease release reserves pool and release-log capacity before removing its block, then reuses the existing Vec capacity without a post-release allocation. The lease stays in its runtime slot if reservation or release fails. Recycled descriptors are not counted as engine allocations and their temporary release-log entry is popped exactly as in existing event_temporary.

## Prefix and boundaries

The Windows initializer passes the actual service retained by the generic consumer, uses the real name/extra providers and owned assignment, and returns `Error::Boundary(stop.unavailable())` at991E60 or90AD00. It never reports a rendered or complete UI. Root supplies the original PACKAGE_GLOBAL2D78F1C image region. Tests publish an explicit diagnostic recipient and service binding; this does not qualify the missing normal screen factory/global producer.

The new guard path is standard-only. Tutorial still uses its earlier event_temporary and destructor behavior, wrapped by ReceiveFailure::Operation. Operation is not a universal promise of resource-free failure; tutorial cleanup, name-provider failure rollback before a guard exists, and persistent metadata-cache assignment retain their separate existing contracts. They are not silently declared repaired by this lot.

## Prepared tests

- `audio_replay_windows_loading_standard_prefix_uses_real_name_skin_and_owned_override_at_both_stops`: four real packet95 cases with SSO/heap source names, heap-growing overrides, real skin metadata and both explicit boundaries. Checks engine allocations/frees, live borrowed override bytes, metadata/index references, unchanged UI record name and no clock use.
- `audio_replay_windows_loading_deferred_descriptor_survives_nested_lease_and_failed_close_then_retry_releases_keepalive`: test-only ownership-map removal forces the explicit atomic-release error while physical bytes stay live. Checks primary and cleanup error preservation, descriptor retention/non-reuse, extra bank keepalive, failed close with closed=false, retry-error journaling, successful retry, exactly one free and keepalive removal. An unsupported Custom route must also preserve the block, its ownership entry and release-log length. This is an ownership failure injection, not an OS allocator failure claim.
- `audio_replay_windows_loading_nested_slots_do_not_reuse_active_descriptors_or_retain_successful_keepalives`: nested leases, distinct labels and stable final Shared strong count.

The existing64 empty-standard calls and4 tutorial clock calls are retained unchanged. The earlier missing-standard-UI test now initializes the diagnostic override fields correctly and expects the later90AD00 boundary. Core, Windows runtime, client build, CLI and actual UI qualifications remain separate.
