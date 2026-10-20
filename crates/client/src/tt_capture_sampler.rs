//! TT Capture's two authored Complex groups, sampled in the source birth order.
//! The source profile is independent from the selected Odin heal profiles.
//! This is an own Rust composition: global original RNG/framebuffer parity is not claimed.
use crate::{relic_pickup_complex_profiles as profiles, relic_pickup_complex_simulation as complex};
use openleague_core::{
    native_complex_birth as birth, native_complex_color as color,
    native_complex_linger::Linger, native_complex_timing::Timing,
    native_complex_uv_parameters::UvParameters, native_complex_vectors::{self as vectors, Field},
    native_probability_curve::apply_probability, native_random::Rng55,
    native_scalar_parameter::{baked_scalar_index, ScalarParameter},
    native_simple_rotation_list as rotation,
};
use serde_json::Value;

pub const GROUPS: [&str; 2] = ["Heal_Sparks", "Heal_Sparks_Up"];
pub const SOURCE_TROY_SHA256: &str = "340e6cd86abdde6fceac58072ee4cdc9c0d5abeb551b4e1f1f13ed1028980c77";
const SOURCE_TEXT: &str = include_str!("../../../data/4.20/relic_runes/TT_Heal_RuneCapture.json");

#[derive(Debug, Clone)]
pub struct RotationSource {
    pub scalar: ScalarParameter,
    pub axis: [u32; 3],
}

#[derive(Debug, Clone)]
pub struct Profile {
    pub numeric: profiles::Profile,
    pub rotations: Vec<RotationSource>,
}

#[derive(Debug, Clone)]
pub struct Sampled {
    /// Velocity and acceleration here have already received the native e-rotation.
    pub numeric: complex::SampledBirth,
    pub merged_offset: [f32; 3],
    pub velocity: [f32; 3],
}

fn scalar(fields: &Value, key: &str, default: f32) -> Result<ScalarParameter, String> {
    ScalarParameter::read_numeric(key, default, |name| profiles::numeric(fields, name))
        .map_err(|error| format!("invalid Capture scalar {key}: {error:?}"))?
        .ok_or_else(|| format!("missing Capture scalar {key}"))
}

fn value(fields: &Value, key: &str, default: f32) -> Result<f32, String> {
    match profiles::numeric(fields, key) {
        Some(values) if values.len() == 1 && values[0].is_finite() => Ok(values[0]),
        Some(_) => Err(format!("invalid Capture value {key}")),
        None if fields.get(key).is_some() => Err(format!("nonnumeric Capture value {key}")),
        None => Ok(default),
    }
}

fn pair(fields: &Value, key: &str, default: [f32; 2]) -> Result<[f32; 2], String> {
    match profiles::numeric(fields, key) {
        Some(values) if values.len() == 2 && values.iter().all(|v| v.is_finite()) => {
            Ok([values[0], values[1]])
        }
        Some(_) => Err(format!("invalid Capture pair {key}")),
        None if fields.get(key).is_some() => Err(format!("nonnumeric Capture pair {key}")),
        None => Ok(default),
    }
}

fn finite_numbers(value: &Value) -> bool {
    match value {
        Value::Number(n) => n.as_f64().is_some_and(|v| (v as f32).is_finite()),
        Value::Array(a) => a.iter().all(finite_numbers),
        Value::Object(o) => o.values().all(finite_numbers),
        _ => true,
    }
}

fn from_fields(index: usize, fields: &Value) -> Result<Profile, String> {
    let group = *GROUPS.get(index).ok_or("Capture group index")?;
    let object = fields.as_object().ok_or("Capture section is not an object")?;
    if !finite_numbers(fields) {
        return Err("nonfinite Capture source number".into());
    }
    for name in object.keys() {
        let key = name.to_ascii_lowercase();
        if key.contains("_flex") || key.starts_with("field-") || key.starts_with("e-shape") {
            return Err(format!("Capture optional producer not admitted: {name}"));
        }
    }
    for key in ["p-vecalign", "p-xquadrot-on", "p-local-orient", "p-life-scale"] {
        if value(fields, key, 0.)? != 0. {
            return Err(format!("Capture optional producer not admitted: {key}"));
        }
    }
    if value(fields, "p-type", -1.)? != 0.
        || value(fields, "rendermode", -1.)? != 0.
        || value(fields, "flag-disable-z", -1.)? != 1.
        || value(fields, "uniformscale", -1.)? != 1.
        || value(fields, "single-particle", -1.)? != 1.
        || value(fields, "e-local-orient", -1.)? != 0.
        || value(fields, "p-bindtoemitter", -1.)? != 1.
    {
        return Err("unsupported Capture type/flags/orientation/binding source".into());
    }
    if pair(fields, "p-texdiv", [1.; 2])? != [1.; 2]
        || value(fields, "p-startframe", 0.)? != 0.
        || value(fields, "p-numframes", 1.)? != 1.
        || value(fields, "p-framerate", 0.)? != 0.
    {
        return Err("Capture atlas source outside type0 1x1 scope".into());
    }
    let life = scalar(fields, "p-life", 3.)?;
    let timing = Timing::from_group(fields, None).map_err(|e| format!("Capture timing: {e:?}"))?;
    let linger = Linger::from_group(fields, &timing, life.maximum)
        .map_err(|e| format!("Capture linger: {e:?}"))?;
    let modes = pair(fields, "p-colortype", [1., 0.])?;
    if modes.iter().any(|v| *v < 0. || v.fract() != 0.) {
        return Err("invalid Capture color lookup mode".into());
    }
    let numeric = profiles::Profile {
        index, group, fields: fields.clone(),
        vectors: vectors::ComplexVectors::from_group(fields)
            .map_err(|e| format!("Capture birth vectors: {e:?}"))?,
        birth_color: color::ComplexColor::from_group(fields)
            .map_err(|e| format!("Capture birth RGBA: {e:?}"))?,
        lifetime_color: color::ComplexColor::from_lifetime_group(fields)
            .map_err(|e| format!("Capture lifetime RGBA: {e:?}"))?,
        lifetime_scale: vectors::FieldConfig::from_lifetime_scale_group(fields)
            .map_err(|e| format!("Capture lifetime scale: {e:?}"))?,
        rate: scalar(fields, "e-rate", 0.)?,
        bind: scalar(fields, "p-bindtoemitter", 0.)?,
        uv: UvParameters::from_group(fields).map_err(|e| format!("Capture UV: {e:?}"))?,
        start_frame: 0, num_frames: 1, frame_rate: 0., local_emitter_orientation: false,
        lookup: profiles::Lookup {
            modes: modes.map(|v| v as u32),
            scale: pair(fields, "p-colorscale", [1.; 2])?,
            offset: pair(fields, "p-coloroffset", [0.; 2])?,
        }, life, timing, linger,
    };
    let rotation_scalar = scalar(fields, "e-rotation1", 0.)?;
    let axis = profiles::numeric(fields, "e-rotation1-axis").ok_or("Capture rotation axis absent")?;
    if axis != [0., 1., 0.] || rotation_scalar.table.len() != 1 {
        return Err("Capture rotation source outside one retained Y-axis element".into());
    }
    // The selected raw file has no additional e-rotation elements. Reject their
    // activation rather than silently inserting another constructor/RNG path.
    for slot in 2..=8 {
        if value(fields, &format!("e-rotation{slot}"), 0.)? != 0. {
            return Err("additional Capture rotation element is not admitted".into());
        }
    }
    Ok(Profile { numeric, rotations: vec![RotationSource {
        scalar: rotation_scalar, axis: [0f32.to_bits(), 1f32.to_bits(), 0f32.to_bits()],
    }] })
}

pub fn profiles() -> Result<[Profile; 2], String> {
    let document: Value = serde_json::from_str(SOURCE_TEXT).map_err(|e| format!("Capture source JSON: {e}"))?;
    from_document(&document)
}

/// Raw decoded fields are the data source; this does not load recorded outputs
/// or call the Odin Profile::load/from_document implementation.
pub fn from_document(document: &Value) -> Result<[Profile; 2], String> {
    if document["source"]["sha256"].as_str() != Some(SOURCE_TROY_SHA256) {
        return Err("Capture source identity mismatch".into());
    }
    let groups = document["groups"].as_array().ok_or("Capture groups absent")?;
    if groups.len() != 2 || groups.iter().zip(GROUPS).any(|(g, name)| g["name"] != name) {
        return Err("Capture requires exactly the two authored groups in order".into());
    }
    let sections = document["sections"].as_object().ok_or("Capture sections absent")?;
    if sections.len() != 3 || !sections.contains_key("System") {
        return Err("unexpected Capture section cardinality".into());
    }
    for (group, name) in groups.iter().zip(GROUPS) {
        if group["fields"] != sections[name] {
            return Err("Capture group/section fields disagree".into());
        }
    }
    Ok([from_fields(0, &sections[GROUPS[0]])?, from_fields(1, &sections[GROUPS[1]])?])
}

/// Selected primary913015/913037 axis producer, using the already-qualified
/// RSQRT/refinement/reciprocal primitive. Only the authored unit-Y input is
/// admitted: its squared length is exactly1 in both source summation orders.
/// Other rows are zero; this carrier has no RNG or source/provider side effects.
fn selected_primary_axis(axis: [u32; 3]) -> Result<[u32; 3], String> {
    if axis != [0, 0x3f800000, 0] {
        return Err("Capture axis outside selected qualified unit-Y input".into());
    }
    let mut carrier = [0.; 16];
    for (at, value) in [0, 4, 8].into_iter().zip(axis) {
        carrier[at] = f32::from_bits(value);
    }
    let normalized = openleague_core::native_actor_effect_owner::orientation(carrier)
        .map_err(str::to_owned)?;
    let result = [normalized[0], normalized[4], normalized[8]].map(f32::to_bits);
    if result != [0, 0x3f800001, 0] {
        return Err("Capture unit-Y axis differs from selected CPU RSQRT witness".into());
    }
    Ok(result)
}

impl Profile {
    /// Primary source construction samples a temporary angle solely for exact
    /// zero retention (912E5F..9130DE). The retained scalar/probability object is
    /// sampled again for every birth; do not reuse this temporary random angle.
    pub fn retained(&self, rng: &mut Rng55) -> Result<Vec<RotationSource>, String> {
        let mut next = rng.clone();
        let mut retained = Vec::new();
        for source in &self.rotations {
            let base = *source.scalar.table.first().ok_or("empty Capture rotation table")?;
            let temporary = apply_probability(Some(&source.scalar.probability), base, &mut next);
            if !temporary.is_finite() {
                return Err("nonfinite Capture retention angle".into());
            }
            if temporary != 0. {
                retained.push(RotationSource { scalar: source.scalar.clone(),
                    axis: selected_primary_axis(source.axis)? });
            }
        }
        *rng = next;
        Ok(retained)
    }
}

pub fn sample_birth(
    profile: &Profile, retained: &[RotationSource], input: complex::BirthInputs, rng: &mut Rng55,
) -> Result<Sampled, String> {
    if input.life_coefficients != [0.; 3] || retained.len() > 1
        || ![input.time, input.previous, input.owner_start, input.instance_duration, input.life_owner_scale]
            .iter().chain(&input.previous_position).chain(&input.current_position).all(|v| v.is_finite())
    {
        return Err("Capture birth input outside finite no-flex source scope".into());
    }
    let schedule = birth::scheduled_birth(input.time, input.previous, input.count, input.index,
        input.previous_position, input.current_position).ok_or("invalid Capture birth schedule")?;
    let age_input = profile.numeric.timing.emitter_age_input(
        input.time, input.owner_start, input.instance_duration,
    );
    // 93488C computes batch emitter age from the call time before distributing
    // birth timestamps. It is distinct from each scheduled particle time.
    let age = age_input.evaluate();
    let mut next = rng.clone();
    // 9355C2..9356A6 comes before RGBA949550 and vector variations9492F0.
    let sampled_life = profile.numeric.life.sample_age(age.normalized, &mut next)
        .map_err(|e| format!("Capture birth life: {e:?}"))?;
    let (rgba, _) = profile.numeric.birth_color.create_birth_color_at_emitter_age(age_input, &mut next)
        .map_err(|e| format!("Capture birth RGBA: {e:?}"))?;
    let mut sampled_vectors = [[0.; 3]; 10];
    for field in complex::BIRTH_ORDER {
        let parameter = profile.numeric.vectors.field(field);
        let multiplier = parameter.create_multiplier([1.; 3], &mut next);
        sampled_vectors[field as usize] = parameter.sample_age(age.normalized, multiplier)
            .map_err(|e| format!("Capture birth {}: {e:?}", field.key()))?;
    }
    // 935D2E finalizes ordinary lifetime before shape/shared/rotation. The
    // admitted file has neither owner-attribute nor velocity-life supplements.
    let life = birth::finalized_life(birth::LifeInputs {
        sampled_life, owner_scale: input.life_owner_scale, scale_enabled: false,
        velocity: sampled_vectors[Field::Velocity as usize],
        coefficients: [0.; 3], symmetry_flags: input.life_symmetry,
    });
    let shared_uv = next.fraction(); // 9360D8, even with an empty retained list.
    let elements = retained.iter().map(|source| {
        let at = baked_scalar_index(source.scalar.table.len(), age.normalized)
            .map_err(|e| format!("Capture rotation table: {e:?}"))?;
        Ok(rotation::Element { angle: source.scalar.table[at].to_bits(), axis: source.axis,
            probability: Some(&source.scalar.probability) })
    }).collect::<Result<Vec<_>, String>>()?;
    let evaluated = rotation::evaluate(&elements, &mut next).map_err(str::to_owned)?;
    // 936472..936778: projective p-offset, linear p-vel and p-accel.
    // p-postoffset is added afterwards; drag/scale/quad rotation are not rotated.
    let (offset, velocity) = evaluated.apply(
        sampled_vectors[Field::Offset as usize].map(f32::to_bits),
        sampled_vectors[Field::Velocity as usize].map(f32::to_bits),
    ).map_err(str::to_owned)?;
    let (_, acceleration) = evaluated.apply([0.; 3].map(f32::to_bits),
        sampled_vectors[Field::Acceleration as usize].map(f32::to_bits)).map_err(str::to_owned)?;
    sampled_vectors[Field::Offset as usize] = offset.map(f32::from_bits);
    sampled_vectors[Field::Velocity as usize] = velocity.map(f32::from_bits);
    sampled_vectors[Field::Acceleration as usize] = acceleration.map(f32::from_bits);
    let merged_offset = std::array::from_fn(|axis| {
        sampled_vectors[Field::Offset as usize][axis] + sampled_vectors[Field::PostOffset as usize][axis]
    });
    let uv = profile.numeric.uv.sample_birth(age.normalized, shared_uv)
        .map_err(|e| format!("Capture birth UV: {e:?}"))?;
    if !rgba.iter().chain(sampled_vectors.iter().flatten()).chain(&merged_offset)
        .chain([life, shared_uv, age.normalized].iter()).all(|v| v.is_finite())
    {
        return Err("nonfinite Capture sampled output".into());
    }
    let result = Sampled {
        velocity: sampled_vectors[Field::Velocity as usize], merged_offset,
        numeric: complex::SampledBirth { schedule, emitter_age: age.normalized, color: rgba,
            vectors: sampled_vectors, life, uv, shared_uv },
    };
    *rng = next;
    Ok(result)
}

#[cfg(test)]
mod tests {
    use super::*;
    fn input() -> complex::BirthInputs {
        complex::BirthInputs { time: 0., previous: f32::MIN, count: 35, index: 0,
            previous_position: [0.; 3], current_position: [0.; 3], owner_start: 0.,
            instance_duration: 0.6, life_owner_scale: 1., life_coefficients: [0.; 3], life_symmetry: 0 }
    }
    fn state(rng: &Rng55) -> (u32, u32, [u32; 55]) { (rng.first, rng.second, rng.words) }
    #[test]
    fn exact_capture_groups_and_cardinality_reject_foreign_sources() {
        let p = profiles().unwrap();
        assert_eq!([p[0].numeric.group, p[1].numeric.group], GROUPS);
        assert_eq!([p[0].numeric.num_frames, p[1].numeric.num_frames], [1, 1]);
        let mut source: Value = serde_json::from_str(SOURCE_TEXT).unwrap();
        source["groups"].as_array_mut().unwrap().pop();
        assert!(from_document(&source).is_err());
        let mut source: Value = serde_json::from_str(SOURCE_TEXT).unwrap();
        source["source"]["sha256"] = Value::String("foreign".into());
        assert!(from_document(&source).is_err());
    }
    #[test]
    fn optional_shape_or_flex_is_rejected_before_sampling() {
        for key in ["p-life_flex0", "field-noise-1", "e-shape-name"] {
            let mut source: Value = serde_json::from_str(SOURCE_TEXT).unwrap();
            source["sections"][GROUPS[0]][key] = serde_json::json!(2.);
            source["groups"][0]["fields"][key] = serde_json::json!(2.);
            assert!(from_document(&source).is_err(), "{key}");
        }
    }
    #[test]
    fn life_uses_first_birth_draw_and_zero_list_keeps_shared_draw() {
        let [profile, _] = profiles().unwrap();
        let mut expected = Rng55::seeded(12345);
        let first = expected.fraction();
        let p = &profile.numeric.life.probability;
        let expected_life = (p.difference * first + p.begin) * profile.numeric.life.table[0];
        // Capture's first group has one variable scale-X and one variable
        // velocity-X curve. Their intervening draws precede the shared one.
        let _scale_x = expected.fraction();
        let _velocity_x = expected.fraction();
        let expected_shared = expected.fraction();
        let mut actual = Rng55::seeded(12345);
        let sampled = sample_birth(&profile, &[], input(), &mut actual).unwrap();
        assert_eq!(sampled.numeric.life.to_bits(), expected_life.to_bits());
        assert_eq!(sampled.numeric.shared_uv.to_bits(), expected_shared.to_bits());
        assert_eq!(state(&actual), state(&expected));
    }
    #[test]
    fn retained_rotation_radializes_velocity_and_preserves_drag() {
        let [profile, _] = profiles().unwrap();
        let mut rng = Rng55::seeded(42);
        let retained = profile.retained(&mut rng).unwrap();
        assert_eq!(retained.len(), 1);
        let sampled = sample_birth(&profile, &retained, input(), &mut rng).unwrap();
        assert_eq!(sampled.velocity, sampled.numeric.vectors[Field::Velocity as usize]);
        assert!(sampled.velocity[2].abs() > 0.01);
        assert_eq!(sampled.numeric.vectors[Field::Drag as usize], [3., 2., 3.]);
        assert_eq!(sampled.merged_offset, [0.; 3]);
        let mut second_rng = Rng55::seeded(43);
        let second_retained = profile.retained(&mut second_rng).unwrap();
        let second = sample_birth(&profile, &second_retained, input(), &mut second_rng).unwrap();
        assert_ne!(sampled.velocity.map(f32::to_bits), second.velocity.map(f32::to_bits));
    }
    #[test]
    fn retained_axis_matches_selected_native_bits_without_an_extra_rng_draw() {
        let [mut profile, _] = profiles().unwrap();
        assert_eq!(profile.rotations[0].axis, [0, 0x3f800000, 0]);
        let mut expected = Rng55::seeded(42);
        let source = &profile.rotations[0];
        let temporary = apply_probability(Some(&source.scalar.probability),
            source.scalar.table[0], &mut expected);
        assert_ne!(temporary, 0.);
        let mut actual = Rng55::seeded(42);
        let retained = profile.retained(&mut actual).unwrap();
        assert_eq!(retained[0].axis, [0, 0x3f800001, 0]);
        assert_eq!(state(&actual), state(&expected));
        profile.rotations[0].axis = [0x3f800000, 0, 0];
        let mut rejected = Rng55::seeded(42);
        let before = state(&rejected);
        assert!(profile.retained(&mut rejected).is_err());
        assert_eq!(state(&rejected), before);
    }
    #[test]
    fn invalid_birth_preserves_full_rng_state() {
        let [profile, _] = profiles().unwrap();
        let mut rng = Rng55::seeded(42);
        let before = state(&rng);
        let mut invalid = input(); invalid.count = 0;
        assert!(sample_birth(&profile, &[], invalid, &mut rng).is_err());
        assert_eq!(state(&rng), before);
    }
}
