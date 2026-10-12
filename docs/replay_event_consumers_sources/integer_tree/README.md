# Metadata state tree: qualified scratch port

Frozen code: `audio_replay_metadata_state.rs` and `audio_replay_metadata_state_tests.rs`. The patch adds these two files only. Integration additionally needs `pub mod audio_replay_metadata_state;` in core `lib.rs` and the fixture `replay_metadata_state_probe.json` at `data/4.20/`. No production file or Windows consumer was changed by this agent.

The module reexports the existing `audio_replay_metadata::Boundary`, adding no host requirement. Its own `Error` represents read/write/free errors, address overflow, invalid traversal, failed24-byte allocation and capacity overflow.

```rust
value_slot(b: &mut impl Boundary, tree: u32, key: u32) -> Result<u32, Error>
mark1(b: &mut impl Boundary, metadata: u32, key: u32) -> Result<u32, Error>
mark2(b: &mut impl Boundary, metadata: u32, key: u32) -> Result<u32, Error>
```

`tree` is metadata+0x18. Existing keys return node+0x14 without allocating or changing the value. A missing key allocates24 bytes, initializes only the original fields, preserves padding14/15, and inserts a zero-valued slot. The two wrappers write1/2 and return the same slot pointer. None of these operations locks metadata. The containing metadata lifecycle retains ownership of the tree and its sentinel.

Source correspondence:

| Source | Port behavior |
| --- | --- |
| 64D040 | Unsigned lower-bound search, retained hint, existing-slot fast return |
| 661F80 / 5D54A0 | Allocation24, three sentinel links, zero color/nil bytes, key and zero value |
| 663240 | Hint at minimum/end, predecessor/successor insertion, fallback |
| 5DA5E0 | Capacity0x0AAAAAA9, pending-node free before length_error, links/extrema/count, red-black repair |
| 5C64E0 / 5C6540 and5DA695 / 5DA71F | External and inline left/right rotations |
| 5DA8C0 | Fallback unique insertion, freeing the newly allocated duplicate |
| 5CCFE0 / 5C23E0 | Predecessor/successor, including header++ identity and header-- maximum |
| 728A40 / 728A60 | Write1/2 and preserve returned value-slot address |

The rotation/link layout matches the existing diagnostic path registry. This module retains the metadata source's hinted insertion and fallback order, rather than substituting the registry's simplified search-and-insert path. `metadata_state_sources.json` contains12 exact PE regions totaling1,878 bytes with individual SHA256 values; the native PE SHA is `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. These regions are evidence and were not installed into an executable image.

Native qualification executed20 complete parent lifetimes, both allocation fills00/A5, with252 operations:78 direct64D040,76 mark1,76 mark2 and22 direct hinted-insertion dependency calls. Another456 native iterator calls cover all final nodes and the sentinel. Profiles include ascending/descending insertion, both zigzags, unsigned boundary keys, repeats, valid/invalid hints, duplicate fallback, max_size-1/max_size, default/custom free and null allocation. Four cases reach the genuine CE0C22 length_error boundary after freeing the pending node; two reach CE0B9F bad_alloc. The expected `failure_pc` lines in `metadata_state_native.log` are those six observed exception boundaries. MSVC unwinding was not simulated.

The final isolated Rust harness passed5 tests, failed0, filtered8, in0.19s:3 new state-tree tests and2 existing metadata lifecycle regressions. It compares complete owned block bytes, native allocation/free order, custom callback/context, returned pointers/values, iterator results and lock events. Metadata destruction releases every owned node/sentinel/object; native parent destruction then leaves no owned block. `metadata_state_receipt.json` records source, fixture, script, executable and log hashes.

Capacity tests explicitly seed the count near the native limit; they do not allocate millions of nodes. Single-thread OS and allocator primitives are supplied; every tree body and rotation executes from the original PE. Concurrent mutation, custom allocators changing tree/key contents, corrupt parent links during repair and exception unwinding remain outside this qualification. No service72B950, accessor729C80, live network/frame delivery or integrated core build is claimed here; root owns those consumers and integration.
