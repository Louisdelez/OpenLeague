# Callback invocation signatures — scratch proposal

Source: the local unpacked League of Legends4.20 PE, SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. Exact byte ranges, bytes and region hashes are in `signatures_native_probe.json`; readable instructions are in `native_disassembly.txt`.

This proposal extends the previous `replay_callback12_agent` module. It edits no production source and attaches no Windows adapter. The combined standalone harness passes **11 tests: eight new signature tests and three preserved5CCEB0 tests**. Compiling this small harness emitted70 unused-code warnings from the copied prerequisite modules, with no error. No cargo build was run.

## APIs and source evidence

`InvocationBoundary: audio_announcer_object_lookup::Memory` exposes `member_two(owner,member,first,second)`, `member_six(owner,member,SixValues)` and `member_zero(owner,member)`. Default methods return signature-specific unconnected errors. All returns preserve full32-bit EAX. There are no raw host pointer calls.

| Source / API | Callback bytes | Source arguments and observable data reads | Member signature |
| --- | --- | --- | --- |
|65E9E0 / `invoke65e9e0`|16|Two value arguments; callback+12, +4, +8|Two values, adjusted owner|
|7341D0 / `invoke7341d0`|16|First value, second reference; *second, callback+12, +4, +8|Two values, adjusted owner|
|734080 / `invoke734080`|12|`SixArguments`: first_ref, second_ref, four values; *second_ref, *first_ref, callback+4, +8|`SixValues`, unchanged owner|
|733F70 / `invoke733f70`|12|No arguments; callback+4, +8|No arguments, unchanged owner|

Adjustment adds with native32-bit wrapping semantics. An invalid required read stops before later reads or terminal dispatch. Null callback labels return the existing `NullCallback` safety error. These are Rust boundary errors, not claims that the source PE recovers from invalid memory.

65E9E0 is itself a generic tailcall and encodes no stack cleanup. Its **two-value** API is tied to the configured service path: member738A3A reads service vtable+34;72B2D0 forwards `[ebp+8]` and `[ebp+C]` into72B2F0, then `ret8`. No claim is made that every possible65E9E0 instantiation must have this signature.

The real leaves are **586230** (`xor al,al; ret`) and **71EC30** (`xor al,al; ret18h`). 733F70 is a wrapper, not a leaf;734080 takes six arguments, not zero. `leaf_false586230(incoming_eax)` and `leaf_false71ec30(incoming_eax)` preserve the upper24bits. The corresponding wrappers load EAX with the member address before dispatch, so their proven full returns are `00586200` and `0071EC00`. Their low-byte boolean result is false. Other members remain explicit boundaries and do not receive fabricated success.

## Qualification

The oracle executes the original wrapper bytes in Unicorn, after verifying the complete PE hash:

-336 cases at explicit terminal observation boundaries:72 two-value,180 second-reference,72 six-argument,12 zero-argument. They cover null/max/ordinary owner words, wrapping adjustments, argument aliases and full terminal results0/1/ABCDEF00/F1234501.
-12 wrapper cases execute the actual native false-leaf bodies, plus12 direct leaf cases with varied incoming EAX.
-All valid callbacks end exactly at a protected page boundary. Native data reads must match the recorded order; callbacks remain unchanged, EBP/ESI remain preserved and stack cleanup matches the signature.
-Two negative controls run the16-byte wrappers on protected12-byte callbacks. Both fault precisely at callback+12, before any terminal invocation.
-Rust matches these traces and results, rejects missing references and unconnected members, and retains all96 earlier5CCEB0 trace cases plus its negative control and error tests.

For generic zero/six argument forwarding only, synthetic terminal labels are used as explicit observation boundaries. They are not recovered consumer identities. Two-argument real service entries are intercepted before executing their bodies. Supplied terminal returns qualify wrapper forwarding only. No metadata/network/gameplay consumer is claimed operational.

## Shared getter and service branch5 — static guidance only

729C80 takes a caller-owned output pair, zeros output+0 and output+4, and passes source `parent+34` to5CC070. It returns the output pointer and `ret4`. The caller must provide fresh output storage: this function does not release an old output pair before zeroing, and overlapping output/source can erase the source before copying.

5CC070 reads **source.control(+4) before source.object(+0)**, increments `control+4` atomically when nonzero, then checks/releases the previous destination control. In the fresh getter path, that destination control is zero. Final stores are destination.control then destination.object. This note does not introduce an alternative implementation of shared ownership.

72B950 branch5 begins72C2B3: obtain/initialize parent singleton, call729C80 into a stack pair, take object from that pair, invoke object vtable+5C with the second service argument as a **value** (`[ebp+C]`), release the pair through5BD3C0, then set BL=1. The method epilogue copies BL to AL. Default/branches3 and4 reach72C2F9 (`xor bl,bl`) before the same epilogue. This establishes the low-byte boolean; it does **not** establish a canonical full-EAX integer0/1 for these service branches. Branch5 metadata+5C corresponds to728A60 in the separate metadata work; this scratch does not connect it.

## Integration files

-`invocation_additions.rs`: new typed APIs only, for review/insertion into the current module.
-`audio_replay_callbacks.rs`: combined previous callback12 proposal and new APIs.
-`callback_signatures_after_callback12.patch`: incremental patch against the frozen callback12 proposal (baseline SHA256 `026b1039e8f4d6670513fa4946f7afbe11c68b0a9270b638ea3b5987dbb234f8`).
-`callback_signatures_production.patch`: combined patch against production as read during preparation (baseline SHA256 `61a96429ab796e2c79e1d92292e65169712128b80c06f8652896a72cf97d9773`). Revalidate that baseline before applying; the parent owns production changes.
-`signatures_tests.rs`, `probe_signatures.py`, native fixture, logs and `validation_receipt.json`: reproducible evidence. The previous callback12 fixture is copied byte-for-byte and its original receipt remains untouched.
