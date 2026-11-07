//! Private flag-disable-z1 QUAD subset. Never changes the general Glow material.
use bevy::{prelude::*, reflect::TypePath, mesh::MeshVertexBufferLayoutRef,
    pbr::{MaterialPipeline,MaterialPipelineKey}, shader::ShaderRef,
    render::render_resource::{AsBindGroup,CompareFunction,RenderPipelineDescriptor,
        ShaderType,SpecializedMeshPipelineError}};
use crate::{nexus_glow_material::{Textures,Inputs},nexus_complex_material::Cull};
#[derive(Clone,Debug,ShaderType)]
struct Uniform {fog:Vec4,control:UVec4}
#[derive(Asset,TypePath,AsBindGroup,Debug,Clone)]
#[bind_group_data(Key)]
pub(crate) struct FlashQuadMaterial {
    #[texture(0)] #[sampler(1)] image:Handle<Image>,
    #[texture(2)] #[sampler(3)] color:Handle<Image>,
    #[texture(4)] #[sampler(5)] visibility:Handle<Image>,
    #[texture(6)] #[sampler(7)] overlay:Handle<Image>,
    #[uniform(8)] params:Uniform,
    cull:Cull, depth_flags:u8,
}
#[derive(Clone,Copy,Debug,PartialEq,Eq,Hash)]
pub(crate) struct Key {cull:Cull,depth_flags:u8}
impl From<&FlashQuadMaterial> for Key {
    fn from(m:&FlashQuadMaterial)->Self {Self {cull:m.cull,depth_flags:m.depth_flags}}
}
impl FlashQuadMaterial {
    pub(crate) fn new(textures:&Textures,visibility:Handle<Image>,overlay:Handle<Image>,input:Inputs)
        ->Result<Self,&'static str> {
        if input.render_mode!=0 || input.render_flags!=1 || input.shader_features!=0 {
            return Err("R flash requires mode0 flag-disable-z1 default QUAD");
        }
        let state=crate::particle_render_state::ParticleState::route(0,1)?;
        if state.state_bits!=0 || state.blend_preset!=2 {return Err("R flash depth-disabled route changed");}
        let f=crate::native_fow::FogParams::from_native_extent(input.native_fog_extent)?.params();
        Ok(Self {image:textures.image.clone(),color:textures.color.clone(),visibility,overlay,
            cull:input.cull,depth_flags:input.render_flags,
            params:Uniform {fog:Vec4::new(f.x*20.,f.y*20.,f.z,f.w),control:UVec4::new(0,input.encoding as u32,0,0)}})
    }
    pub(crate) fn set_admitted(&mut self,value:bool){self.params.control.x=u32::from(value);}
    pub(crate) fn strict_source_identity(&self)->([AssetId<Image>;4],[u32;4],[u32;4],Cull,u8) {
        ([self.image.id(),self.color.id(),self.visibility.id(),self.overlay.id()],
            self.params.fog.to_array().map(f32::to_bits),self.params.control.to_array(),self.cull,self.depth_flags)
    }
    fn depth_compare(flags:u8)->CompareFunction {
        // Unconstructible invalid keys fail closed to Never; the admitted key is1.
        if flags==1 {CompareFunction::Always}else{CompareFunction::Never}
    }
}
impl Material for FlashQuadMaterial {
    fn fragment_shader()->ShaderRef {crate::nexus_glow_material::SHADER.into()}
    fn alpha_mode(&self)->AlphaMode {AlphaMode::Blend}
    fn enable_prepass()->bool {false}
    fn enable_shadows()->bool {false}
    fn reads_view_transmission_texture(&self)->bool {false}
    fn specialize(_: &MaterialPipeline,d:&mut RenderPipelineDescriptor,layout:&MeshVertexBufferLayoutRef,
        key:MaterialPipelineKey<Self>)->Result<(),SpecializedMeshPipelineError> {
        let _=layout.0.get_layout(&[Mesh::ATTRIBUTE_POSITION.at_shader_location(0),
            Mesh::ATTRIBUTE_UV_0.at_shader_location(2),Mesh::ATTRIBUTE_UV_1.at_shader_location(3),
            Mesh::ATTRIBUTE_COLOR.at_shader_location(5)])?;
        d.primitive.cull_mode=crate::nexus_complex_material::view_cull(key.bind_group_data.cull,key.mesh_key);
        if let Some(depth)=d.depth_stencil.as_mut() {
            depth.depth_write_enabled=Some(false);
            depth.depth_compare=Some(Self::depth_compare(key.bind_group_data.depth_flags));
        }
        if let Some(fragment)=d.fragment.as_mut(){for target in fragment.targets.iter_mut().flatten(){
            target.blend=Some(crate::particle_render_state::ParticleState::base_projected_blend());
        }} Ok(())
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn flag1_is_in_both_shader_source_identity_and_real_pipeline_key() {
        let textures=Textures {image:Handle::default(),color:Handle::default(),samplers:std::array::from_fn(|_|Default::default())};
        let input=Inputs {native_fog_extent:15360.,encoding:crate::nexus_complex_material::OutputEncoding::RawNumeric,
            cull:Cull::None,render_mode:0,render_flags:1,shader_features:0};
        let mut material=FlashQuadMaterial::new(&textures,Handle::default(),Handle::default(),input).unwrap();
        assert_eq!(material.strict_source_identity().4,1);assert_eq!(Key::from(&material).depth_flags,1);
        assert_eq!(FlashQuadMaterial::depth_compare(Key::from(&material).depth_flags),CompareFunction::Always);
        assert!(FlashQuadMaterial::new(&textures,Handle::default(),Handle::default(),Inputs {render_flags:0,..input}).is_err());
        let original=Key::from(&material);material.depth_flags=0;assert_ne!(original,Key::from(&material));
        assert_eq!(FlashQuadMaterial::depth_compare(0),CompareFunction::Never);
        let state=crate::particle_render_state::ParticleState::route(0,1).unwrap();
        assert_eq!((state.state_bits,state.blend_preset),(0,2));
    }
}
