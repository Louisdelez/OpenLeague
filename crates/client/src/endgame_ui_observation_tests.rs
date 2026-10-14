use super::*;
use std::collections::HashMap;

// A process-wide sequence prevents coarse Windows SystemTime collisions among
// concurrent tests. Exclusive creation also skips an existing foreign path.
static FIXTURE_DIRECTORY_SEQUENCE:std::sync::atomic::AtomicU64=std::sync::atomic::AtomicU64::new(0);
fn new_fixture_directory_at(scope:&std::path::Path,pid:u32,stamp:u128)->std::io::Result<std::path::PathBuf>{
 for _ in 0..256 {
  let sequence=FIXTURE_DIRECTORY_SEQUENCE.fetch_add(1,std::sync::atomic::Ordering::Relaxed);
  let path=scope.join(format!("test-events-{pid}-{stamp}-{sequence}"));
  match std::fs::create_dir(&path){
   Ok(())=>return Ok(path),
   Err(error)if error.kind()==std::io::ErrorKind::AlreadyExists=>continue,
   Err(error)=>return Err(error),
  }
 }
 Err(std::io::Error::new(std::io::ErrorKind::AlreadyExists,"bounded unique fixture directory attempts exhausted"))
}

fn app()->App {
 let nav=openleague_core::Navigation::load(include_str!("E:/OpenLeague/assets/maps/tt_navigation_grid.json"),include_bytes!("E:/OpenLeague/assets/maps/tt_navigation_grid.cells.bin")).unwrap();
 let mut game=openleague_core::Simulation::new(nav).unwrap();game.enable_map10().unwrap();game.session=7301;
 for _ in 0..6{game.join("garen").unwrap();}game.winner=Some(0);game.advance();let snapshot=game.snapshot();let id=snapshot.result.as_ref().unwrap().players[0].id;
 // Controlled terminal result and local accepted identity fixture: never an
 // ordinary victory/network/GPU/framebuffer claim.
 let connection=crate::Connection{socket:std::net::UdpSocket::bind("127.0.0.1:0").unwrap(),link:crate::session_connection::Link::legacy(),id:Some(id),session:Some(7301),sequence:0,last_join:std::time::Instant::now(),champion:"garen".into(),summoners:[None,None],rejection:String::new(),assembler:Default::default(),welcome_history:Default::default()};
 let mut app=App::new();app.add_plugins((MinimalPlugins,AssetPlugin::default())).init_asset::<Image>().init_resource::<ButtonInput<MouseButton>>().init_resource::<crate::native_endgame_ui::View>().init_resource::<crate::endgame_timeline::Clock>()
  .insert_resource(connection).insert_resource(crate::Match{snapshot:Some(snapshot),visuals:HashMap::new(),..default()}).add_message::<bevy::app::AppExit>()
  .add_systems(Update,(crate::endgame_timeline::update,drive,crate::native_endgame_ui::update,crate::match_results_ui::update,crate::session_departure::return_button).chain());
 app.world_mut().resource_mut::<Time<Virtual>>().set_max_delta(std::time::Duration::from_secs(10));app.insert_resource(bevy::time::TimeUpdateStrategy::ManualDuration(std::time::Duration::ZERO));
 let path=new_fixture_directory_at(std::path::Path::new("E:/mapslol3v3/endgame_ui_observation_candidate"),std::process::id(),std::time::SystemTime::now().duration_since(std::time::UNIX_EPOCH).unwrap().as_nanos()).unwrap();
 let mut host=Host::default();host.directory=Some(path);app.insert_resource(host);
 let splash=app.world_mut().spawn((crate::native_endgame_ui::Splash,Node::default())).id();
 app.world_mut().spawn((crate::native_endgame_ui::Continue,Interaction::None,Node::default(),ImageNode::default(),ChildOf(splash)));
 let results=app.world_mut().spawn((crate::match_results_ui::ResultsPanel,Node::default())).id();
 app.world_mut().spawn((crate::match_results_ui::ResultsText,Text::default(),ChildOf(results)));
 app.world_mut().spawn((crate::session_departure::ReturnButton,Interaction::None,Node::default(),BackgroundColor::default(),ChildOf(results)));
 app
}
fn advance(app:&mut App,seconds:f64){app.insert_resource(bevy::time::TimeUpdateStrategy::ManualDuration(std::time::Duration::from_secs_f64(seconds)));app.update();app.insert_resource(bevy::time::TimeUpdateStrategy::ManualDuration(std::time::Duration::ZERO));}
fn node<T:Component>(app:&mut App)->Display{let entity=one::<T>(app.world_mut()).unwrap();app.world().get::<Node>(entity).unwrap().display}
fn clean(app:&App){let host=app.world().resource::<Host>();if let Some(path)=&host.directory{std::fs::remove_file(path.join("events.jsonl")).unwrap();std::fs::remove_dir(path).unwrap();}}

#[test]
fn programmatic_armed_continue_uses_stock_consumer_then_stock_results_and_return_exit(){
 let mut app=app();app.update();advance(&mut app,5.5);assert_eq!(node::<crate::native_endgame_ui::Splash>(&mut app),Display::Flex);
 app.world_mut().resource_mut::<Host>().stage=Stage::ContinuePress;app.update();assert!(app.world().resource::<crate::native_endgame_ui::View>().armed);assert!(!app.world().resource::<crate::native_endgame_ui::View>().dismissed);
 app.update();assert!(app.world().resource::<crate::native_endgame_ui::View>().dismissed);assert_eq!(node::<crate::match_results_ui::ResultsPanel>(&mut app),Display::Flex);assert_eq!(node::<crate::session_departure::ReturnButton>(&mut app),Display::Flex);
 app.world_mut().resource_mut::<ButtonInput<MouseButton>>().clear();app.world_mut().resource_mut::<Host>().stage=Stage::ReturnPress;app.update();
 let mut cursor=bevy::ecs::message::MessageCursor::<bevy::app::AppExit>::default();assert_eq!(cursor.read(app.world().resource::<Messages<bevy::app::AppExit>>()).count(),0);
 app.update();assert_eq!(cursor.read(app.world().resource::<Messages<bevy::app::AppExit>>()).filter(|e|matches!(e,bevy::app::AppExit::Success)).count(),1);clean(&app);
}
#[test]
fn before_native_deadline_same_gesture_cannot_dismiss_splash_or_show_results(){
 let mut app=app();app.update();advance(&mut app,5.499999);app.world_mut().resource_mut::<Host>().stage=Stage::ContinuePress;app.update();app.update();assert_eq!(app.world().resource::<Host>().stage,Stage::Failed);assert!(!app.world().resource::<crate::native_endgame_ui::View>().dismissed);assert_eq!(node::<crate::match_results_ui::ResultsPanel>(&mut app),Display::None);clean(&app);
}
#[test]
fn replaced_session_fails_before_a_programmatic_gesture_can_touch_new_owner(){
 let mut app=app();app.update();let entity=one::<crate::native_endgame_ui::Continue>(app.world_mut()).unwrap();app.world_mut().resource_mut::<Host>().stage=Stage::ContinuePress;
 app.world_mut().resource_mut::<crate::Connection>().session=Some(9999);app.update();assert_eq!(app.world().resource::<Host>().stage,Stage::Failed);assert_eq!(*app.world().get::<Interaction>(entity).unwrap(),Interaction::None);assert!(!app.world().resource::<ButtonInput<MouseButton>>().pressed(MouseButton::Left));clean(&app);
}
#[test]
fn session_replacement_between_press_and_release_restores_only_owned_gesture(){
 let mut app=app();app.update();advance(&mut app,5.5);let entity=one::<crate::native_endgame_ui::Continue>(app.world_mut()).unwrap();app.world_mut().resource_mut::<Host>().stage=Stage::ContinuePress;app.update();assert!(app.world().resource::<ButtonInput<MouseButton>>().pressed(MouseButton::Left));
 app.world_mut().resource_mut::<crate::Connection>().session=Some(9999);app.update();assert_eq!(app.world().resource::<Host>().stage,Stage::Failed);assert_eq!(*app.world().get::<Interaction>(entity).unwrap(),Interaction::None);assert!(!app.world().resource::<ButtonInput<MouseButton>>().pressed(MouseButton::Left));assert!(!app.world().resource::<crate::native_endgame_ui::View>().dismissed);clean(&app);
}
