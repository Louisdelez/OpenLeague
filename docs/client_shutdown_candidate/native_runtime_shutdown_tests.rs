//! Prepared tests: actual Bevy schedules + actual Windows native ownership.
//! These do not create a window or run Winit. No compiler has run this file.
use super::*;
use std::sync::{Arc, Mutex};

fn attached() -> App {
    let root = std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");
    let loaded = crate::native_user_settings::load(&root).expect("normal Game.cfg");
    let replay = crate::native_replay_service::Service::new(loaded.replay).unwrap();
    let mut app = App::new();
    app.insert_resource(crate::NativeReplayService(replay));
    crate::attach_native_replay_runtime(&mut app).unwrap();
    // Real default window-exit producer in Last/ExitSystems, with no window:
    // this is explicitly a headless query/exit test, not a window-close test.
    app.add_plugins(bevy::window::WindowPlugin {
        primary_window: None,
        ..Default::default()
    });
    app
}

fn assert_finished(app: &App, expected_qpf: u64) -> serde_json::Value {
    let report = &app.world().resource::<ShutdownReport>().0;
    assert_eq!(report["phase_order"], serde_json::json!(["service", "runtime", "application"]));
    assert_eq!(report["complete"], false);
    assert_eq!(report["producer_sample_requested_during_shutdown"], false);
    assert_eq!(report["clock"]["qpf_calls"], expected_qpf);
    assert_eq!(report["clock"]["crt_allocations"], 0);
    assert_eq!(report["clock"]["pending_mirrors"], 0);
    assert_eq!(report["clock"]["inner_mutexes"], 0);
    assert_eq!(report["clock"]["registered_cleanups"], serde_json::json!([]));
    assert_eq!(report["clock"]["events_created"], report["clock"]["events_closed"]);
    assert_eq!(report["clock"]["event_close_failures"], 0);
    assert_eq!(report["runtime"], serde_json::json!({"engine_allocations":0,
        "active_workers":0,"handles":0,"critical_sections":0,"errors":[]}));
    assert_eq!(report["application"]["closed"], true);
    assert_eq!(report["application"]["transport"], serde_json::Value::Null);
    for key in ["heap_blocks", "retained_mirrors", "critical_sections", "heap_failures", "lock_failures"] {
        assert_eq!(report["application"]["crt"][key], 0, "{key}");
    }
    assert_eq!(report["application"]["crt"]["heap_allocations"], report["application"]["crt"]["heap_frees"]);
    assert_eq!(app.world().resource::<crate::NativeReplayService>().0.live_allocations(), 0);
    assert!(app.world().non_send_resource::<Application>().transport().is_err());
    report.clone()
}

#[test]
fn normal_shutdown_last_observes_exit_and_closes_initialized_owners_once() {
    let mut app = attached();
    let source = app.world().non_send_resource::<Application>().transport().unwrap().clock_handle().unwrap();
    app.add_plugins((crate::native_effect_clock::Plugin, Plugin));
    app.update();
    // First executes the real clock once. Last's actual ExitSystems then emits
    // Success, and this plugin must finish before App::should_exit observes it.
    assert_eq!(app.should_exit(), Some(AppExit::Success));
    let report = assert_finished(&app, 1);
    assert_eq!(report["passed"], true);
    assert_eq!(report["errors"], serde_json::json!([]));
    assert_eq!(report["clock"]["qpc_calls"], 2); // init QPC + first effect frame
    let after = source.process_clock_snapshot().unwrap();
    let diagnostic = app.world().non_send_resource::<Application>().diagnostic().unwrap();
    app.world_mut().write_message(AppExit::Success);
    // Re-run only Last. A real Winit exit does not schedule another First frame.
    app.world_mut().run_schedule(Last);
    assert_eq!(app.world().resource::<ShutdownReport>().0, report);
    assert_eq!(source.process_clock_snapshot().unwrap(), after);
    assert_eq!(app.world().non_send_resource::<Application>().diagnostic().unwrap(), diagnostic);
    assert_eq!(app.should_exit(), Some(AppExit::Success));
    // Mirror Winit::exiting cleanup while retaining only a diagnostic handle.
    app.world_mut().clear_all();
    assert_eq!(source.process_clock_snapshot().unwrap(), after);
}

#[test]
fn normal_shutdown_keeps_injected_observation_error_and_error_exit_after_real_cleanup() {
    let mut app = attached();
    let source = app.world().non_send_resource::<Application>().transport().unwrap().clock_handle().unwrap();
    let observations = Arc::new(Mutex::new(Vec::<Phase>::new()));
    let recorded = observations.clone();
    app.add_plugins(crate::native_effect_clock::Plugin);
    // This replaces only the plugin system's no-op observer. Every cleanup
    // operation is real. It tests error propagation, not simulated HeapFree.
    app.add_systems(Last, (move |world: &mut World| {
        close_on_exit_observed(world, |phase, world| {
            recorded.lock().unwrap().push(phase);
            match phase {
                Phase::Service => {
                    assert_eq!(world.resource::<crate::NativeReplayService>().0.live_allocations(), 0);
                    let owner = world.non_send_resource::<Application>();
                    assert_eq!(owner.diagnostic().unwrap()["closed"], false);
                    assert_eq!(owner.transport().unwrap().process_clock_snapshot().unwrap().crt_allocations, 1);
                    Err("test-local shutdown observation failed".into())
                }
                Phase::Runtime => {
                    let owner = world.non_send_resource::<Application>();
                    let runtime = owner.transport().unwrap();
                    assert_eq!(runtime.snapshot().unwrap().engine_allocations, 0);
                    assert_eq!(runtime.process_clock_snapshot().unwrap().crt_allocations, 0);
                    assert_eq!(owner.diagnostic().unwrap()["closed"], false);
                    Ok(())
                }
                Phase::Application => {
                    assert_eq!(world.non_send_resource::<Application>().diagnostic().unwrap()["closed"], true);
                    Ok(())
                }
            }
        });
    }).after(bevy::window::ExitSystems));
    app.update();
    assert_eq!(app.should_exit(), Some(AppExit::error()));
    let report = assert_finished(&app, 1);
    assert_eq!(report["passed"], false);
    assert_eq!(report["errors"], serde_json::json!(["test-local shutdown observation failed"]));
    assert_eq!(*observations.lock().unwrap(), vec![Phase::Service, Phase::Runtime, Phase::Application]);
    let after = source.process_clock_snapshot().unwrap();
    app.world_mut().write_message(AppExit::Success); // must not overwrite Error
    app.world_mut().run_schedule(Last);
    assert_eq!(app.should_exit(), Some(AppExit::error()));
    assert_eq!(app.world().resource::<ShutdownReport>().0, report);
    assert_eq!(observations.lock().unwrap().len(), 3); // one checkpoint only
    assert_eq!(source.process_clock_snapshot().unwrap(), after);
    app.world_mut().clear_all();
    assert_eq!(source.process_clock_snapshot().unwrap(), after);
}

#[test]
fn normal_shutdown_before_first_clock_consumer_does_not_initialize_a_clock() {
    let mut app = attached();
    let source = app.world().non_send_resource::<Application>().transport().unwrap().clock_handle().unwrap();
    let before = source.process_clock_snapshot().unwrap();
    assert!(!before.initialized);
    app.add_plugins(Plugin);
    app.update();
    assert_eq!(app.should_exit(), Some(AppExit::Success));
    let report = assert_finished(&app, 0);
    assert_eq!(report["passed"], true);
    assert_eq!(report["clock"]["initialized"], false);
    assert_eq!(report["clock"]["qpc_calls"], 0);
    let after = source.process_clock_snapshot().unwrap();
    assert_eq!((after.origin, after.frequency, after.qpf_calls, after.qpc_calls),
               (before.origin, before.frequency, 0, 0));
    app.world_mut().clear_all();
    assert_eq!(source.process_clock_snapshot().unwrap(), after);
}
