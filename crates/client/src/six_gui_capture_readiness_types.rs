//! Shared source-stage ABI for a readonly capture resource barrier.
//! Resource readiness, phase membership, DrawMaterial success and pixels differ.
use bevy::{prelude::*,asset::AssetId,camera::NormalizedRenderTarget,mesh::skinning::SkinnedMeshInverseBindposes};
use super::materials::StandardSource;

#[derive(Clone,Copy,Debug,PartialEq,Eq)]
pub(crate) struct Owner {pub pid:u32,pub session:u64,pub player:u32,pub epoch:Option<u64>}
#[derive(Clone,Debug,PartialEq)]
pub(crate) struct Scope {
    pub owner:Owner,pub team:u8,pub window:Entity,pub camera:Entity,
    pub target:NormalizedRenderTarget,pub model_root:Entity,pub map_root:Entity,
    pub model:AssetId<Gltf>,pub map:AssetId<Gltf>,
    pub model_scene:AssetId<bevy::world_serialization::WorldAsset>,pub map_scene:AssetId<bevy::world_serialization::WorldAsset>,
    pub model_instance:bevy::world_serialization::InstanceId,pub map_instance:bevy::world_serialization::InstanceId,
    // Global scene FoW output obligation, distinct from any material binding.
    pub visibility_output:AssetId<Image>,
}
#[derive(Clone,Copy,Debug,PartialEq,Eq)]
// Terrain means the visible MapRoot mesh census, including embedded sprites;
// it is not a semantic/native TerrainMaterial or fidelity qualification.
pub(crate) enum MeshRole {LocalModel,Terrain}
#[derive(Clone,Copy,Debug,PartialEq,Eq)]
pub(crate) enum MeshMaterial {
    Fog(AssetId<crate::map_fog::FogMaterial>),
    Terrain(AssetId<crate::terrain_material::TerrainMaterial>),
    Standard(AssetId<StandardMaterial>),
}
#[derive(Clone,Debug,PartialEq,Eq)]
pub(crate) struct Skin {pub inverse:AssetId<SkinnedMeshInverseBindposes>,pub joints:Vec<Entity>}
#[derive(Clone,Debug,PartialEq,Eq)]
pub(crate) struct MeshTicket {
    pub role:MeshRole,pub draw:Entity,pub mesh:AssetId<Mesh>,pub material:MeshMaterial,
    pub images:Vec<AssetId<Image>>,pub native_visibility:Option<AssetId<Image>>,pub skin:Option<Skin>,
    // Some only for exact existing GLTF Standard provenance. Its shader does
    // not bind Native FoW. No texture repair, shadow or native pass is inferred.
    pub standard_source:Option<StandardSource>,
}
#[derive(Clone,Copy,Debug,PartialEq,Eq)]
pub(crate) enum UiRole {Frame,Portrait,Glyph}
#[derive(Clone,Copy,Debug,PartialEq,Eq)]
pub(crate) enum UiMaterial {
    Icon(AssetId<crate::native_hud_icon_material::IconMaterial>),
    Font(AssetId<crate::native_font_material::FontMaterial>),
}
#[derive(Clone,Debug,PartialEq,Eq)]
pub(crate) struct UiTicket {pub role:UiRole,pub draw:Entity,pub material:UiMaterial,pub images:Vec<AssetId<Image>>}
#[derive(Resource,Clone,Default,bevy::render::extract_resource::ExtractResource)]
pub(crate) struct Frame {
    pub serial:u64,pub source_tick:Option<u64>,pub scope:Option<Scope>,
    pub missing:Vec<String>,pub meshes:Vec<MeshTicket>,pub ui:Vec<UiTicket>,
}
#[derive(Clone,Debug)]
pub(crate) struct GpuReport {
    pub serial:u64,pub scope:Scope,pub meshes:Vec<MeshTicket>,pub ui:Vec<UiTicket>,
    pub missing:Vec<String>,pub observations:serde_json::Value,
    // Never set these true from a resource/cache/item observation.
    pub draw_material_success_observed:bool,pub visible_pixels_qualified:bool,
}
#[derive(Resource,Clone,Default)]
pub(crate) struct Shared(pub std::sync::Arc<std::sync::Mutex<Option<GpuReport>>>);

pub(crate) fn fresh(current:u64,witness:u64)->bool {
    // Bevy 0.19 waits for the preceding RenderApp before extraction, then
    // renders the extracted frame in parallel with the next Main schedule.
    // Collect advances once in PostUpdate. That Main schedule may finish
    // Collect before the outstanding RenderGraph publishes its report, so
    // the bridge can still expose the report preceding that extraction:
    // current CPU serial N+1 versus completed render serial N-1.
    // Two source serials are the bound, not a wall-clock grace period. An
    // absent, future or older report remains unavailable; all identities and
    // exact ticket vectors are still compared by compatible/current_missing.
    witness>0&&witness<=current&&current-witness<=2
}
pub(crate) fn compatible(frame:&Frame,report:&GpuReport)->bool {
    frame.scope.as_ref()==Some(&report.scope)&&frame.meshes==report.meshes&&frame.ui==report.ui
        // Explicit source-generation freshness; this is not a waiting delay.
        // One outstanding render plus one PostUpdate collection permits two serials.
        &&fresh(frame.serial,report.serial)
}
#[cfg(test)]mod tests {
    use super::*;
    #[test]fn six_gui_capture_missing_GPU_report_is_not_resource_ready(){
        let shared=Shared::default();assert!(shared.0.lock().unwrap().is_none());
    }
    #[test]fn six_gui_capture_default_frame_has_no_fabricated_scope_or_draw(){
        let frame=Frame::default();assert!(frame.scope.is_none());assert!(frame.meshes.is_empty());
        assert!(frame.ui.is_empty());assert_eq!(frame.serial,0);
    }
    #[test]fn six_gui_capture_generation_freshness_rejects_absent_future_and_stopped_render_witness(){
        assert!(fresh(20,20));assert!(fresh(20,19));assert!(fresh(20,18));assert!(!fresh(20,17));
        assert!(!fresh(20,21));assert!(!fresh(0,0));assert!(!fresh(u64::MAX,1));
    }
    #[test]fn six_gui_capture_two_serial_bridge_keeps_owner_scope_and_ticket_vectors_exact(){
        // Pure equality fixtures, not a real renderer, accepted owner or scene.
        let mut world=World::new();let window=world.spawn_empty().id();
        let camera=world.spawn_empty().id();let model_root=world.spawn_empty().id();
        let map_root=world.spawn_empty().id();let draw=world.spawn_empty().id();
        let mut instances=bevy::world_serialization::WorldInstanceSpawner::default();
        // Queuing creates opaque IDs only; these fixture scenes are never spawned.
        let model_instance=instances.spawn(Handle::<bevy::world_serialization::WorldAsset>::default());
        let map_instance=instances.spawn(Handle::<bevy::world_serialization::WorldAsset>::default());
        let scope=Scope {owner:Owner {pid:7,session:11,player:21,epoch:Some(2)},team:0,
            window,camera,target:bevy::camera::RenderTarget::Window(bevy::window::WindowRef::Entity(window)).normalize(Some(window)).unwrap(),
            model_root,map_root,model:Handle::<Gltf>::default().id(),map:Handle::<Gltf>::default().id(),
            model_scene:Handle::<bevy::world_serialization::WorldAsset>::default().id(),
            map_scene:Handle::<bevy::world_serialization::WorldAsset>::default().id(),model_instance,map_instance,
            visibility_output:Handle::<Image>::default().id()};
        let ticket=MeshTicket {role:MeshRole::LocalModel,draw,mesh:Handle::<Mesh>::default().id(),
            material:MeshMaterial::Fog(Handle::<crate::map_fog::FogMaterial>::default().id()),
            images:vec![Handle::<Image>::default().id()],native_visibility:Some(Handle::<Image>::default().id()),skin:None,standard_source:None};
        let frame=Frame {serial:20,scope:Some(scope.clone()),meshes:vec![ticket.clone()],..Default::default()};
        let report=GpuReport {serial:18,scope,meshes:vec![ticket],ui:vec![],missing:vec![],observations:serde_json::Value::Null,
            draw_material_success_observed:false,visible_pixels_qualified:false};
        assert!(compatible(&frame,&report));
        for field in 0..11 {
            let mut wrong=report.clone();match field {
                0=>wrong.scope.owner.pid+=1,1=>wrong.scope.owner.session+=1,
                2=>wrong.scope.owner.player+=1,3=>wrong.scope.owner.epoch=Some(3),
                4=>wrong.scope.team=1,5=>wrong.scope.window=draw,6=>wrong.scope.camera=draw,
                7=>wrong.scope.model_root=draw,8=>wrong.scope.map_root=draw,
                9=>wrong.scope.model_instance=wrong.scope.map_instance,
                _=>wrong.scope.target=bevy::camera::RenderTarget::Window(bevy::window::WindowRef::Entity(draw)).normalize(Some(draw)).unwrap(),
            }assert!(!compatible(&frame,&wrong),"foreign owner/scope alias {field}");
        }
        let mut wrong=report.clone();wrong.meshes[0].draw=camera;assert!(!compatible(&frame,&wrong));
        wrong=report.clone();wrong.meshes[0].images.clear();assert!(!compatible(&frame,&wrong));
        wrong=report.clone();wrong.meshes[0].native_visibility=None;assert!(!compatible(&frame,&wrong));
        let mut outputs=Assets::<Image>::default();let foreign_output=outputs.add(Image::default());
        wrong=report.clone();wrong.scope.visibility_output=foreign_output.id();assert!(!compatible(&frame,&wrong));
        wrong=report.clone();wrong.meshes[0].role=MeshRole::Terrain;assert!(!compatible(&frame,&wrong));
        wrong=report.clone();wrong.ui.push(UiTicket {role:UiRole::Glyph,draw,
            material:UiMaterial::Font(Handle::<crate::native_font_material::FontMaterial>::default().id()),images:vec![]});
        assert!(!compatible(&frame,&wrong));
        wrong=report.clone();wrong.serial=17;assert!(!compatible(&frame,&wrong));
        wrong=report.clone();wrong.serial=21;assert!(!compatible(&frame,&wrong));
        wrong=report;wrong.serial=0;assert!(!compatible(&frame,&wrong));
    }
}
