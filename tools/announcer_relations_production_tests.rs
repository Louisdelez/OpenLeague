#[path="E:/OpenLeague/crates/core/src/audio_announcer_actor_tokens.rs"] mod audio_announcer_actor_tokens;
#[path="E:/OpenLeague/crates/core/src/audio_announcer_object_lookup.rs"] mod audio_announcer_object_lookup;
#[path="E:/OpenLeague/crates/core/src/audio_announcer_actor_wrapper.rs"] mod audio_announcer_actor_wrapper;
fn audio_test_fixture(relative:&str)->String {std::fs::read_to_string(std::path::Path::new("E:/OpenLeague").join(relative)).unwrap()}

#[path="E:/OpenLeague/crates/core/src/audio_announcer_actor_name.rs"] mod audio_announcer_actor_name;

#[path="E:/OpenLeague/crates/core/src/audio_announcer_name_provider.rs"] mod audio_announcer_name_provider;

#[path="E:/OpenLeague/crates/core/src/audio_announcer_name_encoding.rs"] mod audio_announcer_name_encoding;

#[path="E:/OpenLeague/crates/core/src/audio_announcer_champion_name.rs"] mod audio_announcer_champion_name;

#[path="E:/OpenLeague/crates/core/src/audio_announcer_relations.rs"] mod audio_announcer_relations;
