from pathlib import Path
r=Path(r'E:/OpenLeague')
(r/'crates/core/src/camera_wheel.rs').write_text('''//! Original 7D01C0 wheel-to-zoom target transition and cached Replay setting.
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
''',encoding='utf-8')
p=r/'crates/core/src/lib.rs';s=p.read_text(encoding='utf-8');assert 'pub mod camera_wheel;' not in s;s+='\npub mod camera_wheel;\n';p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/camera_native.rs';s=p.read_text(encoding='utf-8');s=s.replace('map_far:f32,shake_probe:','map_far:f32,wheel:openleague_core::camera_wheel::Settings,shake_probe:');s=s.replace('map_far:value("cam_FarZ"),shake_probe:','map_far:value("cam_FarZ"),wheel:Default::default(),shake_probe:');s=s.replace('impl NativeCamera {\n','''impl NativeCamera {
 /// Windows winit line units are raw WM_MOUSEWHEEL signed high-word / WHEEL_DELTA120.
 /// UI capture and original event producer remain reconstructed, not qualified.
 pub fn scroll(&mut self,unit:bevy::input::mouse::MouseScrollUnit,lines:f32)->Result<(),&'static str> {
  let delta=windows_wheel_delta(unit,lines)?;
  self.wheel.apply(&mut self.state.zoom.target,delta,0);
  Ok(())
 }
''',1)
s+='''
fn windows_wheel_delta(unit:bevy::input::mouse::MouseScrollUnit,lines:f32)->Result<i32,&'static str> {
 if unit!=bevy::input::mouse::MouseScrollUnit::Line {return Err("pixel wheel units unsupported pending native conversion qualification");}
 if !lines.is_finite() {return Err("nonfinite wheel input");}
 let raw=(f64::from(lines)*120.).round();
 if raw < f64::from(i16::MIN) || raw > f64::from(i16::MAX) {return Err("wheel input exceeds Windows signed high-word range");}
 Ok(raw as i32)
}
#[cfg(test)]
mod wheel_tests {
 use super::*;
 use bevy::input::mouse::MouseScrollUnit;
 #[test]
 fn recovers_all_65536_windows_wheel_values_and_rejects_unqualified_units() {
  for delta in i16::MIN..=i16::MAX {assert_eq!(windows_wheel_delta(MouseScrollUnit::Line,f32::from(delta)/120.).unwrap(),i32::from(delta));}
  assert!(windows_wheel_delta(MouseScrollUnit::Pixel,1.).is_err());
  for lines in [f32::NAN,f32::INFINITY,1000.,-1000.] {assert!(windows_wheel_delta(MouseScrollUnit::Line,lines).is_err());}
 }
 #[test]
 fn wheel_changes_native_target_then_smooths_view_to_both_original_limits() {
  let mut c=NativeCamera::default();let focus=Vec3::new(370.,0.,385.);
  c.scroll(MouseScrollUnit::Line,1.).unwrap();assert_eq!(c.state.zoom.target,2130.);
  let before=c.pose(focus,0.,0.).unwrap().0.translation;
  let after=c.pose(focus,0.016,0.016).unwrap().0.translation;
  assert!(after.distance(focus)<before.distance(focus));
  c.scroll(MouseScrollUnit::Line,20.).unwrap();assert_eq!(c.state.zoom.target,1000.);
  for i in 0..120 {c.pose(focus,0.016,i as f32*0.016).unwrap();}
  assert_eq!(c.state.zoom.current,1000.);
  assert!((c.pose(focus,0.016,2.).unwrap().0.translation.distance(focus)-40.).abs()<0.001);
  c.scroll(MouseScrollUnit::Line,-20.).unwrap();assert_eq!(c.state.zoom.target,2250.);
  for i in 0..120 {c.pose(focus,0.016,2.+i as f32*0.016).unwrap();}
  assert_eq!(c.state.zoom.current,2250.);
  assert!((c.pose(focus,0.016,4.).unwrap().0.translation.distance(focus)-90.).abs()<0.001);
 }
}
''';p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8');old='fn camera(\n    keys: Res<ButtonInput<KeyCode>>,\n';assert old in s;s=s.replace(old,old+'    mut wheel: MessageReader<bevy::input::mouse::MouseWheel>,\n',1);old='    let mut delta = Vec3::ZERO;\n';assert s.count(old)==1;s=s.replace(old,'''    for event in wheel.read() {
        if let Err(error)=native_camera.scroll(event.unit,event.y) {warn!("Camera wheel: {error}");}
    }
'''+old,1);p.write_text(s,encoding='utf-8')
print('Native wheel core and client integration written with explicit UTF8')
