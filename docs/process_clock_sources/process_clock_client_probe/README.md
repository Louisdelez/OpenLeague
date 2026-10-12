# Native process clock CLI probe — staged, not executed

Append `main_probe.rs.txt` to `E:/OpenLeague/crates/client/src/main.rs` and insert `main_dispatch.rs.txt` immediately after `arguments` is collected in `main`. Root owns integration and compilation; this preparation does not modify production.

Run the rebuilt client as:

```powershell
E:\OpenLeague\target\debug\openleague-client.exe --native-process-clock-probe E:\OpenLeague
```

Use the actual executable path selected by root if the target directory differs. The probe prints one JSON result; failed checks set `passed:false`, preserve cleanup errors and then fail the command. A successful result contains `passed:true` and `complete:false`.

The probe uses the current normal `native_user_settings::load` path and configured `NativeReplayService`, then calls `attach_native_replay_runtime` exactly once. The normal configuration loader retains its existing configuration-directory/migration behavior; this preparation never invokes it. There is no second `Application`, QPC substitute, private origin or manually advanced Bevy `Time`.

The exercise samples the shared process handle before the first effect frame, installs the existing `native_effect_clock::Plugin`, and performs seven actual `app.update()` calls. It checks the first frame, running time, four paused frames, and resume. Pause/resume use the existing local ordered adapter with native A1/0A payload layouts. Real short OS sleeps provide elapsed time. While paused, effect time remains bit-identical and published `AnimationDelta` is zero, but canonical raw QPC samples advance with unchanged origin/frequency. QPF must be called exactly once.

Shutdown runs after exercise errors as well as success. It closes the configured service, shuts down its runtime, then closes the owning application. Public snapshots verify CRT blocks/mirrors, mutex owners, cleanup registrations, engine allocations, worker handles and event balances. Both raw and f32 clock methods must reject calls through the retained handle after close without changing the final snapshot. Every cleanup error remains in the JSON.

This is a headless lifetime and frame-clock probe. It does not dispatch a loading packet, play an animation clip, render UI, send network pause messages or exercise FIFO contention. It records those limits explicitly. FIFO contention and native loading-consumer fidelity belong to their separate tests. In an uncontended run, `events_created == events_closed == 0` is legitimate and does not claim tested event creation.

No Rust compilation, client execution, native oracle or production mutation was performed for this preparation. The manifest records source dependencies and staged artifact hashes; it is not a passing runtime receipt.
