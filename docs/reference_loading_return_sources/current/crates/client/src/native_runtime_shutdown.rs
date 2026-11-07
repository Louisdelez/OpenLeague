//! Normal-client shutdown checkpoint and independent post-run diagnostics.
//! Keep Drop as the fallback; expose cleanup failures before Winit reads AppExit.
#![cfg(windows)]
use bevy::{app::AppExit, ecs::message::Messages, prelude::*};
use openleague_core::audio_replay_windows_application::Application;
use openleague_core::audio_crt_windows_critical_sections as cs;
use std::sync::{Arc, Mutex};

#[derive(Resource, Clone)]
struct ReportSink(Arc<Mutex<Option<serde_json::Value>>>);

/// These are independent diagnostic records only: no Runtime, ClockHandle,
/// Application or native Section is retained across the runner's destruction.
pub struct Watch {
    sink: ReportSink,
    sections: Arc<cs::Report>,
}

fn watch(app: &mut App) -> Result<Watch, String> {
    if app.world().contains_resource::<ReportSink>() {
        return Err("native shutdown observer is already installed".into());
    }
    let sections = app.world().get_non_send_resource::<Application>()
        .ok_or("native shutdown observer requires Application")?
        .transport()?.critical_section_report();
    let sink = ReportSink(Arc::new(Mutex::new(None)));
    app.insert_resource(sink.clone());
    Ok(Watch { sink, sections })
}

pub fn install(app: &mut App) -> Result<Watch, String> {
    let watch = watch(app)?;
    app.add_plugins(Plugin);
    Ok(watch)
}

fn preserve_exit(exit: AppExit, cleanup_failed: bool) -> AppExit {
    if exit.is_error() || !cleanup_failed { exit } else { AppExit::error() }
}

impl Watch {
    fn after_runner(&self) -> (bool, serde_json::Value) {
        let (checkpoint, report_error) = match self.sink.0.lock() {
            Ok(report) => (report.clone(), None),
            Err(_) => (None, Some("shutdown report lock poisoned")),
        };
        let failures: Vec<String> = self.sections.failures().into_iter()
            .map(|e| format!("{e:?}")).collect();
        let failed = report_error.is_some() || !failures.is_empty()
            || checkpoint.as_ref().is_some_and(|v| v["passed"] == false);
        // Missing Last can mean an event-loop/initialization failure. Preserve
        // its returned exit code; absence alone is not a native cleanup error.
        (failed, serde_json::json!({"checkpoint_observed":checkpoint.is_some(),
            "checkpoint":checkpoint,"report_error":report_error,
            "critical_section_failures":failures,
            "critical_section_report_owners":Arc::strong_count(&self.sections),
            "direct_os_deletion_count_observed":false,"cleanup_failed":failed,
            "complete":false}))
    }

    pub fn finish(self, exit: AppExit) -> AppExit {
        let (failed, report) = self.after_runner();
        eprintln!("NATIVE_RUNTIME_AFTER_RUN {report}");
        preserve_exit(exit, failed)
    }
}

#[derive(Resource)]
pub struct ShutdownReport(pub serde_json::Value);

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
enum Phase { Service, Runtime, Application }

pub struct Plugin;
impl bevy::app::Plugin for Plugin {
    fn build(&self, app: &mut App) {
        app.add_systems(Last, close_on_exit.after(bevy::window::ExitSystems));
    }
}

/// Exclusive system: runs after normal frame consumers and the window exit
/// producer, on the owning thread. It retains both resources for idempotent Drop.
fn close_on_exit(world: &mut World) {
    close_on_exit_observed(world, |_, _| Ok(()));
}

// The ordinary system passes a no-op observer. Headless tests can inject one
// local observation failure without a global flag, resource, or environment
// override. Actual service/runtime/Application cleanup remains unchanged.
fn close_on_exit_observed(
    world: &mut World,
    mut observe: impl FnMut(Phase, &World) -> Result<(), String>,
) {
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
    let before_clock = clock.as_ref().and_then(|clock| match clock.process_clock_snapshot() {
        Ok(snapshot) => Some(snapshot),
        Err(error) => { errors.push(format!("clock snapshot before close: {error}")); None }
    });
    let mut phases = Vec::<&str>::new();
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
    phases.push("service");
    if let Err(error) = observe(Phase::Service, world) { errors.push(error); }

    // Application::close also calls runtime.shutdown. The explicit phase here
    // lets the normal window report transport owners before Application removes
    // its runtime. A failure is retained even if Application's retry succeeds.
    let runtime = (|| -> Result<serde_json::Value, String> {
        let owner = world.get_non_send_resource::<Application>().ok_or("Application missing")?;
        let runtime = owner.transport()?;
        runtime.shutdown()?;
        let state = runtime.snapshot()?;
        let section_failures = runtime.critical_section_report().failures();
        if state.engine_allocations != 0 || state.active_workers != 0 || state.handles != 0
            || !section_failures.is_empty() || !runtime.errors().is_empty()
        {
            return Err("runtime retained owners or recorded an error".into());
        }
        Ok(serde_json::json!({"engine_allocations":state.engine_allocations,
            "active_workers":state.active_workers,"handles":state.handles,
            // Runtime::shutdown owns dynamic retirement. Its Shared-scope
            // startup::MUTEX+8 Section remains until the final handles drop.
            // Count is evidence, not a magic-zero production error predicate.
            "critical_sections":state.critical_sections,
            "scope_critical_section_reference":openleague_core::audio_replay_transport_startup::MUTEX + 8,
            "critical_section_failures":section_failures.iter().map(|e|format!("{e:?}")).collect::<Vec<_>>(),
            "errors":runtime.errors()}))
    })();
    if let Err(error) = &runtime { errors.push(format!("runtime close: {error}")); }
    phases.push("runtime");
    if let Err(error) = observe(Phase::Runtime, world) { errors.push(error); }
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
    phases.push("application");
    if let Err(error) = observe(Phase::Application, world) { errors.push(error); }
    let clock_report = if let Some(clock) = clock {
        match clock.process_clock_snapshot() {
            Ok(snapshot) => {
                if snapshot.crt_allocations != 0 || snapshot.pending_mirrors != 0 || snapshot.inner_mutexes != 0
                    || !snapshot.registered_cleanups.is_empty() || snapshot.events_created != snapshot.events_closed
                    || snapshot.event_close_failures != 0 || snapshot.failure.is_some()
                { errors.push("clock shutdown ownership/failure checks failed".into()); }
                // Snapshot is a read of retained diagnostics only. Never invoke
                // either clock producer after closure, even to test rejection.
                if let Some(before) = &before_clock {
                    if (before.initialized, before.origin, before.frequency, before.qpf_calls, before.qpc_calls)
                        != (snapshot.initialized, snapshot.origin, snapshot.frequency, snapshot.qpf_calls, snapshot.qpc_calls)
                    { errors.push("shutdown changed process clock identity or sampled the producer".into()); }
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
    let mut report = serde_json::json!({"checkpoint":"native-runtime-app-exit","passed":passed,"complete":false,
        "phase_order":phases,"producer_sample_requested_during_shutdown":false,
        "runtime":runtime.ok(),"application":application,"clock":clock_report,"errors":errors});
    if let Some(sink) = world.get_resource::<ReportSink>() {
        match sink.0.lock() {
            Ok(mut saved) => *saved = Some(report.clone()),
            Err(_) => {
                report["passed"] = serde_json::json!(false);
                report["errors"].as_array_mut().unwrap().push(serde_json::json!("shutdown report lock poisoned"));
            }
        }
    }
    let passed = report["passed"] == true;
    eprintln!("NATIVE_RUNTIME_SHUTDOWN {report}");
    world.insert_resource(ShutdownReport(report));
    if !passed {
        // App::should_exit prioritizes an Error over the window's Success.
        world.write_message(AppExit::error());
    }
}

#[cfg(test)]
#[path = "native_runtime_shutdown_tests.rs"]
mod tests;
