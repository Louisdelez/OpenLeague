use super::*;
use bevy::input::{InputPlugin, keyboard::{Key, KeyboardFocusLost}};

fn event(window:Entity,key_code:KeyCode,state:ButtonState,text:Option<&str>)->KeyboardInput {
    KeyboardInput{window,key_code,state,text:text.map(Into::into),logical_key:Key::Character("fixture".into()),repeat:false}
}
fn down(key:KeyCode,text:Option<&str>)->KeyboardInput {event(Entity::PLACEHOLDER,key,ButtonState::Pressed,text)}
fn up(key:KeyCode)->KeyboardInput {event(Entity::PLACEHOLDER,key,ButtonState::Released,None)}
fn frame(input:&mut Input,query:&mut String,focused:&mut bool,events:&[KeyboardInput],paste:impl FnMut()->Result<String,&'static str>) {
    input.update(query,focused,true,Some((Entity::PLACEHOLDER,true)),Some((7,11)),false,events.iter(),paste);
}
fn active()->(Input,String,bool) {
    let(mut input,mut query,mut focused)=(Input::default(),String::new(),true);
    frame(&mut input,&mut query,&mut focused,&[],||panic!("clipboard must not be read"));
    (input,query,focused)
}
fn paste_keys()->Vec<KeyboardInput> {vec![down(KeyCode::ControlLeft,None),down(KeyCode::KeyV,Some("v")),up(KeyCode::KeyV),up(KeyCode::ControlLeft)]}

#[test]
fn complete_control_v_chord_pastes_once_without_literal_v() {
    let(mut input,mut query,mut focused)=active();let mut reads=0;
    frame(&mut input,&mut query,&mut focused,&paste_keys(),||{reads+=1;Ok("potion".into())});
    assert_eq!(reads,1);assert_eq!(query,"potion");assert!(input.held.is_empty());
    frame(&mut input,&mut query,&mut focused,&[],||panic!("no delayed paste"));assert_eq!(query,"potion");
}
#[test]
fn later_or_released_control_does_not_rewrite_text_as_a_paste() {
    for events in [vec![down(KeyCode::KeyV,Some("v")),down(KeyCode::ControlLeft,None)],
        vec![down(KeyCode::ControlLeft,None),up(KeyCode::ControlLeft),down(KeyCode::KeyV,Some("v"))]] {
        let(mut input,mut query,mut focused)=active();
        frame(&mut input,&mut query,&mut focused,&events,||panic!("not Ctrl+V at keydown"));assert_eq!(query,"v");
    }
}
#[test]
fn held_controls_work_across_frames_but_held_paste_does_not_repeat() {
    let(mut input,mut query,mut focused)=active();let mut reads=0;
    frame(&mut input,&mut query,&mut focused,&[down(KeyCode::ControlLeft,None),down(KeyCode::ControlRight,None)],||panic!());
    frame(&mut input,&mut query,&mut focused,&[up(KeyCode::ControlLeft),down(KeyCode::KeyV,Some("v"))],||{reads+=1;Ok("a".into())});
    let mut repeat=down(KeyCode::KeyV,Some("v"));repeat.repeat=true;
    frame(&mut input,&mut query,&mut focused,&[repeat,down(KeyCode::KeyV,Some("v"))],||panic!("repeat paste"));
    frame(&mut input,&mut query,&mut focused,&[up(KeyCode::KeyV),down(KeyCode::KeyV,Some("v"))],||{reads+=1;Ok("b".into())});
    assert_eq!(reads,2);assert_eq!(query,"ab");
}
#[test]
fn unicode_text_multicharacters_backspace_and_paste_share_scalar_limit() {
    let(mut input,mut query,mut focused)=active();
    frame(&mut input,&mut query,&mut focused,&[down(KeyCode::KeyE,Some("\u{ea}\u{e9}")),up(KeyCode::KeyE)],||panic!());
    frame(&mut input,&mut query,&mut focused,&paste_keys(),||Ok("\r\n\u{1f980}".repeat(80)));
    assert_eq!(query.chars().count(),64);assert!(query.starts_with("\u{ea}\u{e9}"));assert!(!query.chars().any(char::is_control));
    frame(&mut input,&mut query,&mut focused,&[down(KeyCode::Backspace,None)],||panic!());assert_eq!(query.chars().count(),63);
    let mut repeat=down(KeyCode::Backspace,None);repeat.repeat=true;
    frame(&mut input,&mut query,&mut focused,&[repeat],||panic!());assert_eq!(query.chars().count(),62);
}
#[test]
fn unavailable_clipboard_preserves_query_and_surfaces_only_generic_error() {
    let(mut input,mut query,mut focused)=active();query="bottes".into();
    frame(&mut input,&mut query,&mut focused,&paste_keys(),||Err("Presse-papiers indisponible."));
    assert_eq!(query,"bottes");assert_eq!(input.error,Some("Presse-papiers indisponible."));
    frame(&mut input,&mut query,&mut focused,&[down(KeyCode::KeyS,Some("s"))],||panic!());
    assert_eq!(query,"bottess");assert_eq!(input.error,None);
}
#[test]
fn inactive_closed_and_activation_frames_never_read_clipboard_or_replay_text() {
    let(mut input,mut query,mut focused)=active();focused=false;
    frame(&mut input,&mut query,&mut focused,&paste_keys(),||panic!());assert!(query.is_empty());
    focused=true;frame(&mut input,&mut query,&mut focused,&paste_keys(),||panic!("activation frame"));assert!(query.is_empty());
    frame(&mut input,&mut query,&mut focused,&[],||panic!());assert!(query.is_empty());
    input.update(&mut query,&mut focused,false,Some((Entity::PLACEHOLDER,true)),Some((7,11)),false,paste_keys().iter(),||panic!("closed"));
    assert!(!focused);assert!(query.is_empty());
}
#[test]
fn focus_loss_window_and_session_changes_drop_ambiguous_input() {
    for change in 0..3 {
        let(mut input,mut query,mut focused)=active();
        frame(&mut input,&mut query,&mut focused,&[down(KeyCode::ControlLeft,None)],||panic!());
        let window=if change==1{Entity::from_raw_u32(17).unwrap()}else{Entity::PLACEHOLDER};
        input.update(&mut query,&mut focused,true,Some((window,true)),Some((if change==2{8}else{7},11)),change==0,
            [event(window,KeyCode::KeyV,ButtonState::Pressed,Some("v"))].iter(),||panic!("transition paste"));
        assert!(query.is_empty());
    }
    let(mut input,mut query,mut focused)=active();
    input.update(&mut query,&mut focused,true,Some((Entity::PLACEHOLDER,false)),Some((7,11)),false,paste_keys().iter(),||panic!());
    assert!(!focused);assert!(query.is_empty());
}
#[test]
fn foreign_window_and_other_shortcuts_do_not_read_clipboard_or_insert_letters() {
    let(mut input,mut query,mut focused)=active();
    let mut foreign=down(KeyCode::KeyV,Some("v"));foreign.window=Entity::from_raw_u32(17).unwrap();
    frame(&mut input,&mut query,&mut focused,&[foreign],||panic!());assert!(query.is_empty());
    frame(&mut input,&mut query,&mut focused,&[down(KeyCode::ControlLeft,None),down(KeyCode::KeyC,Some("c")),down(KeyCode::KeyA,Some("a"))],||panic!());
    assert!(query.is_empty());
}
#[test]
fn right_alt_text_is_not_misinterpreted_as_control_v() {
    let(mut input,mut query,mut focused)=active();
    frame(&mut input,&mut query,&mut focused,&[down(KeyCode::ControlLeft,None),down(KeyCode::AltRight,None),down(KeyCode::KeyV,Some("@"))],||panic!());
    assert_eq!(query,"@");
}
#[test]
fn clipboard_decoder_requires_bounded_terminated_valid_utf16() {
    assert_eq!(decode(&[0x70,0x6f,0x74,0x69,0x6f,0x6e,0,0xffff]).unwrap(),"potion");
    assert_eq!(decode(&[0xd83e,0xdd80,0]).unwrap(),"\u{1f980}");
    assert!(decode(&[0x70,0x6f]).is_err());assert!(decode(&[0xd800,0]).is_err());
    assert!(decode(&vec![0;CLIPBOARD_BYTES/2+1]).is_err());assert_eq!(decode(&[0]).unwrap(),"");
}

#[derive(Resource,Default)]
struct Fixture { input:Input, query:String, focused:bool, reads:usize }
fn drive(mut state:ResMut<Fixture>,mut events:MessageReader<KeyboardInput>,mut lost:MessageReader<KeyboardFocusLost>,windows:Query<(Entity,&Window),With<bevy::window::PrimaryWindow>>) {
    let window=windows.single().ok().map(|(e,w)|(e,w.focused));let lost=lost.read().next().is_some();
    let Fixture{input,query,focused,reads}=&mut *state;
    input.update(query,focused,true,window,Some((7,11)),lost,events.read(),||{*reads+=1;Ok("potion".into())});events.clear();
}
#[test]
fn actual_bevy_input_queue_keeps_modifier_order_and_independent_readers() {
    let mut app=App::new();app.add_plugins(InputPlugin).insert_resource(Fixture{focused:true,..default()}).add_systems(Update,drive);
    let window=app.world_mut().spawn((Window{focused:true,..default()},bevy::window::PrimaryWindow)).id();app.update();
    let mut other=app.world().resource::<Messages<KeyboardInput>>().get_cursor_current();
    for mut event in paste_keys(){event.window=window;app.world_mut().write_message(event);}
    app.update();assert_eq!(app.world().resource::<Fixture>().query,"potion");assert_eq!(app.world().resource::<Fixture>().reads,1);
    assert!(!app.world().resource::<ButtonInput<KeyCode>>().pressed(KeyCode::ControlLeft));
    assert_eq!(other.read(app.world().resource::<Messages<KeyboardInput>>()).count(),4);
    app.world_mut().write_message(KeyboardFocusLost);app.update();assert!(!app.world().resource::<Fixture>().focused);
}
#[test]
fn pasted_potion_matches_real_catalogue_in_all_and_utility_categories() {
    let(mut input,mut query,mut focused)=active();frame(&mut input,&mut query,&mut focused,&paste_keys(),||Ok("potion".into()));
    let mut filters=super::super::Filters{focused,open:true,query,category:0,inspected:None};
    let potion=openleague_core::shop::catalog().iter().find(|item|item.id==2003).unwrap();
    assert!(super::super::matches(potion,&filters));
    // Utilitaire now admits implemented consumables; paste still supplies the query.
    assert_eq!(filters.query,"potion");
    filters.category=3;assert!(super::super::matches(potion,&filters));
}
