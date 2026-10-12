mod native_effect_clock;
#[cfg(windows)]
mod native_runtime_shutdown;
mod native_hud_recharge_live;
mod native_hud_recharge_line;
mod native_hud_recharge_line_gpu_probe;
mod native_hud_recharge_material;
mod native_hud_recharge_gpu_probe;
mod native_hud_bars;
mod native_hud_pool_numbers;
mod native_hud_live_probe;
mod native_hud_experience;
mod native_hud_spells;
mod native_hud_summoners;
mod native_hud_inventory;
mod native_minimap;
mod native_hud_ranks;
mod native_hud_learning;
#[allow(dead_code)] // Native recharge math/shader port; GPU bridge pending.
mod native_hud_recharge;
mod native_hud_cooldown_text;
mod native_hud_portraits;
mod native_hud_panels;
mod native_hud_icon_material;
#[allow(dead_code)] // Native Icon draw routing; GPU bridge pending.
mod native_hud_icon_draw;
#[allow(dead_code)] // Native Icon geometry qualified; GPU sprite bridge pending.
mod native_hud_icon_geometry;
mod native_hud_widgets;
mod native_hud_respawn;
mod native_hud_text_gpu_probe;
mod native_hud_text_render;
mod native_hud_text_batch;
mod native_font_material;
mod native_font_gpu;
mod native_font_metrics;
mod native_font_descriptor;
mod native_hud_font_creation;
mod native_hud_font_assets;
mod native_hud_font_configuration;
mod native_hud_normal_font;
mod native_hud_font_requests;
mod native_hud_texture_bindings;
mod native_hud_textures;
mod native_hud_viewport;
mod native_hud_group_bounds;
mod native_hud_scenes;
mod native_hud_groups;
#[allow(dead_code)] // Native Effect packet/render-state port; GPU transport pending.
mod native_hud_effect_packets;
mod native_hud_effect_uniforms;
mod native_hud_file_structure;
mod native_hud_record_population;
mod native_hud_uv_flips;
mod native_hud_named_element;
mod native_hud_remaining_properties;
mod native_hud_property_apply;
mod native_hud_string_properties;
mod native_hud_integer_properties;
mod native_hud_property_driver;
mod native_hud_record_header;
mod native_hud_element_storage;
mod native_hud_layout;
mod native_hud_property_text;
mod native_hud_anchor;
mod native_hud_uv;
mod native_hud_rect;
mod native_hud_atlases;
mod native_texture_filename;
mod native_zip_provider;
mod native_zip_archive;
mod native_zip_local_header;
mod native_archive_index;
mod native_filesystem_provider;
mod native_config_path_parts;
mod native_config_resource_dispatch;
mod native_config_cache_reload;
mod native_config_cache;
mod native_config_layout;
mod native_user_settings;
mod native_game_cfg_text;
mod native_replay_settings;
mod native_replay_service;
#[derive(bevy::prelude::Resource)]
struct NativeReplayService(native_replay_service::Service);
mod native_graphics_options;
mod native_fxaa_pass;
mod native_multisample;
#[allow(dead_code)] // Native profile port; runtime option binding pending.
mod native_fog_profile;
mod native_high_fog;
#[allow(dead_code)] // Native cloud phase qualified; full GPU fog binding pending.
mod native_cloud_phase;
mod native_gamma;
mod nexus_ceremony;
mod endgame_timeline;
mod native_endgame_ui;
mod match_results_ui;
mod session_departure;
mod session_client;
mod session_bootstrap;
mod session_connection;
mod structure_animation_clock;
mod grass_live_registry;
mod grass_model_bounds;
#[allow(dead_code)]
mod grass_spatial_extents;
#[allow(dead_code)]
mod grass_spatial_chain;
#[allow(dead_code)]
mod grass_parent;
#[allow(dead_code)]
mod grass_insertion;
#[allow(dead_code)]
mod grass_subdivision;
#[allow(dead_code)]
mod grass_pool;
#[allow(dead_code)]
mod grass_tree_service;
#[allow(dead_code)]
mod grass_object_registry;
#[allow(dead_code)]
mod grass_spatial_bounds;
#[allow(dead_code)]
mod grass_spatial_dispatch;
#[allow(dead_code)]
mod grass_actor_aabb;
#[allow(dead_code)]
mod grass_actor_subclasses;
#[allow(dead_code)]
mod grass_actor_visibility;
#[allow(dead_code)]
mod grass_actor_cache;
#[allow(dead_code)] // Native grass prefix; full material state/order and winding bridge pending.
mod grass_pass_state;
#[allow(dead_code)] // Native target/camera integration remains pending.
mod grass_screen_matrix;
#[allow(dead_code)]
mod grass_target_viewport;
#[allow(dead_code)]
mod grass_buffers;
#[allow(dead_code)]
mod grass_constants;
#[allow(dead_code)] // Registry/actor semantics and live camera remain pending.
mod grass_sources;
#[allow(dead_code)] // Native grass quad constants; texture/driver producers and GPU binding pending.
mod grass_quad;
#[allow(dead_code)] // Native projection consumer; actual camera/viewport producers and live mask pending.
mod grass_projection;
#[allow(dead_code)] // Native rectangle consumer qualified; camera, mask producer and live actor gates pending.
mod grass_rectangle;
mod actor_fow;
mod material_selection;
mod garen_w_state;
mod garen_w_profile;
mod garen_w_material_host;
mod garen_w_live;
mod garen_w_slice_material;
mod garen_w_slice_host;
mod garen_w_slice_live;
mod garen_w_slice_readiness;
mod garen_w_probe;
mod fow_gpu;
mod map10_native_config;
#[allow(dead_code)] // Native provider lookup qualified; filesystem/archive table population pending.
mod map_resource_provider;
#[allow(dead_code)] // Native settings reader consumer qualified; path selection/GPU binding pending.
mod fow_settings;
mod fow_visibility_texture;
mod fow_champion_sources;
#[allow(dead_code)] // Original resource geometry catalog; runtime source binding pending.
mod fow_character_geometry;
#[allow(dead_code)] // Resource/geometry initialization contract; live loader pending.
mod fow_actor_metrics;
#[allow(dead_code)] // Startup view initialized; source/server/GPU binding pending.
mod map10_vision_view;
#[allow(dead_code)] // Native extent producer qualified; live activation pending.
mod fow_level_bounds;
mod fow_view_registry;
mod fow_view_state;
mod fow_player_filter;
mod fow_spectator_filter;
mod fow_registered_filter;
mod fow_entity_registry;
mod fow_schedule;
mod fow_pending;
mod fow_source_factory;
mod fow_lifecycle;
mod fow_position;
mod fow_source_update;
mod fow_owner;
#[allow(dead_code)]
mod fow_occluded;
#[allow(dead_code)]
mod fow_radial_fan;
#[allow(dead_code)]
mod fow_terrain_ray;
#[allow(dead_code)]
mod fow_ray_clip;
#[allow(dead_code)]
mod fow_shapes;
#[allow(dead_code)]
mod fow_timing;
#[allow(dead_code)]
mod fow_upscale;
#[allow(dead_code)]
mod fow_postprocess;
#[allow(dead_code)]
mod fow_regions;
#[allow(dead_code)]
mod native_fow;
#[allow(dead_code)] // General routing qualified; only base projection bound.
mod particle_render_state;
mod projected_live;
mod projected_pipeline_probe;
mod projected_warmup;
mod projected_pixel_pair;
#[allow(dead_code)] // Native input preparation; normal render binding remains open.
mod projected_inputs;
#[allow(dead_code)] // Native single particle lifecycle; owner-end/pose binding pending.
mod simple_cycle;
mod native_projected_cycle;
#[allow(dead_code)]
mod simple_system;
#[allow(dead_code)]
mod effect_owner;
#[allow(dead_code)]
mod simple_owner_pose;
#[allow(dead_code)] // Native attachment consumers; upstream pose and ordering pending.
mod simple_attachment;
#[allow(dead_code)] // Native gate/count contract; birth and attachment pending.
mod simple_emission;
#[allow(dead_code)] // Native config prepared; emitter lifecycle binding pending.
mod native_particle_class;
mod simple_projected_config;
mod projected_render;
#[allow(dead_code)] // Surface preparation precedes the live projected particle consumer.
mod projected_terrain;
#[allow(dead_code)] // Native UV/terrain preparation; emitter constant producer and GPU consumer pending.
mod projected_surface;
mod annie_q_vfx;
mod annie_ready;
mod entity_orientation;
mod camera_native;
mod camera_projection_bridge;
mod ordinary_camera_input;
mod animation;
mod nexus_idle_particles;
mod nexus_complex_mesh;
mod nexus_complex_material;
mod nexus_complex_host;
mod nexus_complex_live;
mod nexus_crown_state;
mod nexus_crown_live;
mod nexus_glow_state;
mod nexus_glow_simple;
mod nexus_glow_live;
mod nexus_glow_quad;
mod nexus_glow_material;
mod attack_animation;
mod vilemaw_attack_animation;
mod health;
mod map_ambient;
mod map_coordinates;
mod map_coordinates_probe;
mod map_audio;
mod map_relic_world;
mod pcm_audio;
mod map_audio_requests;
mod map_events;
mod map_fog;
mod picking;
mod render_probe;
mod window_surface_lifecycle;
mod shop_ui;
mod spell_input;
mod terrain_material;
mod environment_render_config;
mod native_environment_draw;
mod selector7_depth;
mod native_alpha;
use bevy::{
    core_pipeline::tonemapping::Tonemapping, gltf::GltfAssetLabel, prelude::*,
    world_serialization::WorldAssetRoot,
};
use openleague_core::{Action, Point, Snapshot};
use std::{collections::HashMap, net::UdpSocket, time::Instant};
#[derive(Resource)]
struct Connection {
    socket: UdpSocket,
    link: session_connection::Link,
    id: Option<u32>,
    session: Option<u64>,
    sequence: u64,
    last_join: Instant,
    champion: String,
    summoners: [Option<openleague_core::summoners::Spell>; 2],
    rejection: String,
    assembler: openleague_core::wire::StateAssembler,
    welcome_history: openleague_core::welcome_history::WelcomeHistory,
}
#[derive(Resource, Default)]
struct Match {
    snapshot: Option<Snapshot>,
    missile_journal: openleague_core::missile_lifecycle::Journal,
    attack_visuals: attack_animation::State,
    vilemaw_visuals: vilemaw_attack_animation::State,
    w_visuals: garen_w_live::Visuals,
    missile_contexts: Vec<Snapshot>,
    visuals: HashMap<u32, Entity>,
    destroyed_structures: HashMap<u32, bool>,
}
#[derive(Resource)]
struct MapHandle(Handle<Gltf>);
#[derive(Resource)]
struct CameraFocus(Vec3);
#[derive(Component)]
struct PlayerLabel;
fn main() -> bevy::app::AppExit {
    let mut exit = bevy::app::AppExit::Success;
    run_client(&mut exit);
    exit
}

fn run_client(exit: &mut bevy::app::AppExit) {
    if std::env::args().any(|a|a=="--native-hud-recharge-line-gpu-probe") {native_hud_recharge_line_gpu_probe::run();return}
    if std::env::args().any(|a|a=="--native-hud-recharge-gpu-probe") {native_hud_recharge_gpu_probe::run();return}
    if std::env::args().any(|a|a=="--native-hud-text-gpu-probe") {native_hud_text_gpu_probe::run();return}

    let root = std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");
    let arguments:Vec<String>=std::env::args().collect();
    if let Some(index) = arguments.iter().position(|a| a == "--native-process-clock-probe") {
        #[cfg(windows)] {
            let probe_root = arguments.get(index + 1).map(std::path::PathBuf::from)
                .unwrap_or_else(|| root.clone());
            native_process_clock_probe(&probe_root);
            return;
        }
        #[cfg(not(windows))]
        panic!("Native process clock requires Windows");
    }

    if let Some(index)=arguments.iter().position(|a|a=="--native-replay-events-probe") {
        #[cfg(windows)] {let probe_root=arguments.get(index+1).map(std::path::PathBuf::from).unwrap_or_else(||root.clone());native_replay_events_probe(&probe_root);return;}
        #[cfg(not(windows))] panic!("Native replay event runtime requires Windows");
    }
    if let Some(index)=arguments.iter().position(|a|a=="--native-replay-game-manager-probe") {
        #[cfg(windows)] {let probe_root=arguments.get(index+1).map(std::path::PathBuf::from).unwrap_or_else(||root.clone());native_replay_game_manager_probe(&probe_root);return;}
        #[cfg(not(windows))] panic!("Native replay game manager requires Windows");
    }
    if let Some(index)=arguments.iter().position(|a|a=="--native-replay-recording-stream-probe") {
        #[cfg(windows)] {let probe_root=arguments.get(index+1).map(std::path::PathBuf::from).unwrap_or_else(||root.clone());native_replay_recording_stream_probe(&probe_root);return;}
        #[cfg(not(windows))] panic!("Native stream file requires Windows");
    }
    if let Some(index)=arguments.iter().position(|a|a=="--native-replay-recording-file-probe") {
        #[cfg(windows)] {
            let probe_root=arguments.get(index+1).map(std::path::PathBuf::from).unwrap_or_else(||root.clone());
            native_replay_recording_file_probe(&probe_root);return;
        }
        #[cfg(not(windows))] panic!("Native diagnostic file requires Windows");
    }
    if let Some(index)=arguments.iter().position(|a|a=="--native-replay-stream-running-probe") {
        #[cfg(windows)] {
            let probe_root=arguments.get(index+1).map(std::path::PathBuf::from).unwrap_or_else(||root.clone());
            native_replay_stream_running_probe(&probe_root);return;
        }
        #[cfg(not(windows))] panic!("Native replay stream running requires Windows");
    }
    if let Some(index)=arguments.iter().position(|a|a=="--native-replay-stream-opening-probe") {
        #[cfg(windows)] {
            let probe_root=arguments.get(index+1).map(std::path::PathBuf::from).unwrap_or_else(||root.clone());
            native_replay_stream_opening_probe(&probe_root);return;
        }
        #[cfg(not(windows))] panic!("Native replay stream opening requires Windows");
    }
    if let Some(index)=arguments.iter().position(|a|a=="--native-replay-stream-transport-probe") {
        #[cfg(windows)] {
            let probe_root=arguments.get(index+1).map(std::path::PathBuf::from).unwrap_or_else(||root.clone());
            native_replay_stream_transport_probe(&probe_root);
            return;
        }
        #[cfg(not(windows))] panic!("Native replay stream transport requires Windows");
    }
    if let Some(index)=arguments.iter().position(|a|a=="--native-replay-configuration-probe") {
        #[cfg(windows)] {
            let probe_root=arguments.get(index+1).map(std::path::PathBuf::from).unwrap_or_else(||root.clone());
            native_replay_configuration_probe(&probe_root);
            return;
        }
        #[cfg(not(windows))] panic!("Native replay configuration requires Windows");
    }
    if let Some(index)=arguments.iter().position(|a|a=="--native-replay-runtime-probe") {
        #[cfg(windows)] {
            let probe_root=arguments.get(index+1).map(std::path::PathBuf::from).unwrap_or_else(||root.clone());
            native_replay_runtime_probe(&probe_root);
            return;
        }
        #[cfg(not(windows))] panic!("Native replay Windows runtime requires Windows");
    }

    if let Some(index)=arguments.iter().position(|a|a=="--native-replay-service-probe") {
        let probe_root=arguments.get(index+1).map(std::path::PathBuf::from).unwrap_or_else(||root.clone());
        let loaded=native_user_settings::load(&probe_root).expect("load replay probe configuration");
        let mut replay=native_replay_service::Service::new(loaded.replay.clone()).expect("construct configured replay service");
        let state=replay.diagnostic().expect("read replay service state");
        replay.close().expect("release replay service");
        println!("{}",serde_json::json!({"replay_service":state,"default_path":loaded.default_path,"user_path":loaded.user_path,"default_loaded":loaded.default_loaded,"user_loaded":loaded.user_loaded,"live_allocations_after_close":replay.live_allocations()}));
        return;
    }

    let mut zip_resources=native_zip_provider::Provider::from_catalog(&root).expect("mount native ZIP resource catalog");
    let native_hud=zip_resources.startup_hud(&root).expect("load original HUD ZIP configuration");
    eprintln!("Native ZIP archives={} entries={} unique_names={} FastHUD_bytes={} Chat_bytes={}",zip_resources.archive_count(),zip_resources.entry_count,zip_resources.unique_names,native_hud.fast_hud.len(),native_hud.chat.len());
    eprintln!("Native HUD structural files={} accepted={} rejected={} repaired={} resource_binding=false drawing=false",native_hud.shadow_isles_layouts.len(),native_hud.shadow_isles_layouts.iter().map(|l|l.structure.accepted.len()).sum::<usize>(),native_hud.shadow_isles_layouts.iter().map(|l|l.structure.rejected.len()).sum::<usize>(),native_hud.shadow_isles_layouts.iter().filter(|l|l.restoration.is_some()).count());
    eprintln!("Native HUD textures={} descriptors_pending={} gpu_handles_resolved=false drawing=false",native_hud.shadow_isles_textures.entries.len(),native_hud.shadow_isles_textures.entries.len());
    eprintln!("Native HUD font source locale={} path={} requests={} font_gpu=false widgets=false",native_hud.shadow_isles_font_configuration.locale,native_hud.shadow_isles_font_configuration.path,native_hud.source_font_requests().expect("source HUD font requests").len());
    eprintln!("Native HUD groups={} bound={} unbound={} cache_clock_producer=false drawing=false",native_hud.shadow_isles_groups.groups.len(),native_hud.shadow_isles_layouts.iter().flat_map(|l|&l.bindings).filter(|b|b.group.is_some()).count(),native_hud.shadow_isles_layouts.iter().flat_map(|l|&l.bindings).filter(|b|b.group.is_none()).count());
    for layout in &native_hud.shadow_isles_layouts {if let Some(path)=&layout.restoration {eprintln!("Native HUD reconstructed overlay request={} selected={} provenance=reconstructed_from_source_patterns",layout.request,path);}}
    let settings=native_user_settings::load_using(&root,|path|zip_resources.read_optional(&root,path)).expect("load native Game.cfg configuration");
    let mut replay=native_replay_service::Service::new(settings.replay.clone()).expect("construct native replay service");
    eprintln!("Native replay service configured {}",replay.diagnostic().expect("read native replay service configuration"));
    eprintln!("Game.cfg layout_mode={} layout_scores={:?}",settings.layout_mode,settings.layout_scores);
    let mut quality=native_environment_draw::Quality::default();
    quality.apply(settings.options.read(native_graphics_options::ENVIRONMENT_ID).value);
    eprintln!("Game.cfg defaults={} user={} loaded={} parser_warnings={} environment_quality={}",settings.default_path.display(),settings.user_path.display(),settings.user_loaded,settings.parse_warnings,quality.value);
    eprintln!("Game.cfg text_loaded={} defaults_loaded={} merged_entries={}",settings.text_loaded,settings.default_loaded,settings.text.entries.len());
    let champion=std::env::var("OPENLEAGUE_CHAMPION").unwrap_or_else(|_|"garen".into());
    let summoners=serde_json::from_str(&std::env::var("OPENLEAGUE_SUMMONERS").unwrap_or_else(|_|"[null,null]".into()))
        .expect("valid summoner loadout");
    // Only the owned launcher's private stdin carries session capabilities.
    // An invalid opted-in bootstrap is an error, never permission for legacy Join.
    let session_client=match session_bootstrap::read_from_environment()
        .and_then(|bootstrap|bootstrap.map(|b|b.into_client(champion.clone(),summoners)).transpose()) {
        Ok(client)=>client,
        Err(error)=>{eprintln!("Session bootstrap failed: {error}");*exit=bevy::app::AppExit::error();return;}
    };
    let socket = UdpSocket::bind("127.0.0.1:0").unwrap();
    socket
        .connect(std::env::var("OPENLEAGUE_SERVER").unwrap_or_else(|_| "127.0.0.1:5896".into()))
        .unwrap();
    if session_client.is_some() && socket.peer_addr().map_err(|_|"Session endpoint unavailable")
        .and_then(session_connection::validate_endpoint).is_err() {
        eprintln!("Private session endpoint rejected");*exit=bevy::app::AppExit::error();return;
    }
    socket.set_nonblocking(true).unwrap();
    let mut app=App::new();
    app.insert_resource(NativeReplayService(replay));
    #[cfg(windows)]
    let shutdown = match attach_native_replay_runtime(&mut app)
        .and_then(|_| native_runtime_shutdown::install(&mut app)) {
        Ok(shutdown) => shutdown,
        Err(error) => {
            eprintln!("Native replay initialization failed: {error}");
            *exit = bevy::app::AppExit::error();
            return; // The owned App and partial native resources still Drop.
        }
    };
    *exit = app.insert_resource(zip_resources)
        .insert_resource(native_hud)
        .add_plugins(
            DefaultPlugins
                .set(AssetPlugin {
                    file_path: root.join("assets").to_string_lossy().into_owned(),
                    ..default()
                })
                .set(WindowPlugin {
                    primary_window: Some(Window {
                        title: "OpenLeague - developpement 4.20".into(),
                        resolution: (1280, 800).into(),
                        ..default()
                    }),
                    ..default()
                }),
        )
        .add_plugins(pcm_audio::Plugin)
        .add_plugins(native_effect_clock::Plugin)
        .add_plugins(window_surface_lifecycle::Plugin)
        .add_plugins(fow_gpu::Plugin)
        .add_plugins(garen_w_live::Plugin)
        .add_plugins(garen_w_slice_live::Plugin)
        .add_plugins(nexus_idle_particles::Plugin)
        .add_plugins(nexus_complex_live::Plugin)
        .add_plugins(nexus_crown_live::Plugin)
        .add_plugins(nexus_glow_live::Plugin)
        .add_plugins(native_hud_atlases::Plugin)
        .add_plugins(native_hud_viewport::Plugin)
        .add_plugins(native_hud_font_assets::Plugin)
        .add_plugins(native_hud_font_creation::Plugin)
        .add_plugins(native_font_metrics::Plugin)
        .add_plugins(native_font_gpu::Plugin)
        .add_plugins(native_hud_widgets::Plugin)
        .add_plugins(native_hud_respawn::Plugin)
        .add_plugins(native_hud_inventory::Plugin)
        .add_plugins(native_minimap::Plugin)
        .add_plugins(map_relic_world::Plugin)
        .add_plugins(spell_input::Plugin)
        .add_plugins(ordinary_camera_input::Plugin)
        .add_plugins(native_hud_live_probe::Plugin)
        .add_plugins(native_hud_panels::Plugin)
        .add_plugins(native_hud_recharge_live::Plugin)
        .add_plugins(native_hud_portraits::Plugin)
        .add_plugins(native_hud_bars::Plugin)
        .add_plugins((native_hud_experience::Plugin, native_hud_spells::Plugin, native_hud_ranks::Plugin, native_hud_learning::Plugin))
        .add_plugins(bevy::core_pipeline::fullscreen_material::FullscreenMaterialPlugin::<native_gamma::Map10Gamma>::default())
        .add_plugins(MaterialPlugin::<terrain_material::TerrainMaterial>::default())
        .add_plugins(MaterialPlugin::<map_fog::FogMaterial>::default())
        .add_plugins(MaterialPlugin::<annie_q_vfx::QMaterial>::default())
        .add_plugins(MaterialPlugin::<annie_ready::ReadyMaterial>::default())
        .add_plugins(annie_ready::phase_order::Plugin)
        .add_plugins(MaterialPlugin::<projected_render::ProjectedMaterial>::default())
        .add_plugins(projected_pipeline_probe::Plugin)
        .add_plugins(projected_warmup::Plugin)
        .add_plugins(projected_pixel_pair::Plugin)
        .add_systems(Startup, projected_render::preload)
        .insert_resource(Connection {
            socket,
            link: session_connection::Link::new(session_client),
            id: None,
            session: None,
            sequence: 0,
            last_join: Instant::now() - std::time::Duration::from_secs(2),
            rejection: String::new(),
            assembler: Default::default(),
            welcome_history: Default::default(),
            champion,
            summoners,
        })
        .init_resource::<Match>().init_resource::<camera_native::EndPan>()
        .init_resource::<native_endgame_ui::View>()
        .init_resource::<endgame_timeline::Clock>()
        .init_resource::<grass_live_registry::Live>()
        .init_resource::<map_resource_provider::Map10Catalog>()
        .init_resource::<fow_champion_sources::Sources>()
        .init_resource::<annie_q_vfx::Flights>()
        .init_resource::<annie_q_vfx::VisibilityProbe>()
        .init_resource::<annie_ready::Ready>()
        .init_resource::<annie_ready::Probe>()
        .init_resource::<picking::Terrain>()
        .init_resource::<shop_ui::Filters>()
        .init_resource::<animation::Catalog>()
        .init_resource::<map_ambient::Catalog>()
        .init_resource::<map_ambient::Probe>()
        .add_systems(PostUpdate, map_coordinates_probe::observe
            .after(bevy::transform::TransformSystems::Propagate)
            .after(bevy::camera::visibility::VisibilitySystems::VisibilityPropagate)
            .after(bevy::camera::visibility::VisibilitySystems::MarkNewlyHiddenEntitiesInvisible)
            .after(bevy::camera::CameraUpdateSystems))
        .init_resource::<map_events::Queue>()
        .init_resource::<map_events::Trace>()
        .init_resource::<map_audio::NativeListener>()
        .init_resource::<map_audio::AmbientPositions>()
        .init_resource::<map_audio_requests::AmbientRequests>()
        .init_resource::<map_audio_requests::AmbientRandom>()
        .insert_resource(CameraFocus(Vec3::new(370., 5., 385.)))
        .init_resource::<camera_native::NativeCamera>()
        .init_resource::<projected_terrain::TerrainSurfaces>()
        .init_resource::<projected_render::Probe>()
        .init_resource::<projected_live::Live>()
        .init_resource::<actor_fow::Cache>()
        .init_resource::<map_fog::Cache>()
        .init_resource::<native_high_fog::CloudState>()
        .add_systems(Update,native_high_fog::advance.after(map_fog::bind).after(terrain_material::bind).before(render_probe::capture))
        .init_resource::<environment_render_config::State>()
        .insert_resource(quality).insert_resource(settings)
        .init_resource::<selector7_depth::Cache>()
        .add_systems(
            Startup,
            (
                setup,
                shop_ui::setup,
                match_results_ui::setup,
                native_endgame_ui::setup,
                terrain_material::setup,
                map_fog::setup,
                fow_visibility_texture::setup,
                map_ambient::setup,
            ),
        )
        .add_systems(
            Update,
            (
                terrain_material::bind,
                map_fog::bind,
                map_fog::dump_probe,
                receive,
                shop_ui::update,
                commands,
                camera.after(annie_q_vfx::update),
                map_audio::listener_position,
                map_audio::listener_probe,
                labels,

                map_audio::update,
                map_audio::altar_events,
                map_ambient::hide_embedded,
                map_ambient::load_models,
                map_ambient::probe,
                animation::load_models,
                animation::animate,
                render_probe::capture,
                render_probe::window_options,
            )
                .chain(),
        )
        .add_systems(Update, endgame_timeline::update.after(receive).before(camera).before(native_endgame_ui::update))
        .add_systems(Update, nexus_ceremony::update.after(endgame_timeline::update).before(animation::load_models).before(animation::animate))
        .add_systems(Update, nexus_ceremony::probe.after(nexus_ceremony::update).after(animation::load_models).before(render_probe::capture))
        .add_systems(Update, native_endgame_ui::update.after(receive).before(match_results_ui::update))
        .add_systems(Update, native_endgame_ui::phase_probe.after(native_endgame_ui::update).after(camera).before(render_probe::capture))
        .add_systems(Update, match_results_ui::update.after(receive).before(render_probe::capture))
        .add_systems(Update, session_departure::return_button.after(native_endgame_ui::update).before(render_probe::capture))
        .add_systems(Last, session_departure::on_exit.after(bevy::window::ExitSystems))
        .add_systems(Update, actor_fow::bind.after(animation::load_models).after(map_ambient::load_models).after(map_fog::bind).before(fow_visibility_texture::bind_materials))
        .add_systems(Update, actor_fow::probe.after(fow_visibility_texture::bind_materials).before(render_probe::capture))
        .add_systems(Update, selector7_depth::synchronize.after(map_fog::bind).before(fow_visibility_texture::bind_materials))
        .add_systems(Update, selector7_depth::probe.after(fow_visibility_texture::bind_materials).before(render_probe::capture))
        .add_systems(Update, map_fog::probe_lifecycle.after(fow_visibility_texture::bind_materials).before(render_probe::capture))
        .add_systems(PostUpdate, animation::synchronize_finished_structure_clocks.after(bevy::animation::advance_animations).before(bevy::animation::animate_targets))
        .add_systems(PostUpdate, animation::destruction_probe.after(bevy::animation::animate_targets))
        .add_systems(PostUpdate, animation::garen_attack_probe.after(bevy::animation::animate_targets))
        .add_systems(PostUpdate, animation::vilemaw_probe::observe.after(bevy::app::AnimationSystems))
        .add_systems(Update, grass_live_registry::update.after(receive).after(animation::load_models).before(render_probe::capture))
        .add_systems(Update, fow_champion_sources::update.after(receive).before(render_probe::capture))
        .add_systems(Update, fow_visibility_texture::update.after(fow_champion_sources::update).before(render_probe::capture))
        .add_systems(Update, fow_visibility_texture::bind_materials.after(fow_visibility_texture::update).after(map_fog::bind).after(actor_fow::bind).after(terrain_material::bind).after(projected_live::update).after(projected_render::probe).before(render_probe::capture))
        .add_systems(Update, annie_ready::update.after(receive).before(render_probe::capture))
        .add_systems(PostUpdate, annie_ready::live_probe::observe.after(bevy::camera::visibility::VisibilitySystems::CheckVisibility))
        .add_systems(Update, annie_q_vfx::update.after(receive).before(render_probe::capture))
        .add_systems(PostUpdate, health::update.after(bevy::camera::CameraUpdateSystems).before(bevy::ui::UiSystems::Prepare))
        .add_systems(Update, projected_live::update.after(annie_q_vfx::update).after(camera).before(render_probe::capture))
        .add_systems(Update, projected_render::probe.after(receive).before(render_probe::capture))
        .add_systems(
            PostUpdate,
            (
                projected_terrain::collect.after(bevy::transform::TransformSystems::Propagate),
                projected_terrain::probe.after(projected_terrain::collect),
                projected_live::visibility_probe.after(projected_live::update).after(bevy::camera::visibility::VisibilitySystems::CheckVisibility),
                annie_q_vfx::visibility_probe.after(annie_q_vfx::update).after(bevy::camera::visibility::VisibilitySystems::CheckVisibility),
                map_events::dispatch.before(bevy::animation::advance_animations),
                map_audio::ambient_cues.after(map_events::dispatch),
                map_audio::ambient_positions.after(map_audio::ambient_cues)
                    .after(bevy::transform::TransformSystems::Propagate),
                map_audio::emitter_probe.after(map_audio::ambient_positions),
                map_audio_requests::update.after(map_audio::ambient_positions),
            ),
        )
        .run();
    #[cfg(windows)]
    { *exit = shutdown.finish(exit.clone()); }
}
fn setup(mut commands: Commands, assets: Res<AssetServer>, focus: Res<CameraFocus>, settings: Res<native_user_settings::Loaded>, mut native_camera: ResMut<camera_native::NativeCamera>) {
    // Native Map10 fog RGB replaces the engine's unrelated gray background.
    // Full historical fog and the association of clear color with fog remain reconstructed.
    let visual: serde_json::Value =
        serde_json::from_str(include_str!("../../../data/4.20/map_visual_settings.json"))
            .expect("native Map10 visual settings");
    let rgb = visual["native_fog_rgb"].as_array().expect("native fog RGB");
    commands.insert_resource(ClearColor(Color::srgb(
        rgb[0].as_u64().unwrap() as f32 / 255.,
        rgb[1].as_u64().unwrap() as f32 / 255.,
        rgb[2].as_u64().unwrap() as f32 / 255.,
    )));
    let native_view = map10_vision_view::Map10VisionView::native_map10().expect("native Map10 view geometry");
    commands.insert_resource(native_view);
    commands.insert_resource(MapHandle(assets.load("maps/twisted_treeline.glb")));
    commands.spawn((
        WorldAssetRoot(
            assets.load(GltfAssetLabel::Scene(0).from_asset("maps/twisted_treeline.glb")),
        ),
        map_coordinates::MapRoot,
        map_coordinates::map_root_transform(),
    ));
    let (camera_transform, camera_projection, _) = native_camera.pose(focus.0, 0., 0.).expect("native Map10 camera");
    commands.spawn((
        Camera3d::default(),
        Camera { invert_culling: true, ..default() },
        camera_projection,
        if std::env::var_os("OPENLEAGUE_SCREENSHOT").is_some()
            && std::env::var("OPENLEAGUE_PROBE_NO_MSAA").as_deref() == Ok("1")
        {
            Msaa::Off
        } else {
            let (option,samples)=native_multisample::configured(&settings.text);
            eprintln!("Native General/Antialiasing={} MSAA_samples={} quality=0",option,samples);
            match samples {2=>Msaa::Sample2,4=>Msaa::Sample4,_=>Msaa::Off}
        },
        Tonemapping::None,
        native_gamma::Map10Gamma::native_map10(),
        camera_transform,
    ));
    commands.spawn((
        Text::new("OpenLeague : connexion..."),
        TextFont {
            font: FontSource::Handle(assets.load("fonts/DejaVuSans.ttf")),
            font_size: FontSize::Px(14.),
            ..default()
        },
        BackgroundColor(Color::srgba(0.02, 0.03, 0.05, 0.85)),
        Node {
            position_type: PositionType::Absolute,
            left: Val::Px(18.),
            bottom: Val::Px(12.),
            display: Display::None,
            max_width: Val::Percent(95.),
            padding: UiRect::all(Val::Px(8.)),
            ..default()
        },
        PlayerLabel,
    ));
}
fn receive(
    mut connection: ResMut<Connection>,
    mut state: ResMut<Match>,
    mut commands: Commands,
    assets: Res<AssetServer>,
    mut transforms: Query<&mut Transform>,
    mut focus: ResMut<CameraFocus>,
    catalog: Res<animation::Catalog>,
    clock: Res<endgame_timeline::Clock>,
    time: Res<Time>,
    mut effect_clock: ResMut<native_effect_clock::EffectClock>,
) {
    connection.maintain_session();
    let mut buffer = [0u8; 16384];
    let mut waiting=std::collections::VecDeque::new();
    let mut received=0;
    loop {
        // Do not coalesce same-tick frames: each has visibility/lifecycle facts.
        if waiting.is_empty() {waiting.extend(connection.take_ready_states());}
        let packet=if let Some(packet)=waiting.pop_front() {packet} else {
            if received>=512 {break;}
            let n=match connection.socket.recv(&mut buffer) {
                Ok(n)=>n,
                Err(error) if error.kind()==std::io::ErrorKind::WouldBlock=>break,
                Err(_)=>{connection.network_interrupted();break;}
            };
            received+=1;
            match connection.decode_datagram(&buffer[..n]) {
                Ok(Some(packet))=>packet,Ok(None)=>continue,
                Err(error)=>{connection.report(error);continue;}
            }
        };
        match packet {
            session_connection::Incoming::Welcome { player, session, epoch } => {
                if epoch.is_none() && !connection.welcome_history.accept(session, player) {
                    warn!("Ignored retired welcome identity: session={session} player={player}");
                    continue;
                }
                if connection.session != Some(session) || connection.id != Some(player) {
                    for (_, entity) in state.visuals.drain() {
                        commands.entity(entity).despawn();
                    }
                    state.destroyed_structures.clear();
                    state.snapshot = None;
                    state.missile_journal.reset(session);
                    state.attack_visuals.reset(session);
                    state.vilemaw_visuals.reset(session);
                    state.w_visuals.reset(session);
                    state.missile_contexts.clear();
                    if epoch.is_none() {effect_clock.reset_session();}
                    connection.sequence = 0;
                    connection.assembler.reset();
                    connection.rejection.clear();
                }
                connection.id = Some(player);
                connection.session = Some(session);
                if let Some(context)=epoch {
                    if garen_w_live::begin_presentation_epoch(&mut state,session,context.epoch)!=Ok(true) {
                        connection.fail_session("Presentation epoch could not be established");break;
                    }
                    effect_clock.reset_session();
                }
                connection.rejection.clear();
            }
            session_connection::Incoming::State { snapshot, delivery } => {
                if connection.session != Some(snapshot.session) {
                    continue;
                }
                if state
                    .snapshot
                    .as_ref()
                    .is_some_and(|old| if delivery.is_some() {old.tick > snapshot.tick} else {old.tick >= snapshot.tick})
                {
                    continue;
                }
                if let Err(error) = openleague_core::entity_facing::validate_snapshot(&snapshot) {
                    warn!("Entity facing snapshot rejected: {error}");
                    continue;
                }
                // Preserve every accepted transition before latest-state coalescing.
                // Context belongs to that exact tick, never the final receive batch.
                let has_missile_context = !snapshot.spell_projectiles.is_empty()
                    || state.snapshot.as_ref().is_some_and(|old| !old.spell_projectiles.is_empty());
                // Validate Attack and W before the missile journal commits, for
                // every accepted packet including intermediate visibility loss.
                let accepted=match delivery {
                    Some((_,frame))=>garen_w_live::accept_presentations_frame(&mut state,&snapshot,frame,effect_clock.now),
                    None=>garen_w_live::accept_presentations(&mut state,&snapshot,effect_clock.now),
                };
                match accepted {
                    Ok(true) => {},
                    Ok(false) => continue,
                    Err(error) => { warn!("Presentation snapshot rejected: {error}"); continue; },
                }
                if has_missile_context { state.missile_contexts.push(snapshot.clone()); }
                if std::env::var_os("OPENLEAGUE_Q_STARTUP_PROBE").is_some() {
                    let missiles=snapshot.spell_projectiles.iter().map(|m|serde_json::json!({"source":m.source,"target":m.target,"cooldown_ready":m.cooldown_ready})).collect::<Vec<_>>();
                    warn!("ANNIE_RECEIVE {}",serde_json::json!({"session":snapshot.session,"tick":snapshot.tick,"elapsed":time.elapsed_secs_f64(),"previous_tick":state.snapshot.as_ref().map(|old|old.tick),"missiles":missiles}));
                }
                for p in &snapshot.players {
                    let position =
                        Vec3::new(p.position.x / 20., p.height / 20., p.position.z / 20.);
                    if !state.visuals.contains_key(&p.id) {
                        let (request, scale) =
                            animation::request(p.id, &p.champion, &catalog, &assets);
                        let mut transform = Transform::from_translation(position).with_scale(Vec3::splat(0.05 * scale));
                        entity_orientation::apply_snapshot(&mut transform, None, p);
                        let entity = commands
                            .spawn((
                                transform,
                                request,
                            ))
                            .id();
                        state.visuals.insert(p.id, entity);
                    } else if let Ok(mut transform) = transforms.get_mut(state.visuals[&p.id]) {
                        let previous=state.snapshot.as_ref().and_then(|old|old.players.iter().find(|old|old.id==p.id));
                        entity_orientation::apply_snapshot(&mut transform, previous, p);
                        transform.translation = position;
                    }
                    if connection.id == Some(p.id) && state.snapshot.is_none() {
                        focus.0 = camera_native::initialize_snapshot_focus(p.id, [p.position.x, p.height, p.position.z]);
                    }
                }
                for unit in &snapshot.units {
                    let destroyed = nexus_ceremony::destroyed(unit, snapshot.result.as_ref(), &clock, time.elapsed_secs_f64());
                    if state
                        .destroyed_structures
                        .get(&unit.id)
                        .is_some_and(|old| *old != destroyed)
                    {
                        if let Some(entity) = state.visuals.remove(&unit.id) {
                            commands.entity(entity).despawn();
                        }
                    }
                    state.destroyed_structures.insert(unit.id, destroyed);
                    let model_name = if destroyed {
                        format!("{}_destroyed", unit.definition)
                    } else {
                        unit.definition.clone()
                    };
                    let position = Vec3::new(
                        unit.position.x / 20.,
                        unit.height / 20.,
                        unit.position.z / 20.,
                    );
                    if !state.visuals.contains_key(&unit.id) {
                        let (request, scale) =
                            animation::request(unit.id, &model_name, &catalog, &assets);
                        let entity = commands
                            .spawn((
                                Transform::from_translation(position)
                                    .with_rotation(Quat::from_rotation_y(unit.facing))
                                    .with_scale(Vec3::splat(scale * 0.05)),
                                request,
                            ))
                            .id();
                        state.visuals.insert(unit.id, entity);
                    } else if let Ok(mut transform) = transforms.get_mut(state.visuals[&unit.id]) {
                        if let Some(previous)=state.snapshot.as_ref().and_then(|old|old.units.iter().find(|old|old.id==unit.id)) {
                            entity_orientation::apply(&mut transform,[unit.position.x-previous.position.x,0.,unit.position.z-previous.position.z]);
                        }
                        transform.translation = position;
                    }
                }
                if let Some(map) = &snapshot.map10 {
                    for altar in &map.altars {
                        if !state.visuals.contains_key(&altar.id) {
                            let name = if altar.name == "altar_west" {
                                "altar_l"
                            } else {
                                "altar_r"
                            };
                            let (request, scale) =
                                animation::request(altar.id, name, &catalog, &assets);
                            let entity = commands
                                .spawn((
                                    Transform::from_xyz(
                                        altar.position.x / 20.,
                                        altar.height / 20.,
                                        altar.position.z / 20.,
                                    )
                                    .with_scale(Vec3::splat(scale * 0.05)),
                                    request,
                                ))
                                .id();
                            state.visuals.insert(altar.id, entity);
                        }
                    }
                }
                let gone: Vec<_> = state
                    .visuals
                    .keys()
                    .filter(|id| {
                        !snapshot.players.iter().any(|p| p.id == **id)
                            && !snapshot.units.iter().any(|u| u.id == **id)
                            && !snapshot
                                .map10
                                .as_ref()
                                .is_some_and(|m| m.altars.iter().any(|a| a.id == **id))
                    })
                    .copied()
                    .collect();
                for id in gone {
                    state.destroyed_structures.remove(&id);
                    if let Some(entity) = state.visuals.remove(&id) {
                        commands.entity(entity).despawn();
                    }
                }
                state.snapshot = Some(snapshot);
                // The actual gameplay/presentation commit is complete. Network
                // receipt, frame assembly or a clock ACK alone never grants inputs.
                if let Err(error)=connection.presented(delivery) {connection.fail_session(error);break;}
                else if connection.ready() {connection.rejection.clear();}
            }
            session_connection::Incoming::Clock { session, ordinal, opcode, payload, secure } => {
                if let Err(error)=session_connection::apply_clock(&mut connection,&mut effect_clock,secure,session,ordinal,opcode,&payload) {
                    connection.report(error);
                }
            }
            session_connection::Incoming::Rejected(reason)=>connection.report(&reason),
        }
    }
}
fn item_hotkey(keys:&ButtonInput<KeyCode>)->Option<u8> {
    [KeyCode::Digit1,KeyCode::Digit2,KeyCode::Digit3,KeyCode::Digit5,KeyCode::Digit6,KeyCode::Digit7].iter().position(|key|keys.just_pressed(*key)).map(|i|i as u8)
}
#[cfg(test)]
mod item_hotkey_tests {
 use super::*;
 #[test]
 fn original_six_item_keys_and_reserved_four_are_respected() {
  for (slot,key) in [KeyCode::Digit1,KeyCode::Digit2,KeyCode::Digit3,KeyCode::Digit5,KeyCode::Digit6,KeyCode::Digit7].into_iter().enumerate() {
   let mut keys=ButtonInput::default();keys.press(key);assert_eq!(item_hotkey(&keys),Some(slot as u8));keys.clear();assert_eq!(item_hotkey(&keys),None);
  }
  let mut keys=ButtonInput::default();keys.press(KeyCode::Digit4);assert_eq!(item_hotkey(&keys),None);
 }
}

fn commands(
    buttons: Res<ButtonInput<MouseButton>>,
    keys: Res<ButtonInput<KeyCode>>,
    windows: Query<&Window>,
    cameras: Query<(&Camera, &GlobalTransform)>,
    mut connection: ResMut<Connection>,
    state: Res<Match>,
    shop: Res<shop_ui::Filters>,
    terrain: Res<picking::Terrain>,
    learning_hud: Res<native_hud_learning::Live>,
    inventory_capture: Res<native_hud_inventory::Capture>,
    minimap_capture: Option<Res<native_minimap::Capture>>,
    shortcuts: Res<spell_input::Shortcuts>,
) {
    if inventory_capture.blocks_commands() || (learning_hud.pointer_hover && buttons.just_pressed(MouseButton::Right)) || shop.focused || !connection.ready() || state.snapshot.as_ref().is_some_and(|s|s.winner.is_some()) {
        return;
    }
    let minimap_pointer=minimap_capture.is_some_and(|capture|capture.blocks_world_pointer());
    let shortcut = shortcuts.selected();
    let skill = shortcut.map(|intent| intent.slot);
    let targeted_q=skill==Some(0)&&state.snapshot.as_ref().and_then(|s|s.players.iter().find(|p|Some(p.id)==connection.id)).is_some_and(|p|p.champion=="annie");
    let ground_skill=skill.is_some_and(|slot|state.snapshot.as_ref().and_then(|s|s.players.iter().find(|p|Some(p.id)==connection.id)).is_some_and(|p|spell_input::ground_target(&p.champion,slot)));
    let pet_control=buttons.just_pressed(MouseButton::Right)&&(keys.pressed(KeyCode::AltLeft)||keys.pressed(KeyCode::AltRight))&&state.snapshot.as_ref().and_then(|s|s.players.iter().find(|p|Some(p.id)==connection.id).map(|p|(s,p))).is_some_and(|(s,p)|p.champion=="annie"&&s.units.iter().any(|u|u.health>0.&&u.pet.as_ref().is_some_and(|pet|pet.owner==p.id&&s.tick<pet.expires)));
    let ground_skill=ground_skill||pet_control;
    let targeted_skill=skill==Some(3)||targeted_q||ground_skill;
    let learning = shortcut.is_some_and(|intent| intent.learn);
    let summoner_action = |slot: u8| {
        // Heal permits no explicit target. A captured minimap pointer must not
        // select an ally behind the overlay; the server keeps its normal policy.
        if minimap_pointer && connection.summoners[slot as usize] == Some(openleague_core::summoners::Spell::Heal) {
            return Action::SummonerTarget { slot, target: None };
        }
        if matches!(
            connection.summoners[slot as usize],
            Some(
                openleague_core::summoners::Spell::Heal
                    | openleague_core::summoners::Spell::Exhaust
                    | openleague_core::summoners::Spell::Ignite
                    | openleague_core::summoners::Spell::Smite
            )
        ) {
            let target = windows
                .iter()
                .next()
                .and_then(|w| w.cursor_position())
                .and_then(|cursor| {
                    let (camera, transform) = cameras.iter().next()?;
                    let ray = camera.viewport_to_world(transform, cursor).ok()?;
                    let pick = if connection.summoners[slot as usize]
                        == Some(openleague_core::summoners::Spell::Heal)
                    {
                        picking::allied_target
                    } else if connection.summoners[slot as usize]==Some(openleague_core::summoners::Spell::Ignite) {
                        picking::ignite_target
                    } else if connection.summoners[slot as usize]==Some(openleague_core::summoners::Spell::Smite) {
                        picking::smite_target
                    } else {
                        picking::exhaust_target
                    };
                    pick(
                        state.snapshot.as_ref()?,
                        connection.id?,
                        (ray.origin * 20.).to_array(),
                        ray.direction.to_array(),
                    )
                });
            Action::SummonerTarget { slot, target }
        } else {
            Action::Summoner { slot }
        }
    };
    let item_slot = item_hotkey(&keys);
    let action = if let Some(slot) = item_slot {
        Some(Action::UseItem { slot })
    } else if keys.just_pressed(KeyCode::KeyD) {
        if minimap_pointer && native_minimap::summoner_requires_world_target(connection.summoners[0]) {
            connection.report("Visez une cible dans le monde pour ce sort.");None
        } else {Some(summoner_action(0))}
    } else if keys.just_pressed(KeyCode::KeyF) {
        if minimap_pointer && native_minimap::summoner_requires_world_target(connection.summoners[1]) {
            connection.report("Visez une cible dans le monde pour ce sort.");None
        } else {Some(summoner_action(1))}
    } else if let Some(slot) = skill.filter(|_| learning) {
        Some(Action::Learn { slot })
    } else if let Some(slot) = skill.filter(|slot| *slot != 3 && !targeted_q && !ground_skill) {
        Some(Action::Cast { slot, target: None })
    } else if keys.just_pressed(KeyCode::KeyS) {
        Some(Action::Stop)
    } else if buttons.just_pressed(MouseButton::Right) || targeted_skill {
        if minimap_pointer {
            if targeted_skill {connection.report("Visez une cible dans le monde pour ce sort.");}
            return;
        }
        let Some(cursor) = windows.iter().next().and_then(|w| w.cursor_position()) else {
            return;
        };
        let Some((camera, transform)) = cameras.iter().next() else {
            return;
        };
        let Ok(ray) = camera.viewport_to_world(transform, cursor) else {
            return;
        };
        let origin = (ray.origin * 20.).to_array();
        let direction = ray.direction.to_array();
        let target = state.snapshot.as_ref().and_then(|snapshot| {
            picking::target(
                snapshot,
                connection.id.unwrap(),
                origin,
                direction,
                skill == Some(3),
            )
        });
        let point = if ground_skill || (target.is_none() && !targeted_skill) {
            let Some(point) = terrain.0.raycast_floor(origin, direction) else {
                return;
            };
            point
        } else {
            Point { x: 0., z: 0. }
        };
        Some(if ground_skill {Action::CastAt{slot:if pet_control {3} else {skill.unwrap()},point}} else if targeted_skill {
            Action::Cast { slot: skill.unwrap(), target }
        } else if let Some(target) = target {
            Action::Attack { target }
        } else {
            Action::Move { point }
        })
    } else {
        None
    };
    if let Some(action) = action {
        if let Err(error)=connection.send_action(action) {connection.report(&error);}
    }
}
fn camera(
    mut end_pan:ResMut<camera_native::EndPan>,
    state: Res<Match>,
    flights: Option<Res<annie_q_vfx::Flights>>,
    effect_clock: Option<Res<native_effect_clock::EffectClock>>,
    input: Res<ordinary_camera_input::Controls>,
    mut wheel: MessageReader<bevy::input::mouse::MouseWheel>,
    time: Res<Time>,
    mut focus: ResMut<CameraFocus>,
    mut native_camera: ResMut<camera_native::NativeCamera>,
    mut cameras: Query<(&mut Transform, &mut Projection, &mut Camera), With<Camera3d>>,
) {
    let locked=state.snapshot.as_ref().is_some_and(|s|s.winner.is_some());
    for event in wheel.read() {
        if locked || !input.accepts_wheel(event.window) {continue;}
        if let Err(error)=native_camera.scroll(event.unit,event.y) {warn!("Camera wheel: {error}");}
    }
    if let Some(position)=end_pan.apply(state.snapshot.as_ref().and_then(|s|s.result.as_ref()),(focus.0*20.).to_array(),time.elapsed_secs()) {focus.0=Vec3::from_array(position)/20.;}
    // Opt-in fixed camera for actual framebuffer diagnostics only.
    if std::env::var_os("OPENLEAGUE_SCREENSHOT").is_some() {
        if let Ok(raw) = std::env::var("OPENLEAGUE_RENDER_FOCUS") {
            let v: Vec<f32> = raw.split(',').filter_map(|s| s.parse().ok()).collect();
            if v.len() == 3 && v.iter().all(|x| x.is_finite()) {
                focus.0 = Vec3::new(v[0], v[1], v[2]);
            }
        }
    }
    // Opt-in rendered camera test; uses the normal camera pose/culling pipeline.
    if std::env::var_os("OPENLEAGUE_PROJECTED_CAMERA_REENTRY").is_some() && std::env::var_os("OPENLEAGUE_SCREENSHOT").is_some(){
        if let (Some(flights),Some(clock))=(flights,effect_clock) {
            let now=clock.now;
            if flights.projection_owners().iter().any(|(_,started,_,_,ended)|!ended && (0.10..0.20).contains(&(now-started))){focus.0.x+=250.;}
        }
    }
    let (transform, projection, constrained_focus) = native_camera.pose(focus.0, time.delta_secs(), time.elapsed_secs()).expect("native Map10 camera");
    focus.0 = constrained_focus;
    for (mut camera, mut camera_projection, mut settings) in &mut cameras {
        camera_projection_bridge::synchronize(&mut settings, &mut camera_projection, &projection)
            .expect("native perspective camera bridge");
        *camera = transform;
    }
}
fn labels(
    connection: Res<Connection>,
    state: Res<Match>,
    map: Res<MapHandle>,
    mut labels: Query<(&mut Text,&mut Node), With<PlayerLabel>>,
    keys: Res<ButtonInput<KeyCode>>,
    mut debug_visible: Local<bool>,
) {
    if keys.just_pressed(KeyCode::F3) {*debug_visible=!*debug_visible;}
    let _retained = &map.0;
    if !connection.ready() {
        for (mut text,mut node) in &mut labels {
            **text=connection.session_status().to_owned();
            node.display=Display::Flex;
        }
        return;
    }
    let Some(snapshot) = &state.snapshot else {
        return;
    };
    let player = snapshot
        .players
        .iter()
        .find(|p| Some(p.id) == connection.id);
    if let Some(player) = player {
        for (mut text,mut node) in &mut labels {
        if state.snapshot.as_ref().is_some_and(|s|s.winner.is_some()){**text=String::new();node.display=Display::None;continue;}
        node.display=if *debug_visible {Display::Flex}else{Display::None};
            let skills = (0..4)
                .map(|i| {
                    format!(
                        "{} {} / {:.1}s",
                        ["Q", "W", "E", "R"][i],
                        player.ranks[i],
                        player.cooldowns[i].saturating_sub(snapshot.tick) as f32 / 30.
                    )
                })
                .collect::<Vec<_>>()
                .join("  |  ");
            let points = player.level.saturating_sub(player.ranks.iter().sum());
            let death = player
                .respawn_at
                .map(|tick| {
                    format!(
                        "RÃ©apparition dans {:.1}s",
                        tick.saturating_sub(snapshot.tick) as f32 / 30.
                    )
                })
                .unwrap_or_default();
            let relic = snapshot
                .map10
                .as_ref()
                .map(|m| {
                    if !m.relic_visible {
                        "Relique hors vue".to_string()
                    } else if m.relic_available {
                        "Relique disponible".to_string()
                    } else {
                        format!(
                            "Relique dans {:.1}s",
                            m.relic_ready_tick.saturating_sub(snapshot.tick) as f32 / 30.
                        )
                    }
                })
                .unwrap_or_default();
            let altars = snapshot
                .map10
                .as_ref()
                .map(|m| {
                    m.altars
                        .iter()
                        .map(|a| {
                            format!(
                                "{} : {} â€” {}",
                                if a.name == "altar_west" {
                                    "Ouest"
                                } else {
                                    "Est"
                                },
                                a.owner
                                    .map(|team| if team == player.team {
                                        "alliÃ©"
                                    } else {
                                        "ennemi"
                                    })
                                    .unwrap_or("neutre"),
                                if snapshot.tick < a.locked_until {
                                    format!(
                                        "verrouillÃ© {:.1}s",
                                        a.locked_until.saturating_sub(snapshot.tick) as f32 / 30.
                                    )
                                } else if a.contested {
                                    "contestÃ©".to_string()
                                } else if a.capturing.is_some() {
                                    format!(
                                        "capture {:.0}%",
                                        100. * a.progress_ticks as f32
                                            / a.required_ticks.max(1) as f32
                                    )
                                } else {
                                    "disponible".to_string()
                                }
                            )
                        })
                        .collect::<Vec<_>>()
                        .join(" | ")
                })
                .unwrap_or_default();
            let summoners = player
                .summoners
                .spells
                .iter()
                .enumerate()
                .map(|(i, spell)| {
                    format!(
                        "{}: {} / {:.1}s",
                        if i == 0 { "D" } else { "F" },
                        match spell {
                            Some(openleague_core::summoners::Spell::Barrier) => "Barriere",
                            Some(openleague_core::summoners::Spell::Heal) => "Soin",
                            Some(openleague_core::summoners::Spell::Exhaust) => "Fatigue",
                            Some(openleague_core::summoners::Spell::Ignite) => "Embrasement",
                            Some(openleague_core::summoners::Spell::Smite) => "Chatiment",
                            None => "vide",
                        },
                        player.summoners.ready_at[i].saturating_sub(snapshot.tick) as f32 / 30.
                    )
                })
                .collect::<Vec<_>>()
                .join(" | ");
            let shield: f32 = player
                .shields
                .iter()
                .filter(|s| s.expires_at > snapshot.tick)
                .map(|s| s.remaining)
                .sum::<f32>()
                .abs();
            let control = player.stuns.iter().map(|s|s.expires_at.saturating_sub(snapshot.tick)).max().unwrap_or(0);
            let passive_label=if player.champion=="annie" {format!(" | Pyromanie {}/4{}",player.effects.pyromania,if player.effects.pyromania>=4 {" prÃªte"} else {""})} else {String::new()};
            let control_label=if control>0 && player.health>0. {format!("Ã‰tourdi {:.1}s",control as f32/30.)} else {"ContrÃ´le : libre".into()};
            **text=format!("OpenLeague 4.20 | {} | niveau {} | K/D/A {}/{}/{} | XP {:.0} | PV {:.0}/{:.0} | or {:.1} | unitÃ©s {}\n{} | points {}\nCtrl+Q/W/E/R : apprendre â€” Q/W/E/R : lancer (sorts ciblÃ©s sous le curseur)\nClic droit : dÃ©placement / attaque â€” Alt+clic droit : Tibbers â€” flÃ¨ches : camÃ©ra â€” Espace : centrer / Y : suivi / molette : zoom â€” S : arrÃªt â€” P : boutique\nServeur : {}\nConstruction en cours : passifs, autres champions, objets, objectifs et services incomplets",player.champion,player.level,player.score.kills,player.score.deaths,player.score.assists,player.experience,player.health,player.max_health,player.gold,snapshot.units.len(),format!("{} | {} | bouclier {:.0} | {}{}", skills, summoners, shield, control_label, passive_label),points,format!("{} {} {} {} {}",connection.rejection,death,relic,altars,snapshot.winner.map(|winner|if winner==player.team {"Victoire : Nexus adverse dÃ©truit"}else {"DÃ©faite : Nexus dÃ©truit"}).unwrap_or("")));
        }
    }
}

#[cfg(test)]
mod camera_input_tests {
 use super::*;
 use bevy::input::{mouse::{MouseWheel,MouseScrollUnit},touch::TouchPhase};
 #[test]
 fn camera_system_consumes_wheel_messages_once_and_updates_actual_projection() {
  let mut app=App::new();let mut clock: Time=Time::default();clock.advance_by(std::time::Duration::from_millis(16));
  app.init_resource::<Match>().init_resource::<camera_native::EndPan>().add_message::<MouseWheel>().insert_resource(clock).insert_resource(ButtonInput::<KeyCode>::default())
   .insert_resource(CameraFocus(Vec3::new(370.,0.,385.))).insert_resource(camera_native::NativeCamera::default())
   .insert_resource(ordinary_camera_input::Controls::wheel_fixture(Entity::PLACEHOLDER))
   .add_systems(Update,camera);
  let entity=app.world_mut().spawn((Camera3d::default(),Transform::default(),Projection::default())).id();
  app.update();let focus=app.world().resource::<CameraFocus>().0;
  let initial=app.world().get::<Transform>(entity).unwrap().translation.distance(focus);
  app.world_mut().write_message(MouseWheel{unit:MouseScrollUnit::Line,x:0.,y:20.,window:Entity::PLACEHOLDER,phase:TouchPhase::Moved});
  app.update();assert!(app.world().get::<Transform>(entity).unwrap().translation.distance(focus)<initial);
  for _ in 0..120 {app.update();}
  assert!((app.world().get::<Transform>(entity).unwrap().translation.distance(focus)-40.).abs()<0.001);
  app.world_mut().write_message(MouseWheel{unit:MouseScrollUnit::Line,x:0.,y:-1.,window:Entity::PLACEHOLDER,phase:TouchPhase::Moved});
  for _ in 0..120 {app.update();}
  // A single -120 native event increases target from1000 to1120, not once per frame.
  assert!((app.world().get::<Transform>(entity).unwrap().translation.distance(focus)-44.8).abs()<0.001);
  let p=camera_projection_bridge::perspective(app.world().get::<Projection>(entity).unwrap()).unwrap();
  assert!(app.world().get::<Camera>(entity).unwrap().invert_culling);
  assert_eq!(p.fov,50_f32.to_radians());assert_eq!(p.near,2.5);assert_eq!(p.far,250.);
 }
 #[test]
 fn end_game_camera_moves_to_authoritative_nexus_and_reaches_actual_renderer_pose(){
  let nav=openleague_core::Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();let mut game=openleague_core::Simulation::new(nav).unwrap();game.enable_map10().unwrap();game.session=734;for _ in 0..6{game.join("garen").unwrap();}game.winner=Some(0);game.advance();let snapshot=game.snapshot();let endpoint=Vec3::from_array(snapshot.result.as_ref().unwrap().destroyed_nexus.as_ref().unwrap().position)/20.;
  let origin=Vec3::new(370.,0.,385.);let mut app=App::new();let mut time:Time=Time::default();time.advance_by(std::time::Duration::from_millis(16));let mut keys=ButtonInput::default();keys.press(KeyCode::ArrowDown);
  app.add_message::<bevy::input::mouse::MouseWheel>().insert_resource(time).insert_resource(keys).insert_resource(Match{snapshot:Some(snapshot),..default()}).init_resource::<camera_native::EndPan>().init_resource::<ordinary_camera_input::Controls>().insert_resource(CameraFocus(origin)).insert_resource(camera_native::NativeCamera::default()).add_systems(Update,camera);
  let entity=app.world_mut().spawn((Camera3d::default(),Transform::default(),Projection::default())).id();app.update();assert!(app.world().resource::<CameraFocus>().0.distance(origin)<0.001);
  app.world_mut().resource_mut::<Time>().advance_by(std::time::Duration::from_millis(1500));app.update();let middle=app.world().resource::<CameraFocus>().0;let target=Vec3::new(endpoint.x,0.,endpoint.z);assert!(middle.distance((origin+target)*0.5)<0.001);
  app.world_mut().resource_mut::<Time>().advance_by(std::time::Duration::from_millis(1500));app.update();assert!(app.world().resource::<CameraFocus>().0.distance(target)<0.001);assert!(app.world().resource::<camera_native::EndPan>().pan.as_ref().unwrap().finished);
  let transform=app.world().get::<Transform>(entity).unwrap();assert!(transform.forward().dot((target-transform.translation).normalize())>0.999999);
 }

}

mod effect_spatial_registry;
mod native_projected_parent;
mod native_ambient_parent;


#[cfg(windows)]
fn attach_native_replay_runtime(app:&mut App)->Result<(),String> {
    let runtime=openleague_core::audio_replay_windows_application::Application::new()?;
    {
        let mut replay=app.world_mut().get_resource_mut::<NativeReplayService>()
            .ok_or("configured replay service must be inserted before its Windows runtime")?;
        replay.0.attach(runtime.transport()?)?;
    }
    let process_clock = runtime.transport()?.clock_handle()?;
    app.insert_resource(native_effect_clock::EffectClock::with_process_clock(process_clock));
    app.insert_non_send_resource(runtime);
    Ok(())
}

#[cfg(windows)]
fn native_replay_runtime_probe(root:&std::path::Path) {
    use openleague_core::audio_replay_windows_application::Application;
    let loaded=native_user_settings::load(root).expect("load runtime probe Game.cfg");
    let replay=native_replay_service::Service::new(loaded.replay).expect("construct configured native replay service");
    let mut app=App::new();
    app.insert_resource(NativeReplayService(replay));
    attach_native_replay_runtime(&mut app).expect("attach normal native replay runtime");
    let before=app.world().non_send_resource::<Application>().diagnostic().expect("read idle runtime");
    let initialized=app.world().non_send_resource::<Application>().transport().expect("transport owner").initialize().expect("native transport initialization");
    let running=app.world().non_send_resource::<Application>().diagnostic().expect("read initialized runtime");
    assert_eq!(initialized,1);
    assert_eq!(running["transport"]["status"],2);
    assert_eq!(running["transport"]["references"],1);
    let service=app.world_mut().resource_mut::<NativeReplayService>().0.diagnostic().expect("read configured native replay service");
    app.world_mut().resource_mut::<NativeReplayService>().0.close().expect("close configured native replay service");
    let live_service_allocations=app.world().resource::<NativeReplayService>().0.live_allocations();
    app.world_mut().non_send_resource_mut::<Application>().close().expect("close replay Windows lifetime");
    let closed=app.world().non_send_resource::<Application>().diagnostic().expect("read closed runtime");
    assert_eq!(live_service_allocations,0);
    assert_eq!(closed["crt"]["heap_blocks"],0);
    assert_eq!(closed["crt"]["critical_sections"],0);
    assert_eq!(closed["workers_created"],closed["workers_closed"]);
    println!("{}",serde_json::json!({"before":before,"running":running,"closed":closed,"replay_service":service,"live_service_allocations_after_close":live_service_allocations,"normal_application_attachment":true,"replay_frame_delivery":false}));
}

#[cfg(windows)]
fn native_replay_configuration_probe(root:&std::path::Path) {
    use openleague_core::{audio_replay_windows_application::Application,audio_replay_windows_transport::ConfigurationRequest};
    let loaded=native_user_settings::load(root).expect("load replay configuration probe Game.cfg");
    let replay=native_replay_service::Service::new(loaded.replay).expect("construct configured native replay service");
    let mut app=App::new();
    app.insert_resource(NativeReplayService(replay));
    attach_native_replay_runtime(&mut app).expect("attach normal native replay runtime");
    let before=app.world().non_send_resource::<Application>().diagnostic().expect("idle configuration lifetime");
    let configured=app.world().non_send_resource::<Application>().transport().expect("transport owner").configure(ConfigurationRequest{host:Some(b"127.0.0.1"),port:0x1234ffff,arguments:[0x11223344,0x55667788],callback:None,sockaddr_frame:[165;16]}).expect("actual Windows transport configuration");
    assert_eq!(configured,0);
    let running=app.world().non_send_resource::<Application>().diagnostic().expect("configured lifetime");
    assert_eq!(running["transport"]["configuration"]["uid"],0xff2199f5u32);
    assert_eq!(running["transport"]["configuration"]["requested_port"],65535);
    assert_eq!(running["transport"]["references"],1);
    let rejected=app.world().non_send_resource::<Application>().transport().expect("transport owner").configure(ConfigurationRequest{host:Some(b"98.24.0.44"),port:12345,arguments:[0,0],callback:None,sockaddr_frame:[0;16]}).expect("native zero-UID error code");
    assert_eq!(rejected,3);
    let failed=app.world().non_send_resource::<Application>().diagnostic().expect("failed configuration lifetime");
    assert_eq!(failed["transport"]["references"],0);
    assert_eq!(failed["transport"]["winsock_references"],0);
    assert_eq!(failed["transport"]["timer_references"],0);
    let service=app.world_mut().resource_mut::<NativeReplayService>().0.diagnostic().expect("configured replay service");
    app.world_mut().resource_mut::<NativeReplayService>().0.close().expect("close replay service");
    assert_eq!(app.world().resource::<NativeReplayService>().0.live_allocations(),0);
    app.world_mut().non_send_resource_mut::<Application>().close().expect("close native configuration and Windows lifetime");
    let closed=app.world().non_send_resource::<Application>().diagnostic().expect("closed configuration lifetime");
    assert_eq!(closed["crt"]["heap_blocks"],0);
    assert_eq!(closed["crt"]["critical_sections"],0);
    assert_eq!(closed["workers_created"],1);
    assert_eq!(closed["workers_closed"],1);
    println!("{}",serde_json::json!({"before":before,"configured":running,"configuration_error":failed,"closed":closed,"replay_service":service,"native_success_code":configured,"native_failure_code":rejected,"normal_application_attachment":true,"native_transport_configuration":true,"source_stream_opening_connected":false,"replay_frame_delivery":false}));
}

#[cfg(windows)]
fn native_replay_stream_transport_probe(root:&std::path::Path) {
    use openleague_core::{audio_replay_windows_application::Application,audio_replay_windows_transport::{ConfigurationRequest,StreamConfigurationRequest,ConfigurationCallback}};
    let mut profiles=Vec::new();
    // Source parent state1 creates a fresh implementation. A released status2
    // transport must not be silently reused or supplied invented references.
    for(host,expected)in[(b"127.0.0.1".as_slice(),0),(b"98.24.0.44".as_slice(),3)] {
        let loaded=native_user_settings::load(root).expect("load stream transport Game.cfg");
        let replay=native_replay_service::Service::new(loaded.replay).expect("construct configured replay service");
        let mut app=App::new();app.insert_resource(NativeReplayService(replay));
        attach_native_replay_runtime(&mut app).expect("attach normal native replay runtime");
        let before=app.world().non_send_resource::<Application>().diagnostic().expect("idle lifetime");
        let result=app.world().non_send_resource::<Application>().transport().expect("runtime").configure_stream_transport(StreamConfigurationRequest {
            transport:ConfigurationRequest {host:Some(host),port:0x1234ffff,arguments:[0x11223344,0x55667788],callback:Some(ConfigurationCallback {owner:0x44000000,member:0x728e20}),sockaddr_frame:[165;16]},
            key:std::array::from_fn(|i|i as u8),flag:0x1ff,extra:0x88776655,
        }).expect("actual Windows derived transport configuration");
        assert_eq!(result,expected);
        let configured=app.world().non_send_resource::<Application>().diagnostic().expect("configured lifetime");
        let c=&configured["transport"]["configuration"];let stream=&c["stream"];
        assert_eq!(stream["interface_pointer"].as_u64().unwrap(),c["pointer"].as_u64().unwrap()+0xe0);
        assert_eq!(stream["flag"],255);assert_eq!(stream["extra"],0x88776655u32);
        assert_eq!(configured["transport"]["references"],if expected==0{1}else{0});
        if expected==0 {assert_ne!(stream["key_pointer"],0);assert_eq!(c["uid"],0xff2199f5u32);}
        else {assert_eq!(stream["key_pointer"],0);assert_eq!(c["uid"],0);}
        let service=app.world_mut().resource_mut::<NativeReplayService>().0.diagnostic().expect("service diagnostic");
        app.world_mut().resource_mut::<NativeReplayService>().0.close().expect("close replay service");
        assert_eq!(app.world().resource::<NativeReplayService>().0.live_allocations(),0);
        app.world_mut().non_send_resource_mut::<Application>().close().expect("close derived transport and CRT owner");
        let closed=app.world().non_send_resource::<Application>().diagnostic().expect("closed lifetime");
        assert_eq!(closed["crt"]["heap_blocks"],0);assert_eq!(closed["crt"]["critical_sections"],0);
        assert_eq!(closed["workers_created"],1);assert_eq!(closed["workers_closed"],1);
        profiles.push(serde_json::json!({"before":before,"configured":configured,"closed":closed,"service":service,"native_code":result}));
    }
    println!("{}",serde_json::json!({"profiles":profiles,"normal_application_attachment":true,"native_derived_transport_configuration":true,"source_stream_opening_connected":false,"replay_frame_delivery":false}));
}

#[cfg(windows)]
fn native_replay_stream_opening_probe(root:&std::path::Path) {
    use openleague_core::{audio_replay_windows_application::Application,audio_replay_windows_transport::{ConfigurationRequest,StreamConfigurationRequest,StreamOpenRequest,ConfigurationCallback}};
    let mut profiles=Vec::new();
    for(mode,host,expected)in[(0,Some(b"127.0.0.1".as_slice()),0),(0,Some(b"98.24.0.44".as_slice()),3),(1,None,0)] {
        let loaded=native_user_settings::load(root).expect("load opening Game.cfg");let replay=native_replay_service::Service::new(loaded.replay).expect("replay service");
        let mut app=App::new();app.insert_resource(NativeReplayService(replay));attach_native_replay_runtime(&mut app).expect("normal replay runtime attachment");
        let before=app.world().non_send_resource::<Application>().diagnostic().expect("idle lifetime");
        let code=app.world().non_send_resource::<Application>().transport().expect("runtime").open_stream(StreamOpenRequest{mode,configuration:StreamConfigurationRequest{
            transport:ConfigurationRequest{host,port:65535,arguments:[0x11223344,0x55667788],callback:Some(ConfigurationCallback{owner:0x44000000,member:0x728e20}),sockaddr_frame:[165;16]},
            key:std::array::from_fn(|i|i as u8),flag:0x1ff,extra:0x88776655,
        }}).expect("native stream opening");assert_eq!(code,expected);
        let opened=app.world().non_send_resource::<Application>().diagnostic().expect("opened lifetime");let stream=&opened["transport"]["stream"];
        assert_eq!(stream["state_id"],if expected==0{3}else{1});assert_eq!(stream["manager"],stream["implementation_manager"]);assert_eq!(stream["manager_references"],2);
        assert_eq!(opened["transport"]["references"],if mode==0&&expected==0{1}else{0});
        app.world().non_send_resource::<Application>().transport().expect("runtime").close_stream().expect("source stream destruction");
        let stream_closed=app.world().non_send_resource::<Application>().diagnostic().expect("global runtime retained");assert!(stream_closed["transport"]["stream"].is_null());
        assert_eq!(stream_closed["transport"]["references"],if mode==0&&expected==0{1}else{0});
        app.world_mut().resource_mut::<NativeReplayService>().0.close().expect("close service");assert_eq!(app.world().resource::<NativeReplayService>().0.live_allocations(),0);
        app.world_mut().non_send_resource_mut::<Application>().close().expect("close shared runtime and CRT");
        let closed=app.world().non_send_resource::<Application>().diagnostic().expect("closed lifetime");assert_eq!(closed["crt"]["heap_blocks"],0);assert_eq!(closed["crt"]["critical_sections"],0);assert_eq!(closed["workers_created"],if mode==0{1}else{0});assert_eq!(closed["workers_created"],closed["workers_closed"]);
        profiles.push(serde_json::json!({"mode":mode,"native_code":code,"before":before,"opened":opened,"stream_closed":stream_closed,"closed":closed}));
    }
    println!("{}",serde_json::json!({"profiles":profiles,"normal_application_attachment":true,"source_stream_opening":true,"optional_recording_resource_connected":false,"service_manager_callback_connected":false,"replay_frame_delivery":false}));
}

#[cfg(windows)]
fn native_replay_stream_running_probe(root:&std::path::Path) {
    use openleague_core::{audio_replay_windows_application::Application,audio_replay_windows_transport::{ConfigurationRequest,StreamConfigurationRequest,StreamOpenRequest}};
    let mut profiles=Vec::new();
    for stop_explicitly in [true,false] {
        let loaded=native_user_settings::load(root).expect("load replay Game.cfg");
        let replay=native_replay_service::Service::new(loaded.replay).expect("configured replay service");
        let mut app=App::new();app.insert_resource(NativeReplayService(replay));
        attach_native_replay_runtime(&mut app).expect("normal runtime attachment");
        let runtime=app.world().non_send_resource::<Application>().transport().unwrap();
        assert_eq!(runtime.open_stream(StreamOpenRequest{mode:1,configuration:StreamConfigurationRequest{
            transport:ConfigurationRequest{host:None,port:0,arguments:[0;2],callback:None,sockaddr_frame:[0;16]},
            key:[0;16],flag:0,extra:0,
        }}).unwrap(),0);
        let before=runtime.stream_snapshot().unwrap();
        assert_eq!(runtime.start_stream([1,2,3,4,5,6]).unwrap(),0);
        assert_eq!(runtime.start_stream([1,2,3,4,5,6]).unwrap(),8);
        std::thread::sleep(std::time::Duration::from_millis(50));
        let active=runtime.snapshot().unwrap().active_workers;assert_eq!(active,1);
        let stopped=if stop_explicitly {
            runtime.stop_stream().unwrap();runtime.stop_stream().unwrap();
            let state=runtime.stream_snapshot().unwrap();assert_eq!(state.as_ref().unwrap().state_id,3);
            assert_eq!(runtime.snapshot().unwrap().active_workers,0);state
        }else{None};
        app.world_mut().resource_mut::<NativeReplayService>().0.close().unwrap();
        app.world_mut().non_send_resource_mut::<Application>().close().unwrap();
        let closed=app.world().non_send_resource::<Application>().diagnostic().unwrap();
        for key in ["heap_blocks","retained_mirrors","critical_sections","heap_failures","lock_failures"]{assert_eq!(closed["crt"][key],0);}
        assert_eq!(closed["workers_created"],1);assert_eq!(closed["workers_closed"],1);
        assert_eq!(closed["handle_failures"],0);assert_eq!(closed["worker_failures"],serde_json::json!([]));
        profiles.push(serde_json::json!({"explicit_stop":stop_explicitly,"before":before,"active_workers":active,"stopped":stopped,"closed":closed}));
    }
    println!("{}",serde_json::json!({"profiles":profiles,"normal_application_attachment":true,"source_stream_worker":true,
        "implementation":"native_no_op","active_network_host_connected":false,"recording_file_connected":false,"service_manager_connected":false,"replay_frame_delivery":false}));
}

#[cfg(windows)]
fn native_replay_recording_file_probe(root:&std::path::Path) {
    use openleague_core::audio_replay_windows_application::Application;
    let mut profiles=Vec::new();let nonce=std::time::SystemTime::now().duration_since(std::time::UNIX_EPOCH).unwrap().as_nanos();
    for success in [true,false] {
        let loaded=native_user_settings::load(root).unwrap();let replay=native_replay_service::Service::new(loaded.replay).unwrap();
        let mut app=App::new();app.insert_resource(NativeReplayService(replay));attach_native_replay_runtime(&mut app).unwrap();
        let path=if success{root.join("logs").join(format!("native-diagnostic-file-{nonce}.log"))}else{root.join("logs").join(format!("missing-native-directory-{nonce}")).join("diagnostic.log")};
        let report=app.world().non_send_resource::<Application>().transport().unwrap().probe_recording_file(path.to_str().unwrap().as_bytes(),&[b"OpenLeague source file boundary %s %n",b"Repeated open must preserve this line"]).unwrap();
        assert_eq!(report.opened,success as u8);assert_eq!(report.opened_again,success as u8);assert_eq!(report.closed,1);assert_eq!(report.remaining_files,0);assert_eq!(report.files_opened,report.files_closed);
        let content=if success{let data=std::fs::read(&path).unwrap();assert!(data.windows(b"LogOut_File: : logfile stopped\r\n".len()).any(|w|w==b"LogOut_File: : logfile stopped\r\n"));Some(String::from_utf8(data).unwrap())}else{assert!(!path.exists());None};
        app.world_mut().resource_mut::<NativeReplayService>().0.close().unwrap();app.world_mut().non_send_resource_mut::<Application>().close().unwrap();
        let closed=app.world().non_send_resource::<Application>().diagnostic().unwrap();
        for key in ["heap_blocks","retained_mirrors","critical_sections","heap_failures","lock_failures"]{assert_eq!(closed["crt"][key],0);}
        assert_eq!(closed["worker_failures"],serde_json::json!([]));assert_eq!(closed["workers_created"],0);
        profiles.push(serde_json::json!({"expected_file_open":success,"path":path,"report":report,"content":content,"closed":closed}));
    }
    println!("{}",serde_json::json!({"profiles":profiles,"normal_application_attachment":true,"native_diagnostic_file_resource":true,"host_crt":"Windows msvcrt.dll fopen/fprintf/fclose","full_stream_file_preparation":false,"pathname_registration_singleton":false,"replay_frame_serialization":false,"service_manager_connected":false}));
}

#[cfg(windows)]
fn native_replay_recording_stream_probe(root:&std::path::Path){
    use openleague_core::audio_replay_windows_application::Application;
    let nonce=std::time::SystemTime::now().duration_since(std::time::UNIX_EPOCH).unwrap().as_nanos();let mut profiles=Vec::new();
    for profile in 0..3 {
        let loaded=native_user_settings::load(root).unwrap();let replay=native_replay_service::Service::new(loaded.replay).unwrap();
        let mut app=App::new();app.insert_resource(NativeReplayService(replay));attach_native_replay_runtime(&mut app).unwrap();
        let path=if profile==2{root.join("logs").join(format!("missing-stream-directory-{nonce}")).join("diagnostic.log")}else{root.join("logs").join(format!("native-stream-diagnostic-{nonce}.log"))};
        let report=app.world().non_send_resource::<Application>().transport().unwrap().probe_recording_stream(if profile==0{None}else{Some(path.to_str().unwrap().as_bytes())},&[b"OpenLeague stream diagnostic %n %s",b"Source optional preparation and worker lifetime"]).unwrap();
        assert_eq!((report.open_code,report.start_code,report.state_after_start,report.state_after_stop),(0,0,4,3));
        assert_eq!(report.resource_enabled,if profile==1{1}else{0});assert_eq!(report.resource_references,1);assert_eq!(report.registry_initialized,profile!=0);
        assert_eq!(report.files_opened,if profile==1{2}else{0});assert_eq!(report.files_opened,report.files_closed);assert_eq!(report.remaining_files,0);
        let content=if profile==1{let bytes=std::fs::read(&path).unwrap();assert!(bytes.ends_with(b"LogOut_File: : logfile stopped\r\n"));Some(String::from_utf8(bytes).unwrap())}else{if profile==2{assert!(!path.exists());}None};
        app.world_mut().resource_mut::<NativeReplayService>().0.close().unwrap();app.world_mut().non_send_resource_mut::<Application>().close().unwrap();
        let closed=app.world().non_send_resource::<Application>().diagnostic().unwrap();assert_eq!(closed["closed"],true);
        for key in ["heap_blocks","retained_mirrors","critical_sections","heap_failures","lock_failures"]{assert_eq!(closed["crt"][key],0);}
        assert_eq!(closed["worker_failures"],serde_json::json!([]));assert_eq!(closed["workers_created"],1);assert_eq!(closed["workers_closed"],1);
        profiles.push(serde_json::json!({"profile":profile,"path":path,"report":report,"content":content,"closed":closed}));
    }
    println!("{}",serde_json::json!({"profiles":profiles,"normal_application_attachment":true,"source_optional_stream_preparation":true,"source_noop_implementation":true,"pathname_registration_singleton":true,"active_network_host":false,"replay_frame_serialization":false,"service_manager_connected":false}));
}

#[cfg(windows)]
fn native_replay_game_manager_probe(root:&std::path::Path) {
    use openleague_core::{
        audio_replay_windows_application::Application,
        audio_replay_windows_transport::GameReplayRequest,
    };
    fn application(root:&std::path::Path)->App {
        let loaded=native_user_settings::load(root).expect("load game manager Game.cfg");
        let replay=native_replay_service::Service::new(loaded.replay).expect("construct configured replay service");
        let mut app=App::new();
        app.insert_resource(NativeReplayService(replay));
        attach_native_replay_runtime(&mut app).expect("attach canonical service and application");
        let service=app.world_mut().resource_mut::<NativeReplayService>().0.diagnostic().unwrap();
        assert_eq!(service["canonical_runtime_bank"],true);
        app
    }
    fn callbacks(snapshot:&serde_json::Value,service:&serde_json::Value) {
        let owner=service["pointer"].as_u64().unwrap();
        assert_eq!(snapshot["service_callbacks"][0],serde_json::json!([0x109b2d4u32,owner,0x738a3au32,0]));
        assert_eq!(snapshot["service_callbacks"][1],serde_json::json!([0x10afcfcu32,owner,0x72b950u32,0]));
        assert_ne!(snapshot["stream"],0);
        assert_ne!(snapshot["metadata"][0],0);
        assert_ne!(snapshot["metadata"][1],0);
        assert_eq!(snapshot["metadata_references"],1);
    }
    fn finish(app:&mut App,workers:u32)->serde_json::Value {
        app.world_mut().resource_mut::<NativeReplayService>().0.close().expect("close canonical service and parent");
        assert_eq!(app.world().resource::<NativeReplayService>().0.live_allocations(),0);
        let retired={
            let runtime=app.world().non_send_resource::<Application>().transport().unwrap();
            runtime.shutdown().expect("retire canonical runtime allocations");
            let state=runtime.snapshot().unwrap();
            assert_eq!(state.engine_allocations,0);
            assert_eq!(state.active_workers,0);
            assert_eq!(state.handles,0);
            assert!(runtime.errors().is_empty());
            assert!(runtime.game_manager_snapshot().unwrap().is_none());
            serde_json::json!({"engine_allocations":state.engine_allocations,"active_workers":state.active_workers,"handles":state.handles,"critical_sections":state.critical_sections,"errors":runtime.errors()})
        };
        app.world_mut().non_send_resource_mut::<Application>().close().expect("close owning Windows application");
        let closed=app.world().non_send_resource::<Application>().diagnostic().unwrap();
        assert_eq!(closed["closed"],true);
        assert_eq!(closed["workers_created"],workers);
        assert_eq!(closed["workers_closed"],workers);
        assert_eq!(closed["worker_completions"],workers);
        assert_eq!(closed["worker_failures"],serde_json::json!([]));
        assert_eq!(closed["handle_failures"],0);
        for key in ["heap_blocks","retained_mirrors","critical_sections","heap_failures","lock_failures"] {assert_eq!(closed["crt"][key],0);}
        assert_eq!(closed["crt"]["heap_allocations"],closed["crt"]["heap_frees"]);
        serde_json::json!({"retired_runtime":retired,"application":closed})
    }
    let nonce=std::time::SystemTime::now().duration_since(std::time::UNIX_EPOCH).unwrap().as_nanos();
    std::fs::create_dir_all(root.join("logs")).expect("create diagnostic log directory");
    let mut profiles=Vec::new();
    for profile in 0..4 {
        let mut app=application(root);
        let configured=app.world_mut().resource_mut::<NativeReplayService>().0.diagnostic().unwrap();
        let path=if profile==2 {
            root.join("logs").join(format!("missing-manager-directory-{nonce}")).join("diagnostic.log")
        } else {
            root.join("logs").join(format!("native-manager-diagnostic-{nonce}-{profile}.log"))
        };
        assert!(!path.exists(),"probe path must be new");
        if profile==2 {assert!(!path.parent().unwrap().exists());}
        if profile==1 {std::fs::write(&path,b"old bytes must be truncated").unwrap();}
        let input=match profile {0=>None,3=>Some(b"".as_slice()),_=>Some(path.to_str().unwrap().as_bytes())};
        let report={
            let runtime=app.world().non_send_resource::<Application>().transport().unwrap();
            let report=runtime.probe_game_manager(input,&[
                b"OpenLeague parent diagnostic %n %s",
                b"Source service callbacks and canonical manager lifetime",
            ]).expect("source no-op parent diagnostic");
            assert_eq!(report["source_noop_diagnostic"],true);
            assert_eq!(report["service_pointer"],configured["pointer"]);
            assert_eq!(report["started"]["state"],4);
            assert_eq!(report["started"]["code"],0);
            assert_eq!(report["stopped"]["state"],3);
            callbacks(&report["started"],&configured);
            callbacks(&report["stopped"],&configured);
            assert_eq!(report["resource_enabled"],if profile==1 {1}else{0});
            assert_eq!(report["files"]["opened"],if profile==1 {2}else{0});
            assert_eq!(report["files"]["opened"],report["files"]["closed"]);
            assert_eq!(report["files"]["remaining"],0);
            assert_eq!(report["files"]["writes"],if profile==1 {4}else{0});
            assert!(runtime.game_manager_snapshot().unwrap().is_none());
            assert_eq!(runtime.snapshot().unwrap().active_workers,0);
            assert_eq!(runtime.logger_snapshot().unwrap().pointer,0);
            assert!(runtime.errors().is_empty());
            report
        };
        let content=if profile==1 {
            let bytes=std::fs::read(&path).unwrap();
            for required in [
                b"LogOut_File: : logfile started\r\n".as_slice(),
                b"OpenLeague parent diagnostic %n %s\r\n",
                b"Source service callbacks and canonical manager lifetime\r\n",
                b"LogOut_File: : logfile stopped\r\n",
            ] {assert!(bytes.windows(required.len()).any(|v|v==required));}
            assert!(!bytes.windows(b"old bytes".len()).any(|v|v==b"old bytes"));
            assert!(bytes.ends_with(b"LogOut_File: : logfile stopped\r\n"));
            Some(String::from_utf8(bytes).unwrap())
        } else {assert!(!path.exists());None};
        let closed=finish(&mut app,1);
        profiles.push(serde_json::json!({"kind":"source_noop_diagnostic","profile":profile,"requested_path":input.map(|v|String::from_utf8_lossy(v).into_owned()),"configured_service":configured,"report":report,"content":content,"closed":closed}));
    }
    for kind in ["initialize_only","normal_null_host","reject_active_host"] {
        let mut app=application(root);
        let configured=app.world_mut().resource_mut::<NativeReplayService>().0.diagnostic().unwrap();
        let before=app.world().non_send_resource::<Application>().diagnostic().unwrap();
        let outcome={
            let runtime=app.world().non_send_resource::<Application>().transport().unwrap();
            assert!(runtime.game_manager_snapshot().unwrap().is_none());
            if kind=="initialize_only" {
                runtime.initialize_game_manager().expect("source72A800 parent initialization");
                let snapshot=serde_json::to_value(runtime.game_manager_snapshot().unwrap().unwrap()).unwrap();
                assert_eq!(snapshot["state"],1);assert!(snapshot["code"].is_null());
                callbacks(&snapshot,&configured);
                serde_json::json!({"snapshot":snapshot})
            } else {
                let result=runtime.open_game_replay(GameReplayRequest{
                    arguments:[0x11223344,0x55667788],key:std::array::from_fn(|i|i as u8),
                    host:if kind=="reject_active_host" {Some(b"127.0.0.1".as_slice())}else{None},
                    start:[0;6],flag:0,recording_path:None,recording:false,
                });
                if kind=="reject_active_host" {
                    let error=result.expect_err("active host must be rejected before mutation");
                    assert!(error.contains("not connected"));
                    assert!(runtime.game_manager_snapshot().unwrap().is_none());
                    serde_json::json!({"rejected":true,"error":error})
                } else {
                    assert_eq!(result.unwrap(),2);
                    let snapshot=serde_json::to_value(runtime.game_manager_snapshot().unwrap().unwrap()).unwrap();
                    assert_eq!(snapshot["state"],1);assert_eq!(snapshot["code"],2);
                    callbacks(&snapshot,&configured);
                    serde_json::json!({"return_code":2,"snapshot":snapshot})
                }
            }
        };
        let after=app.world().non_send_resource::<Application>().diagnostic().unwrap();
        if kind=="reject_active_host" {
            assert_eq!(after,before,"host preflight must not mutate the application");
            assert_eq!(app.world_mut().resource_mut::<NativeReplayService>().0.diagnostic().unwrap(),configured);
        }
        // Source8FC610 initializes and drains transport before validating host.
        let closed=finish(&mut app,if kind=="normal_null_host"{1}else{0});
        profiles.push(serde_json::json!({"kind":kind,"configured_service":configured,"before":before,"outcome":outcome,"after":after,"closed":closed}));
    }
    println!("{}",serde_json::json!({
        "profiles":profiles,"normal_application_attachment":true,"canonical_configured_service":true,
        "native_service_manager_initialization":true,"source_noop_diagnostic_workers":4,
        "normal_null_host_return_code":2,"active_host_rejected_before_mutation":true,
        "diagnostic_text_file":true,"active_network_host":false,"replay_frame_serialization":false,
        "simulation_frame_delivery":false,"gameplay_complete":false,
    }));
}

#[cfg(windows)]
fn native_replay_events_probe(root:&std::path::Path){
    use openleague_core::audio_replay_windows_application::Application;
    let loaded=native_user_settings::load(root).expect("load replay events Game.cfg");
    let replay=native_replay_service::Service::new(loaded.replay).expect("configure replay service");
    let mut app=App::new();app.insert_resource(NativeReplayService(replay));
    attach_native_replay_runtime(&mut app).expect("attach canonical replay service");
    let report=app.world().non_send_resource::<Application>().transport().unwrap().probe_game_event_consumers().expect("real replay event consumers");
    app.world_mut().resource_mut::<NativeReplayService>().0.close().expect("close replay service");
    let retired={let r=app.world().non_send_resource::<Application>().transport().unwrap();r.shutdown().expect("shutdown replay runtime");let s=r.snapshot().unwrap();assert_eq!(s.engine_allocations,0);assert_eq!(s.active_workers,0);assert_eq!(s.handles,0);assert!(r.errors().is_empty());serde_json::json!({"allocations":s.engine_allocations,"workers":s.active_workers,"handles":s.handles,"errors":r.errors()})};
    app.world_mut().non_send_resource_mut::<Application>().close().expect("close replay application");
    println!("{}",serde_json::json!({"passed":true,"consumers":report,"retired":retired,"complete":false}));
}

#[cfg(windows)]
fn native_process_clock_probe(root: &std::path::Path) {
    use openleague_core::{
        audio_native_process_clock::RawSample,
        audio_replay_windows_application::Application,
        audio_replay_windows_transport::ProcessClockSnapshot,
    };
    use serde_json::{Value, json};

    fn require(condition: bool, message: &str) -> Result<(), String> {
        if condition { Ok(()) } else { Err(message.into()) }
    }
    fn clock_json(s: &ProcessClockSnapshot) -> Value {
        json!({
            "initialized":s.initialized,"origin":s.origin,"frequency":s.frequency,
            "qpf_calls":s.qpf_calls,"qpc_calls":s.qpc_calls,
            "crt_allocations":s.crt_allocations,"pending_mirrors":s.pending_mirrors,
            "inner_mutexes":s.inner_mutexes,"registered_cleanups":s.registered_cleanups,
            "events_created":s.events_created,"events_closed":s.events_closed,
            "event_close_failures":s.event_close_failures,"failure":s.failure,
        })
    }
    fn raw_json(s: RawSample) -> Result<Value, String> {
        let bits = s.f32_bits().map_err(|e| format!("raw clock arithmetic: {e:?}"))?;
        require(f32::from_bits(bits).is_finite(), "raw clock is not finite")?;
        Ok(json!({"counter":s.counter,"origin":s.origin,"frequency":s.frequency,
            "wall_f32_bits":bits}))
    }
    fn follows(first: RawSample, previous: RawSample, next: RawSample) -> Result<(), String> {
        require((first.origin, first.frequency) == (next.origin, next.frequency),
            "canonical clock identity changed")?;
        require(next.counter > previous.counter, "raw counter did not advance across real frames")
    }
    fn effect_json(app: &App) -> Value {
        json!({"clock":app.world().resource::<native_effect_clock::EffectClock>().diagnostic(),
            "animation_delta_bits":app.world().resource::<bevy::animation::AnimationDelta>().0.to_bits()})
    }
    fn healthy_effect(app: &App) -> Result<(), String> {
        let clock = app.world().resource::<native_effect_clock::EffectClock>();
        require(clock.diagnostic()["failed"] == false && clock.now.is_finite(),
            "effect clock stopped or produced a non-finite time")
    }

    let report = (|| -> Result<Value, String> {
        let loaded = native_user_settings::load(root).map_err(|e| format!("load normal Game.cfg: {e}"))?;
        require(loaded.default_loaded && loaded.text_loaded, "normal Game.cfg defaults are unavailable")?;
        let configuration = json!({"default_path":loaded.default_path,"user_path":loaded.user_path,
            "default_loaded":loaded.default_loaded,"user_loaded":loaded.user_loaded,
            "parse_warnings":loaded.parse_warnings,"layout_mode":loaded.layout_mode});
        let replay = native_replay_service::Service::new(loaded.replay)
            .map_err(|e| format!("construct configured service: {e:?}"))?;
        let mut app = App::new();
        app.insert_resource(NativeReplayService(replay));
        attach_native_replay_runtime(&mut app)?;
        app.add_plugins(native_effect_clock::Plugin);
        let source = app.world().non_send_resource::<Application>().transport()?.clock_handle()?;
        // This report owns neither Runtime nor Shared. Bank and each Section
        // hold one report Arc, so it can observe their final retirement below.
        let critical_sections = app.world().non_send_resource::<Application>()
            .transport()?.critical_section_report();
        let mut trace = Vec::<Value>::new();

        // An error inside the exercise still reaches explicit owner cleanup.
        let exercise = (|| -> Result<Value, String> {
            let configured = app.world_mut().resource_mut::<NativeReplayService>().0.diagnostic()
                .map_err(|e| format!("configured service diagnostic: {e:?}"))?;
            require(configured["canonical_runtime_bank"] == true, "service did not attach to the canonical bank")?;
            let before = source.process_clock_snapshot()?;
            require(!before.initialized && before.qpf_calls == 0 && before.qpc_calls == 0,
                "clock initialized before its first consumer")?;
            trace.push(json!({"phase":"attached","process_clock":clock_json(&before)}));

            // Sample the process API before the first effects frame. This is
            // the same canonical producer used by the loading boundary, but
            // this probe does not claim it dispatched a loading packet.
            let first = source.raw_clock_sample()?;
            require(first.frequency > 0, "Windows QPF did not produce a positive frequency")?;
            app.update();
            healthy_effect(&app)?;
            require(app.world().resource::<native_effect_clock::EffectClock>().now == 0.,
                "first frame included time before the effect frame origin")?;
            trace.push(json!({"phase":"first_effect_frame","raw":raw_json(first)?,"effects":effect_json(&app)}));

            // Real waits create elapsed time; there is no synthetic QPC or epoch.
            std::thread::sleep(std::time::Duration::from_millis(20));
            app.update();
            healthy_effect(&app)?;
            let warm = source.raw_clock_sample()?;
            follows(first, first, warm)?;
            let held_time = app.world().resource::<native_effect_clock::EffectClock>().now;
            require(held_time > 0. && app.world().resource::<bevy::animation::AnimationDelta>().0 > 0.,
                "unpaused frame did not advance effects and animation delta")?;
            trace.push(json!({"phase":"running","raw":raw_json(warm)?,"effects":effect_json(&app)}));

            let mut pause = [0u8; 14];
            pause[9..13].copy_from_slice(&30i32.to_le_bytes());
            pause[13] = 1;
            app.world_mut().resource_mut::<native_effect_clock::EffectClock>()
                .receive(1, 0xa1, &pause).map_err(str::to_string)?;
            require(app.world().resource::<native_effect_clock::EffectClock>().paused(), "pause was not applied")?;
            let mut previous = warm;
            for frame in 0..4 {
                std::thread::sleep(std::time::Duration::from_millis(10));
                app.update();
                healthy_effect(&app)?;
                let effects = app.world().resource::<native_effect_clock::EffectClock>();
                require(effects.paused() && effects.acknowledged_ordinal() == 1,
                    "pause state changed during a paused frame")?;
                require(effects.now.to_bits() == held_time.to_bits(), "paused effects advanced")?;
                require(app.world().resource::<bevy::animation::AnimationDelta>().0 == 0.,
                    "paused animation delta was not zero")?;
                let raw = source.raw_clock_sample()?;
                follows(first, previous, raw)?;
                trace.push(json!({"phase":"paused","frame":frame,"raw":raw_json(raw)?,"effects":effect_json(&app)}));
                previous = raw;
            }
            app.world_mut().resource_mut::<native_effect_clock::EffectClock>()
                .receive(2, 0x0a, &[0; 10]).map_err(str::to_string)?;
            std::thread::sleep(std::time::Duration::from_millis(20));
            app.update();
            healthy_effect(&app)?;
            let effects = app.world().resource::<native_effect_clock::EffectClock>();
            require(!effects.paused() && effects.acknowledged_ordinal() == 2, "resume was not applied")?;
            require(effects.now > held_time && app.world().resource::<bevy::animation::AnimationDelta>().0 > 0.,
                "resumed effects and animation delta did not advance")?;
            let resumed = source.raw_clock_sample()?;
            follows(first, previous, resumed)?;
            let process_f32 = source.wall_clock_f32_bits()?;
            require(f32::from_bits(process_f32).is_finite() && f32::from_bits(process_f32) > 0.,
                "canonical f32 clock sample is invalid")?;
            let live = source.process_clock_snapshot()?;
            require(live.initialized && live.qpf_calls == 1 && live.qpc_calls >= 2,
                "canonical clock did not initialize QPF exactly once")?;
            require((live.origin, live.frequency) == (first.origin, first.frequency),
                "pause or resume changed the process clock origin/frequency")?;
            require(live.crt_allocations == 1 && live.pending_mirrors == 0 && live.inner_mutexes == 1,
                "clock mutex ownership is unexpected before shutdown")?;
            require(live.registered_cleanups == [
                openleague_core::audio_clock_once::OUTER_CLEANUP,
                openleague_core::audio_clock_once::MUTEX_CLEANUP,
            ], "clock cleanup registrations are missing or out of order")?;
            require(live.failure.is_none() && live.event_close_failures == 0 && live.events_created == live.events_closed,
                "process clock reported a failure or retained a waiter event")?;
            trace.push(json!({"phase":"resumed","raw":raw_json(resumed)?,"effects":effect_json(&app),
                "process_clock":clock_json(&live),"wall_clock_api_f32_bits":process_f32}));
            Ok(json!({"configured_service":configured,"frame_updates":7,"paused_frames":4,
                "origin":first.origin,"frequency":first.frequency,"qpf_calls":live.qpf_calls}))
        })();

        let mut cleanup_errors = Vec::<String>::new();
        if let Err(e) = app.world_mut().resource_mut::<NativeReplayService>().0.close() {
            cleanup_errors.push(format!("close configured service: {e:?}"));
        }
        let service_allocations = app.world().resource::<NativeReplayService>().0.live_allocations();
        if service_allocations != 0 { cleanup_errors.push(format!("service retained {service_allocations} allocations")); }
        let retired = (|| -> Result<Value, String> {
            let runtime = app.world().non_send_resource::<Application>().transport()?;
            runtime.shutdown()?;
            let state = runtime.snapshot()?;
            require(state.engine_allocations == 0 && state.active_workers == 0 && state.handles == 0,
                "runtime retained allocations, workers or handles")?;
            // Native-logger attach creates one Shared-scope section at
            // startup::MUTEX+8. shutdown retires dynamic sections but this
            // section stays alive until the retained Service/Clock handles die.
            require(state.critical_sections == 1,
                "runtime did not retain exactly its single Shared-scope critical section")?;
            let report_owners = std::sync::Arc::strong_count(&critical_sections);
            require(report_owners == 3,
                "critical-section report must have probe, Bank and single Section owners")?;
            require(critical_sections.failures().is_empty(), "critical-section report recorded a shutdown failure")?;
            require(runtime.errors().is_empty(), "runtime recorded an error")?;
            Ok(json!({"engine_allocations":state.engine_allocations,"active_workers":state.active_workers,
                "handles":state.handles,"critical_sections":state.critical_sections,
                "scope_critical_section_reference":openleague_core::audio_replay_transport_startup::MUTEX + 8,
                "critical_section_report_owners":report_owners,"errors":runtime.errors()}))
        })();
        if let Err(e) = &retired { cleanup_errors.push(format!("runtime cleanup: {e}")); }
        if let Err(e) = app.world_mut().non_send_resource_mut::<Application>().close() {
            cleanup_errors.push(format!("application cleanup: {e}"));
        }
        let closed = (|| -> Result<Value, String> {
            let snapshot = source.process_clock_snapshot()?;
            require(snapshot.crt_allocations == 0 && snapshot.pending_mirrors == 0 && snapshot.inner_mutexes == 0
                && snapshot.registered_cleanups.is_empty(), "clock retained cleanup owners")?;
            require(snapshot.events_created == snapshot.events_closed && snapshot.event_close_failures == 0,
                "clock retained an event or failed to close one")?;
            require(snapshot.failure.is_none(), "clock recorded an error before shutdown")?;
            let raw_rejection = source.raw_clock_sample().err().ok_or("closed raw clock accepted a sample")?;
            let f32_rejection = source.wall_clock_f32_bits().err().ok_or("closed f32 clock accepted a sample")?;
            require(snapshot == source.process_clock_snapshot()?, "closed clock calls mutated counters or ownership")?;
            let diagnostic = app.world().non_send_resource::<Application>().diagnostic()?;
            require(diagnostic["closed"] == true, "application did not close")?;
            require(diagnostic["workers_created"] == diagnostic["workers_closed"]
                && diagnostic["workers_created"] == diagnostic["worker_completions"]
                && diagnostic["worker_failures"] == json!([]) && diagnostic["handle_failures"] == 0,
                "application retained workers or handle failures")?;
            for key in ["heap_blocks", "retained_mirrors", "critical_sections", "heap_failures", "lock_failures"] {
                require(diagnostic["crt"][key] == 0, &format!("CRT {key} did not clear"))?;
            }
            require(diagnostic["crt"]["heap_allocations"] == diagnostic["crt"]["heap_frees"],
                "CRT allocation/free counts differ")?;
            Ok(json!({"process_clock":clock_json(&snapshot),"application":diagnostic,
                "raw_handle_rejection":raw_rejection,"f32_handle_rejection":f32_rejection,
                "rejected_calls_preserved_clock_snapshot":true}))
        })();
        if let Err(e) = &closed { cleanup_errors.push(format!("closed lifetime checks: {e}")); }
        // All reports above contain values, not owners. Drop both resources in
        // App (Service + EffectClock) and the final explicit ClockHandle before
        // inspecting the independent report. No clock call follows these drops.
        drop(app);
        drop(source);
        let report_owners = std::sync::Arc::strong_count(&critical_sections);
        let section_failures: Vec<String> = critical_sections.failures().into_iter()
            .map(|failure| format!("{failure:?}")).collect();
        if report_owners != 1 {
            cleanup_errors.push(format!("critical-section Bank/Section still owns report after drops: {report_owners}"));
        }
        if !section_failures.is_empty() {
            cleanup_errors.push(format!("critical-section failure after final drops: {section_failures:?}"));
        }
        let shared_drop = json!({"app_dropped":true,"clock_handle_dropped":true,
            "critical_section_report_owners":report_owners,"critical_section_failures":section_failures,
            "bank_and_sections_retired":report_owners == 1,"direct_os_deletion_count_observed":false});
        let passed = exercise.is_ok() && cleanup_errors.is_empty();
        Ok(json!({"probe":"native-process-clock","passed":passed,"complete":false,
            "normal_application_attachment":true,"application_instances":1,"configuration":configuration,
            "exercise":exercise.as_ref().ok(),"exercise_error":exercise.as_ref().err(),"trace":trace,
            "retired_runtime":retired.as_ref().ok(),"closed":closed.as_ref().ok(),
            "shared_drop":shared_drop,
            "service_allocations_after_close":service_allocations,"cleanup_errors":cleanup_errors,
            "scope":{"canonical_windows_clock":true,"effect_plugin_frames":true,"pause_resume_delivery":"local ordered adapter",
                "loading_packet_dispatched":false,"network_packet_delivery":false,"ui_rendered":false,
                "animation_clips_played":false,"gameplay_complete":false,"fifo_contention_exercised":false}}))
    })().unwrap_or_else(|error| json!({"probe":"native-process-clock","passed":false,"complete":false,"setup_error":error}));
    let passed = report["passed"] == true;
    println!("{report}");
    assert!(passed, "native process clock probe failed; see JSON report");
}
