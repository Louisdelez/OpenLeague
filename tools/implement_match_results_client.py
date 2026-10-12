from pathlib import Path
r=Path(r'E:\OpenLeague')
p=r/'crates/client/src/match_results_ui.rs'
assert not p.exists()
p.write_text('''//! Terminal scoreboard consumes immutable authoritative results, never the live roster.
use bevy::prelude::*;
use crate::{Match, Connection};
use openleague_core::match_results::MatchResult;
#[derive(Component)] pub struct ResultsPanel;
pub fn setup(mut commands:Commands, assets:Res<AssetServer>) {
 commands.spawn((ResultsPanel,Text::new(""),TextFont{font:FontSource::Handle(assets.load("fonts/DejaVuSans.ttf")),font_size:FontSize::Px(20.),..default()},
  BackgroundColor(Color::srgba(0.02,0.03,0.05,0.97)),Node{display:Display::None,position_type:PositionType::Absolute,left:Val::Percent(15.),top:Val::Percent(15.),width:Val::Percent(70.),padding:UiRect::all(Val::Px(24.)),..default()}));
}
fn summary(result:&MatchResult, local_id:Option<u32>)->String {
 let team=local_id.and_then(|id|result.players.iter().find(|p|p.id==id)).map(|p|p.team);
 let heading=match team {Some(t) if t==result.winner=>"VICTOIRE",Some(_)=>"DÉFAITE",None=>"PARTIE TERMINÉE"};
 let mut text=format!("{heading} — équipe {}\\nDurée : {}:{:02}\\n",result.winner+1,result.ended_tick/30/60,result.ended_tick/30%60);
 for team in 0..2 {
  text.push_str(&format!("\\nÉquipe {} — Champion | Niveau | K / D / A | Or restant\\n",team+1));
  for p in result.players.iter().filter(|p|p.team==team) {
   text.push_str(&format!("{} | {} | {} / {} / {} | {:.0}\\n",p.champion,p.level,p.score.kills,p.score.deaths,p.score.assists,p.gold_remaining));
  }
 }
 text
}
pub fn update(state:Res<Match>, connection:Res<Connection>,mut panels:Query<(&mut Node,&mut Text),With<ResultsPanel>>) {
 let result=state.snapshot.as_ref().and_then(|s|s.result.as_ref());
 for (mut node,mut text) in &mut panels {
  node.display=if result.is_some(){Display::Flex}else{Display::None};
  if let Some(result)=result {**text=summary(result,connection.id);}
 }
}
#[cfg(test)] mod tests {
 use super::*;
 #[test] fn scoreboard_uses_frozen_roster_when_live_players_have_disconnected() {
  let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../../data/4.20");
  let mut game=openleague_core::Simulation::new(&root).unwrap();
  for _ in 0..6 {game.join("garen").unwrap();}
  game.winner=Some(0);game.advance();let mut snapshot=game.snapshot();let id=snapshot.result.as_ref().unwrap().players.iter().find(|p|p.team==0).unwrap().id;snapshot.players.clear();
  let socket=std::net::UdpSocket::bind("127.0.0.1:0").unwrap();
  let connection=Connection{socket,id:Some(id),session:None,sequence:0,last_join:std::time::Instant::now(),champion:"garen".into(),summoners:[None,None],rejection:String::new(),assembler:Default::default()};
  let mut app=App::new();app.insert_resource(connection).insert_resource(Match{snapshot:Some(snapshot),..default()}).add_systems(Update,update);
  let entity=app.world_mut().spawn((ResultsPanel,Node::default(),Text::new(""))).id();app.update();
  let text=&app.world().get::<Text>(entity).unwrap().0;assert!(text.starts_with("VICTOIRE"));assert_eq!(text.matches("garen |").count(),6);assert_eq!(app.world().get::<Node>(entity).unwrap().display,Display::Flex);
  app.world_mut().resource_mut::<Match>().snapshot=None;app.update();assert_eq!(app.world().get::<Node>(entity).unwrap().display,Display::None);
 }
}
''',encoding='utf-8')
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8');s='mod match_results_ui;\n'+s
s=s.replace('                shop_ui::setup,','                shop_ui::setup,\n                match_results_ui::setup,',1)
s=s.replace('        .add_systems(Update, actor_fow::bind','        .add_systems(Update, match_results_ui::update.after(receive).before(render_probe::capture))\n        .add_systems(Update, actor_fow::bind',1)
s=s.replace('if shop.focused || connection.id.is_none() {','if shop.focused || connection.id.is_none() || state.snapshot.as_ref().is_some_and(|s|s.winner.is_some()) {',1)
s=s.replace('fn camera(\n','fn camera(\n    state: Res<Match>,\n',1)
s=s.replace('    for event in wheel.read() {\n        if let Err(error)=native_camera.scroll','    let locked=state.snapshot.as_ref().is_some_and(|s|s.winner.is_some());\n    for event in wheel.read() {\n        if locked {continue;}\n        if let Err(error)=native_camera.scroll',1)
for key in ['ArrowUp','ArrowDown','ArrowLeft','ArrowRight']:s=s.replace(f'if keys.pressed(KeyCode::{key}) {{',f'if !locked && keys.pressed(KeyCode::{key}) {{',1)
s=s.replace('app.add_message::<MouseWheel>().insert_resource(clock)','app.init_resource::<Match>().add_message::<MouseWheel>().insert_resource(clock)',1)
p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/shop_ui.rs';s=p.read_text(encoding='utf-8');needle=') {\n    if keys.just_pressed(KeyCode::Escape) {';assert needle in s
s=s.replace(needle,') {\n    if state.snapshot.as_ref().is_some_and(|s|s.winner.is_some()) {\n        f.open=false;f.focused=false;\n        for (mut panel, _, _) in &mut panels {panel.display=Display::None;}\n        events.clear();return;\n    }\n    if keys.just_pressed(KeyCode::Escape) {',1);p.write_text(s,encoding='utf-8')
print('client terminal results and input gates implemented')
