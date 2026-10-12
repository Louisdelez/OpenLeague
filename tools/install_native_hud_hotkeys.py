from pathlib import Path
import shutil,datetime
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3');history=r/'docs/plan_history'/('hud-hotkeys-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
for name in ['main.rs','spell_input.rs','native_hud_widgets.rs']:shutil.copy2(r/'crates/client/src'/name,history/name)
p=r/'crates/client/src/spell_input.rs';s=p.read_text(encoding='utf-8');assert 'pub const KEYS' not in s
s+='''
// Shared physical keys match recovered4.20 default bindings; runtime rebinding remains open.
pub const KEYS:[bevy::prelude::KeyCode;4]=[bevy::prelude::KeyCode::KeyQ,bevy::prelude::KeyCode::KeyW,bevy::prelude::KeyCode::KeyE,bevy::prelude::KeyCode::KeyR];
pub fn pressed_slot(keys:&bevy::prelude::ButtonInput<bevy::prelude::KeyCode>)->Option<u8> {KEYS.iter().position(|key|keys.just_pressed(*key)).map(|n|n as u8)}
pub fn short_label(binding:&str)->Result<String,String> {if !binding.is_ascii() {return Err("native short-label byte encoding not yet qualified".into());}let first=binding.find(',');Ok(if first.map_or(binding.len()==3,|i|i==3) {binding.get(1..2).ok_or("native short label outside source buffer")?.to_string()}else {" ".into()})}
pub fn hud_labels()->[String;4] {static SOURCE:std::sync::OnceLock<serde_json::Value>=std::sync::OnceLock::new();let s=SOURCE.get_or_init(||serde_json::from_str(include_str!("../../../data/4.20/native_hud_hotkeys_contract.json")).unwrap());std::array::from_fn(|slot|short_label(s["bindings"][slot]["cast"].as_str().unwrap()).unwrap())}
#[cfg(test)] mod hotkey_tests {
 use super::*;
 #[test] fn original_short_label_cases_and_source_defaults_match() {let c:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_hotkeys_contract.json")).unwrap();assert_eq!(c["case_count"],11);for a in c["cases"].as_array().unwrap() {assert_eq!(short_label(a["input"].as_str().unwrap()).unwrap(),a["output"].as_str().unwrap());}assert_eq!(hud_labels(),["q","w","e","r"].map(str::to_string));for (i,key) in KEYS.iter().enumerate() {let name=format!("{key:?}");assert_eq!(name.trim_start_matches("Key").to_ascii_lowercase(),hud_labels()[i]);assert_eq!(c["bindings"][i]["learn"].as_str().unwrap(),format!("[Ctrl][{}]",hud_labels()[i]));}assert!(short_label("[é]").is_err());}
 #[test] fn shared_actual_key_press_dispatch_matches_native_hud_slots() {use bevy::prelude::*;for (i,key) in KEYS.iter().enumerate() {let mut input=ButtonInput::default();input.press(*key);assert_eq!(pressed_slot(&input),Some(i as u8));input.clear();assert_eq!(pressed_slot(&input),None);input.release(*key);assert_eq!(pressed_slot(&input),None);}let mut input=ButtonInput::default();input.press(KeyCode::KeyA);assert_eq!(pressed_slot(&input),None);input.press(KeyCode::KeyR);input.press(KeyCode::KeyQ);assert_eq!(pressed_slot(&input),Some(0));}
}
''';p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8');old='''let skill = [KeyCode::KeyQ, KeyCode::KeyW, KeyCode::KeyE, KeyCode::KeyR]
        .iter()
        .position(|key| keys.just_pressed(*key))
        .map(|n| n as u8);''';assert old in s;s=s.replace(old,'let skill = spell_input::pressed_slot(&keys);');p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/native_hud_widgets.rs';s=p.read_text(encoding='utf-8');s=s.replace('Nine original map10 Text widgets','Thirteen original map10 Text widgets').replace('Nine source Text widgets','Thirteen source Text widgets').replace('widgets.len()!=9','widgets.len()!=13').replace('original nine numeric HUD Text definitions','original thirteen HUD Text definitions').replace('assert_eq!(widgets.len(),9)','assert_eq!(widgets.len(),13)')
needle='if (layout.request.ends_with("ShadowIslesChampionLeft.ini")';assert needle in s;s=s.replace(needle,'if (name.starts_with(b"SpellHotKey") && (0..4).any(|slot|layout.request.ends_with(&format!("CenterHUD_AbilitiesSpell{slot}.ini")) && name==format!("SpellHotKey{slot}").as_bytes())) || (layout.request.ends_with("ShadowIslesChampionLeft.ini")',1)
needle='    Ok(Some(values))';assert needle in s;s=s.replace(needle,'    for (slot,label) in crate::spell_input::hud_labels().into_iter().enumerate() {values.insert(format!("SpellHotKey{slot}"),label);}\n'+needle,1)
p.write_text(s,encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print('Four original hotkey Text sources installed; input and HUD share actual QWER keys')
