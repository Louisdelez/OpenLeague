from pathlib import Path
import shutil,datetime
r=Path('E:/OpenLeague');p=r/'crates/client/src/main.rs';h=r/'docs/plan_history'/('xp-hud-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));h.mkdir(parents=True);shutil.copy2(p,h/p.name)
source=r'''//! Original map10 XP fill/overlay/endcaps, driven by authoritative experience and native curve.
use bevy::{prelude::*,ui_render::ui_material::MaterialNode,window::PrimaryWindow};
use crate::{native_hud_panels::Panel,native_hud_icon_material::IconMaterial,native_hud_element_storage::ElementStorage,native_zip_provider::StartupHud};
#[derive(Resource,Default)] struct Live {panels:Vec<Panel>,entities:Vec<Entity>,materials:Vec<Handle<IconMaterial>>,signature:Option<String>,error:Option<String>}
pub struct Plugin;
impl bevy::app::Plugin for Plugin {fn build(&self,app:&mut App) {app.init_resource::<Live>().add_systems(Startup,setup).add_systems(Update,update.after(crate::receive));}}
fn fraction(current:f32,needed:f32,maximum_level:bool)->Result<f32,String> {
 if !current.is_finite() || !needed.is_finite() || needed<=0.0 {return Err("invalid authoritative XP interval".into());}
 Ok(if maximum_level {1.0}else {current.max(0.0).min(needed)/needed})
}
fn threshold(level:u8)->Result<f32,String> {
 if level==1 {return Ok(0.0);}
 static CURVE:std::sync::OnceLock<serde_json::Value>=std::sync::OnceLock::new();
 let data=CURVE.get_or_init(||serde_json::from_str(include_str!("../../../data/4.20/experience_curve_map10.json")).expect("native map10 curve"));let v=&data["Values"]["EXP"][format!("Level{level}")];
 let n=v.as_f64().map(|v|v as f32).or_else(||v.as_str().and_then(|v|v.parse::<f32>().ok())).ok_or("native XP threshold missing")?;
 if !n.is_finite() || n<0.0 {return Err("invalid native XP threshold".into());}Ok(n)
}
pub fn value(snapshot:&openleague_core::Snapshot,id:Option<u32>)->Result<Option<f32>,String> {
 let Some(player)=snapshot.players.iter().find(|p|Some(p.id)==id) else{return Ok(None);};
 if !(1..=18).contains(&player.level) || !player.experience.is_finite() || player.experience<0.0 {return Err("invalid authoritative experience or level".into());}
 if player.level==18 {return Ok(Some(1.0));}
 let previous=threshold(player.level)?;let next=threshold(player.level+1)?;fraction(player.experience-previous,next-previous,false).map(Some)
}
fn load(hud:&StartupHud)->Result<Vec<Panel>,String> {
 let mut panels=Vec::new();for layout in &hud.shadow_isles_layouts {if !layout.request.ends_with("ShadowIslesChampionLeft.ini") {continue;}
 for record in &layout.structure.accepted {let s=&record.element.storage;if s.kind()!=1 {continue;}let name=s.bytes()[..32].split(|b|*b==0).next().unwrap();if !matches!(name,b"XPBar"|b"XPBarOverlay"|b"XPBarEndCapLeft"|b"XPBarEndCapRight") {continue;}
 if s.flags()&1==0 || s.bytes()[0x204..0x214]!=s.bytes()[0x214..0x224] {return Err("XP element requires unqualified source state".into());}
 let mut storage=ElementStorage::new(1).unwrap();storage.write_bytes(0,s.bytes());panels.push(Panel {name:String::from_utf8(name.to_vec()).map_err(|_|"XP name encoding")?,path:layout.request.clone(),storage});
 }}if panels.len()!=4 {return Err("four original XP elements missing or duplicated".into());}panels.sort_by_key(|p|p.storage.word(0x1a4));Ok(panels)
}
fn setup(hud:Res<StartupHud>,mut live:ResMut<Live>) {match load(&hud) {Ok(p)=>live.panels=p,Err(e)=>eprintln!("Native XP HUD unavailable: {e}")}}
fn clear(live:&mut Live,commands:&mut Commands,materials:&mut Assets<IconMaterial>) {for e in live.entities.drain(..) {commands.entity(e).despawn();}for m in live.materials.drain(..) {materials.remove(m.id());}live.signature=None;}
fn update(mut commands:Commands,state:Res<crate::Match>,connection:Res<crate::Connection>,window:Query<&Window,With<PrimaryWindow>>,atlases:Res<crate::native_hud_atlases::Atlases>,viewport:Res<crate::native_hud_viewport::Viewport>,mut materials:ResMut<Assets<IconMaterial>>,mut live:ResMut<Live>) {
 if live.panels.len()!=4 {return;}
 let v=match state.snapshot.as_ref().map(|s|value(s,connection.id)).unwrap_or(Ok(None)) {Ok(Some(v))=>v,Ok(None)=>{clear(&mut live,&mut commands,&mut materials);return;},Err(e)=>{clear(&mut live,&mut commands,&mut materials);if live.error.as_ref()!=Some(&e) {eprintln!("Native XP HUD value unavailable: {e}");live.error=Some(e);}return;}};
 let Ok(window)=window.single() else{return;};let dimensions=[window.physical_width(),window.physical_height()];let dpi=window.scale_factor();let signature=format!("{:?}:{dimensions:?}:{dpi}:{}:{}",connection.id,viewport.scalar.to_bits(),v.to_bits());if live.signature.as_ref()==Some(&signature) {return;}
 let result=(||->Result<Vec<(Node,IconMaterial,serde_json::Value,i32)>,String> {
 let mut payloads=Vec::new();for panel in &mut live.panels {
 if panel.name=="XPBar" {panel.storage.set_word(0x1d0,v.to_bits());}
 let texture=std::str::from_utf8(panel.storage.bytes()[0x1e0..0x200].split(|b|*b==0).next().unwrap()).map_err(|_|"XP atlas encoding")?;let suffix=format!("/{texture}.dds");let atlas=atlases.entries.iter().find(|a|a.normalized.ends_with(&suffix)).ok_or("native XP atlas unavailable")?;
 let (node,material)=crate::native_hud_panels::payload(panel,dimensions,viewport.scalar,dpi,atlas.image.clone())?;let layer=panel.storage.word(0x1a4);let record=serde_json::json!({"name":panel.name,"path":panel.path,"flags":panel.storage.flags(),"layer":layer,"fraction":panel.storage.initial_fractions()[0],"uv":material.parameters.uv.to_array(),"node":format!("{:?},{:?},{:?},{:?}",node.left,node.top,node.width,node.height)});payloads.push((node,material,record,80+layer as i32));
 }Ok(payloads)})();
 let payloads=match result {Ok(p)=>p,Err(e)=>{clear(&mut live,&mut commands,&mut materials);if live.error.as_ref()!=Some(&e) {eprintln!("Native XP HUD render unavailable: {e}");live.error=Some(e);}return;}};
 clear(&mut live,&mut commands,&mut materials);let mut records=Vec::new();for (node,material,record,z) in payloads {records.push(record);let h=materials.add(material);live.entities.push(commands.spawn((node,MaterialNode(h.clone()),GlobalZIndex(z),Name::new("NativeMap10HudExperience"))).id());live.materials.push(h);}live.signature=Some(signature);live.error=None;
 if let Ok(path)=std::env::var("OPENLEAGUE_NATIVE_HUD_XP_TRACE") {let report=serde_json::json!({"complete":false,"fraction":v,"player":connection.id,"entities":live.entities.len(),"elements":records,"limits":["Native ordinary clamp/division and maximum-level fraction qualified; server map10 curve drives progression. Original accessor/cap producer and whole framebuffer identity remain open.","Highlight/level-up effects, XP tooltip/input, graphical gains and transitions still require qualification."]});if let Err(e)=std::fs::write(path,serde_json::to_vec_pretty(&report).unwrap()) {eprintln!("Native XP HUD trace failed: {e}");}}
}
#[cfg(test)] mod tests {
 use super::*;
 #[test] fn original_xp_fraction_matches_every_executed_native_case() {
 let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_experience_contract.json")).unwrap();assert_eq!(p["case_count"],64);for c in p["cases"].as_array().unwrap() {assert_eq!(fraction(c["current_level_experience_f32"].as_f64().unwrap() as f32,c["needed_f32"].as_f64().unwrap() as f32,c["maximum_level"].as_bool().unwrap()).unwrap().to_bits(),c["fraction_bits"].as_u64().unwrap() as u32);}
 }
 #[test] fn native_xp_elements_and_real_progression_snapshots_cover_boundary_reset_and_cap() {
 let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");let mut provider=crate::native_zip_provider::Provider::from_catalog(&root).unwrap();let hud=provider.startup_hud(&root).unwrap();let panels=load(&hud).unwrap();assert_eq!(panels.len(),4);let fill=panels.iter().find(|p|p.name=="XPBar").unwrap();assert_eq!(fill.storage.word(0x1dc),0xfffda135);assert_eq!(fill.storage.word(0x224),0);
 let nav=openleague_core::Navigation::load(&std::fs::read_to_string(root.join("assets/maps/tt_navigation_grid.json")).unwrap(),&std::fs::read(root.join("assets/maps/tt_navigation_grid.cells.bin")).unwrap()).unwrap();let mut sim=openleague_core::Simulation::new(nav).unwrap();let id=sim.join("garen").unwrap();assert_eq!(value(&sim.snapshot(),Some(id)).unwrap(),Some(0.0));sim.award_experience(id,150.0).unwrap();assert_eq!(value(&sim.snapshot(),Some(id)).unwrap(),Some(0.5));sim.award_experience(id,150.0).unwrap();assert_eq!(sim.players[&id].level,2);assert_eq!(value(&sim.snapshot(),Some(id)).unwrap(),Some(0.0));sim.award_experience(id,200.0).unwrap();assert_eq!(value(&sim.snapshot(),Some(id)).unwrap(),Some(0.5));sim.award_experience(id,100000.0).unwrap();assert_eq!(sim.players[&id].level,18);assert_eq!(value(&sim.snapshot(),Some(id)).unwrap(),Some(1.0));assert_eq!(value(&sim.snapshot(),None).unwrap(),None);let mut snap=sim.snapshot();snap.players[0].experience=f32::NAN;assert!(value(&snap,Some(id)).is_err());
 }
}
'''
f=r/'crates/client/src/native_hud_experience.rs';assert not f.exists();f.write_text(source,encoding='utf-8')
s=p.read_text(encoding='utf-8').replace('mod native_hud_live_probe;','mod native_hud_live_probe;\nmod native_hud_experience;').replace('.add_plugins(native_hud_bars::Plugin)','.add_plugins(native_hud_bars::Plugin)\n        .add_plugins(native_hud_experience::Plugin)');p.write_text(s,encoding='utf-8');print('Original XP bar integrated')
