from pathlib import Path
import shutil
S=Path(__file__).resolve().parent;P=S/'production';A=S.parent/'loading_windows_consumer_agent';R=Path('E:/OpenLeague')
src=P/'crates/core/src'
s=(A/'audio_replay_windows_loading.rs').read_text(encoding='utf-8').replace('audio_replay_windows_loading_tests.rs','audio_replay_windows_loading_packets_tests.rs')
(src/'audio_replay_windows_loading_packets.rs').write_text(s,encoding='utf-8')
shutil.copyfile(A/'audio_replay_windows_loading_tests.rs',src/'audio_replay_windows_loading_packets_tests.rs')
p=src/'audio_replay_windows_transport.rs';s=p.read_text(encoding='utf-8');anchor='#[path = "audio_replay_windows_receive.rs"]'
assert 'mod loading_packets;' not in s;s=s.replace(anchor,'#[path = "audio_replay_windows_loading_packets.rs"]\nmod loading_packets;\n'+anchor,1);p.write_text(s,encoding='utf-8')
s=(R/'crates/core/src/audio_replay_windows_receive.rs').read_text(encoding='utf-8')
old='''        _payload: u32,
    ) -> Result<(), &'static str> {
        Err(self.failure(
            (recipient, target),
            "native packet95 recipient is not connected",
        ))'''
new='''        payload: u32,
    ) -> Result<(), &'static str> {
        self.receive_loading_payload(recipient, target, payload)'''
assert s.count(old)==1;s=s.replace(old,new)
anchor='        // These are the only connected listener consumers that read payload.'
assert s.count(anchor)==1;s=s.replace(anchor,'''        if event == 0x95 {
            self.preflight_loading_packet(packet)?;
        }
        // These connected owner-listener consumers read payload.''')
(src/'audio_replay_windows_receive.rs').write_text(s,encoding='utf-8')
