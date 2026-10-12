//! Original Cooldown pixel shader, transported through Bevy UI.
//! Native projection, LineStrip transport and ordinary HUD integration remain open.
use bevy::{prelude::*,render::render_resource::{AsBindGroup,ShaderType,RenderPipelineDescriptor},shader::ShaderRef,ui_render::ui_material::{UiMaterial,UiMaterialKey}};
#[derive(Clone,Copy,Debug,ShaderType)] pub struct Parameters {pub params:Vec4,pub color0:Vec4,pub color1:Vec4}
#[derive(Asset,TypePath,AsBindGroup,Clone,Debug)] pub struct RechargeMaterial {#[uniform(0)] pub parameters:Parameters}
impl UiMaterial for RechargeMaterial {
 fn fragment_shader()->ShaderRef {"shaders/native_hud_recharge.wgsl".into()}
 fn specialize(descriptor:&mut RenderPipelineDescriptor,_key:UiMaterialKey<Self>) {if let Some(fragment)=&mut descriptor.fragment {for target in fragment.targets.iter_mut().flatten() {target.blend=Some(crate::native_hud_icon_material::blend());}}}
}
