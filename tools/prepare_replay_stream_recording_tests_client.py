from pathlib import Path
r=Path('E:/OpenLeague');s=Path('E:/mapslol3v3')
t=(r/'crates/core/src/audio_replay_windows_recording_tests.rs').read_text(encoding='utf-8')
t+='''
#[test]
fn audio_replay_windows_recorded_stream_prepares_starts_stops_and_retires_actual_file_worker_registry_lifetimes(){
    for profile in 0..4 {
        let folder=directory();let path=if profile==2{folder.join("missing").join("recorded-stream.log")}else{folder.join("recorded-stream.log")};
        let mut a=Application::new().unwrap();let r=a.transport().unwrap();
        let input=match profile {0=>None,3=>Some(b"".as_slice()),_=>Some(path.to_str().unwrap().as_bytes())};
        if profile==1 {std::fs::write(&path,b"old bytes must disappear").unwrap();}
        let p=r.probe_recording_stream(input,&[b"Stream diagnostic 100% %s %n",b"Narrow \\x80\\xe9\\xff\\0ignored"]).unwrap();
        assert_eq!((p.open_code,p.start_code,p.state_after_start,p.state_after_stop),(0,0,4,3));
        assert_eq!(p.resource_enabled,if profile==1 {1}else{0});
        assert_eq!(p.resource_references,1);assert_eq!(p.registry_initialized,profile!=0);
        assert_eq!(p.files_opened,if profile==1{2}else{0});assert_eq!(p.files_opened,p.files_closed);assert_eq!(p.remaining_files,0);
        assert_eq!(r.snapshot().unwrap().active_workers,0);assert!(r.stream_snapshot().unwrap().is_none());
        assert_eq!(r.logger_snapshot().unwrap().pointer,0);assert!(r.errors().is_empty());
        assert_eq!(r.snapshot().unwrap().engine_allocations,usize::from(profile!=0));
        a.close().unwrap();let d=a.diagnostic().unwrap();
        assert_eq!(d["workers_created"],1);assert_eq!(d["workers_closed"],1);assert_eq!(d["worker_failures"],serde_json::json!([]));
        for k in ["heap_blocks","retained_mirrors","critical_sections","heap_failures","lock_failures"]{assert_eq!(d["crt"][k],0);}
        assert_eq!(d["crt"]["heap_allocations"],d["crt"]["heap_frees"]);
        if profile==1 {
            let bytes=std::fs::read(&path).unwrap();
            for needed in [b"LogOut_File: : logfile started\\r\\n".as_slice(),b"Stream diagnostic 100% %s %n\\r\\n",b"Narrow \\x80\\xe9\\xff\\r\\n",b"LogOut_File: : logfile stopped\\r\\n"]{assert!(bytes.windows(needed.len()).any(|x|x==needed));}
            for absent in [b"old bytes".as_slice(),b"ignored"]{assert!(!bytes.windows(absent.len()).any(|x|x==absent));}
            assert!(bytes.ends_with(b"LogOut_File: : logfile stopped\\r\\n"));assert!(p.writes>=4);
            std::fs::remove_file(&path).unwrap();
        }else{assert!(!path.exists());assert_eq!(p.writes,0);}
        std::fs::remove_dir(folder).unwrap();
    }
}
'''
(s/'audio_replay_windows_recording_tests.rs').write_text(t,encoding='utf-8')
t=(r/'crates/client/src/main.rs').read_text(encoding='utf-8')
anchor='    if let Some(index)=arguments.iter().position(|a|a=="--native-replay-recording-file-probe") {'
assert t.count(anchor)==1
t=t.replace(anchor,'''    if let Some(index)=arguments.iter().position(|a|a=="--native-replay-recording-stream-probe") {
        #[cfg(windows)] {let probe_root=arguments.get(index+1).map(std::path::PathBuf::from).unwrap_or_else(||root.clone());native_replay_recording_stream_probe(&probe_root);return;}
        #[cfg(not(windows))] panic!("Native stream file requires Windows");
    }
'''+anchor)
t+='''
#[cfg(windows)]
fn native_replay_recording_stream_probe(root:&std::path::Path){
    use openleague_core::audio_replay_windows_application::Application;
    let nonce=std::time::SystemTime::now().duration_since(std::time::UNIX_EPOCH).unwrap().as_nanos();let mut profiles=Vec::new();
    for profile in 0..3 {
        let loaded=native_user_settings::load(root).unwrap();let replay=native_replay_service::Service::new(loaded.replay).unwrap();
        let mut app=App::new();app.insert_resource(NativeReplayService(replay));attach_native_replay_runtime(&mut app).unwrap();
        let path=if profile==2{root.join("logs").join(format!("missing-stream-directory-{nonce}")).join("diagnostic.log")}else{root.join("logs").join(format!("native-stream-diagnostic-{nonce}.log"))};
        let report=app.world().non_send_resource::<Application>().transport().unwrap().probe_recording_stream(if profile==0{None}else{Some(path.to_str().unwrap().as_bytes())},&[b"OpenLeague stream diagnostic %n %s",b"Source optional preparation and worker lifetime"]).unwrap();
        assert_eq!((report.open_code,report.start_code,report.state_after_start,report.state_after_stop),(0,0,4,3));
        assert_eq!(report.resource_enabled,if profile==1{1}else{0});assert_eq!(report.resource_references,1);assert_eq!(report.registry_initialized,profile!=0);
        assert_eq!(report.files_opened,if profile==1{2}else{0});assert_eq!(report.files_opened,report.files_closed);assert_eq!(report.remaining_files,0);
        let content=if profile==1{let bytes=std::fs::read(&path).unwrap();assert!(bytes.ends_with(b"LogOut_File: : logfile stopped\\r\\n"));Some(String::from_utf8(bytes).unwrap())}else{if profile==2{assert!(!path.exists());}None};
        app.world_mut().resource_mut::<NativeReplayService>().0.close().unwrap();app.world_mut().non_send_resource_mut::<Application>().close().unwrap();
        let closed=app.world().non_send_resource::<Application>().diagnostic().unwrap();assert_eq!(closed["closed"],true);
        for key in ["heap_blocks","retained_mirrors","critical_sections","heap_failures","lock_failures"]{assert_eq!(closed["crt"][key],0);}
        assert_eq!(closed["worker_failures"],serde_json::json!([]));assert_eq!(closed["workers_created"],1);assert_eq!(closed["workers_closed"],1);
        profiles.push(serde_json::json!({"profile":profile,"path":path,"report":report,"content":content,"closed":closed}));
    }
    println!("{}",serde_json::json!({"profiles":profiles,"normal_application_attachment":true,"source_optional_stream_preparation":true,"source_noop_implementation":true,"pathname_registration_singleton":true,"active_network_host":false,"replay_frame_serialization":false,"service_manager_connected":false}));
}
'''
(s/'main_replay_stream_recording.rs').write_text(t,encoding='utf-8')
print('Staged four actual Windows lifetimes and three rebuilt-client profiles')
