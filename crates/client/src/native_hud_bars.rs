//! Original local HP and mana bar elements. Trailing-loss/tip effects and non-mana resources pending.
use bevy::{prelude::*,ui_render::ui_material::MaterialNode,window::PrimaryWindow};
use crate::{native_hud_panels::Panel,native_hud_icon_material::IconMaterial,native_hud_element_storage::ElementStorage,native_zip_provider::StartupHud};
#[derive(Resource,Default)] struct Live {panels:Vec<Panel>,entities:Vec<Entity>,materials:Vec<Handle<IconMaterial>>,signature:Option<String>,error:Option<String>}
pub struct Plugin;
impl bevy::app::Plugin for Plugin {fn build(&self,app:&mut App) {app.init_resource::<Live>().add_systems(Startup,setup).add_systems(Update,update.after(crate::receive).before(crate::render_probe::capture));}}
#[derive(Debug,PartialEq)] pub struct Values {pub health:f32,pub resource:Option<f32>,pub kind:String}

pub fn values(snapshot:&openleague_core::Snapshot,id:Option<u32>)->Result<Option<Values>,String> {
 let Some(player)=snapshot.players.iter().find(|p|Some(p.id)==id) else{return Ok(None);};let data:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/champion_resources.json")).unwrap();let kind=data[&player.champion]["type"].as_str().ok_or("unknown native champion resource kind")?.to_owned();let health=crate::native_hud_pool_numbers::fraction(player.health,player.max_health,true)?;
 let resource=if kind=="Mana" {Some(crate::native_hud_pool_numbers::fraction(player.mana,player.max_mana.ok_or("authoritative resource capacity missing")?,false)?)}else{None};Ok(Some(Values {health,resource,kind}))
}
fn load(hud:&StartupHud)->Result<Vec<Panel>,String> {
 let mut panels=Vec::new();
 for layout in &hud.shadow_isles_layouts {for record in &layout.structure.accepted {let s=&record.element.storage;if s.kind()!=1 {continue;}let name=s.bytes()[..32].split(|b|*b==0).next().unwrap();
  let wanted=if layout.request.ends_with("ShadowIslesCenterHUD_BG.ini") {matches!(name,b"HUDCenterFrame"|b"HUDCenterUnderlay")}else if layout.request.ends_with("CenterHUD_HealthBar.ini") {matches!(name,b"HPBar"|b"HPBarEmpty"|b"HPBarEndCapLeft"|b"HPBarEndCapRight")}else if layout.request.ends_with("CenterHUD_PARBar.ini") {matches!(name,b"MPBar"|b"MPBarEmpty"|b"MPBarEndCapLeft"|b"MPBarEndCapRight"|b"EmptyPARBar")}else {false};
  if wanted {if s.flags()&1==0 || s.bytes()[0x204..0x214]!=s.bytes()[0x214..0x224] {return Err("native bar requires unqualified dynamic UV pair".into());}let mut storage=ElementStorage::new(1).unwrap();storage.write_bytes(0,s.bytes());panels.push(Panel {name:String::from_utf8(name.to_vec()).map_err(|_|"bar name encoding")?,path:layout.request.clone(),storage});}
 }}if panels.len()!=11 {return Err("eleven original bar/background elements missing or duplicated".into());}panels.sort_by_key(|p|p.storage.word(0x1a4));Ok(panels)
}
fn setup(hud:Res<StartupHud>,mut live:ResMut<Live>) {match load(&hud) {Ok(p)=>live.panels=p,Err(e)=>eprintln!("Native HUD bars unavailable: {e}")}}
fn clear(live:&mut Live,commands:&mut Commands,materials:&mut Assets<IconMaterial>) {for e in live.entities.drain(..) {commands.entity(e).despawn();}for m in live.materials.drain(..) {materials.remove(m.id());}live.signature=None;}
fn update(mut commands:Commands,state:Res<crate::Match>,connection:Res<crate::Connection>,window:Query<&Window,With<PrimaryWindow>>,atlases:Res<crate::native_hud_atlases::Atlases>,viewport:Res<crate::native_hud_viewport::Viewport>,mut materials:ResMut<Assets<IconMaterial>>,mut live:ResMut<Live>) {
 if live.panels.len()!=11 {return;}let result=state.snapshot.as_ref().map(|s|values(s,connection.id)).unwrap_or(Ok(None));let v=match result {Ok(Some(v))=>v,Ok(None)=>{clear(&mut live,&mut commands,&mut materials);return;},Err(e)=>{clear(&mut live,&mut commands,&mut materials);if live.error.as_ref()!=Some(&e) {eprintln!("Native bar snapshot unavailable: {e}");live.error=Some(e);}return;}};
 let Ok(window)=window.single() else{return;};let dimensions=[window.physical_width(),window.physical_height()];let dpi=window.scale_factor();let signature=format!("{:?}:{dimensions:?}:{dpi}:{}:{v:?}",connection.id,viewport.scalar.to_bits());if live.signature.as_ref()==Some(&signature) {return;}
 let result=(||->Result<Vec<(Node,IconMaterial,serde_json::Value,i32)>,String> {let mut payloads=Vec::new();for panel in &mut live.panels {
  let name=panel.name.as_str();if name.starts_with("MP") && v.resource.is_none() || name=="EmptyPARBar" && v.kind!="None" {continue;}
  if name=="HPBar" {panel.storage.set_word(0x1d0,v.health.to_bits());}if name=="MPBar" {panel.storage.set_word(0x1d0,v.resource.unwrap().to_bits());}
  let texture=panel.storage.bytes()[0x1e0..0x200].split(|b|*b==0).next().unwrap();let texture=std::str::from_utf8(texture).map_err(|_|"native bar atlas encoding")?;let suffix=format!("/{texture}.dds");let atlas=atlases.entries.iter().find(|a|a.normalized.ends_with(&suffix)).ok_or("native bar atlas unavailable")?;
  let (node,material)=crate::native_hud_panels::payload(panel,dimensions,viewport.scalar,dpi,atlas.image.clone())?;let layer=panel.storage.word(0x1a4);let record=serde_json::json!({"name":name,"path":panel.path,"layer":layer,"fraction":panel.storage.initial_fractions()[0],"uv":material.parameters.uv.to_array(),"node":format!("{:?},{:?},{:?},{:?}",node.left,node.top,node.width,node.height)});payloads.push((node,material,record,80+layer as i32));
 }Ok(payloads)})();let payloads=match result {Ok(p)=>p,Err(e)=>{clear(&mut live,&mut commands,&mut materials);if live.error.as_ref()!=Some(&e) {eprintln!("Native HUD bar render unavailable: {e}");live.error=Some(e);}return;}};
 clear(&mut live,&mut commands,&mut materials);let mut records=Vec::new();for (node,material,record,z) in payloads {records.push(record);let h=materials.add(material);live.entities.push(commands.spawn((node,MaterialNode(h.clone()),GlobalZIndex(z),Name::new("NativeMap10HudBar"))).id());live.materials.push(h);}live.signature=Some(signature);live.error=None;
 if let Ok(path)=std::env::var("OPENLEAGUE_NATIVE_HUD_BARS_TRACE") {let report=serde_json::json!({"complete":false,"player":connection.id,"health_fraction":v.health,"resource_fraction":v.resource,"resource_kind":v.kind,"elements":records,"entities":live.entities.len(),"materials":live.materials.len(),"limits":["Current HP and mana fill, empty fields, end caps and center background only. Native positive finite rounded-pool ratios integrated; tip/lost-health interpolation, highlights and shields pending.","Energy and other non-mana resources not rendered as mana. Original projection/gamma/sampler/final framebuffer equivalence open."]});if let Err(e)=std::fs::write(path,serde_json::to_vec_pretty(&report).unwrap()) {eprintln!("Native HUD bar trace failed: {e}");}}
}
#[cfg(test)] mod tests {
 use super::*;
 #[test] fn original_bar_fill_clips_geometry_and_uv_together_for_empty_partial_and_full_state() {
  let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");let mut provider=crate::native_zip_provider::Provider::from_catalog(&root).unwrap();let hud=provider.startup_hud(&root).unwrap();let panels=load(&hud).unwrap();assert_eq!(panels.len(),11);
  for name in ["HPBar","MPBar"] {let source=panels.iter().find(|p|p.name==name).unwrap();let mut storage=ElementStorage::new(1).unwrap();storage.write_bytes(0,source.storage.bytes());let mut p=Panel {name:name.into(),path:source.path.clone(),storage};let (_,full)=crate::native_hud_panels::payload(&p,[1280,800],1.0,1.0,Handle::default()).unwrap();for fraction in [0.0f32,0.25,0.5,1.0] {p.storage.set_word(0x1d0,fraction.to_bits());let (_,partial)=crate::native_hud_panels::payload(&p,[1280,800],1.0,1.0,Handle::default()).unwrap();assert_eq!(partial.parameters.uv.x,full.parameters.uv.x);assert_eq!(partial.parameters.uv.z,(full.parameters.uv.z-full.parameters.uv.x)*fraction+full.parameters.uv.x);}}
  assert!(crate::native_hud_pool_numbers::fraction(f32::NAN,1.0,true).is_err());assert!(crate::native_hud_pool_numbers::fraction(1.0,0.0,true).is_err());
 }
}
