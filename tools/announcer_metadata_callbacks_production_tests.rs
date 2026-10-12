#[path="E:/OpenLeague/crates/core/src/audio_announcer_actor_tokens.rs"] mod audio_announcer_actor_tokens;
#[path="E:/OpenLeague/crates/core/src/audio_announcer_object_lookup.rs"] mod audio_announcer_object_lookup;
#[path="E:/OpenLeague/crates/core/src/audio_announcer_actor_wrapper.rs"] mod audio_announcer_actor_wrapper;
fn audio_test_fixture(relative:&str)->String {std::fs::read_to_string(std::path::Path::new("E:/OpenLeague").join(relative)).unwrap()}

#[path="E:/OpenLeague/crates/core/src/audio_announcer_actor_name.rs"] mod audio_announcer_actor_name;

#[path="E:/OpenLeague/crates/core/src/audio_announcer_name_provider.rs"] mod audio_announcer_name_provider;

#[path="E:/OpenLeague/crates/core/src/audio_announcer_name_encoding.rs"] mod audio_announcer_name_encoding;

#[path="E:/OpenLeague/crates/core/src/audio_announcer_champion_name.rs"] mod audio_announcer_champion_name;

#[path="E:/OpenLeague/crates/core/src/audio_announcer_relations.rs"] mod audio_announcer_relations;

#[path="E:/OpenLeague/crates/core/src/audio_announcer_team_colors.rs"] mod audio_announcer_team_colors;
#[path="E:/OpenLeague/crates/core/src/audio_announcer_labels.rs"] mod audio_announcer_labels;
#[path="E:/OpenLeague/crates/core/src/audio_announcer_kill_roles.rs"] mod audio_announcer_kill_roles;
#[path="E:/OpenLeague/crates/core/src/audio_announcer_icons.rs"] mod audio_announcer_icons;
#[path="E:/OpenLeague/crates/core/src/audio_announcer_palettes.rs"] mod audio_announcer_palettes;
#[path="E:/OpenLeague/crates/core/src/audio_announcer_styles.rs"] mod audio_announcer_styles;
#[path="E:/OpenLeague/crates/core/src/audio_announcer_color_streams.rs"] mod audio_announcer_color_streams;
#[path="E:/OpenLeague/crates/core/src/audio_announcer_rendered_styles.rs"] mod audio_announcer_rendered_styles;
#[path="E:/OpenLeague/crates/core/src/audio_announcer_integer_formats.rs"] mod audio_announcer_integer_formats;
#[path="E:/OpenLeague/crates/core/src/audio_announcer_plain_color_streams.rs"] mod audio_announcer_plain_color_streams;

#[path="E:/OpenLeague/crates/core/src/audio_announcer_num_put_writer.rs"] mod audio_announcer_num_put_writer;

#[path="E:/OpenLeague/crates/core/src/audio_announcer_ostream_integer.rs"] mod audio_announcer_ostream_integer;

#[path="E:/OpenLeague/crates/core/src/audio_announcer_bounty.rs"] mod audio_announcer_bounty;
#[path="E:/OpenLeague/crates/core/src/audio_announcer_value_fields.rs"] mod audio_announcer_value_fields;

#[path="E:/OpenLeague/crates/core/src/audio_announcer_team_tokens.rs"] mod audio_announcer_team_tokens;
#[path="E:/OpenLeague/crates/core/src/audio_announcer_ordered_formatter.rs"] mod audio_announcer_ordered_formatter;

#[path="E:/OpenLeague/crates/core/src/audio_announcer_outer_callbacks.rs"] mod audio_announcer_outer_callbacks;

#[path="E:/OpenLeague/crates/core/src/audio_announcer_registry_init.rs"] mod audio_announcer_registry_init;

#[path="E:/OpenLeague/crates/core/src/audio_announcer_registry_remove.rs"] mod audio_announcer_registry_remove;

#[path="E:/OpenLeague/crates/core/src/audio_announcer_registry_insert.rs"] mod audio_announcer_registry_insert;
#[path="E:/OpenLeague/crates/core/src/audio_announcer_actor_admission.rs"] mod audio_announcer_actor_admission;

#[path="E:/OpenLeague/crates/core/src/audio_announcer_actor_registration.rs"] mod audio_announcer_actor_registration;
#[path="E:/OpenLeague/crates/core/src/audio_announcer_secondary_registries.rs"] mod audio_announcer_secondary_registries;

#[path="E:/OpenLeague/crates/core/src/audio_announcer_registry_shutdown.rs"] mod audio_announcer_registry_shutdown;

#[path="E:/OpenLeague/crates/core/src/audio_announcer_actor_registry_composition.rs"] mod audio_announcer_actor_registry_composition;

#[path="E:/OpenLeague/crates/core/src/audio_announcer_secondary_unregister.rs"] mod audio_announcer_secondary_unregister;

#[path="E:/OpenLeague/crates/core/src/audio_announcer_owner_component_destructor.rs"] mod audio_announcer_owner_component_destructor;

#[path="E:/OpenLeague/crates/core/src/audio_announcer_owner_control.rs"] mod audio_announcer_owner_control;
#[path="E:/OpenLeague/crates/core/src/audio_announcer_owner_metadata.rs"] mod audio_announcer_owner_metadata;
#[path="E:/OpenLeague/crates/core/src/audio_announcer_metadata_callbacks.rs"] mod audio_announcer_metadata_callbacks;
