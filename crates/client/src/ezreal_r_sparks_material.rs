//! Private R sparks QUAD binding guard, adapted from the current Projected guard.
//! Geometry/lifecycle are separate; no native visual parity claimed.
//! Prepared Data owns IDs/weak provenance only, never EncodedOutputProof/transport.
use std::{hash::{Hash, Hasher}, sync::Mutex};
use bevy::{prelude::*, reflect::TypePath, shader::ShaderRef, mesh::MeshVertexBufferLayoutRef,
    ecs::system::{lifetimeless::SRes, SystemParamItem},
    pbr::{MaterialPipeline, MaterialPipelineKey},
    render::{render_asset::RenderAssets, renderer::RenderDevice, texture::GpuImage,
        render_resource::{AsBindGroup, AsBindGroupError, BindGroupLayout, BindGroupLayoutEntry,
            OwnedBindingResource, RenderPipelineDescriptor, SpecializedMeshPipelineError,
            SamplerBindingType, SamplerId, TextureAspect, TextureDimension, TextureFormat, TextureFormatFeatureFlags,
            TextureId, TextureSampleType, TextureUsages, TextureViewDimension, TextureViewId, UnpreparedBindGroup, WgpuFeatures}}};
use crate::{nexus_glow_material::GlowMaterial,
    ezreal_r_sparks_draw::{Admission, PreparationContexts}};

type InnerData = <GlowMaterial as AsBindGroup>::Data;

/// Every effective QUAD shader/pipeline input is captured, with exact fog bits.
#[derive(Clone, PartialEq, Eq, Debug)]
pub(crate) struct SourceKey {
    pub(crate) images: [AssetId<Image>; 4],
    fog: [u32; 4],
    control: [u32; 4],
    cull: crate::nexus_complex_material::Cull,
}
impl SourceKey {
    fn from_inner(inner: &GlowMaterial) -> Option<Self> {
        let (images, fog, control, cull) = inner.strict_source_identity();
        if control[0] != 1 || control[1] > 1 || control[2..] != [0, 0]
            || fog.iter().any(|bits| !f32::from_bits(*bits).is_finite()) { return None; }
        // Keep output at index1 as required by the physical FoW proof path.
        Some(Self { images: [images[0], images[2], images[3], images[1]], fog, control, cull })
    }
    pub(crate) fn output(&self) -> AssetId<Image> { self.images[1] }
}

#[derive(Clone)]
pub(crate) struct BindingCapture {
    pub(crate) admission: Admission,
    pub(crate) inputs: SourceKey,
    pub(crate) physical: ImageBindings,
    pub(crate) recovery: u64,
}

/// Non-owning identities of all four images actually handed to the allocator.
/// The same asset ID may be prepared with a new view or sampler after reload.
/// These values never enter the specialization key or retain GPU resources.
#[derive(Clone, Copy, PartialEq, Eq)]
pub(crate) struct ImageBindings {
    textures: [TextureId; 4],
    views: [TextureViewId; 4],
    samplers: [SamplerId; 4],
}
impl ImageBindings {
    fn from_images(images: [&GpuImage; 4]) -> Self {
        Self {
            textures: images.map(|image| image.texture.id()),
            views: images.map(|image| image.texture_view.id()),
            samplers: images.map(|image| image.sampler.id()),
        }
    }
    pub(crate) fn output(&self) -> (TextureId, TextureViewId) { (self.textures[1], self.views[1]) }
}

pub(crate) fn current_image_bindings(inputs: &SourceKey, images: &RenderAssets<GpuImage>, features: WgpuFeatures) -> Option<ImageBindings> {
    let [Some(texture), Some(output), Some(overlay), Some(color)] = inputs.images.map(|id| images.get(id)) else { return None; };
    let images = [texture, output, overlay, color];
    if !images.into_iter().all(|image| ordinary_image(image, features)) || !mask_image(output, features) { return None; }
    Some(ImageBindings::from_images(images))
}

/// Hash/Eq are EXACTLY the inner pipeline data. No authority or volatile ID
/// becomes a pipeline specialization key. Draw reads current PreparedMaterial.
#[derive(Clone)]
pub(crate) struct StrictData {
    pipeline: InnerData,
    pub(crate) capture: Option<BindingCapture>,
}
impl PartialEq for StrictData { fn eq(&self, other: &Self) -> bool { self.pipeline == other.pipeline } }
impl Eq for StrictData {}
impl Hash for StrictData { fn hash<H: Hasher>(&self, state: &mut H) { self.pipeline.hash(state); } }

#[derive(Asset, TypePath)]
pub(crate) struct StrictMaterial {
    inner: GlowMaterial,
    admission: Option<Admission>,
    capture: Mutex<Option<BindingCapture>>,
}
impl Clone for StrictMaterial {
    fn clone(&self) -> Self {
        Self { inner: self.inner.clone(), admission: self.admission.clone(), capture: Mutex::new(None) }
    }
}
impl StrictMaterial {
    /// Inputs only. Authority is attached to a private Render clone by handoff.
    pub(crate) fn new(inner: GlowMaterial) -> Self {
        Self { inner, admission: None, capture: Mutex::new(None) }
    }
    pub(crate) fn source_key(&self) -> Option<SourceKey> { SourceKey::from_inner(&self.inner) }
    pub(crate) fn for_admission(&self, admission: &Admission) -> Self {
        let mut clone = self.clone();
        clone.admission = Some(admission.clone());
        clone
    }
}

/// Check the effective view format against this device's enabled features.
/// These materials declare sampled Float { filterable: true }; integer, depth,
/// stencil and unfilterable float views cannot satisfy that layout.
/// Adapter-specific extensions beyond WebGPU's feature-dependent guarantees
/// are not assumed; this function never queries or invents adapter capabilities.
fn filterable_float_format(format: TextureFormat, aspect: TextureAspect, features: WgpuFeatures) -> bool {
    let capabilities = format.guaranteed_format_features(features);
    features.contains(format.required_features())
        && format.sample_type(Some(aspect), Some(features)) == Some(TextureSampleType::Float { filterable: true })
        && capabilities.allowed_usages.contains(TextureUsages::TEXTURE_BINDING)
        && capabilities.flags.contains(TextureFormatFeatureFlags::FILTERABLE)
}

fn ordinary_image(image: &GpuImage, features: WgpuFeatures) -> bool {
    let descriptor = &image.texture_descriptor;
    let aspect = image.texture_view_descriptor.as_ref().map(|view| view.aspect).unwrap_or(TextureAspect::All);
    descriptor.dimension == TextureDimension::D2 && descriptor.size.depth_or_array_layers == 1
        && descriptor.sample_count == 1
        && descriptor.size.width > 0 && descriptor.size.height > 0
        && descriptor.usage.contains(TextureUsages::TEXTURE_BINDING)
        && filterable_float_format(image.view_format(), aspect, features)
        && image.texture_view_descriptor.as_ref().and_then(|v| v.dimension)
            .is_none_or(|d| d == TextureViewDimension::D2)
}
fn mask_image(image: &GpuImage, features: WgpuFeatures) -> bool {
    ordinary_image(image, features) && image.texture_descriptor.size.width == 512
        && image.texture_descriptor.size.height == 512
        && image.view_format() == TextureFormat::Rgba8Unorm
}

impl AsBindGroup for StrictMaterial {
    type Data = StrictData;
    type Param = (<GlowMaterial as AsBindGroup>::Param,
        SRes<RenderAssets<GpuImage>>, SRes<PreparationContexts>);
    fn label() -> &'static str { "ezreal-r-strict-sparks-local" }
    fn bind_group_data(&self) -> Self::Data {
        let inputs = self.source_key();
        let capture = self.capture.lock().ok().and_then(|slot| slot.clone())
            .filter(|capture| self.admission.as_ref().is_some_and(|a| a.same(&capture.admission))
                && inputs.as_ref() == Some(&capture.inputs));
        StrictData { pipeline: self.inner.bind_group_data(), capture }
    }
    fn unprepared_bind_group(&self, layout: &BindGroupLayout, device: &RenderDevice,
        param: &mut SystemParamItem<'_, '_, Self::Param>, _force_no_bindless: bool,
    ) -> Result<UnpreparedBindGroup, AsBindGroupError> {
        let fail = || AsBindGroupError::RetryNextUpdate;
        let Ok(mut slot) = self.capture.lock() else { return Err(fail()); };
        *slot = None; // Keep the lock through the whole attempt, including errors.
        let admission = self.admission.as_ref().ok_or_else(fail)?;
        let inputs = self.source_key().ok_or_else(fail)?;
        let context = param.2.current.get(&admission.material).ok_or_else(fail)?;
        if !context.admission.same(admission) || context.inputs != inputs { return Err(fail()); }
        // All four real images must exist: never permit the inner fallback view.
        let images = inputs.images.map(|id| param.1.get(id));
        let [Some(texture), Some(output), Some(overlay), Some(color)] = images else { return Err(fail()); };
        let physical = current_image_bindings(&inputs, &param.1, device.features()).ok_or_else(fail)?;
        if context.physical != physical { return Err(fail()); }
        let unprepared = self.inner.unprepared_bind_group(layout, device, &mut param.0, true)?;
        // Inspect the SAME resources returned to the ordinary allocator, not a
        // second reconstruction. QUAD binding 4 and all sampled views are exact.
        for (binding, image) in [0, 4, 6, 2].into_iter().zip([texture, output, overlay, color]) {
            let mut matches = unprepared.bindings.iter().filter(|(index, _)| *index == binding);
            let Some((_, OwnedBindingResource::TextureView(dimension, view))) = matches.next() else { return Err(fail()); };
            if *dimension != TextureViewDimension::D2 || view.id() != image.texture_view.id()
                || matches.next().is_some() { return Err(fail()); }
        }
        // An unchanged texture view does not imply an unchanged image sampler.
        // The derive's default sampler binding is Filtering for these textures.
        for (binding, image) in [1, 5, 7, 3].into_iter().zip([texture, output, overlay, color]) {
            let mut matches = unprepared.bindings.iter().filter(|(index, _)| *index == binding);
            let Some((_, OwnedBindingResource::Sampler(kind, sampler))) = matches.next() else { return Err(fail()); };
            if *kind != SamplerBindingType::Filtering || sampler.id() != image.sampler.id()
                || matches.next().is_some() { return Err(fail()); }
        }
        *slot = Some(BindingCapture { admission: admission.clone(), inputs,
            physical, recovery: context.recovery });
        Ok(unprepared)
    }
    fn bind_group_layout_entries(device: &RenderDevice, _force_no_bindless: bool) -> Vec<BindGroupLayoutEntry> {
        GlowMaterial::bind_group_layout_entries(device, true)
    }
}
impl Material for StrictMaterial {
    fn vertex_shader() -> ShaderRef { GlowMaterial::vertex_shader() }
    fn fragment_shader() -> ShaderRef { GlowMaterial::fragment_shader() }
    fn alpha_mode(&self) -> AlphaMode { AlphaMode::Blend }
    fn enable_prepass() -> bool { false }
    fn enable_shadows() -> bool { false }
    fn reads_view_transmission_texture(&self) -> bool { false }
    fn specialize(pipeline: &MaterialPipeline, descriptor: &mut RenderPipelineDescriptor,
        layout: &MeshVertexBufferLayoutRef, key: MaterialPipelineKey<Self>,
    ) -> Result<(), SpecializedMeshPipelineError> {
        GlowMaterial::specialize(pipeline, descriptor, layout,
            MaterialPipelineKey::<GlowMaterial> { mesh_key: key.mesh_key, bind_group_data: key.bind_group_data.pipeline })
    }
}

#[cfg(test)]
fn fixture_inner(cull: crate::nexus_complex_material::Cull,
    encoding: crate::nexus_complex_material::OutputEncoding, extent: f32, admitted: bool) -> GlowMaterial {
    let textures = crate::nexus_glow_material::Textures { image: Handle::default(),
        color: Handle::default(), samplers: std::array::from_fn(|_| Default::default()) };
    let mut material = GlowMaterial::new(&textures, Handle::default(), Handle::default(),
        crate::nexus_glow_material::Inputs { native_fog_extent: extent, encoding, cull,
            render_mode: 0, render_flags: 0, shader_features: 0 }).unwrap();
    material.set_admitted(admitted); material
}
#[cfg(test)]
pub(crate) fn fixture_material() -> StrictMaterial {
    StrictMaterial::new(fixture_inner(crate::nexus_complex_material::Cull::None,
        crate::nexus_complex_material::OutputEncoding::RawNumeric, 15360., true))
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::collections::hash_map::DefaultHasher;
    fn hash(value: &StrictData) -> u64 { let mut h = DefaultHasher::new(); value.hash(&mut h); h.finish() }
    #[test]
    fn quad_identity_requires_admission_and_tracks_images_fog_encoding_and_cull() {
        use crate::nexus_complex_material::{Cull, OutputEncoding};
        let mut inner = fixture_inner(Cull::None, OutputEncoding::RawNumeric, 15360., false);
        assert!(StrictMaterial::new(inner.clone()).source_key().is_none());
        inner.set_admitted(true);
        let original = StrictMaterial::new(inner).source_key().unwrap();
        for changed in [fixture_inner(Cull::Back, OutputEncoding::RawNumeric, 15360., true),
            fixture_inner(Cull::None, OutputEncoding::DisplayToLinear, 15360., true),
            fixture_inner(Cull::None, OutputEncoding::RawNumeric, 12000., true)] {
            assert_ne!(original, StrictMaterial::new(changed).source_key().unwrap());
        }
        let mut images = Assets::<Image>::default();
        let handles: Vec<_> = (0..4).map(|_| images.add(Image::default())).collect();
        let textures = crate::nexus_glow_material::Textures { image: handles[0].clone(),
            color: handles[1].clone(), samplers: std::array::from_fn(|_| Default::default()) };
        let input = crate::nexus_glow_material::Inputs { native_fog_extent: 15360.,
            encoding: OutputEncoding::RawNumeric, cull: Cull::None, render_mode: 0,
            render_flags: 0, shader_features: 0 };
        let mut supplied = GlowMaterial::new(&textures, handles[2].clone(), handles[3].clone(), input).unwrap();
        supplied.set_admitted(true);
        let actual = StrictMaterial::new(supplied).source_key().unwrap();
        assert_eq!(actual.images, [handles[0].id(), handles[2].id(), handles[3].id(), handles[1].id()]);
        assert_ne!(original, actual);
    }
    #[test]
    fn clone_attempt_capture_is_private_and_pipeline_data_never_contains_binding_authority() {
        let material = fixture_material();
        let clone = material.clone();
        assert!(!std::ptr::eq(&material.capture, &clone.capture));
        assert!(clone.bind_group_data().capture.is_none());
        let first = material.bind_group_data(); let second = clone.bind_group_data();
        assert!(first == second); assert_eq!(hash(&first), hash(&second));
        // Poison the original slot; clone owns a fresh healthy slot. This does
        // not simulate a GpuImage or claim a successful bind group preparation.
        std::thread::scope(|scope| { let _ = scope.spawn(|| { let _guard = material.capture.lock().unwrap(); panic!("poison fixture"); }).join(); });
        assert!(material.bind_group_data().capture.is_none());
        assert!(clone.capture.lock().is_ok());
    }

    #[test]
    fn sampled_float_layout_rejects_integer_depth_and_unfilterable_effective_formats() {
        let none = WgpuFeatures::empty();
        for format in [TextureFormat::R8Uint, TextureFormat::Rgba8Uint, TextureFormat::Rgba8Sint,
            TextureFormat::R32Sint, TextureFormat::R32Uint, TextureFormat::Depth32Float, TextureFormat::Stencil8] {
            assert!(!filterable_float_format(format, TextureAspect::All, none));
        }
        for aspect in [TextureAspect::All, TextureAspect::DepthOnly, TextureAspect::StencilOnly] {
            assert!(!filterable_float_format(TextureFormat::Depth32FloatStencil8, aspect, WgpuFeatures::DEPTH32FLOAT_STENCIL8));
        }
        assert!(filterable_float_format(TextureFormat::Rgba8Unorm, TextureAspect::All, none));
        assert!(filterable_float_format(TextureFormat::Rgba8UnormSrgb, TextureAspect::All, none));
        assert!(!filterable_float_format(TextureFormat::Rgba32Float, TextureAspect::All, none));
        assert!(filterable_float_format(TextureFormat::Rgba32Float, TextureAspect::All, WgpuFeatures::FLOAT32_FILTERABLE));
        assert!(!filterable_float_format(TextureFormat::Bc3RgbaUnorm, TextureAspect::All, none));
        assert!(filterable_float_format(TextureFormat::Bc3RgbaUnorm, TextureAspect::All, WgpuFeatures::TEXTURE_COMPRESSION_BC));
        // This tests the exact wgpu format-feature contract. It does not create
        // a GpuImage, allocate a bind group or claim an adapter supports a format.
    }
}
