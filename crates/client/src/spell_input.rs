pub fn ground_target(champion:&str,slot:u8)->bool {(champion=="annie"&&(slot==1||slot==3))||(champion=="trundle"&&(slot==1||slot==2))||(champion=="ezreal"&&(slot==0||slot==1||slot==2||slot==3))}
#[cfg(test)] mod tests {#[test] fn only_supported_ground_slots_route_to_position_command(){assert!(super::ground_target("annie",1));assert!(super::ground_target("annie",3));assert!(super::ground_target("trundle",1));assert!(super::ground_target("trundle",2));assert!(super::ground_target("ezreal",1));assert!(super::ground_target("ezreal",2));assert!(super::ground_target("ezreal",3));for (c,s) in [("garen",1),("annie",0),("annie",2),("ahri",1),("trundle",0),("trundle",3)] {assert!(!super::ground_target(c,s));}}}

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

// Ordered physical key interpretation. This is local input policy, not a native
// Riot input-loop port. The modifier is sampled at keydown, never frame-end.
use bevy::{prelude::*, input::{ButtonState, InputSystems, keyboard::{KeyboardInput,KeyboardFocusLost}}, window::PrimaryWindow};
use std::collections::HashSet;
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub struct Shortcut { pub slot:u8, pub learn:bool }
#[derive(Resource,Default)]
pub struct Shortcuts { held:HashSet<KeyCode>, pressed:[Option<Shortcut>;4], window:Option<Entity> }
impl Shortcuts {
    pub fn selected(&self)->Option<Shortcut> {self.pressed.iter().flatten().copied().next()}
    fn clear_frame(&mut self) {self.pressed=[None;4];}
    fn reset(&mut self) {self.held.clear();self.clear_frame();}
    fn key(&mut self,key:KeyCode,state:ButtonState,repeat:bool) {
        match state {
            ButtonState::Released=>{self.held.remove(&key);},
            ButtonState::Pressed=>{
                let fresh=self.held.insert(key);
                if fresh && !repeat {
                    if let Some(slot)=KEYS.iter().position(|value|*value==key) {
                        let learn=self.held.contains(&KeyCode::ControlLeft)||self.held.contains(&KeyCode::ControlRight);
                        // Keep existing Q/W/E/R slot precedence and first press
                        // per slot in a frame; a later Ctrl cannot rewrite it.
                        self.pressed[slot].get_or_insert(Shortcut {slot:slot as u8,learn});
                    }
                }
            }
        }
    }
}
pub struct Plugin;
impl bevy::app::Plugin for Plugin {
    fn build(&self,app:&mut App) {
        app.init_resource::<Shortcuts>().add_systems(PreUpdate,collect.after(InputSystems));
    }
}
fn collect(mut input:ResMut<Shortcuts>,mut events:MessageReader<KeyboardInput>,mut lost:MessageReader<KeyboardFocusLost>,windows:Query<(Entity,&Window),With<PrimaryWindow>>) {
    input.clear_frame();
    let focus_lost=lost.read().next().is_some();lost.clear();
    let Ok((entity,window))=windows.single() else {input.reset();input.window=None;events.clear();return;};
    if input.window!=Some(entity) {input.reset();input.window=Some(entity);}
    // The two event queues do not preserve ordering relative to each other;
    // suppress the whole loss-of-focus frame instead of guessing an order.
    if focus_lost || !window.focused {input.reset();events.clear();return;}
    for event in events.read().filter(|event|event.window==entity) {input.key(event.key_code,event.state,event.repeat);}
}
#[cfg(test)] mod ordered_shortcut_tests {
    use super::*;
    fn down(s:&mut Shortcuts,key:KeyCode){s.key(key,ButtonState::Pressed,false)}
    fn up(s:&mut Shortcuts,key:KeyCode){s.key(key,ButtonState::Released,false)}
    #[test] fn complete_control_e_chord_in_one_frame_keeps_keydown_modifier() {
        for ctrl in [KeyCode::ControlLeft,KeyCode::ControlRight] {
            let mut s=Shortcuts::default();down(&mut s,ctrl);down(&mut s,KeyCode::KeyE);up(&mut s,KeyCode::KeyE);up(&mut s,ctrl);
            assert_eq!(s.selected(),Some(Shortcut{slot:2,learn:true}));assert!(s.held.is_empty());
        }
        let mut old=ButtonInput::default();old.press(KeyCode::ControlLeft);old.press(KeyCode::KeyE);old.release(KeyCode::KeyE);old.release(KeyCode::ControlLeft);
        assert_eq!(pressed_slot(&old),Some(2));assert!(!old.pressed(KeyCode::ControlLeft));
    }
    #[test] fn later_control_or_already_released_control_cannot_convert_cast_to_learn() {
        let mut s=Shortcuts::default();down(&mut s,KeyCode::KeyE);down(&mut s,KeyCode::ControlLeft);assert_eq!(s.selected().unwrap().learn,false);
        let mut s=Shortcuts::default();down(&mut s,KeyCode::ControlLeft);up(&mut s,KeyCode::ControlLeft);down(&mut s,KeyCode::KeyE);assert_eq!(s.selected().unwrap().learn,false);
    }
    #[test] fn held_modifier_across_frames_and_both_controls_are_preserved() {
        let mut s=Shortcuts::default();down(&mut s,KeyCode::ControlLeft);down(&mut s,KeyCode::ControlRight);s.clear_frame();up(&mut s,KeyCode::ControlLeft);down(&mut s,KeyCode::KeyW);
        assert_eq!(s.selected(),Some(Shortcut{slot:1,learn:true}));s.clear_frame();assert_eq!(s.selected(),None);up(&mut s,KeyCode::ControlRight);down(&mut s,KeyCode::KeyQ);assert_eq!(s.selected().unwrap().learn,false);
    }
    #[test] fn repeated_keydown_and_frame_gate_do_not_replay_an_intent() {
        let mut s=Shortcuts::default();down(&mut s,KeyCode::ControlLeft);down(&mut s,KeyCode::KeyE);s.clear_frame(); // gated frame discarded
        s.key(KeyCode::KeyE,ButtonState::Pressed,true);down(&mut s,KeyCode::KeyE);assert_eq!(s.selected(),None);
        up(&mut s,KeyCode::KeyE);down(&mut s,KeyCode::KeyE);assert!(s.selected().unwrap().learn);
    }
    #[test] fn focus_reset_removes_stale_modifier_and_intent() {
        let mut s=Shortcuts::default();down(&mut s,KeyCode::ControlLeft);down(&mut s,KeyCode::KeyE);s.reset();assert_eq!(s.selected(),None);
        down(&mut s,KeyCode::KeyE);assert!(!s.selected().unwrap().learn);
    }
    #[test] fn other_shortcuts_are_not_consumed_and_slot_precedence_is_unchanged() {
        let mut s=Shortcuts::default();for key in [KeyCode::KeyD,KeyCode::KeyF,KeyCode::Digit1,KeyCode::KeyP] {down(&mut s,key);}assert_eq!(s.selected(),None);
        down(&mut s,KeyCode::KeyR);down(&mut s,KeyCode::KeyQ);assert_eq!(s.selected().unwrap().slot,0);
    }
    #[test] fn bevy_collector_keeps_message_order_without_consuming_other_readers() {
        use bevy::input::{InputPlugin,keyboard::Key};
        let mut app=App::new();app.add_plugins((InputPlugin,Plugin));
        let window=app.world_mut().spawn((Window{focused:true,..default()},PrimaryWindow)).id();app.update();
        for (key_code,state) in [(KeyCode::ControlLeft,ButtonState::Pressed),(KeyCode::KeyE,ButtonState::Pressed),(KeyCode::KeyE,ButtonState::Released),(KeyCode::ControlLeft,ButtonState::Released),(KeyCode::KeyD,ButtonState::Pressed)] {
            app.world_mut().write_message(KeyboardInput{key_code,logical_key:Key::Character("test".into()),state,text:None,repeat:false,window});
        }
        app.update();assert_eq!(app.world().resource::<Shortcuts>().selected(),Some(Shortcut{slot:2,learn:true}));
        let buttons=app.world().resource::<ButtonInput<KeyCode>>();assert!(!buttons.pressed(KeyCode::ControlLeft));assert!(buttons.just_pressed(KeyCode::KeyE));assert!(buttons.just_pressed(KeyCode::KeyD));
        app.update();assert_eq!(app.world().resource::<Shortcuts>().selected(),None);
        app.world_mut().write_message(KeyboardFocusLost);app.update();assert!(app.world().resource::<Shortcuts>().held.is_empty());
    }
}
