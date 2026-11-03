//! TT Capture mode0 / flag-disable-z1 on the existing native QUAD shader.
//! This admits owned CPU resources. GPU dispatch and pixels remain observations.
use bevy::{prelude::*,reflect::TypePath,mesh::MeshVertexBufferLayoutRef,
    pbr::{MaterialPipeline,MaterialPipelineKey},
    render::render_resource::{AsBindGroup,CompareFunction,RenderPipelineDescriptor,ShaderType,
        SpecializedMeshPipelineError,TextureDimension,TextureFormat},shader::ShaderRef,
    image::ImageSampler};
use crate::{relic_rune_image_bindings::Bindings,relic_image_reference_store::Store};

#[derive(Clone,Debug,ShaderType)]
struct Uniform {fog:Vec4,control:UVec4}
#[derive(Asset,TypePath,AsBindGroup,Debug,Clone)]
pub struct CaptureMaterial {
    #[texture(0)] #[sampler(1)] image:Handle<Image>,
    #[texture(2)] #[sampler(3)] color:Handle<Image>,
    #[texture(4)] #[sampler(5)] visibility:Handle<Image>,
    #[texture(6)] #[sampler(7)] overlay:Handle<Image>,
    #[uniform(8)] params:Uniform,
}
impl CaptureMaterial {
    pub fn owned(bindings:&Bindings,store:&Store,images:&Assets<Image>,fog:[Handle<Image>;2],
        extent:f32)->Result<(Self,[Handle<Image>;4]),String> {
        let state=crate::particle_render_state::ParticleState::route(0,1)?;
        if state.state_bits!=0 || state.blend_preset!=2 {
            return Err("TT Capture source mode0/depth-disabled additive route changed".into());
        }
        for layout in bindings.layouts(store)? {
            if layout.source_has_block_padding(){return Err("TT Capture DDS logical padding unqualified".into());}
        }
        let handles=bindings.images_render_fog(store,images,fog)?;
        for handle in &handles[..2] {
            let image=images.get(handle).ok_or("TT Capture owned DDS pending")?;
            let d=&image.texture_descriptor;
            if d.dimension!=TextureDimension::D2 || d.size.depth_or_array_layers!=1 || d.sample_count!=1
                || !matches!(d.format,TextureFormat::Bc1RgbaUnorm|TextureFormat::Bc3RgbaUnorm|TextureFormat::Rgba8Unorm) {
                return Err("TT Capture DDS linear descriptor changed".into());
            }
            let ImageSampler::Descriptor(s)=&image.sampler else{return Err("TT Capture sampler must be explicit".into());};
            if s.compare.is_some() || !s.lod_min_clamp.is_finite() || !s.lod_max_clamp.is_finite()
                || s.lod_min_clamp<0. || s.lod_max_clamp<s.lod_min_clamp {
                return Err("TT Capture sampler outside owned local policy".into());
            }
        }
        let f=crate::native_fow::FogParams::from_native_extent(extent)?.params();
        // Same raw-numeric output convention as the existing native glow shader.
        // Linear DDS + explicit host sampler/cull policy is not original device parity.
        let material=Self {image:handles[0].clone(),color:handles[1].clone(),visibility:handles[2].clone(),
            overlay:handles[3].clone(),params:Uniform {fog:Vec4::new(f.x*20.,f.y*20.,f.z,f.w),
            control:UVec4::new(0,crate::nexus_complex_material::OutputEncoding::RawNumeric as u32,0,0)}};
        Ok((material,handles))
    }
    pub fn set_admitted(&mut self,value:bool){self.params.control.x=u32::from(value);}
    pub fn is_admitted(&self)->bool{self.params.control.x==1}
    pub fn depth_compare()->CompareFunction{CompareFunction::Always}
}
impl Material for CaptureMaterial {
    fn fragment_shader()->ShaderRef{crate::nexus_glow_material::SHADER.into()}
    fn alpha_mode(&self)->AlphaMode{AlphaMode::Blend}
    fn enable_prepass()->bool{false}
    fn enable_shadows()->bool{false}
    fn specialize(_: &MaterialPipeline,d:&mut RenderPipelineDescriptor,layout:&MeshVertexBufferLayoutRef,
        key:MaterialPipelineKey<Self>)->Result<(),SpecializedMeshPipelineError> {
        let _=layout.0.get_layout(&[Mesh::ATTRIBUTE_POSITION.at_shader_location(0),
            Mesh::ATTRIBUTE_UV_0.at_shader_location(2),Mesh::ATTRIBUTE_UV_1.at_shader_location(3),
            Mesh::ATTRIBUTE_COLOR.at_shader_location(5)])?;
        // Fresh primary.backface=0 selects native D3DCULL_CCW. Preserve the
        // existing reflected LH-view mapping rather than disabling culling.
        d.primitive.cull_mode=crate::nexus_complex_material::view_cull(crate::nexus_complex_material::Cull::Back,key.mesh_key);
        if let Some(depth)=d.depth_stencil.as_mut(){depth.depth_write_enabled=Some(false);
            depth.depth_compare=Some(Self::depth_compare());}
        if let Some(fragment)=d.fragment.as_mut(){for target in fragment.targets.iter_mut().flatten(){
            target.blend=Some(crate::particle_render_state::ParticleState::base_projected_blend());
        }}Ok(())
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn source_depth_disabled_route_has_real_ZENABLE_zero_and_additive_state() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/projected_render_state_contract.json")).unwrap();
        let case=proof["cases"].as_array().unwrap().iter().find(|c|c["mode"]==0&&c["flags"]==1
            &&c["calls"].as_array().unwrap().contains(&serde_json::json!([7,0]))).unwrap();
        assert_eq!(case["state_bits"],0);assert_eq!(case["blend_preset"],2);
        assert_eq!(CaptureMaterial::depth_compare(),CompareFunction::Always);
        assert_ne!(CaptureMaterial::depth_compare(),crate::particle_render_state::ParticleState::base_projected_depth_compare());
        assert!(!crate::particle_render_state::ParticleState::base_projected_depth_write());
    }
}
