from pathlib import Path
p=Path(__file__).resolve().parent
s=Path('E:/mapslol3v3/loading_owner_agent/loading_owner_harness.rs').read_text(encoding='utf-8')
s=s[:s.index('fn audio_test_fixture')]
s=s.replace('#[path="E:/mapslol3v3/replay_packet95_agent/audio_replay_packet95.rs"] mod audio_replay_packet95;','#[path="E:/OpenLeague/crates/core/src/audio_replay_packet95.rs"] mod audio_replay_packet95;')
s=s.replace('#[path="E:/mapslol3v3/loading_owner_agent/audio_replay_loading_owner.rs"] mod audio_replay_loading_owner;','#[path="E:/OpenLeague/crates/core/src/audio_replay_metadata.rs"] mod audio_replay_metadata;\n#[path="audio_loading_metadata.rs"] mod audio_loading_metadata;')
s+='fn audio_test_fixture(path:&str)->String {let n=std::path::Path::new(path).file_name().unwrap();let root=if n=="loading_metadata_probe.json"{"E:/mapslol3v3/loading_metadata_stage"}else{"E:/OpenLeague/data/4.20"};std::fs::read_to_string(std::path::Path::new(root).join(n)).unwrap()}\n'
(p/'harness.rs').write_text(s,encoding='utf-8')
