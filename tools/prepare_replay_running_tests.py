from pathlib import Path
r=Path('E:/OpenLeague');s=Path('E:/mapslol3v3')
t=(r/'crates/core/src/audio_replay_stream_tests.rs').read_text()
t+='\n#[path="audio_replay_stream_running_tests.rs"]\nmod running_tests;\n'
(s/'audio_replay_stream_tests.rs').write_text(t)
t=(r/'crates/core/src/audio_replay_windows_opening_tests.rs').read_text()
t+='''
#[test]
fn audio_replay_windows_running_starts_restarts_and_joins_actual_source_stream_workers() {
    for mode in [1,257] {
        let mut a=Application::new().unwrap();
        let r=a.transport().unwrap();r.open_stream(input(mode,None,false)).unwrap();
        for _ in 0..2 {
            assert_eq!(r.start_stream([1,2,3,4,5,6]).unwrap(),0);
            assert_eq!(r.start_stream([1,2,3,4,5,6]).unwrap(),8);
            std::thread::sleep(std::time::Duration::from_millis(30));
            assert_eq!(r.snapshot().unwrap().active_workers,1);
            r.stop_stream().unwrap();r.stop_stream().unwrap();
            assert_eq!(r.snapshot().unwrap().active_workers,0);
            assert_eq!(r.stream_snapshot().unwrap().unwrap().state_id,3);
        }
        r.close_stream().unwrap();assert!(r.stream_snapshot().unwrap().is_none());
        assert!(r.errors().is_empty());fully_closed(&mut a,2);
    }
}
#[test]
fn audio_replay_windows_running_application_close_stops_a_live_stream_before_freeing_its_bank() {
    for direct_drop in [false,true] {
        let mut a=Application::new().unwrap();
        let root=a.root.clone();let report=a.report.clone();
        let r=a.transport().unwrap();let locks=r.critical_section_report();
        r.open_stream(input(1,None,false)).unwrap();
        assert_eq!(r.start_stream([0;6]).unwrap(),0);
        std::thread::sleep(std::time::Duration::from_millis(30));
        assert_eq!(r.snapshot().unwrap().active_workers,1);
        if !direct_drop { fully_closed(&mut a,1); }
        drop(a);
        root.context.with(|c| {
            assert_eq!(c.services.inner.heap.outstanding(),0);
            assert_eq!(c.services.inner.heap.retained_mirrors(),0);
            assert!(c.services.locks.is_empty());
        }).unwrap();
        assert!(locks.failures().is_empty());assert!(report.failures().is_empty());
        assert_eq!(report.threads.created(),1);assert_eq!(report.threads.closed(),1);
    }
}
#[test]
fn audio_replay_windows_running_unsupported_host_does_not_start_an_orphan_worker_or_change_state() {
    let mut a=Application::new().unwrap();let r=a.transport().unwrap();
    r.open_stream(input(0,Some(b"127.0.0.1"),false)).unwrap();let before=r.stream_snapshot().unwrap();
    assert!(r.start_stream([0;6]).unwrap_err().contains("host creation/connection"));
    assert_eq!(r.stream_snapshot().unwrap(),before);assert_eq!(r.snapshot().unwrap().active_workers,0);
    fully_closed(&mut a,1);
}
'''
(s/'audio_replay_windows_opening_tests.rs').write_text(t)
# Standalone host for the new source contracts. Existing dependency modules remain
# the production versions; only edited modules/tests are redirected to staging.
t=(s/'replay-opening-tests.rs').read_text()
import re
t=re.sub(r'E:/mapslol3v3/([\w]+\.rs)',r'E:/OpenLeague/crates/core/src/\1',t)
t=t.replace('fn audio_test_fixture(relative:&str)->String', 'fn old_audio_test_fixture(relative:&str)->String',1)
t+='\nfn audio_test_fixture(relative:&str)->String {std::fs::read_to_string(if relative.ends_with("replay_stream_running_contract.json"){std::path::Path::new("E:/mapslol3v3").join("replay_stream_running_contract.json")}else{std::path::Path::new("E:/OpenLeague").join(relative)}).unwrap()}\n'
for name in ['audio_replay_transport_thread','audio_replay_object_manager']:
 t=t.replace('E:/OpenLeague/crates/core/src/'+name+'.rs','E:/mapslol3v3/'+name+'.rs')
t+='\n#[path="E:/mapslol3v3/audio_replay_stream_running.rs"] mod audio_replay_stream_running;\n'
(s/'replay-running-tests.rs').write_text(t)
for name in ['audio_replay_object_manager.rs','audio_replay_object_manager_tests.rs']:
 t=(r/'crates/core/src'/name).read_text()
 t=re.sub(r'#\[path\s*=\s*"([^"/]+)"\]',lambda m:'#[path="E:/mapslol3v3/'+m[1]+'"]' if m[1] in ['audio_replay_object_manager_tests.rs','audio_replay_stream_tests.rs'] else '#[path="E:/OpenLeague/crates/core/src/'+m[1]+'"]',t)
 (s/name).write_text(t)
# The thread tests do not need redirection; keep their native-fixture harness.
p=s/'audio_replay_transport_thread.rs';t=p.read_text().replace('"audio_replay_transport_thread_tests_native.rs"','"E:/OpenLeague/crates/core/src/audio_replay_transport_thread_tests_native.rs"');p.write_text(t)
print('Prepared source contract and real Windows worker lifetime tests')
