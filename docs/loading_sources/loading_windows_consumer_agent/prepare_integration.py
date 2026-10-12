from pathlib import Path
import difflib,json,hashlib
root=Path('E:/OpenLeague/crates/core/src');out=Path(__file__).resolve().parent
receive=(root/'audio_replay_windows_receive.rs').read_text()
old='''        _payload: u32,
    ) -> Result<(), &'static str> {
        Err(self.failure(
            (recipient, target),
            "native packet95 recipient is not connected",
        ))'''
new='''        payload: u32,
    ) -> Result<(), &'static str> {
        self.receive_loading_payload(recipient, target, payload)'''
assert receive.count(old)==1
after=receive.replace(old,new)
old='''        // These are the only connected listener consumers that read payload.'''
new='''        if event == 0x95 {
            self.preflight_loading_packet(packet)?;
        }
        // These are the connected owner-listener consumers that read payload.'''
assert after.count(old)==1
after=after.replace(old,new)
(out/'audio_replay_windows_receive.rs').write_text(after)
transport=(root/'audio_replay_windows_transport.rs').read_text()
needle='''#[path = "audio_replay_windows_receive.rs"]
mod receive;'''
replacement='''#[path = "audio_replay_windows_loading.rs"]
mod loading;
#[path = "audio_replay_windows_receive.rs"]
mod receive;'''
assert transport.count(needle)==1
transport_after=transport.replace(needle,replacement)
patch=''.join(difflib.unified_diff(receive.splitlines(True),after.splitlines(True),fromfile='a/crates/core/src/audio_replay_windows_receive.rs',tofile='b/crates/core/src/audio_replay_windows_receive.rs'))
patch+=''.join(difflib.unified_diff(transport.splitlines(True),transport_after.splitlines(True),fromfile='a/crates/core/src/audio_replay_windows_transport.rs',tofile='b/crates/core/src/audio_replay_windows_transport.rs'))
(out/'integration.patch').write_text(patch)
print(json.dumps({'patch_bytes':len(patch.encode()),'production_modified':False,'tests_executed':False}))
