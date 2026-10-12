//! Native indexed CooldownLine shader. Projection is explicitly supplied.
use bevy::{prelude::*,asset::RenderAssetUsages,mesh::{Indices,MeshVertexBufferLayoutRef},render::render_resource::{AsBindGroup,ShaderType,RenderPipelineDescriptor,PrimitiveTopology,SpecializedMeshPipelineError},shader::ShaderRef,sprite_render::{Material2d,Material2dKey,AlphaMode2d}};
#[derive(Clone,Copy,Debug,ShaderType)] pub struct Parameters {pub projection:Mat4,pub direction:Vec4}
#[derive(Asset,TypePath,AsBindGroup,Clone,Debug)] pub struct LineMaterial {#[uniform(0)] pub parameters:Parameters}
impl Material2d for LineMaterial {
 fn vertex_shader()->ShaderRef {"shaders/native_hud_recharge_line.wgsl".into()}
 fn fragment_shader()->ShaderRef {"shaders/native_hud_recharge_line.wgsl".into()}
 fn alpha_mode(&self)->AlphaMode2d {AlphaMode2d::Blend}
 fn specialize(descriptor:&mut RenderPipelineDescriptor,layout:&MeshVertexBufferLayoutRef,_key:Material2dKey<Self>)->Result<(),SpecializedMeshPipelineError> {
  descriptor.vertex.buffers=vec![layout.0.get_layout(&[Mesh::ATTRIBUTE_POSITION.at_shader_location(0),Mesh::ATTRIBUTE_UV_0.at_shader_location(1),Mesh::ATTRIBUTE_COLOR.at_shader_location(2)])?];
  descriptor.primitive.cull_mode=None;
  if let Some(fragment)=&mut descriptor.fragment {for target in fragment.targets.iter_mut().flatten() {target.blend=Some(crate::native_hud_icon_material::blend());}}
  Ok(())
 }
}
pub fn mesh(vertices:&[crate::native_hud_recharge::RechargeVertex;7])->Mesh {
 let mut mesh=Mesh::new(PrimitiveTopology::LineStrip,RenderAssetUsages::MAIN_WORLD|RenderAssetUsages::RENDER_WORLD);
 mesh.insert_attribute(Mesh::ATTRIBUTE_POSITION,vertices.iter().map(|v|v.position).collect::<Vec<_>>());
 mesh.insert_attribute(Mesh::ATTRIBUTE_UV_0,vertices.iter().map(|v|v.uv).collect::<Vec<_>>());
 mesh.insert_attribute(Mesh::ATTRIBUTE_COLOR,vertices.iter().map(|v|crate::native_font_material::packed_color(v.color).to_array()).collect::<Vec<_>>());
 mesh.insert_indices(Indices::U16(crate::native_hud_recharge::RECHARGE_INDICES[6..].to_vec()));mesh
}
/// Explicit normalized top-left viewport transport; native matrix producer remains open.
pub fn viewport_projection()->Mat4 {Mat4::from_cols_array(&[2.,0.,0.,0.,0.,-2.,0.,0.,0.,0.,1.,0.,-1.,1.,0.,1.])}
