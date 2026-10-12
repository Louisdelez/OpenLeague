use super::*;
use crate::{
    audio_announcer_registry_init as init, audio_crt_windows_engine_worker as bridge,
    audio_replay_transport_startup as net, audio_replay_windows_transport as runtime,
};
use init::Storage;
use std::sync::{
    atomic::{AtomicBool, AtomicUsize, Ordering},
    Mutex,
};
#[derive(Default)]
struct Messages {
    lines: Mutex<Vec<String>>,
    fail: AtomicBool,
}
impl runtime::Diagnostics for Messages {
    fn emit(&self, s: &str) -> Result<(), &'static str> {
        if self.fail.load(Ordering::Acquire) {
            return Err("explicit logger output failure");
        }
        self.lines.lock().unwrap().push(s.into());
        Ok(())
    }
}
fn globals() -> init::OwnedMemory {
    let v: Value = serde_json::from_str(&crate::audio_test_fixture(
        "data/4.20/replay_runtime_globals.json",
    ))
    .unwrap();
    assert_eq!(v["passed"], true);
    let mut m = init::OwnedMemory::new(0x39000000, 0xa5);
    for region in v["regions"].as_array().unwrap() {
        let p = region["address"].as_u64().unwrap() as u32;
        let bytes = bytes(region["hex"].as_str().unwrap());
        m.reserve_at(p, bytes.len() as u32).unwrap();
        for (i, b) in bytes.into_iter().enumerate() {
            m.write_byte(p + i as u32, b).unwrap();
        }
    }
    m
}
fn prepared_root(p: &Value, row: &Value) -> Arc<bridge::Root> {
    let mut c = prepare(p, row);
    c.memory.insert(
        0x14ae5f8,
        Memory {
            reference: 0x14ae5f8,
            raw: vec![0; 16],
        },
    );
    c.memory.insert(
        0x122343c,
        Memory {
            reference: 0x122343c,
            raw: u32::MAX.to_le_bytes().to_vec(),
        },
    );
    Arc::new(initialize(c, Some(retire)).unwrap())
}
fn assert_empty(root: &bridge::Root, expected: u32) {
    root.context
        .with(|c| {
            let h = c.services.inner.heap.report();
            assert_eq!((h.allocations(), h.frees()), (expected, expected));
            assert_eq!(c.services.inner.heap.outstanding(), 0);
            assert_eq!(c.services.inner.heap.retained_mirrors(), 0);
            assert!(h.failures().is_empty() && c.services.locks.is_empty());
        })
        .unwrap();
}
#[test]
fn audio_replay_windows_transport_6_roots_compose_full_launch_shared_globals_recursive_locks_native_naming_controls_and_concurrent_status_gates(
) {
    let p = fixture();
    let mut count = 0;
    for row in p["cases"]
        .as_array()
        .unwrap()
        .iter()
        .filter(|v| v["layout"] == "all" && v["failure"] == "none")
    {
        let root = prepared_root(&p, row);
        let bridge = Arc::new(bridge::Bridge::new(root.clone(), 0x41000000, 0x73000000).unwrap());
        let report = bridge.report();
        let messages = Arc::new(Messages::default());
        let runtime = runtime::Runtime::new(
            bridge.clone(),
            globals(),
            net::windows::WindowsNetwork::default(),
            0x2d78ed0,
            messages.clone(),
            0x40000000,
        )
        .unwrap();
        let locks = runtime.critical_section_report();
        assert_eq!(runtime.initialize().unwrap(), 1);
        assert_eq!(
            runtime.snapshot().unwrap(),
            runtime::Snapshot {
                status: 2,
                references: 1,
                pair: [0, 0],
                counters: [0; 5],
                engine_allocations: 0,
                handles: 0,
                active_workers: 0,
                critical_sections: 2
            }
        );
        assert_eq!(runtime.inspect_network(|n| n.outstanding()), (1, 1));
        std::thread::scope(|scope| {
            let tasks = (0..8)
                .map(|_| scope.spawn(|| runtime.initialize().unwrap()))
                .collect::<Vec<_>>();
            for task in tasks {
                assert_eq!(task.join().unwrap(), 1);
            }
        });
        assert_eq!(report.threads.created(), 1);
        assert_eq!(runtime.snapshot().unwrap().references, 1);
        runtime.release().unwrap();
        assert_eq!(runtime.inspect_network(|n| n.outstanding()), (0, 0));
        assert_eq!(runtime.snapshot().unwrap().status, 2);
        assert_eq!(runtime.snapshot().unwrap().references, 0);
        assert!(runtime.release().is_err());
        assert_eq!(runtime.initialize().unwrap(), 1);
        assert_eq!(report.threads.created(), 1);
        assert_eq!(runtime.inspect_network(|n| n.outstanding()), (0, 0));
        runtime.shutdown().unwrap();
        runtime.shutdown().unwrap();
        assert!(runtime.initialize().is_err());
        assert!(runtime.errors().is_empty());
        drop(runtime);
        assert!(locks.failures().is_empty());
        let lines = messages.lines.lock().unwrap();
        assert_eq!(lines.len(), 1);
        assert!(
            lines[0].contains("Current Allocations = 0")
                && lines[0].contains("Out of Pool dealloc = 0")
        );
        drop(lines);
        assert_eq!((report.threads.created(), report.threads.closed()), (1, 1));
        assert_eq!(report.completions().len(), 1);
        assert_eq!(report.completions()[0].code, 0);
        assert!(report.failures().is_empty() && report.threads.failures().is_empty());
        drop(bridge);
        root.shutdown().unwrap();
        assert_empty(&root, 2);
        count += 1;
    }
    assert_eq!(count, 6);
}
struct FailFirst {
    calls: Arc<AtomicUsize>,
    inner: net::windows::WindowsNetwork,
}
impl net::Network for FailFirst {
    fn winsock_startup(&mut self, v: u16) -> Result<net::Negotiation, net::Error> {
        assert_eq!(v, 0x202);
        if self.calls.fetch_add(1, Ordering::AcqRel) == 0 {
            Ok(net::Negotiation {
                code: 10093,
                version: 0,
            })
        } else {
            self.inner.winsock_startup(v)
        }
    }
    fn winsock_cleanup(&mut self) -> Result<u32, net::Error> {
        self.inner.winsock_cleanup()
    }
    fn timer_begin(&mut self, p: u32) -> Result<u32, net::Error> {
        self.inner.timer_begin(p)
    }
    fn timer_end(&mut self, p: u32) -> Result<u32, net::Error> {
        self.inner.timer_end(p)
    }
}
#[test]
fn audio_replay_windows_transport_failure_retry_preserves_native_status_and_retires_both_real_threads_and_global_resources(
) {
    let p = fixture();
    let row = p["cases"]
        .as_array()
        .unwrap()
        .iter()
        .find(|v| v["layout"] == "all" && v["failure"] == "none")
        .unwrap();
    let root = prepared_root(&p, row);
    let bridge = Arc::new(bridge::Bridge::new(root.clone(), 0x41000000, 0x73000000).unwrap());
    let report = bridge.report();
    let calls = Arc::new(AtomicUsize::new(0));
    let messages = Arc::new(Messages::default());
    let runtime = runtime::Runtime::new(
        bridge.clone(),
        globals(),
        FailFirst {
            calls: calls.clone(),
            inner: net::windows::WindowsNetwork::default(),
        },
        0x2d78ed0,
        messages.clone(),
        0x40000000,
    )
    .unwrap();
    assert_eq!(runtime.initialize().unwrap(), 1);
    let state = runtime.snapshot().unwrap();
    assert_eq!(
        (
            state.status,
            state.references,
            state.engine_allocations,
            state.handles
        ),
        (3, 0, 0, 0)
    );
    assert_eq!(runtime.inspect_network(|n| n.inner.outstanding()), (0, 0));
    assert_eq!(*messages.lines.lock().unwrap(), vec![net::FAILURE_MESSAGE]);
    assert_eq!(runtime.initialize().unwrap(), 1);
    let state = runtime.snapshot().unwrap();
    assert_eq!(
        (
            state.status,
            state.references,
            state.engine_allocations,
            state.handles
        ),
        (2, 1, 0, 0)
    );
    assert_eq!(calls.load(Ordering::Acquire), 2);
    assert_eq!(runtime.inspect_network(|n| n.inner.outstanding()), (1, 1));
    runtime.shutdown().unwrap();
    assert_eq!(runtime.inspect_network(|n| n.inner.outstanding()), (0, 0));
    assert!(runtime.errors().is_empty());
    drop(runtime);
    assert_eq!((report.threads.created(), report.threads.closed()), (2, 2));
    assert_eq!(report.completions().len(), 2);
    assert!(report.failures().is_empty() && report.threads.failures().is_empty());
    drop(bridge);
    root.shutdown().unwrap();
    assert_empty(&root, 3);
}
#[test]
fn audio_replay_windows_transport_logger_failure_is_reported_without_fabricating_readiness_or_leaking_the_worker(
) {
    let p = fixture();
    let row = p["cases"]
        .as_array()
        .unwrap()
        .iter()
        .find(|v| v["layout"] == "all" && v["failure"] == "none")
        .unwrap();
    let root = prepared_root(&p, row);
    let bridge = Arc::new(bridge::Bridge::new(root.clone(), 0x41000000, 0x73000000).unwrap());
    let report = bridge.report();
    let messages = Arc::new(Messages::default());
    messages.fail.store(true, Ordering::Release);
    let runtime = runtime::Runtime::new(
        bridge.clone(),
        globals(),
        FailFirst {
            calls: Arc::new(AtomicUsize::new(0)),
            inner: net::windows::WindowsNetwork::default(),
        },
        0x2d78ed0,
        messages,
        0x40000000,
    )
    .unwrap();
    assert_eq!(runtime.initialize().unwrap(), 1);
    let state = runtime.snapshot().unwrap();
    assert_eq!(
        (
            state.status,
            state.references,
            state.engine_allocations,
            state.handles
        ),
        (1, 0, 0, 0)
    );
    assert_eq!(report.completions()[0].code, bridge::FAILED);
    assert_eq!(report.failures().len(), 1);
    assert_eq!(runtime.errors().len(), 1);
    runtime.shutdown().unwrap();
    let locks = runtime.critical_section_report();
    drop(runtime);
    assert!(locks.failures().is_empty());
    assert_eq!((report.threads.created(), report.threads.closed()), (1, 1));
    drop(bridge);
    root.shutdown().unwrap();
    assert_empty(&root, 2);
}

fn lazy_logger_globals(fill: u8) -> init::OwnedMemory {
    use crate::{audio_announcer_owner_metadata as cb, audio_replay_logger as log};
    let mut m = globals();
    Storage::write_word(&mut m, log::POINTER, 0).unwrap();
    for i in 0..36 {
        m.write_byte(log::LOGGER + i, fill).unwrap();
    }
    m.write_byte(log::REINITIALIZE, 0).unwrap();
    m.write_byte(log::REGISTERED, 0).unwrap();
    for (p, len) in [
        (log::BUFFER, log::CAPACITY as u32),
        (cb::HANDLER_VTABLE, 12),
    ] {
        m.reserve_at(p, len).unwrap();
        for i in 0..len {
            m.write_byte(p + i, 0).unwrap();
        }
    }
    for (p, v) in [
        (cb::HANDLER_VTABLE, cb::HANDLER_DELETE),
        (cb::HANDLER_VTABLE + 4, cb::HANDLER_CLONE),
        (cb::HANDLER_VTABLE + 8, log::INVOKE),
    ] {
        Storage::write_word(&mut m, p, v).unwrap();
    }
    m
}
fn stamp(t: [u16; 8]) -> String {
    format!(
        "{:04}-{:02}-{:02}T{:02}-{:02}-{:02}",
        t[0], t[1], t[3], t[4], t[5], t[6]
    )
}
fn assert_clock_and_message(message: &[u8], before: [u16; 8], after: [u16; 8], body: &str) {
    let message = std::str::from_utf8(message).unwrap();
    assert!(message.len() >= 21);
    assert!(&message[..19] >= stamp(before).as_str() && &message[..19] <= stamp(after).as_str());
    assert_eq!(&message[19..], format!(": {body}\n"));
}
#[test]
fn audio_replay_windows_transport_6_roots_create_native_logger_lazily_with_host_clock_and_free_callback_and_lock_after_release(
) {
    use crate::{audio_announcer_owner_metadata as cb, audio_replay_logger as log};
    let p = fixture();
    let mut count = 0;
    for row in p["cases"]
        .as_array()
        .unwrap()
        .iter()
        .filter(|v| v["layout"] == "all" && v["failure"] == "none")
    {
        let root = prepared_root(&p, row);
        let bridge = Arc::new(bridge::Bridge::new(root.clone(), 0x41000000, 0x73000000).unwrap());
        let report = bridge.report();
        let runtime = runtime::Runtime::new_with_native_logger(
            bridge.clone(),
            lazy_logger_globals(if count % 2 == 0 { 0 } else { 165 }),
            net::windows::WindowsNetwork::default(),
            0x40000000,
        )
        .unwrap();
        let locks = runtime.critical_section_report();
        assert_eq!(
            runtime.logger_snapshot().unwrap(),
            runtime::LoggerSnapshot {
                pointer: 0,
                flags: [0, 0],
                callback: None,
                shutdown_registrations: vec![],
                last_message: vec![]
            }
        );
        assert_eq!(runtime.snapshot().unwrap().critical_sections, 1);
        assert_eq!(runtime.initialize().unwrap(), 1);
        assert_eq!(runtime.logger_snapshot().unwrap().pointer, 0);
        assert_eq!(runtime.snapshot().unwrap().engine_allocations, 0);
        let before = log::local_time();
        runtime.release().unwrap();
        let after = log::local_time();
        let logger = runtime.logger_snapshot().unwrap();
        assert_eq!(logger.pointer, log::LOGGER);
        assert_eq!(logger.flags, [0, 0]);
        assert_eq!(
            logger.callback,
            Some([cb::HANDLER_VTABLE, log::LOGGER, log::DEFAULT_MEMBER])
        );
        assert_eq!(logger.shutdown_registrations, vec![log::SHUTDOWN]);
        assert_clock_and_message(&logger.last_message,before,after,"Memory Allocations \n Current Allocations = 0 \n Total Allocations = 0 \n Max Allocations = 0 \n Out of Pool Allocations = 0 \n Out of Pool dealloc = 0 \n");
        let state = runtime.snapshot().unwrap();
        assert_eq!(
            (
                state.status,
                state.references,
                state.engine_allocations,
                state.critical_sections
            ),
            (2, 0, 1, 2)
        );
        assert_eq!(runtime.inspect_network(|n| n.outstanding()), (0, 0));
        runtime.shutdown().unwrap();
        runtime.shutdown().unwrap();
        let final_state = runtime.snapshot().unwrap();
        assert_eq!(
            (
                final_state.engine_allocations,
                final_state.handles,
                final_state.active_workers,
                final_state.critical_sections
            ),
            (0, 0, 0, 1)
        );
        let retired = runtime.logger_snapshot().unwrap();
        assert_eq!(
            (retired.pointer, retired.flags, retired.callback),
            (0, [1, 0], None)
        );
        assert_eq!(retired.last_message, logger.last_message);
        assert!(runtime.errors().is_empty());
        drop(runtime);
        assert!(locks.failures().is_empty());
        assert_eq!((report.threads.created(), report.threads.closed()), (1, 1));
        assert!(report.failures().is_empty());
        drop(bridge);
        root.shutdown().unwrap();
        assert_empty(&root, 2);
        count += 1;
    }
    assert_eq!(count, 6);
}
#[test]
fn audio_replay_windows_transport_native_logger_survives_failed_network_then_retry_and_is_retired_by_shutdown(
) {
    use crate::audio_replay_logger as log;
    let p = fixture();
    let row = p["cases"]
        .as_array()
        .unwrap()
        .iter()
        .find(|v| v["layout"] == "all" && v["failure"] == "none")
        .unwrap();
    let root = prepared_root(&p, row);
    let bridge = Arc::new(bridge::Bridge::new(root.clone(), 0x41000000, 0x73000000).unwrap());
    let report = bridge.report();
    let calls = Arc::new(AtomicUsize::new(0));
    let runtime = runtime::Runtime::new_with_native_logger(
        bridge.clone(),
        lazy_logger_globals(165),
        FailFirst {
            calls: calls.clone(),
            inner: net::windows::WindowsNetwork::default(),
        },
        0x40000000,
    )
    .unwrap();
    let before = log::local_time();
    assert_eq!(runtime.initialize().unwrap(), 1);
    let after = log::local_time();
    let state = runtime.snapshot().unwrap();
    assert_eq!(
        (
            state.status,
            state.references,
            state.engine_allocations,
            state.critical_sections
        ),
        (3, 0, 1, 2)
    );
    let logger = runtime.logger_snapshot().unwrap();
    assert_clock_and_message(&logger.last_message, before, after, net::FAILURE_MESSAGE);
    assert_eq!(runtime.initialize().unwrap(), 1);
    assert_eq!(runtime.logger_snapshot().unwrap(), logger);
    assert_eq!(calls.load(Ordering::Acquire), 2);
    let state = runtime.snapshot().unwrap();
    assert_eq!(
        (state.status, state.references, state.engine_allocations),
        (2, 1, 1)
    );
    runtime.shutdown().unwrap();
    assert_eq!(runtime.inspect_network(|n| n.inner.outstanding()), (0, 0));
    assert_eq!(runtime.logger_snapshot().unwrap().flags, [1, 0]);
    assert_eq!(runtime.snapshot().unwrap().engine_allocations, 0);
    assert!(runtime.errors().is_empty());
    drop(runtime);
    assert_eq!((report.threads.created(), report.threads.closed()), (2, 2));
    assert_eq!(report.completions().len(), 2);
    assert!(report.failures().is_empty());
    drop(bridge);
    root.shutdown().unwrap();
    assert_empty(&root, 3);
}
