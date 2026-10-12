//! Default QUAD shader subset, exact authored DDS including native p-rgba default.
//! Resource admission and emitter lifetime belong to the private live host.
use bevy::{
    image::{ImageLoaderSettings, ImageSampler, ImageSamplerDescriptor},
    mesh::MeshVertexBufferLayoutRef,
    pbr::{MaterialPipeline, MaterialPipelineKey}, prelude::*, reflect::TypePath,
    render::render_resource::{AsBindGroup, CompareFunction, RenderPipelineDescriptor,
        ShaderType, SpecializedMeshPipelineError, TextureDimension, TextureFormat},
    shader::ShaderRef,
};
use crate::nexus_complex_material::{Cull,OutputEncoding};
pub const SHADER:&str="shaders/nexus_glow_quad.wgsl";
pub const IMAGE:&str="particles/nexus_glow_linear/glows.dds";
pub const ORDER_COLOR:&str="particles/nexus_glow_linear/color-nexus-gem-glow.dds";
pub const CHAOS_COLOR:&str="particles/nexus_glow_linear/color-turretcrystal.dds";
pub const COLOR:&str="particles/nexus_glow_linear/DefaultColorOverlifetime.dds";

#[derive(Clone,Debug)]
pub struct Textures {pub image:Handle<Image>,pub color:Handle<Image>,pub(crate) samplers:[ImageSamplerDescriptor;2]}
impl Textures {
    /// Samplers are required explicitly: DDS identity does not prove GPU sampling.
    /// Dedicated exact-byte paths isolate raw-linear settings from other users.
    pub fn load(server:&AssetServer,samplers:[ImageSamplerDescriptor;2])->Result<Self,&'static str> {
        Self::load_color(server,samplers,COLOR)
    }
    pub fn load_color(server:&AssetServer,samplers:[ImageSamplerDescriptor;2],color_path:&'static str)->Result<Self,&'static str> {
        if ![COLOR,ORDER_COLOR,CHAOS_COLOR].contains(&color_path){return Err("CrystalGlow unsupported palette path");}
        for s in &samplers {
            if s.compare.is_some() || !s.lod_min_clamp.is_finite() || !s.lod_max_clamp.is_finite()
                || s.lod_min_clamp<0. || s.lod_max_clamp<s.lod_min_clamp {return Err("CrystalGlow invalid explicit sampler");}
        }
        let load=|path:&'static str,sampler:ImageSamplerDescriptor|server.load_builder()
            .with_settings(move |s:&mut ImageLoaderSettings|{s.is_srgb=false;s.sampler=ImageSampler::Descriptor(sampler.clone());}).load(path);
        Ok(Self {image:load(IMAGE,samplers[0].clone()),color:load(color_path,samplers[1].clone()),samplers})
    }
    pub fn validate(&self,images:&Assets<Image>)->Result<(),&'static str> {
        self.validate_palette(images,false)
    }
    pub fn validate_palette(&self,images:&Assets<Image>,simple:bool)->Result<(),&'static str> {
        let (color_size,color_mips,color_format)=if simple{(64,7,TextureFormat::Bc3RgbaUnorm)}else{(8,1,TextureFormat::Bc1RgbaUnorm)};
        for (handle,size,mips,format,sampler) in [(&self.image,64,7,TextureFormat::Bc1RgbaUnorm,&self.samplers[0]),(&self.color,color_size,color_mips,color_format,&self.samplers[1])] {
            let image=images.get(handle).ok_or("CrystalGlow exact DDS not loaded")?;let d=&image.texture_descriptor;
            if d.dimension!=TextureDimension::D2 || d.size.width!=size || d.size.height!=size
                || d.size.depth_or_array_layers!=1 || d.mip_level_count!=mips
                || d.format!=format
                || !matches!(&image.sampler,ImageSampler::Descriptor(actual) if actual==sampler) {
                return Err("CrystalGlow DDS format or sampler changed");
            }
        } Ok(())
    }
}
#[derive(Clone,Copy,Debug)]
pub struct Inputs {pub native_fog_extent:f32,pub encoding:OutputEncoding,pub cull:Cull,
    pub render_mode:u32,pub render_flags:u8,pub shader_features:u32}
#[derive(Clone,Debug,ShaderType)]
struct Uniform {fog:Vec4,control:UVec4}
#[derive(Asset,TypePath,AsBindGroup,Debug,Clone)]
#[bind_group_data(Key)]
pub struct GlowMaterial {
    #[texture(0)] #[sampler(1)] image:Handle<Image>,
    #[texture(2)] #[sampler(3)] color:Handle<Image>,
    #[texture(4)] #[sampler(5)] visibility:Handle<Image>,
    #[texture(6)] #[sampler(7)] overlay:Handle<Image>,
    #[uniform(8)] params:Uniform,
    cull:Cull,
}
#[derive(Clone,Copy,Debug,PartialEq,Eq,Hash)]
pub struct Key {cull:Cull}
impl From<&GlowMaterial> for Key {fn from(m:&GlowMaterial)->Self {Self {cull:m.cull}}}
impl GlowMaterial {
    /// Receives the selected exact native palette: default for Complex Startup,
    /// authored Order/Chaos DDS for Simple On. No generated color substitute.
    pub fn new(textures:&Textures,visibility:Handle<Image>,overlay:Handle<Image>,input:Inputs)
        ->Result<Self,&'static str>
    {
        if input.render_mode!=0 || input.render_flags!=0 || input.shader_features!=0 {
            return Err("CrystalGlow only supports mode0 default QUAD variant");
        }
        let state=crate::particle_render_state::ParticleState::route(0,0)?;
        if state.blend_preset!=2 {return Err("CrystalGlow mode0 blend contract changed");}
        let native=crate::native_fow::FogParams::from_native_extent(input.native_fog_extent)?.params();
        Ok(Self {image:textures.image.clone(),color:textures.color.clone(),visibility,overlay,cull:input.cull,
            params:Uniform {fog:Vec4::new(native.x*20.,native.y*20.,native.z,native.w),control:UVec4::new(0,input.encoding as u32,0,0)}})
    }
    /// Permission is supplied after the host admits exact CPU resources. Bevy
    /// prepares the pipeline independently; this bit is NOT a GPU-ready report.
    pub fn set_admitted(&mut self,admitted:bool) {self.params.control.x=u32::from(admitted);}
    pub fn is_admitted(&self)->bool {self.params.control.x==1}
}
impl Material for GlowMaterial {
    fn fragment_shader()->ShaderRef {SHADER.into()}
    fn alpha_mode(&self)->AlphaMode {AlphaMode::Blend}
    fn enable_prepass()->bool {false}
    fn enable_shadows()->bool {false}
    fn specialize(_: &MaterialPipeline,d:&mut RenderPipelineDescriptor,layout:&MeshVertexBufferLayoutRef,key:MaterialPipelineKey<Self>)
        ->Result<(),SpecializedMeshPipelineError>
    {
        let _=layout.0.get_layout(&[Mesh::ATTRIBUTE_POSITION.at_shader_location(0),
            Mesh::ATTRIBUTE_UV_0.at_shader_location(2),Mesh::ATTRIBUTE_UV_1.at_shader_location(3),Mesh::ATTRIBUTE_COLOR.at_shader_location(5)])?;
        d.primitive.cull_mode=crate::nexus_complex_material::view_cull(key.bind_group_data.cull,key.mesh_key);
        if let Some(depth)=d.depth_stencil.as_mut() {depth.depth_write_enabled=Some(false);depth.depth_compare=Some(CompareFunction::GreaterEqual);}
        if let Some(fragment)=d.fragment.as_mut() {for target in fragment.targets.iter_mut().flatten() {
            target.blend=Some(crate::particle_render_state::ParticleState::base_projected_blend());
        }} Ok(())
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn both_exact_original_dds_decode_and_constructor_stays_unadmitted() {
        use bevy::{asset::RenderAssetUsages,image::{CompressedImageFormats,ImageType}};
        let sampler=ImageSamplerDescriptor::default();let mut images=Assets::<Image>::default();
        let mut decode=|bytes:&[u8]| images.add(Image::from_buffer(bytes,ImageType::Extension("dds"),
            CompressedImageFormats::BC,false,ImageSampler::Descriptor(sampler.clone()),RenderAssetUsages::default()).unwrap());
        let image=decode(include_bytes!("../../../assets/particles/nexus_glow_linear/glows.dds"));
        let color=decode(include_bytes!("../../../assets/particles/nexus_glow_linear/DefaultColorOverlifetime.dds"));
        let textures=Textures {image,color,samplers:[sampler.clone(),sampler]};textures.validate(&images).unwrap();
        let input=Inputs {native_fog_extent:15360.,encoding:OutputEncoding::RawNumeric,cull:Cull::None,
            render_mode:0,render_flags:0,shader_features:0};
        let mut material=GlowMaterial::new(&textures,Handle::default(),Handle::default(),input).unwrap();
        assert_eq!(material.params.control.x,0);material.set_admitted(true);assert_eq!(material.params.control.x,1);
        material.set_admitted(false);assert_eq!(material.params.control.x,0);
        assert!(GlowMaterial::new(&textures,Handle::default(),Handle::default(),Inputs {shader_features:1,..input}).is_err());
        images.remove(textures.color.id());assert!(textures.validate(&images).is_err());
    }
}
