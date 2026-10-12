# Loading record trees: native and Rust qualification

The scratch module `audio_loading_record_tree.rs` ports the actual standard record map `5BE170` and tutorial record map `5BE1F0`. It executes the tree algorithms in Rust, including missing-key record construction and red-black insertion. It does not substitute lookup/insertion with a host result.

## Integration API

```rust
pub use crate::audio_replay_metadata::{Boundary, Error};
pub enum Kind { Standard, Tutorial }
pub fn construct(b: &mut impl Boundary, kind: Kind, tree: u32) -> Result<(), Error>;
pub fn record_slot(b: &mut impl Boundary, kind: Kind, tree: u32, key_ref: u32) -> Result<u32, Error>;
pub fn clear(b: &mut impl Boundary, kind: Kind, tree: u32) -> Result<(), Error>;
pub fn destroy(b: &mut impl Boundary, kind: Kind, tree: u32) -> Result<(), Error>;
```

`tree` points to the caller-owned eight-byte map header. Standard owners use `recipient+0x1C`, tutorial owners use `recipient+4`. `record_slot` returns `node+20`. Keys are unsigned 32-bit integers. The input remains an address: its value is read when the source reads it, including a constructor reload after allocation. A supplied allocator may change that key; the retained lookup hint then drives the real hinted insertion and fallback path. Existing records are preserved.

The existing metadata Boundary is sufficient. The module needs only its `Storage`, free backend and `read_byte`; it calls no lock methods. The caller supplies actual allocation/free boundaries. Node sizes are 140 (standard) and 96 (tutorial). Capacity limits are respectively `0x1D41D40` and `0x2AAAAA9`. A null allocation returns `Error::AllocationFailed(node_bytes)`. Capacity failure destroys the pending node, then returns `Error::Boundary("native loading record tree capacity exceeded")`.

The only additional canonical runtime byte needed is **`0x14C758B`, length 1**, present as `tutorial_construction_byte` in `loading_record_tree_sources.json`. Native `5D34F0` reads it before calling `5E3DA0`; that constructor does not use the passed byte, but the port preserves the read. The allocator/free globals are already represented by existing host boundaries. No new vtable region is required.

## Native evidence

Original client PE SHA256: `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.

`probe_loading_record_tree.py` maps the unmodified PE in Unicorn. Only allocator `9933E0`, standard free `C98528`, and explicitly supplied custom free callbacks are terminal host primitives. Tree, node, value, iterator, rotation, string destruction and tree destruction functions execute their original bytes. Unexpected code targets and accesses to retired/out-of-allocation heap memory fail the oracle.

Construction executes the real owner snippets `57CE5C..57CE72` and `5B2BF5..5B2C0B`, including sentinel functions `5C75C0`/`5C75F0`. It does not claim that the full screen constructors run. Standard values use `576000`; tutorial pair construction uses `5E3DA0`. Writes preserve node padding, SSO padding and the high seven bits of the record flag byte.

Destruction executes tree-only functions `57D1E0`/`5B3090`, the full-range branch of `5C36B0`/`5C3770`, and traversals `5C6C10`/`5C6D00`. The traversal is right subtree, current node, left subtree. Standard strings are destroyed at node offsets `0x74`, then `0x44`; tutorial strings at `0x3C`. The free callback is cached per node and reloaded after each custom string free. After clearing, the sentinel is freed; the caller-owned header retains its retired pointer, as native does.

The oracle completed **48 lifetimes, 480 record accesses, 484 native allocator requests that returned storage**, with **36 additional owned long-string buffers explicitly seeded as teardown inputs**. It executed 1,566 distinct instruction addresses and recorded **60,140 ordered byte writes**. These inputs are not provider/UI output.

Profiles cover fills `00`/`A5`, ascending and descending insertions, both zigzag directions, unsigned limits, repeated existing keys, allocator mutation of referenced keys, both capacity boundaries, allocation failure, long strings, free callback changes A→B→standard, and empty destruction. The native maximum count is seeded close to the limit, without allocating millions of records.

Observed insertion branches include both inline rotations, external `5C64E0`/`5C6540`, red-uncle recolouring, predecessor/successor `5CCFE0`/`5C23E0`, both unhinted fallbacks `5DB440`/`5DB710`, and duplicate-node release `5DB521`/`5DB7EE`. Detailed addresses and counts are in `coverage_summary.json`.

## Rust checks actually run

The isolated five-module harness compiled with rustc. **Three tests passed**, with 12 unrelated dependency tests filtered out:

- `audio_loading_record_tree_standard_matches_native240_calls24_lifetimes_full_bytes_writes_and_frees`
- `audio_loading_record_tree_tutorial_matches_native240_calls24_lifetimes_full_bytes_writes_and_frees`
- `audio_loading_record_tree_rejects_missing_tree_and_null_sentinel_without_fake_record`

Each native snapshot is compared with Rust for all live allocation bytes, the eight-byte header, returned record pointer/error, key mutation, allocation/free order, freed block bytes, free callback/context, and the exact ordered writes normalized to individual bytes. Final live ownership is empty. This checks structure and padding, not only logical values. All 480 record accesses, both exception boundaries and all 48 destructors are included.

The first harness compile diagnosed four ambiguous `write_word` trait calls in the test code; the calls were qualified and the final compile/test succeeded. `compile_tree.log` is diagnostic history only; `compile_tree_final.log` and `test_tree.log` are the final verification logs.

## Scope and limits

- No production source, cargo build or whole-game completion is claimed. Root owns integration and Windows verification.
- Only tree members are constructed/destroyed. Screen selection, full owner lifetime, graphics providers, resource handles and actual rendering remain separate contracts.
- Native exceptions stop at the actual `CE0B9F`/`CE0C22` throw boundary. MSVC exception unwinding and cleanup after arbitrary host read/write failure are not qualified. Such failures return an explicit error; the caller must treat the interrupted tree operation as failed.
- Single-threaded allocator key mutation is covered. Concurrent mutation or arbitrary allocator mutation of tree topology is not claimed.
- The portable code reuses the shape of previously qualified metadata-state helpers; this lot independently compares their complete loading-record effects with the original PE. No source value is inferred from another game's version.

Sources, tests and fixtures are frozen after qualification. No local compiler or test process remains running.
