//! Inactive Slice material candidate. The caller owns effect identity, pose and readiness.
//! The original arithmetic is separate from Bevy sampling/framebuffer adaptations.
use bevy::{
    image::{ImageLoaderSettings, ImageSampler, ImageSamplerDescriptor},
    mesh::MeshVertexBufferLayoutRef,
    pbr::{MaterialPipeline, MaterialPipelineKey},
    prelude::*,
    reflect::TypePath,
    render::render_resource::{
        AsBindGroup, BlendComponent, BlendFactor, BlendOperation, BlendState, CompareFunction,
        RenderPipelineDescriptor, ShaderType, SpecializedMeshPipelineError, TextureDimension, TextureFormat,
    },
    shader::ShaderRef,
};

pub const SCROLL_LINEAR: &str = "champions/garen/effects/slice_linear/Garen_Base_W_Scroll.dds";
pub const LOOKUP_LINEAR: &str = "champions/garen/effects/slice_linear/alpha_20.dds";
pub const SHADER: &str = "shaders/garen_w_slice.wgsl";

/// A deliberate framebuffer boundary, never applied to the scroll/lookup inputs.
/// Neither choice establishes equivalence to the original D3D framebuffer blend.
#[derive(Clone, Copy, Debug)]
pub enum OutputEncoding {
    RawNumeric = 0,
    DisplayToLinear = 1,
}

/// Every value must come from the effect/FoW producer; no local timer or inferred width.
#[derive(Clone, Copy, Debug)]
pub struct Inputs {
    pub uv_scale_offset: Vec4,
    pub color_lookup: Vec2,
    pub color_factor: Vec4,
    pub slice_range: Vec2,
    /// UV = world_position.xz * xy + zw, in the current renderer's world units.
    pub fog_scale_offset: Vec4,
    pub output_encoding: OutputEncoding,
}
impl Inputs {
    fn validate(self) -> Result<Self, &'static str> {
        if !self.uv_scale_offset.is_finite() || !self.color_lookup.is_finite()
            || !self.color_factor.is_finite() || !self.slice_range.is_finite()
            || !self.fog_scale_offset.is_finite()
        {
            return Err("Slice requires finite explicit inputs");
        }
        Ok(self)
    }
}

/// Asset paths are reserved for raw DDS loads, separate from the base W material.
/// Keep this owner for the lifetime of all draws; do not mutate shared Image assets.
#[derive(Clone, Debug)]
pub struct LinearTextures {
    scroll: Handle<Image>,
    lookup: Handle<Image>,
    scroll_sampler: ImageSamplerDescriptor,
    lookup_sampler: ImageSamplerDescriptor,
}
impl LinearTextures {
    /// Invoke once for this profile. Bevy caches by path/type, not loader settings.
    /// The producer must establish the native samplers; this API supplies no default.
    pub fn load(
        assets: &AssetServer,
        scroll_sampler: ImageSamplerDescriptor,
        lookup_sampler: ImageSamplerDescriptor,
    ) -> Result<Self, &'static str> {
        for s in [&scroll_sampler, &lookup_sampler] {
            if s.compare.is_some() || !s.lod_min_clamp.is_finite() || !s.lod_max_clamp.is_finite()
                || s.lod_min_clamp < 0.0 || s.lod_max_clamp < s.lod_min_clamp
            {
                return Err("Slice requires a finite non-comparison sampler");
            }
        }
        let load = |path: &'static str, sampler: ImageSamplerDescriptor| {
            assets.load_builder().with_settings(move |s: &mut ImageLoaderSettings| {
                s.is_srgb = false;
                s.sampler = ImageSampler::Descriptor(sampler.clone());
            }).load(path)
        };
        Ok(Self {
            scroll: load(SCROLL_LINEAR, scroll_sampler.clone()),
            lookup: load(LOOKUP_LINEAR, lookup_sampler.clone()),
            scroll_sampler,
            lookup_sampler,
        })
    }

    pub fn handles(&self) -> [&Handle<Image>; 2] { [&self.scroll, &self.lookup] }

    /// Main-world check only. RenderAssets<GpuImage>, pipeline and generation readiness
    /// must also be checked by the future owner before exposing a draw.
    pub fn validate_images(&self, images: &Assets<Image>) -> Result<(), &'static str> {
        for (handle, sampler, width, height, mips) in [
            (&self.scroll, &self.scroll_sampler, 512, 512, 1),
            (&self.lookup, &self.lookup_sampler, 128, 128, 8),
        ] {
            let image = images.get(handle).ok_or("Slice DDS is not loaded")?;
            let d = &image.texture_descriptor;
            if d.dimension != TextureDimension::D2 || d.size.depth_or_array_layers != 1
                || (d.size.width, d.size.height, d.mip_level_count) != (width, height, mips)
                || d.format != TextureFormat::Bc3RgbaUnorm
            {
                return Err("Slice DDS layout or raw-linear format changed");
            }
            if !matches!(&image.sampler, ImageSampler::Descriptor(actual) if actual == sampler) {
                return Err("Slice DDS sampler does not match the requested profile");
            }
        }
        Ok(())
    }
}

#[derive(Clone, Debug, ShaderType)]
struct Uniform {
    uv_scale_offset: Vec4,
    color_lookup: Vec4,
    color_factor: Vec4,
    slice_range: Vec4,
    fog_scale_offset: Vec4,
    // x: explicit readiness, y: explicit framebuffer conversion; z/w reserved zero.
    control: UVec4,
}
impl Uniform {
    fn from_inputs(inputs: Inputs, ready: bool) -> Self {
        Self {
            uv_scale_offset: inputs.uv_scale_offset,
            color_lookup: inputs.color_lookup.extend(0.0).extend(0.0),
            color_factor: inputs.color_factor,
            slice_range: inputs.slice_range.extend(0.0).extend(0.0),
            fog_scale_offset: inputs.fog_scale_offset,
            control: UVec4::new(u32::from(ready), inputs.output_encoding as u32, 0, 0),
        }
    }
}

#[derive(Asset, TypePath, AsBindGroup, Debug, Clone)]
pub struct SliceMaterial {
    #[texture(0)] #[sampler(1)] scroll: Handle<Image>,
    #[texture(2)] #[sampler(3)] lookup: Handle<Image>,
    #[texture(4)] #[sampler(5)] visibility: Handle<Image>,
    #[texture(6)] #[sampler(7)] overlay: Handle<Image>,
    #[uniform(8)] params: Uniform,
}
impl SliceMaterial {
    /// Starts disabled. `visibility` is fow_gpu::Images.output (mask in red),
    /// `overlay` is the existing DefaultFogOfWarOverlay image. No white fallback.
    pub fn new(
        textures: &LinearTextures, visibility: Handle<Image>, overlay: Handle<Image>, inputs: Inputs,
    ) -> Result<Self, &'static str> {
        Ok(Self {
            scroll: textures.scroll.clone(), lookup: textures.lookup.clone(),
            visibility, overlay, params: Uniform::from_inputs(inputs.validate()?, false),
        })
    }

    /// Readiness always drops. Invalid input retains the previous parameter values,
    /// hidden; the owner must revalidate pose/assets/session/FoW before enabling.
    pub fn update_inputs(&mut self, inputs: Inputs) -> Result<(), &'static str> {
        self.set_draw_ready(false);
        self.params = Uniform::from_inputs(inputs.validate()?, false);
        Ok(())
    }

    /// Rebind on FoW allocation/reload; keeps the draw hidden until validated.
    pub fn bind_fog(&mut self, visibility: Handle<Image>, overlay: Handle<Image>) {
        self.set_draw_ready(false);
        self.visibility = visibility;
        self.overlay = overlay;
    }

    /// Explicit host gate, not a proof of readiness. Also keep ECS Visibility hidden
    /// on missing data, fog/session retirement, reload or any palette failure.
    pub fn set_draw_ready(&mut self, ready: bool) { self.params.control.x = u32::from(ready); }

    pub fn image_handles(&self) -> [&Handle<Image>; 4] {
        [&self.scroll, &self.lookup, &self.visibility, &self.overlay]
    }
}

pub fn mode4_blend() -> BlendState {
    let component = BlendComponent {
        src_factor: BlendFactor::SrcAlpha,
        dst_factor: BlendFactor::One,
        operation: BlendOperation::Add,
    };
    BlendState { color: component, alpha: component }
}

impl Material for SliceMaterial {
    // Default mesh vertex stage preserves Bevy's actual current private skin palette.
    // It is not a claimed bit-identical port of PARTICLE_VS.
    fn fragment_shader() -> ShaderRef { SHADER.into() }
    fn alpha_mode(&self) -> AlphaMode { AlphaMode::Blend }
    fn enable_prepass() -> bool { false }
    fn enable_shadows() -> bool { false }
    fn specialize(
        _: &MaterialPipeline, d: &mut RenderPipelineDescriptor,
        layout: &MeshVertexBufferLayoutRef, _: MaterialPipelineKey<Self>,
    ) -> Result<(), SpecializedMeshPipelineError> {
        // Check required attributes only; retain the default vertex-buffer layout.
        let _ = layout.0.get_layout(&[
            Mesh::ATTRIBUTE_POSITION.at_shader_location(0),
            Mesh::ATTRIBUTE_NORMAL.at_shader_location(1),
            Mesh::ATTRIBUTE_UV_0.at_shader_location(2),
            Mesh::ATTRIBUTE_JOINT_INDEX.at_shader_location(6),
            Mesh::ATTRIBUTE_JOINT_WEIGHT.at_shader_location(7),
        ])?;
        d.primitive.cull_mode = None;
        if let Some(depth) = d.depth_stencil.as_mut() {
            depth.depth_write_enabled = Some(false);
            depth.depth_compare = Some(CompareFunction::GreaterEqual);
        }
        if let Some(fragment) = d.fragment.as_mut() {
            for target in fragment.targets.iter_mut().flatten() {
                target.blend = Some(mode4_blend());
            }
        }
        Ok(())
    }
}
