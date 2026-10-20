//! Native clock arithmetic fed by the application-owned canonical process clock.
//! Uses the canonical core clock handle; it owns no local QPC epoch.
//! Bevy host adaptation: consecutive First boundaries delimit a complete frame,
//! including its pacing wait. Native58D550/586350 instead bracket frame work and
//! its limiter. This scheduling mapping still requires live fidelity validation.
use bevy::prelude::*;
use openleague_core::native_game_clock::{GameClock,PauseControl,frame_delta,wall_sample};
use openleague_core::native_pause_packet::{Directive,decode};
use std::collections::BTreeMap;
use openleague_core::audio_native_process_clock::RawSample;
#[cfg(windows)]
type CanonicalClock = openleague_core::audio_replay_windows_transport::ClockHandle<
    openleague_core::audio_replay_transport_startup::windows::WindowsNetwork>;
#[derive(Resource)]
pub struct EffectClock {
 control:PauseControl, adjustment:f32, last_ordinal:u64, pending:BTreeMap<u64,Directive>,
 game:GameClock, start:Option<f32>, pub now:f64, failed:bool,
 #[cfg(windows)] source:Option<CanonicalClock>,
}
fn same_origin(a:&RawSample,b:&RawSample)->Result<(),&'static str>{
 if a.origin!=b.origin || a.frequency!=b.frequency {return Err("canonical process clock changed during sampling");}
 Ok(())
}
impl Default for EffectClock {
 fn default()->Self{Self{control:PauseControl::default(),adjustment:0.,last_ordinal:0,pending:BTreeMap::new(),game:GameClock::default(),start:None,now:0.,failed:false,#[cfg(windows)] source:None}}
}
impl EffectClock {
 #[cfg(windows)]
 pub fn with_process_clock(source:CanonicalClock)->Self{Self{source:Some(source),..Self::default()}}
 fn raw_clock_sample(&self)->Result<RawSample,&'static str>{
  #[cfg(windows)] {
   self.source.as_ref().ok_or("canonical process clock is not attached")?.raw_clock_sample()
    .map_err(|e|{error!("Canonical process clock failed: {e}");"canonical process clock sample failed"})
  }
  #[cfg(not(windows))] {Err("canonical process clock platform is not qualified")}
 }
 fn advance_frame(&mut self)->Result<(),&'static str>{
  let sample=self.raw_clock_sample()?;
  if self.start.is_none(){self.start=Some(wall_sample(sample.counter,sample.origin,sample.frequency)?);return Ok(());}
  let delta=frame_delta(sample.counter,sample.origin,sample.frequency,self.start.unwrap())?;
  let next_start=wall_sample(sample.counter,sample.origin,sample.frequency)?;
  let accounting=self.raw_clock_sample()?;same_origin(&sample,&accounting)?;
  let drift=self.raw_clock_sample()?;same_origin(&sample,&drift)?;
  let mut game=self.game;let mut control=self.control;
  control.advance(&mut game,delta,[accounting.counter,drift.counter],sample.origin,sample.frequency)?;
  let now=openleague_core::native_troy_clock::Clock{origin:0.,scale:1.,offset:0.}.sample(Some(game.sample()))? as f64;
  self.game=game;self.control=control;self.start=Some(next_start);self.now=now;Ok(())
 }
 /// Presentation must not treat the frozen last value of a failed clock as a live sample.
 pub fn presentation_ready(&self)->bool {
  #[cfg(windows)] {self.source.is_some() && self.start.is_some() && !self.failed}
  #[cfg(not(windows))] {false}
 }
 pub fn diagnostic(&self)->serde_json::Value{serde_json::json!({"time":self.now,"time_bits":self.game.time.to_bits(),"delta_bits":self.game.delta.to_bits(),"paused":self.control.paused,"resume_pending":self.control.resume_pending,"remaining":self.control.remaining,"ordinal":self.last_ordinal,"failed":self.failed})}
 pub fn paused(&self)->bool{self.control.paused}
 pub fn acknowledged_ordinal(&self)->u64{self.last_ordinal}
 /// Ordinary HUD observes applied server-clock state without changing the clock.
 pub(crate) fn pause_ui_status(&self)->(u64,bool,bool){
  (self.last_ordinal,self.control.paused,self.control.resume_pending)
 }
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
     let budget=self.raw_clock_sample()?;
     adjustment=control.adjustment_for_remaining(1800.,remaining_seconds as f32,budget.counter,budget.origin,budget.frequency)?;
     let gate=self.raw_clock_sample()?;same_origin(&budget,&gate)?;
     let pause=self.raw_clock_sample()?;same_origin(&budget,&pause)?;
     control.request_pause(&mut game,1800.,adjustment,u32::from(marker),[gate.counter,pause.counter],budget.origin,budget.frequency)?;
    }
    Directive::Resume{actor:_,delayed}=>{
     let accounting=self.raw_clock_sample()?;let drift=self.raw_clock_sample()?;same_origin(&accounting,&drift)?;
     control.request_resume(&mut game,delayed.then_some(5.),[accounting.counter,drift.counter],accounting.origin,accounting.frequency)?;
    }
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
 if let Err(error)=clock.advance_frame(){clock.failed=true;error!("Native effect clock stopped: {error}");}
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
 fn initialized()->(openleague_core::audio_replay_windows_application::Application,EffectClock){
  let owner=openleague_core::audio_replay_windows_application::Application::new().unwrap();
  let mut clock=EffectClock::with_process_clock(owner.transport().unwrap().clock_handle().unwrap());
  clock.advance_frame().unwrap();(owner,clock)
 }
 fn pause()->Vec<u8>{let mut p=vec![0;14];p[9..13].copy_from_slice(&30i32.to_le_bytes());p[13]=1;p}
 #[test] fn presentation_ready_rejects_unattached_uninitialized_and_failed_clock(){
  assert!(!EffectClock::default().presentation_ready());
  let (_owner,mut clock)=initialized();assert!(clock.presentation_ready());
  let held=clock.now;clock.failed=true;assert!(!clock.presentation_ready());assert_eq!(clock.now,held);
  clock.failed=false;clock.start=None;assert!(!clock.presentation_ready());
 }
 #[test] fn reordered_and_duplicate_messages_preserve_pause_then_resume(){
  let (_owner,mut clock)=initialized();let resume=vec![0;10];
  clock.receive(3,0x0a,&resume).unwrap();assert!(!clock.control.paused);
  assert!(clock.receive(3,0xa1,&pause()).is_err());
  clock.receive(1,0xa1,&pause()).unwrap();assert!(clock.control.paused);assert_eq!(clock.game.scale,0.);
  clock.receive(1,0xa1,&pause()).unwrap();assert!(clock.control.paused);
  clock.receive(2,0xa1,&pause()).unwrap();assert!(!clock.control.paused);assert_eq!(clock.game.scale,1.);assert_eq!(clock.last_ordinal,3);assert!(clock.pending.is_empty());
  clock.receive(3,0xa1,&pause()).unwrap();assert!(!clock.control.paused);
 }
 #[test] fn malformed_gaps_and_session_reset_do_not_leave_old_pause(){
  let (_owner,mut clock)=initialized();assert!(clock.receive(1,0xa1,&[0;13]).is_err());assert_eq!(clock.last_ordinal,0);
  assert!(clock.receive(0,0xa1,&pause()).is_err());assert!(clock.receive(65,0xa1,&pause()).is_err());assert!(clock.pending.is_empty());
  clock.receive(1,0xa1,&pause()).unwrap();clock.receive(3,0xa1,&pause()).unwrap();assert!(clock.control.paused);
  clock.reset_session();assert!(!clock.control.paused);assert_eq!(clock.game.scale,1.);assert_eq!(clock.last_ordinal,0);assert!(clock.pending.is_empty());
  clock.receive(1,0xa1,&pause()).unwrap();assert!(clock.control.paused);
 }
 #[test] fn received_pause_freezes_effect_time_across_real_frame_updates(){
  let mut app=App::new();install_test_clock(&mut app);app.add_plugins(super::Plugin);app.update();app.update();
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

// Tests install the same explicit owner as the normal executable. There is no
// production fallback that silently constructs a second application or epoch.
#[cfg(all(test,windows))]
pub(crate) fn install_test_clock(app:&mut App){
 let owner=openleague_core::audio_replay_windows_application::Application::new().unwrap();
 let clock=EffectClock::with_process_clock(owner.transport().unwrap().clock_handle().unwrap());
 app.insert_resource(clock);app.insert_non_send_resource(owner);
}

#[cfg(all(test,windows))]
mod shared_clock_tests {
 use super::*;
 #[test]
 fn effects_pause_and_scale_do_not_modify_canonical_loading_time_and_closed_handles_fail(){
  let mut owner=openleague_core::audio_replay_windows_application::Application::new().unwrap();
  let source=owner.transport().unwrap().clock_handle().unwrap();
  let mut effect=EffectClock::with_process_clock(source.clone());effect.advance_frame().unwrap();effect.advance_frame().unwrap();
  let first=source.raw_clock_sample().unwrap();let game_before=effect.now;
  let mut packet=vec![0;14];packet[9..13].copy_from_slice(&30i32.to_le_bytes());packet[13]=1;
  effect.receive(1,0xa1,&packet).unwrap();assert!(effect.paused());
  for _ in 0..8{effect.advance_frame().unwrap();assert_eq!(effect.now,game_before);}
  let second=source.raw_clock_sample().unwrap();assert!(second.counter>first.counter);
  assert_eq!((first.origin,first.frequency),(second.origin,second.frequency));
  let raw_before_scale=source.raw_clock_sample().unwrap();effect.control.set_scale(&mut effect.game,2.).unwrap();
  effect.receive(2,0x0a,&[0;10]).unwrap();effect.advance_frame().unwrap();assert!(effect.now>game_before);
  let after=source.raw_clock_sample().unwrap();assert_eq!((first.origin,first.frequency),(after.origin,after.frequency));assert!(after.counter>=raw_before_scale.counter);
  effect.reset_session();let reset=source.raw_clock_sample().unwrap();assert_eq!((first.origin,first.frequency),(reset.origin,reset.frequency));
  owner.close().unwrap();assert!(source.raw_clock_sample().is_err());assert!(effect.advance_frame().is_err());
 }
 #[test]
 fn effect_first_frame_does_not_reset_an_origin_previously_used_by_loading(){
  let owner=openleague_core::audio_replay_windows_application::Application::new().unwrap();
  let source=owner.transport().unwrap().clock_handle().unwrap();
  let loading=source.raw_clock_sample().unwrap();
  let mut effect=EffectClock::with_process_clock(source.clone());effect.advance_frame().unwrap();
  let after=source.raw_clock_sample().unwrap();assert_eq!((loading.origin,loading.frequency),(after.origin,after.frequency));
  let lo=wall_sample(loading.counter,loading.origin,loading.frequency).unwrap();
  let hi=wall_sample(after.counter,after.origin,after.frequency).unwrap();
  assert!(effect.start.unwrap()>=lo && effect.start.unwrap()<=hi);assert_eq!(effect.now,0.);
 }
}
