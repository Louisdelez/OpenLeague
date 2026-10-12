//! Verified GarenQAttack data binding, consumed by attack presentation.
//! Authored flags/frames are NOT an authoritative timing or Move/Stop policy.
//! The Rust registry needs no RADS object, native pointers, or source files at runtime.
use crate::attack_presentation::Kind;
use serde::Serialize;
use serde_json::Value;
use std::sync::OnceLock;

const CONTRACT: &str = include_str!("../../../data/4.20/garen_q_resource_contract.json");
pub const TIMING_POLICY: &str = "existing_basic_policy_unqualified_for_q";
pub const ORDER_POLICY: &str = "existing_move_stop_policy_unqualified_for_q";

#[derive(Debug, Serialize)]
pub struct AuthoredFields {
    pub cast_frame_text: String,
    pub use_animator_framerate: bool,
    pub cant_cancel_while_winding_up: bool,
    pub delay_cast_offset_percent: f32,
    pub delay_total_time_percent: f32,
}

#[derive(Debug)]
pub struct Binding {
    kind: Kind,
    resource_name: String,
    native_key: u32,
    animation_name: String,
    presentation_role: String,
    authored: AuthoredFields,
}

impl Binding {
    pub fn resource_name(&self) -> &str { &self.resource_name }
    pub fn native_key(&self) -> u32 { self.native_key }
    pub fn animation_name(&self) -> &str { &self.animation_name }
    pub fn presentation_role(&self) -> &str { &self.presentation_role }
    pub fn authored(&self) -> &AuthoredFields { &self.authored }

    /// Caller supplies the Garen empowerment observed at THIS fact's tick.
    /// Begin and impact remain independent; this does not freeze damage at start.
    pub fn kind_at_observation(&self, empowered: bool, critical: bool) -> Kind {
        if empowered { self.kind }
        else if critical { Kind::Critical }
        else { Kind::Basic }
    }

    pub fn diagnostic(&self) -> Value {
        serde_json::json!({"resource_name":self.resource_name,"native_key":format!("{:08X}",self.native_key),
            "native_animation":self.animation_name,"presentation_role":self.presentation_role,
            "authored_fields":self.authored,"timing_policy":TIMING_POLICY,"order_policy":ORDER_POLICY,
            "native_provider_loaded":false})
    }
}

/// Immutable embedded data. Errors are retained, never replaced by another spell.
pub fn binding() -> Result<&'static Binding, &'static str> {
    static BINDING: OnceLock<Result<Binding, String>> = OnceLock::new();
    BINDING.get_or_init(|| parse(CONTRACT)).as_ref().map_err(String::as_str)
}

fn require(condition: bool, message: &str) -> Result<(), String> {
    if condition { Ok(()) } else { Err(format!("GarenQAttack contract: {message}")) }
}

fn parse(text: &str) -> Result<Binding, String> {
    let v: Value = serde_json::from_str(text).map_err(|e| format!("GarenQAttack contract JSON: {e}"))?;
    require(v["schema"] == 1 && v["champion"] == "garen" && v["role"] == "empowered_attack", "schema/champion/role")?;
    require(v["lookup_source"] == "Data/ExtraSpell1" && v["resource_name"] == "GarenQAttack", "resource identity")?;
    require(v["native_key"] == "01532BCB", "native identity hash")?;
    require(v["character_source"]["bytes"] == 1065 && v["character_source"]["sha256"] == "17268558d84561f9b59e89a312dfdf2888971c9202a7abc0a7a6f1c97b0105d5", "character provenance")?;
    require(v["spell_source"]["bytes"] == 1708 && v["spell_source"]["sha256"] == "feeea7484dee0f67717bf5fcbb707d1fa4401267457fbc5c9318acdacb964b32", "spell provenance")?;
    require(v["oracle"]["sha256"] == "c98f9ffdcd728409645556bc7bf5b6cec2e24a35b1fb6ac45d194ba3ea42e427" &&
        v["oracle_manifest"]["sha256"] == "4fcbe19368f760802a999f3e408a583867e5b6273db3f22557d5a6a6976e3498", "oracle provenance")?;
    require(v["native_constructor_complete"] == false && v["provider_required_for_Rust_registry"] == false, "qualification boundary")?;
    let fields = &v["fields"];
    require(fields.as_object().is_some_and(|o| o.len() == 6), "authored field set")?;
    for (name, key, getter, expected) in [
        ("AnimationName", "681C7297", "008B01C0", Value::from("Spell1")),
        ("CastFrame", "C465DD76", "008B01C0", Value::from("21.000")),
        ("UseAnimatorFramerate", "897EF7F7", "008AFC30", Value::from(1)),
        ("CantCancelWhileWindingUp", "B95C8C5A", "008AFC30", Value::from(1)),
    ] {
        let field = &fields[name];
        require(field["key_hash"] == key && field["getter"] == getter && field["value"] == expected && field["float_bits"].is_null(), name)?;
    }
    for (name, key) in [("DelayCastOffsetPercent", "B0C69808"), ("DelayTotalTimePercent", "BB71873F")] {
        let field = &fields[name];
        require(field["key_hash"] == key && field["getter"] == "008AFB10" && field["float_bits"] == "BE6147AE" &&
            field["value"].as_f64().is_some_and(|f| (f as f32).to_bits() == 0xBE61_47AE), name)?;
    }
    require(v["presentation_binding"]["native_animation"] == fields["AnimationName"]["value"] &&
        v["presentation_binding"]["existing_catalog_role"] == "spell1", "audited animation alias")?;
    require(v["mechanics_policy"]["timing"] == "preserve_existing_basic_attack_profile_pending_authoritative_Q_timing" &&
        v["mechanics_policy"]["cancel_move_stop"] == "preserve_existing_policy_pending_native_actor_phase_command_context" &&
        v["mechanics_policy"]["impact_kind"] == "re-evaluate current empowered state at impact, as existing engine does" &&
        v["mechanics_policy"]["flags_are_observed_data_not_command_policy"] == true, "mechanics policy boundary")?;
    // Every conversion below follows the corresponding exact typed validation.
    Ok(Binding {
        kind: Kind::GarenQ, // This type follows the exact name/key checks above.
        resource_name: v["resource_name"].as_str().unwrap().into(),
        native_key: u32::from_str_radix(v["native_key"].as_str().unwrap(), 16).unwrap(),
        animation_name: fields["AnimationName"]["value"].as_str().unwrap().into(),
        presentation_role: v["presentation_binding"]["existing_catalog_role"].as_str().unwrap().into(),
        authored: AuthoredFields {
            cast_frame_text: fields["CastFrame"]["value"].as_str().unwrap().into(),
            use_animator_framerate: fields["UseAnimatorFramerate"]["value"] == 1,
            cant_cancel_while_winding_up: fields["CantCancelWhileWindingUp"]["value"] == 1,
            delay_cast_offset_percent: fields["DelayCastOffsetPercent"]["value"].as_f64().unwrap() as f32,
            delay_total_time_percent: fields["DelayTotalTimePercent"]["value"].as_f64().unwrap() as f32,
        },
    })
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn q_registry_preserves_native_identity_types_bits_and_policy_boundary() {
        let b = binding().unwrap();
        assert_eq!(b.resource_name(), "GarenQAttack"); assert_eq!(b.native_key(), 0x0153_2BCB);
        assert_eq!((b.animation_name(), b.presentation_role()), ("Spell1", "spell1"));
        assert_eq!(b.authored().cast_frame_text, "21.000");
        assert!(b.authored().use_animator_framerate && b.authored().cant_cancel_while_winding_up);
        assert_eq!(b.authored().delay_cast_offset_percent.to_bits(), 0xBE61_47AE);
        assert_eq!(b.authored().delay_total_time_percent.to_bits(), 0xBE61_47AE);
        assert_eq!(b.diagnostic()["timing_policy"], TIMING_POLICY);
        assert_eq!(b.diagnostic()["order_policy"], ORDER_POLICY);
        assert!(std::ptr::eq(b, binding().unwrap()));
    }
    #[test]
    fn q_registry_rejects_changed_identity_authored_values_provenance_and_policy() {
        for (pointer, changed) in [
            ("/resource_name", Value::from("GarenQ")), ("/native_key", Value::from("00000000")),
            ("/fields/CastFrame/value", Value::from(21)), ("/fields/UseAnimatorFramerate/value", Value::from(true)),
            ("/fields/CantCancelWhileWindingUp/value", Value::from(0)),
            ("/fields/DelayCastOffsetPercent/value", Value::from(-0.2)),
            ("/fields/DelayTotalTimePercent/float_bits", Value::from("00000000")),
            ("/presentation_binding/existing_catalog_role", Value::from("attack")),
            ("/character_source/sha256", Value::from("changed")), ("/spell_source/bytes", Value::from(1707)),
            ("/oracle/sha256", Value::from("changed")), ("/native_constructor_complete", Value::from(true)),
            ("/mechanics_policy/flags_are_observed_data_not_command_policy", Value::from(false)),
        ] {
            let mut v: Value = serde_json::from_str(CONTRACT).unwrap();
            *v.pointer_mut(pointer).unwrap() = changed;
            assert!(parse(&v.to_string()).is_err(), "accepted mutation {pointer}");
        }
        assert!(parse("{}").is_err()); assert!(parse("invalid").is_err());
    }
    #[test]
    fn q_registry_selects_effective_kind_without_a_persistent_start_kind() {
        let b = binding().unwrap();
        assert_eq!(b.kind_at_observation(false, false), Kind::Basic);
        assert_eq!(b.kind_at_observation(false, true), Kind::Critical);
        assert_eq!(b.kind_at_observation(true, false), Kind::GarenQ);
        assert_eq!(b.kind_at_observation(true, true), Kind::GarenQ);
        assert_eq!(b.kind_at_observation(false, false), Kind::Basic);
    }
}
