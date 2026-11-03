//! Private E release QUAD binding guard, adapted from the current Projected guard.
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
use crate::{ezreal_r_flash_quad_material::FlashQuadMaterial,
    ezreal_e_release_draw::{Admission, PreparationContexts}};

type InnerData = <FlashQuadMaterial as AsBindGroup>::Data;

/// Every effective QUAD shader/pipeline input is captured, with exact fog bits.
#[derive(Clone, PartialEq, Eq, Debug)]
pub(crate) struct SourceKey {
    pub(crate) images: [AssetId<Image>; 4],
    fog: [u32; 4],
    control: [u32; 4],
    cull: crate::nexus_complex_material::Cull,
    depth_flags: u8,
}
impl SourceKey {
    fn from_inner(inner: &FlashQuadMaterial) -> Option<Self> {
        let (images, fog, control, cull, depth_flags) = inner.strict_source_identity();
        if depth_flags != 1 || control[0] != 1 || control[1] > 1 || control[2..] != [0, 0]
            || fog.iter().any(|bits| !f32::from_bits(*bits).is_finite()) { return None; }
        // Keep output at index1 as required by the physical FoW proof path.
        Some(Self { images: [images[0], images[2], images[3], images[1]], fog, control, cull, depth_flags })
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
    inner: FlashQuadMaterial,
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
    pub(crate) fn new(inner: FlashQuadMaterial) -> Self {
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
    type Param = (<FlashQuadMaterial as AsBindGroup>::Param,
        SRes<RenderAssets<GpuImage>>, SRes<PreparationContexts>);
    fn label() -> &'static str { "ezreal-r-strict-flash-local" }
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
        FlashQuadMaterial::bind_group_layout_entries(device, true)
    }
}
impl Material for StrictMaterial {
    fn vertex_shader() -> ShaderRef { FlashQuadMaterial::vertex_shader() }
    fn fragment_shader() -> ShaderRef { FlashQuadMaterial::fragment_shader() }
    fn alpha_mode(&self) -> AlphaMode { AlphaMode::Blend }
    fn enable_prepass() -> bool { false }
    fn enable_shadows() -> bool { false }
    fn reads_view_transmission_texture(&self) -> bool { false }
    fn specialize(pipeline: &MaterialPipeline, descriptor: &mut RenderPipelineDescriptor,
        layout: &MeshVertexBufferLayoutRef, key: MaterialPipelineKey<Self>,
    ) -> Result<(), SpecializedMeshPipelineError> {
        FlashQuadMaterial::specialize(pipeline, descriptor, layout,
            MaterialPipelineKey::<FlashQuadMaterial> { mesh_key: key.mesh_key, bind_group_data: key.bind_group_data.pipeline })
    }
}

#[cfg(test)]
fn fixture_inner(cull: crate::nexus_complex_material::Cull,
    encoding: crate::nexus_complex_material::OutputEncoding, extent: f32, admitted: bool) -> FlashQuadMaterial {
    let textures = crate::nexus_glow_material::Textures { image: Handle::default(),
        color: Handle::default(), samplers: std::array::from_fn(|_| Default::default()) };
    let mut material = FlashQuadMaterial::new(&textures, Handle::default(), Handle::default(),
        crate::nexus_glow_material::Inputs { native_fog_extent: extent, encoding, cull,
            render_mode: 0, render_flags: 1, shader_features: 0 }).unwrap();
    material.set_admitted(admitted); material
}
#[cfg(test)]
pub(crate) fn fixture_material() -> StrictMaterial {
    StrictMaterial::new(fixture_inner(crate::nexus_complex_material::Cull::None,
        crate::nexus_complex_material::OutputEncoding::RawNumeric, 15360., true))
}

