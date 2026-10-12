from pathlib import Path
import hashlib,json
r=Path('E:/OpenLeague');s=Path('E:/mapslol3v3');inputs=json.loads((s/'replay_opening_source_inputs.json').read_text())
def read(p):
 raw=(r/p).read_bytes();inputs[p]=hashlib.sha256(raw).hexdigest();return raw.decode('utf-8-sig').replace('\r\n','\n')
def put(n,t):(s/n).write_text(t,encoding='utf-8')
def rep(t,a,b):assert t.count(a)==1,(a,t.count(a));return t.replace(a,b)
t=read('crates/core/src/audio_replay_windows_transport.rs')
t=rep(t,'mod configuration;','mod configuration;\n#[path="audio_replay_windows_opening.rs"]mod opening;\npub use opening::{StreamOpenRequest,StreamSnapshot};')
t=rep(t,'    configuration: Mutex<Option<configuration::Record>>,','    configuration: Mutex<Option<configuration::Record>>,\n    stream: Mutex<Option<opening::Record>>,')
t=rep(t,'                configuration: Mutex::new(None),','                configuration: Mutex::new(None),\n                stream: Mutex::new(None),')
t=rep(t,'        if self.shared.configuration.lock().unwrap().is_some() {','        if self.shared.stream.lock().unwrap().is_some(){return Err("close the owned stream before releasing transport".into());}\n        if self.shared.configuration.lock().unwrap().is_some() {')
t=rep(t,'        self.close_configuration_owned(&mut b)?;','        self.close_stream_owned(&mut b)?;\n        self.close_configuration_owned(&mut b)?;')
t=rep(t,'        if f != thread::DISPOSE {','''        if f==crate::audio_replay_manager_control::DISPOSE{return crate::audio_replay_manager_control::dispose(self,p).map_err(|e|self.failure(e,"manager control disposal failed"));}
        if f==control::DISPOSE{return control::dispose(self,p).map_err(|e|self.failure(e,"shared object disposal failed"));}
        if f != thread::DISPOSE {''');put('audio_replay_windows_transport.rs',t)
t=read('crates/core/src/audio_replay_windows_configuration.rs');t=rep(t,'        let mut b = Backend::new(self.shared.clone());','        let mut b = Backend::new(self.shared.clone());') if False else t
anchor='        if self.shared.diagnostics.is_some() {';t=rep(t,anchor,'        if self.shared.stream.lock().unwrap().is_some(){return Err("an owned replay stream already uses this transport".into());}\n'+anchor);t=t.replace('//! The source224-byte object remains owned until close_configuration/shutdown.','//! The source base or derived object remains owned until close_configuration/shutdown.');put('audio_replay_windows_configuration.rs',t)
t=read('crates/core/src/audio_replay_windows_application.rs');t=rep(t,'"configuration":r.configuration_snapshot()?','"configuration":r.configuration_snapshot()?,"stream":r.stream_snapshot()?');t+='\n#[cfg(test)]\n#[path="audio_replay_windows_opening_tests.rs"]mod opening_tests;\n';put('audio_replay_windows_application.rs',t)
t=read('crates/core/src/audio_replay_runtime_image.rs');t=rep(t,'[(u32, u32, u32); 15]','[(u32, u32, u32); 20]');t=rep(t,'    (1, 0x10d5fdc, 12),','''    (1, 0x10d5fdc, 12),
    (1, 0x10d5f34, 4),
    (1, 0x10d607c, 40),
    (1, 0x1085f4c, 12),
    (1, 0x10d6030, 12),
    (1, 0x10d5fec, 48),''');put('audio_replay_runtime_image.rs',t)
t=read('tools/extract_replay_runtime_image.py');t=rep(t," ('stream_transport_control_vtable',1,0x10d5fdc,12),",''' ('stream_transport_control_vtable',1,0x10d5fdc,12),
 ('stream_object_vtable',1,0x10d5f34,4),
 ('stream_state_machine_vtable',1,0x10d607c,40),
 ('stream_null_control_vtable',1,0x1085f4c,12),
 ('stream_manager_control_vtable',1,0x10d6030,12),
 ('stream_null_implementation_vtable',1,0x10d5fec,48),''');put('extract_replay_runtime_image.py',t)
t=read('crates/core/src/lib.rs');t+='\npub mod audio_replay_opening;\n';put('lib_replay_opening.rs',t)
put('replay_opening_source_inputs.json',json.dumps(inputs,indent=2)+'\n');print('Prepared canonical stream/manager/transport Windows ownership')
