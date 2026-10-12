# Replay service receive path: source audit and native execution

Original PE SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. `replay_service_packet_sources.json` archives20 exact regions and their hashes. `packet_switch_map.json` archives both switch tables plus bounded control-flow disassembly for124 distinct targets. `allowed_packet_branches.txt` provides the five branches admitted while service+184 is zero. Extraction follows direct branches only inside588290..58C1AC; indirect jumps and calls are recorded explicitly, not simulated.

## Signature and order

`65E9E0` reads callback owner+4 and adjustment+C, computes this, then tailcalls member+8. `738A3A` jumps through `[service.vtable+34]`; original table10AFE8C selects72B2D0. That wrapper forwards **two32-bit stack arguments** to72B2F0: context value and packet pointer, returns AL and pops8 bytes. Neither argument is a packet length.

72B2F0 reads packet byte0 as an unsigned event. If byte0 isFE, it replaces the event with the unaligned little-endian u16 at packet+5. EventDD immediately returnsAL1. Otherwise, when service byte184 is zero, only88/92/54/95/C6 continue; all other events returnAL1. Thus AL1 on this filter path means no consumer ran. Filtered packets do not update service+5C or read packet owner.

The accepted path writes the first argument to service+5C, reads the unaligned owner u32 at packet+1, and compares it to global2D62878. Equal owner bypasses registries and calls588290 directly. Otherwise it forms a12-byte descriptor: owner+0, zero+4, event u16+8 and untouched two-byte stack padding+10. It calls72EC40 on service+C, then72EEC0 on service+18 with descriptor and the **original unshifted packet pointer**. Nonzero AL from callbacks is returned verbatim. Zero AL falls through to588290, with event inECX, packet inEDX and context on stack.

The root service is392 bytes in these observations; byte184 requires at least389 readable bytes. Header reads require one byte for a compact filtered packet, seven for extended event decode, and five for owner decode on an accepted compact packet. Consumers can require much more; the wrapper does not validate a length.

## Existing reusable ports and real effects

72EC40 and72EEC0 already exist in `audio_announcer_service_activation::{activate,dispatch}`. Both Rust APIs take the **service base**, performing internal+C/+18 adjustments. Activation processes pending pairs in reverse and destroys descriptors/pairs after insertion. Dispatch takes an owned callback-pointer snapshot, ORs callback AL values, then frees the snapshot. Native ownership and padding must be preserved by the caller.

Four actual metadata consumers execute in the new native oracle. They are already ported by `audio_announcer_metadata_callbacks::{invoke,consume}`:

| Event | Native consumer | Observed effect relative to full56-byte owner metadata |
| --- | --- | --- |
|51|6B27A0|Reads actual service spectator byte through VT+B0=718AD0. When zero, clears metadata byte36 and invokes borrowed actor VT+24.|
|35|6B27D0|Same gate; clears metadata byte37 and invokes borrowed actor VT+2C.|
|E0|6B2800|ORs bit `(packet[5] &31)` into metadata u32+40; values>=4 invoke native diagnostic first.|
|E1|6B2850|Clears that bit in metadata u32+40, with the same diagnostic/reload behavior.|

The actual actor virtual implementations remain the next simulation boundary. Existing ConsumerBoundary records/supplies those operations; that is not evidence of actor movement, rendering or combat. The last two consumers already perform real metadata state writes. No gameplay semantics beyond these demonstrated operations are assigned here.

## General packet dispatcher588290

It truncates ECX to u16, subtracts2, and uses a301-byte index table58C39C for codes2..302, indexing124 function-local targets through496 bytes at58C1AC. **177 of those codes select the default58830A**, which returnsAL0 without packet-specific action. Codes outside2..302 also returnAL0. The remaining123 targets require their actual consumers; no generic success substitutes for them.

Five branches can reach this dispatcher even when service+184 is zero:

| Code | Entry | Dependencies/effects demonstrated statically |
| --- | --- | --- |
|88|5884E0|Calls5C86F0, then writes zero-extended packet byte5 to global2D788C0 and returns1.5C86F0 initializes static timestamp vector2D798C4/8/C, calls clock993CE0, and may shift its entries and call6AFD10.|
|92|58A6BF|Reads u32 at packet+5/+9, calls598EB0 to update singleton2D78504 fields68/6C under lock+E8, lazily constructs via5D1130.597CC0 assigns NUL-terminated packet+13 to singleton string+88 under the same lock. At least13 fixed bytes plus a terminated string are required.|
|54|589FD0|Large branch with strings and subsystem initialization: first references packet+886, reads u32+1325/+1329 into object2D79104+10/+14, then processes further strings/data through+142D and indexed reads. Multiple logging, settings, replay and service calls; the wrapper's32-byte test buffers do not qualify this branch. Complete bounded call/CFG inventory is inpacket_switch_map.json.|
|95|58A6F2|Calls577E90 with packet+5. That method obtains shared pair14C761C/20 through5CC140, increments/releases its control, and when object nonnull invokes `(**object).vtable[0]` with payload. Returns1 from the outer switch. Empty pair is exercised; active target is not.|
|C6|5885B6|Logs through5FA170, then588010 reads packet byte5 bit0, writes14CBC60 to100/200, branches on connection globals and can invoke UI, service and process APIs. No execution of those side effects is attempted by this oracle.|

The archive records EBX-relative operands as syntax observations, not complete schemas. Indexed reads, strings, calls and possible register reuse prevent deriving an exact universal size from the maximum immediate offset.

## Native oracle

`probe_service_packet.py` → `replay_service_packet_probe.json`: **passed**,8 service-member/owner-metadata lifetimes, **144 full wrapper invocations**,88 actual activations,88 actual registry dispatches,80 actual588290 calls,16 actual577E90→5CC140 calls with the source-empty global pair, and8 supplied actor virtual operations. Zero/A5 fills, owner42/sentinelFFFFFFFF, service gate0/1, byte184 values0/1/255, compact/extended event headers, local-owner bypass, real listener hits and misses are covered. Every live allocation and all392 service bytes are retained after each step; teardown frees all tracked owned blocks.

No consumer or registry body is stubbed. Existing allocator/copy primitives and actor virtual actions are explicit supplied boundaries. Service storage is caller-owned with only relevant native members constructed, so this is not full72A3B0 construction. Full replay-stream delivery, active95 targets and the other123 switch targets remain unqualified. No Rust service-receive compilation has been performed during the root build.

## Proposed next port

Port72B2F0 and the vtable-checked738A3A/72B2D0 entry using existing activation/dispatch and metadata callback ports. Require caller-owned24-byte scratch: descriptor12 plus activation12, preserving the two padding bytes in each. General588290 remains an explicit boundary. A source-backed default classifier can return0 only for the exact default/out-of-range codes; active handlers must dispatch to real ports or return a precise unsupported error. Reconnect the borrowed actor VT+24/+2C operations to native actor lifecycle/simulation only once their implementations and owner lifetime are qualified.
