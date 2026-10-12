# Loading metadata Windows adapter review and composed native evidence

Read-only review of loading_metadata_stage/audio_replay_windows_loading_metadata.rs and its proposed test. No Cargo, rustc or production mutation was performed for this review.

One concrete setup defect was reported to root: initialize_game_manager/72A800 creates a source8F6700 stream whose object-index pair+6C/+70 is still empty. The proposed first72C780 command therefore tries8F8CF0 at index0. The test needs the real index constructor/control producer, or an explicitly described diagnostic setup using object_manager::construct and replay_manager_control::replace_pair. owner_control::replace_pair is wrong for this object because8F8810's first word is not a vtable. Root was already fixing a separate scratch overlap.

No further adapter deadlock was found. resolve_key preserves the native direct lookup path729EC0→729730→738AC0→8F8CF0, retaining the stream index control and dropping it after the action. No optional-null shortcut729CF0 was introduced. Action/cleanup errors remain explicit. The supplied metadata getter module acquires its metadata lock before the object-manager lookup, matching the source lock order.

## New native oracle

probe_resolve_composition.py executes actual parent construction728E20/728FD0, object-index construction8F8810, manager control publication9019A0, packet producer72C780 and metadata text producer7285B0. It then executes16 direct729EC0 resolutions and32 service getters72AD90/72AE40 across2fill00/A5 lifetimes. All48 calls to8F8CF0 execute the original native tree lookup; no resolver, packet-object or metadata-return boundary is substituted. Actual728EA0 shutdown retires parent, stream, index, packet objects, metadata and controls: all owned allocations released.

loading_resolver_composition_probe.json records the prepared object graph, real entries, complete live allocation snapshots, each resolver chain, output bytes/extras, and metadata/index reference counts before/after each query. It also includes original resolver source bytes and all executed instruction addresses. Existing primitive allocator/memcpy, Win32 and mutex boundaries are used by the inherited native harness. This is single-thread source qualification, not a network or UI session.

Source behavior to preserve: absent packet identifiers return the64-bit value0. If metadata has an actual key64zero row, a missing identifier returns that row's name/extra. In this oracle a zero-key row has extra7, so missing ids9000 andFFFFFFFE return extra7. No special empty/zero filtering should be inserted by the adapter.

The explicit index source setup is not execution of the complete8F68D0 stream-opening producer. Native nested/parent/metadata initialization is real, and the data is populated by actual native producers, but normal loading startup, rendering, networking and simulation remain separate work. No new Rust tests are claimed by this oracle.
