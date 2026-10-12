"""Build a scratch client proposal from verified current source; no compiler."""
from pathlib import Path
import hashlib,json
ROOT=Path(__file__).resolve().parent
SOURCE=Path('E:/OpenLeague/crates/client/src/native_effect_clock.rs')
raw=SOURCE.read_bytes();text=raw.decode('utf-8').replace('\r\n','\n')
snap=ROOT/'source_snapshots';snap.mkdir(exist_ok=True)
(snap/SOURCE.name).write_bytes(raw)
def replace(old,new):
    global text
    assert text.count(old)==1,(old[:80],text.count(old))
    text=text.replace(old,new)
replace('//! Native clock arithmetic with a Windows QPC producer.',
        '//! Native clock arithmetic fed by the application-owned canonical process clock.\n//! Scratch proposal: requires the qualified core clock handle, no local QPC/epoch.')
replace('use std::collections::BTreeMap;', '''use std::collections::BTreeMap;
use openleague_core::audio_native_process_clock::RawSample;
#[cfg(windows)]
type CanonicalClock = openleague_core::audio_replay_windows_transport::ClockHandle<
    openleague_core::audio_replay_transport_startup::windows::WindowsNetwork>;''')
start=text.index('#[derive(Resource)]')
end=text.index('impl Default for EffectClock',start)
text=text[:start]+'''#[derive(Resource)]
pub struct EffectClock {
 control:PauseControl, adjustment:f32, last_ordinal:u64, pending:BTreeMap<u64,Directive>,
 game:GameClock, start:Option<f32>, pub now:f64, failed:bool,
 #[cfg(windows)] source:Option<CanonicalClock>,
}
fn same_origin(a:&RawSample,b:&RawSample)->Result<(),&'static str>{
 if a.origin!=b.origin || a.frequency!=b.frequency {return Err("canonical process clock changed during sampling");}
 Ok(())
}
'''+text[end:]
replace('fn default()->Self{Self{control:PauseControl::default(),adjustment:0.,last_ordinal:0,pending:BTreeMap::new(),game:GameClock::default(),origin:0,frequency:0,start:None,now:0.,failed:false}}',
'''fn default()->Self{Self{control:PauseControl::default(),adjustment:0.,last_ordinal:0,pending:BTreeMap::new(),game:GameClock::default(),start:None,now:0.,failed:false,#[cfg(windows)] source:None}}''')
replace('impl EffectClock {\n', '''impl EffectClock {
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
''')
replace('''     adjustment=control.adjustment_for_remaining(1800.,remaining_seconds as f32,counter()?,self.origin,self.frequency)?;
     control.request_pause(&mut game,1800.,adjustment,u32::from(marker),[counter()?,counter()?],self.origin,self.frequency)?;''', '''     let budget=self.raw_clock_sample()?;
     adjustment=control.adjustment_for_remaining(1800.,remaining_seconds as f32,budget.counter,budget.origin,budget.frequency)?;
     let gate=self.raw_clock_sample()?;same_origin(&budget,&gate)?;
     let pause=self.raw_clock_sample()?;same_origin(&budget,&pause)?;
     control.request_pause(&mut game,1800.,adjustment,u32::from(marker),[gate.counter,pause.counter],budget.origin,budget.frequency)?;''')
replace('''    Directive::Resume{actor:_,delayed}=>{control.request_resume(&mut game,delayed.then_some(5.),[counter()?,counter()?],self.origin,self.frequency)?;}''', '''    Directive::Resume{actor:_,delayed}=>{
     let accounting=self.raw_clock_sample()?;let drift=self.raw_clock_sample()?;same_origin(&accounting,&drift)?;
     control.request_resume(&mut game,delayed.then_some(5.),[accounting.counter,drift.counter],accounting.origin,accounting.frequency)?;
    }''')
start=text.index('fn advance(mut clock:ResMut<EffectClock>){')
end=text.index('fn publish_animation_delta',start)
text=text[:start]+'''fn advance(mut clock:ResMut<EffectClock>){
 if clock.failed{return;}
 if let Err(error)=clock.advance_frame(){clock.failed=true;error!("Native effect clock stopped: {error}");}
}
'''+text[end:]
replace(''' fn initialized()->EffectClock{let mut clock=EffectClock::default();clock.frequency=frequency().unwrap();clock.origin=counter().unwrap();clock.start=Some(0.);clock}''', ''' fn initialized()->(openleague_core::audio_replay_windows_application::Application,EffectClock){
  let owner=openleague_core::audio_replay_windows_application::Application::new().unwrap();
  let mut clock=EffectClock::with_process_clock(owner.transport().unwrap().clock_handle().unwrap());
  clock.advance_frame().unwrap();(owner,clock)
 }''')
assert text.count('let mut clock=initialized();')==2
text=text.replace('let mut clock=initialized();','let (_owner,mut clock)=initialized();')
replace('''  let mut app=App::new();app.add_plugins(super::Plugin);app.update();app.update();''', '''  let mut app=App::new();install_test_clock(&mut app);app.add_plugins(super::Plugin);app.update();app.update();''')
text+='''
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
'''
assert 'fn counter()' not in text and 'fn frequency()' not in text
assert 'self.origin' not in text and 'self.frequency' not in text
assert 'Instant::' not in text and 'QueryPerformance' not in text
(ROOT/'native_effect_clock.rs').write_text(text,encoding='utf-8')
# Small known integration points, staged as reviewable excerpts rather than
# overwriting the root's concurrently edited production main/transport files.
(ROOT/'client_attach_excerpt.rs').write_text('''// Inside the existing attach_native_replay_runtime, after replay.0.attach(...)
// and before app.insert_non_send_resource(runtime):
let process_clock = runtime.transport()?.clock_handle()?;
app.insert_resource(native_effect_clock::EffectClock::with_process_clock(process_clock));
// Existing Application remains the only owner. Plugin::init_resource preserves
// this inserted EffectClock and never creates an Application.
''',encoding='utf-8')
(ROOT/'transport_module_excerpt.rs').write_text('''// In audio_replay_windows_transport.rs:
#[path = "audio_replay_windows_clock.rs"]
mod process_clock;
pub use process_clock::ClockHandle;
// In Backend::loading_clock_f32_bits, replace the explicit unconnected body
// only when the actual once dependency is qualified:
// self.native_clock_f32_bits()
// Existing source error must remain until that prerequisite is satisfied.
''',encoding='utf-8')
(ROOT/'client_stage_provenance.json').write_text(json.dumps(dict(source=str(SOURCE),source_sha256=hashlib.sha256(raw).hexdigest(),staged_sha256=hashlib.sha256((ROOT/'native_effect_clock.rs').read_bytes()).hexdigest(),compiled=False,tests_run=False,production_integrated=False),indent=2)+'\n')
print(json.dumps(dict(staged=True,rust_compiled=False,source_sha256=hashlib.sha256(raw).hexdigest(),staged_sha256=hashlib.sha256((ROOT/'native_effect_clock.rs').read_bytes()).hexdigest())))
