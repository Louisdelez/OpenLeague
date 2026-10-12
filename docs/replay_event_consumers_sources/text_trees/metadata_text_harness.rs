#[path="E:/OpenLeague/crates/core/src/audio_announcer_object_lookup.rs"] mod audio_announcer_object_lookup;
#[path="E:/OpenLeague/crates/core/src/audio_announcer_registry_init.rs"] mod audio_announcer_registry_init;
#[path="E:/OpenLeague/crates/core/src/audio_announcer_registry_remove.rs"] mod audio_announcer_registry_remove;
#[path="E:/OpenLeague/crates/core/src/audio_replay_metadata.rs"] mod audio_replay_metadata;
#[path="audio_replay_metadata_text.rs"] mod audio_replay_metadata_text;
fn audio_test_fixture(path:&str)->String{let file=std::path::Path::new(path).file_name().unwrap();let root=if file.to_string_lossy().starts_with("replay_metadata_text_"){"E:/mapslol3v3/replay_metadata_text_agent"}else{"E:/OpenLeague/data/4.20"};std::fs::read_to_string(std::path::Path::new(root).join(file)).unwrap()}
