# Native replay metadata setters: next implementation lot

Source PE SHA256: `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.
All artifacts are scratch evidence, not installed source or completion evidence.

`metadata_setter_sources.json` contains 19 raw PE regions, per-region hashes and the full derived metadata vtable. `metadata_setters_disassembly.txt`, `metadata_containers_disassembly.txt` and `metadata_containers_extra_disassembly.txt` contain the disassembly. The complete `0x7285B0..0x7286CF` extraction is in the third file and raw JSON.

`probe_metadata_setters_audit.py` executes actual PE code through the existing metadata oracle prerequisites. `replay_metadata_setters_audit.json` passed two full parent lifetimes, with heap fills 0 and A5, and returned to zero owned allocations. It records 72 scalar setters, 360 getters, 64 text-map writes, 24 mark2 calls and two additional mark1-then-mark2 overwrite sequences. Existing allocator, memory-copy and single-thread lock primitives are supplied; none of the setters, string/tree helpers or destruction methods are stubbed.

## Exact public contracts

| Address / derived vtable offset | Inputs after ECX=this | Behavior and return |
| --- | --- | --- |
| `728150 / +08` | `id:u32, count:u32`; ret8 | Unsigned count>48 returns AL0 before locking. Otherwise locks this+1C8, stores count at +1A0 for id100 or +1A4 for id200, unlocks and returns AL1. Unknown id locks/unlocks and returns AL0 without writing. |
| `7281C0 / +0C` | `id:u32, selector:u32`; ret8 | No lock. Only the low byte of selector matters. Nonzero selects +1A0/+1A4; zero selects +1A8/+1AC for id100/200. Unknown id returns EAX0. |
| `7285B0 / +28` | `key:u32, index:i32 bits, string24:u32, extra:u32`; ret10h | Locks +1C8, finds and erases an existing composite key in map+08, then creates a new node56 and string/extra payload. Copies the native string by explicit stored length, preserving embedded NUL. Unlocks. No stable scalar result should be inferred from volatile EAX. |
| `728830 / +3C` | `key:u32, index:i32 bits, string24:u32`; ret0Ch | Locks +1C8, finds/erases composite key in map+10, obtains source char pointer through SSO/capacity, then scans to first NUL and constructs a new node48/string. The source string's stored length is not the resulting value length when NUL is embedded. Unlocks. |
| `728A60 / +5C` | `key:u32`; ret4 | No lock. `64D040(this+18,&key)` finds/inserts map24 value slot, then stores2. EAX remains that slot address. Native audit checks returned_slot == node+14h. `728A40 / +58` is identical with value1. |

Both string maps order keys lexicographically by **signed index first**, then **unsigned key**. `72E390`: JG/JL compare node+14 versus key+4 at 72E3B0, then unsigned JAE compares node+10 versus key+0 at 72E3B7. Do not use default unsigned tuple ordering or a simple key-only map.

The native count bound is 48 (`728164/728167`), not24. Yet the two fixed arrays occupy only24 eight-byte entries each: +20..+DF and +E0..+19F. The existing `729D70` copies according to these counts. Setter parity must preserve48; do not silently tighten it to24. Qualify count-driven packet copy separately with monitored native bounds before connecting arbitrary caller values. This audit intentionally does not invoke packet-copy at large counts.

## Containers and allocation order

All nodes use links left/parent/right at +0/+4/+8, color at +0C, sentinel flag at +0D. Bytes +0E/+0F remain allocation fill. A map is `[sentinel:u32,count:u32]`.

| Map | Node bytes | Key/value fields | Helpers |
| --- | --- | --- | --- |
| this+08 | 56 | key+10,index+14,string24 at+18,extra+30; final+34 remains fill | find72E390; erase5C4680; pair-copy7334D0; node734D70â†’735740; insertion734E40â†’735EF0 |
| this+10 | 48 | key+10,index+14,string24 at+18 | find72E390; erase5C4680; pair-copy733520; node734F80â†’663FD0; insertion734FC0â†’7360B0 |
| this+18 | 24 | unsigned key+10,value+14 | value_slot64D040; node661F80â†’5D54A0; hinted insert663240â†’5DA5E0 |

`7285B0` erases before copying the incoming value (728613,728628). It builds a string-plus-extra temporary, copies it into a pair temporary, copies again into node56, inserts, then destroys both temporary strings. `728830` follows the same erase/replace model but first constructs a C-string temporary through564C20; pair/node copies go through5FE7F0. Replacing a key is not an in-place payload write: node addresses, allocation/free order and red-black rotations change.

56-byte and48-byte insertion limits are respectively `0x04924923` and `0x05555554` nodes, checked before increment (735EFB/7360BB). Source failures dispose the newly constructed node and call length-error `CE0C22`. Allocation failure paths call `CE0B9F`. Expose explicit errors until exception/allocator behavior is qualified; do not substitute successful empty nodes.

Erase5C4680 supports leaf, single-child and successor transplant, fixes colors/rotations, frees a long string, resets its SSO descriptor, frees the node and decrements map count. Its custom free callback is global14BEF40 with context14BEF44; after a custom string free it rereads the deallocator before node free (5C48F8). Existing metadata destruction already observes this route-change behavior; setter erase must keep it.

Dependencies: string-copy564AF0, buffer-assign564C20, string-destroy564900, string-copy-wrapper5FE7F0; allocation9933E0, standard freeC98528 or custom allocator route; predecessor5CCFE0, successor5C23E0, rotations5C64E0/5C6540. No new network/OS imports are needed beyond the already owned metadata lock. Full container helpers require additional porting; these are not fulfilled merely by the lifecycle clear implementation.

## Proposed Rust interfaces and implementation split

Extend the existing `audio_replay_metadata::Boundary`; it already provides Storage, removal and the four lock methods. Add module functions rather than changing construction/destruction semantics:

```rust
set_count(b: &mut impl Boundary, p: u32, id: u32, count: u32) -> Result<u8, Error>
get_count(b: &mut impl Boundary, p: u32, id: u32, selector: u32) -> Result<u32, Error>
put_string_extra(b: &mut impl Boundary, p: u32, key: u32, index: u32,
                 source_string: u32, extra: u32, scratch: u32) -> Result<(), Error>
put_string_c(b: &mut impl Boundary, p: u32, key: u32, index: u32,
             source_string: u32, scratch: u32) -> Result<(), Error>
mark2(b: &mut impl Boundary, p: u32, key: u32) -> Result<u32, Error>
```

Proposed caller scratch: at least64 nonoverlapping bytes for the extra-string and pair temporaries, with a separate documented result slot if the translated insert helper requires one. Confirm this layout while porting; the native stack layout is not an API requirement. The source_string address must be a real 24-byte native string descriptor. A separate adapter can materialize `events::Argument::String(Vec<u8>)` into that form and own its destruction. Do not read past a12-byte callback to fabricate the16-byte invoke734130 adjustment.

First implement exact scalar helpers with current lock/unlock error joining. `get_count` can simply match `(id, selector as u8 != 0)` to four offsets, with unknown id0. `set_count` must perform the unsigned >48 return before lock and preserve an unknown-id lock cycle.

For mark2, the existing private `audio_replay_path_registry::{find,rotate,insert_node,value_slot}` operates the same24-byte unsigned-key layout. It is a suitable starting point for a common native tree helper; reuse requires checking5DA5E0 limits and hinted insertion against this oracle, not merely assuming all trees share semantics. Metadata string maps need a signed-index/unsigned-key comparator plus erase/rebalance and exact string-copy temporaries. Do not replace their in-memory topology with `std::collections::BTreeMap`, which cannot match observable native addresses/layout.

The current production image contains only4 bytes at metadata vtable10B00C4. Before Windows `events::Boundary::virtual_call` can dispatch +08/+0C/+28/+3C/+5C, extend that PE region to the full100 bytes ending immediately before bundle vtable10B0128, or extract precisely supported slots. The source JSON already provides those bytes. This is a future image change; nothing has been installed here.

## Fixture priorities

1. Scalar tests: all ids0/99/100/200/201/FFFFFFFF; counts0/1/24/48/49/FFFFFFFF; selector0/1/256/257/FFFFFFFF. Compare exact writes and lock events. The prepared audit already covers these combinations.
2. Map24 parity: empty lookup/insert, duplicate overwrite, keys0/80000000/FFFFFFFF, ascending/descending/zigzag rotation patterns, all links/colors, count, allocator route and returned value-slot pointer. Audit already covers ten distinct mixed-order keys, duplicate keys and1â†’2 overwrite.
3. String-map parity: lengths0/1/15/16/31/64; embedded NUL; signed index80000000/FFFFFFFF/0/1/7FFFFFFF; equal key with different index; replacement shortâ†’longâ†’embedded NULâ†’empty. Compare allocations, frees, sparse bytes, strings and full tree topology. Audit contains these inputs, but expand replacement selection to specifically remove leaf/one-child/two-child/root/min/max nodes before declaring erase coverage complete.
4. Boundary errors: temporary string allocation failures, node allocation/length errors, custom free route mutation, lock failure/unlock behavior. Current audit supplies successful standard allocation and single-thread locks only.
5. Compose Windows event dispatch with opcode101/102/103 against real metadata object and downstream callback effects; only after this should frame delivery be claimed. Counts25..48 need a separate monitored original-code packet-copy audit.

## Loader alignment follow-up

`audio_replay_windows_stdio.rs` now declares `GetProcAddress(..., *const u8)` to match existing repository declarations and passes export names with `.as_ptr()`. This type-only declaration alignment was not rebuilt per root instruction. Its new SHA256 is `e02c9a992cc8116c1441edc5f948384aa9f201ab72b318152b980d934a0058b1`; the previous isolated test receipt describes the preceding ABI-equivalent `*const c_char` revision. No production or Cargo changes were made in this lot.
