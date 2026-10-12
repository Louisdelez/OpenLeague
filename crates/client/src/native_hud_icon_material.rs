//! Original UI shaders and premultiplied native99F170 composition.
use bevy::{prelude::*,render::render_resource::{AsBindGroup,ShaderType,RenderPipelineDescriptor,BlendState,BlendComponent,BlendFactor,BlendOperation},shader::ShaderRef,ui_render::ui_material::{UiMaterial,UiMaterialKey}};
#[derive(Clone,Copy,Debug,ShaderType)] pub struct Parameters {pub uv:Vec4,pub vertex_color:Vec4,pub tint:Vec4,pub mode:Vec4}
#[derive(Asset,TypePath,AsBindGroup,Clone,Debug)] pub struct IconMaterial {#[uniform(0)] pub parameters:Parameters,#[texture(1)] #[sampler(2)] pub texture:Handle<Image>}
pub fn blend()->BlendState {let component=BlendComponent {src_factor:BlendFactor::One,dst_factor:BlendFactor::OneMinusSrcAlpha,operation:BlendOperation::Add};BlendState {color:component,alpha:component}}
impl UiMaterial for IconMaterial {
 fn fragment_shader()->ShaderRef {"shaders/native_hud_icon.wgsl".into()}
 fn specialize(descriptor:&mut RenderPipelineDescriptor,_key:UiMaterialKey<Self>) {if let Some(fragment)=&mut descriptor.fragment {for target in fragment.targets.iter_mut().flatten() {target.blend=Some(blend());}}}
}
pub fn shade(texture:Vec4,vertex:Vec4,tint:Vec4,mode:u32)->Vec4 {
 let col=texture*vertex;
 match mode {0=>(col.truncate()*col.w*tint.truncate()*tint.w).extend(col.w*tint.w),1=>(col.truncate()*tint.truncate()).extend(1.0),2=>Vec4::ZERO,3=>(col.truncate()*tint.truncate()*tint.w).extend(col.w*tint.w),_=>panic!("unsupported native Icon shader")}
}
#[cfg(test)] mod tests {
 use super::*;
 #[test] fn native_shader_premultiplication_and_d3d_reset_factors_are_preserved() {
  let texture=Vec4::new(0.8,0.4,0.2,0.5);let vertex=Vec4::new(0.5,0.5,1.0,0.5);let tint=Vec4::new(0.5,1.0,0.5,0.5);
  for (mode,want) in [(0,[0.025,0.025,0.0125,0.125]),(1,[0.2,0.2,0.1,1.0]),(2,[0.0;4]),(3,[0.1,0.1,0.05,0.125])] {for (a,b) in shade(texture,vertex,tint,mode).to_array().into_iter().zip(want) {assert!((a-b).abs()<1e-7);}}
  let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_icon_state_contract.json")).unwrap();assert_eq!(p["passed"],true);
  for c in p["cases"].as_array().unwrap() {let events=c["events"].as_array().unwrap();for (state,value) in [(19,2),(207,2),(20,6),(208,6)] {if let Some(event)=events.iter().find(|e|e["state"]==state) {assert_eq!(event["value"],value);}}}
  let b=blend();assert_eq!(b.color.src_factor,BlendFactor::One);assert_eq!(b.color.dst_factor,BlendFactor::OneMinusSrcAlpha);assert_eq!(b.alpha,b.color);
 }
}
