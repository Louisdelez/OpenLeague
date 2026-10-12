from pathlib import Path
r=Path('E:/OpenLeague');s=Path('E:/mapslol3v3');p=r/'crates/client/src/main.rs';text=p.read_text(encoding="utf-8")
anchor='    if let Some(index)=arguments.iter().position(|a|a=="--native-replay-runtime-probe") {'
assert text.count(anchor)==1
text=text.replace(anchor,'''    if let Some(index)=arguments.iter().position(|a|a=="--native-replay-configuration-probe") {
        #[cfg(windows)] {
            let probe_root=arguments.get(index+1).map(std::path::PathBuf::from).unwrap_or_else(||root.clone());
            native_replay_configuration_probe(&probe_root);
            return;
        }
        #[cfg(not(windows))] panic!("Native replay configuration requires Windows");
    }
'''+anchor)
text+='''
#[cfg(windows)]
fn native_replay_configuration_probe(root:&std::path::Path) {
    use openleague_core::{audio_replay_windows_application::Application,audio_replay_windows_transport::ConfigurationRequest};
    let loaded=native_user_settings::load(root).expect("load replay configuration probe Game.cfg");
    let replay=native_replay_service::Service::new(loaded.replay).expect("construct configured native replay service");
    let mut app=App::new();
    app.insert_resource(NativeReplayService(replay));
    attach_native_replay_runtime(&mut app).expect("attach normal native replay runtime");
    let before=app.world().non_send_resource::<Application>().diagnostic().expect("idle configuration lifetime");
    let configured=app.world().non_send_resource::<Application>().transport().expect("transport owner").configure(ConfigurationRequest{host:Some(b"127.0.0.1"),port:0x1234ffff,arguments:[0x11223344,0x55667788],callback:None,sockaddr_frame:[165;16]}).expect("actual Windows transport configuration");
    assert_eq!(configured,0);
    let running=app.world().non_send_resource::<Application>().diagnostic().expect("configured lifetime");
    assert_eq!(running["transport"]["configuration"]["uid"],0xff2199f5u32);
    assert_eq!(running["transport"]["configuration"]["requested_port"],65535);
    assert_eq!(running["transport"]["references"],1);
    let rejected=app.world().non_send_resource::<Application>().transport().expect("transport owner").configure(ConfigurationRequest{host:Some(b"98.24.0.44"),port:12345,arguments:[0,0],callback:None,sockaddr_frame:[0;16]}).expect("native zero-UID error code");
    assert_eq!(rejected,3);
    let failed=app.world().non_send_resource::<Application>().diagnostic().expect("failed configuration lifetime");
    assert_eq!(failed["transport"]["references"],0);
    assert_eq!(failed["transport"]["winsock_references"],0);
    assert_eq!(failed["transport"]["timer_references"],0);
    let service=app.world_mut().resource_mut::<NativeReplayService>().0.diagnostic().expect("configured replay service");
    app.world_mut().resource_mut::<NativeReplayService>().0.close().expect("close replay service");
    assert_eq!(app.world().resource::<NativeReplayService>().0.live_allocations(),0);
    app.world_mut().non_send_resource_mut::<Application>().close().expect("close native configuration and Windows lifetime");
    let closed=app.world().non_send_resource::<Application>().diagnostic().expect("closed configuration lifetime");
    assert_eq!(closed["crt"]["heap_blocks"],0);
    assert_eq!(closed["crt"]["critical_sections"],0);
    assert_eq!(closed["workers_created"],1);
    assert_eq!(closed["workers_closed"],1);
    println!("{}",serde_json::json!({"before":before,"configured":running,"configuration_error":failed,"closed":closed,"replay_service":service,"native_success_code":configured,"native_failure_code":rejected,"normal_application_attachment":true,"native_transport_configuration":true,"source_stream_opening_connected":false,"replay_frame_delivery":false}));
}
'''
(s/'main_replay_windows_configuration.rs').write_text(text,encoding='utf-8')
print('Prepared normal-client Windows configuration probe through the existing Application owner')

