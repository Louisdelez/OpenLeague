# Metadata count port, scratch only

`audio_replay_metadata.rs` and `audio_replay_metadata_tests.rs` are copies of the current production modules with only two public operations and two tests added. `metadata_count.patch` contains those additions; it does not modify the Boundary trait or Error enum. `replay_metadata_count_probe.json` is the 42,964-byte scalar projection to place at `data/4.20/replay_metadata_count_probe.json` if the root agent integrates this lot.

Signatures:

```rust
set_count(b: &mut impl Boundary, p: u32, id: u32, count: u32) -> Result<u8, Error>
get_count(b: &mut impl Boundary, p: u32, id: u32, selector: u32) -> Result<u32, Error>
```

The setter preserves the native unsigned limit48, return AL and IDs100/200. A rejected count returns before even computing the lock address; tests explicitly supply null and unmapped pointers with counts49/u32::MAX. For other counts, including unknown IDs, it enters and leaves the existing metadata lock. The getter never locks, returns zero without reading metadata for unknown IDs, and uses only the low byte of the selector.

Source evidence: native PE SHA `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`; disassembly at `E:/mapslol3v3/replay_manager_agent/metadata_setters_disassembly.txt`, functions728150–7281B6 and7281C0–72820B. The complete native oracle is `E:/mapslol3v3/replay_manager_agent/replay_metadata_setters_audit.json`, SHA `c261df7c77265c610f85c39546367a89dd2c6d959dafc50dd3f7a0f22c68aa73`. The projection retains its exact72 scalar steps and360 getter results, both fills00/A5, full initial metadata bytes and original pre-loop counter seeds.

After the root compilation finished and isolated compilation was authorized, `metadata_count_harness.exe audio_replay_metadata --nocapture` passed4 tests, failed0, filtered8, in0.06s. Two are new parity tests; two are existing metadata construction/teardown regression tests. Whole512-byte snapshots and lock events are checked, including absence of getter writes, allocations and frees. The final run is recorded in `metadata_count_tests.log`; executable and inputs are hashed in `metadata_count_receipt.json`.

The native setters accept48 although each fixed array has24 entries. These tests never invoke729D70 or any frame-copy consumer. No Windows dispatch, metadata string-map operation or production file was changed. This qualification is limited to the scalar port and does not establish safe consumption of large counts. Injected boundary failures and concurrency are outside this oracle.
