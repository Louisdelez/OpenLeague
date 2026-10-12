from pathlib import Path
r=Path('E:/OpenLeague');s=Path('E:/mapslol3v3')
def edit(name,replacements):
 t=(r/name).read_text(encoding='utf-8')
 for a,b in replacements:assert t.count(a)==1,(name,a[:70],t.count(a));t=t.replace(a,b)
 (s/Path(name).name).write_text(t,encoding='utf-8')
edit('crates/core/src/audio_replay_windows_transport.rs',[
 ('mod opening;','mod opening;\n#[path="audio_replay_windows_recording.rs"]\nmod recording;\npub use recording::RecordingFileProbe;'),
 ('    stream: Mutex<Option<opening::Record>>,','    stream: Mutex<Option<opening::Record>>,\n    files: Mutex<recording::Files>,'),
 ('                stream: Mutex::new(None),','                stream: Mutex::new(None),\n                files: Mutex::new(recording::Files::default()),'),
 ('''    fn invoke_member(&mut self, _: u32, _: u32, _: u32) -> Result<u8, &'static str> {
        Err("configured native logger member has no attached dispatcher")
    }''','''    fn invoke_member(&mut self, owner: u32, member: u32, message: u32) -> Result<u8, &'static str> {
        if member==crate::audio_replay_recording_resource::MEMBER {
            return crate::audio_replay_recording_resource::message(self,owner,message)
                .map_err(|e|self.failure(e,"recording file message failed"));
        }
        Err("configured native logger member has no attached dispatcher")
    }''')])
edit('crates/core/src/lib.rs',[('pub mod audio_replay_stream_running;','pub mod audio_replay_stream_running;\npub mod audio_replay_recording_resource;')])
edit('crates/core/src/audio_replay_runtime_image.rs',[
 ('; 20] = [','; 21] = ['),('(1, 0x10d5fec, 48),','(1, 0x10d5fec, 48),\n    (1, 0x10d5f64, 12),')])
edit('tools/extract_replay_runtime_image.py',[(" ('stream_null_implementation_vtable',1,0x10d5fec,48),"," ('stream_null_implementation_vtable',1,0x10d5fec,48),\n ('logger_composite_callback_vtable',1,0x10d5f64,12),")])
edit('crates/core/src/audio_replay_windows_application.rs',[('mod opening_tests;','mod opening_tests;\n#[cfg(test)]\n#[path="audio_replay_windows_recording_tests.rs"]\nmod recording_tests;')])
print('Prepared host CRT file boundary and canonical runtime diagnostic integration')
