use super::*;
use crate::audio_replay_windows_transport::{ConfigurationCallback, ConfigurationRequest};
fn request(host: Option<&[u8]>, port: u32, fill: u8) -> ConfigurationRequest<'_> {
    ConfigurationRequest {
        host,
        port,
        arguments: [0x11223344, 0x55667788],
        callback: None,
        sockaddr_frame: [fill; 16],
    }
}
fn closed(a: &mut Application) {
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
    assert_eq!(d["workers_created"], d["workers_closed"]);
    assert_eq!(d["handle_failures"], 0);
    assert_eq!(d["worker_failures"], serde_json::json!([]));
}
#[test]
fn audio_replay_windows_configuration_real_numeric_lifetimes_use_original_uid_arguments_and_retire_all_resources(
) {
    for (host, port) in [
        (b"127.0.0.1".as_slice(), 0),
        (b"127.1", 1024),
        (b"0177.0.0.1", 12345),
        (b"0x7f000001", 0x1234ffff),
    ] {
        let mut a = Application::new().unwrap();
        let runtime = a.transport().unwrap();
        assert_eq!(
            runtime.configure(request(Some(host), port, 165)).unwrap(),
            0
        );
        let c = runtime.configuration_snapshot().unwrap().unwrap();
        assert_eq!(c.return_code, Some(0));
        assert_eq!(c.ipv4, 0x0100007f);
        assert_eq!(c.requested_port, port as u16);
        assert_eq!(c.uid, 0xff2199f5);
        assert_eq!(c.address_text, b"127.0.0.1");
        assert_eq!(c.arguments, [0x11223344, 0x55667788]);
        assert_eq!(c.callback, None);
        assert_eq!(c.host, 0);
        assert_eq!(c.queue_count, 0);
        let state = runtime.snapshot().unwrap();
        assert_eq!(state.references, 1);
        assert_eq!(state.engine_allocations, 3);
        assert_eq!(state.critical_sections, 3);
        assert_eq!(runtime.inspect_network(|n| n.outstanding()), (1, 1));
        assert!(runtime.release().is_err());
        runtime.close_configuration().unwrap();
        runtime.close_configuration().unwrap();
        assert!(runtime.configuration_snapshot().unwrap().is_none());
        assert_eq!(runtime.inspect_network(|n| n.outstanding()), (0, 0));
        assert_eq!(runtime.snapshot().unwrap().engine_allocations, 1);
        assert!(runtime.errors().is_empty());
        closed(&mut a);
    }
}
#[test]
fn audio_replay_windows_configuration_localhost_keeps_caller_socket_port_and_actual_windows_lookup()
{
    for fill in [0, 165] {
        let mut a = Application::new().unwrap();
        let r = a.transport().unwrap();
        assert_eq!(
            r.configure(request(Some(b"localhost"), 12345, fill))
                .unwrap(),
            0
        );
        let c = r.configuration_snapshot().unwrap().unwrap();
        assert_eq!(c.ipv4, 0x0100007f);
        assert_eq!(c.requested_port, 12345);
        let mut socket = [fill; 16];
        socket[..2].copy_from_slice(&2u16.to_le_bytes());
        socket[4..8].copy_from_slice(&c.ipv4.to_le_bytes());
        assert_eq!(c.uid, crate::audio_replay_address::uid(&socket));
        assert_eq!(
            c.address_text,
            if fill == 0 {
                b"127.0.0.1".as_slice()
            } else {
                b"127.0.0.1:42405"
            }
        );
        closed(&mut a);
    }
}
#[test]
fn audio_replay_windows_configuration_replaces_owned_callbacks_then_crc_failure_closes_once_and_rejects_released_reuse(
) {
    let mut a = Application::new().unwrap();
    let r = a.transport().unwrap();
    for (owner, member, port) in [
        (0x44000000, 0x728e20, 12345),
        (0x44000100, 0x728fd0, 0x1234ffff),
    ] {
        let mut input = request(Some(b"127.0.0.1"), port, 0);
        input.callback = Some(ConfigurationCallback { owner, member });
        assert_eq!(r.configure(input).unwrap(), 0);
        let c = r.configuration_snapshot().unwrap().unwrap();
        assert_eq!(
            c.callback,
            Some([
                crate::audio_announcer_owner_metadata::HANDLER_VTABLE,
                owner,
                member
            ])
        );
        assert_eq!(r.snapshot().unwrap().engine_allocations, 4);
        assert_eq!(r.snapshot().unwrap().references, 1);
    }
    assert_eq!(a.diagnostic().unwrap()["workers_created"], 1);
    assert_eq!(
        r.configure(request(Some(b"98.24.0.44"), 12345, 0)).unwrap(),
        3
    );
    let failed = r.configuration_snapshot().unwrap().unwrap();
    assert_eq!(failed.uid, 0);
    assert_eq!(failed.address_text, b"98.24.0.44");
    assert_eq!(failed.ipv4, 0x0100007f);
    assert_eq!(failed.requested_port, 65535);
    assert_eq!(failed.callback, None);
    assert_eq!(r.inspect_network(|n| n.outstanding()), (0, 0));
    assert!(r
        .configure(request(Some(b"127.0.0.1"), 12345, 0))
        .unwrap_err()
        .contains("status remains2"));
    assert_eq!(r.configuration_snapshot().unwrap(), Some(failed));
    assert_eq!(a.diagnostic().unwrap()["workers_created"], 1);
    closed(&mut a);
}
#[test]
fn audio_replay_windows_configuration_invalid_hosts_ports_and_uid_release_network_and_keep_native_return_codes(
) {
    for (host, port, expected) in [
        (None, 12345, 2),
        (Some([b'A'; 128].as_slice()), 12345, 2),
        (Some(b"example.invalid".as_slice()), 12345, 3),
        (Some(b"127.0.0.1".as_slice()), 1, 3),
        (Some(b"255.255.255.255".as_slice()), 12345, 3),
        (Some(b"98.24.0.44".as_slice()), 12345, 3),
    ] {
        let mut a = Application::new().unwrap();
        let r = a.transport().unwrap();
        assert_eq!(r.configure(request(host, port, 0)).unwrap(), expected);
        assert_eq!(
            r.configuration_snapshot().unwrap().unwrap().return_code,
            Some(expected)
        );
        assert_eq!(r.snapshot().unwrap().references, 0);
        assert_eq!(r.inspect_network(|n| n.outstanding()), (0, 0));
        assert!(r.errors().is_empty());
        closed(&mut a);
    }
}
#[test]
fn audio_replay_windows_configuration_application_drop_retires_live_or_failed_configuration_and_its_crt_owner(
) {
    for host in [b"127.0.0.1".as_slice(), b"98.24.0.44"] {
        let a = Application::new().unwrap();
        let root = a.root.clone();
        let report = a.report.clone();
        let lock_report = a.transport().unwrap().critical_section_report();
        a.transport()
            .unwrap()
            .configure(request(Some(host), 12345, 0))
            .unwrap();
        drop(a);
        root.context
            .with(|c| {
                assert_eq!(c.services.inner.heap.outstanding(), 0);
                assert!(c.services.locks.is_empty());
                assert_eq!(c.services.inner.heap.retained_mirrors(), 0);
            })
            .unwrap();
        assert!(lock_report.failures().is_empty());
        assert!(report.failures().is_empty());
        assert_eq!(report.threads.created(), 1);
        assert_eq!(report.threads.closed(), 1);
    }
}

include!("audio_replay_windows_stream_transport_tests.rs");
