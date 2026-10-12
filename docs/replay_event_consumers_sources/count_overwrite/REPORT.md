# Native metadata copy729D70 — counts25/48

Source PE SHA256: `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. The executable path, exact code ranges, bytes and region hashes are recorded in `count_overwrite_native_probe.json`. The oracle verifies the complete source hash before every run.

**Result: keep the public ingress limit of24 entries per array.** The original setter accepts counts through48, but the original copy does not protect the two24-entry physical arrays. This is a demonstrated source behavior, not an instruction to reproduce the corruption in public ingress.

The100 controlled profiles execute actual729D70,728150 and7281C0 bytes. Only single-thread lock primitives9941B0/994210 are supplied boundaries. The512-byte metadata object and each packet end at independent protected pages. Completed copies preserve the native stack return; faulted copies stop immediately. No damaged object is subsequently destroyed or dispatched.

Observed totals:84 normal returns,8 protected packet reads,8 protected metadata writes. Forty profiles overwrite both counter fields during the second copy.

|Source operation|Observed behavior|
|---|---|
|Setter728150 at728164|Accepts unsigned count≤48; larger values return AL0 without storing the count.|
|First copy729E10, destination+20|25..48 elements overlap the second array. With count48 it writes through+19C, still inside512 bytes and just before the counters.|
|Second copy729E40, destination+E0|Element24 (zero based) writes+1A0 and+1A4: the two loop counters themselves. Data comes from packet+189/+18D.|
|Bound reread729E51|After incrementing the loop index to25, compares it against the **new** value at+1A4.|
|Replacement counterB≤25|Stops after25 elements and returns normally, leaving counterA=11223344h and counterB equal to the controlled replacement. AL can be1 despite this overwrite.|
|Replacement counterB>25, packet length191h|Next iteration faults reading packet+191h at729E40 (element25), before its next destination write.|
|Replacement counterB>25, packet length249h|Continues through metadata strings/lock fields; element36 attempts metadata+200h at729E45 and faults at the512-byte guard.|

The packet fields at189h/18Dh are copied earlier into metadata+1A8/+1AC. They are not merely inert trailing bytes: when countB exceeds24, they become the loop counters through the overlapping second copy. Count25 can therefore stop normally or run into a guard, depending on these fields.

Additional control profiles confirm that an oversized count49 rejected by the setter does not abort729D70. The stored previous count controls the copy. Setter return bytes overwrite the local result rather than combining failures: with countA49 rejected and countB1 accepted, the function returns AL1. This audit starts stored counters at0; it makes no claim about every preexisting corrupted state.

Profiles: count pairs `(24,24)`, `(25,0)`, `(48,0)`, `(0,25)`, `(0,48)`, `(25,25)`, `(48,48)`, `(49,0)`, `(0,49)`, `(49,1)`; packet lengths191h/249h; replacement counterB0/24/25/48/FFFFFFFFh. Each proof case retains operand bytes, actual getter/setter/lock entries, loop-counter read traces, destination writes, first fault and final object bytes.

Limits: operand fields are controlled audit state, not a constructor/destructor lifetime proof. The extended249h packet is a deliberate audit profile, not a recovered protocol-size claim. No Rust or production change was made and no live game/network consumer was executed. The audit supports rejecting counts above24 before mutation; it does not expand the qualified replay protocol.
