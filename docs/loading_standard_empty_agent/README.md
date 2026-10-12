# Standard loading screen: real empty-name native branch

This is **preparation evidence only**. There is **no Rust port, no Windows connection of the standard empty-name branch, no production edit and no integration claim** in this directory. The previously tested integration receipt remains separate and unchanged.

`probe_standard_empty.py` executed original57D650 through the real service method72AD90, metadata getter728410, resolver729EC0/729730/738AC0 and object index lookup8F8CF0. No provider, resolver, record-tree or consumer result is simulated. The original PE SHA256 is `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.

**Observed results:16 complete lifetimes,64 consumer calls,1,952 ordered events, all passed.** Profiles combine fills00/A5, short/heap-backed metadata cache, four ways to obtain an actually empty name, and flag bytes0/1/128/255:

- Existing object identifier with a real empty metadata string row.
- Existing object identifier with no matching metadata row.
- Missing object identifier and no zero-key metadata row.
- Missing object identifier with an actual empty zero-key metadata row, preserving the native resolver's zero alias.

Parent728E20/728FD0, object index8F8810 and control publication9019A0 execute. Objects are inserted through72C780 and name rows through7285B0. The metadata's optional old long cache string is created by564C20. The standard record tree uses the real constructor snippet57CE5C..57CE72 and record lookup/insertion5BE170. Recipient/service storage and vtables are explicitly diagnostic bindings: the full loading-screen factories, complete service constructor and normal stream-opening producer are not being qualified.

Every consumer call compares all120 record bytes against the observed record immediately after native lookup, allowing exactly the25-byte payload copy and the source bit0 reset of word+10. Payload bytes remain unchanged. Reference counts for metadata and index return from1 to1. The metadata lock order is enter then leave. Cached long-string allocation/capacity remain owned by metadata, with only length/content reset by its getter.

The native returned output is an empty String24 with capacity15. At57DCAE the caller enters cleanup, reads exactly this capacity, skips free and reaches57DCE6. No free occurs during these consumer calls. This qualifies the real SSO cleanup path, not an invented heap-backed empty output. The heap-backed metadata cache is released later by native parent shutdown.

Instruction and memory guards reject all entry into the first nonempty branch57D6FE, extra getter72AE40, resource/package/texture/category/localization helpers and993CE0. They also reject reads of the12-row table, resource/category globals and recipient overrides+1A0..+1D8. No UI or clock boundary is used. Native57D1E0 retires the record tree, then728EA0 retires parent, stream, index, objects, metadata and controls; every tracked owned allocation is released in all16 lifetimes.

The harness reuses the existing native allocator/memory-copy and single-thread OS/lock primitives and the source composition established in `loading_metadata_review`. It does not prove contention, allocation-failure/SEH rollback, renderer or asset availability, network decoding, visible loading UI, or a Windows implementation. No compiler was run.

Files are frozen after `preparation_manifest.json`. The next work must separately port this branch and qualify its runtime integration before changing its status from prepared evidence.
