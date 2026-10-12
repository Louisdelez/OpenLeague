//! Original base portraits for122 champions; source Portrait widget and authoritative selection.
//! Native AvatarImage producer, skin/form/death variants and framebuffer identity remain open.
use bevy::{prelude::*,image::CompressedImageFormats,render::renderer::RenderDevice,ui_render::ui_material::MaterialNode,window::PrimaryWindow};
use crate::{native_zip_provider::StartupHud,native_hud_panels::Panel,native_hud_icon_material::IconMaterial,native_hud_element_storage::ElementStorage};
struct Icon {image:Handle<Image>,asset:String}
#[derive(Resource,Default)] struct Live {panel:Option<Panel>,icons:std::collections::BTreeMap<String,Icon>,signature:Option<String>,entity:Option<Entity>,material:Option<Handle<IconMaterial>>}
pub struct Plugin;
impl bevy::app::Plugin for Plugin {fn build(&self,app:&mut App) {app.init_resource::<Live>().add_systems(Startup,setup).add_systems(Update,update.after(crate::receive).before(crate::render_probe::capture));}}
fn source_panel(hud:&StartupHud)->Result<Panel,String> {
 let mut result=None;
 for layout in &hud.shadow_isles_layouts {if !layout.request.ends_with("ShadowIslesChampionLeft.ini") {continue;}
  for record in &layout.structure.accepted {let s=&record.element.storage;if s.kind()==1 && s.bytes()[..32].split(|b|*b==0).next().unwrap()==b"Portrait" {
   if result.is_some() || s.flags()&1==0 || s.bytes()[0x1e0..0x200].split(|b|*b==0).next().unwrap()!=b"AvatarImage" || s.bytes()[0x204..0x214]!=s.bytes()[0x214..0x224] {return Err("native portrait widget invalid or duplicated".into());}
   let mut storage=ElementStorage::new(1).unwrap();storage.write_bytes(0,s.bytes());result=Some(Panel {name:"Portrait".into(),path:layout.request.clone(),storage});
  }}
 }result.ok_or("native Portrait widget missing".into())
}
fn setup(hud:Res<StartupHud>,device:Res<RenderDevice>,mut images:ResMut<Assets<Image>>,mut live:ResMut<Live>) {
 match source_panel(&hud) {Ok(p)=>live.panel=Some(p),Err(e)=>{eprintln!("Native portraits unavailable: {e}");return;}}
 let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");let manifest:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_champion_portraits.json")).unwrap();
 for entry in manifest["entries"].as_array().unwrap() {
  let id=entry["id"].as_str().unwrap();let asset=entry["asset"].as_str().unwrap();
  match std::fs::read(root.join("assets").join(asset)).map_err(|e|e.to_string()).and_then(|bytes|crate::native_hud_atlases::decode(&bytes,CompressedImageFormats::from_features(device.features())).map_err(|e|e.to_string())) {
   Ok(image)=>{live.icons.insert(id.into(),Icon {image:images.add(image),asset:asset.into()});},Err(e)=>eprintln!("Native champion portrait unavailable id={id}: {e}")
  }
 }eprintln!("Native base champion portraits loaded={} expected=122 full_portrait_variants=false",live.icons.len());
}
pub fn selected(snapshot:&openleague_core::Snapshot,id:Option<u32>)->Option<&str> {snapshot.players.iter().find(|p|Some(p.id)==id).map(|p|p.champion.as_str())}
fn clear(live:&mut Live,commands:&mut Commands,materials:&mut Assets<IconMaterial>) {if let Some(e)=live.entity.take() {commands.entity(e).despawn();}if let Some(m)=live.material.take() {materials.remove(m.id());}live.signature=None;}
fn update(mut commands:Commands,state:Res<crate::Match>,connection:Res<crate::Connection>,window:Query<&Window,With<PrimaryWindow>>,viewport:Res<crate::native_hud_viewport::Viewport>,mut materials:ResMut<Assets<IconMaterial>>,mut live:ResMut<Live>) {
 let Some(champion)=state.snapshot.as_ref().and_then(|s|selected(s,connection.id)) else {clear(&mut live,&mut commands,&mut materials);return;};
 let Some(icon)=live.icons.get(champion) else {clear(&mut live,&mut commands,&mut materials);return;};let texture=icon.image.clone();let asset=icon.asset.clone();let Some(panel)=&live.panel else{return;};let Ok(window)=window.single() else{return;};let dimensions=[window.physical_width(),window.physical_height()];let dpi=window.scale_factor();let signature=format!("{:?}:{champion}:{dimensions:?}:{dpi}:{}",connection.id,viewport.scalar.to_bits());if live.signature.as_ref()==Some(&signature) {return;}
 let (node,material)=match crate::native_hud_panels::payload(panel,dimensions,viewport.scalar,dpi,texture) {Ok(p)=>p,Err(e)=>{eprintln!("Native portrait render unavailable: {e}");clear(&mut live,&mut commands,&mut materials);return;}};
 let source_layer=panel.storage.word(0x1a4);let record=serde_json::json!({"complete":false,"player":connection.id,"champion":champion,"asset":asset,"loaded_base_portraits":live.icons.len(),"source_widget":"Portrait","source_texture":"AvatarImage","source_layer":source_layer,"mode":material.parameters.mode.x,"uv":material.parameters.uv.to_array(),"node":format!("{:?},{:?},{:?},{:?}",node.left,node.top,node.width,node.height),"viewport":dimensions,"dpi":dpi,"limits":["Original base portrait selected by authoritative champion id; native AvatarImage producer, alternate skins/forms, death tint, projection/sampler/gamma and original framebuffer equivalence pending."]});
 clear(&mut live,&mut commands,&mut materials);let handle=materials.add(material);live.entity=Some(commands.spawn((node,MaterialNode(handle.clone()),GlobalZIndex(80+source_layer as i32),Name::new("NativeMap10ChampionPortrait"))).id());live.material=Some(handle);live.signature=Some(signature);
 if let Ok(path)=std::env::var("OPENLEAGUE_NATIVE_HUD_PORTRAIT_TRACE") {if let Err(e)=std::fs::write(path,serde_json::to_vec_pretty(&record).unwrap()) {eprintln!("Native portrait trace failed: {e}");}}
}
#[cfg(test)] mod tests {
 use super::*;
 #[test] fn all122_native_portrait_dds_payloads_and_original_widget_survive_decode_and_transport() {
  let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");let mut provider=crate::native_zip_provider::Provider::from_catalog(&root).unwrap();let hud=provider.startup_hud(&root).unwrap();let panel=source_panel(&hud).unwrap();assert_eq!(panel.storage.word(0x1a4),1);assert_eq!(panel.storage.word(0x224),0);
  let manifest:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_champion_portraits.json")).unwrap();assert_eq!(manifest["count"],122);let mut ids=std::collections::BTreeSet::new();
  for entry in manifest["entries"].as_array().unwrap() {assert!(ids.insert(entry["id"].as_str().unwrap()));assert_eq!(entry["field_hash"],3606610482u64);let bytes=std::fs::read(root.join("assets").join(entry["asset"].as_str().unwrap())).unwrap();let image=crate::native_hud_atlases::decode(&bytes,CompressedImageFormats::BC).unwrap();assert_eq!(image.data.as_deref(),Some(&bytes[128..]));assert_eq!(image.texture_descriptor.size.width,120);assert_eq!(image.texture_descriptor.size.height,120);let (_,material)=crate::native_hud_panels::payload(&panel,[1280,800],1.0,1.0,Handle::default()).unwrap();assert_eq!(material.parameters.mode.x,1.0);assert_eq!(material.parameters.uv,Vec4::new(0.0,0.0,1.0,1.0));}
 }
 #[test] fn portrait_selection_tracks_authoritative_local_player_and_clears_on_missing_player() {
  let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");let navigation=openleague_core::Navigation::load(&std::fs::read_to_string(root.join("assets/maps/tt_navigation_grid.json")).unwrap(),&std::fs::read(root.join("assets/maps/tt_navigation_grid.cells.bin")).unwrap()).unwrap();let mut simulation=openleague_core::Simulation::new(navigation).unwrap();let a=simulation.join("garen").unwrap();let b=simulation.join("ahri").unwrap();let snapshot=simulation.snapshot();assert_eq!(selected(&snapshot,Some(a)),Some("garen"));assert_eq!(selected(&snapshot,Some(b)),Some("ahri"));assert_eq!(selected(&snapshot,None),None);assert_eq!(selected(&snapshot,Some(u32::MAX)),None);
 }
}
