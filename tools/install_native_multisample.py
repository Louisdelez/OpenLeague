from pathlib import Path
r=Path('E:/OpenLeague');src=r/'crates/client/src'
module='''//! Native General/Antialiasing selection; device/GPU evidence is separate.
pub fn samples(option:i32)->u32 {match option {1=>2,2=>4,_=>0}}
pub fn configured(parsed:&crate::native_game_cfg_text::Parsed)->(i32,u32) {
 use crate::native_graphics_options::{ValueSources,read_integer_value};
 let text=parsed.value(b"General",b"Antialiasing");
 let value=read_integer_value(0,ValueSources {binary_enabled:false,typed_enabled:false,text_enabled:true,typed:None,text},|_|{}).value;
 (value,samples(value))
}
#[cfg(test)] mod tests {
 use super::*;
 #[test] fn selection_matches_original_launch_and_presentation_cases() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_multisample_selection_contract.json")).unwrap();
  assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],112);
  for row in proof["cases"].as_array().unwrap() {
   assert_eq!(samples(row["config"].as_i64().unwrap() as i32),row["d3d_multisample_type"].as_u64().unwrap() as u32);
   assert_eq!(row["d3d_multisample_quality"],0);
  }
 }
 #[test] fn defaults_and_user_overrides_use_original_configuration_parser() {
  let bytes=include_bytes!("../../../data/4.20/configuration/defaults/Game.cfg");
  let parsed=crate::native_game_cfg_text::parse(bytes,0);assert_eq!(configured(&parsed),(0,0));
  for (text,expected) in [(b"[General]\\nAntialiasing=1\\n".as_slice(),(1,2)),(b"[General]\\nAntialiasing=2\\n".as_slice(),(2,4)),(b"[General]\\nAntialiasing=3\\n".as_slice(),(3,0))] {
   let merged=crate::native_game_cfg_text::load_text_files(Some(text),Some(bytes));
   assert!(merged.parsed.error.is_none());assert_eq!(configured(&merged.parsed),expected);
  }
 }
}
'''
(src/'native_multisample.rs').write_text(module,encoding='utf-8')
p=src/'main.rs';text=p.read_text(encoding='utf-8')
assert 'mod native_multisample;' not in text
text=text.replace('mod native_fxaa_pass;','mod native_fxaa_pass;\nmod native_multisample;')
old='fn setup(mut commands: Commands, assets: Res<AssetServer>, focus: Res<CameraFocus>, mut native_camera: ResMut<camera_native::NativeCamera>) {'
assert old in text
text=text.replace(old,old.replace('focus: Res<CameraFocus>,','focus: Res<CameraFocus>, settings: Res<native_user_settings::Loaded>,'))
old='            Msaa::default()';assert text.count(old)==1
text=text.replace(old,'''            let (option,samples)=native_multisample::configured(&settings.text);
            eprintln!("Native General/Antialiasing={} MSAA_samples={} quality=0",option,samples);
            match samples {2=>Msaa::Sample2,4=>Msaa::Sample4,_=>Msaa::Off}''')
p.write_text(text,encoding='utf-8')
print('Native Game.cfg selection installed; runtime qualification pending.')
