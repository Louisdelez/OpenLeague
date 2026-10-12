//! Release stale surface references when camera extraction is disabled by a zero-sized window.
use bevy::{prelude::*, render::{Render, RenderApp, RenderSystems,
    camera::ExtractedCamera, view::{ViewTarget, window::create_surfaces}}};
pub struct Plugin;
impl bevy::prelude::Plugin for Plugin {
    fn build(&self, app: &mut App) {
        if let Some(render_app) = app.get_sub_app_mut(RenderApp) {
            render_app.add_systems(Render, release_orphan_targets
                .in_set(RenderSystems::PrepareViews).before(create_surfaces));
        }
    }
}
// Bevy removes ExtractedCamera at target size zero. Its resize cleanup queries
// (ExtractedCamera, ViewTarget), so it misses these retained targets. Drop their
// swap-chain views before DX12 reconfiguration; normal cameras recreate targets.
fn release_orphan_targets(mut commands: Commands,
    targets: Query<Entity, (With<ViewTarget>, Without<ExtractedCamera>)>) {
    for entity in &targets { commands.entity(entity).remove::<ViewTarget>(); }
}
