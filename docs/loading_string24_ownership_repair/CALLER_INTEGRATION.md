# Caller integration contract (not implemented here)

## Standard consumer

The production `audio_loading_screen_packet::receive` currently obtains the name, invokes an initializer returning `Result<(), &'static str>`, and unconditionally calls `drop_string(scratch)`. That is incompatible with partial assignment publication. Do not install this helper behind the old initializer signature alone.

Proposed narrow change, retaining tutorial behavior separately:

1. Keep the actual service pointer loaded before the key/name lookup. Pass that same pointer into the standard prefix; never read `SERVICE_GLOBAL` again for the extra lookup.
2. After `service_name` returns success, create exactly one `Temporary::new(scratch)`. Before success, the name provider still owns its own rollback contract.
3. The standard initializer receives `&mut Temporary` instead of merely `scratch: u32`, plus the retained service. Its prefix assignment calls the new ownership helper on that guard. Its return is `Result<(), metadata::Error>`; errors must not be converted to strings at this boundary.
4. Evaluate the ordinary standard body, including the initial name-length read, into a primary `Result`.
5. Call the new `finish(b, temporary, primary)` exactly once. **Do not call `drop_string` as well.** Empty names follow the same guard lifecycle and require no assignment.
6. Return a typed consumer error. One concrete shape is `ReceiveFailure::BeforeName(metadata::Error)` or `ReceiveFailure::Owned(audio_loading_owned_string::Failure)`. Only the latter can contain live string ownership. An ordinary error enum carrying just strings or `metadata::Error` is insufficient.

The initializer cannot report UI success by default. `991E60` and `90AD00` remain explicit stops as in the frozen prefix proposal. This change does not add UI resources or normal recipient factories.

## Scratch lifetime is part of cleanup ownership

The existing `Backend::event_temporary` calls the closure, then always releases its scratch block and returns the label to a pool. If a failed cleanup leaves `Authority::Descriptor`, later retirement must read the descriptor. Its bytes therefore cannot be released or reused yet. `pending` may independently own another allocation at the same time.

Use a scratch lease retained through the typed result. The proposed wrapper owns `(ScratchLease, Temporary)` when cleanup is deferred. `ScratchLease` contains the canonical block label, size, and identity of the bank which owns it; it is not just a borrowed integer. For simplicity, retain the scratch for every remaining guard, including Detached, although detached cleanup itself does not read the descriptor.

The wrapper must consume the owned failure before mapping it to the existing outer event error:

```text
typed_result = receive_with_owned_error(backend, scratch_lease.address)
if typed_result has no remaining ownership:
    retire scratch lease and return/report its result
else:
    move (scratch lease, remaining guard) into a runtime-owned retirement slot
    retain primary and cleanup errors separately in the structured failure record
    only then return the outer unsupported/error status
```

The retirement slot must already exist or be reserved before the fallible operation. A failed allocation while enqueueing cleanup must not drop the last owner. A caller-owned single slot reserved for the active event is sufficient if nested events use separate slots; an unreserved `Vec::push` is not a complete recovery contract. If there is no such owner, propagate the typed failure together with its lease to the caller instead of reducing it to a string.

The runtime close path retries explicit retirement only through the atomic-release contract, then releases the scratch lease. If retirement still fails, close must retain and report the unresolved owner; it must not report successful cleanup or discard the bank. This ledger/lease integration is deliberately not implemented or qualified by this preparation.

## Error reporting and retry

`Failure.primary` records the assignment/provider failure. `Failure.cleanup` records cleanup failure independently. `Failure.remaining` carries every still-live allocation. An error handler may format copies/references to the errors after moving `remaining` into its concrete owner. Passing the whole failure by value to the existing `Backend::failure(error, message)` currently formats and drops it; that would lose its guard and is forbidden.

`Temporary::retire` can succeed for one owner and fail for the other. It clears only ownership which retired successfully, so a retry cannot repeat the successful free. A failed descriptor read means the descriptor lease must remain live; a failed atomic free means the corresponding heap must remain owned. No blind descriptor reset or apparent rollback is performed.

## Deliberately separate work

The old helper in `audio_loading_metadata.rs` is untouched. Its cache callers have different lifetimes and cannot be repaired by treating their persistent cache descriptors as temporary stack strings. Service-name failure rollback, tutorial reset failure, arbitrary custom deallocator side effects, aliasing strings, native allocation fallback/SEH and panic recovery need their own explicit contracts. This proposal addresses only the newly reused standard-prefix assignment and its caller-owned temporary.

Before integration: compile and run the four proposed generic tests, add the typed consumer/scratch retention adapter and fault tests for deferred cleanup, then qualify the existing successful native caller cases through that adapter. No Rust or application test result is claimed here.
