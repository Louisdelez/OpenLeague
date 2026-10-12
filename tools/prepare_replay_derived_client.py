from pathlib import Path
import hashlib,json
r=Path('E:/OpenLeague');s=Path('E:/mapslol3v3');p='crates/client/src/main.rs';raw=(r/p).read_bytes();t=raw.decode('utf-8-sig').replace('\r\n','\n')
anchor='    if let Some(index)=arguments.iter().position(|a|a=="--native-replay-configuration-probe") {'
assert t.count(anchor)==1
t=t.replace(anchor,'''    if let Some(index)=arguments.iter().position(|a|a=="--native-replay-stream-transport-probe") {
        #[cfg(windows)] {
            let probe_root=arguments.get(index+1).map(std::path::PathBuf::from).unwrap_or_else(||root.clone());
            native_replay_stream_transport_probe(&probe_root);
            return;
        }
        #[cfg(not(windows))] panic!("Native replay stream transport requires Windows");
    }
'''+anchor)
t+='''
#[cfg(windows)]
fn native_replay_stream_transport_probe(root:&std::path::Path) {
    use openleague_core::{audio_replay_windows_application::Application,audio_replay_windows_transport::{ConfigurationRequest,StreamConfigurationRequest,ConfigurationCallback}};
    let mut profiles=Vec::new();
    // Source parent state1 creates a fresh implementation. A released status2
    // transport must not be silently reused or supplied invented references.
    for(host,expected)in[(b"127.0.0.1".as_slice(),0),(b"98.24.0.44".as_slice(),3)] {
        let loaded=native_user_settings::load(root).expect("load stream transport Game.cfg");
        let replay=native_replay_service::Service::new(loaded.replay).expect("construct configured replay service");
        let mut app=App::new();app.insert_resource(NativeReplayService(replay));
        attach_native_replay_runtime(&mut app).expect("attach normal native replay runtime");
        let before=app.world().non_send_resource::<Application>().diagnostic().expect("idle lifetime");
        let result=app.world().non_send_resource::<Application>().transport().expect("runtime").configure_stream_transport(StreamConfigurationRequest {
            transport:ConfigurationRequest {host:Some(host),port:0x1234ffff,arguments:[0x11223344,0x55667788],callback:Some(ConfigurationCallback {owner:0x44000000,member:0x728e20}),sockaddr_frame:[165;16]},
            key:std::array::from_fn(|i|i as u8),flag:0x1ff,extra:0x88776655,
        }).expect("actual Windows derived transport configuration");
        assert_eq!(result,expected);
        let configured=app.world().non_send_resource::<Application>().diagnostic().expect("configured lifetime");
        let c=&configured["transport"]["configuration"];let stream=&c["stream"];
        assert_eq!(stream["interface_pointer"].as_u64().unwrap(),c["pointer"].as_u64().unwrap()+0xe0);
        assert_eq!(stream["flag"],255);assert_eq!(stream["extra"],0x88776655u32);
        assert_eq!(configured["transport"]["references"],if expected==0{1}else{0});
        if expected==0 {assert_ne!(stream["key_pointer"],0);assert_eq!(c["uid"],0xff2199f5u32);}
        else {assert_eq!(stream["key_pointer"],0);assert_eq!(c["uid"],0);}
        let service=app.world_mut().resource_mut::<NativeReplayService>().0.diagnostic().expect("service diagnostic");
        app.world_mut().resource_mut::<NativeReplayService>().0.close().expect("close replay service");
        assert_eq!(app.world().resource::<NativeReplayService>().0.live_allocations(),0);
        app.world_mut().non_send_resource_mut::<Application>().close().expect("close derived transport and CRT owner");
        let closed=app.world().non_send_resource::<Application>().diagnostic().expect("closed lifetime");
        assert_eq!(closed["crt"]["heap_blocks"],0);assert_eq!(closed["crt"]["critical_sections"],0);
        assert_eq!(closed["workers_created"],1);assert_eq!(closed["workers_closed"],1);
        profiles.push(serde_json::json!({"before":before,"configured":configured,"closed":closed,"service":service,"native_code":result}));
    }
    println!("{}",serde_json::json!({"profiles":profiles,"normal_application_attachment":true,"native_derived_transport_configuration":true,"source_stream_opening_connected":false,"replay_frame_delivery":false}));
}
'''
(s/'main_replay_stream_transport.rs').write_text(t,encoding='utf-8')
q=s/'replay_derived_windows_source_inputs.json';inputs=json.loads(q.read_text());inputs[p]=hashlib.sha256(raw).hexdigest();q.write_text(json.dumps(inputs,indent=2)+'\n')
print('Prepared rebuilt-client derived transport success/error probe')
