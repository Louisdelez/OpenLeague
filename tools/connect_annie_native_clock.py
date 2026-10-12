from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/client/src/projected_live.rs';s=p.read_text(encoding='utf-8')
s=s.replace('struct Lifetime {cycle:NativeProjectedCycle,system:SimpleSystemState}', '''// Native default wrapper9283F0: origin0, scale1, offset0.
// Bevy elapsed seconds is the explicit local source; original source/pausing remains open.
fn native_time(source:f64)->Result<f32,&'static str>{
 openleague_core::native_troy_clock::Clock{origin:0.,scale:1.,offset:0.}.sample(Some(source))
}
struct Lifetime {cycle:NativeProjectedCycle,system:SimpleSystemState}''')
s=s.replace('fn new(native_position:Vec3,c:&SimpleProjectedConfig)', 'fn new(native_position:Vec3,c:&SimpleProjectedConfig,source_started:f64)')
s=s.replace('let cycle=NativeProjectedCycle::new(0.,&pose,c,openleague_core::native_random::Rng55::seeded(17))?;\n        Ok(Self{cycle,system:SimpleSystemState{flags:1,start_time:0.,stop_time:0.}})', '''let clock=native_time(source_started)?;
        let started=openleague_core::native_troy_resource_initial::start(clock,0.,0.)?;
        let start=f32::from_bits(started.clock_words[0]);
        let cycle=NativeProjectedCycle::new(start,&pose,c,openleague_core::native_random::Rng55::seeded(17))?;
        Ok(Self{cycle,system:SimpleSystemState{flags:1,start_time:start,stop_time:0.}})''')
s=s.replace('fn frame(&mut self,age:f32,', 'fn frame(&mut self,source_now:f64,')
s=s.replace('if ended {self.system.stop(age)?;}', 'let clock=native_time(source_now)?;\n        if ended {self.system.stop(clock)?;}')
s=s.replace('self.cycle.step(age,&pose,end.as_ref(),c)?;', 'self.cycle.step(clock,&pose,end.as_ref(),c)?;')
s=s.replace('Lifetime::new(position*20.,&c)', 'Lifetime::new(position*20.,&c,started)')
s=s.replace('effect.lifetime.frame((now-effect.started) as f32,position*20.,ended,&c)', 'effect.lifetime.frame(now,position*20.,ended,&c)')
s=s.replace('Lifetime::new(Vec3::new(100.,200.,300.),&c)', 'Lifetime::new(Vec3::new(100.,200.,300.),&c,0.)')
s=s.replace('native lifetimes/scale/attachment;', 'native clock/start/lifetimes/scale/attachment;')
s=s.replace('"normal_binding":true,"spawned"', '"normal_binding":true,"native_clock_binding":true,"time_source":"local Bevy elapsed seconds; native default scale1/origin0/offset0","spawned"')
s=s.replace('"Shared current projectile anchor', '"Native clock/start consumers use local Bevy source; original source, pause and scale transitions unqualified.","Shared current projectile anchor')
marker='    #[test]\n    fn released_draw_removes_entity_and_both_owned_assets()'
new='''    #[test]
    fn normal_lifetime_with_native_clock_matches_fifty_original_owner_end_frames(){
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/simple_owner_end_contract.json")).unwrap();let mut checked=0;
        for case in proof["cases"].as_array().unwrap(){
            let mut c=config().unwrap();c.emitter_linger=case["emitter_linger"].as_f64().unwrap() as f32;c.particle_linger=case["particle_linger"].as_f64().unwrap() as f32;
            let frames=case["frames"].as_array().unwrap();let position=|f:&serde_json::Value|Vec3::new(f["previous_matrix"][12].as_f64().unwrap() as f32,f["previous_matrix"][13].as_f64().unwrap() as f32,f["previous_matrix"][14].as_f64().unwrap() as f32);
            let mut life=Lifetime::new(position(&frames[0]),&c,10.).unwrap();assert_eq!(life.system.start_time,10.);
            for f in frames{life.frame(10.+f["age"].as_f64().unwrap(),position(f),f["owner_end_flag"].as_bool().unwrap(),&c).unwrap();
                assert_eq!(life.cycle.active_count,f["active_count"].as_u64().unwrap() as u32);assert_eq!(life.cycle.finished,f["emitter_finished"]==1);
                assert_eq!(life.cycle.normalized_age.to_bits(),f["normalized_age_bits"][0].as_u64().unwrap() as u32);
                assert_eq!(life.cycle.position.to_array().map(f32::to_bits),std::array::from_fn(|i|(f["position"][i].as_f64().unwrap() as f32).to_bits()));checked+=1;
            }
        }assert_eq!(checked,50);
    }
'''
assert marker in s;s=s.replace(marker,new+marker);p.write_text(s,encoding='utf-8')
