//! Native clock arithmetic with a Windows QPC producer.
//! Bevy host adaptation: consecutive First boundaries delimit a complete frame,
//! including its pacing wait. Native58D550/586350 instead bracket frame work and
//! its limiter. This scheduling mapping still requires live fidelity validation.
use bevy::prelude::*;
use openleague_core::native_game_clock::{GameClock,PauseControl,frame_delta,wall_sample};
use openleague_core::native_pause_packet::{Directive,decode};
use std::collections::BTreeMap;
#[derive(Resource)]
pub struct EffectClock { control:PauseControl, adjustment:f32, last_ordinal:u64, pending:BTreeMap<u64,Directive>, game:GameClock, origin:u64, frequency:u64, start:Option<f32>, pub now:f64, failed:bool }
#[cfg(windows)]
fn counter()->Result<u64,&'static str>{
 #[link(name="Kernel32")] unsafe extern "system" {fn QueryPerformanceCounter(value:*mut i64)->i32;}
 let mut value=0i64;if unsafe{QueryPerformanceCounter(&mut value)}==0{return Err("QueryPerformanceCounter failed");}Ok(value as u64)
}
#[cfg(windows)]
fn frequency()->Result<u64,&'static str>{
 #[link(name="Kernel32")] unsafe extern "system" {fn QueryPerformanceFrequency(value:*mut i64)->i32;}
 let mut value=0i64;if unsafe{QueryPerformanceFrequency(&mut value)}==0 || value<=0{return Err("QueryPerformanceFrequency failed");}Ok(value as u64)
}
#[cfg(not(windows))]
fn counter()->Result<u64,&'static str>{Err("native effect clock platform not qualified")}
#[cfg(not(windows))]
fn frequency()->Result<u64,&'static str>{Err("native effect clock platform not qualified")}
impl Default for EffectClock {
 fn default()->Self{Self{control:PauseControl::default(),adjustment:0.,last_ordinal:0,pending:BTreeMap::new(),game:GameClock::default(),origin:0,frequency:0,start:None,now:0.,failed:false}}
}
impl EffectClock {
 pub fn diagnostic(&self)->serde_json::Value{serde_json::json!({"time":self.now,"time_bits":self.game.time.to_bits(),"delta_bits":self.game.delta.to_bits(),"paused":self.control.paused,"resume_pending":self.control.resume_pending,"remaining":self.control.remaining,"ordinal":self.last_ordinal,"failed":self.failed})}
 pub fn paused(&self)->bool{self.control.paused}
 pub fn acknowledged_ordinal(&self)->u64{self.last_ordinal}
 /// A new Welcome identity discards queued directives and a previous pause.
 /// Keep process-local time monotonic; consumers already retire session effects.
 pub fn reset_session(&mut self){self.control=PauseControl::default();self.adjustment=0.;self.last_ordinal=0;self.pending.clear();self.game.scale=1.;}
 /// Local ordered transport adapter. Native packets do not contain this ordinal.
 /// A missing ordinal holds later directives; sender retransmission is required.
 pub fn receive(&mut self,ordinal:u64,opcode:u16,payload:&[u8])->Result<(),&'static str>{
  if self.failed || self.start.is_none(){return Err("effect clock unavailable");}
  let directive=decode(opcode,payload)?;
  if ordinal==0{return Err("clock ordinal must start at one");}
  if ordinal<=self.last_ordinal{return Ok(());}
  if ordinal-self.last_ordinal>64{return Err("clock delivery gap exceeds window");}
  if let Some(previous)=self.pending.get(&ordinal){if previous!=&directive{return Err("conflicting clock directive");}}
  self.pending.insert(ordinal,directive);
  while let Some(directive)=self.pending.get(&(self.last_ordinal+1)).copied(){
   let mut control=self.control;let mut game=self.game;let mut adjustment=self.adjustment;
   // Constructor defaults recovered from TournamentPause. Effective override
   // propagation and mode authorization still belong to server integration.
   match directive {
    Directive::Pause{actor:_,remaining_seconds,marker}=>{
     adjustment=control.adjustment_for_remaining(1800.,remaining_seconds as f32,counter()?,self.origin,self.frequency)?;
     control.request_pause(&mut game,1800.,adjustment,u32::from(marker),[counter()?,counter()?],self.origin,self.frequency)?;
    }
    Directive::Resume{actor:_,delayed}=>{control.request_resume(&mut game,delayed.then_some(5.),[counter()?,counter()?],self.origin,self.frequency)?;}
   }
   self.control=control;self.game=game;self.adjustment=adjustment;
   self.last_ordinal+=1;self.pending.remove(&self.last_ordinal);
   warn!("NATIVE_CLOCK_CONTROL ordinal={} directive={:?} paused={} remaining={}",self.last_ordinal,directive,self.control.paused,self.control.remaining);
  }
  Ok(())
 }
}
fn advance(mut clock:ResMut<EffectClock>){
 if clock.failed{return;}
 let result=(||->Result<(),&'static str>{
  let current=counter()?;
  if clock.start.is_none(){clock.frequency=frequency()?;clock.origin=current;clock.start=Some(0.);return Ok(());}
  let delta=frame_delta(current,clock.origin,clock.frequency,clock.start.unwrap())?;
  let next_start=wall_sample(current,clock.origin,clock.frequency)?;
  let mut game=clock.game;let mut control=clock.control;control.advance(&mut game,delta,[counter()?,counter()?],clock.origin,clock.frequency)?;
  let now=openleague_core::native_troy_clock::Clock{origin:0.,scale:1.,offset:0.}.sample(Some(game.sample()))? as f64;
  clock.game=game;clock.control=control;clock.start=Some(next_start);clock.now=now;Ok(())
 })();
 if let Err(error)=result{clock.failed=true;error!("Native effect clock stopped: {error}");}
}
fn publish_animation_delta(clock:Res<EffectClock>,mut delta:ResMut<bevy::animation::AnimationDelta>){
 delta.0=if clock.failed {0.} else {clock.game.delta};
}
pub struct Plugin;
impl bevy::app::Plugin for Plugin {
 fn build(&self,app:&mut App){app.init_resource::<EffectClock>().init_resource::<bevy::animation::AnimationDelta>().add_systems(First,(advance,publish_animation_delta).chain());}
}

#[cfg(all(test,windows))]
mod tests {
 use super::*;
 fn initialized()->EffectClock{let mut clock=EffectClock::default();clock.frequency=frequency().unwrap();clock.origin=counter().unwrap();clock.start=Some(0.);clock}
 fn pause()->Vec<u8>{let mut p=vec![0;14];p[9..13].copy_from_slice(&30i32.to_le_bytes());p[13]=1;p}
 #[test] fn reordered_and_duplicate_messages_preserve_pause_then_resume(){
  let mut clock=initialized();let resume=vec![0;10];
  clock.receive(3,0x0a,&resume).unwrap();assert!(!clock.control.paused);
  assert!(clock.receive(3,0xa1,&pause()).is_err());
  clock.receive(1,0xa1,&pause()).unwrap();assert!(clock.control.paused);assert_eq!(clock.game.scale,0.);
  clock.receive(1,0xa1,&pause()).unwrap();assert!(clock.control.paused);
  clock.receive(2,0xa1,&pause()).unwrap();assert!(!clock.control.paused);assert_eq!(clock.game.scale,1.);assert_eq!(clock.last_ordinal,3);assert!(clock.pending.is_empty());
  clock.receive(3,0xa1,&pause()).unwrap();assert!(!clock.control.paused);
 }
 #[test] fn malformed_gaps_and_session_reset_do_not_leave_old_pause(){
  let mut clock=initialized();assert!(clock.receive(1,0xa1,&[0;13]).is_err());assert_eq!(clock.last_ordinal,0);
  assert!(clock.receive(0,0xa1,&pause()).is_err());assert!(clock.receive(65,0xa1,&pause()).is_err());assert!(clock.pending.is_empty());
  clock.receive(1,0xa1,&pause()).unwrap();clock.receive(3,0xa1,&pause()).unwrap();assert!(clock.control.paused);
  clock.reset_session();assert!(!clock.control.paused);assert_eq!(clock.game.scale,1.);assert_eq!(clock.last_ordinal,0);assert!(clock.pending.is_empty());
  clock.receive(1,0xa1,&pause()).unwrap();assert!(clock.control.paused);
 }
 #[test] fn received_pause_freezes_effect_time_across_real_frame_updates(){
  let mut app=App::new();app.add_plugins(super::Plugin);app.update();app.update();
  let before=app.world().resource::<EffectClock>().now;
  app.world_mut().resource_mut::<EffectClock>().receive(1,0xa1,&pause()).unwrap();
  for _ in 0..12{app.update();assert_eq!(app.world().resource::<EffectClock>().now,before);}
  app.world_mut().resource_mut::<EffectClock>().receive(2,0x0a,&[0;10]).unwrap();app.update();
  assert!(app.world().resource::<EffectClock>().now>before);
 }

}

#[cfg(test)]
mod animation_delta_tests {
 use super::*;
 use bevy::animation::{AnimationDelta,advance_animations,transition::{advance_transitions,expire_completed_transitions}};
 use std::time::Duration;
 #[test]
 fn scoped_animation_delta_freezes_clips_and_fades_then_expires_without_freezing_wall_time(){
  let mut app=App::new();
  app.add_plugins(bevy::app::TaskPoolPlugin::default());
  app.init_resource::<Time>().init_resource::<Assets<AnimationClip>>().init_resource::<Assets<AnimationGraph>>().init_resource::<AnimationDelta>();
  app.add_systems(Update,(advance_transitions,advance_animations,expire_completed_transitions).chain());
  let mut clip=AnimationClip::default();clip.set_duration(100.);
  let handle=app.world_mut().resource_mut::<Assets<AnimationClip>>().add(clip);
  let mut graph=AnimationGraph::new();let a=graph.add_clip(handle.clone(),1.,graph.root);let b=graph.add_clip(handle,1.,graph.root);
  let graph=app.world_mut().resource_mut::<Assets<AnimationGraph>>().add(graph);
  let mut player=AnimationPlayer::default();let mut transitions=AnimationTransitions::new();
  transitions.play(&mut player,a,Duration::ZERO).repeat();
  transitions.play(&mut player,b,Duration::from_secs(1)).repeat();
  let entity=app.world_mut().spawn((player,transitions,AnimationGraphHandle(graph))).id();
  let step=|app:&mut App,delta:f32|{app.world_mut().resource_mut::<Time>().advance_by(Duration::from_secs(2));app.world_mut().resource_mut::<AnimationDelta>().0=delta;app.update();};
  step(&mut app,0.25);
  for _ in 0..3 {
   step(&mut app,0.);
   let player=app.world().get::<AnimationPlayer>(entity).unwrap();
   for (clip,weight) in [(a,0.75),(b,0.25)] {let active=player.animation(clip).unwrap();assert_eq!(active.seek_time(),0.25);assert_eq!(active.elapsed(),0.25);assert_eq!(active.weight(),weight);}
  }
  assert_eq!(app.world().resource::<Time>().elapsed_secs(),8.);
  step(&mut app,0.25);
  {let player=app.world().get::<AnimationPlayer>(entity).unwrap();assert_eq!(player.animation(a).unwrap().weight(),0.5);assert_eq!(player.animation(b).unwrap().seek_time(),0.5);}
  step(&mut app,0.5);
  let player=app.world().get::<AnimationPlayer>(entity).unwrap();assert!(player.animation(a).is_none());assert_eq!(player.animation(b).unwrap().weight(),1.);assert_eq!(player.animation(b).unwrap().seek_time(),1.);
 }
 #[test]
 fn publishes_native_delta_and_stops_on_clock_failure(){
  let mut app=App::new();app.init_resource::<EffectClock>().init_resource::<AnimationDelta>().add_systems(Update,publish_animation_delta);
  app.world_mut().resource_mut::<EffectClock>().game.delta=0.125;app.update();assert_eq!(app.world().resource::<AnimationDelta>().0,0.125);
  app.world_mut().resource_mut::<EffectClock>().game.delta=0.;app.update();assert_eq!(app.world().resource::<AnimationDelta>().0,0.);
  app.world_mut().resource_mut::<EffectClock>().game.delta=0.5;app.world_mut().resource_mut::<EffectClock>().failed=true;app.update();assert_eq!(app.world().resource::<AnimationDelta>().0,0.);
 }
}
