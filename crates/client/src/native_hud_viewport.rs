//! Qualified owner dimensions/scalar; Bevy window is OpenLeague's dimension supplier.
//! Full original resize/resource lifecycle and settings overrides remain separate.
use bevy::{prelude::*,window::PrimaryWindow};
#[derive(Resource)]
pub struct Viewport { pub dimensions:Option<(u32,u32)>,pub scalar:f32 }
impl Default for Viewport {
    fn default()->Self {Self {dimensions:None,scalar:f32::from_bits(0x3f800000)}}
}
pub struct Plugin;
impl bevy::app::Plugin for Plugin {
    fn build(&self,app:&mut App) {app.init_resource::<Viewport>().add_systems(Update,refresh);}
}
fn refresh(windows:Query<&Window,With<PrimaryWindow>>,mut viewport:ResMut<Viewport>,mut hud:ResMut<crate::native_zip_provider::StartupHud>) {
    let Ok(window)=windows.single() else {return};
    let dimensions=(window.physical_width(),window.physical_height());
    if dimensions.0==0 || dimensions.1==0 || viewport.dimensions==Some(dimensions) {return;}
    // Engine integration: invalidate derived bounds when the supplied dimensions change.
    // This is not a claim that the original cache/resource lifecycle has been ported.
    if viewport.dimensions.is_some() {
        for group in hud.shadow_isles_groups.groups.values_mut() {if !group.members.is_empty() {group.flags|=2;}}
    }
    match hud.refresh_bounds(dimensions.0,dimensions.1,viewport.scalar) {
        Ok(count)=> {
            viewport.dimensions=Some(dimensions);
            eprintln!("Native HUD viewport physical={}x{} scalar={} refreshed={} groups={} dimension_supplier=bevy_window widgets=false",dimensions.0,dimensions.1,viewport.scalar,count,hud.shadow_isles_groups.groups.len());
        }
        Err(error)=>eprintln!("Native HUD viewport refresh failed: {error}"),
    }
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn native_owner_scalar_and_twelve_dimension_transfers_match() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_viewport_transfer_contract.json")).unwrap();
        assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],12);
        let owner=Viewport::default();assert!(owner.dimensions.is_none());
        for case in proof["cases"].as_array().unwrap() {
            assert_eq!(case["scalar_bits"].as_u64().unwrap() as u32,owner.scalar.to_bits());
            assert_eq!(case["element_width"],case["width"]);assert_eq!(case["group_width"],case["width"]);
            assert_eq!(case["element_height"],case["height"]);assert_eq!(case["group_height"],case["height"]);
        }
    }
    #[test] fn actual_window_change_refreshes_source_groups_then_reuses_bounds() {
        let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");
        let mut provider=crate::native_zip_provider::Provider::from_catalog(&root).unwrap();
        let hud=provider.startup_hud(&root).unwrap();
        let mut app=App::new();app.insert_resource(hud).add_plugins(Plugin);
        let entity=app.world_mut().spawn((Window {resolution:(1280,800).into(),..default()},PrimaryWindow)).id();
        app.update();assert_eq!(app.world().resource::<Viewport>().dimensions,Some((1280,800)));
        app.world_mut().entity_mut(entity).get_mut::<Window>().unwrap().resolution.set_physical_resolution(1920,1080);
        app.update();assert_eq!(app.world().resource::<Viewport>().dimensions,Some((1920,1080)));
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_group_bounds_contract.json")).unwrap();
        let hud=app.world().resource::<crate::native_zip_provider::StartupHud>();
        for case in proof["cases"].as_array().unwrap().iter().filter(|c|c["width"]==1920 && c["height"]==1080 && c["owner_scalar_bits"]==1f32.to_bits() && c["dirty"]==true && c["initial_bits"][0]==0x7f7fffffu32) {
            let id=hud.shadow_isles_groups.lookup(case["group"].as_str().unwrap().as_bytes()).unwrap().unwrap();
            assert_eq!(hud.shadow_isles_groups.groups[&id].bounds.to_vec(),case["output_bits"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect::<Vec<_>>());
        }
        assert_eq!(app.world_mut().resource_mut::<crate::native_zip_provider::StartupHud>().refresh_bounds(1920,1080,1.0).unwrap(),0);
        app.update();
    }
}
