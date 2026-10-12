from pathlib import Path
r=Path('E:/OpenLeague');s=Path('E:/mapslol3v3')
t=(r/'crates/client/src/main.rs').read_text(encoding='utf-8')
anchor='    if let Some(index)=arguments.iter().position(|a|a=="--native-replay-stream-opening-probe") {'
assert t.count(anchor)==1
t=t.replace(anchor,'''    if let Some(index)=arguments.iter().position(|a|a=="--native-replay-stream-running-probe") {
        #[cfg(windows)] {
            let probe_root=arguments.get(index+1).map(std::path::PathBuf::from).unwrap_or_else(||root.clone());
            native_replay_stream_running_probe(&probe_root);return;
        }
        #[cfg(not(windows))] panic!("Native replay stream running requires Windows");
    }
'''+anchor)
t+='''
#[cfg(windows)]
fn native_replay_stream_running_probe(root:&std::path::Path) {
    use openleague_core::{audio_replay_windows_application::Application,audio_replay_windows_transport::{ConfigurationRequest,StreamConfigurationRequest,StreamOpenRequest}};
    let mut profiles=Vec::new();
    for stop_explicitly in [true,false] {
        let loaded=native_user_settings::load(root).expect("load replay Game.cfg");
        let replay=native_replay_service::Service::new(loaded.replay).expect("configured replay service");
        let mut app=App::new();app.insert_resource(NativeReplayService(replay));
        attach_native_replay_runtime(&mut app).expect("normal runtime attachment");
        let runtime=app.world().non_send_resource::<Application>().transport().unwrap();
        assert_eq!(runtime.open_stream(StreamOpenRequest{mode:1,configuration:StreamConfigurationRequest{
            transport:ConfigurationRequest{host:None,port:0,arguments:[0;2],callback:None,sockaddr_frame:[0;16]},
            key:[0;16],flag:0,extra:0,
        }}).unwrap(),0);
        let before=runtime.stream_snapshot().unwrap();
        assert_eq!(runtime.start_stream([1,2,3,4,5,6]).unwrap(),0);
        assert_eq!(runtime.start_stream([1,2,3,4,5,6]).unwrap(),8);
        std::thread::sleep(std::time::Duration::from_millis(50));
        let active=runtime.snapshot().unwrap().active_workers;assert_eq!(active,1);
        let stopped=if stop_explicitly {
            runtime.stop_stream().unwrap();runtime.stop_stream().unwrap();
            let state=runtime.stream_snapshot().unwrap();assert_eq!(state.as_ref().unwrap().state_id,3);
            assert_eq!(runtime.snapshot().unwrap().active_workers,0);state
        }else{None};
        app.world_mut().resource_mut::<NativeReplayService>().0.close().unwrap();
        app.world_mut().non_send_resource_mut::<Application>().close().unwrap();
        let closed=app.world().non_send_resource::<Application>().diagnostic().unwrap();
        for key in ["heap_blocks","retained_mirrors","critical_sections","heap_failures","lock_failures"]{assert_eq!(closed["crt"][key],0);}
        assert_eq!(closed["workers_created"],1);assert_eq!(closed["workers_closed"],1);
        assert_eq!(closed["handle_failures"],0);assert_eq!(closed["worker_failures"],serde_json::json!([]));
        profiles.push(serde_json::json!({"explicit_stop":stop_explicitly,"before":before,"active_workers":active,"stopped":stopped,"closed":closed}));
    }
    println!("{}",serde_json::json!({"profiles":profiles,"normal_application_attachment":true,"source_stream_worker":true,
        "implementation":"native_no_op","active_network_host_connected":false,"recording_file_connected":false,"service_manager_connected":false,"replay_frame_delivery":false}));
}
'''
(s/'main_replay_running.rs').write_text(t,encoding='utf-8')
print('Prepared final-client actual-worker start/stop command')
