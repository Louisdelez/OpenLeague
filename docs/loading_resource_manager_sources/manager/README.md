# Resource manager172 — integration candidate

This stage contains the source port and prepared tests for the empty lifetime only. No Rust compiler or test executable was run by this agent. Production was not modified. The Python native oracle was executed against the original PE, SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.

## Files/API

Install the three `audio_loading_resource_manager*.rs` files together. The index file is a private path module. Add the main module to core/lib. Install `loading_resource_manager_oracle.json` and `loading_resource_manager_null_probe.json` under `data/4.20/`.

`Boundary` is a re-export of `audio_loading_owned_string::Boundary`. `Error` re-exports metadata::Error. No additional host trait implementation is required. `Snapshot` derives Serialize. Public functions are:

- `hash65599(b, pointer) -> Result<u32, Error>`:8E50F0, null returns0 without memory access, signed byte/ASCII folding.
- `initialize_hashes(b) -> Result<(), Error>`:531A50/531A90/531AD0/531B10 in CRT initializer order. Their first '[' is immediate; memory starts at string+1.
- `produce(b, &mut Record, scratch4) -> Result<u32, Error>`:90B7C0/90A4C0. Requires exclusive serialized use of GLOBAL and a retired/fresh record; external nonzero global is refused before allocation. scratch4 may be released after any return, including errors.
- `wire_backpointers(b, &mut Record)`: separate592E49..592E6A fragment only; does not claim the full startup caller.
- `retire_empty(b, &mut Record)`: source empty90A800/90A760(flags1) writes/frees, then outer global clear. Keep Record on every error. A second produce on an active record fails. `pointer()`, `is_retired()`, `snapshot()` expose ownership state without adopting pointers.

All allocations are recorded in a fixed14-entry inventory before the first fallible initialization. No allocation after a native allocate can lose ownership. Allocation contract is owned_string::Boundary's fresh/disjoint success and no published allocation on Err. `release_owned` must be atomic: Err keeps allocation; Ok retires exactly once. Writes may fail after changing bytes inside their range, so the program retains independent allocation addresses and a retirement cursor.

Normal retirement first checks the9 distinct owned sentinels, empty provider/string/vector state, and owned index nodes. An immutable fixed96-action plan then reproduces source heap writes and release order; successful actions are never rerun. In particular, a failed final manager free leaves GLOBAL published; a failed subsequent clear leaves zero live allocations and an AwaitingGlobalClear record, preventing a second free. Reads performed by prevalidation/planning differ from native ordering and are explicitly host adaptation. This does not qualify reentrant/concurrent mutation.

Construction errors do not call a destructor on invalid partial fields. They retire the recorded raw allocations in reverse order. A failed publication may leave a partial global word; under the required exclusive global lease this is cleared before partial recovery. These are host error adaptations, not emulation of native C++ exceptions/SEH. The primary Result remains with the caller; separate cleanup errors do not erase it.

## Index comparison

5BD9B0 and64D040 both use the24-byte key/value node and identical unsigned lower-bound structure. 5D2710/661F80 share5D54A0 allocation;5D2950/663240 differ in stack/SEH prologue but both call the actual common5DA5E0/5DA8C0 insertion/rotation helpers. The public metadata value_slot accepts a key by value and therefore cannot be reused unchanged:5BD9B0 takes key_ref, reads it for search/equality, and rereads after allocation. The private manager index port preserves those reads and tracks pending allocations. It is scoped to the manager's four registrations, not offered as an arbitrary unbounded tree API. The source regions/disassembly are retained in manager_source.json/txt.

The ordinary write sequence reuses the existing geometry of source5DA5E0/5DA8C0. Native16-bit writes of color/nil are lowered into two host byte writes. Oracle comparison expands every write into ordered bytes, and separately preserves allocation/free ordering. Stack spills, private caller scratch, allocator fill, and preflight reads are not called native byte-write parity.

## Evidence executed

`probe_manager.py` executes real static initializers, producer/constructor, four virtual hash getter methods, bounded backpointer fragment, and empty destructor from the PE, with only alloc/free/memory primitives supplied. Two00/A5 lives each have14 allocations,14 frees,239 ordered write/allocation/free events. All14 initial and wired memory banks plus final free order match the previously frozen native_resource_oracle.json. It also executes264 hash inputs (null, all256 individual bytes, four names and mixed/high-byte/NUL-containing strings).1135 instruction addresses are recorded. It does not execute the outer global-clear caller: this distinction is explicit in the fixture and Rust test.

The second fixture is a byte-for-byte copy of root's independently executed90B7C0 null-allocation proof (two initial globals). Source native overwrites a foreign global with0 in that path; the host intentionally rejects foreign globals instead of adopting or destroying another owner.

Prepared Rust tests (not executed here):

1. audio_loading_resource_manager_matches_two_native_lifetimes_and_exact_heap_writes
2. audio_loading_resource_manager_null_producer_and_external_global_are_distinct
3. audio_loading_resource_manager_every_constructor_host_failure_keeps_raw_ownership
4. audio_loading_resource_manager_each_retirement_write_and_free_failure_is_retryable
5. audio_loading_resource_manager_refuses_populated_cache_without_free_or_mutation
6. audio_loading_resource_manager_hash_matches264_native_inputs_including_signed_bytes

The failure tests inject every allocating/writing constructor boundary, both atomic and partial-byte write failures, an additional cleanup failure, and every retirement write/free boundary. The tests retain primary errors and assert complete eventual retirement with no second successful free. These are proposed host-failure qualifications, not native SEH claims, until root executes them.

## Runtime PE data required

- hash globals2D6EDF0..2D6EDFF,16 bytes.
- strings10D666C/16,10BF2D4/9,10D6880/13,10D6B34/12 including NUL.
- manager global2D78F1C/4 and manager vtable10D6450/8 (already in image).
- four slots only:10D640C/4→901EF0;10D6320/4→901EE0;10D62EC/4→901ED0;10D6354/4→901E20.

Other base/embedded vtables are written as native identifiers but not read by this port. CRT table FA6B74/16 documents initializer ordering; the generic implementation does not read that table. Native allocator/deallocator integration is the existing boundary, with the stricter atomic release contract.

## Excluded

No cache miss factory90B520, INIBIN provider, populated multi-owner provider destruction, renderer, texture upload, complete startup caller, or UI continuation is implemented or claimed by this manager stage. A populated cache makes retirement fail before mutation; it is not silently emptied or freed as raw tokens. Integration and Windows qualification belong to root's subsequent stage.
