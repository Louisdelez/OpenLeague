//! Opt-in render-world measurements; these do not assert framebuffer fidelity.
use bevy::{prelude::*, render::{extract_resource::{ExtractResource, ExtractResourcePlugin},
    render_resource::{CachedPipelineState, PipelineCache}, renderer::RenderGraph, RenderApp,
    sync_world::MainEntity}, pbr::SpecializedMaterialPipelineCache,
    core_pipeline::schedule::camera_driver};
#[derive(Resource, Clone, Default, ExtractResource)]
struct Frame { path:Option<std::path::PathBuf>, time:f64, draws:Vec<(Entity,bool,u32)> }
#[derive(Resource, Default)]
struct Measurements { rows:Vec<serde_json::Value>, had_draws:bool }
pub struct Plugin;
impl bevy::prelude::Plugin for Plugin {
    fn build(&self, app:&mut App) {
        let Some(path)=std::env::var_os("OPENLEAGUE_PROJECTED_PIPELINE_PROBE").map(std::path::PathBuf::from)
            .filter(|p|p.parent()==Some(std::path::Path::new("E:/OpenLeague/logs"))) else{return;};
        app.insert_resource(Frame{path:Some(path),..default()})
            .add_plugins(ExtractResourcePlugin::<Frame>::default())
            .add_systems(PostUpdate, extract_frame.after(bevy::camera::visibility::VisibilitySystems::CheckVisibility));
        app.sub_app_mut(RenderApp).init_resource::<Measurements>()
            .add_systems(RenderGraph, measure.before(camera_driver));
    }
}
fn extract_frame(time:Res<Time>, query:Query<(Entity,&ViewVisibility,&MeshMaterial3d<crate::projected_render::ProjectedMaterial>),With<crate::projected_live::ProjectedDraw>>,
    materials:Res<Assets<crate::projected_render::ProjectedMaterial>>,mut frame:ResMut<Frame>) {
    frame.time=time.elapsed_secs_f64();
    frame.draws=query.iter().map(|(entity,visibility,handle)|
        (entity,visibility.get(),materials.get(handle.id()).map_or(0,|m|m.visibility_ready))).collect();
}
fn measure(frame:Option<Res<Frame>>, pipelines:Res<SpecializedMaterialPipelineCache>, cache:Res<PipelineCache>,mut measurements:ResMut<Measurements>) {
    let Some(frame)=frame else{return;};
    if frame.draws.is_empty() && !measurements.had_draws{return;}
    let draws:Vec<_>=frame.draws.iter().map(|(entity,visible,fow_ready)|{
        let states:Vec<_>=pipelines.values().filter_map(|view|view.get(&MainEntity::from(*entity))).map(|id|{
            match cache.get_render_pipeline_state(*id) {
                CachedPipelineState::Ok(_)=>"ready".to_owned(),
                CachedPipelineState::Queued=>"queued".to_owned(),
                CachedPipelineState::Creating(_)=>"creating".to_owned(),
                CachedPipelineState::Err(error)=>format!("error: {error:?}"),
            }
        }).collect();
        serde_json::json!({"entity":format!("{entity:?}"),"view_visible":visible,"fow_ready":fow_ready,"pipeline_states":states})
    }).collect();
    measurements.rows.push(serde_json::json!({"time":frame.time,"draws":draws}));
    measurements.had_draws=!frame.draws.is_empty();
    if let Some(path)=&frame.path {
        let report=serde_json::json!({"complete":false,"render_world_measurement":true,"before_camera_driver":true,"frames":measurements.rows,"limits":["Pipeline availability and material binding are measured before the camera draw; they do not prove fragment contribution, native receiver fidelity or original pixels."]});
        if let Err(error)=std::fs::write(path,serde_json::to_vec_pretty(&report).unwrap()){warn!("Projected pipeline measurement: {error}");}
    }
}
