from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/client/src/endgame_timeline.rs';assert not p.exists()
p.write_text('''//! Native default phase deadlines. Camera/audio/skin consumers remain separate work.
use bevy::prelude::*;
use crate::Match;
#[derive(Debug)] pub struct Schedule {pub pan:f64,pub skin:f64,pub main_sfx_delay:f64,pub main_sfx_fade:f64,pub minion_fade:f64,pub scoreboard_delay:f64}
impl Schedule {pub fn scoreboard(&self)->f64{self.skin+self.scoreboard_delay}}
pub fn schedule()->&'static Schedule {
 static VALUE:std::sync::OnceLock<Schedule>=std::sync::OnceLock::new();
 VALUE.get_or_init(||{
  let timing:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_endgame_default_timing.json")).expect("native getter qualification");
  let lua:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/endgame_lua_source_audit.json")).expect("native Lua audit");
  let getter=|name:&str|timing["cases"].as_array().unwrap().iter().find(|r|r["name"]==name).unwrap()["value"].as_f64().unwrap();
  let literal=|name:&str|lua["initialization"]["globals"][name].as_f64().expect("native phase literal");
  let s=Schedule{pan:getter("pan"),skin:getter("nexus_skin"),main_sfx_delay:literal("EOG_MAIN_SFX_FADE_DELAY_TIME"),main_sfx_fade:literal("EOG_MAIN_SFX_FADE_DURATION"),minion_fade:literal("EOG_MINION_FADE_TIME"),scoreboard_delay:literal("EOG_SCOREBOARD_PHASE_DELAY_TIME")};
  assert!([s.pan,s.skin,s.main_sfx_delay,s.main_sfx_fade,s.minion_fade,s.scoreboard_delay].iter().all(|v|v.is_finite()&&*v>=0.));s
 })
}
#[derive(Resource,Default,Debug)] pub struct Clock {key:Option<(u64,u64)>,started:Option<f64>}
impl Clock {
 fn observe(&mut self,key:Option<(u64,u64)>,now:f64){if self.key!=key {self.key=key;self.started=key.map(|_|now);}}
 pub fn age(&self,now:f64)->Option<f64>{self.started.map(|start|(now-start).max(0.))}
 pub fn scoreboard_due(&self,now:f64)->bool{self.age(now).is_some_and(|age|age>=schedule().scoreboard())}
}
pub fn update(state:Res<Match>,time:Res<Time>,mut clock:ResMut<Clock>){let key=state.snapshot.as_ref().and_then(|s|s.result.as_ref()).map(|r|(r.session,r.ended_tick));clock.observe(key,time.elapsed_secs_f64());}
#[cfg(test)] mod tests {
 use super::*;
 #[test] fn phase_boundary_uses_native_skin_time_plus_original_scoreboard_timer(){
  let mut c=Clock::default();assert!(!c.scoreboard_due(100.));c.observe(Some((42,123)),100.);assert!(!c.scoreboard_due(105.499999));assert!(c.scoreboard_due(105.5));c.observe(Some((42,123)),106.);assert_eq!(c.age(106.),Some(6.));
 }
 #[test] fn different_match_and_absent_result_reset_the_local_phase_clock(){let mut c=Clock::default();c.observe(Some((1,3)),10.);assert!(c.scoreboard_due(20.));c.observe(None,20.);assert_eq!(c.age(20.),None);c.observe(Some((2,3)),30.);assert!(!c.scoreboard_due(30.));assert!(c.scoreboard_due(35.5));}
}
''',encoding='utf-8')
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8');s='mod endgame_timeline;\n'+s;s=s.replace('.init_resource::<native_endgame_ui::View>()','.init_resource::<native_endgame_ui::View>()\n        .init_resource::<endgame_timeline::Clock>()',1);s=s.replace('.add_systems(Update, native_endgame_ui::update.after(receive)','.add_systems(Update, endgame_timeline::update.after(receive).before(native_endgame_ui::update))\n        .add_systems(Update, native_endgame_ui::update.after(receive)',1);p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/native_endgame_ui.rs';s=p.read_text(encoding='utf-8');s=s.replace('pub fn update(state:Res<Match>,','pub fn update(time:Res<Time>,clock:Res<crate::endgame_timeline::Clock>,state:Res<Match>,',1);s=s.replace('let visible=victory.is_some()&&!view.dismissed;','let visible=victory.is_some()&&!view.dismissed&&clock.scoreboard_due(time.elapsed_secs_f64());',1)
s=s.replace('.init_resource::<View>()','.init_resource::<View>().init_resource::<crate::endgame_timeline::Clock>()',1).replace('.add_systems(Update,update);','.add_systems(Update,(crate::endgame_timeline::update,update).chain());',1)
s=s.replace('let (mut app,root,image,button)=app(0);app.update();','let (mut app,root,image,button)=app(0);app.update();app.insert_resource(bevy::time::TimeUpdateStrategy::ManualDuration(std::time::Duration::from_secs(6)));app.update();',1)
# Virtual Time normally caps delta at250ms. These deterministic tests use the actual injected time source.
s=s.replace('let root=app.world_mut().spawn((Splash,Node::default())).id();','app.world_mut().resource_mut::<Time<Virtual>>().set_max_delta(std::time::Duration::from_secs(10));\n  let root=app.world_mut().spawn((Splash,Node::default())).id();',1)
idx=s.rfind('\n}');s=s[:idx]+'''
 #[test] fn actual_ui_stays_hidden_and_ignores_continue_before_native_phase_deadline(){
  let (mut app,root,_,button)=app(0);app.update();assert_eq!(app.world().get::<Node>(root).unwrap().display,Display::None);
  *app.world_mut().get_mut::<Interaction>(button).unwrap()=Interaction::Pressed;app.update();assert!(!app.world().resource::<View>().armed);
  *app.world_mut().get_mut::<Interaction>(button).unwrap()=Interaction::None;
  app.insert_resource(bevy::time::TimeUpdateStrategy::ManualDuration(std::time::Duration::from_secs(1)));
  for _ in 0..5 {app.update();assert_eq!(app.world().get::<Node>(root).unwrap().display,Display::None);}
  app.update();assert_eq!(app.world().get::<Node>(root).unwrap().display,Display::Flex);
 }
'''+s[idx:];p.write_text(s,encoding='utf-8')
print('native default scoreboard phase deadline integrated; other ceremony consumers remain open')
