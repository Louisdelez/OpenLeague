use super::*;
use crate::audio_replay_windows_transport::{
    ConfigurationCallback, ConfigurationRequest, StreamConfigurationRequest, StreamOpenRequest,
};
fn input(mode: u32, host: Option<&[u8]>, callback: bool) -> StreamOpenRequest<'_> {
    StreamOpenRequest {
        mode,
        configuration: StreamConfigurationRequest {
            transport: ConfigurationRequest {
                host,
                port: 65535,
                arguments: [0x11223344, 0x55667788],
                callback: if callback {
                    Some(ConfigurationCallback {
                        owner: 0x44000000,
                        member: 0x728e20,
                    })
                } else {
                    None
                },
                sockaddr_frame: [165; 16],
            },
            key: std::array::from_fn(|i| i as u8),
            flag: 0x1234ff,
            extra: 0x88776655,
        },
    }
}
fn fully_closed(a: &mut Application, workers: u32) {
    a.close().unwrap();
    a.close().unwrap();
    let d = a.diagnostic().unwrap();
    assert_eq!(d["closed"], true);
    assert!(d["transport"].is_null());
    for key in [
        "heap_blocks",
        "retained_mirrors",
        "critical_sections",
        "heap_failures",
        "lock_failures",
    ] {
        assert_eq!(d["crt"][key], 0, "{key}");
    }
    assert_eq!(d["crt"]["heap_allocations"], d["crt"]["heap_frees"]);
    assert_eq!(d["workers_created"], workers);
    assert_eq!(d["workers_closed"], workers);
    assert_eq!(d["handle_failures"], 0);
    assert_eq!(d["worker_failures"], serde_json::json!([]));
}
#[test]
fn audio_replay_windows_opening_success_owns_two_shared_manager_references_and_retains_global_network_lifetime_after_stream_close(
) {
    for mode in [0, 1, 257] {
        for callback in [false, true] {
            let mut a = Application::new().unwrap();
            let r = a.transport().unwrap();
            assert_eq!(
                r.open_stream(input(mode, Some(b"127.0.0.1"), callback))
                    .unwrap(),
                0
            );
            let c = r.stream_snapshot().unwrap().unwrap();
            assert_eq!(c.return_code, Some(0));
            assert_eq!(c.state_id, 3);
            assert_eq!(c.manager, c.implementation_manager);
            assert_ne!(c.manager[0], 0);
            assert_eq!(c.manager_references, 2);
            assert_eq!(c.key_pointer.is_some(), mode == 0);
            if mode == 0 {
                assert_ne!(c.key_pointer, Some(0));
            }
            assert_eq!(
                r.snapshot().unwrap().references,
                if mode == 0 { 1 } else { 0 }
            );
            assert!(r.configuration_snapshot().unwrap().is_none());
            assert!(r.release().is_err());
            assert!(r
                .configure(input(0, None, false).configuration.transport)
                .is_err());
            assert!(r.open_stream(input(mode, None, !callback)).is_err());
            assert_eq!(r.stream_snapshot().unwrap(), Some(c));
            r.close_stream().unwrap();
            r.close_stream().unwrap();
            assert!(r.stream_snapshot().unwrap().is_none());
            assert_eq!(
                r.snapshot().unwrap().references,
                if mode == 0 { 1 } else { 0 }
            );
            assert_eq!(
                r.snapshot().unwrap().engine_allocations,
                if mode == 0 { 1 } else { 0 }
            );
            assert!(r.errors().is_empty());
            fully_closed(&mut a, if mode == 0 { 1 } else { 0 });
        }
    }
}
#[test]
fn audio_replay_windows_opening_failure_keeps_native_state1_manager_ownership_and_virtual_close_releases_the_key(
) {
    for (host, code) in [
        (None, 2),
        (Some(b"98.24.0.44".as_slice()), 3),
        (Some(b"example.invalid".as_slice()), 3),
    ] {
        for callback in [false, true] {
            let mut a = Application::new().unwrap();
            let r = a.transport().unwrap();
            assert_eq!(r.open_stream(input(0, host, callback)).unwrap(), code);
            let c = r.stream_snapshot().unwrap().unwrap();
            assert_eq!(c.return_code, Some(code));
            assert_eq!(c.state_id, 1);
            assert_eq!(c.key_pointer, Some(0));
            assert_ne!(c.manager[0], 0);
            assert_eq!(c.manager, c.implementation_manager);
            assert_eq!(c.manager_references, 2);
            assert_eq!(r.snapshot().unwrap().references, 0);
            assert_eq!(r.inspect_network(|n| n.outstanding()), (0, 0));
            assert!(r.errors().is_empty());
            fully_closed(&mut a, 1);
        }
    }
}
#[test]
fn audio_replay_windows_opening_application_drop_retires_stream_manager_transport_logger_and_crt_owners(
) {
    for mode in [0, 1] {
        for host in [b"127.0.0.1".as_slice(), b"98.24.0.44"] {
            let a = Application::new().unwrap();
            let root = a.root.clone();
            let report = a.report.clone();
            let locks = a.transport().unwrap().critical_section_report();
            a.transport()
                .unwrap()
                .open_stream(input(mode, Some(host), true))
                .unwrap();
            drop(a);
            root.context
                .with(|c| {
                    assert_eq!(c.services.inner.heap.outstanding(), 0);
                    assert_eq!(c.services.inner.heap.retained_mirrors(), 0);
                    assert!(c.services.locks.is_empty());
                })
                .unwrap();
            assert!(locks.failures().is_empty());
            assert!(report.failures().is_empty());
            assert_eq!(report.threads.created(), if mode == 0 { 1 } else { 0 });
            assert_eq!(report.threads.created(), report.threads.closed());
        }
    }
}

#[test]
fn audio_replay_windows_running_starts_restarts_and_joins_actual_source_stream_workers() {
    for mode in [1, 257] {
        let mut a = Application::new().unwrap();
        let r = a.transport().unwrap();
        r.open_stream(input(mode, None, false)).unwrap();
        for _ in 0..2 {
            assert_eq!(r.start_stream([1, 2, 3, 4, 5, 6]).unwrap(), 0);
            assert_eq!(r.start_stream([1, 2, 3, 4, 5, 6]).unwrap(), 8);
            std::thread::sleep(std::time::Duration::from_millis(30));
            assert_eq!(r.snapshot().unwrap().active_workers, 1);
            r.stop_stream().unwrap();
            r.stop_stream().unwrap();
            assert_eq!(r.snapshot().unwrap().active_workers, 0);
            assert_eq!(r.stream_snapshot().unwrap().unwrap().state_id, 3);
        }
        r.close_stream().unwrap();
        assert!(r.stream_snapshot().unwrap().is_none());
        assert!(r.errors().is_empty());
        fully_closed(&mut a, 2);
    }
}
#[test]
fn audio_replay_windows_running_application_close_stops_a_live_stream_before_freeing_its_bank() {
    for direct_drop in [false, true] {
        let mut a = Application::new().unwrap();
        let root = a.root.clone();
        let report = a.report.clone();
        let r = a.transport().unwrap();
        let locks = r.critical_section_report();
        r.open_stream(input(1, None, false)).unwrap();
        assert_eq!(r.start_stream([0; 6]).unwrap(), 0);
        std::thread::sleep(std::time::Duration::from_millis(30));
        assert_eq!(r.snapshot().unwrap().active_workers, 1);
        if !direct_drop {
            fully_closed(&mut a, 1);
        }
        drop(a);
        root.context
            .with(|c| {
                assert_eq!(c.services.inner.heap.outstanding(), 0);
                assert_eq!(c.services.inner.heap.retained_mirrors(), 0);
                assert!(c.services.locks.is_empty());
            })
            .unwrap();
        assert!(locks.failures().is_empty());
        assert!(report.failures().is_empty());
        assert_eq!(report.threads.created(), 1);
        assert_eq!(report.threads.closed(), 1);
    }
}
#[test]
fn audio_replay_windows_running_unsupported_host_does_not_start_an_orphan_worker_or_change_state() {
    let mut a = Application::new().unwrap();
    let r = a.transport().unwrap();
    r.open_stream(input(0, Some(b"127.0.0.1"), false)).unwrap();
    let before = r.stream_snapshot().unwrap();
    assert!(r
        .start_stream([0; 6])
        .unwrap_err()
        .contains("host creation/connection"));
    assert_eq!(r.stream_snapshot().unwrap(), before);
    assert_eq!(r.snapshot().unwrap().active_workers, 0);
    fully_closed(&mut a, 1);
}
