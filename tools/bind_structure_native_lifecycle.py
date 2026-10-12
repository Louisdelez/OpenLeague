from pathlib import Path
import json,shutil,datetime
r=Path('E:/OpenLeague');staging=Path('E:/mapslol3v3')
native=json.loads((staging/'structure_native_lifecycle_contract.json').read_text());assert native['passed'] and len(native['states'])==48
native['allocator_boundary'].pop('bytes_per_call');native['allocator_boundary']['requested_sizes']=[8,16]
native['limits'].append('Isolated FS:[0] exception-chain head supplied for native weak-reference constructor SEH; no exception path was taken.')
native['native_addresses_note']='Includes allocator boundary entry intercepted by adapter; remaining visited instructions execute original mapped bytes.'
(r/'data/4.20/structure_native_lifecycle_contract.json').write_text(json.dumps(native,indent=2)+'\n')
p=r/'data/4.20/structure_clip_playback.json';d=json.loads(p.read_text());assert all('repeat' not in c for roles in d['models'].values() for c in roles.values())
for roles in d['models'].values():
 for c in roles.values():
  source=next(s for s in native['states'] if s['model']==c['native_model'] and s['state']==c['native_state'])
  c.update(repeat=source['loop'],serialized_flags=source['serialized_flags'])
d['updated_utc']=datetime.datetime.now(datetime.timezone.utc).isoformat();d['lifecycle_contract']='data/4.20/structure_native_lifecycle_contract.json'
d['limits'].append('Repeat policy bound from executed native simple-node getter; stop requests, continuation callers, general blends/state transitions, events and native pose interpolation remain incomplete.')
p.write_text(json.dumps(d,indent=2)+'\n')
p=r/'crates/client/src/structure_animation_clock.rs';s=p.read_text();assert 'pub fn repeats' not in s
s=s.replace('struct Clock {speed:f32}','struct Clock {speed:f32,repeat:bool}')
s=s.replace('pub fn speed(model:&str,role:&str)->f32 {','fn catalog()->&\'static Catalog {\n static C:OnceLock<Catalog>=OnceLock::new();\n C.get_or_init(||serde_json::from_str(include_str!("../../../data/4.20/structure_clip_playback.json")).expect("verified structure animation clock"))\n}\npub fn repeats(model:&str,role:&str)->Option<bool> {\n catalog().models.get(model).and_then(|m|m.get(role)).map(|c|c.repeat)\n}\npub fn configure(model:&str,role:&str,active:&mut bevy::animation::ActiveAnimation)->bool {\n let Some(repeat)=repeats(model,role) else {return false;};\n active.set_speed(speed(model,role)).set_repeat(if repeat {bevy::animation::RepeatAnimation::Forever} else {bevy::animation::RepeatAnimation::Never});true\n}\npub fn speed(model:&str,role:&str)->f32 {')
old=' static C:OnceLock<Catalog>=OnceLock::new();\n let catalog=C.get_or_init(||serde_json::from_str(include_str!("../../../data/4.20/structure_clip_playback.json")).expect("verified structure animation clock"));'
assert old in s;s=s.replace(old,' let catalog=catalog();')
s+='''
#[cfg(test)] mod lifecycle_tests {
 use super::*;
 #[test] fn repeat_policy_matches_executed_native_nodes(){
  let native:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/structure_native_lifecycle_contract.json")).unwrap();assert_eq!(native["passed"],true);
  let binding:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/structure_clip_playback.json")).unwrap();let mut checked=0;
  for (model,roles) in binding["models"].as_object().unwrap(){for (role,c) in roles.as_object().unwrap(){
   let source=native["states"].as_array().unwrap().iter().find(|s|s["model"]==c["native_model"]&&s["state"]==c["native_state"]).unwrap();
   let repeat=repeats(model,role).unwrap();assert_eq!(repeat,source["loop"].as_bool().unwrap());
   for case in source["cases"].as_array().unwrap(){if case["stop_requested"]==false{assert_eq!(repeat,case["loop"].as_bool().unwrap());checked+=1;}}
  }}assert_eq!(checked,480);assert_eq!(repeats("Garen","idle"),None);
 }
 #[test] fn death_on_shared_clip_clears_inherited_loop_and_restarts(){
  use bevy::animation::{AnimationPlayer,RepeatAnimation,transition::AnimationTransitions,graph::AnimationNodeIndex};
  let mut player=AnimationPlayer::default();let mut transitions=AnimationTransitions::new();let clip=AnimationNodeIndex::new(0);
  let idle=transitions.play(&mut player,clip,std::time::Duration::ZERO);
  assert!(configure("TT_OrderInhibitor_destroyed","idle",idle));assert_eq!(idle.repeat_mode(),RepeatAnimation::Forever);idle.seek_to(2.);
  let death=transitions.play(&mut player,clip,std::time::Duration::ZERO);
  assert!(configure("TT_OrderInhibitor_destroyed","death",death));assert_eq!(death.repeat_mode(),RepeatAnimation::Never);assert_eq!(death.seek_time(),0.);assert_eq!(death.completions(),0);
 }
}
'''
p.write_text(s)
p=r/'crates/client/src/animation.rs';s=p.read_text()
old='''                transitions
                    .play(&mut player, *index, std::time::Duration::ZERO)
                    .set_speed(crate::structure_animation_clock::speed(&playback.model_name,"idle"))
                    .repeat();'''
new='''                let active=transitions.play(&mut player,*index,std::time::Duration::ZERO);
                if !crate::structure_animation_clock::configure(&playback.model_name,"idle",active) {active.repeat();}'''
assert old in s;s=s.replace(old,new)
old='''        active.set_speed(crate::structure_animation_clock::speed(&actor.playback.model_name,role));
        if ["idle", "run", "spell3"].contains(&role) {
            active.repeat();
        }'''
new='''        if !crate::structure_animation_clock::configure(&actor.playback.model_name,role,active)
            && ["idle", "run", "spell3"].contains(&role) {active.repeat();}'''
assert old in s;s=s.replace(old,new);p.write_text(s)
shutil.copy2(staging/'probe_structure_native_lifecycle.py',r/'tools/probe_structure_native_lifecycle.py')
print(json.dumps(dict(bound_roles=sum(len(m) for m in d['models'].values()),native_states=48,native_cases=960,full_controller_complete=False)))
