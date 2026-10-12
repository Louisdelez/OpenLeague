use super::*;
use crate::audio_replay_windows_application::Application;
struct Defaults;
impl crate::audio_game_service_lifecycle::Settings for Defaults {
    fn float_bits(&mut self, _: &str, _: &str, v: u32) -> Result<u32, &'static str> {
        Ok(v)
    }
    fn bool_value(&mut self, _: &str, _: &str, v: u8) -> Result<u8, &'static str> {
        Ok(v)
    }
    fn integer(&mut self, _: &str, _: &str, v: u32) -> Result<u32, &'static str> {
        Ok(v)
    }
}
#[test]
fn audio_replay_windows_game_manager_owns_source_service_callbacks_metadata_and_closes_in_application_order(
) {
    for close_parent_first in [false, true] {
        let mut a = Application::new().unwrap();
        let runtime = a.transport().unwrap();
        let service = runtime.configure_service(Defaults).unwrap();
        let d = service.diagnostic().unwrap();
        assert_eq!(d["canonical_runtime_bank"], true);
        assert_eq!(d["live_allocations"], 11);
        assert_eq!(d["float_bits"]["FastForwardSpeed"], 0x42c80000u32);
        assert_eq!(d["DisableCatchup"], 1);
        assert_eq!(d["UseLookAhead"], 1);
        assert_eq!(d["PingTimeForReconnectMessage"], 5000);
        runtime.initialize_game_manager().unwrap();
        let s = runtime.game_manager_snapshot().unwrap().unwrap();
        assert_eq!(s.state, 1);
        assert_eq!(s.metadata_references, 1);
        assert_eq!(
            s.service_callbacks,
            [
                [
                    0x109b2d4,
                    d["pointer"].as_u64().unwrap() as u32,
                    0x738a3a,
                    0
                ],
                [
                    0x10afcfc,
                    d["pointer"].as_u64().unwrap() as u32,
                    0x72b950,
                    0
                ]
            ]
        );
        assert!(runtime.initialize_game_manager().is_err());
        assert_eq!(
            runtime.game_manager_snapshot().unwrap().unwrap().metadata,
            s.metadata
        );
        if close_parent_first {
            service.close().unwrap();
            assert!(runtime.game_manager_snapshot().unwrap().is_none());
            assert_eq!(runtime.snapshot().unwrap().engine_allocations, 0);
        }
        a.close().unwrap();
        assert_eq!(service.live_allocations(), 0);
        service.close().unwrap();
        let d = a.diagnostic().unwrap();
        assert_eq!(d["workers_created"], 0);
        assert_eq!(d["worker_failures"], serde_json::json!([]));
    }
}
#[test]
fn audio_replay_windows_service_open_preserves_source_null_host_error_and_rejects_unconnected_active_host_before_mutation(
) {
    for recording in [false, true] {
        let mut a = Application::new().unwrap();
        let runtime = a.transport().unwrap();
        let service = runtime.configure_service(Defaults).unwrap();
        let before = runtime.snapshot().unwrap().engine_allocations;
        let request = |host| GameReplayRequest {
            arguments: [17, 23],
            key: [0x42; 16],
            host,
            start: [1, 2, 3, 0, 0, 0],
            flag: 1,
            recording_path: None,
            recording,
        };
        let mut bad = request(None);
        bad.recording_path = Some(b"bad\0path");
        assert!(runtime.open_game_replay(bad).unwrap_err().contains("NUL"));
        assert!(runtime
            .probe_game_manager(Some(b"bad\0path"), &[])
            .unwrap_err()
            .contains("NUL"));
        assert!(runtime.game_manager_snapshot().unwrap().is_none());
        assert_eq!(runtime.snapshot().unwrap().engine_allocations, before);
        assert!(runtime
            .open_game_replay(request(Some(b"127.0.0.1")))
            .unwrap_err()
            .contains("not connected"));
        assert!(runtime.game_manager_snapshot().unwrap().is_none());
        assert_eq!(runtime.snapshot().unwrap().engine_allocations, before);
        assert_eq!(runtime.open_game_replay(request(None)).unwrap(), 2);
        let s = runtime.game_manager_snapshot().unwrap().unwrap();
        assert_eq!(s.state, 1);
        assert_eq!(s.code, Some(2));
        assert!(runtime.open_game_replay(request(None)).is_err());
        service.close().unwrap();
        assert_eq!(runtime.snapshot().unwrap().engine_allocations, 0);
        a.close().unwrap();
    }
}
struct FailsAt {
    call: usize,
    fail: usize,
}
impl FailsAt {
    fn next(&mut self) -> Result<(), &'static str> {
        self.call += 1;
        if self.call == self.fail {
            Err("supplied configuration failure")
        } else {
            Ok(())
        }
    }
}
impl crate::audio_game_service_lifecycle::Settings for FailsAt {
    fn float_bits(&mut self, _: &str, _: &str, v: u32) -> Result<u32, &'static str> {
        self.next()?;
        Ok(v)
    }
    fn bool_value(&mut self, _: &str, _: &str, v: u8) -> Result<u8, &'static str> {
        self.next()?;
        Ok(v)
    }
    fn integer(&mut self, _: &str, _: &str, v: u32) -> Result<u32, &'static str> {
        self.next()?;
        Ok(v)
    }
}
#[test]
fn audio_replay_windows_service_failed_settings_retire_private_partial_construction_and_allow_a_clean_retry(
) {
    for fail in 1..=10 {
        let mut a = Application::new().unwrap();
        let r = a.transport().unwrap();
        let scratch = r.shared.bank.lock().unwrap().next_scratch;
        assert!(r.configure_service(FailsAt { call: 0, fail }).is_err());
        assert_eq!(r.snapshot().unwrap().engine_allocations, 0);
        assert!(r
            .shared
            .bank
            .lock()
            .unwrap()
            .memory
            .read_byte(scratch)
            .is_err());
        let service = r.configure_service(Defaults).unwrap();
        assert_eq!(service.live_allocations(), 11);
        service.close().unwrap();
        assert_eq!(r.snapshot().unwrap().engine_allocations, 0);
        a.close().unwrap();
    }
}
#[test]
fn audio_replay_windows_game_manager4_recording_profiles_join_real_workers_and_retire_file_callbacks(
) {
    let root = std::env::temp_dir().join(format!(
        "openleague-parent-{}-{}",
        std::process::id(),
        std::time::SystemTime::now()
            .duration_since(std::time::UNIX_EPOCH)
            .unwrap()
            .as_nanos()
    ));
    std::fs::create_dir(&root).unwrap();
    let valid = root.join("parent.log");
    let missing = root.join("absent").join("parent.log");
    for (i, path) in [
        None,
        Some(valid.to_str().unwrap()),
        Some(missing.to_str().unwrap()),
        Some(""),
    ]
    .into_iter()
    .enumerate()
    {
        let mut a = Application::new().unwrap();
        let runtime = a.transport().unwrap();
        let service = runtime.configure_service(Defaults).unwrap();
        let report = runtime
            .probe_game_manager(
                path.map(str::as_bytes),
                &[b"parent canonical alpha", b"parent canonical beta"],
            )
            .unwrap();
        assert_eq!(report["started"]["state"], 4);
        assert_eq!(report["stopped"]["state"], 3);
        assert_eq!(report["started"]["metadata_references"], 1);
        assert_eq!(
            report["started"]["service_callbacks"][0][1],
            report["service_pointer"]
        );
        assert_eq!(report["resource_enabled"], if i == 1 { 1 } else { 0 });
        assert_eq!(report["files"]["opened"], if i == 1 { 2 } else { 0 });
        assert_eq!(report["files"]["opened"], report["files"]["closed"]);
        assert_eq!(report["files"]["remaining"], 0);
        assert!(runtime.game_manager_snapshot().unwrap().is_none());
        assert_eq!(runtime.logger_snapshot().unwrap().pointer, 0);
        assert!(runtime.errors().is_empty());
        service.close().unwrap();
        a.close().unwrap();
        let d = a.diagnostic().unwrap();
        assert_eq!(d["workers_created"], 1);
        assert_eq!(d["workers_closed"], 1);
        assert_eq!(d["worker_completions"], 1);
        assert_eq!(d["worker_failures"], serde_json::json!([]));
    }
    let data = std::fs::read_to_string(&valid).unwrap();
    assert!(data.contains("parent canonical alpha") && data.contains("parent canonical beta"));
    assert_eq!(data.lines().count(), 4);
    std::fs::remove_file(valid).unwrap();
    std::fs::remove_dir(root).unwrap();
}
