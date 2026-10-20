//! Opt-in application UI exercise after an actual accepted terminal snapshot.
//! Programmatic Interaction + ButtonInput gestures, never physical/user approval.
//! Existing UI and departure consumers own transitions and AppExit.
use bevy::prelude::*;
use bevy::render::view::screenshot::ScreenshotCaptured;
use std::{collections::HashSet,path::PathBuf};

#[derive(Clone,Copy,Debug,PartialEq,Eq)]
enum Stage {Wait,PreCapture,PreWait,SplashWait,SplashCapture,SplashCaptured,ContinuePress,ContinueRelease,ResultsWait,ResultsCapture,ResultsCaptured,ReturnPress,ReturnRelease,Returned,Failed}
#[derive(Resource)]
pub struct Host {
 directory:Option<PathBuf>,key:Option<(u64,u64,u32)>,stage:Stage,started:f64,
 captured:HashSet<String>,error:Option<String>,expected_files:HashSet<String>,
 owned_gesture:Option<(Entity,Interaction,bool)>,
}
impl Default for Host {fn default()->Self{Self{directory:None,key:None,stage:Stage::Wait,started:0.,captured:HashSet::new(),error:None,expected_files:HashSet::new(),owned_gesture:None}}}
#[derive(Component)]struct Capture {key:(u64,u64,u32),name:String,path:PathBuf}

fn valid_directory()->Result<Option<PathBuf>,String>{
 let Some(raw)=std::env::var_os("OPENLEAGUE_ENDGAME_UI_OBSERVATION")else{return Ok(None);};
 let path=PathBuf::from(raw);
 let allowed=path.starts_with("E:/mapslol3v3")||path.starts_with("E:/OpenLeague/logs");
 if !path.is_absolute()||!allowed||path.components().any(|p|matches!(p,std::path::Component::ParentDir))||path.exists(){return Err("endgame UI output must be a fresh absolute child of scratch or OpenLeague/logs".into());}
 std::fs::create_dir(&path).map_err(|e|format!("endgame UI fresh output: {e}"))?;Ok(Some(path))
}
fn write(host:&mut Host,row:serde_json::Value){
 let Some(directory)=&host.directory else{return;};
 use std::io::Write;
 let result=(||->std::io::Result<()>{let mut f=std::fs::OpenOptions::new().create(true).append(true).open(directory.join("events.jsonl"))?;writeln!(f,"{row}")})();
 if let Err(error)=result {host.error=Some(format!("observation journal: {error}"));host.stage=Stage::Failed;}
}
fn fail(host:&mut Host,error:&str){host.error=Some(error.into());host.stage=Stage::Failed;write(host,serde_json::json!({"stage":"failed","key":host.key,"error":error}));}
fn setup(mut host:ResMut<Host>){
 match valid_directory(){Ok(directory)=>host.directory=directory,Err(error)=>{host.error=Some(error.clone());host.stage=Stage::Failed;warn!("{error}");}}
}
fn gesture(world:&mut World,entity:Entity,pressed:bool){
 if let Some(mut interaction)=world.get_mut::<Interaction>(entity){*interaction=if pressed{Interaction::Pressed}else{Interaction::Hovered};}
 if let Some(mut mouse)=world.get_resource_mut::<ButtonInput<MouseButton>>(){if pressed{mouse.press(MouseButton::Left);}else{mouse.release(MouseButton::Left);}}
}
fn begin_gesture(world:&mut World,host:&mut Host,entity:Entity){
 if host.owned_gesture.is_none(){
  let previous=world.get::<Interaction>(entity).copied().unwrap_or(Interaction::None);
  let was_pressed=world.get_resource::<ButtonInput<MouseButton>>().is_some_and(|m|m.pressed(MouseButton::Left));
  host.owned_gesture=Some((entity,previous,was_pressed));
 }
 gesture(world,entity,true);
}
fn release_owned(world:&mut World,host:&mut Host){
 if let Some((entity,previous,was_pressed))=host.owned_gesture.take(){
  if let Some(mut interaction)=world.get_mut::<Interaction>(entity){if matches!(*interaction,Interaction::Pressed|Interaction::Hovered){*interaction=previous;}}
  if !was_pressed {if let Some(mut input)=world.get_resource_mut::<ButtonInput<MouseButton>>(){if input.pressed(MouseButton::Left){input.release(MouseButton::Left);}}}
 }
}
fn one<T:Component>(world:&mut World)->Option<Entity>{let mut q=world.query_filtered::<Entity,With<T>>();let mut rows=q.iter(world);let entity=rows.next()?;rows.next().is_none().then_some(entity)}
fn button_visible<T:Component>(world:&World,entity:Entity)->bool {
 if !world.get::<Node>(entity).is_some_and(|n|n.display!=Display::None){return false;}
 let mut cursor=world.get::<ChildOf>(entity).map(|p|p.parent());let mut seen=HashSet::new();
 while let Some(parent)=cursor {
  if !seen.insert(parent)||seen.len()>32{return false;}
  if !world.get::<Node>(parent).is_some_and(|n|n.display!=Display::None){return false;}
  if world.get::<T>(parent).is_some(){return true;}
  cursor=world.get::<ChildOf>(parent).map(|p|p.parent());
 }
 false
}

/// After ordinary UI input focus and receive, before the stock UI consumers.
pub fn drive(world:&mut World){
 let mut host=world.remove_resource::<Host>().unwrap_or_default();
 if host.directory.is_none(){world.insert_resource(host);return;}
 if host.stage==Stage::Failed{release_owned(world,&mut host);world.insert_resource(host);return;}
 let now=world.resource::<Time>().elapsed_secs_f64();
 let selected=(|| {
  let identity=world.get_resource::<crate::Connection>()?.inventory_input_identity()?;
  let state=world.get_resource::<crate::Match>()?;let snapshot=state.snapshot.as_ref()?;let result=snapshot.result.as_ref()?;
  if result.session!=identity.0||snapshot.session!=identity.0||result.winner>1||snapshot.winner!=Some(result.winner)
   ||!result.players.iter().any(|p|p.id==identity.1){return None;}
  let age=world.get_resource::<crate::endgame_timeline::Clock>()?.age(now)?;
  Some(((result.session,result.ended_tick,identity.1),age))
 })();
 let Some((key,age))=selected else{
  if host.key.is_some()&&!matches!(host.stage,Stage::Returned|Stage::ReturnRelease){fail(&mut host,"accepted terminal identity/result disappeared during exercise");}
  if host.stage==Stage::Failed{release_owned(world,&mut host);}world.insert_resource(host);return;
 };
 if host.key.is_none(){host.key=Some(key);host.started=now;write(&mut host,serde_json::json!({"stage":"accepted_result","session":key.0,"ended_tick":key.1,"local_player":key.2,"age":age,"application_UI_test":true,"physical_click":false,"Tauri_return_qualified":false}));}
 else if host.key!=Some(key){fail(&mut host,"terminal session/tick/player replaced; old exercise cannot affect new owner");release_owned(world,&mut host);world.insert_resource(host);return;}
 if now-host.started>60.&&!matches!(host.stage,Stage::Returned){fail(&mut host,"bounded endgame UI observation60seconds exceeded");release_owned(world,&mut host);world.insert_resource(host);return;}
 match host.stage {
  Stage::ContinuePress=>{
   if !crate::native_minion_fade_observation::cleanup_complete_for(world,key){world.insert_resource(host);return;}
   if let Some(entity)=one::<crate::native_endgame_ui::Continue>(world).filter(|e|button_visible::<crate::native_endgame_ui::Splash>(world,*e)) {begin_gesture(world,&mut host,entity);write(&mut host,serde_json::json!({"stage":"continue_press","key":key,"entity":format!("{entity:?}"),"age":age,"programmatic":true}));host.stage=Stage::ContinueRelease;}
   else{fail(&mut host,"actual unique Continue button unavailable");}
  },
  Stage::ContinueRelease=>{
   if let Some(entity)=one::<crate::native_endgame_ui::Continue>(world).filter(|e|button_visible::<crate::native_endgame_ui::Splash>(world,*e)){gesture(world,entity,false);write(&mut host,serde_json::json!({"stage":"continue_release_inside","key":key,"entity":format!("{entity:?}"),"age":age,"programmatic":true}));host.stage=Stage::ResultsWait;}
   else{fail(&mut host,"actual Continue button retired before release");}
  },
  Stage::ReturnPress=>{
   if let Some(entity)=one::<crate::session_departure::ReturnButton>(world).filter(|e|button_visible::<crate::match_results_ui::ResultsPanel>(world,*e)){begin_gesture(world,&mut host,entity);write(&mut host,serde_json::json!({"stage":"return_press","key":key,"entity":format!("{entity:?}"),"age":age,"programmatic":true,"actual_launcher_observed":false}));host.stage=Stage::ReturnRelease;}
   else{fail(&mut host,"actual unique ReturnButton unavailable");}
  },
  Stage::ReturnRelease=>{
   if let Some(entity)=one::<crate::session_departure::ReturnButton>(world).filter(|e|button_visible::<crate::match_results_ui::ResultsPanel>(world,*e)){gesture(world,entity,false);write(&mut host,serde_json::json!({"stage":"return_release_inside","key":key,"entity":format!("{entity:?}"),"age":age,"programmatic":true}));host.stage=Stage::Returned;}
   else{fail(&mut host,"actual ReturnButton retired before release");}
  },
  _=>{},
 }
 world.insert_resource(host);
}

fn captured(event:On<ScreenshotCaptured>,query:Query<&Capture>,time:Res<Time>,clock:Res<crate::endgame_timeline::Clock>,mut host:ResMut<Host>){
 let Ok(request)=query.get(event.entity)else{return;};
 if host.key!=Some(request.key)||host.stage==Stage::Failed{return;}
 let image=event.image.clone();let size=[image.width(),image.height()];
 let result=image.try_into_dynamic().map_err(|e|format!("screenshot conversion: {e}")).and_then(|image|image.to_rgb8().save(&request.path).map_err(|e|format!("screenshot save: {e}")));
 match result {Ok(())=>{host.captured.insert(request.name.clone());write(&mut host,serde_json::json!({"stage":"framebuffer_saved","key":request.key,"capture":request.name,"path":request.path,"dimensions":size,"callback_local_time":time.elapsed_secs_f64(),"callback_ceremony_age":clock.age(time.elapsed_secs_f64()),"exact_GPU_exposure_time":null,"visually_reviewed":false}));},Err(error)=>fail(&mut host,&error)}
}

/// After all stock UI consumers. Uses their resulting Nodes/View/Playback.
pub fn observe(world:&mut World){
 let mut host=world.remove_resource::<Host>().unwrap_or_default();
 if host.directory.is_none()||host.key.is_none()||host.stage==Stage::Failed{world.insert_resource(host);return;}
 let key=host.key.unwrap();let now=world.resource::<Time>().elapsed_secs_f64();let age=world.resource::<crate::endgame_timeline::Clock>().age(now).unwrap_or(0.);
 let splash=one::<crate::native_endgame_ui::Splash>(world).and_then(|e|world.get::<Node>(e)).is_some_and(|n|n.display==Display::Flex);
 let results=one::<crate::match_results_ui::ResultsPanel>(world).and_then(|e|world.get::<Node>(e)).is_some_and(|n|n.display==Display::Flex);
 let return_visible=one::<crate::session_departure::ReturnButton>(world).and_then(|e|world.get::<Node>(e)).is_some_and(|n|n.display==Display::Flex);
 let dismissed=world.resource::<crate::native_endgame_ui::View>().dismissed;
 let nexus_loaded=(||{let state=world.resource::<crate::Match>();let result=state.snapshot.as_ref()?.result.as_ref()?;let nexus=result.destroyed_nexus.as_ref()?;let root=state.visuals.get(&nexus.id)?;let playback=world.get::<crate::animation::Playback>(*root)?;Some(playback.model_name().ends_with("_destroyed"))})().unwrap_or(false);
 let text=one::<crate::match_results_ui::ResultsText>(world).and_then(|e|world.get::<Text>(e)).map(|t|t.0.clone());
 let before=host.stage;
 match host.stage {
  Stage::Wait if age<crate::endgame_timeline::schedule().skin=>host.stage=Stage::PreCapture,
  Stage::Wait=>fail(&mut host,"first observation missed pre-no-render ceremony capture"),
  Stage::PreWait if host.captured.contains("ceremony-before")=>host.stage=Stage::SplashWait,
  Stage::SplashWait if age>=crate::endgame_timeline::schedule().scoreboard()&&splash&&nexus_loaded=>host.stage=Stage::SplashCapture,
  Stage::SplashCaptured if host.captured.contains("native-splash")=>host.stage=Stage::ContinuePress,
  Stage::ResultsWait if !splash&&dismissed&&results&&return_visible&&text.as_ref().is_some_and(|t|!t.is_empty())=>host.stage=Stage::ResultsCapture,
  Stage::ResultsCaptured if host.captured.contains("results-panel")=>host.stage=Stage::ReturnPress,
  _=>{},
 }
 if matches!(host.stage,Stage::ResultsWait|Stage::Returned|Stage::Failed){release_owned(world,&mut host);}
 if host.stage!=before{let current=host.stage;write(&mut host,serde_json::json!({"stage":"consumer_state","key":key,"age":age,"previous":format!("{before:?}"),"current":format!("{current:?}"),"splash_visible":splash,"results_visible":results,"return_visible":return_visible,"dismissed":dismissed,"destroyed_nexus_loaded":nexus_loaded,"results_text":text}));}
 let capture=match host.stage {Stage::PreCapture=>Some(("ceremony-before",Stage::PreWait)),Stage::SplashCapture=>Some(("native-splash",Stage::SplashCaptured)),Stage::ResultsCapture=>Some(("results-panel",Stage::ResultsCaptured)),_=>None};
 if let Some((name,next))=capture {
  let path=host.directory.as_ref().unwrap().join(format!("{name}.png"));
  if path.exists()||host.expected_files.contains(name){fail(&mut host,"capture path already exists or duplicate request");}
  else if let Some(entity)=crate::native_minion_fade_observation::try_primary_capture(world){host.expected_files.insert(name.into());world.entity_mut(entity).insert(Capture{key,name:name.into(),path:path.clone()}).observe(captured);host.stage=next;write(&mut host,serde_json::json!({"stage":"framebuffer_requested","key":key,"request_ceremony_age":age,"exact_GPU_exposure_time":null,"capture":name,"path":path,"splash_visible":splash,"results_visible":results,"nexus_loaded":nexus_loaded}));}
 }
 world.insert_resource(host);
}

pub fn exit_report(mut exits:MessageReader<bevy::app::AppExit>,connection:Res<crate::Connection>,mut host:ResMut<Host>){
 if host.directory.is_none()||host.stage!=Stage::Returned{return;}
 for exit in exits.read(){
  let key=host.key;write(&mut host,serde_json::json!({"stage":"stock_AppExit_observed","key":key,"success":matches!(exit,bevy::app::AppExit::Success),"connection_public_identity_after_departure":connection.inventory_input_identity(),"expected_identity_after_stock_departure":null,"application_UI_test":true,"physical_click":false,"launcher_return_qualified":false}));
 }
}

pub struct Plugin;
impl bevy::app::Plugin for Plugin {
 fn build(&self,app:&mut App){app.init_resource::<Host>().add_systems(Startup,setup)
  .add_systems(Update,drive.after(crate::receive).after(crate::endgame_timeline::update)
   .before(crate::native_endgame_ui::update).before(crate::session_departure::return_button))
  .add_systems(PostUpdate,observe.after(bevy::camera::visibility::VisibilitySystems::CheckVisibility))
  .add_systems(Last,exit_report.after(crate::session_departure::on_exit));}
}

#[cfg(test)]
#[path="endgame_ui_observation_tests.rs"]mod tests;
