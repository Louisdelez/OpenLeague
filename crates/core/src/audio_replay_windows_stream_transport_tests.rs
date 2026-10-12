use crate::audio_replay_windows_transport::StreamConfigurationRequest;
fn stream_request(host: Option<&[u8]>, callback: bool) -> StreamConfigurationRequest<'_> {
    let mut transport = request(host, 0x1234ffff, 165);
    if callback {
        transport.callback = Some(ConfigurationCallback {
            owner: 0x44000000,
            member: 0x728e20,
        });
    }
    StreamConfigurationRequest {
        transport,
        key: std::array::from_fn(|i| i as u8),
        flag: 0x1ff,
        extra: 0x88776655,
    }
}
#[test]
fn audio_replay_windows_stream_transport_owns_derived_key_callback_and_rejects_repeated_or_mixed_configuration(
) {
    for callback in [false, true] {
        let mut a = Application::new().unwrap();
        let r = a.transport().unwrap();
        assert_eq!(
            r.configure_stream_transport(stream_request(Some(b"127.0.0.1"), callback))
                .unwrap(),
            0
        );
        let c = r.configuration_snapshot().unwrap().unwrap();
        let stream = c.stream.as_ref().unwrap();
        assert_eq!(stream.interface_pointer, c.pointer + 0xe0);
        assert_ne!(stream.key_pointer, 0);
        assert_eq!(stream.flag, 255);
        assert_eq!(stream.extra, 0x88776655);
        assert_eq!(c.uid, 0xff2199f5);
        assert_eq!(c.arguments, [0x11223344, 0x55667788]);
        assert_eq!(c.requested_port, 65535);
        assert_eq!(c.address_text, b"127.0.0.1");
        assert_eq!(
            c.callback,
            if callback {
                Some([
                    crate::audio_announcer_owner_metadata::HANDLER_VTABLE,
                    0x44000000,
                    0x728e20,
                ])
            } else {
                None
            }
        );
        assert_eq!(
            r.snapshot().unwrap().engine_allocations,
            if callback { 5 } else { 4 }
        );
        assert_eq!(r.inspect_network(|n| n.outstanding()), (1, 1));
        assert!(r
            .configure_stream_transport(stream_request(Some(b"127.0.0.1"), !callback))
            .unwrap_err()
            .contains("already attempted"));
        assert!(r
            .configure(request(Some(b"127.0.0.1"), 12345, 0))
            .unwrap_err()
            .contains("kind cannot change"));
        assert_eq!(r.configuration_snapshot().unwrap(), Some(c));
        assert_eq!(a.diagnostic().unwrap()["workers_created"], 1);
        r.close_configuration().unwrap();
        assert_eq!(r.snapshot().unwrap().engine_allocations, 1);
        assert_eq!(r.inspect_network(|n| n.outstanding()), (0, 0));
        assert!(r.errors().is_empty());
        closed(&mut a);
    }
}
#[test]
fn audio_replay_windows_stream_transport_virtual_error_close_clears_key_and_application_drop_releases_all_owners(
) {
    for (host, expected) in [
        (None, 2),
        (Some(b"98.24.0.44".as_slice()), 3),
        (Some(b"example.invalid".as_slice()), 3),
    ] {
        let mut a = Application::new().unwrap();
        let r = a.transport().unwrap();
        assert_eq!(
            r.configure_stream_transport(stream_request(host, true))
                .unwrap(),
            expected
        );
        let c = r.configuration_snapshot().unwrap().unwrap();
        assert_eq!(c.return_code, Some(expected));
        assert_eq!(c.stream.unwrap().key_pointer, 0);
        assert_eq!(r.snapshot().unwrap().references, 0);
        assert_eq!(r.inspect_network(|n| n.outstanding()), (0, 0));
        assert!(r.errors().is_empty());
        closed(&mut a);
    }
    for host in [b"127.0.0.1".as_slice(), b"98.24.0.44"] {
        let a = Application::new().unwrap();
        let root = a.root.clone();
        let report = a.report.clone();
        let locks = a.transport().unwrap().critical_section_report();
        a.transport()
            .unwrap()
            .configure_stream_transport(stream_request(Some(host), true))
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
        assert_eq!(report.threads.created(), 1);
        assert_eq!(report.threads.closed(), 1);
    }
}
