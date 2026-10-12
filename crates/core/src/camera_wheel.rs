//! Original 7D01C0 wheel-to-zoom target transition and cached Replay setting.
#[derive(Debug, Clone, Copy, Default)]
pub struct Settings { pub initialized_flags: u32, pub enabled_raw: u8 }
impl Settings {
    /// Config getter result is supplied only on first invocation; original default is zero.
    pub fn apply(&mut self, target: &mut f32, delta: i32, config_result: i32) {
        if self.initialized_flags & 1 == 0 {
            self.initialized_flags |= 1;
            self.enabled_raw = u8::from(config_result != 0);
        }
        let mut candidate = *target - delta as f32;
        if self.enabled_raw != 0 {
            if delta > 0 { candidate = 1000.; }
            else if delta < 0 { candidate = 2250.; }
        }
        // Native ordered COMISS branches pass through unordered values.
        let candidate = if candidate > 2250. { 2250. }
            else if 1000. > candidate { 1000. } else { candidate };
        // Native UCOMISS/LAHF parity sequence skips equal values, writes unordered values.
        if candidate != *target { *target = candidate; }
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn matches_2592_original_handlers_and_cached_configuration_calls() {
        let proof: serde_json::Value = serde_json::from_str(include_str!("../../../data/4.20/camera_wheel_contract.json")).unwrap();
        let cases = proof["cases"].as_array().unwrap(); assert_eq!(cases.len(),2592);
        for (i,c) in cases.iter().enumerate() {
            let u = |key: &str| c[key].as_u64().unwrap() as u32;
            let mut target = f32::from_bits(u("target_bits"));
            let mut settings = Settings { initialized_flags: u("flags"), enabled_raw: u("cached_raw") as u8 };
            settings.apply(&mut target,c["delta"].as_i64().unwrap() as i32,c["config_override"].as_i64().unwrap() as i32);
            let expected=f32::from_bits(u("output_target_bits"));
            if expected.is_nan() { assert!(target.is_nan(),"case{i}"); }
            else { assert_eq!(target.to_bits(),expected.to_bits(),"case{i}"); }
            assert_eq!(settings.initialized_flags,u("output_flags"),"case{i}");
            assert_eq!(settings.enabled_raw,u("output_cached_raw") as u8,"case{i}");
        }
    }
}
