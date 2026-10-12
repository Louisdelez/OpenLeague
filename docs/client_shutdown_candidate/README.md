# Normal client shutdown candidate

Prepared source and three headless Windows tests only. This lot has not been compiled, executed, or integrated. It does not qualify a real window close, graphics teardown, or a complete game. The earlier `process_clock_client_shutdown_review` lot remains unchanged.

## Source finding and schedule

The existing normal Drop order is already compatible with the native owners. Winit 0.19 `state.rs::exiting` calls `World::clear_all`, which clears ECS resources before non-send resources. `NativeReplayService` is a resource, and `Application` is non-send. `Application::close` shuts down transport before CRT. No normal shutdown leak or use-after-free was demonstrated.

The concrete reporting gap is conditional: native Drop implementations log cleanup errors after Winit has already selected its exit result, and the existing `main` discards the `AppExit` returned by `app.run()`.

The candidate runs one exclusive checkpoint in `Last.after(bevy::window::ExitSystems)`. The actual default `WindowPlugin` emits `AppExit::Success` in `ExitSystems` when its window query is empty. Winit reads `app.should_exit()` after the main update; `should_exit` prioritizes an error among buffered exit messages. The checkpoint can therefore retain an error without hiding the window's original exit request. No client system currently registered in Last consumes the native clock; this remains a constraint for future schedules. This source audit is not a Winit event-loop execution test.

## Cleanup and test seam

The checkpoint performs service close, transport shutdown with its ownership snapshot, and Application close with its CRT report. It retains errors from earlier phases even when later cleanup succeeds. It then reads retained clock diagnostics only. It never invokes `raw_clock_sample` or `wall_clock_f32_bits`, including after closure. Publishing a clock handle for diagnostics does not initialize the clock.

`ShutdownReport` guards the checkpoint, so subsequent Last runs do not repeat its phases. This means one effective cleanup sequence, not exactly one call to the Rust method named `Runtime::shutdown`: `Application::close` invokes that method again, and the already-closed guard returns immediately. Existing Drop fallbacks also remain idempotent. The tests check stable ownership counters and a single observed phase sequence, rather than claiming to count every no-op method entry.

The private `close_on_exit_observed` function accepts a local observer. The ordinary plugin passes a no-op closure. A test closure returns one error after the real service close and inspects the following real cleanup phases. There is no environment switch, mutable global fault marker, or production test resource. This qualifies the checkpoint's error retention if run; it does not inject or claim an actual Windows HeapFree or worker failure.

## Prepared tests

All tests construct the real configured service from the normal `Game.cfg` loader and call the existing `attach_native_replay_runtime` once. They use `WindowPlugin { primary_window: None, ..Default::default() }` to exercise its actual exit producer without Winit, a renderer, or a window.

1. `normal_shutdown_last_observes_exit_and_closes_initialized_owners_once`: the actual EffectClock plugin initializes the canonical clock in First; Last observes Success and closes owners. Expects QPF=1 and QPC=2, zero live ownership, one unchanged report after another Last run, and stable diagnostics after `clear_all`.
2. `normal_shutdown_keeps_injected_observation_error_and_error_exit_after_real_cleanup`: observes the real service, runtime, Application phases, injects a local error after service close, checks all later cleanup still completes, and checks Error remains preferred after another Success request. One phase sequence and unchanged clock counters are required.
3. `normal_shutdown_before_first_clock_consumer_does_not_initialize_a_clock`: closes without the EffectClock schedule; expects QPF=0, QPC=0, unchanged uninitialized identity, and no owned clock allocation.

The second Last run deliberately does not run First: a real Winit exit does not start another normal frame after selecting exit. Tests retain only diagnostic handles after closure, never sample the closed clock producer.

## Integration proposal

`main_integration.rs.txt` shows the module declaration, normal-path plugin registration, and capture of `.run()`'s result. The final assertion gives a nonzero process result by unwinding if the runner reports an error, while preserving `fn main() -> ()` and all existing early CLI `return;` branches. It does not preserve an exact AppExit numeric error code. The process exit status itself has not been tested in this lot.

Do not close resources after `app.run()` on the original App: Bevy replaces that App with an empty one and moves the configured App into its runner. The checkpoint must live inside that runner's schedules. Headless tests can be merged into the Windows client module and run by the root only after the current build is finished.

## Remaining qualification

- Compile and run the three proposed Windows client tests against the current root source.
- Confirm a real window close produces the checkpoint before Winit exits and returns the intended process status.
- A fault in the OS allocator, OS events, or a surviving worker is outside the injected-observer test; no such failure is declared qualified.
- No panic interception is added. Existing fallible cleanup methods may still panic on poisoned locks; this checkpoint does not convert panics into AppExit errors.

The manifest records source hashes, frozen baseline hashes, and explicit false flags for compilation, execution, integration, and real-window qualification.
