//! Proposed normal-window shutdown checkpoint. Not integrated or compiled.
//! Keep Drop as the fallback; expose cleanup failures before Winit reads AppExit.
#![cfg(windows)]
use bevy::{app::AppExit, ecs::message::Messages, prelude::*};
use openleague_core::audio_replay_windows_application::Application;

#[derive(Resource)]
pub struct ShutdownReport(pub serde_json::Value);

pub struct Plugin;
impl bevy::app::Plugin for Plugin {
    fn build(&self, app: &mut App) {
        app.add_systems(Last, close_on_exit.after(bevy::window::ExitSystems));
    }
}

/// Exclusive system: runs after normal frame consumers and the window exit
/// producer, on the owning thread. It retains both resources for idempotent Drop.
fn close_on_exit(world: &mut World) {
    if world.contains_resource::<ShutdownReport>()
        || !world.get_resource::<Messages<AppExit>>().is_some_and(|events| !events.is_empty())
    {
        return;
    }
    let mut errors = Vec::<String>::new();
    let clock = match world.get_non_send_resource::<Application>() {
        Some(owner) => match owner.transport().and_then(|runtime| runtime.clock_handle()) {
            Ok(clock) => Some(clock),
            Err(error) => { errors.push(format!("clock handle before close: {error}")); None }
        },
        None => { errors.push("normal replay Application is missing".into()); None }
    };
    if let Some(mut service) = world.get_resource_mut::<crate::NativeReplayService>() {
        if let Err(error) = service.0.close() {
            errors.push(format!("service close: {error:?}"));
        }
        if service.0.live_allocations() != 0 {
            errors.push("service retained allocations".into());
        }
    } else {
        errors.push("configured native replay service is missing".into());
    }

    // Application::close also calls runtime.shutdown. The explicit phase here
    // lets the normal window report transport owners before Application removes
    // its runtime. A failure is retained even if Application's retry succeeds.
    let runtime = (|| -> Result<serde_json::Value, String> {
        let owner = world.get_non_send_resource::<Application>().ok_or("Application missing")?;
        let runtime = owner.transport()?;
        runtime.shutdown()?;
        let state = runtime.snapshot()?;
        if state.engine_allocations != 0 || state.active_workers != 0 || state.handles != 0
            || state.critical_sections != 0 || !runtime.errors().is_empty()
        {
            return Err("runtime retained owners or recorded an error".into());
        }
        Ok(serde_json::json!({"engine_allocations":state.engine_allocations,
            "active_workers":state.active_workers,"handles":state.handles,
            "critical_sections":state.critical_sections,"errors":runtime.errors()}))
    })();
    if let Err(error) = &runtime { errors.push(format!("runtime close: {error}")); }
    let application = if let Some(mut owner) = world.get_non_send_resource_mut::<Application>() {
        if let Err(error) = owner.close() { errors.push(format!("Application close: {error}")); }
        match owner.diagnostic() {
            Ok(report) => {
                if report["closed"] != true || report["transport"] != serde_json::Value::Null
                    || report["workers_created"] != report["workers_closed"]
                    || report["workers_created"] != report["worker_completions"]
                    || report["worker_failures"] != serde_json::json!([]) || report["handle_failures"] != 0
                { errors.push("Application close/worker checks failed".into()); }
                for key in ["heap_blocks", "retained_mirrors", "critical_sections", "heap_failures", "lock_failures"] {
                    if report["crt"][key] != 0 { errors.push(format!("CRT {key} remains nonzero")); }
                }
                if report["crt"]["heap_allocations"] != report["crt"]["heap_frees"] {
                    errors.push("CRT allocation/free counts differ".into());
                }
                Some(report)
            }
            Err(error) => { errors.push(format!("Application diagnostic: {error}")); None }
        }
    } else { None };
    let clock_report = if let Some(clock) = clock {
        match clock.process_clock_snapshot() {
            Ok(snapshot) => {
                if snapshot.crt_allocations != 0 || snapshot.pending_mirrors != 0 || snapshot.inner_mutexes != 0
                    || !snapshot.registered_cleanups.is_empty() || snapshot.events_created != snapshot.events_closed
                    || snapshot.event_close_failures != 0 || snapshot.failure.is_some()
                { errors.push("clock shutdown ownership/failure checks failed".into()); }
                if clock.raw_clock_sample().is_ok() { errors.push("closed clock accepted a sample".into()); }
                match clock.process_clock_snapshot() {
                    Ok(after) if after == snapshot => {},
                    Ok(_) => errors.push("closed clock call mutated its snapshot".into()),
                    Err(error) => errors.push(format!("clock final snapshot: {error}")),
                }
                Some(serde_json::json!({"initialized":snapshot.initialized,"origin":snapshot.origin,
                    "frequency":snapshot.frequency,"qpf_calls":snapshot.qpf_calls,"qpc_calls":snapshot.qpc_calls,
                    "crt_allocations":snapshot.crt_allocations,"pending_mirrors":snapshot.pending_mirrors,
                    "inner_mutexes":snapshot.inner_mutexes,"registered_cleanups":snapshot.registered_cleanups,
                    "events_created":snapshot.events_created,"events_closed":snapshot.events_closed,
                    "event_close_failures":snapshot.event_close_failures,"failure":snapshot.failure}))
            }
            Err(error) => { errors.push(format!("clock shutdown snapshot: {error}")); None }
        }
    } else { None };
    let passed = errors.is_empty();
    let report = serde_json::json!({"checkpoint":"native-runtime-app-exit","passed":passed,"complete":false,
        "runtime":runtime.ok(),"application":application,"clock":clock_report,"errors":errors});
    eprintln!("NATIVE_RUNTIME_SHUTDOWN {report}");
    world.insert_resource(ShutdownReport(report));
    if !passed {
        // App::should_exit prioritizes an Error over the window's Success.
        world.write_message(AppExit::error());
    }
}
