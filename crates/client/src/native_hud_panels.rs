//! Three original static map10 frames. Full matrix/sampler/gamma fidelity remains open.
use bevy::{prelude::*,ui_render::{UiMaterialPlugin,ui_material::MaterialNode},window::PrimaryWindow};
use crate::{native_hud_element_storage::ElementStorage,native_zip_provider::StartupHud,native_hud_icon_material::{IconMaterial,Parameters},native_hud_icon_draw::PixelShader};
pub(crate) struct Panel {pub(crate) name:String,pub(crate) path:String,pub(crate) storage:ElementStorage}
#[derive(Resource,Default)] struct Live {panels:Vec<Panel>,signature:Option<String>,entities:Vec<Entity>,materials:Vec<Handle<IconMaterial>>}
pub struct Plugin;
impl bevy::app::Plugin for Plugin {fn build(&self,app:&mut App) {app.add_plugins(UiMaterialPlugin::<IconMaterial>::default()).init_resource::<Live>().add_systems(Startup,setup).add_systems(Update,update.before(crate::render_probe::capture));}}
fn load(hud:&StartupHud)->Result<Vec<Panel>,String> {
 let mut result=Vec::new();
 for layout in &hud.shadow_isles_layouts {for record in &layout.structure.accepted {
  let s=&record.element.storage;if s.kind()!=1 {continue;}
  let name=s.bytes()[..32].split(|b|*b==0).next().unwrap();
  if (layout.request.ends_with("ShadowIslesChampionLeft.ini") && matches!(name,b"HUDLeftFrame"|b"HUDLeftPillar")) || (layout.request.ends_with("ShadowIslesTitanBar.ini") && name==b"TitanBarFrame") {
   if s.flags()&1==0 || &s.bytes()[0x204..0x214]!=&s.bytes()[0x214..0x224] {return Err("static original frame disabled or requires dynamic UV producer".into());}
   let texture=s.bytes()[0x1e0..0x200].split(|b|*b==0).next().unwrap();if texture!=b"ShadowIslesHUDAtlas" {return Err("unexpected native frame texture".into());}
   let mut storage=ElementStorage::new(1).unwrap();storage.write_bytes(0,s.bytes());result.push(Panel {name:String::from_utf8(name.to_vec()).map_err(|_|"panel name encoding")?,path:layout.request.clone(),storage});
  }
 }}if result.len()!=3 {return Err("three original map10 frames missing or duplicated".into());}result.sort_by_key(|p|p.storage.word(0x1a4));Ok(result)
}
fn setup(hud:Res<StartupHud>,mut live:ResMut<Live>) {match load(&hud) {Ok(panels)=>live.panels=panels,Err(e)=>eprintln!("Native HUD panels unavailable: {e}")}}
pub(crate) fn payload(panel:&Panel,dimensions:[u32;2],scalar:f32,dpi:f32,texture:Handle<Image>)->Result<(Node,IconMaterial),String> {
 let s=&panel.storage;let f=|off|f32::from_bits(s.word(off));
 if !dpi.is_finite() || dpi<=0.0 {return Err("invalid panel DPI".into());}
 let rect=crate::native_hud_layout::transform(&crate::native_hud_layout::Input {flags:s.flags(),width:dimensions[0],height:dimensions[1],owner_scalar:scalar,rect:[f(0x1c0),f(0x1c4),f(0x1c8),f(0x1cc)],anchors:[f(0x1a8),f(0x1ac),f(0x1b0),f(0x1b4)],motion_offset:[f(0x1b8),f(0x1bc)],include_motion:false,group_offset:None,fractions:s.initial_fractions(),aspect:f(0x1d8)}).map_err(str::to_owned)?;
 let uv=crate::native_hud_icon_geometry::uv([f(0x204),f(0x208),f(0x20c),f(0x210)],[f(0x214),f(0x218),f(0x21c),f(0x220)],0.0,s.flags(),f(0x1d0));
 let q=crate::native_hud_icon_geometry::emit(rect,uv,s.word(0x1dc),0,true,true).ok_or("panel geometry missing")?;
 let read=|off|f32::from_bits(u32::from_le_bytes(q.vertices[off..off+4].try_into().unwrap()));let bounds=[read(0),read(4),read(24),read(52)];
 if bounds.iter().chain(&uv).any(|v|!v.is_finite()) || bounds[2]<bounds[0] || bounds[3]<bounds[1] {return Err("panel quad cannot use axis-aligned UI transport".into());}
 let route=crate::native_hud_icon_draw::route(2,true,true,2,s.word(0x224)).ok_or("panel native draw suppressed")?;let mode=match route.shader {PixelShader::Alpha=>0.0,PixelShader::Opaque=>1.0,PixelShader::Clear=>2.0,PixelShader::Blit=>3.0};
 let w=dimensions[0] as f32/dpi;let h=dimensions[1] as f32/dpi;
 let node=Node {position_type:PositionType::Absolute,left:Val::Px(bounds[0]*w),top:Val::Px(bounds[1]*h),width:Val::Px((bounds[2]-bounds[0])*w),height:Val::Px((bounds[3]-bounds[1])*h),..default()};
 Ok((node,IconMaterial {parameters:Parameters {uv:Vec4::from_array(uv),vertex_color:crate::native_font_material::packed_color(s.word(0x1dc)),tint:Vec4::ONE,mode:Vec4::new(mode,0.0,0.0,0.0)},texture}))
}
fn update(mut commands:Commands,window:Query<&Window,With<PrimaryWindow>>,atlases:Res<crate::native_hud_atlases::Atlases>,viewport:Res<crate::native_hud_viewport::Viewport>,mut materials:ResMut<Assets<IconMaterial>>,mut live:ResMut<Live>) {
 if live.panels.len()!=3 {return;}let Ok(window)=window.single() else{return;};let Some(atlas)=atlases.entries.iter().find(|a|a.normalized.ends_with("ShadowIslesHUDAtlas.dds")) else{return;};let dimensions=[window.physical_width(),window.physical_height()];let dpi=window.scale_factor();let signature=format!("{dimensions:?}:{dpi}:{}:{:?}",viewport.scalar.to_bits(),atlas.image.id());if live.signature.as_ref()==Some(&signature) {return;}
 let result=live.panels.iter().map(|p|payload(p,dimensions,viewport.scalar,dpi,atlas.image.clone())).collect::<Result<Vec<_>,_>>();let payloads=match result {Ok(p)=>p,Err(e)=>{eprintln!("Native HUD panel render unavailable: {e}");return;}};
 for entity in live.entities.drain(..) {commands.entity(entity).despawn();}for material in live.materials.drain(..) {materials.remove(material.id());}
 let mut records=Vec::new();for (i,(node,material)) in payloads.into_iter().enumerate() {let panel=&live.panels[i];records.push(serde_json::json!({"name":panel.name,"path":panel.path,"layer":panel.storage.word(0x1a4),"uv":material.parameters.uv.to_array(),"node":format!("{:?},{:?},{:?},{:?}",node.left,node.top,node.width,node.height)}));let z=80+panel.storage.word(0x1a4) as i32;let handle=materials.add(material);live.entities.push(commands.spawn((node,MaterialNode(handle.clone()),GlobalZIndex(z),Name::new("NativeMap10HudPanel"))).id());live.materials.push(handle);}
 live.signature=Some(signature);if let Ok(path)=std::env::var("OPENLEAGUE_NATIVE_HUD_PANELS_TRACE") {let report=serde_json::json!({"complete":false,"panels":records,"entities":live.entities.len(),"materials":live.materials.len(),"viewport":dimensions,"dpi":dpi,"limits":["Three static frames only. White owner tint and normalized rect to physical pixel UI transport explicit. Original base matrix, framebuffer equivalence, gamma and sampler addressing pending.","Original DDS sRGB interpretation/linear sampler inherited from atlas loader; no claim of original backend equivalence."]});if let Err(e)=std::fs::write(path,serde_json::to_vec_pretty(&report).unwrap()) {eprintln!("HUD panel trace failed: {e}");}}
}
#[cfg(test)] mod tests {
 use super::*;
 #[test] fn source_frames_preserve_original_uv_color_layer_and_resize() {
  let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");let mut provider=crate::native_zip_provider::Provider::from_catalog(&root).unwrap();let hud=provider.startup_hud(&root).unwrap();let panels=load(&hud).unwrap();assert_eq!(panels.iter().map(|p|p.name.as_str()).collect::<Vec<_>>(),["TitanBarFrame","HUDLeftFrame","HUDLeftPillar"]);
  for panel in &panels {for dimensions in [[1280,800],[1920,1080]] {let (node,material)=payload(panel,dimensions,1.0,1.0,Handle::default()).unwrap();assert_eq!(material.parameters.vertex_color,Vec4::ONE);assert_eq!(material.parameters.mode.x,0.0);assert_eq!(material.parameters.uv.to_array().map(f32::to_bits),std::array::from_fn(|k|panel.storage.word(0x204+k*4)));let (scaled,_)=payload(panel,dimensions,1.0,2.0,Handle::default()).unwrap();if let (Val::Px(a),Val::Px(b))=(node.width,scaled.width) {assert_eq!(a,b*2.0);}else {panic!("pixel width required")}}}
 }
}
