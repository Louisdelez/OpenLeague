from pathlib import Path
r=Path('E:/OpenLeague/crates/core/src');s=Path('E:/mapslol3v3')
t=(r/'audio_replay_windows_transport.rs').read_text(encoding='utf-8')
old='self.shared.diagnostics.is_some() || callback != logger::SHUTDOWN'
assert t.count(old)==1
t=t.replace(old,'self.shared.diagnostics.is_some() || ![logger::SHUTDOWN,crate::audio_replay_path_registry::SHUTDOWN].contains(&callback)')
(s/'audio_replay_windows_transport.rs').write_text(t,encoding='utf-8')
t=(r/'audio_replay_windows_recording_tests.rs').read_text(encoding='utf-8')
old='''            )
            .unwrap();
        assert_eq!(
            (
                p.open_code,'''
new='''            )
            .unwrap_or_else(|e|panic!("profile {profile}: {e}; backend {:?}",r.errors()));
        assert_eq!(
            (
                p.open_code,'''
assert t.count(old)==1
(s/'audio_replay_windows_recording_tests.rs').write_text(t.replace(old,new),encoding='utf-8')
