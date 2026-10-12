//! Source-derived MESH shader subset; not a claim of native GPU equivalence.
use bevy::{
    image::{ImageLoaderSettings, ImageSampler, ImageSamplerDescriptor},
    mesh::MeshVertexBufferLayoutRef,
    pbr::{MaterialPipeline, MaterialPipelineKey, MeshPipelineKey},
    prelude::*, reflect::TypePath,
    render::render_resource::{AsBindGroup, BlendComponent, BlendFactor, BlendOperation,
        BlendState, CompareFunction, Face, RenderPipelineDescriptor, ShaderType,
        SpecializedMeshPipelineError, TextureDimension, TextureFormat},
    shader::ShaderRef,
};
use crate::nexus_complex_mesh::Group;

pub const SHADER: &str = "shaders/nexus_complex_mesh.wgsl";

/// Raster/front-face and output encoding are explicit renderer adaptations until
/// the Nexus draw state/target has been qualified. Neither has a silent default.
#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
pub enum Cull { None, Front, Back }
#[derive(Clone, Copy, Debug)]
pub enum OutputEncoding { RawNumeric = 0, DisplayToLinear = 1 }
#[derive(Clone, Copy, Debug)]
pub struct Inputs {
    pub uv_scale_offset: Vec4,
    pub lookup_uv: Vec2,
    pub color_factor: Vec4,
    pub native_fog_extent: f32,
    pub output_encoding: OutputEncoding,
    pub cull: Cull,
    /// Native shader flags. Zero is the only implemented variant: no slice, vertex
    /// colors, reflection, soft/screen/mult/separate UV, palette, death or debug tint.
    pub shader_features: u32,
    pub fresnel: Vec4,
    pub render_mode: u32,
    pub render_flags: u8,
}
impl Inputs {
    pub fn validate(self) -> Result<Self, &'static str> {
        if !self.uv_scale_offset.is_finite() || !self.lookup_uv.is_finite()
            || !self.color_factor.is_finite() || !self.fresnel.is_finite()
        { return Err("Nexus material parameters must be finite"); }
        if self.shader_features != 0 || self.fresnel.truncate() != Vec3::ZERO {
            return Err("Nexus MESH shader variant is outside the supported subset");
        }
        let state = crate::particle_render_state::ParticleState::route(self.render_mode, self.render_flags)?;
        if self.render_mode > 1 || self.render_flags & !1 != 0
            || state.blend_preset != if self.render_mode == 0 {2} else {1} {
            return Err("Nexus backend only supports mode0/preset2 and mode1/preset1 without extra render flags");
        }
        crate::native_fow::FogParams::from_native_extent(self.native_fog_extent)?;
        Ok(self)
    }
}

#[derive(Clone, Debug)]
pub struct Textures {
    pub(crate) inside: Handle<Image>, pub(crate) gem: Handle<Image>,
    pub(crate) sparkle: Option<Handle<Image>>,
    sampler: ImageSamplerDescriptor,
}
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum TextureSet { Startup, StartupWithSparkle, On, ChaosOn }
impl TextureSet {
    fn path(self,group:Group)->Option<&'static str> {
        match (self,group) {
            (Self::Startup,Group::GemSparkle)=>None,
            (Self::Startup | Self::StartupWithSparkle,group)=>Some(group.texture_asset()),
            (Self::On,Group::GemInside)=>Some("particles/nexus_complex_linear/Order_Nexus_Gem_inside.dds"),
            (Self::On,Group::Gem)=>Some("particles/nexus_complex_linear/Order_Nexus_Gem.dds"),
            (Self::On | Self::ChaosOn,Group::GemSparkle)=>Some(Group::GemSparkle.texture_asset()),
            (Self::ChaosOn,Group::GemInside)=>Some("particles/nexus_complex_linear/Purple_Gem_inside.dds"),
            (Self::ChaosOn,Group::Gem)=>Some("particles/nexus_complex_linear/Purple_Gem.dds"),
        }
    }
}
impl Textures {
    #[cfg(test)]
    pub(crate) fn fixture(images: &mut Assets<Image>) -> Self {
        Self::fixture_set(images,TextureSet::Startup)
    }
    #[cfg(test)]
    pub(crate) fn fixture_set(images: &mut Assets<Image>,set:TextureSet) -> Self {
        use bevy::{asset::RenderAssetUsages, image::{CompressedImageFormats, ImageType}};
        let sampler=ImageSamplerDescriptor::default();
        let mut decode=|bytes:&[u8]| images.add(Image::from_buffer(bytes,ImageType::Extension("dds"),
            CompressedImageFormats::BC,false,ImageSampler::Descriptor(sampler.clone()),RenderAssetUsages::default()).unwrap());
        let (inside,gem):(&[u8],&[u8])=match set {
            TextureSet::Startup | TextureSet::StartupWithSparkle=>(include_bytes!("../../../assets/particles/nexus_complex_linear/Nexus_Gem_inside_mono.dds"),
                include_bytes!("../../../assets/particles/nexus_complex_linear/Nexus_Gem_mono.dds")),
            TextureSet::On=>(include_bytes!("../../../assets/particles/nexus_complex_linear/Order_Nexus_Gem_inside.dds"),
                include_bytes!("../../../assets/particles/nexus_complex_linear/Order_Nexus_Gem.dds")),
            TextureSet::ChaosOn=>(include_bytes!("../../../assets/particles/nexus_complex_linear/Purple_Gem_inside.dds"),
                include_bytes!("../../../assets/particles/nexus_complex_linear/Purple_Gem.dds")),
        };
        Self {inside:decode(inside),gem:decode(gem),
            sparkle:(set!=TextureSet::Startup).then(||decode(include_bytes!("../../../assets/particles/nexus_complex_linear/Nexus_Gem_Sparkle.dds"))),sampler}
    }
    /// Dedicated asset paths prevent conflicting sRGB loader settings on shared DDS.
    /// This function does not choose a native sampler; the caller must supply it.
    pub fn load(assets: &AssetServer, sampler: ImageSamplerDescriptor) -> Result<Self, &'static str> {
        Self::load_set(assets,sampler,TextureSet::Startup)
    }
    pub fn load_set(assets: &AssetServer, sampler: ImageSamplerDescriptor,set:TextureSet) -> Result<Self, &'static str> {
        if sampler.compare.is_some() || !sampler.lod_min_clamp.is_finite()
            || !sampler.lod_max_clamp.is_finite() || sampler.lod_min_clamp < 0.
            || sampler.lod_max_clamp < sampler.lod_min_clamp
        { return Err("Nexus needs an explicit finite non-comparison sampler"); }
        let load = |path: &'static str| {
            let sampler = sampler.clone();
            assets.load_builder().with_settings(move |s: &mut ImageLoaderSettings| {
                s.is_srgb = false; s.sampler = ImageSampler::Descriptor(sampler.clone());
            }).load(path)
        };
        Ok(Self { inside: load(set.path(Group::GemInside).expect("both sets have inside")),
            gem: load(set.path(Group::Gem).expect("both sets have gem")),
            sparkle:set.path(Group::GemSparkle).map(load),sampler })
    }
    pub fn handle(&self, group: Group) -> Result<&Handle<Image>, &'static str> {
        match group { Group::GemInside => Ok(&self.inside), Group::Gem => Ok(&self.gem),
            Group::GemSparkle => self.sparkle.as_ref().ok_or("Nexus sparkle texture absent from this resource") }
    }
    pub fn validate(&self, images: &Assets<Image>) -> Result<(), &'static str> {
        for group in [Group::GemInside, Group::Gem].into_iter().chain(self.sparkle.as_ref().map(|_|Group::GemSparkle)) {
            let image = images.get(self.handle(group)?).ok_or("Nexus DDS not loaded")?;
            let d = &image.texture_descriptor;
            let (size, mips) = group.dimensions();
            if d.dimension != TextureDimension::D2 || d.size.width != size || d.size.height != size
                || d.size.depth_or_array_layers != 1 || d.mip_level_count != mips
                || d.format != TextureFormat::Bc3RgbaUnorm
                || !matches!(&image.sampler, ImageSampler::Descriptor(actual) if actual == &self.sampler)
            { return Err("Nexus DDS format, dimensions or requested sampler changed"); }
        }
        Ok(())
    }
}

/// The producer supplies its actual color table. The live adapter bakes the
/// original authored curve, then explicitly adapts transport to RGBA8/nearest.
/// No unrelated W or white fallback image.
#[derive(Clone, Debug)]
pub struct Bindings {
    pub textures: Textures,
    pub lookup: [Handle<Image>; 2], pub visibility: Handle<Image>, pub overlay: Handle<Image>,
    pub sparkle_lookup: Option<Handle<Image>>,
}
impl Bindings {
    pub fn validate(&self, images: &Assets<Image>) -> Result<(), &'static str> {
        self.textures.validate(images)?;
        if self.textures.sparkle.is_some() != self.sparkle_lookup.is_some() {
            return Err("Nexus sparkle texture/table pair incomplete");
        }
        for handle in self.lookup.iter().chain(self.sparkle_lookup.iter()) {
        let lookup = images.get(handle).ok_or("Nexus color lookup not loaded")?;
        if lookup.texture_descriptor.dimension != TextureDimension::D2
            || lookup.texture_descriptor.format.is_srgb()
            || lookup.texture_descriptor.size.width == 0 || lookup.texture_descriptor.size.height == 0
            || lookup.texture_descriptor.size.depth_or_array_layers != 1
        { return Err("Nexus needs the actual raw-linear 2D color table"); }
        }
        // Visibility may be RenderAssetUsages::RENDER_WORLD only. GPU existence and
        // exact TextureId validation belong to the caller's RenderApp admission.
        Ok(())
    }
    pub fn images(&self, group: Group) -> Result<[Handle<Image>; 4], &'static str> {
        let lookup=match group {Group::GemInside=>&self.lookup[0],Group::Gem=>&self.lookup[1],
            Group::GemSparkle=>self.sparkle_lookup.as_ref().ok_or("Nexus sparkle table absent from this resource")?};
        Ok([self.textures.handle(group)?.clone(), lookup.clone(), self.visibility.clone(), self.overlay.clone()])
    }
    pub fn watched_images(&self) -> Vec<bevy::asset::AssetId<Image>> {
        [&self.textures.inside,&self.textures.gem,&self.lookup[0],&self.lookup[1],&self.overlay]
            .into_iter().chain(self.textures.sparkle.iter()).chain(self.sparkle_lookup.iter()).map(Handle::id).collect()
    }
}

#[derive(Clone, Debug, ShaderType)]
struct Uniform { uv: Vec4, lookup: Vec4, color: Vec4, fog: Vec4, control: UVec4 }
#[derive(Asset, TypePath, AsBindGroup, Debug, Clone)]
#[bind_group_data(MaterialKey)]
pub struct NexusMaterial {
    #[texture(0)] #[sampler(1)] image: Handle<Image>,
    #[texture(2)] #[sampler(3)] lookup: Handle<Image>,
    #[texture(4)] #[sampler(5)] visibility: Handle<Image>,
    #[texture(6)] #[sampler(7)] overlay: Handle<Image>,
    #[uniform(8)] params: Uniform,
    cull: Cull,
    render_mode: u32,
}
#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
pub struct MaterialKey { cull: Cull, render_mode: u32 }
impl From<&NexusMaterial> for MaterialKey {
    fn from(m: &NexusMaterial) -> Self { Self { cull: m.cull, render_mode:m.render_mode } }
}
impl NexusMaterial {
    pub fn new(bindings: &Bindings, group: Group, input: Inputs) -> Result<Self, &'static str> {
        Self::from_images(bindings.images(group)?, input)
    }
    /// Reusable MESH subset. Caller must admit the exact texture/table/FoW set
    /// before publication; this constructor alone makes no resource/GPU claim.
    pub(crate) fn from_images(bound: [Handle<Image>; 4], input: Inputs) -> Result<Self, &'static str> {
        let input = input.validate()?;
        let native = crate::native_fow::FogParams::from_native_extent(input.native_fog_extent)?.params();
        Ok(Self {
            image: bound[0].clone(), lookup: bound[1].clone(),
            visibility: bound[2].clone(), overlay: bound[3].clone(), cull: input.cull,
            render_mode:input.render_mode,
            params: Uniform { uv: input.uv_scale_offset, lookup: input.lookup_uv.extend(0.).extend(0.),
                color: input.color_factor, fog: Vec4::new(native.x*20., native.y*20., native.z, native.w),
                control: UVec4::new(0, input.output_encoding as u32, 0, 0) },
        })
    }
    pub(crate) fn set_ready(&mut self, ready: bool) { self.params.control.x = u32::from(ready); }
    pub fn is_ready(&self) -> bool { self.params.control.x == 1 }
}
pub fn mode1_blend() -> BlendState {
    let component = BlendComponent { src_factor: BlendFactor::SrcAlpha,
        dst_factor: BlendFactor::OneMinusSrcAlpha, operation: BlendOperation::Add };
    BlendState { color: component, alpha: component }
}
/// Original932A60 mode0 -> preset2 and9AC600: ONE/ONE RGB and alpha.
/// Reuses the qualified render-state function; no claim about complete GPU output.
pub fn supported_blend(mode:u32)->Result<BlendState,&'static str> {
    match mode {0=>Ok(crate::particle_render_state::ParticleState::base_projected_blend()),
        1=>Ok(mode1_blend()),_=>Err("Nexus blend mode outside the two-resource subset")}
}
/// Match Bevy StandardMaterial's view reflection handling. Our custom material
/// specializes after the common mesh pipeline, which does not perform this swap.
pub(crate) fn view_cull(cull:Cull,key:MeshPipelineKey)->Option<Face> {
    match (cull,key.contains(MeshPipelineKey::INVERT_CULLING)) {
        (Cull::None,_)=>None,
        (Cull::Front,false)|(Cull::Back,true)=>Some(Face::Front),
        (Cull::Back,false)|(Cull::Front,true)=>Some(Face::Back),
    }
}
impl Material for NexusMaterial {
    fn fragment_shader() -> ShaderRef { SHADER.into() }
    fn alpha_mode(&self) -> AlphaMode { AlphaMode::Blend }
    fn enable_prepass() -> bool { false }
    fn enable_shadows() -> bool { false }
    fn specialize(_: &MaterialPipeline, d: &mut RenderPipelineDescriptor,
        layout: &MeshVertexBufferLayoutRef, key: MaterialPipelineKey<Self>) -> Result<(), SpecializedMeshPipelineError>
    {
        let _ = layout.0.get_layout(&[Mesh::ATTRIBUTE_POSITION.at_shader_location(0),
            Mesh::ATTRIBUTE_UV_0.at_shader_location(2), Mesh::ATTRIBUTE_COLOR.at_shader_location(5)])?;
        d.primitive.cull_mode = view_cull(key.bind_group_data.cull,key.mesh_key);
        if let Some(depth) = d.depth_stencil.as_mut() {
            depth.depth_write_enabled = Some(false);
            depth.depth_compare = Some(CompareFunction::GreaterEqual);
        }
        if let Some(fragment) = d.fragment.as_mut() {
            for target in fragment.targets.iter_mut().flatten() {
                target.blend = Some(supported_blend(key.bind_group_data.render_mode).expect("validated Nexus material mode"));
            }
        }
        Ok(())
    }
}
