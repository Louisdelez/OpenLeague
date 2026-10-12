# Temporary String24 ownership repair — preparation only

This directory is a new, isolated proposal. Production and the frozen `loading_standard_prefix_port` stage were not modified. No Rust compiler or Rust test was run for this proposal. The ordinary loading UI is not completed or enabled by it.

## Defect and scope

The previous reusable assignment helper can release the old heap, fail while publishing the new String24 fields, and then return to a caller which destroys the partial descriptor. That caller can free the old heap a second time, or lose the new heap after helper-local cleanup. Successful native lifetimes do not qualify this failure path.

The new `audio_loading_owned_string.rs` is restricted to an exclusive, caller-owned temporary returned successfully by the name provider. It does not reset or repair persistent metadata cache entries. It implements offset 0/count MAX assignment with valid, non-alias input strings. Identical descriptor addresses must be skipped by the caller. Invalid strings, length exceptions, allocation fallback/SEH, panic and process abort are outside this proposal.

## Concrete API

`Boundary: audio_replay_metadata::Boundary` adds an explicit `release_owned(pointer, route)` contract: a returned error retires nothing; success retires exactly that allocation. No blanket implementation assumes that every existing `free` implementation meets this contract. Allocation errors must publish no allocation; successful allocations must be nonzero, fresh and disjoint.

- `Temporary::new(address)` transfers ownership after the successful name provider, without reading or changing memory.
- `assign_owned_non_alias(backend, &mut temporary, source)` performs assignment while preserving cleanup authority.
- `temporary.retire(backend)` attempts cleanup and retains any ownership whose retirement fails.
- `finish(backend, temporary, primary_result)` returns either the value or `Failure { primary, cleanup, remaining }`. Both errors remain separate, and `remaining` carries live ownership. It must be retained, not merely formatted into a string.

`Temporary` is not `Clone` and has no automatic `Drop` which might perform a second retirement. `#[must_use]` is a diagnostic, not a substitute for the caller integration described in `CALLER_INTEGRATION.md`.

## Ownership transitions

| State | Cleanup authority | Invariant |
| --- | --- | --- |
| Original | Descriptor | Old descriptor is valid and owns its heap, if any. |
| New allocation / old copy | Descriptor plus independent pending pointer | Both heaps are live; failure frees the pending allocation and then the old descriptor allocation. |
| Old retirement completed | Detached new pointer | The ownership switch contains no fallible host operation and occurs before the first descriptor publication. |
| Partial publication / source copy | Detached new pointer | Cleanup never reads the possibly mixed descriptor. |
| Assignment completed | Descriptor | All fields and terminator are valid; ordinary native cleanup order is restored. |
| Cleanup failed | Remaining guard | Only the unsuccessfully retired ownership remains; explicit retry requires the atomic release contract. |

Successful standard cleanup does not reset the stack descriptor. Failure cleanup also leaves its exact partial bytes intact. The caller discards this exclusive temporary after its ownership is retired. Neither behavior is a cache rollback.

## Native success order versus host error adaptation

Source PE SHA-256: `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.

`564AF0` (288 bytes) reads the original destination capacity at `564B66`, passes the old length at `564B6D`, then enters `564F30` (407 bytes). The growth helper reloads capacity at `564F71`, allocates and copies the old bytes, then reads capacity/deallocator/old pointer before release. Publication follows `56509D` byte zero, `5650A0` pointer, `5650A2` capacity, `5650A5` old length and `5650AF` terminator. The final ordinary assignment reads capacity at `564BCB` **before** publishing length at `564BCF`, then selects the character pointer and writes the NUL. The candidate preserves this read order; it does not copy the old helper's reversed final read/write order.

The out-of-band ownership states and returned failure envelope are a host error adaptation. They are not claimed to reproduce native C++ exception unwinding. Native successes and injected host failures are deliberately separate qualifications.

## Evidence and proposed checks

`prepare_fixture.py` was executed successfully. It checks the frozen original oracle SHA and derives `loading_owned_string_probe.json`: 128 existing native caller lifetimes, comprising 96 actual override assignments and 32 empty-override skips. No new PE execution occurred in this preparation. The derivation records which descriptor/padding/heap bytes are exact snapshots and which fresh poisoned tails are reconstructed from the explicit input contract.

Four Rust tests are written but **not compiled or executed**:

1. Compare all 128 success cases against descriptor bytes, target heap bytes, allocations, assignment/cleanup frees, and final native capacity-read order.
2. Inject all eight writes after old retirement for both fill 00 and A5: 16 failure scenarios. Check exact partial descriptor and new-heap bytes, one old free, one new free, no descriptor read during detached cleanup and unchanged borrowed source ownership.
3. Combine failed capacity publication with failed new-heap cleanup; preserve primary and cleanup errors, retain the new allocation, then explicitly retry its retirement.
4. Fail old-buffer copying or old-buffer release before transfer; verify the original descriptor and both owners survive until cleanup.

An independent read-only review by `replay_path_registry` found no ownership gap or double release in `pending`/`Detached`/`retire` under the stated atomic-release contract. It also confirmed the corrected final capacity-read order. That review did not execute tests. The subsequent additional exact-byte assertions are also unexecuted.

## Reachability in the current Windows backend

This is a real generic fallible-boundary defect. It is **not a demonstrated normal Windows runtime failure** for a valid, exclusive descriptor in a healthy bank.

`audio_replay_windows_transport.rs` writes through `OwnedMemory::write`, which validates the complete range before `copy_from_slice`, with no allocation or callback. A returned write error makes no change. The Standard free path checks ownership, releases memory and removes ownership under one bank lock; a returned release error occurs before retirement. `event_temporary` holds its scratch allocation through the callback, and delivery holds the launch lock. There is no identified ordinary returned error at these writes while those preconditions hold. Invalid addresses/ranges and bank poisoning are exceptional violations; panic/OOM during the release log append is not a transactional `Err` and is not handled by this proposal.

## Integration status

Not ready for production integration. The proposed helper and four tests must first compile and pass. The caller must also carry the ownership-aware error and keep its scratch storage alive when cleanup fails. The existing `event_temporary` always releases scratch after the callback, and `Backend::failure` converts errors to a log string; neither can safely carry a descriptor-authoritative remaining guard unchanged. See the precise proposed caller and scratch lease changes in `CALLER_INTEGRATION.md`.
