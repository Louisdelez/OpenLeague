from pathlib import Path
import shutil
r=Path('E:/OpenLeague')
p=r/'crates/font-raster/src/native_hud_text_projection.rs';assert not p.exists();p.write_text('''//! Original99F4BB matrix preparation suffix; full clip matrix producer is separate.
use crate::Error;
pub fn matrix(mut matrix:[f32;16],viewport:[u32;2],scale:f32)->Result<[f32;16],Error> {
    if matrix.iter().any(|v|!v.is_finite()) || !scale.is_finite() || scale<=0.0 {return Err(Error("unqualified text projection matrix".into()))}
    matrix[0]*=scale;matrix[5]*=scale;matrix[12]=(matrix[12] as f64*viewport[0] as f64) as f32;matrix[13]=(matrix[13] as f64*viewport[1] as f64) as f32;Ok(matrix)
}
#[cfg(test)] mod tests {
    #[test] fn matrix_suffix_matches30_original_executions() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_text_projection_contract.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],30);
        for c in p["cases"].as_array().unwrap() {let matrix=std::array::from_fn(|i|f32::from_bits(c["matrix_bits"][i].as_u64().unwrap() as u32));let actual=super::matrix(matrix,[c["viewport"][0].as_u64().unwrap() as u32,c["viewport"][1].as_u64().unwrap() as u32],f32::from_bits(c["scale_bits"].as_u64().unwrap() as u32)).unwrap().map(f32::to_bits);assert_eq!(actual,std::array::from_fn(|i|c["output_bits"][i].as_u64().unwrap() as u32));}
    }
}
''',encoding='utf-8')
p=r/'crates/font-raster/src/lib.rs';s=p.read_text(encoding='utf-8')+'\npub mod native_hud_text_projection;\n';p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/native_hud_text_render.rs';s=p.read_text(encoding='utf-8');idx=s.index('#[cfg(test)]')
s=s[:idx]+'''/// Apply qualified diagonal projection factor to axis-aligned glyph positions.
/// Base clip matrix and original half-texel mapping remain separate.
pub fn projected_ui_payloads(prepared:&Prepared,faces:&Faces,sizes:&Sizes,pages:&Pages,fill:Handle<Image>,viewport_offset:Vec2)->Result<Vec<(Node,FontMaterial)>,String> {
    let mut result=Vec::new();
    for text in &prepared.texts {
        let scale=openleague_font_raster::native_hud_text_projection::matrix([1.0,0.0,0.0,0.0,0.0,1.0,0.0,0.0,0.0,0.0,1.0,0.0,0.0,0.0,0.0,1.0],[1,1],text.packet_scale).map_err(|e|e.to_string())?[0];
        for (character,quad) in &text.geometry.glyphs {let mut quad=quad.clone();for vertex in &mut quad.vertices {vertex.position[0]*=scale;vertex.position[1]*=scale;}
            result.push(pages.material_for_quad(faces,sizes,text.source_binding,*character,&quad,fill.clone(),viewport_offset)?);
        }
    }Ok(result)
}
'''+s[idx:];p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/native_hud_widgets.rs';assert not p.exists();p.write_text('''//! Three original map10 Text widgets, fed by authoritative OpenLeague snapshots.
//! Snapshot value formatting is engine-owned; original formatter/clip matrix remain open.
use bevy::{prelude::*,asset::RenderAssetUsages,render::render_resource::{Extent3d,TextureDimension,TextureFormat},ui_render::ui_material::MaterialNode,window::PrimaryWindow};
use crate::{native_font_gpu::{FontMaterial,Pages},native_font_metrics::Faces,native_hud_font_creation::Sizes,native_hud_element_storage::ElementStorage,native_zip_provider::StartupHud};
struct Widget {name:String,path:String,binding:usize,storage:ElementStorage}
#[derive(Resource,Default)] pub struct Live {widgets:Vec<Widget>,fill:Handle<Image>,entities:Vec<Entity>,materials:Vec<Handle<FontMaterial>>,signature:Option<String>,last_error:Option<String>,pub rebuilds:u64}
pub struct Plugin;
impl bevy::app::Plugin for Plugin {fn build(&self,app:&mut App) {app.init_resource::<Live>().add_systems(Startup,setup).add_systems(Update,update.after(crate::receive).after(crate::native_font_metrics::MetricsSet).before(crate::render_probe::capture));}}
fn load(hud:&StartupHud)->Result<Vec<Widget>,String> {
    let mut widgets=Vec::new();let mut binding=0;
    for layout in &hud.shadow_isles_layouts {for record in &layout.structure.accepted {
        let storage=&record.element.storage;if storage.kind()!=3 {continue}
        let name=storage.bytes()[..32].split(|b|*b==0).next().unwrap();
        if (layout.request.ends_with("ShadowIslesChampionLeft.ini") && (name==b"GoldStat" || name==b"LevelStat")) || (layout.request.ends_with("ShadowIslesTitanBar.ini") && name==b"GameTime") {
            let mut owned=ElementStorage::new(3).map_err(str::to_owned)?;owned.write_bytes(0,storage.bytes());owned.set_word(0x200,binding as u32+1);
            widgets.push(Widget {name:String::from_utf8(name.to_vec()).map_err(|_|"source widget name encoding")?,path:layout.request.clone(),binding,storage:owned});
        }binding+=1;
    }}
    if widgets.len()!=3 {return Err("original GameTime/GoldStat/LevelStat definitions missing or duplicated".into())}Ok(widgets)
}
fn setup(hud:Res<StartupHud>,mut live:ResMut<Live>,mut images:ResMut<Assets<Image>>) {
    match load(&hud) {Ok(widgets)=>live.widgets=widgets,Err(e)=>{live.last_error=Some(e.clone());eprintln!("Native HUD widgets unavailable: {e}");return}}
    let mut white=Image::new(Extent3d {width:1,height:1,depth_or_array_layers:1},TextureDimension::D2,vec![255;4],TextureFormat::Rgba8Unorm,RenderAssetUsages::MAIN_WORLD|RenderAssetUsages::RENDER_WORLD);white.sampler=crate::native_font_material::sampler(1,false).unwrap();live.fill=images.add(white);
}
pub fn snapshot_values(snapshot:&openleague_core::Snapshot,id:Option<u32>)->Result<Option<std::collections::BTreeMap<String,String>>,String> {
    let Some(player)=snapshot.players.iter().find(|p|Some(p.id)==id) else {return Ok(None)};
    if !player.gold.is_finite() || player.gold<0.0 || player.gold as f64>u32::MAX as f64 {return Err("HUD authoritative gold outside supported unsigned32 range".into())}
    let seconds=snapshot.tick/openleague_core::TICK_RATE;
    Ok(Some(std::collections::BTreeMap::from([("GameTime".into(),format!("{}:{:02}",seconds/60,seconds%60)),("GoldStat".into(),format!("{}",player.gold.floor() as u32)),("LevelStat".into(),player.level.to_string())])))
}
fn clear(live:&mut Live,commands:&mut Commands,materials:&mut Assets<FontMaterial>) {for entity in live.entities.drain(..) {commands.entity(entity).despawn();}for material in live.materials.drain(..) {materials.remove(material.id());}live.signature=None;}
fn update(mut commands:Commands,state:Res<crate::Match>,connection:Res<crate::Connection>,window:Query<&Window,With<PrimaryWindow>>,viewport:Res<crate::native_hud_viewport::Viewport>,sizes:Res<Sizes>,mut faces:NonSendMut<Faces>,mut pages:ResMut<Pages>,mut images:ResMut<Assets<Image>>,mut materials:ResMut<Assets<FontMaterial>>,mut live:ResMut<Live>) {
    if live.widgets.len()!=3 {return}
    let Some(snapshot)=&state.snapshot else {clear(&mut live,&mut commands,&mut materials);return};
    let values=match snapshot_values(snapshot,connection.id) {Ok(Some(v))=>v,Ok(None)=>{clear(&mut live,&mut commands,&mut materials);return},Err(e)=>{clear(&mut live,&mut commands,&mut materials);if live.last_error.as_ref()!=Some(&e) {eprintln!("Native HUD values unavailable: {e}");live.last_error=Some(e)}return}};
    let Ok(window)=window.single() else {return};let dimensions=[window.physical_width(),window.physical_height()];if sizes.height!=Some(dimensions[1]) || faces.height!=sizes.height {return}
    let signature=format!("{dimensions:?}:{:?}:{}:{values:?}",faces.dpi,viewport.scalar.to_bits());if live.signature.as_ref()==Some(&signature) {return}
    let result=(||->Result<Vec<(Node,FontMaterial)>,String> {
        for widget in &mut live.widgets {let text=values.get(&widget.name).ok_or("widget value missing")?.as_bytes();if text.len()>255 {return Err("HUD value exceeds original capacity".into())}let mut bytes=[0u8;256];bytes[..text.len()].copy_from_slice(text);widget.storage.write_bytes(0x20c,&bytes);}
        let bindings=live.widgets.iter().map(|w|(w.binding as u32+1,w.binding)).collect::<std::collections::BTreeMap<_,_>>();let mut storages=live.widgets.iter_mut().map(|w|&mut w.storage).collect::<Vec<_>>();
        let batch=crate::native_hud_text_batch::from_elements(&mut storages,dimensions,viewport.scalar,0,[1.0,1.0,0.0,0.0]).map_err(str::to_owned)?;
        let prepared=crate::native_hud_text_render::prepare(&mut faces,&sizes,&batch,&crate::native_hud_text_render::Context {viewport:dimensions,packet_scalar:viewport.scalar,glyph_owner_scale:1.0},&bindings,|text|if text.is_ascii() {Ok(text.iter().map(|b|*b as u16).collect())}else {Err("numeric HUD values require ASCII".into())})?;
        if !prepared.copy_errors.is_empty() {return Err("HUD native text copy failed".into())}
        pages.sync(&faces,&sizes,&mut images)?;crate::native_hud_text_render::projected_ui_payloads(&prepared,&faces,&sizes,&pages,live.fill.clone(),Vec2::splat(0.5))
    })();
    let payloads=match result {Ok(v)=>v,Err(e)=>{clear(&mut live,&mut commands,&mut materials);if live.last_error.as_ref()!=Some(&e) {eprintln!("Native HUD widget rendering unavailable: {e}");live.last_error=Some(e)}return}};
    clear(&mut live,&mut commands,&mut materials);let rects=payloads.iter().map(|(n,_)|format!("{:?},{:?},{:?},{:?}",n.left,n.top,n.width,n.height)).collect::<Vec<_>>();
    for (node,material) in payloads {let handle=materials.add(material);live.entities.push(commands.spawn((node,MaterialNode(handle.clone()),GlobalZIndex(100),Name::new("NativeMap10HudGlyph"))).id());live.materials.push(handle);}
    live.signature=Some(signature);live.last_error=None;live.rebuilds+=1;
    if let Ok(path)=std::env::var("OPENLEAGUE_NATIVE_HUD_TRACE") {
        let sources=live.widgets.iter().map(|w|serde_json::json!({"name":w.name,"path":w.path,"source_text_binding":w.binding,"alignment":w.storage.word(0x208),"packed_color":w.storage.word(0x1dc)})).collect::<Vec<_>>();
        let report=serde_json::json!({"tick":snapshot.tick,"player":connection.id,"values":values,"viewport":dimensions,"rebuilds":live.rebuilds,"glyph_entities":live.entities.len(),"material_assets":live.materials.len(),"sources":sources,"glyph_nodes":rects,"complete":false,"limits":["Three Text widgets only; original formatter, base clip matrix and original framebuffer equivalence pending. Engine numeric ASCII formatter, white fill, positive packet scale and viewport offset0.5 explicit."]});
        if let Err(e)=std::fs::write(path,serde_json::to_vec_pretty(&report).unwrap()) {eprintln!("Native HUD trace failed: {e}");}
    }
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn exact_source_widgets_bind_original_styles_and_font_request_order() {
        let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");let mut provider=crate::native_zip_provider::Provider::from_catalog(&root).unwrap();let hud=provider.startup_hud(&root).unwrap();let widgets=load(&hud).unwrap();assert_eq!(widgets.len(),3);
        for widget in &widgets {assert!(widget.binding<154);assert_eq!(widget.storage.flags(),1);assert_eq!(widget.storage.word(0x208),1);assert_eq!(widget.storage.word(0x200),widget.binding as u32+1);}
        assert_eq!(widgets.iter().find(|w|w.name=="GoldStat").unwrap().storage.word(0x1dc),0xfffff799);assert_eq!(widgets.iter().find(|w|w.name=="LevelStat").unwrap().storage.word(0x1dc),0xc8ffffff);
    }
    #[test] fn authoritative_snapshot_values_follow_gold_level_time_and_missing_player() {
        let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");let navigation=openleague_core::Navigation::load(&std::fs::read_to_string(root.join("assets/maps/tt_navigation_grid.json")).unwrap(),&std::fs::read(root.join("assets/maps/tt_navigation_grid.cells.bin")).unwrap()).unwrap();let mut simulation=openleague_core::Simulation::new(navigation).unwrap();let id=simulation.join("garen").unwrap();simulation.tick=61*openleague_core::TICK_RATE;let player=simulation.players.get_mut(&id).unwrap();player.gold=1234.75;player.level=7;let mut snapshot=simulation.snapshot();let values=snapshot_values(&snapshot,Some(id)).unwrap().unwrap();assert_eq!(values["GameTime"],"1:01");assert_eq!(values["GoldStat"],"1234");assert_eq!(values["LevelStat"],"7");assert_eq!(snapshot_values(&snapshot,None).unwrap(),None);snapshot.players[0].gold=f32::NAN;assert!(snapshot_values(&snapshot,Some(id)).is_err());
    }
}
''',encoding='utf-8')
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8');s='mod native_hud_widgets;\n'+s;s=s.replace('.add_plugins(native_font_gpu::Plugin)','.add_plugins(native_font_gpu::Plugin)\n        .add_plugins(native_hud_widgets::Plugin)',1);p.write_text(s,encoding='utf-8')
for name in ['port_native_hud_widgets.py','qualify_native_hud_text_projection.py']:shutil.copy2(Path('E:/mapslol3v3')/name,r/'tools'/name)
print('GameTime, GoldStat and LevelStat source widgets connected to live snapshots and material/entity lifecycle')
