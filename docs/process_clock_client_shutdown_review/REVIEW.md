# Normal client shutdown review — source evidence only

No production mutation, compiler, client execution or window-close test was performed. The current build is unaffected.

## Finding: normal source ordering is preserved

The current normal client inserts `NativeReplayService`, attaches one `Application` as a non-send resource, and installs `EffectClock` with a handle to that same runtime. The normal plugin chain ends in `.run()` without a custom shutdown system.

The inspected Bevy 0.19.0 implementation establishes the normal ordering:

- `bevy_window/src/lib.rs`: default window close handling runs in `Last` before `ExitSystems`; the exit producer writes `AppExit::Success`.
- `bevy_winit/src/state.rs:735`: the runner saves the selected `AppExit` and requests event-loop exit.
- `bevy_winit/src/state.rs:502`: `exiting` clears windows and calls `world.clear_all()` on the event-loop thread.
- `bevy_ecs/src/world/mod.rs:3362`: `clear_all` first calls `clear_entities`, including Resource components, then `clear_non_send`.
- Consequently `NativeReplayService::Drop` and `EffectClock` resource destruction precede the non-send `Application::Drop`. Their relative order is irrelevant: `EffectClock` has no custom destructor and dropping its `ClockHandle` only releases an `Arc`.
- `Service::Drop` calls `close`, and the contained canonical `ServiceHandle` destructor may call `close` again. `close_service` is idempotent when its owner is absent or the runtime is closed. It closes the parent before the configured service.
- `Application::close` calls runtime shutdown, removes its runtime/bridge handles, then shuts down CRT. Runtime shutdown also closes its owned service, so there is a fallback if service destruction has not already completed. `ClockHandle::raw_clock_sample` holds the lifetime gate and rejects a closed runtime before sampling.
- Bevy non-send storage validates that access/destruction happens on the insertion thread. The normal Winit callback path runs on that thread.

There is no demonstrated normal-path reversed destruction, use-after-free or deadlock in this chain. An actual window close, a return after window destruction, and error-path shutdown still need qualification; lack of that test is not evidence of a crash or leak.

## Concrete error-reporting defect

`Service::Drop`, `ServiceHandle::Drop` and `Application::Drop` can only print close errors. During Winit `exiting`, the runner has already stored the earlier `AppExit::Success`, so a cleanup failure does not update that result. In addition, `main.rs` discards the result of `.run()` and has return type `()`. Thus even an existing `AppExit::Error` does not set a failure process status. This is a source-demonstrated failure-reporting gap, conditional on cleanup/runner failure; no real window failure was reproduced here.

The staged `native_runtime_shutdown.rs` is an optional next-step correction for that gap and observable lifetime qualification, not a repair for a proven normal-order memory fault. Its exclusive `Last.after(ExitSystems)` system closes service → runtime → Application before Winit reads exit messages, retains every cleanup error, records a report, and writes `AppExit::Error` on failure. The resources remain present for idempotent fallback destruction. It never initializes an unused clock or creates a new application. The companion integration snippet captures `.run()` and asserts success to propagate failure through the existing `main()->()` without skipping destructors; exact numeric exit-code propagation would require a wider main signature/early-return edit.

Do not close these resources by adding code after `.run()`: `App::run` transfers them into the runner and replaces the caller's app with `App::empty()` first.

## Required follow-up qualification

1. Compile the staged system with the installed Bevy 0.19 API after the current build finishes.
2. A headless App test with the normal attachment, effect plugin and a real `AppExit` verifies one shutdown report, empty owners, rejected retained clock handle, and repeated exit idempotence. It must not claim a rendered/window test.
3. A second headless test exercises an early exit before clock initialization and confirms zero QPF/QPC calls and clean closure.
4. A real window test follows the actual close request (two-frame `ClosingWindow` handling), records the report before `clear_all`, waits for process termination, and verifies no worker/CRT errors. Repeat with the effects clock paused.
5. A controlled host-error test must prove close failures survive an eventual successful retry, publish `AppExit::Error`, and produce a nonzero process exit. This may need a test-only cleanup seam; none is invented in the staged proposal.

Abnormal process termination, abort, panic during another destructor, active-worker timeout and Winit startup failure are separate cases. The staged Last system does not guarantee it executes for those paths; existing destructors remain the fallback. FIFO contention and full gameplay/UI completion are outside this review.
