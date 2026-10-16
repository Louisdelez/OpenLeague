//! Exact Heal_Plus source and BC1 CPU texture admission. No ordinary producer.
//! Native sampler, shadow pass, owner pose, GPU use and retirement are separate.
use bevy::{asset::RenderAssetUsages, image::{CompressedImageFormats, ImageSampler,
    ImageSamplerDescriptor, ImageType}, prelude::*,
    render::render_resource::{TextureDimension, TextureFormat}};
use openleague_core::{native_complex_mesh_pose as mesh_pose,
    native_complex_timing::Timing, native_complex_linger::Linger};
use serde_json::Value;

pub const SOURCE_TROY_SHA256: &str = "6b84766de781ec91ef83f7d373104fa8cbc97627b929d2504033c3c4f93aff74";
pub const DIFFUSE_SHA256: &str = "0fcb3d98976985436701a1289b9739d16c126543b49d6c4e1a7efac1034fe1b5";
pub const DIFFUSE: &[u8] = include_bytes!("../../../assets/particles/relic_runes/color-hold.DDS");
const DOCUMENT: &str = include_str!("../../../data/4.20/relic_runes/TT_Heal_Rune.json");
pub const GROUP: &str = "Heal_Plus";
pub const DIFFUSE_REQUEST: &str = "color-hold.tga";
pub const MESH_REQUEST: &str = "TT_Heal_Plus.sco";

/// Authored input values, not a birth record or a native activation token.
/// Private construction rejects foreign sections, overlays and unknown changes.
#[derive(Debug, Clone)]
pub struct Authored {
    scale: [f32; 3], post: [f32; 3], rotation_velocity: [f32; 3],
    particle_life: f32, emitter_life: f32, particle_linger: f32,
    emitter_linger: f32, shadow: bool, render_mode: u32, pass: i32,
    single: u32, bind: f32, rate: f32, lifetime_color: [f32; 4],
}
fn document() -> Result<Value, String> {
    serde_json::from_str(DOCUMENT).map_err(|e| format!("Heal_Plus source JSON: {e}"))
}
fn raw_hash(section: &str, key: &str) -> u32 {
    section.bytes().chain([b'*']).chain(key.bytes()).fold(0, |h: u32, b| {
        h.wrapping_mul(65599).wrapping_add(b.to_ascii_lowercase() as u32)
    })
}
fn absent_raw(input: &Value, key: &str) -> Result<(), String> {
    let h = raw_hash(GROUP, key);
    let fields = input["fields"].as_array().ok_or("Heal_Plus raw fields absent")?;
    let unknown = input["unknown_fields"].as_object().ok_or("Heal_Plus raw unknown hashes absent")?;
    if fields.iter().any(|f| f["native_hash"].as_u64() == Some(h as u64))
        || unknown.contains_key(&h.to_string())
    { return Err(format!("Heal_Plus missing-field input materialized: {key}")); }
    Ok(())
}
impl Authored {
    pub fn load() -> Result<Self, String> { Self::from_document(&document()?) }
    pub fn from_document(input: &Value) -> Result<Self, String> {
        if input != &document()? || input["source"]["sha256"] != SOURCE_TROY_SHA256
            || input["semantics_qualified"] != false
        { return Err("Heal_Plus frozen source or scope changed".into()); }
        let groups = input["groups"].as_array().ok_or("Rune declarations absent")?;
        let slot = groups.iter().find(|g| g["slot"] == 1).ok_or("Rune slot 1 absent")?;
        let f = &input["sections"][GROUP];
        if slot["name"] != GROUP || slot["fields"] != *f
            || input["sections"]["System"]["GroupPart1"] != GROUP
            || crate::native_particle_class::EmitterClass::from_system(&input["sections"]["System"], 1)?
                != crate::native_particle_class::EmitterClass::Complex
        { return Err("Heal_Plus selected Complex slot changed".into()); }
        // Only these missing timing fields are projected through the qualified
        // generic timing helper. Other missing defaults remain unadmitted.
        for key in ["e-timeoffset", "e-active", "e-period"] { absent_raw(input, key)?; }
        let type_hash = raw_hash("System", "GroupPart1Type");
        if input["fields"].as_array().unwrap().iter()
            .any(|row| row["native_hash"].as_u64() == Some(type_hash as u64))
            || input["unknown_fields"].as_object().unwrap().contains_key(&type_hash.to_string())
        { return Err("Heal_Plus selected class default is not raw-absent".into()); }
        let scalar = |key: &str| -> Result<f32, String> {
            f[key].as_f64().map(|v| v as f32).filter(|v| v.is_finite())
                .ok_or_else(|| format!("Heal_Plus authored scalar absent: {key}"))
        };
        let vec3 = |key: &str| -> Result<[f32; 3], String> {
            let a = f[key].as_array().ok_or_else(|| format!("Heal_Plus vector absent: {key}"))?;
            if a.len() != 3 { return Err(format!("Heal_Plus vector length: {key}")); }
            let values = a.iter().map(|v| v.as_f64().map(|v| v as f32))
                .collect::<Option<Vec<_>>>().ok_or_else(|| format!("Heal_Plus vector invalid: {key}"))?;
            if values.iter().any(|v| !v.is_finite()) { return Err("nonfinite Heal_Plus vector".into()); }
            Ok(values.try_into().unwrap())
        };
        if f["p-meshtex"] != DIFFUSE_REQUEST || f["p-mesh"] != MESH_REQUEST
            || scalar("p-type")? != 3. || scalar("rendermode")? != 1.
            || scalar("single-particle")? != 1. || scalar("p-shadow")? != 1.
            || scalar("pass")? != 1.
        { return Err("Heal_Plus authored mesh/material fields changed".into()); }
        let color = f["p-xrgba"].as_array().ok_or("Heal_Plus lifetime color absent")?;
        if color.len() != 4 { return Err("Heal_Plus lifetime color length".into()); }
        let color: Vec<f32> = color.iter().map(|v| v.as_f64().map(|v| v as f32))
            .collect::<Option<_>>().ok_or("Heal_Plus lifetime color invalid")?;
        if color.iter().any(|v| !v.is_finite()) { return Err("Heal_Plus lifetime color nonfinite".into()); }
        Ok(Self { scale: vec3("p-scale")?, post: vec3("p-postoffset")?,
            rotation_velocity: vec3("p-rotvel")?, particle_life: scalar("p-life")?,
            emitter_life: scalar("e-life")?, particle_linger: scalar("p-linger")?,
            emitter_linger: scalar("e-linger")?, shadow: true, render_mode: 1,
            pass: 1, single: 1, bind: scalar("p-bindtoemitter")?, rate: scalar("e-rate")?,
            lifetime_color: color.try_into().unwrap() })
    }
    pub fn scale(&self) -> [f32; 3] { self.scale }
    pub fn post_offset(&self) -> [f32; 3] { self.post }
    pub fn rotation_velocity_authored(&self) -> [f32; 3] { self.rotation_velocity }
    pub fn particle_life_authored(&self) -> f32 { self.particle_life }
    pub fn lifetime_color_authored(&self) -> [f32; 4] { self.lifetime_color }
    pub fn single_field(&self) -> u32 { self.single }
    pub fn bind_authored(&self) -> f32 { self.bind }
    pub fn rate_authored(&self) -> f32 { self.rate }
    pub fn native_shadow(&self) -> bool { self.shadow }
    pub fn render_mode(&self) -> u32 { self.render_mode }
    pub fn native_pass(&self) -> i32 { self.pass }
    /// Native generic negative e-life branch returns FLT_MAX. This does not
    /// produce instance7C, owner start, single emission or actual callback timing.
    pub fn timing_fragment(&self) -> Timing {
        Timing::from_scalars(None, Some(self.emitter_life), None, None, None)
    }
    pub fn linger_fragment(&self) -> Linger {
        Linger::from_scalars(self.particle_life, self.timing_fragment().life,
            Some(self.particle_linger), Some(self.emitter_linger))
    }
    /// Actual owner/particle row-vector pose is a mandatory supplied input.
    /// No elapsed*80 Euler shortcut, identity fallback or pivot guess is made.
    pub fn compose_with_owned_pose(&self, centre: [f32; 3], pose: [f32; 16])
        -> Result<[f32; 16], &'static str>
    {
        mesh_pose::compose(mesh_pose::Inputs { centre, scale: self.scale,
            post_offset: self.post, pose })
    }
    /// Native p-shadow is definition+178 and participates in original pass1
    /// eligibility. NexusMaterial has no qualified equivalent shadow pass.
    /// Never replace this requirement by Bevy enable_shadows or silently false.
    pub fn admit_current_material(&self) -> Result<(), &'static str> {
        if self.shadow { return Err("Heal_Plus native p-shadow/pass1 backend is not qualified"); }
        Err("Heal_Plus complete mesh material producer is not qualified")
    }
}

/// CPU transport admission only. Caller explicitly supplies sampler settings;
/// none of the accepted settings are labelled original until sampler proof exists.
pub fn decode_diffuse(bytes: &[u8], supported: CompressedImageFormats,
    sampler: ImageSamplerDescriptor) -> Result<Image, String>
{
    if bytes != DIFFUSE { return Err("Heal_Plus diffuse differs from exact original BC1".into()); }
    if sampler.compare.is_some() || !sampler.lod_min_clamp.is_finite()
        || !sampler.lod_max_clamp.is_finite() || sampler.lod_min_clamp < 0.
        || sampler.lod_max_clamp < sampler.lod_min_clamp
    { return Err("Heal_Plus requires explicit finite non-comparison sampler".into()); }
    let image = Image::from_buffer(bytes, ImageType::Extension("dds"), supported, false,
        ImageSampler::Descriptor(sampler.clone()),
        RenderAssetUsages::MAIN_WORLD | RenderAssetUsages::RENDER_WORLD)
        .map_err(|e| format!("Heal_Plus original DDS decode: {e}"))?;
    validate_diffuse(&image, &sampler)?;
    Ok(image)
}
/// Raw DDS has mipCount0. Bevy0.19 explicitly transports it as one BC1 mip;
/// exact compressed payload remains32bytes. This is not a BC3 Nexus texture.
pub fn validate_diffuse(image: &Image, sampler: &ImageSamplerDescriptor) -> Result<(), String> {
    let d = &image.texture_descriptor;
    if d.dimension != TextureDimension::D2 || d.size.width != 8 || d.size.height != 8
        || d.size.depth_or_array_layers != 1 || d.mip_level_count != 1
        || d.format != TextureFormat::Bc1RgbaUnorm
        || image.data.as_deref() != Some(&DIFFUSE[128..])
        || image.texture_view_descriptor.is_some()
        || !matches!(&image.sampler, ImageSampler::Descriptor(actual) if actual == sampler)
    { return Err("Heal_Plus BC1 format, dimensions, payload or supplied sampler changed".into()); }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn heal_plus_native_bc1_keeps_original_payload_and_zero_header_mip_transport() {
        let sampler = ImageSamplerDescriptor::default(); // Test input only, not native default.
        let image = decode_diffuse(DIFFUSE, CompressedImageFormats::BC, sampler.clone()).unwrap();
        assert_eq!(&DIFFUSE[84..88], b"DXT1");
        assert_eq!(u32::from_le_bytes(DIFFUSE[28..32].try_into().unwrap()), 0);
        assert_eq!(image.texture_descriptor.mip_level_count, 1);
        assert_eq!(image.texture_descriptor.format, TextureFormat::Bc1RgbaUnorm);
        assert_eq!(image.data.as_ref().unwrap().len(), 32);
        validate_diffuse(&image, &sampler).unwrap();
    }
    #[test]
    fn heal_plus_native_bc1_rejects_foreign_data_support_and_mutated_binding() {
        let sampler = ImageSamplerDescriptor::default();
        for at in [0, 28, 84, 128, 159] {
            let mut changed = DIFFUSE.to_vec(); changed[at] ^= 1;
            assert!(decode_diffuse(&changed, CompressedImageFormats::BC, sampler.clone()).is_err());
        }
        assert!(decode_diffuse(&DIFFUSE[..159], CompressedImageFormats::BC, sampler.clone()).is_err());
        assert!(decode_diffuse(DIFFUSE, CompressedImageFormats::NONE, sampler.clone()).is_err());
        let mut image = decode_diffuse(DIFFUSE, CompressedImageFormats::BC, sampler.clone()).unwrap();
        image.texture_descriptor.format = TextureFormat::Bc3RgbaUnorm;
        assert!(validate_diffuse(&image, &sampler).is_err());
        image.texture_descriptor.format = TextureFormat::Bc1RgbaUnorm;
        image.data.as_mut().unwrap()[0] ^= 1;
        assert!(validate_diffuse(&image, &sampler).is_err());
    }
    #[test]
    fn heal_plus_native_authored_pose_life_and_shadow_are_not_guessed() {
        let a = Authored::load().unwrap();
        assert_eq!(a.scale(), [40.; 3]); assert_eq!(a.post_offset(), [0., 125., 0.]);
        assert_eq!(a.rotation_velocity_authored(), [0., 80., 0.]);
        assert_eq!(a.particle_life_authored(), -1.);
        assert_eq!(a.timing_fragment().life.to_bits(), 0x7f7fffff);
        assert_eq!((a.linger_fragment().particle, a.linger_fragment().emitter), (1., 1.));
        assert_eq!((a.single_field(), a.bind_authored(), a.rate_authored()), (1, 1., 1.));
        assert!(a.native_shadow()); assert_eq!(a.native_pass(), 1);
        assert!(a.admit_current_material().is_err());
        assert!(a.compose_with_owned_pose([0.; 3], [f32::NAN; 16]).is_err());
    }
    #[test]
    fn heal_plus_native_authored_rejects_overlay_unknown_change_and_foreign_group() {
        for mutate in 0..4 {
            let mut changed = document().unwrap();
            match mutate {
                0 => changed["sections"][GROUP]["p-shadow"] = serde_json::json!(0),
                1 => changed["unknown_fields"]["1"] = serde_json::json!(42),
                2 => changed["groups"][0]["name"] = serde_json::json!("Heal_Plus_Env"),
                _ => changed["semantics_qualified"] = serde_json::json!(true),
            }
            assert!(Authored::from_document(&changed).is_err());
        }
    }
}
