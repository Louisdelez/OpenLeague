#![allow(dead_code)]
#[path="E:/OpenLeague/crates/core/src/audio_announcer_object_lookup.rs"] mod audio_announcer_object_lookup;
#[path="E:/OpenLeague/crates/core/src/audio_announcer_registry_init.rs"] mod audio_announcer_registry_init;
#[path="E:/OpenLeague/crates/core/src/audio_announcer_registry_remove.rs"] mod audio_announcer_registry_remove;
#[path="E:/OpenLeague/crates/core/src/audio_replay_metadata.rs"] mod audio_replay_metadata;
#[path="E:/mapslol3v3/loading_record_tree_agent/audio_loading_record_tree.rs"] mod audio_loading_record_tree;
#[path="audio_loading_screen_packet.rs"] mod audio_loading_screen_packet;
fn audio_test_fixture(path:&str)->String {
    let filename=std::path::Path::new(path).file_name().unwrap();
    for root in ["E:/mapslol3v3/loading_consumer_agent","E:/mapslol3v3/replay_loading_record_probe","E:/mapslol3v3/loading_record_tree_agent","E:/OpenLeague/data/4.20"] {
        let path=std::path::Path::new(root).join(filename);
        if path.exists() { return std::fs::read_to_string(path).unwrap(); }
    }
    panic!("missing fixture {path}")
}
