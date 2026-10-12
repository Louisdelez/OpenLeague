#[path="E:/OpenLeague/crates/core/src/audio_announcer_active_service.rs"] mod audio_announcer_active_service;
#[path="E:/OpenLeague/crates/core/src/audio_announcer_descriptor_insert.rs"] mod audio_announcer_descriptor_insert;
#[path="E:/OpenLeague/crates/core/src/audio_announcer_metadata_callbacks.rs"] mod audio_announcer_metadata_callbacks;
#[path="E:/OpenLeague/crates/core/src/audio_announcer_object_lookup.rs"] mod audio_announcer_object_lookup;
#[path="E:/OpenLeague/crates/core/src/audio_announcer_owner_metadata.rs"] mod audio_announcer_owner_metadata;
#[path="E:/OpenLeague/crates/core/src/audio_announcer_pending_service.rs"] mod audio_announcer_pending_service;
#[path="E:/OpenLeague/crates/core/src/audio_announcer_registry_init.rs"] mod audio_announcer_registry_init;
#[path="E:/OpenLeague/crates/core/src/audio_announcer_registry_insert.rs"] mod audio_announcer_registry_insert;
#[path="E:/OpenLeague/crates/core/src/audio_announcer_registry_remove.rs"] mod audio_announcer_registry_remove;
#[path="E:/OpenLeague/crates/core/src/audio_announcer_registry_shutdown.rs"] mod audio_announcer_registry_shutdown;
#[path="E:/OpenLeague/crates/core/src/audio_announcer_service_activation.rs"] mod audio_announcer_service_activation;
#[path="E:/OpenLeague/crates/core/src/audio_announcer_service_teardown.rs"] mod audio_announcer_service_teardown;
#[path="E:/mapslol3v3/replay_packet_agent/audio_replay_service_receive.rs"] mod audio_replay_service_receive;
fn audio_test_fixture(path:&str)->String{let file=std::path::Path::new(path).file_name().unwrap();let root=if file.to_string_lossy().starts_with("replay_service_packet_"){"E:/mapslol3v3/replay_packet_agent"}else{"E:/OpenLeague/data/4.20"};std::fs::read_to_string(std::path::Path::new(root).join(file)).unwrap()}
