//! Original classic 4.20 splash assets/layout. Native engine callback/ceremony remains open.
use bevy::prelude::*;
use crate::{Match,Connection};
#[derive(Resource,Default)] pub struct View {pub session:Option<u64>,pub dismissed:bool,pub armed:bool}
#[derive(Component)] pub struct Splash;
#[derive(Component)] pub struct NativeImage(&'static str);
#[derive(Component)] pub struct Continue;
pub fn setup(mut commands:Commands,assets:Res<AssetServer>){
 commands.spawn((Splash,Node{display:Display::None,position_type:PositionType::Absolute,width:Val::Px(1024.),height:Val::Px(532.),..default()})).with_children(|parent|{
  parent.spawn((NativeImage("background"),ImageNode::new(assets.load("ui/endgame/victory.png")),Node{position_type:PositionType::Absolute,width:Val::Px(1024.),height:Val::Px(512.),..default()}));
  parent.spawn((NativeImage("title"),ImageNode::new(assets.load("ui/endgame/victory_title.png")),Node{position_type:PositionType::Absolute,..default()}));
  parent.spawn((Button,Continue,ImageNode::new(assets.load("ui/endgame/victory_idle.png")),Node{position_type:PositionType::Absolute,left:Val::Px(409.95),top:Val::Px(469.95),width:Val::Px(204.),height:Val::Px(60.),justify_content:JustifyContent::Center,align_items:AlignItems::Center,..default()})).with_children(|parent|{parent.spawn((Text::new("CONTINUER"),TextFont{font:FontSource::Handle(assets.load("fonts/DejaVuSans.ttf")),font_size:FontSize::Px(20.),..default()},TextColor(Color::srgb_u8(255,244,153)),NativeImage("button_label")));});
 });
}
fn local_victory(result:&openleague_core::match_results::MatchResult,id:Option<u32>)->Option<bool>{id.and_then(|id|result.players.iter().find(|p|p.id==id)).map(|p|p.team==result.winner)}
pub fn update(time:Res<Time>,clock:Res<crate::endgame_timeline::Clock>,state:Res<Match>,connection:Res<Connection>,mut view:ResMut<View>,assets:Res<AssetServer>,buttons:Res<ButtonInput<MouseButton>>,windows:Query<&Window>,
 mut roots:Query<&mut Node,(With<Splash>,Without<NativeImage>,Without<Continue>)>,
 mut images:Query<(&NativeImage,&mut Node,Option<&mut ImageNode>,Option<&mut TextFont>),(Without<Splash>,Without<Continue>)>,
 mut controls:Query<(&Interaction,&mut Node,&mut ImageNode),(With<Continue>,Without<Splash>,Without<NativeImage>)>){
 let result=state.snapshot.as_ref().and_then(|s|s.result.as_ref());
 if view.session!=result.map(|r|r.session){view.session=result.map(|r|r.session);view.dismissed=false;view.armed=false;}
 let victory=result.and_then(|r|local_victory(r,connection.id));
 let visible=victory.is_some()&&!view.dismissed&&clock.scoreboard_due(time.elapsed_secs_f64());
 let window=windows.iter().next();let (w,h)=window.map(|w|(w.width(),w.height())).unwrap_or((1280.,800.));let scale=(w/1024.).min(h/532.).min(1.);
 for mut root in &mut roots {root.display=if visible {Display::Flex}else{Display::None};root.width=Val::Px(1024.*scale);root.height=Val::Px(532.*scale);root.left=Val::Px((w-1024.*scale)/2.);root.top=Val::Px((h-532.*scale)/2.);}
 let outcome=if victory==Some(false){"defeat"}else{"victory"};
 static CATALOG:std::sync::OnceLock<serde_json::Value>=std::sync::OnceLock::new();
 let catalog=CATALOG.get_or_init(||serde_json::from_str(include_str!("../../../data/4.20/endgame_ui_native.json")).expect("native UI catalog"));
 for (kind,mut node,image,font) in &mut images {
  if let Some(mut image)=image {
   let key=if kind.0=="title"{format!("{outcome}_title")}else{outcome.into()};image.image=assets.load(format!("ui/endgame/{key}.png"));
   let rect=catalog["converted_assets"][&key]["rect"].as_array().expect("native rectangle");let v:Vec<f32>=rect.iter().map(|v|v.as_f64().unwrap() as f32).collect();image.rect=Some(Rect::new(v[0],v[1],v[2],v[3]));
   node.width=Val::Px((v[2]-v[0])*scale);node.height=Val::Px((v[3]-v[1])*scale);
   if kind.0=="title"{node.left=Val::Px((67.+(890.95-(v[2]-v[0]))/2.)*scale);node.top=Val::Px(196.75*scale);}
  }
  if let Some(mut font)=font{font.font_size=FontSize::Px(20.*scale);}
 }
 for (interaction,mut node,mut image) in &mut controls {
  let appearance=match interaction {Interaction::Pressed=>"down",Interaction::Hovered=>"hover",Interaction::None=>"idle"};let key=format!("{outcome}_{appearance}");image.image=assets.load(format!("ui/endgame/{key}.png"));// ExternalImage logical dimensions define the display extent; DDS storage is resampled to a power of two.
  image.rect=None;
  node.left=Val::Px(if outcome=="defeat"{410.95*scale}else{409.95*scale});node.top=Val::Px(469.95*scale);node.width=Val::Px(204.*scale);node.height=Val::Px(60.*scale);
  if visible&&*interaction==Interaction::Pressed{view.armed=true;}
  if buttons.just_released(MouseButton::Left){if visible&&view.armed&&*interaction==Interaction::Hovered{view.dismissed=true;}view.armed=false;}
 }
}

#[cfg(test)] mod tests {
 use super::*;
 fn app(team:u8)->(App,Entity,Entity,Entity){
  let nav=openleague_core::Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();let mut game=openleague_core::Simulation::new(nav).unwrap();game.session=42;for _ in 0..6{game.join("garen").unwrap();}let id=game.players.values().find(|p|p.team==team).unwrap().id;game.winner=Some(0);game.advance();
  let connection=Connection{link:crate::session_connection::Link::legacy(),welcome_history:Default::default(),socket:std::net::UdpSocket::bind("127.0.0.1:0").unwrap(),id:Some(id),session:Some(42),sequence:0,last_join:std::time::Instant::now(),champion:"garen".into(),summoners:[None,None],rejection:String::new(),assembler:Default::default()};
  let mut app=App::new();app.add_plugins((MinimalPlugins,AssetPlugin::default())).init_asset::<Image>().init_resource::<View>().init_resource::<crate::endgame_timeline::Clock>().init_resource::<ButtonInput<MouseButton>>().insert_resource(connection).insert_resource(Match{snapshot:Some(game.snapshot()),..default()}).add_systems(Update,(crate::endgame_timeline::update,update).chain());
  app.world_mut().resource_mut::<Time<Virtual>>().set_max_delta(std::time::Duration::from_secs(10));
  // Every deadline test starts on a controlled clock. Asset initialization or
  // concurrent tests must not advance the native scoreboard phase deadline.
  app.insert_resource(bevy::time::TimeUpdateStrategy::ManualDuration(std::time::Duration::ZERO));
  let root=app.world_mut().spawn((Splash,Node::default())).id();let image=app.world_mut().spawn((NativeImage("background"),Node::default(),ImageNode::default())).id();let button=app.world_mut().spawn((Continue,Node::default(),ImageNode::default(),Interaction::None)).id();(app,root,image,button)
 }
 #[test] fn native_splash_selects_local_team_and_dismisses_only_armed_release(){
  let (mut app,root,image,button)=app(0);app.update();app.insert_resource(bevy::time::TimeUpdateStrategy::ManualDuration(std::time::Duration::from_secs(6)));app.update();assert_eq!(app.world().get::<Node>(root).unwrap().display,Display::Flex);
  let image_path=app.world().resource::<AssetServer>().get_path(app.world().get::<ImageNode>(image).unwrap().image.id()).unwrap();assert_eq!(image_path.path().to_str(),Some("ui/endgame/victory.png"));
  app.world_mut().resource_mut::<ButtonInput<MouseButton>>().press(MouseButton::Left);*app.world_mut().get_mut::<Interaction>(button).unwrap()=Interaction::Pressed;app.update();assert!(app.world().resource::<View>().armed);
  *app.world_mut().get_mut::<Interaction>(button).unwrap()=Interaction::Hovered;app.world_mut().resource_mut::<ButtonInput<MouseButton>>().release(MouseButton::Left);app.update();assert!(app.world().resource::<View>().dismissed);
  app.world_mut().resource_mut::<ButtonInput<MouseButton>>().clear();app.update();assert_eq!(app.world().get::<Node>(root).unwrap().display,Display::None);
 }
 #[test] fn losing_team_uses_original_red_asset_and_unarmed_release_is_ignored(){
  let (mut app,_,image,button)=app(1);app.update();let image_path=app.world().resource::<AssetServer>().get_path(app.world().get::<ImageNode>(image).unwrap().image.id()).unwrap();assert_eq!(image_path.path().to_str(),Some("ui/endgame/defeat.png"));
  *app.world_mut().get_mut::<Interaction>(button).unwrap()=Interaction::Hovered;let mut input=app.world_mut().resource_mut::<ButtonInput<MouseButton>>();input.press(MouseButton::Left);input.release(MouseButton::Left);drop(input);app.update();assert!(!app.world().resource::<View>().dismissed);
 }
 #[test] fn actual_ui_stays_hidden_and_ignores_continue_before_native_phase_deadline(){
  let (mut app,root,_,button)=app(0);app.update();assert_eq!(app.world().get::<Node>(root).unwrap().display,Display::None);
  *app.world_mut().get_mut::<Interaction>(button).unwrap()=Interaction::Pressed;app.update();assert!(!app.world().resource::<View>().armed);
  *app.world_mut().get_mut::<Interaction>(button).unwrap()=Interaction::None;
  app.insert_resource(bevy::time::TimeUpdateStrategy::ManualDuration(std::time::Duration::from_secs(1)));
  for _ in 0..5 {app.update();assert_eq!(app.world().get::<Node>(root).unwrap().display,Display::None);}
  app.update();assert_eq!(app.world().get::<Node>(root).unwrap().display,Display::Flex);
 }

}

/// Opt-in observation of actual UI state and native deadlines. Disabled during ordinary play.
pub fn phase_probe(pan:Res<crate::camera_native::EndPan>,camera:Res<crate::camera_native::NativeCamera>,poses:Query<&Transform,With<Camera3d>>,state:Res<Match>,time:Res<Time>,clock:Res<crate::endgame_timeline::Clock>,view:Res<View>,roots:Query<&Node,With<Splash>>,mut next:Local<f64>){
 if std::env::var("OPENLEAGUE_ENDGAME_PHASE_PROBE").as_deref()!=Ok("1"){return;}
 let Some(result)=state.snapshot.as_ref().and_then(|s|s.result.as_ref()) else{return;};let now=time.elapsed_secs_f64();if now<*next{return;}*next=now+0.1;
 let record=serde_json::json!({"session":result.session,"ended_tick":result.ended_tick,"local_time":now,"age":clock.age(now),"native_scoreboard_deadline":crate::endgame_timeline::schedule().scoreboard(),"due":clock.scoreboard_due(now),"dismissed":view.dismissed,"splash_visible":roots.iter().any(|n|n.display==Display::Flex),"pan_initial":pan.initial,"pan_started":pan.started,"pan_now":time.elapsed_secs(),"pan_target":result.destroyed_nexus.as_ref().map(|n|n.position),"pan_current":pan.pan.as_ref().map(|p|p.current),"pan_finished":pan.pan.as_ref().map(|p|p.finished),"native_render_focus":camera.native_focus(),"render_camera_position":poses.iter().next().map(|t|t.translation.to_array())});
 use std::io::Write;let path=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../../logs/endgame-camera-pan-runtime.jsonl");let mut file=std::fs::OpenOptions::new().create(true).append(true).open(path).expect("diagnostic phase log");writeln!(file,"{record}").expect("diagnostic phase record");
}
