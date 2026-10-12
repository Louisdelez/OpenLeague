use super::*;
fn directory() -> std::path::PathBuf {
    let nonce = std::time::SystemTime::now()
        .duration_since(std::time::UNIX_EPOCH)
        .unwrap()
        .as_nanos();
    let p = std::env::temp_dir().join(format!(
        "openleague-recording-{}-{nonce}",
        std::process::id()
    ));
    std::fs::create_dir(&p).unwrap();
    p
}
fn close(a: &mut Application) {
    a.close().unwrap();
    let d = a.diagnostic().unwrap();
    assert_eq!(d["closed"], true);
    assert_eq!(d["workers_created"], 0);
    for k in [
        "heap_blocks",
        "retained_mirrors",
        "critical_sections",
        "heap_failures",
        "lock_failures",
    ] {
        assert_eq!(d["crt"][k], 0);
    }
    assert_eq!(d["crt"]["heap_allocations"], d["crt"]["heap_frees"]);
    assert_eq!(d["worker_failures"], serde_json::json!([]));
}
#[test]
fn audio_replay_windows_recording_actual_crt_truncates_once_appends_literal_bytes_and_releases_every_file(
) {
    let folder = directory();
    let path = folder.join("source-diagnostic.log");
    std::fs::write(&path, b"old content must be truncated").unwrap();
    let mut a = Application::new().unwrap();
    let r = a.transport().unwrap();
    let p = r
        .probe_recording_file(
            path.to_str().unwrap().as_bytes(),
            &[
                b"literal %n %s 100%",
                b"raw \x80\xe9\xff\nnext line\0ignored",
            ],
        )
        .unwrap();
    assert_eq!((p.opened, p.opened_again, p.closed), (1, 1, 1));
    assert_eq!(
        (p.files_opened, p.files_closed, p.writes, p.remaining_files),
        (2, 2, 5, 0)
    );
    let content = std::fs::read(&path).unwrap();
    for needed in [
        b"LogOut_File: : logfile started\r\n".as_slice(),
        b"literal %n %s 100%\r\n",
        b"raw \x80\xe9\xff\r\nnext line\r\n",
        b"LogOut_File: : logfile stopped\r\n",
    ] {
        assert!(
            content.windows(needed.len()).any(|x| x == needed),
            "missing {needed:?}"
        );
    }
    for absent in [b"old content".as_slice(), b"ignored"] {
        assert!(!content.windows(absent.len()).any(|x| x == absent));
    }
    assert_eq!(r.snapshot().unwrap().engine_allocations, 0);
    assert_eq!(r.logger_snapshot().unwrap().pointer, 0);
    assert!(r.errors().is_empty());
    close(&mut a);
    std::fs::remove_file(path).unwrap();
    std::fs::remove_dir(folder).unwrap();
}
#[test]
fn audio_replay_windows_recording_missing_parent_returns_native_open_failure_and_retires_callbacks()
{
    let folder = directory();
    let path = folder.join("missing").join("diagnostic.log");
    let mut a = Application::new().unwrap();
    let p = a
        .transport()
        .unwrap()
        .probe_recording_file(
            path.to_str().unwrap().as_bytes(),
            &[b"must not create a parent folder"],
        )
        .unwrap();
    assert_eq!((p.opened, p.opened_again, p.closed), (0, 0, 1));
    assert_eq!(
        (p.files_opened, p.files_closed, p.writes, p.remaining_files),
        (0, 0, 0, 0)
    );
    assert!(!path.exists() && !folder.join("missing").exists());
    assert!(a.transport().unwrap().errors().is_empty());
    close(&mut a);
    std::fs::remove_dir(folder).unwrap();
}

#[test]
fn audio_replay_windows_recorded_stream_prepares_starts_stops_and_retires_actual_file_worker_registry_lifetimes(
) {
    for profile in 0..4 {
        let folder = directory();
        let path = if profile == 2 {
            folder.join("missing").join("recorded-stream.log")
        } else {
            folder.join("recorded-stream.log")
        };
        let mut a = Application::new().unwrap();
        let r = a.transport().unwrap();
        let input = match profile {
            0 => None,
            3 => Some(b"".as_slice()),
            _ => Some(path.to_str().unwrap().as_bytes()),
        };
        if profile == 1 {
            std::fs::write(&path, b"old bytes must disappear").unwrap();
        }
        let p = r
            .probe_recording_stream(
                input,
                &[
                    b"Stream diagnostic 100% %s %n",
                    b"Narrow \x80\xe9\xff\0ignored",
                ],
            )
            .unwrap_or_else(|e| panic!("profile {profile}: {e}; backend {:?}", r.errors()));
        assert_eq!(
            (
                p.open_code,
                p.start_code,
                p.state_after_start,
                p.state_after_stop
            ),
            (0, 0, 4, 3)
        );
        assert_eq!(p.resource_enabled, if profile == 1 { 1 } else { 0 });
        assert_eq!(p.resource_references, 1);
        assert_eq!(p.registry_initialized, profile != 0);
        assert_eq!(p.files_opened, if profile == 1 { 2 } else { 0 });
        assert_eq!(p.files_opened, p.files_closed);
        assert_eq!(p.remaining_files, 0);
        assert_eq!(r.snapshot().unwrap().active_workers, 0);
        assert!(r.stream_snapshot().unwrap().is_none());
        assert_eq!(r.logger_snapshot().unwrap().pointer, 0);
        assert!(r.errors().is_empty());
        assert_eq!(
            r.snapshot().unwrap().engine_allocations,
            usize::from(profile != 0)
        );
        a.close().unwrap();
        let d = a.diagnostic().unwrap();
        assert_eq!(d["workers_created"], 1);
        assert_eq!(d["workers_closed"], 1);
        assert_eq!(d["worker_failures"], serde_json::json!([]));
        for k in [
            "heap_blocks",
            "retained_mirrors",
            "critical_sections",
            "heap_failures",
            "lock_failures",
        ] {
            assert_eq!(d["crt"][k], 0);
        }
        assert_eq!(d["crt"]["heap_allocations"], d["crt"]["heap_frees"]);
        if profile == 1 {
            let bytes = std::fs::read(&path).unwrap();
            for needed in [
                b"LogOut_File: : logfile started\r\n".as_slice(),
                b"Stream diagnostic 100% %s %n\r\n",
                b"Narrow \x80\xe9\xff\r\n",
                b"LogOut_File: : logfile stopped\r\n",
            ] {
                assert!(bytes.windows(needed.len()).any(|x| x == needed));
            }
            for absent in [b"old bytes".as_slice(), b"ignored"] {
                assert!(!bytes.windows(absent.len()).any(|x| x == absent));
            }
            assert!(bytes.ends_with(b"LogOut_File: : logfile stopped\r\n"));
            assert!(p.writes >= 4);
            std::fs::remove_file(&path).unwrap();
        } else {
            assert!(!path.exists());
            assert_eq!(p.writes, 0);
        }
        std::fs::remove_dir(folder).unwrap();
    }
}
