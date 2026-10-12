from pathlib import Path
import hashlib,json
r=Path('E:/OpenLeague');s=Path('E:/mapslol3v3');p='crates/client/src/main.rs';raw=(r/p).read_bytes();t=raw.decode('utf-8-sig').replace('\r\n','\n')
anchor='    if let Some(index)=arguments.iter().position(|a|a=="--native-replay-stream-transport-probe") {';assert t.count(anchor)==1
t=t.replace(anchor,'''    if let Some(index)=arguments.iter().position(|a|a=="--native-replay-stream-opening-probe") {
        #[cfg(windows)] {
            let probe_root=arguments.get(index+1).map(std::path::PathBuf::from).unwrap_or_else(||root.clone());
            native_replay_stream_opening_probe(&probe_root);return;
        }
        #[cfg(not(windows))] panic!("Native replay stream opening requires Windows");
    }
'''+anchor)
t+='''
#[cfg(windows)]
fn native_replay_stream_opening_probe(root:&std::path::Path) {
    use openleague_core::{audio_replay_windows_application::Application,audio_replay_windows_transport::{ConfigurationRequest,StreamConfigurationRequest,StreamOpenRequest,ConfigurationCallback}};
    let mut profiles=Vec::new();
    for(mode,host,expected)in[(0,Some(b"127.0.0.1".as_slice()),0),(0,Some(b"98.24.0.44".as_slice()),3),(1,None,0)] {
        let loaded=native_user_settings::load(root).expect("load opening Game.cfg");let replay=native_replay_service::Service::new(loaded.replay).expect("replay service");
        let mut app=App::new();app.insert_resource(NativeReplayService(replay));attach_native_replay_runtime(&mut app).expect("normal replay runtime attachment");
        let before=app.world().non_send_resource::<Application>().diagnostic().expect("idle lifetime");
        let code=app.world().non_send_resource::<Application>().transport().expect("runtime").open_stream(StreamOpenRequest{mode,configuration:StreamConfigurationRequest{
            transport:ConfigurationRequest{host,port:65535,arguments:[0x11223344,0x55667788],callback:Some(ConfigurationCallback{owner:0x44000000,member:0x728e20}),sockaddr_frame:[165;16]},
            key:std::array::from_fn(|i|i as u8),flag:0x1ff,extra:0x88776655,
        }}).expect("native stream opening");assert_eq!(code,expected);
        let opened=app.world().non_send_resource::<Application>().diagnostic().expect("opened lifetime");let stream=&opened["transport"]["stream"];
        assert_eq!(stream["state_id"],if expected==0{3}else{1});assert_eq!(stream["manager"],stream["implementation_manager"]);assert_eq!(stream["manager_references"],2);
        assert_eq!(opened["transport"]["references"],if mode==0&&expected==0{1}else{0});
        app.world().non_send_resource::<Application>().transport().expect("runtime").close_stream().expect("source stream destruction");
        let stream_closed=app.world().non_send_resource::<Application>().diagnostic().expect("global runtime retained");assert!(stream_closed["transport"]["stream"].is_null());
        assert_eq!(stream_closed["transport"]["references"],if mode==0&&expected==0{1}else{0});
        app.world_mut().resource_mut::<NativeReplayService>().0.close().expect("close service");assert_eq!(app.world().resource::<NativeReplayService>().0.live_allocations(),0);
        app.world_mut().non_send_resource_mut::<Application>().close().expect("close shared runtime and CRT");
        let closed=app.world().non_send_resource::<Application>().diagnostic().expect("closed lifetime");assert_eq!(closed["crt"]["heap_blocks"],0);assert_eq!(closed["crt"]["critical_sections"],0);assert_eq!(closed["workers_created"],if mode==0{1}else{0});assert_eq!(closed["workers_created"],closed["workers_closed"]);
        profiles.push(serde_json::json!({"mode":mode,"native_code":code,"before":before,"opened":opened,"stream_closed":stream_closed,"closed":closed}));
    }
    println!("{}",serde_json::json!({"profiles":profiles,"normal_application_attachment":true,"source_stream_opening":true,"optional_recording_resource_connected":false,"service_manager_callback_connected":false,"replay_frame_delivery":false}));
}
'''
(s/'main_replay_opening.rs').write_text(t,encoding='utf-8');q=s/'replay_opening_source_inputs.json';inputs=json.loads(q.read_text());inputs[p]=hashlib.sha256(raw).hexdigest();q.write_text(json.dumps(inputs,indent=2)+'\n');print('Prepared normal-attachment stream opening client probe')
