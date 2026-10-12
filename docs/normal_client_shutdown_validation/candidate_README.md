# Client shutdown refresh — source candidate only

No Rust compiler, client, GUI or native probe has been run for this stage. Production is unchanged. The earlier `client_shutdown_candidate` and `process_clock_client_shutdown_review` remain byte-identical.

## Proven defect and stale assertion

The normal client discards the `AppExit` returned by `app.run()`. Bevy0.19 `AppExit` implements `std::process::Termination` and preserves its nonzero u8 code; discarding it can report a successful process result after the runner reports failure. Existing native Drop paths log their cleanup failures, but the runner has already selected its exit code before Winit's `exiting` clears the World. This is a reporting gap, not evidence of a normal shutdown leak or incorrect Drop order.

The old uncompiled checkpoint additionally required zero transport critical sections after `Runtime::shutdown`. That is incorrect: the Shared owner retains its original `startup::MUTEX+8` section while Service/EffectClock/ClockHandle references remain. The current runtime also retires loading-string groups and the integrated resource manager. The refresh calls the current runtime rather than reimplementing those lifecycle steps.

Two of the old candidate's21 observed sources changed: current `main.rs` is SHA256 `60ead59c1c409a8991c08c0c9370e8edc40acaeaa5b23f6968f26fb0fca55f2f`; current transport is SHA256 `7f7e0376b69f5e8520d58430790f464464b2c883f3deb6eab7ac5ae09cc3da6f`. The other19 hashes, including Bevy0.19 sources, still match. The manifest records all current hashes before integration. `main.baseline.rs` is the exact current main used by this candidate.

## Minimal production delta

- `main.rs`: declare the new Windows module; wrap the previous body as `run_client(&mut AppExit)` with main returning `AppExit`; capture the normal `.run()` result. All early CLI `return;` branches stay identical and retain their previous success/panic behavior. No `process::exit`, added panic or forced code101 is used to report a normal runner error.
- The normal Windows attachment/observer setup now returns Error1 on its own explicit failure and allows the local App/partial owners to Drop. Other pre-existing initialization `expect`/panic sites are outside this patch.
- `native_runtime_shutdown.rs`: one guarded exclusive checkpoint in `Last.after(ExitSystems)` calls service close → current runtime shutdown → Application close. It collects actual errors, keeps the earlier error even when later cleanup retries succeed, and never requests a clock sample during or after shutdown. A retained diagnostic snapshot is not a producer call.
- Transport critical-section count/reference are observations; zero is not an error predicate. Actual report failures remain errors. The independent `Watch` holds only the CS report and a JSON result sink, so it does not prolong the native Shared/CRT lifetime. After `.run()` has returned and its runner's App has been destroyed, the Watch reads actual late section Drop failures.
- An existing `AppExit::Error(code)` always remains the same code. Only a successful runner result with an actually collected cleanup/report error becomes Error1. A missing checkpoint alone is recorded and does not invent a native error. A returned event-loop error remains its nonzero code, with Drop as fallback if Last never ran.

This does not capture all hypothetical panic/abort paths. Root's close methods can still panic on poisoned locks, and a panicking plugin or process abort can bypass normal result handling. No new panic interception is proposed.

## Source schedule evidence

Local `bevy_window-0.19.0` emits its default empty-window Success in `ExitSystems`. Winit runs the main App update before `should_exit` (`state.rs:735`), and `App::should_exit` prioritizes any buffered Error (`app.rs:1429`). Winit `exiting` then calls `world.clear_all` (`state.rs:502`); ECS clears resources before non-send resources. Existing Service/EffectClock resources therefore release before Application's non-send Drop fallback. No change to this existing ordering is necessary.

`App::run` moves the configured App into its runner and replaces the original caller App with an empty one (`app.rs:192`). Cleanup after `.run()` cannot recover native owners from that empty caller; the external Watch intentionally retains diagnostics only. Winit can return before a normal frame if its event loop fails; this is not evidence that Last executed. `winit_runner` logs an OS `run_app` error and uses its stored `app_exit` or Error1 if absent. A hypothetical OS error after an already selected Success is a Bevy limitation not corrected here.

## Prepared tests (not run)

1. Actual configured Service, process EffectClock, a real transport worker and current empty loading-resource manager. Real headless WindowPlugin exit producer closes once; retained snapshots do not advance QPC; after `clear_all` and final diagnostic ClockHandle drop the independent CS report has only the Watch reference and no errors.
2. Local observer error after actual service close preserves the primary error while runtime and Application still clean up. Error37 survives the final Watch. This is not an injected OS HeapFree/worker failure.
3. Exit before the first EffectClock consumer does not initialize or sample a clock; real owner cleanup and final report retirement still occur.
4. Every existing nonzero u8 AppExit code survives with/without cleanup error; only Success+error becomes Error1.
5. A custom runner returns Error43 before any frame, taking real App/owner Drop fallback. This is a headless runner contract test, not a simulated OS Winit failure. Missing Last alone is not mislabeled a cleanup failure.
6. Real attach helper fails because the required service is absent, and leaves no Application/EffectClock resource published in the App. Its unpublished owner is inaccessible to the test, so no physical heap-retirement measurement is claimed on that path.

## GUI qualification proposal

Prefer the actual rebuilt normal client, without a new diagnostic CLI or alternate App. Start it with separate stdout/stderr logs, retain its exact PID, wait for its visible HWND and active message pump, then post WM_CLOSE only to that process's verified HWND. Preserve exit status plus `NATIVE_RUNTIME_SHUTDOWN` and `NATIVE_RUNTIME_AFTER_RUN` reports. Require initialized clock evidence, one phase sequence, no cleanup errors, cleared CRT ownership and no late CS failures after Winit returns. A real window/GPU failure before startup must remain a failure, not be replaced by the headless result.

For a separate real-process Error37 scenario, an explicit diagnostic profile would need to enqueue AppExit::Error37 after a first normal frame. No such profile has been added: the default product flow remains unchanged. The prepared headless test validates error precedence/code preservation only; root decides whether the extra process profile is necessary. Exact process status and WM_CLOSE/GPU behavior remain untested until root performs those checks.

No assets, launcher, service implementation, core runtime or plugin dependencies are modified by this stage.
