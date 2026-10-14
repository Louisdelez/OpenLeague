//! Dedicated type3 MESH / FIXEDALPHAUV / mode4 material.
//! Asset provenance, native owner/packet production and real GPU readiness are
//! caller-owned. This module does not broaden the Nexus material's admission.
use bevy::{mesh::MeshVertexBufferLayoutRef,pbr::{MaterialPipeline,MaterialPipelineKey,MeshPipelineKey},
    prelude::*,reflect::TypePath,render::render_resource::{AsBindGroup,BlendComponent,BlendFactor,BlendOperation,
    BlendState,CompareFunction,Face,RenderPipelineDescriptor,ShaderType,SpecializedMeshPipelineError,AsBindGroupError,BindGroupLayout,BindGroupLayoutEntry,UnpreparedBindGroup,OwnedBindingResource,TextureViewId,SamplerId},shader::ShaderRef};
pub const SHADER:&str="shaders/spawn_mist_mesh.wgsl";
#[derive(Clone,Copy,Debug,PartialEq,Eq,Hash)]pub enum Cull{None,Front,Back}
#[derive(Clone,Copy,Debug)]pub enum OutputEncoding{RawNumeric=0,DisplayToLinear=1}
#[derive(Clone,Copy,Debug)]
pub struct Inputs {
    /// Original c232, produced by the type3/style2 draw arithmetic.
    pub uv_scale_offset:Vec4,
    /// Actual native lookup buffer+64, modes1/3; not elapsed time.
    pub lookup_uv:Vec2,
    /// Actual925F54 mode4 channel products; preserve unpremultiplied alpha.
    pub color_factor:Vec4,
    /// Native FogParams mapped to renderer world coordinates by the caller.
    pub fog_uv_scale_offset:Vec4,
    /// Explicit global output/raster adaptations. No guessed camera defaults.
    pub output_encoding:OutputEncoding,pub cull:Cull,
    /// Mandatory option producer result; selected scope is fixed-alpha only.
    pub shader_class:u32,pub uv_mode:u32,pub render_mode:u32,
    pub vertex_colors:bool,pub reflected:bool,pub soft:bool,pub mult_pass:bool,
    pub screen_uv:bool,pub alpha_slice:f32,pub fresnel_rgb:Vec3,
}
impl Inputs {
    pub fn validate(self)->Result<Self,&'static str>{
        if !self.uv_scale_offset.is_finite() || !self.lookup_uv.is_finite() || !self.color_factor.is_finite()
            || !self.fog_uv_scale_offset.is_finite() || !self.alpha_slice.is_finite() || !self.fresnel_rgb.is_finite() {
            return Err("nonfinite mist material input");
        }
        if self.shader_class!=1 || self.uv_mode!=2 || self.render_mode!=4
            || self.vertex_colors || self.reflected || self.soft || self.mult_pass || self.screen_uv
            || self.alpha_slice!=0. || self.fresnel_rgb!=Vec3::ZERO {
            return Err("mist material outside supplied MESH-FIXEDALPHAUV mode4 subset");
        }Ok(self)
    }
}
#[derive(Clone,Copy,ShaderType)]
pub struct Uniform {pub uv:Vec4,pub lookup:Vec4,pub color:Vec4,pub fog:Vec4,pub control:UVec4}
#[derive(Asset,TypePath,Clone)]
pub struct MistMaterial {
    pub diffuse:Handle<Image>,pub palette:Handle<Image>,pub visibility:Handle<Image>,pub overlay:Handle<Image>,
    pub params:Uniform,cull:Cull,
    pub binding_evidence:BindingEvidenceHandle,
}
#[derive(AsBindGroup)]
#[bind_group_data(MaterialKey)]
pub struct BindingFields {
    #[texture(0)]#[sampler(1)]pub diffuse:Handle<Image>,
    #[texture(2)]#[sampler(3)]pub palette:Handle<Image>,
    #[texture(4)]#[sampler(5)]pub visibility:Handle<Image>,
    #[texture(6)]#[sampler(7)]pub overlay:Handle<Image>,
    #[uniform(8)]pub params:Uniform,
    cull:Cull,
}
#[derive(Clone,Copy,Debug,PartialEq,Eq,Hash)]pub struct MaterialKey{cull:Cull}
impl From<&BindingFields> for MaterialKey {fn from(value:&BindingFields)->Self{Self{cull:value.cull}}}
impl MistMaterial {
    /// Images must already identify the actual reconstructed diffuse, original
    /// bellramp palette and current FoW pair. No white/default asset is inserted.
    pub fn from_images(images:[Handle<Image>;4],input:Inputs)->Result<Self,&'static str>{
        let input=input.validate()?;
        Ok(Self {diffuse:images[0].clone(),palette:images[1].clone(),visibility:images[2].clone(),overlay:images[3].clone(),cull:input.cull,
            binding_evidence:BindingEvidenceHandle::default(),params:Uniform {uv:input.uv_scale_offset,lookup:input.lookup_uv.extend(0.).extend(0.),color:input.color_factor,
                fog:input.fog_uv_scale_offset,control:UVec4::new(0,input.output_encoding as u32,0,0)}})
    }
    /// This gate must be fed by real owner/resource/pipeline admission. A
    /// constructor or numeric test alone never enables the ordinary draw.
    pub fn set_ready(&mut self,ready:bool){self.params.control.x=u32::from(ready);}
    pub fn is_ready(&self)->bool{self.params.control.x==1}
    pub fn images(&self)->[Handle<Image>;4]{[self.diffuse.clone(),self.palette.clone(),self.visibility.clone(),self.overlay.clone()]}
}

/// The exact resources produced by this material's real AsBindGroup call.
/// The handle is shared with the extracted ticket, never a GPU-ready answer.
#[derive(Clone,Default)]pub struct BindingEvidenceHandle(pub std::sync::Arc<std::sync::Mutex<Option<BindingEvidence>>>);
#[derive(Clone,Copy,Debug,PartialEq,Eq)]pub struct BindingEvidence{
 pub views:[TextureViewId;4],pub samplers:[SamplerId;4],pub uniform_words:[u32;20],
}
impl MistMaterial{
 pub fn uniform_words(&self)->[u32;20]{
  let mut out=[0;20];out[..4].copy_from_slice(&self.params.uv.to_array().map(f32::to_bits));
  out[4..8].copy_from_slice(&self.params.lookup.to_array().map(f32::to_bits));
  out[8..12].copy_from_slice(&self.params.color.to_array().map(f32::to_bits));
  out[12..16].copy_from_slice(&self.params.fog.to_array().map(f32::to_bits));
  out[16..20].copy_from_slice(&self.params.control.to_array());out
 }
 fn binding_fields(&self)->BindingFields{BindingFields{diffuse:self.diffuse.clone(),palette:self.palette.clone(),visibility:self.visibility.clone(),overlay:self.overlay.clone(),params:self.params,cull:self.cull}}
}
impl AsBindGroup for MistMaterial{
 type Data=MaterialKey;
 type Param=<BindingFields as AsBindGroup>::Param;
 fn label()->&'static str{<BindingFields as AsBindGroup>::label()}
 fn bind_group_data(&self)->Self::Data{MaterialKey{cull:self.cull}}
 fn bind_group_layout_entries(device:&bevy::render::renderer::RenderDevice,force_no_bindless:bool)->Vec<BindGroupLayoutEntry>{<BindingFields as AsBindGroup>::bind_group_layout_entries(device,force_no_bindless)}
 fn unprepared_bind_group(&self,layout:&BindGroupLayout,device:&bevy::render::renderer::RenderDevice,
  param:&mut bevy::ecs::system::SystemParamItem<'_,'_,Self::Param>,force_no_bindless:bool)->Result<UnpreparedBindGroup,AsBindGroupError>{
  // Same generated binding layout and preparation as the qualified material.
  // Capture actual returned resources; missing/fallback IDs will fail the draw.
  *self.binding_evidence.0.lock().unwrap_or_else(std::sync::PoisonError::into_inner)=None;
  let group=self.binding_fields().unprepared_bind_group(layout,device,param,force_no_bindless)?;
  let mut views=Vec::new();let mut samplers=Vec::new();
  for index in 0..4u32{
   let view=group.bindings.iter().find(|(binding,_)|*binding==index*2).and_then(|(_,resource)|if let OwnedBindingResource::TextureView(_,view)=resource{Some(view.id())}else{None}).ok_or(AsBindGroupError::RetryNextUpdate)?;
   let sampler=group.bindings.iter().find(|(binding,_)|*binding==index*2+1).and_then(|(_,resource)|if let OwnedBindingResource::Sampler(_,sampler)=resource{Some(sampler.id())}else{None}).ok_or(AsBindGroupError::RetryNextUpdate)?;
   views.push(view);samplers.push(sampler);
  }
  *self.binding_evidence.0.lock().unwrap_or_else(std::sync::PoisonError::into_inner)=Some(BindingEvidence{views:views.try_into().unwrap(),samplers:samplers.try_into().unwrap(),uniform_words:self.uniform_words()});
  Ok(group)
 }
}

/// Actual932A60 mode4/preset6 and9AC600 state calls: SRCALPHA/ONE on RGB and
/// separate alpha. Color ADD; alpha ADD follows the qualified baseline reset.
pub fn mode4_blend()->BlendState{
    let component=BlendComponent{src_factor:BlendFactor::SrcAlpha,dst_factor:BlendFactor::One,operation:BlendOperation::Add};
    BlendState{color:component,alpha:component}
}
pub fn view_cull(cull:Cull,key:MeshPipelineKey)->Option<Face>{
    match(cull,key.contains(MeshPipelineKey::INVERT_CULLING)){
        (Cull::None,_)=>None,(Cull::Front,false)|(Cull::Back,true)=>Some(Face::Front),
        (Cull::Back,false)|(Cull::Front,true)=>Some(Face::Back),
    }
}
impl Material for MistMaterial {
    fn fragment_shader()->ShaderRef{SHADER.into()}
    fn alpha_mode(&self)->AlphaMode{AlphaMode::Blend}
    fn enable_prepass()->bool{false}
    fn enable_shadows()->bool{false}
    fn specialize(_: &MaterialPipeline,d:&mut RenderPipelineDescriptor,layout:&MeshVertexBufferLayoutRef,key:MaterialPipelineKey<Self>)->Result<(),SpecializedMeshPipelineError>{
        let _=layout.0.get_layout(&[Mesh::ATTRIBUTE_POSITION.at_shader_location(0),Mesh::ATTRIBUTE_UV_0.at_shader_location(2),Mesh::ATTRIBUTE_COLOR.at_shader_location(5)])?;
        d.primitive.cull_mode=view_cull(key.bind_group_data.cull,key.mesh_key);
        if let Some(depth)=d.depth_stencil.as_mut(){depth.depth_write_enabled=Some(false);depth.depth_compare=Some(CompareFunction::GreaterEqual);}
        if let Some(fragment)=d.fragment.as_mut(){for target in fragment.targets.iter_mut().flatten(){target.blend=Some(mode4_blend());}}
        Ok(())
    }
}
pub struct Plugin;
impl bevy::prelude::Plugin for Plugin{fn build(&self,app:&mut App){app.add_plugins(MaterialPlugin::<MistMaterial>::default());}}
