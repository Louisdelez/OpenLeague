use super::*;
use std::io::Cursor;

#[test]
fn fragmented_untrusted_lines_emit_only_fixed_codes_and_recover_after_oversize() {
    let counts=Counts::default();let mut framer=Framer::default();let mut found=Vec::new();
    let input=b"\x1b[31mWARN No audio device found. access_key=SECRET-CANARY\x1b[0m\r\nrecovery_key=OTHER-SECRET\n";
    for bytes in input.chunks(3) {framer.feed(bytes,&counts,|code|found.push(code));}
    let mut too_long=vec![b'x';MAX_LINE+17];too_long.extend_from_slice(b"No audio device found.\n");
    framer.feed(&too_long,&counts,|code|found.push(code));
    framer.feed(b"Optional Ezreal R OnCast audio unavailable: private-path-and-key",&counts,|code|found.push(code));
    framer.eof(&counts,|code|found.push(code));
    assert_eq!(found,["audio_output_unavailable","r_cast_asset_unavailable"]);
    assert_eq!(counts.lines.load(Ordering::Relaxed),4);assert_eq!(counts.unknown.load(Ordering::Relaxed),1);
    assert_eq!(counts.oversized.load(Ordering::Relaxed),1);assert!(framer.line.is_empty());
    assert!(!serde_json::to_string(&found).unwrap().contains("SECRET"));
}

#[test]
fn full_or_disconnected_record_queue_still_drains_entire_source() {
    let shared=Shared::new();let (sender,receiver)=mpsc::sync_channel(1);
    let data=b"No audio device found.\n".repeat(10000);let mut source=Cursor::new(&data);
    let mut framer=Framer::default();let mut bytes=[0;CHUNK];
    loop {let n=source.read(&mut bytes).unwrap();if n==0 {break;}
        framer.feed(&bytes[..n],&shared.counts[0],|c|send_record(&sender,&shared,Stream::Out,c));}
    assert_eq!(source.position(),data.len() as u64);assert_eq!(shared.counts[0].queue_dropped.load(Ordering::Relaxed),9999);
    assert_eq!(receiver.try_recv().unwrap().code,"audio_output_unavailable");drop(receiver);
    framer.feed(b"No audio device found.\n",&shared.counts[0],|c|send_record(&sender,&shared,Stream::Out,c));
    assert_eq!(shared.counts[0].queue_dropped.load(Ordering::Relaxed),10000);
}

#[test]
fn hard_file_quota_reserves_summary_and_partial_disk_failure_never_retries() {
    let mut file=Capped::new(Vec::new());
    for _ in 0..10000 {file.write(&serde_json::json!({"elapsed_ms":u64::MAX,"code":"audio_output_unavailable"}),false);}
    assert!(file.quota);assert!(file.writer.len()<=MAX_FILE_BYTES-FOOTER_RESERVE);
    file.write(&serde_json::json!({"code":"stream_finished","counts":Counts::default().value()}),true);
    assert!(file.writer.len()<=MAX_FILE_BYTES);assert!(String::from_utf8(file.writer).unwrap().contains("stream_finished"));
    struct Fails {bytes:Vec<u8>,calls:usize}
    impl Write for Fails {
        fn write(&mut self,b:&[u8])->io::Result<usize> {self.calls+=1;if self.calls==1 {let n=b.len().min(3);self.bytes.extend_from_slice(&b[..n]);Ok(n)}else{Err(io::Error::other("fixture disk failure"))}}
        fn flush(&mut self)->io::Result<()> {Ok(())}
    }
    let mut file=Capped::new(Fails{bytes:vec![],calls:0});file.write(&serde_json::json!({"code":"audio_output_unavailable"}),false);
    assert!(file.failed);assert_eq!(file.writer.calls,2);let bytes=file.writer.bytes.clone();
    file.write(&serde_json::json!({"code":"stream_finished"}),true);assert_eq!(file.writer.calls,2);assert_eq!(file.writer.bytes,bytes);
}

struct Temp(PathBuf);
impl Temp {
    fn new()->Self {
        static NEXT:AtomicU64=AtomicU64::new(1);
        let dir=std::env::temp_dir().join(format!("openleague-child-log-test-{}-{}-{}",std::process::id(),
            std::time::SystemTime::now().duration_since(std::time::UNIX_EPOCH).unwrap().as_nanos(),NEXT.fetch_add(1,Ordering::Relaxed)));
        fs::create_dir(&dir).unwrap();Self(dir)
    }
}
impl Drop for Temp {
    fn drop(&mut self) {
        // Only this test's create-new leaf below the real temp directory.
        let base=std::env::temp_dir().canonicalize().unwrap();
        if let Ok(actual)=self.0.canonicalize() {if actual.parent()==Some(base.as_path()) && actual.file_name().unwrap().to_string_lossy().starts_with("openleague-child-log-test-") {let _=fs::remove_dir_all(actual);}}
    }
}

#[test]
fn existing_files_and_exhausted_slots_are_never_overwritten_or_recycled() {
    let temp=Temp::new();let first=reserve(&temp.0).unwrap();assert_eq!(first.slot,0);
    assert!(OpenOptions::new().write(true).create_new(true).open(temp.0.join("runtime/diagnostics/child-output/slot-00/stdout.jsonl")).is_err());
    drop(first);
    let base=temp.0.join("runtime/diagnostics/child-output");
    for i in 1..MAX_SLOTS {fs::create_dir(base.join(format!("slot-{i:02}"))).unwrap();}
    let marker=base.join("slot-00/stdout.jsonl");fs::write(&marker,b"fixture retained evidence").unwrap();
    assert!(reserve(&temp.0).is_err());assert_eq!(fs::read(marker).unwrap(),b"fixture retained evidence");
    let blocked=Temp::new();fs::write(blocked.0.join("runtime"),b"not a directory").unwrap();
    assert!(reserve(&blocked.0).is_err());assert_eq!(fs::read(blocked.0.join("runtime")).unwrap(),b"not a directory");
}

#[cfg(windows)]
#[test]
fn pinned_directory_cannot_be_renamed_during_capture() {
    let temp=Temp::new();let files=reserve(&temp.0).unwrap();
    let before=temp.0.join("runtime/diagnostics/child-output/slot-00");
    let after=temp.0.join("runtime/diagnostics/child-output/moved");
    assert!(fs::rename(&before,&after).is_err());assert!(before.is_dir());assert!(!after.exists());
    drop(files);fs::rename(&before,&after).unwrap();
}

// This fixture is invoked only as an owned child by the test below. Its fake
// secret strings are deliberately emitted to verify they never reach the files.
#[test]
#[ignore]
fn diagnostic_child_fixture() {
    assert_eq!(std::env::var("OPENLEAGUE_DIAGNOSTIC_TEST_CHILD").as_deref(),Ok("1"));
    let mut private=[0;2];std::io::stdin().read_exact(&mut private).unwrap();assert_eq!(&private,b"ok");
    let mut out=std::io::stdout().lock();let mut err=std::io::stderr().lock();
    for _ in 0..4096 {out.write_all(b"untrusted recovery_key=SECRET-CANARY and no known event\n").unwrap();err.write_all(b"untrusted access_key=PRIVATE-CANARY\n").unwrap();}
    out.write_all(b"No audio device found.\n").unwrap();out.flush().unwrap();
    err.write_all(b"Optional Ezreal R OnCast audio unavailable: SECRET-CANARY\n").unwrap();err.flush().unwrap();
}

#[cfg(windows)]
#[test]
fn ordinary_child_flood_keeps_private_stdin_exit_and_new_attempt_logs_distinct() {
    let temp=Temp::new();let mut previous=None;
    for _ in 0..2 {
        let mut command=Command::new(std::env::current_exe().unwrap());
        command.args(["--exact","sessions::output::tests::diagnostic_child_fixture","--ignored","--nocapture"])
            .env("OPENLEAGUE_DIAGNOSTIC_TEST_CHILD","1").stdin(Stdio::piped());
        let mut child=LoggedChild::spawn(&mut command,&temp.0,Role::Client,u64::MAX-5).unwrap();
        let slot=child.diagnostics()["slot"].as_u64().unwrap();assert_ne!(previous,Some(slot));previous=Some(slot);
        let mut pipe=child.stdin.take().unwrap();pipe.write_all(b"ok").unwrap();drop(pipe);
        let deadline=Instant::now()+Duration::from_secs(15);
        loop {if let Some(exit)=child.observe().unwrap() {assert!(exit.success());break;}
            assert!(Instant::now()<deadline,"owned fixture failed to exit; no PID kill is attempted");thread::sleep(Duration::from_millis(5));}
        let shared=child.capture.as_ref().unwrap().shared.clone();
        while !shared.writer_ended.load(Ordering::Acquire) {assert!(Instant::now()<deadline);thread::sleep(Duration::from_millis(5));}
        drop(child);reap_finished();
        let dir=temp.0.join(format!("runtime/diagnostics/child-output/slot-{slot:02}"));
        let out=fs::read(dir.join("stdout.jsonl")).unwrap();let err=fs::read(dir.join("stderr.jsonl")).unwrap();
        for bytes in [&out,&err] {assert!(bytes.len()<=MAX_FILE_BYTES);let text=std::str::from_utf8(bytes).unwrap();assert!(!text.contains("SECRET-CANARY"));assert!(!text.contains("PRIVATE-CANARY"));assert!(!text.contains("recovery_key"));assert!(!text.contains("access_key"));}
        assert!(std::str::from_utf8(&out).unwrap().contains("audio_output_unavailable"));
        assert!(std::str::from_utf8(&err).unwrap().contains("r_cast_asset_unavailable"));
        assert!(shared.counts[0].bytes.load(Ordering::Relaxed)>65536);assert!(shared.counts[1].bytes.load(Ordering::Relaxed)>65536);
    }
}

#[test]
fn oncast_tokens_are_fixed_fragment_safe_and_never_persist_private_suffixes() {
    let pairs=&[
        ("[OL_R_CAST_DIAG:v1:context_rejected]","r_cast_diag_context_rejected"),
        ("[OL_R_CAST_DIAG:v1:delivery_revoked]","r_cast_diag_delivery_revoked"),
        ("[OL_R_CAST_DIAG:v1:clock_rejected]","r_cast_diag_clock_rejected"),
        ("[OL_R_CAST_DIAG:v1:projection_rejected]","r_cast_diag_projection_rejected"),
        ("[OL_R_CAST_DIAG:v1:event_admitted]","r_cast_diag_event_admitted"),
        ("[OL_R_CAST_DIAG:v1:event_baseline]","r_cast_diag_event_baseline"),
        ("[OL_R_CAST_DIAG:v1:event_previously_hidden]","r_cast_diag_event_previously_hidden"),
        ("[OL_R_CAST_DIAG:v1:event_not_ready]","r_cast_diag_event_not_ready"),
        ("[OL_R_CAST_DIAG:v1:event_paused]","r_cast_diag_event_paused"),
        ("[OL_R_CAST_DIAG:v1:event_finished]","r_cast_diag_event_finished"),
        ("[OL_R_CAST_DIAG:v1:event_stale]","r_cast_diag_event_stale"),
        ("[OL_R_CAST_DIAG:v1:event_backdated]","r_cast_diag_event_backdated"),
        ("[OL_R_CAST_DIAG:v1:event_capacity]","r_cast_diag_event_capacity"),
        ("[OL_R_CAST_DIAG:v1:pending_revoked]","r_cast_diag_pending_revoked"),
        ("[OL_R_CAST_DIAG:v1:pending_expired]","r_cast_diag_pending_expired"),
        ("[OL_R_CAST_DIAG:v1:request_not_ready]","r_cast_diag_request_not_ready"),
        ("[OL_R_CAST_DIAG:v1:request_paused]","r_cast_diag_request_paused"),
        ("[OL_R_CAST_DIAG:v1:request_channel]","r_cast_diag_request_channel"),
        ("[OL_R_CAST_DIAG:v1:request_snapshot]","r_cast_diag_request_snapshot"),
        ("[OL_R_CAST_DIAG:v1:request_capacity]","r_cast_diag_request_capacity"),
        ("[OL_R_CAST_DIAG:v1:request_owner_hidden]","r_cast_diag_request_owner_hidden"),
        ("[OL_R_CAST_DIAG:v1:request_owner_missing]","r_cast_diag_request_owner_missing"),
        ("[OL_R_CAST_DIAG:v1:request_asset_missing]","r_cast_diag_request_asset_missing"),
        ("[OL_R_CAST_DIAG:v1:gain_zero]","r_cast_diag_gain_zero"),
        ("[OL_R_CAST_DIAG:v1:gain_invalid]","r_cast_diag_gain_invalid"),
        ("[OL_R_CAST_DIAG:v1:spawn_queued]","r_cast_diag_spawn_queued"),
        ("[OL_R_CAST_DIAG:v1:first_sink_within_100ms]","r_cast_diag_first_sink_within_100ms"),
        ("[OL_R_CAST_DIAG:v1:first_sink_after_100ms]","r_cast_diag_first_sink_after_100ms"),
        ("[OL_R_CAST_DIAG:v1:first_sink_clock_invalid]","r_cast_diag_first_sink_clock_invalid"),
        ("[OL_R_CAST_DIAG:v1:retire_not_ready]","r_cast_diag_retire_not_ready"),
        ("[OL_R_CAST_DIAG:v1:retire_paused]","r_cast_diag_retire_paused"),
        ("[OL_R_CAST_DIAG:v1:retire_channel]","r_cast_diag_retire_channel"),
        ("[OL_R_CAST_DIAG:v1:retire_snapshot]","r_cast_diag_retire_snapshot"),
        ("[OL_R_CAST_DIAG:v1:retire_context]","r_cast_diag_retire_context"),
        ("[OL_R_CAST_DIAG:v1:retire_authorization]","r_cast_diag_retire_authorization"),
        ("[OL_R_CAST_DIAG:v1:retire_owner_hidden]","r_cast_diag_retire_owner_hidden"),
        ("[OL_R_CAST_DIAG:v1:retire_owner_changed]","r_cast_diag_retire_owner_changed"),
        ("[OL_R_CAST_DIAG:v1:retire_gain_zero]","r_cast_diag_retire_gain_zero"),
        ("[OL_R_CAST_DIAG:v1:retire_gain_invalid]","r_cast_diag_retire_gain_invalid"),
        ("[OL_R_CAST_DIAG:v1:retire_clock_or_duration]","r_cast_diag_retire_clock_or_duration"),
        ("[OL_R_CAST_DIAG:v1:retire_hard_limit]","r_cast_diag_retire_hard_limit"),
        ("[OL_R_CAST_DIAG:v1:retire_sink_lost]","r_cast_diag_retire_sink_lost"),
        ("[OL_R_CAST_DIAG:v1:retire_sink_empty]","r_cast_diag_retire_sink_empty"),
        ("[OL_R_CAST_DIAG:v1:retire_initial_sink_timeout]","r_cast_diag_retire_initial_sink_timeout"),
        ("[OL_R_CAST_DIAG:v1:retire_first_sink_late]","r_cast_diag_retire_first_sink_late"),
        ("[OL_R_CAST_DIAG:v1:retire_active_watchdog]","r_cast_diag_retire_active_watchdog"),
        ("[OL_R_CAST_DIAG:v1:budget_exhausted]","r_cast_diag_budget_exhausted"),
    ];
    let counts=Counts::default();let mut framer=Framer::default();let mut found=Vec::new();
    for &(token,expected) in pairs {
        assert_eq!(code(token.as_bytes()),Some(expected));
        let input=format!("INFO {token} access_key=SECRET-CANARY position=1,2 owner=999 path=C:/private\n");
        for chunk in input.as_bytes().chunks(2) {framer.feed(chunk,&counts,|c|found.push(c));}
    }
    for input in [b"[OL_R_CAST_DIAG:v1:unknown] SECRET\n".as_slice(),
        b"[OL_R_CAST_DIAG:v2:event_admitted] SECRET\n",b"[OL_R_CAST_DIAG:v1:event_admitted_fake] SECRET\n"] {
        framer.feed(input,&counts,|c|found.push(c));
    }
    framer.eof(&counts,|c|found.push(c));
    assert_eq!(found,pairs.iter().map(|(_,code)|*code).collect::<Vec<_>>());
    assert_eq!(counts.unknown.load(Ordering::Relaxed),3);
    let saved=serde_json::to_string(&found).unwrap();
    for private in ["SECRET","position=","owner=","999","path=","C:/","access_key"] {assert!(!saved.contains(private),"{private}");}
}
