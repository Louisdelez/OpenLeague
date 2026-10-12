//! Application-owned CRT and replay transport, built from actual initial PE data.
//! Creation does not open a replay or acquire a network reference; native stream
//! configuration must explicitly request transport initialization when needed.
use crate::{
    audio_bus_bank::Error, audio_crt_windows_critical_sections as cs,
    audio_crt_windows_engine_worker as worker, audio_crt_windows_fls_slot::Context,
    audio_crt_windows_global_services::NativeGlobal, audio_crt_windows_process_heap as heap,
    audio_crt_windows_root_startup as startup, audio_replay_runtime_image as image,
    audio_replay_transport_startup::windows::WindowsNetwork,
    audio_replay_windows_transport as transport,
};
use std::{collections::BTreeSet, marker::PhantomData, rc::Rc, sync::Arc};
pub type Runtime = transport::Runtime<WindowsNetwork>;
pub struct Application {
    runtime: Option<Runtime>,
    bridge: Option<Arc<worker::Bridge>>,
    root: Arc<worker::Root>,
    report: Arc<worker::Report>,
    closed: bool,
    // Root creation/explicit shutdown stay on the application's owning thread.
    _thread_owner: PhantomData<Rc<()>>,
}
fn retire(context: &mut Context<worker::Services>) -> Result<(), Error> {
    context
        .services
        .inner
        .heap
        .retire_mirrors(&mut context.memory, &mut context.dead)
        .map(|_| ())
        .map_err(|_| Error::Backend("application CRT mirror retirement failed"))
}
impl Application {
    pub fn new() -> Result<Self, String> {
        let image::Initial { mut crt, transport } = image::load()?;
        let dead = BTreeSet::new();
        let mut heap = heap::Heap::new(0x71000000, 0x50000000)
            .map_err(|e| format!("process heap owner: {e:?}"))?;
        if heap
            .initialize(&mut crt, &dead)
            .map_err(|e| format!("process heap startup: {e:?}"))?
            != 1
        {
            return Err("Windows process heap unavailable".into());
        }
        let native =
            NativeGlobal::new(0x72000000).map_err(|e| format!("native API registry: {e:?}"))?;
        let context = Context {
            memory: crt,
            dead,
            services: cs::Provider {
                inner: heap::Provider {
                    inner: native,
                    heap,
                },
                locks: cs::Bank::default(),
            },
        };
        // The frame label is canonical32-bit integer entropy, never a host pointer.
        // Successful QueryPerformanceCounter overwrites both initial words.
        let root = Arc::new(
            startup::initialize_with_cookie(
                context,
                Some(retire),
                0x4001fff8,
                [0, 0],
                &mut crate::audio_security_cookie::WindowsEntropy,
            )
            .map_err(|e| format!("application CRT startup: {e:?}"))?,
        );
        if root.status != 1 {
            return Err("application CRT startup returned failure".into());
        }
        let bridge = Arc::new(worker::Bridge::new(root.clone(), 0x41000000, 0x73000000)?);
        let report = bridge.report();
        let runtime = Runtime::new_with_native_logger(
            bridge.clone(),
            transport,
            WindowsNetwork::default(),
            0x40000000,
        )?;
        Ok(Self {
            runtime: Some(runtime),
            bridge: Some(bridge),
            root,
            report,
            closed: false,
            _thread_owner: PhantomData,
        })
    }
    pub fn transport(&self) -> Result<&Runtime, String> {
        self.runtime
            .as_ref()
            .ok_or_else(|| "application replay runtime is closed".into())
    }
    pub fn close(&mut self) -> Result<(), String> {
        if self.closed {
            return Ok(());
        }
        if let Some(runtime) = &self.runtime {
            runtime.shutdown()?;
        }
        self.runtime.take();
        self.bridge.take();
        self.root
            .shutdown()
            .map_err(|e| format!("application CRT shutdown: {e:?}"))?;
        self.closed = true;
        Ok(())
    }
    pub fn diagnostic(&self) -> Result<serde_json::Value, String> {
        let crt=self.root.context.with(|c|->Result<serde_json::Value,Error>{
            let word=|p|crate::audio_path_source_virtual_cleanup::get(&c.memory,&c.dead,p,4);
            let heap=c.services.inner.heap.report();
            Ok(serde_json::json!({"slot_index":word(0x12230cc)?,"cookie":word(0x1222ed0)?,"cookie_complement":word(0x1222ed4)?,
                "mb_references":word(0x1222bb0)?,"locale_references":word(0x1223240)?,"heap_blocks":c.services.inner.heap.outstanding(),
                "retained_mirrors":c.services.inner.heap.retained_mirrors(),"heap_allocations":heap.allocations(),"heap_frees":heap.frees(),
                "heap_failures":heap.failures().len(),"critical_sections":c.services.locks.len(),"lock_failures":c.services.locks.report().failures().len()}))
        }).map_err(|e|format!("CRT diagnostic: {e:?}"))?.map_err(|e|format!("CRT bank diagnostic: {e:?}"))?;
        let runtime = if let Some(r) = &self.runtime {
            let s = r.snapshot()?;
            let logger = r.logger_snapshot()?;
            let network = r.inspect_network(|n| n.outstanding());
            serde_json::json!({"status":s.status,"references":s.references,"thread_pair":s.pair,"engine_allocations":s.engine_allocations,"handles":s.handles,"active_workers":s.active_workers,"critical_sections":s.critical_sections,
                "winsock_references":network.0,"timer_references":network.1,"logger_pointer":logger.pointer,"logger_flags":logger.flags,"logger_shutdown_registrations":logger.shutdown_registrations,"errors":r.errors(),"configuration":r.configuration_snapshot()?,"stream":r.stream_snapshot()?,"game_manager":r.game_manager_snapshot()?})
        } else {
            serde_json::Value::Null
        };
        Ok(
            serde_json::json!({"native_source_sha256":image::SOURCE_SHA256,"closed":self.closed,"crt":crt,"transport":runtime,
            "workers_created":self.report.threads.created(),"workers_closed":self.report.threads.closed(),"worker_completions":self.report.completions().len(),"worker_failures":self.report.failures(),"handle_failures":self.report.threads.failures().len()}),
        )
    }
}
impl Drop for Application {
    fn drop(&mut self) {
        if let Err(error) = self.close() {
            eprintln!("Replay application shutdown failed: {error}");
        }
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn audio_replay_windows_application_from_production_pe_bytes_starts_idle_then_runs_and_retires4_real_workers_without_fixtures(
    ) {
        for start in [false, true, false, true, false, true, false, true] {
            let mut application = Application::new().unwrap();
            let before = application.diagnostic().unwrap();
            assert_eq!(before["transport"]["status"], 0);
            assert_eq!(before["transport"]["references"], 0);
            assert_eq!(before["transport"]["logger_pointer"], 0);
            assert_eq!(before["crt"]["heap_blocks"], 1);
            assert_eq!(before["crt"]["heap_allocations"], 1);
            assert_eq!(before["workers_created"], 0);
            let cookie = before["crt"]["cookie"].as_u64().unwrap() as u32;
            assert_ne!(cookie, crate::audio_security_cookie::DEFAULT);
            assert_ne!(cookie >> 16, 0);
            assert_eq!(before["crt"]["cookie_complement"], !cookie);
            if start {
                assert_eq!(application.transport().unwrap().initialize().unwrap(), 1);
                let running = application.diagnostic().unwrap();
                assert_eq!(running["transport"]["status"], 2);
                assert_eq!(running["transport"]["references"], 1);
                assert_eq!(running["transport"]["winsock_references"], 1);
                assert_eq!(running["transport"]["timer_references"], 1);
                assert_eq!(running["workers_created"], 1);
                assert_eq!(running["workers_closed"], 1);
            }
            application.close().unwrap();
            application.close().unwrap();
            assert!(application.transport().is_err());
            let after = application.diagnostic().unwrap();
            assert_eq!(after["closed"], true);
            assert!(after["transport"].is_null());
            assert_eq!(after["crt"]["slot_index"], u32::MAX);
            assert_eq!(after["crt"]["heap_blocks"], 0);
            assert_eq!(after["crt"]["retained_mirrors"], 0);
            assert_eq!(after["crt"]["critical_sections"], 0);
            assert_eq!(after["crt"]["heap_allocations"], if start { 2 } else { 1 });
            assert_eq!(after["crt"]["heap_allocations"], after["crt"]["heap_frees"]);
            for key in ["heap_failures", "lock_failures"] {
                assert_eq!(after["crt"][key], 0);
            }
            assert_eq!(after["worker_failures"], serde_json::json!([]));
            assert_eq!(after["handle_failures"], 0);
            for key in ["mb_references", "locale_references"] {
                assert_eq!(
                    after["crt"][key].as_u64().unwrap() + 1,
                    before["crt"][key].as_u64().unwrap()
                );
            }
        }
    }
    #[test]
    fn audio_replay_windows_application_drop_releases_real_heap_fls_and_locks_after_production_initialization(
    ) {
        let application = Application::new().unwrap();
        let root = application.root.clone();
        let slot = root.slot.as_ref().unwrap().clone();
        application.transport().unwrap().initialize().unwrap();
        drop(application);
        assert_eq!(slot.report().failure(), None);
        root.context
            .with(|c| {
                assert_eq!(c.services.inner.heap.outstanding(), 0);
                assert!(c.services.locks.is_empty());
                assert_eq!(c.services.inner.heap.retained_mirrors(), 0);
            })
            .unwrap();
    }
}

#[cfg(test)]
#[path = "audio_replay_windows_configuration_tests.rs"]
mod configuration_tests;

#[cfg(test)]
#[path = "audio_replay_windows_opening_tests.rs"]
mod opening_tests;
#[cfg(test)]
#[path = "audio_replay_windows_recording_tests.rs"]
mod recording_tests;
