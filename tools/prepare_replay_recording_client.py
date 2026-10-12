from pathlib import Path
r=Path('E:/OpenLeague');s=Path('E:/mapslol3v3')
t=(r/'crates/client/src/main.rs').read_text(encoding='utf-8')
anchor='    if let Some(index)=arguments.iter().position(|a|a=="--native-replay-stream-running-probe") {';assert t.count(anchor)==1
t=t.replace(anchor,'''    if let Some(index)=arguments.iter().position(|a|a=="--native-replay-recording-file-probe") {
        #[cfg(windows)] {
            let probe_root=arguments.get(index+1).map(std::path::PathBuf::from).unwrap_or_else(||root.clone());
            native_replay_recording_file_probe(&probe_root);return;
        }
        #[cfg(not(windows))] panic!("Native diagnostic file requires Windows");
    }
'''+anchor)
t+='''
#[cfg(windows)]
fn native_replay_recording_file_probe(root:&std::path::Path) {
    use openleague_core::audio_replay_windows_application::Application;
    let mut profiles=Vec::new();let nonce=std::time::SystemTime::now().duration_since(std::time::UNIX_EPOCH).unwrap().as_nanos();
    for success in [true,false] {
        let loaded=native_user_settings::load(root).unwrap();let replay=native_replay_service::Service::new(loaded.replay).unwrap();
        let mut app=App::new();app.insert_resource(NativeReplayService(replay));attach_native_replay_runtime(&mut app).unwrap();
        let path=if success{root.join("logs").join(format!("native-diagnostic-file-{nonce}.log"))}else{root.join("logs").join(format!("missing-native-directory-{nonce}")).join("diagnostic.log")};
        let report=app.world().non_send_resource::<Application>().transport().unwrap().probe_recording_file(path.to_str().unwrap().as_bytes(),&[b"OpenLeague source file boundary %s %n",b"Repeated open must preserve this line"]).unwrap();
        assert_eq!(report.opened,success as u8);assert_eq!(report.opened_again,success as u8);assert_eq!(report.closed,1);assert_eq!(report.remaining_files,0);assert_eq!(report.files_opened,report.files_closed);
        let content=if success{let data=std::fs::read(&path).unwrap();assert!(data.windows(32).any(|w|w==b"LogOut_File: : logfile stopped\\r\\n"));Some(String::from_utf8(data).unwrap())}else{assert!(!path.exists());None};
        app.world_mut().resource_mut::<NativeReplayService>().0.close().unwrap();app.world_mut().non_send_resource_mut::<Application>().close().unwrap();
        let closed=app.world().non_send_resource::<Application>().diagnostic().unwrap();
        for key in ["heap_blocks","retained_mirrors","critical_sections","heap_failures","lock_failures"]{assert_eq!(closed["crt"][key],0);}
        assert_eq!(closed["worker_failures"],serde_json::json!([]));assert_eq!(closed["workers_created"],0);
        profiles.push(serde_json::json!({"expected_file_open":success,"path":path,"report":report,"content":content,"closed":closed}));
    }
    println!("{}",serde_json::json!({"profiles":profiles,"normal_application_attachment":true,"native_diagnostic_file_resource":true,"host_crt":"Windows msvcrt.dll fopen/fprintf/fclose","full_stream_file_preparation":false,"pathname_registration_singleton":false,"replay_frame_serialization":false,"service_manager_connected":false}));
}
'''
# Exact stop-line length is31, derive it in Rust to avoid a duplicated constant.
t=t.replace('data.windows(32).any(|w|w==b"LogOut_File: : logfile stopped\\r\\n")','data.windows(b"LogOut_File: : logfile stopped\\r\\n".len()).any(|w|w==b"LogOut_File: : logfile stopped\\r\\n")')
(s/'main_replay_recording.rs').write_text(t,encoding='utf-8')
print('Prepared final-client on-disk source diagnostic file probe')
