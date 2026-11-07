//! Selected Ring_Vec_align numeric source, under a fresh no-overlay own policy.
//! The immutable Well document is selected independently from Capture/Odin.
//! e9ad/38b8/94b2 source receipts resolve the selected defaults, not full Well,
//! native owner/provider activation, shared original RNG or framebuffer parity.
use crate::{relic_pickup_complex_profiles as profiles,
    relic_pickup_complex_simulation as complex, tt_capture_sampler as capture};
use openleague_core::{native_complex_color as color, native_complex_linger::Linger,
    native_complex_timing::Timing, native_complex_uv_parameters::UvParameters,
    native_complex_vectors as vectors, native_random::Rng55,
    native_scalar_parameter::ScalarParameter};
use serde_json::Value;

pub const GROUP: &str = "Ring_Vec_align";
pub const SOURCE_TROY_SHA256: &str = "cb00b9309963d6f8c559556948310688a7faad214af70e5371c289f34493e641";
pub const DIFFUSE_REQUEST: &str = "TT_Heal_Platform.tga";
pub const COLOR_REQUEST: &str = "DefaultColorOverLifetime.dds";
/// Dispatcher938939..938953 excludes kind0 from its alignment flag, even when
/// the authored p-vecalign bit is set. This is not a rewrite of that source bit.
pub const VELOCITY_ALIGNMENT: bool = false;
pub const UNIFORM_SCALE: bool = false;
pub const SINGLE_FLAG: u32 = 0;
/// Supported depth-route projection only; primary+2C also has the selected
/// flag-force-animated-mesh-z-write default bit0x10. Do not label it all-zero.
pub const DEPTH_ROUTE_FLAGS: u8 = 0;
const SOURCE_TEXT: &str = include_str!("../../../data/4.20/relic_runes/TT_Heal_RuneWell.json");

#[derive(Debug, Clone)]
pub struct Profile {
    pub numeric: profiles::Profile,
    pub rotations: Vec<capture::RotationSource>,
}

fn document() -> Result<Value, String> {
    serde_json::from_str(SOURCE_TEXT).map_err(|e| format!("Ring source JSON: {e}"))
}

fn scalar(fields: &Value, key: &str, default: f32) -> Result<ScalarParameter, String> {
    ScalarParameter::read_numeric(key, default, |name| profiles::numeric(fields, name))
        .map_err(|e| format!("Ring scalar {key}: {e:?}"))?
        .ok_or_else(|| format!("Ring authored scalar absent: {key}"))
}

fn raw_hash(section: &str, key: &str) -> u32 {
    section.bytes().chain([b'*']).chain(key.bytes()).fold(0u32, |hash, byte| {
        hash.wrapping_mul(65599).wrapping_add(byte.to_ascii_lowercase() as u32)
    })
}

fn absent_raw(document: &Value, key: &str) -> Result<(), String> {
    let hash = raw_hash(GROUP, key);
    let named = document["fields"].as_array().ok_or("Ring encoded fields absent")?;
    let unknown = document["unknown_fields"].as_object().ok_or("Ring unknown hashes absent")?;
    if named.iter().any(|row| row["native_hash"].as_u64() == Some(hash as u64))
        || unknown.contains_key(&hash.to_string())
    {
        return Err(format!("Ring selected missing-field producer activated: {key}"));
    }
    Ok(())
}

pub fn profile() -> Result<Profile, String> {
    from_document(&document()?)
}

/// Only the pinned decoded source is admitted. A null selected definition,
/// overlay/provider materialization, extra producer or modified unmapped hash
/// cannot be replaced by a default here. Actual DDS/FoW/provider ownership must
/// still be admitted by the live adapter; this function has no live provider.
pub fn from_document(input: &Value) -> Result<Profile, String> {
    if input["source"]["sha256"].as_str() != Some(SOURCE_TROY_SHA256)
        || input["semantics_qualified"] != false
    {
        return Err("Ring source identity or qualification scope changed".into());
    }
    let groups = input["groups"].as_array().ok_or("Ring declarations absent")?;
    if groups.len() != 2 || groups[0]["slot"] != 1 || groups[0]["name"] != GROUP
        || groups[1]["slot"] != 2 || groups[1]["name"] != "Firefly_Spin"
        || !groups[1]["fields"].is_null()
    {
        return Err("Ring/Firefly declaration boundary changed".into());
    }
    let sections = input["sections"].as_object().ok_or("Ring sections absent")?;
    let fields = sections.get(GROUP).ok_or("Ring selected definition absent")?;
    let object = fields.as_object().ok_or("Ring selected definition is not an object")?;
    if sections.len() != 2 || !sections.contains_key("System") || groups[0]["fields"] != *fields {
        return Err("Ring selected section/declaration differs".into());
    }
    let system = &sections["System"];
    if system["GroupPart1"] != GROUP || system["GroupPart2"] != "Firefly_Spin"
        || crate::native_particle_class::EmitterClass::from_system(system, 1)?
            != crate::native_particle_class::EmitterClass::Complex
    {
        return Err("Ring requires the selected Complex class".into());
    }
    for name in object.keys() {
        let key = name.to_ascii_lowercase();
        if key.contains("_flex") || key.starts_with("field-") || key.starts_with("e-shape")
            || key.starts_with("particle-") || key.starts_with("p-xquadrot")
            || key.starts_with("emitter-")
        {
            return Err(format!("Ring optional producer not admitted: {name}"));
        }
    }
    // These are actual raw-hash absences in the frozen source, not just missing
    // decoded names. All310 unmapped entries remain part of the document pin.
    for key in ["p-type", "single-particle", "e-local-orient", "uniformscale",
        "p-startframe", "p-framerate", "p-framerate-mult", "p-numframes-mult",
        "p-life-scale", "e-life-scale", "e-rotation1-axis", "p-colortype",
        "p-colorscale", "p-coloroffset", "p-rgba", "flag-disable-z", "p-backfaceon"]
    {
        if object.keys().any(|name| name.eq_ignore_ascii_case(key)) {
            return Err(format!("Ring source outside selected absent-field scope: {key}"));
        }
        absent_raw(input, key)?;
    }
    let reference = document()?;
    if input != &reference {
        return Err("Ring frozen source changed; provider/overlay additions are not admitted".into());
    }
    if fields["p-texture"].as_str() != Some(DIFFUSE_REQUEST)
        || profiles::numeric(fields, "p-texdiv") != Some(vec![2., 1.])
        || profiles::numeric(fields, "p-numframes") != Some(vec![2.])
        || profiles::numeric(fields, "p-randomstartframe") != Some(vec![1.])
        || profiles::numeric(fields, "p-vecalign") != Some(vec![1.])
        || profiles::numeric(fields, "rendermode") != Some(vec![0.])
    {
        return Err("Ring texture/type0/atlas/flags source changed".into());
    }
    let life = scalar(fields, "p-life", 3.)?;
    let timing = Timing::from_group(fields, None).map_err(|e| format!("Ring timing: {e:?}"))?;
    let linger = Linger::from_group(fields, &timing, life.maximum)
        .map_err(|e| format!("Ring linger: {e:?}"))?;
    let numeric = profiles::Profile {
        index: 0, group: GROUP, fields: fields.clone(),
        vectors: vectors::ComplexVectors::from_group(fields).map_err(|e| format!("Ring vectors: {e:?}"))?,
        birth_color: color::ComplexColor::from_group(fields).map_err(|e| format!("Ring birth RGBA: {e:?}"))?,
        lifetime_color: color::ComplexColor::from_lifetime_group(fields)
            .map_err(|e| format!("Ring lifetime RGBA: {e:?}"))?,
        lifetime_scale: vectors::FieldConfig::from_lifetime_scale_group(fields)
            .map_err(|e| format!("Ring lifetime scale: {e:?}"))?,
        rate: scalar(fields, "e-rate", 0.)?, bind: scalar(fields, "p-bindtoemitter", 0.)?,
        uv: UvParameters::from_group(fields).map_err(|e| format!("Ring UV: {e:?}"))?,
        // Nested914B3D fldz,914B4B stores the fallback; p-framerate getter
        //914B55 writes nested+C at914B5D. Its multiplier has a separate0 default.
        start_frame: 0, num_frames: 2, frame_rate: 0., local_emitter_orientation: false,
        lookup: profiles::Lookup { modes: [1, 0], scale: [1.; 2], offset: [0.; 2] },
        life, timing, linger,
    };
    // Generic missing axis fallback912FAF..912FE2 is raw unitY. The selected
    // existing retention adapter normalizes it to [0,3f800001,0] without RNG.
    Ok(Profile { numeric, rotations: vec![capture::RotationSource {
        scalar: scalar(fields, "e-rotation1", 0.)?, axis: [0, 0x3f800000, 0],
    }] })
}

impl Profile {
    fn selected_scope(&self) -> Result<(), String> {
        if self.numeric.group != GROUP || self.numeric.index != 0
            || self.numeric.start_frame != 0 || self.numeric.num_frames != 2
            || self.numeric.frame_rate != 0. || self.numeric.local_emitter_orientation
            || self.rotations.len() != 1 || self.rotations[0].axis != [0, 0x3f800000, 0]
            || self.rotations[0].scalar.table != [1.]
        {
            return Err("Ring numeric carrier outside selected source scope".into());
        }
        Ok(())
    }

    fn shared_birth_profile(&self) -> capture::Profile {
        capture::Profile { numeric: self.numeric.clone(), rotations: self.rotations.clone() }
    }

    /// Retains the native temporary-angle draw and selected axis normalization.
    /// Delegation uses the public numeric carrier only, never Capture's loader.
    pub fn retained(&self, rng: &mut Rng55) -> Result<Vec<capture::RotationSource>, String> {
        self.selected_scope()?;
        self.shared_birth_profile().retained(rng)
    }
}

/// Reuse life -> RGBA -> native vector order -> shared fraction -> retained
/// rotation -> UV, including atomic full-RNG commit and batch emitter age.
pub fn sample_birth(profile: &Profile, retained: &[capture::RotationSource],
    input: complex::BirthInputs, rng: &mut Rng55) -> Result<capture::Sampled, String>
{
    profile.selected_scope()?;
    if retained.iter().any(|r| r.axis != [0, 0x3f800001, 0]) {
        return Err("Ring birth rotation axis lacks selected normalization".into());
    }
    capture::sample_birth(&profile.shared_birth_profile(), retained, input, rng)
}

/// Selected atlas939F75..939FEE. Stored field58 is the existing shared fraction;
/// there is no second random draw or integer random frame. Frequency0 has no
/// elapsed contribution. The finite [0,2] remainder is exact at f64 precision.
pub fn atlas_frame(shared: f32, elapsed: f32, frequency: f32) -> Result<f32, String> {
    if !shared.is_finite() || !(0. ..=1.).contains(&shared)
        || !elapsed.is_finite() || elapsed < 0. || frequency != 0.
    {
        return Err("Ring atlas outside shared [0,1], finite elapsed and frequency0 scope".into());
    }
    let frame = 2f32 * shared; // Original MULSS before x87 remainder.
    Ok(((f64::from(frame) % 2f64) as f32) + 0f32) // Native startframe0 addition.
}

#[cfg(test)]
mod tests {
    use super::*;
    use openleague_core::native_complex_vectors::Field;
    fn state(rng: &Rng55) -> (u32, u32, [u32; 55]) { (rng.first, rng.second, rng.words) }
    fn input(index: u32) -> complex::BirthInputs {
        complex::BirthInputs { time: 1., previous: 0., count: 43, index,
            previous_position: [0.; 3], current_position: [20., 30., 40.], owner_start: 0.,
            instance_duration: f32::MAX, life_owner_scale: 1., life_coefficients: [0.; 3], life_symmetry: 0 }
    }
    fn set(source: &mut Value, key: &str, value: Value) {
        source["sections"][GROUP][key] = value.clone();
        source["groups"][0]["fields"][key] = value;
    }

    #[test]
    fn ring_loader_preserves_persistent_source_and_selected_missing_defaults() {
        let p = profile().unwrap();
        assert_eq!(p.numeric.group, GROUP);
        assert!(p.numeric.fields.get("p-type").is_none());
        assert_eq!(p.numeric.fields["p-vecalign"], 1);
        assert!(!VELOCITY_ALIGNMENT && !UNIFORM_SCALE);
        assert_eq!((SINGLE_FLAG, DEPTH_ROUTE_FLAGS), (0, 0));
        assert_eq!(p.numeric.timing.life.to_bits(), f32::MAX.to_bits());
        assert_eq!(p.numeric.timing.time_offset.to_bits(), 0.15f32.to_bits());
        assert_eq!(p.numeric.rate.table, [130.]);
        assert_eq!(p.numeric.life.table, [3.]);
        assert_eq!((p.numeric.start_frame, p.numeric.num_frames, p.numeric.frame_rate), (0, 2, 0.));
        assert!(!p.numeric.local_emitter_orientation);
        assert_eq!(p.numeric.bind.table, [1.]);
        assert_eq!(p.rotations[0].axis, [0, 0x3f800000, 0]);
    }

    #[test]
    fn ring_loader_rejects_missing_definition_foreign_source_and_extra_producers() {
        let mut missing = document().unwrap();
        missing["groups"][0]["fields"] = Value::Null;
        assert!(from_document(&missing).is_err());
        let mut foreign = document().unwrap();
        foreign["source"]["sha256"] = "foreign".into();
        assert!(from_document(&foreign).is_err());
        for (key, value) in [("p-life_flex0", serde_json::json!(2.)),
            ("field-noise-1", serde_json::json!(1.)), ("e-shape-name", serde_json::json!("shape")),
            ("Particle-Velocity", serde_json::json!([1., 0., 0.])),
            ("single-particle", serde_json::json!(1.)), ("e-local-orient", serde_json::json!(1.)),
            ("uniformscale", serde_json::json!(1.)), ("p-framerate", serde_json::json!(1.))]
        {
            let mut source = document().unwrap(); set(&mut source, key, value);
            assert!(from_document(&source).is_err(), "{key}");
        }
        let mut hashes = document().unwrap();
        hashes["unknown_fields"].as_object_mut().unwrap().insert(
            raw_hash(GROUP, "p-framerate").to_string(), serde_json::json!({"value": 1}));
        assert!(from_document(&hashes).is_err());
        let mut firefly = document().unwrap();
        firefly["groups"][1]["fields"] = serde_json::json!({"e-rate": 1});
        assert!(from_document(&firefly).is_err());
    }

    #[test]
    fn ring_retention_normalizes_axis_and_preserves_exact_one_draw_state() {
        let mut p = profile().unwrap();
        let mut expected = Rng55::seeded(42);
        assert_ne!(expected.fraction() * 360f32, 0.);
        let mut actual = Rng55::seeded(42);
        let retained = p.retained(&mut actual).unwrap();
        assert_eq!(retained.len(), 1);
        assert_eq!(retained[0].axis, [0, 0x3f800001, 0]);
        assert_eq!(state(&actual), state(&expected));
        p.rotations[0].axis = [0x3f800000, 0, 0];
        let before = state(&actual);
        assert!(p.retained(&mut actual).is_err());
        assert_eq!(state(&actual), before);
    }

    #[test]
    fn ring_birth_keeps_six_vector_draws_shared_then_rotation_across_large_batch() {
        let p = profile().unwrap();
        let mut actual = Rng55::seeded(42);
        let retained = p.retained(&mut actual).unwrap();
        let mut expected = Rng55::seeded(42);
        let _temporary_rotation = expected.fraction();
        let mut age = None;
        for index in [0, 19, 42] {
            let sx = expected.fraction(); let sy = expected.fraction();
            let _zero_velocity_x = expected.fraction();
            let orbit_y = expected.fraction();
            let _offset_y = expected.fraction(); let _offset_z = expected.fraction();
            let shared = expected.fraction(); let _rotation = expected.fraction();
            let b = sample_birth(&p, &retained, input(index), &mut actual).unwrap();
            assert_eq!(b.numeric.shared_uv.to_bits(), shared.to_bits());
            assert_eq!(b.numeric.life.to_bits(), 3f32.to_bits());
            assert_eq!(b.numeric.vectors[Field::Scale as usize].map(f32::to_bits),
                [40f32 * (0.5f32 * sx + 0.5), 80f32 * ((1f32 - 0.8) * sy + 0.8), 10.].map(f32::to_bits));
            assert_eq!(b.numeric.vectors[Field::OrbitVelocity as usize][1].to_bits(),
                (0.15f32 * (2f32 * orbit_y + 1.)).to_bits());
            assert_eq!(b.numeric.vectors[Field::Drag as usize], [1., 0., 1.]);
            assert_eq!(b.velocity, [0.; 3]);
            if let Some(previous) = age { assert_eq!(b.numeric.emitter_age.to_bits(), previous); }
            age = Some(b.numeric.emitter_age.to_bits());
            assert_eq!(state(&actual), state(&expected));
            let before_atlas = state(&actual);
            let _frame = atlas_frame(b.numeric.shared_uv, 1., p.numeric.frame_rate).unwrap();
            assert_eq!(state(&actual), before_atlas);
        }
    }

    #[test]
    fn ring_empty_rotation_list_still_keeps_shared_and_zero_velocity_draws() {
        let p = profile().unwrap();
        let mut expected = Rng55::seeded(12345);
        for _ in 0..6 { let _vector = expected.fraction(); }
        let shared = expected.fraction();
        let mut actual = Rng55::seeded(12345);
        let b = sample_birth(&p, &[], input(0), &mut actual).unwrap();
        assert_eq!(b.numeric.shared_uv.to_bits(), shared.to_bits());
        assert_eq!(state(&actual), state(&expected));
    }

    #[test]
    fn ring_shared_atlas_selects_both_tiles_and_wraps_exact_one_without_rng() {
        use openleague_core::native_complex_quad_binding::atlas_uv;
        for (shared, tile_x) in [(0., 0.), (0.25, 0.), (0.5, 0.5),
            (f32::from_bits(0x3f7fffff), 0.5), (1., 0.)]
        {
            let frame = atlas_frame(shared, 1., 0.).unwrap();
            assert_eq!(atlas_uv([0., 0.], frame, [2, 1]).unwrap(), [tile_x, 0.]);
        }
        assert_eq!(atlas_frame(0.25, 0., 0.).unwrap().to_bits(), 0.5f32.to_bits());
        assert_eq!(atlas_frame(0.5, 0., 0.).unwrap().to_bits(), 1f32.to_bits());
        assert_eq!(atlas_frame(1., f32::MAX, 0.).unwrap().to_bits(), 0f32.to_bits());
        for shared in [-0.1, 1.1, f32::NAN, f32::INFINITY] { assert!(atlas_frame(shared, 0., 0.).is_err()); }
        assert!(atlas_frame(0.5, f32::NAN, 0.).is_err());
        assert!(atlas_frame(0.5, -1., 0.).is_err());
        for frequency in [-1., 1., f32::NAN, f32::INFINITY] { assert!(atlas_frame(0.5, 1., frequency).is_err()); }
    }

    #[test]
    fn ring_invalid_birth_or_unprepared_axis_preserves_full_rng() {
        let p = profile().unwrap(); let mut rng = Rng55::seeded(42);
        let retained = p.retained(&mut rng).unwrap(); let before = state(&rng);
        let mut invalid = input(0); invalid.count = 0;
        assert!(sample_birth(&p, &retained, invalid, &mut rng).is_err());
        assert_eq!(state(&rng), before);
        let mut invalid = input(0); invalid.life_coefficients = [1., 0., 0.];
        assert!(sample_birth(&p, &retained, invalid, &mut rng).is_err());
        assert_eq!(state(&rng), before);
        assert!(sample_birth(&p, &p.rotations, input(0), &mut rng).is_err());
        assert_eq!(state(&rng), before);
    }
}
