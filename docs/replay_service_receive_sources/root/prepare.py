from pathlib import Path
import shutil
R=Path('E:/OpenLeague');S=Path('E:/mapslol3v3/replay_receive_stage');P=S/'production'
def put(rel,text):
 p=P/rel;p.parent.mkdir(parents=True,exist_ok=True);p.write_text(text,encoding='utf-8')
def read(rel):return (R/rel).read_text(encoding='utf-8')
for name in ['audio_replay_service_receive.rs','audio_replay_service_receive_tests.rs']:
 put('crates/core/src/'+name,(S.parent/'replay_packet_agent'/name).read_text(encoding='utf-8'))
for name in ['audio_replay_packet95.rs','audio_replay_packet95_tests.rs']:
 put('crates/core/src/'+name,(S.parent/'replay_packet95_agent'/name).read_text(encoding='utf-8'))
for name in ['audio_announcer_owner_metadata.rs','audio_announcer_service_activation.rs','audio_announcer_service_activation_cleanup_tests.rs']:
 put('crates/core/src/'+name,(S.parent/'replay_dispatch_cleanup_agent'/name).read_text(encoding='utf-8'))
for name in ['audio_replay_windows_receive.rs','audio_replay_windows_receive_tests.rs']:
 put('crates/core/src/'+name,(S/name).read_text(encoding='utf-8'))
put('crates/core/src/lib.rs',read('crates/core/src/lib.rs')+'\npub mod audio_replay_service_receive;\npub mod audio_replay_packet95;\n')
t=read('crates/core/src/audio_replay_windows_transport.rs')
t=t.replace('#[path = "audio_replay_windows_service.rs"]','#[path = "audio_replay_windows_receive.rs"]\nmod receive;\n#[path = "audio_replay_windows_service.rs"]')
old='''        _: u32,
        _: u32,
        _: u32,
        _: &mut u32,
    ) -> Result<(), &'static str> {
        Err("transport logger has no listener registry")
    }
    fn unregister_listener(&mut self, _: u32, _: u32, _: u32) -> Result<(), &'static str> {
        Err("transport logger has no listener registry")
    }'''
new='''        service: u32,
        callback: u32,
        field: u32,
        temporary: &mut u32,
    ) -> Result<(), &'static str> {
        crate::audio_announcer_pending_service::register_virtual(self,service,callback,field,*temporary)
            .map_err(|e|self.failure(e,"pending listener registration failed"))
    }
    fn unregister_listener(&mut self, service:u32, callback:u32, field:u32) -> Result<(), &'static str> {
        crate::audio_announcer_pending_service::unregister_virtual(self,service,callback,field)
            .map_err(|e|self.failure(e,"listener removal failed"))
    }'''
assert old in t;t=t.replace(old,new);put('crates/core/src/audio_replay_windows_transport.rs',t)
t=read('crates/core/src/audio_replay_windows_events.rs')
t=t.replace('    fn event_temporary<T>(', '    pub(super) fn event_temporary<T>(').replace('    fn event_reference(', '    pub(super) fn event_reference(')
needle='''        if member != 0x72b950 {'''
new='''        if member == 0x738a3a {
            return self.event_temporary(24, |b,s| {
                crate::audio_replay_service_receive::invoke_virtual(b,owner,first,second,s)
                    .map(u32::from).map_err(|e|b.failure(e,"service packet consumer failed"))
            });
        }
        if member != 0x72b950 {'''
assert needle in t;t=t.replace(needle,new)
needle='''        let bytes = u32::try_from(packet.len())'''
new='''        if selector as u8 == 3 && matches!(subtype as u8,2..=4) {
            let service=self.shared.service.lock().unwrap().as_ref()
                .ok_or("service is not initialized")?.pointer;
            b.preflight_service_packet(service,packet)?;
        }
        let bytes = u32::try_from(packet.len())'''
assert needle in t;t=t.replace(needle,new)
# Existing native-client probe gets a real packet route check before the parent is retired.
needle='''        self.close_game_manager()?;
        Ok(
            serde_json::json!({"passed":true,"notifications":4100'''
new='''        let service_packets=self.probe_service_packet_ingress()?;
        self.close_game_manager()?;
        Ok(
            serde_json::json!({"service_packets":service_packets,"passed":true,"notifications":4100'''
assert needle in t;t=t.replace(needle,new);put('crates/core/src/audio_replay_windows_events.rs',t)
t=read('tools/extract_replay_runtime_image.py').replace("('game_service_vtable',1,0x10afe8c,32)","('game_service_vtable',1,0x10afe8c,180)")
extra=""" ('service_receive_local_owner',1,0x2d62878,4),
 ('service_owner_metadata_global',1,0x2d787b8,4),
 ('service_owner_sentinel',1,0x2d5f448,4),
 ('owner_metadata_default',1,0x123b12c,4),
 ('owner_metadata_vtables',1,0x10a0360,48),
 ('service_packet_switch_targets',1,0x58c1ac,496),
 ('service_packet_switch_indices',1,0x58c39c,301),
 ('packet95_receiver_pair',1,0x14c761c,8),
"""
t=t.replace("]\noutput=bytearray",extra+"]\noutput=bytearray")
t=t.replace("stage=Path('E:/mapslol3v3/replay_events_stage')", "stage=Path('E:/mapslol3v3/replay_receive_stage')")
put('tools/extract_replay_runtime_image.py',t)
t=read('crates/core/src/audio_replay_runtime_image.rs').replace('; 39]','; 47]').replace('(1, 0x10afe8c, 32)', '(1, 0x10afe8c, 180)')
extra=''.join(f'    (1, {a}, {n}),\n' for a,n in [('0x2d62878',4),('0x2d787b8',4),('0x2d5f448',4),('0x123b12c',4),('0x10a0360',48),('0x58c1ac',496),('0x58c39c',301),('0x14c761c',8)])
t=t.replace('];\npub struct Initial',extra+'];\npub struct Initial');put('crates/core/src/audio_replay_runtime_image.rs',t)
target=P/'data/4.20/replay_service_packet_probe.json';target.parent.mkdir(parents=True,exist_ok=True)
shutil.copyfile(S.parent/'replay_packet_agent/replay_service_packet_probe.json',target)
shutil.copyfile(S.parent/'replay_packet_agent/replay_service_packet_sources.json',target.with_name('replay_service_packet_sources.json'))
shutil.copyfile(S.parent/'replay_packet95_agent/replay_packet95_probe.json',target.with_name('replay_packet95_probe.json'))
print('stage prepared')
