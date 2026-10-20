//! Private E default QUAD subset. Depth flags are explicit inputs, not inferred native state.
//! Shared shader/layout unchanged; no geometry, actor lookup, or draw authority here.
use bevy::{prelude::*, reflect::TypePath, mesh::MeshVertexBufferLayoutRef,
    pbr::{MaterialPipeline,MaterialPipelineKey}, shader::ShaderRef,
    render::render_resource::{AsBindGroup,CompareFunction,RenderPipelineDescriptor,
        ShaderType,SpecializedMeshPipelineError}};
use crate::{nexus_glow_material::{Textures,Inputs},nexus_complex_material::Cull};
#[derive(Clone,Debug,ShaderType)]
struct Uniform {fog:Vec4,control:UVec4}
#[derive(Asset,TypePath,AsBindGroup,Debug,Clone)]
#[bind_group_data(Key)]
pub(crate) struct EQuadMaterial {
    #[texture(0)] #[sampler(1)] image:Handle<Image>,
    #[texture(2)] #[sampler(3)] color:Handle<Image>,
    #[texture(4)] #[sampler(5)] visibility:Handle<Image>,
    #[texture(6)] #[sampler(7)] overlay:Handle<Image>,
    #[uniform(8)] params:Uniform,
    cull:Cull, depth_flags:u8,
}
#[derive(Clone,Copy,Debug,PartialEq,Eq,Hash)]
pub(crate) struct Key {cull:Cull,depth_flags:u8}
impl From<&EQuadMaterial> for Key {
    fn from(m:&EQuadMaterial)->Self {Self {cull:m.cull,depth_flags:m.depth_flags}}
}
impl EQuadMaterial {
    pub(crate) fn new(textures:&Textures,visibility:Handle<Image>,overlay:Handle<Image>,input:Inputs)
        ->Result<Self,&'static str> {
        if input.render_mode!=0 || input.render_flags>1 || input.shader_features!=0 {
            return Err("E bolt requires explicit mode0 depth flags0/1 default QUAD");
        }
        let state=crate::particle_render_state::ParticleState::route(0,input.render_flags)?;
        let expected_depth_bits=if input.render_flags==0 {4}else{0};
        if state.state_bits!=expected_depth_bits || state.blend_preset!=2 {return Err("E bolt QUAD routing changed");}
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
        // Invalid keys fail closed; flag0 uses the explicit reversed-depth route.
        match flags {0=>CompareFunction::GreaterEqual,1=>CompareFunction::Always,_=>CompareFunction::Never}
    }
}
impl Material for EQuadMaterial {
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
    fn textures()->Textures {Textures {image:Handle::default(),color:Handle::default(),
        samplers:std::array::from_fn(|_|Default::default())}}
    fn input(flags:u8)->Inputs {Inputs {native_fog_extent:15360.,
        encoding:crate::nexus_complex_material::OutputEncoding::RawNumeric,cull:Cull::None,
        render_mode:0,render_flags:flags,shader_features:0}}
    #[test]
    fn both_depth_routes_are_explicit_in_source_and_pipeline_identity() {
        let textures=textures();
        let zero=EQuadMaterial::new(&textures,Handle::default(),Handle::default(),input(0)).unwrap();
        let one=EQuadMaterial::new(&textures,Handle::default(),Handle::default(),input(1)).unwrap();
        assert_eq!(zero.strict_source_identity().4,0);assert_eq!(one.strict_source_identity().4,1);
        assert_ne!(Key::from(&zero),Key::from(&one));
        assert_eq!(EQuadMaterial::depth_compare(Key::from(&zero).depth_flags),CompareFunction::GreaterEqual);
        assert_eq!(EQuadMaterial::depth_compare(Key::from(&one).depth_flags),CompareFunction::Always);
        for (flag,bits) in [(0,4),(1,0)] {
            let state=crate::particle_render_state::ParticleState::route(0,flag).unwrap();
            assert_eq!((state.state_bits,state.blend_preset),(bits,2));
        }
        assert_eq!(zero.strict_source_identity().2[0],0,"constructor grants no admission");
    }
    #[test]
    fn unsupported_policy_and_invalid_fog_are_rejected_without_a_pipeline_fallback() {
        let textures=textures();let valid=input(0);
        for invalid in [Inputs {render_mode:1,..valid},Inputs {render_flags:2,..valid},
            Inputs {render_flags:255,..valid},Inputs {shader_features:1,..valid},
            Inputs {native_fog_extent:f32::NAN,..valid},Inputs {native_fog_extent:0.,..valid}] {
            assert!(EQuadMaterial::new(&textures,Handle::default(),Handle::default(),invalid).is_err());
        }
        assert_eq!(EQuadMaterial::depth_compare(2),CompareFunction::Never);
        assert_eq!(EQuadMaterial::depth_compare(255),CompareFunction::Never);
    }
}
