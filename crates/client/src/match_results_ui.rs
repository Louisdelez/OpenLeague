//! Terminal scoreboard consumes immutable authoritative results, never the live roster.
use bevy::prelude::*;
use crate::{Match, Connection};
use openleague_core::match_results::MatchResult;
#[derive(Component)] pub struct ResultsPanel;
#[derive(Component)] pub struct ResultsText;
// Application results sit above the current HUD (native layers 80+N, glyphs100).
const RESULTS_Z_INDEX: i32 = 200;
pub fn setup(mut commands:Commands, assets:Res<AssetServer>) {
 spawn_panel(&mut commands, assets.load("fonts/DejaVuSans.ttf"));
}
fn spawn_panel(commands:&mut Commands, font:Handle<Font>) {
 commands.spawn((ResultsPanel,GlobalZIndex(RESULTS_Z_INDEX),
  BackgroundColor(Color::srgba(0.02,0.03,0.05,0.97)),Node{display:Display::None,position_type:PositionType::Absolute,left:Val::Percent(15.),top:Val::Percent(15.),width:Val::Percent(70.),padding:UiRect::all(Val::Px(24.)),flex_direction:FlexDirection::Column,row_gap:Val::Px(20.),..default()}))
  .with_children(|panel| {
   panel.spawn((ResultsText,Text::new(""),TextFont{font:FontSource::Handle(font.clone()),font_size:FontSize::Px(20.),..default()},Node{width:Val::Percent(100.),..default()}));
   panel.spawn((Button,crate::session_departure::ReturnButton,BackgroundColor(Color::srgb_u8(38,55,66)),
    Node{display:Display::None,align_self:AlignSelf::FlexEnd,flex_shrink:0.,padding:UiRect::axes(Val::Px(22.),Val::Px(12.)),..default()}))
    .with_children(|button| {
     button.spawn((Text::new("RETOUR AU LAUNCHER"),TextFont{font:FontSource::Handle(font),font_size:FontSize::Px(18.),..default()},TextColor(Color::srgb_u8(255,244,153))));
    });
  });
}
fn summary(result:&MatchResult, local_id:Option<u32>)->String {
 let team=local_id.and_then(|id|result.players.iter().find(|p|p.id==id)).map(|p|p.team);
 let heading=match team {Some(t) if t==result.winner=>"VICTOIRE",Some(_)=>"DÉFAITE",None=>"PARTIE TERMINÉE"};
 let mut text=format!("{heading} — équipe {}\nDurée : {}:{:02}\n",result.winner+1,result.ended_tick/30/60,result.ended_tick/30%60);
 for team in 0..2 {
  text.push_str(&format!("\nÉquipe {} — Champion | Niveau | K / D / A | Or restant\n",team+1));
  for p in result.players.iter().filter(|p|p.team==team) {
   text.push_str(&format!("{} | {} | {} / {} / {} | {:.0}\n",p.champion,p.level,p.score.kills,p.score.deaths,p.score.assists,p.gold_remaining));
  }
 }
 text
}
pub fn update(view:Res<crate::native_endgame_ui::View>,state:Res<Match>, connection:Res<Connection>,mut panels:Query<&mut Node,With<ResultsPanel>>,mut texts:Query<&mut Text,With<ResultsText>>) {
 let result=state.snapshot.as_ref().and_then(|s|s.result.as_ref());
 for mut node in &mut panels {
  node.display=if result.is_some() && view.dismissed{Display::Flex}else{Display::None};
 }
 if let Some(result)=result {for mut text in &mut texts {**text=summary(result,connection.id);}}
}
#[cfg(test)] mod tests {
 use super::*;
 #[test] fn scoreboard_uses_frozen_roster_when_live_players_have_disconnected() {
  let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../../data/4.20");
  let navigation=openleague_core::Navigation::load(&std::fs::read_to_string(root.join("../../assets/maps/tt_navigation_grid.json")).unwrap(),&std::fs::read(root.join("../../assets/maps/tt_navigation_grid.cells.bin")).unwrap()).unwrap();
  let mut game=openleague_core::Simulation::new(navigation).unwrap();game.enable_map10().unwrap();
  for _ in 0..6 {game.join("garen").unwrap();}
  game.winner=Some(0);game.advance();let mut snapshot=game.snapshot();let id=snapshot.result.as_ref().unwrap().players.iter().find(|p|p.team==0).unwrap().id;snapshot.players.clear();
  let socket=std::net::UdpSocket::bind("127.0.0.1:0").unwrap();
  let connection=Connection{link:crate::session_connection::Link::legacy(),welcome_history:Default::default(),socket,id:Some(id),session:None,sequence:0,last_join:std::time::Instant::now(),champion:"garen".into(),summoners:[None,None],rejection:String::new(),assembler:Default::default()};
  let mut app=App::new();app.insert_resource(crate::native_endgame_ui::View{dismissed:true,..default()}).insert_resource(connection).insert_resource(Match{snapshot:Some(snapshot),..default()}).add_systems(Update,update);
  app.add_systems(Startup,setup_test_panel);app.update();
  let panel=one::<ResultsPanel>(&mut app);
  let text_entity=one::<ResultsText>(&mut app);
  let text=&app.world().get::<Text>(text_entity).unwrap().0;assert!(text.starts_with("VICTOIRE"));assert_eq!(text.matches("garen |").count(),6);assert_eq!(app.world().get::<Node>(panel).unwrap().display,Display::Flex);
  assert_eq!(app.world().get::<ChildOf>(text_entity).unwrap().parent(),panel);
  app.world_mut().resource_mut::<Match>().snapshot=None;app.update();assert_eq!(app.world().get::<Node>(panel).unwrap().display,Display::None);
 }
 fn setup_test_panel(mut commands:Commands) {spawn_panel(&mut commands,Handle::default());}
 fn one<T:Component>(app:&mut App)->Entity {let world=app.world_mut();let mut query=world.query_filtered::<Entity,With<T>>();query.single(world).unwrap()}
 #[test] fn results_setup_keeps_return_inside_panel_above_hud() {
  let mut app=App::new();app.add_systems(Startup,setup_test_panel);app.update();
  let panel=one::<ResultsPanel>(&mut app);
  let text=one::<ResultsText>(&mut app);
  let button=one::<crate::session_departure::ReturnButton>(&mut app);
  assert_eq!(app.world().get::<ChildOf>(text).unwrap().parent(),panel);
  assert_eq!(app.world().get::<ChildOf>(button).unwrap().parent(),panel);
  let children=app.world().get::<Children>(panel).unwrap();assert_eq!(children.len(),2);assert_eq!(children[0],text);assert_eq!(children[1],button);
  assert!(app.world().get::<Text>(panel).is_none());
  let node=app.world().get::<Node>(panel).unwrap();assert_eq!(node.display,Display::None);assert_eq!(node.flex_direction,FlexDirection::Column);assert_eq!(node.row_gap,Val::Px(20.));
  assert_eq!(app.world().get::<GlobalZIndex>(panel).unwrap().0,RESULTS_Z_INDEX);assert!(RESULTS_Z_INDEX>100);
  let node=app.world().get::<Node>(button).unwrap();assert_eq!(node.display,Display::None);assert_eq!(node.position_type,PositionType::Relative);assert_eq!(node.align_self,AlignSelf::FlexEnd);assert_eq!(node.bottom,Val::Auto);
 }
}
