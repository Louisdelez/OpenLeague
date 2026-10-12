# Metadata text setters (scratch handoff)

Frozen source `audio_replay_metadata_text.rs` exposes `put_string_extra(b, metadata, key, index, source, extra, scratch)` for 7285B0 and `put_string(b, metadata, key, index, source, scratch)` for 728830. The existing `audio_replay_metadata::Boundary` and `Error` are reused. `SCRATCH_BYTES` is 64. No production file was changed and no cargo command was executed.

The source is a readable native 24-byte string descriptor. For capacity below16 its bytes are inline; otherwise +0 is the byte pointer. Length is at +16 and capacity at +20. The caller owns this descriptor and any referenced buffer. Scratch must be writable and disjoint from metadata, source, tree nodes, globals and owned buffers. It need not be zero initialized. Source validity follows the original ordering: an old matching node is removed before any incoming text is read.

7285B0 copies the explicit string length, including embedded NUL bytes. 728830 ignores that length and scans to the first NUL. An adapter should preserve raw bytes, append a readable terminator, and must not interpret arbitrary native strings as necessarily valid UTF-8. The latter setter constructs a fresh string once then **moves** it through the temporary pair into the node; 5FE7F0 is a move constructor. It does not allocate three copies of a long string. Extra setter 7285B0 does make three copies.

Trees use exact native links, color/nil bytes and poison-preserving padding. Comparison is signed index then unsigned key. Replacement erases and rebalances before allocation of the replacement node. Rotations, successor transplant, root/min/max updates and the final blackening follow the original tree code. A custom string deallocator is allowed to change its global route before node release; the route is reloaded on that path, and map count decrements only after node release. The supplied callback mutation cases verify these observations.

## Validation

`test.log`: **3 passed, 0 failed**, standalone rustc harness, 10 unrelated tests filtered. The source and tests have been frozen for root integration. Local rustfmt returned Access denied; root may format the copied files.

- `replay_metadata_text_probe.json`: two complete native parent lifetimes, zero/A5 allocation fill, **408 original setter calls**. Per call, Rust matches allocation sizes/order, freed addresses/order, complete live metadata/node/string bytes and lock events. Cases cover signed index and unsigned key extremes, 0/1/15/16/31/64/128-byte text, embedded NUL, stored-length/strlen disagreement, root/min/max replacement, leaf/one-child/two-child replacement, and both-sided balancing. Final clear matches native freed order and leaves only metadata plus three sentinels in the Rust-owned subset. Original native parent shutdown separately retires all parent-owned allocations.
- `replay_metadata_text_custom_probe.json`: **16 complete native parent lifetimes, 32 setter calls**, short/long replacements in both maps and both fill values. The supplied custom deallocator changes A/context11111111 to B/context22222222 or standard. Native and Rust callback addresses, contexts, freed pointers, map counts and node capacity at release agree. The test saves capacity before retirement; it does not read released Rust storage.
- A separate negative test aliases the incoming source to the node being replaced. The erased storage becomes unreadable and the port returns a read error while releasing the metadata lock. Native dangling-read exception behavior is not claimed by that test.

`metadata_text_sources.json` contains **24 raw PE code regions**, individually hashed against original PE SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. `extract_metadata_text_sources.py` verifies those raw bytes again. `native_branch_observations.json` reports selected executed instruction addresses rather than claiming whole-function branch coverage. In particular, the right-side red-sibling case at 5C4847 was not reached by the main fixture; other right-side rotation paths were reached. This is a stated test-coverage limit.

## Integration

Copy the module and its tests next to the existing metadata module and register it in lib.rs. Tests read both fixtures through `crate::audio_test_fixture`. No additional runtime PE regions are required for direct setters: data allocation/free and locks already pass through the metadata boundary. The metadata vtable must include the relevant slots if a separate consumer dispatches through it; vtable extraction is owned by root's consumer integration.

## Limits

The qualified contract covers successful native operations with valid owned tree structure and caller-provided strings/scratch. Native C++ OOM/length exceptions and their full unwinding are not ported; allocation failure or length overflow returns explicit errors, with local temporary cleanup. Arbitrary reentrant allocator mutation, concurrent mutation, malformed descriptor capacity/length combinations and invalid cyclic trees are not native-parity claims. A safety guard rejects detected cycles during search/extreme traversal. No consumer, file decoder, gameplay completion, Windows event integration or whole-game completion is implied by these standalone tests.

Frozen pre-format SHA256:

| File | SHA256 |
| --- | --- |
| audio_replay_metadata_text.rs | d50436d80996ac523eac43ee77a289fa14bd28572e7cb0a725b30732e0f0d7b2 |
| audio_replay_metadata_text_tests.rs | 8f915261eea689c5982d81fd64155ab52d37f08ecb71cb4e0b5f8ab8fef2c59a |
| replay_metadata_text_probe.json | a16838a3f346c035301531bee6ddb0e72cdfe3b8e5827875023b222f68d52a12 |
| replay_metadata_text_custom_probe.json | 4e7a769736bbf2e5dacf92a7dd00ede4adbf225aca227764916b125f8868582c |
