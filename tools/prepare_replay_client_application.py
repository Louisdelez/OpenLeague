from pathlib import Path
import hashlib,json
r=Path('E:/OpenLeague');s=Path('E:/mapslol3v3');p=r/'crates/client/src/main.rs';source=p.read_text(encoding='utf-8')
assert 'attach_native_replay_runtime' not in source
anchor='    let arguments:Vec<String>=std::env::args().collect();';assert source.count(anchor)==1
probe='''
    if let Some(index)=arguments.iter().position(|a|a=="--native-replay-runtime-probe") {
        #[cfg(windows)] {
            let probe_root=arguments.get(index+1).map(std::path::PathBuf::from).unwrap_or_else(||root.clone());
            native_replay_runtime_probe(&probe_root);
            return;
        }
        #[cfg(not(windows))] panic!("Native replay Windows runtime requires Windows");
    }
'''
source=source.replace(anchor,anchor+probe)
anchor='    App::new()\n        .insert_resource(zip_resources)';assert source.count(anchor)==1
source=source.replace(anchor,'''    let mut app=App::new();
    #[cfg(windows)] attach_native_replay_runtime(&mut app).expect("create native replay Windows lifetime");
    app.insert_resource(zip_resources)''')
source+='''

#[cfg(windows)]
fn attach_native_replay_runtime(app:&mut App)->Result<(),String> {
    let runtime=openleague_core::audio_replay_windows_application::Application::new()?;
    app.insert_non_send_resource(runtime);
    Ok(())
}

#[cfg(windows)]
fn native_replay_runtime_probe(root:&std::path::Path) {
    use openleague_core::audio_replay_windows_application::Application;
    let loaded=native_user_settings::load(root).expect("load runtime probe Game.cfg");
    let replay=native_replay_service::Service::new(loaded.replay).expect("construct configured native replay service");
    let mut app=App::new();
    app.insert_resource(NativeReplayService(replay));
    attach_native_replay_runtime(&mut app).expect("attach normal native replay runtime");
    let before=app.world().non_send_resource::<Application>().diagnostic().expect("read idle runtime");
    let initialized=app.world().non_send_resource::<Application>().transport().expect("transport owner").initialize().expect("native transport initialization");
    let running=app.world().non_send_resource::<Application>().diagnostic().expect("read initialized runtime");
    assert_eq!(initialized,1);
    assert_eq!(running["transport"]["status"],2);
    assert_eq!(running["transport"]["references"],1);
    let service=app.world_mut().resource_mut::<NativeReplayService>().0.diagnostic().expect("read configured native replay service");
    app.world_mut().resource_mut::<NativeReplayService>().0.close().expect("close configured native replay service");
    let live_service_allocations=app.world().resource::<NativeReplayService>().0.live_allocations();
    app.world_mut().non_send_resource_mut::<Application>().close().expect("close replay Windows lifetime");
    let closed=app.world().non_send_resource::<Application>().diagnostic().expect("read closed runtime");
    assert_eq!(live_service_allocations,0);
    assert_eq!(closed["crt"]["heap_blocks"],0);
    assert_eq!(closed["crt"]["critical_sections"],0);
    assert_eq!(closed["workers_created"],closed["workers_closed"]);
    println!("{}",serde_json::json!({"before":before,"running":running,"closed":closed,"replay_service":service,"live_service_allocations_after_close":live_service_allocations,"normal_application_attachment":true,"replay_frame_delivery":false}));
}
'''
(s/'replay_client_main_updated.rs').write_text(source,encoding='utf-8')
(s/'replay_client_main_source.json').write_text(json.dumps({'original_sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'updated_sha256':hashlib.sha256((s/'replay_client_main_updated.rs').read_bytes()).hexdigest()}),encoding='utf-8')
print('Staged normal client attachment and runtime probe; production files unchanged.')
