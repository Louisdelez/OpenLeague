//! Original Simple arithmetic with a named local ground/force-anchor policy.
//! No actor, bone, remote callback or native random-seed reconstruction.
use std::collections::{BTreeMap,BTreeSet};
use openleague_core::{native_random::Rng55,native_simple_emission_count as count,
    native_simple_emission_lifecycle as emission,native_simple_particle_update as particles,
    native_simple_birth_parameters as birth,native_simple_rotation_list as rotations,
    native_particle_force_body as force_body,native_particle_force_graph as force_graph};
use crate::{ezreal_r_flash_events::{Identity,Request,State as Events},ezreal_r_magicdust_profile::Profile};
pub(crate) const MAX_EMITTERS:usize=32;
pub(crate) const MAX_SLOTS:usize=50;
pub(crate) const MAX_STEP:f64=0.25;
#[derive(Clone)]
pub(crate) struct Entry {pub(crate) request:Request,pub(crate) storage:particles::State,
    birth:Vec<u32>,owner:emission::State,rng:Rng55,anchor:[u32;3],started:f64,clock:f64}
#[derive(Clone,Default)]
pub(crate) struct State {pub(crate) rows:BTreeMap<Identity,Entry>,context:Option<(u64,u64,u32)>,clock:Option<f64>}
fn identity()->[u32;16]{std::array::from_fn(|i|if [0,5,10,15].contains(&i){1f32.to_bits()}else{0})}
fn empty()->particles::State {particles::State {last_time:f32::MIN.to_bits(),life:vec![],ages:vec![],active:0,
    positions:vec![],velocities:vec![],scales:vec![],factors:vec![],scalar:vec![],rates:vec![],auxiliary:vec![],
    attribute_a:vec![],attribute_b:vec![],previous_heights:vec![],bounds:openleague_core::native_simple_bounds_policy::State {
        bounds:openleague_core::native_simple_particle_bounds::Bounds {minimum:[0;3],maximum:[0;3]},center:[0;3],last:0},counter:0}}
fn seed(request:&Request)->u32 {
    let id=request.identity;let mut h=0x811c9dc5u32;
    // Local deterministic selection only. Full-width keys, never this hash, own particles.
    for value in [id.session,id.epoch,id.order,request.incarnation(),u64::from(id.owner),2] {
        for byte in value.to_le_bytes(){h=(h^u32::from(byte)).wrapping_mul(0x01000193);}
    }h
}
impl Entry {
    fn new(request:Request,now:f64,y:f32)->Self {Self {request,storage:empty(),birth:vec![],
        owner:emission::State {previous:0,emitted:0,counter:0,bounds_factor:1f32.to_bits()},
        rng:Rng55::seeded(seed(&request)),anchor:[request.position.x,y,request.position.z].map(f32::to_bits),started:now,clock:now}}
    pub(crate) fn live_indices(&self)->impl Iterator<Item=usize>+'_ {
        self.storage.ages.iter().enumerate().filter(|(_,v)|f32::from_bits(**v)<1.).map(|(i,_)|i)
    }
    fn step(&mut self,now:f64,p:&Profile)->Result<(),&'static str>{
        let dt=now-self.clock;if !dt.is_finite() || !(0. ..=MAX_STEP).contains(&dt){return Err("Magicdust frame gap invalid");}
        if dt==0. && self.owner.emitted!=0 {return Ok(());}
        let age=(now-self.started) as f32;
        if !age.is_finite() || age<0. || age>=p.linger {return Err("Magicdust age outside owned lifetime");}
        let progress=age/p.emitter_life;
        // Absent scalar/rotation-speed and A8 position_offset are explicit local zero inputs.
        // Authored p-offset uses final11C; rotation list then transforms offset and velocity.
        let values=birth::sample_base(&p.life.table,&[0.],&p.scale.table,&[0.],progress)?;
        let source=birth::BaseBirth {values,position:[0;3],velocity:birth::sample_vector(&p.velocity.table,progress)?,
            offset:birth::sample_vector(&p.offset.table,progress)?};
        let curves=birth::BirthCurves {life:Some(&p.life.probability),factor:Some(&p.scale.probability),scalar:None,
            rotation:None,position:[None;3],velocity:std::array::from_fn(|i|Some(&p.velocity.probabilities[i])),
            offset:std::array::from_fn(|i|Some(&p.offset.probabilities[i]))};
        let sources=[rotations::Source {table:&p.rotation.table,axis:[0f32,1.,0.].map(f32::to_bits),probability:Some(&p.rotation.probability)}];
        let rotation=rotations::sample(&sources,progress)?;
        let mut matrix=identity();matrix[12..15].copy_from_slice(&self.anchor);
        let scale=particles::Table {values:&p.xscale.table,probability:Some(&p.xscale.probability)};
        let prepared=emission::Prepared {life:values.life,scalar:values.scalar,rate:values.rotation,factor:values.factor,
            offset:source.offset,position_offset:source.position,velocity:source.velocity,matrix,
            previous_position:self.anchor,current_position:self.anchor,bounds_factor:1f32.to_bits(),scale,terrain:0};
        // single-particle selects one native rate-sized burst, not a single dot.
        let timing=count::Input {time:age,start:0.,previous:0.,life:p.emitter_life,delay:0.,period:p.emitter_life,
            window:p.emitter_life,rate:50.,single:1,emitted:0};
        let emitted=emission::update_with_rate_and_rotation_source(&mut self.owner,timing,&prepared,
            &mut self.storage,&mut self.birth,&mut self.rng,&mut |_|Err("Magicdust particle terrain disabled"),
            &mut |rng|birth::sample_rate(&p.rate.table,Some(&p.rate.probability),progress,1.,rng),
            &mut |_,rng|Ok(source.birth(&curves,rng)),
            &mut |_,offset,velocity,rng|rotations::evaluate(&rotation,rng)?.apply(offset,velocity))?;
        if emitted<0 || emitted>MAX_SLOTS as i32 || self.birth.len()>MAX_SLOTS {return Err("Magicdust population exceeded authored burst");}
        // Names/radius/strength/acceleration are authored. The stationary field
        // center is a LOCAL attachment choice, not a recovered native producer.
        let damping=[force_body::Sphere {position:self.anchor,radius:p.radius.to_bits(),strength:p.drag.to_bits()}];
        let graph=force_graph::Input {body:force_body::Input {acceleration:Some(p.acceleration.map(f32::to_bits)),
            points:&[],dampings:&damping,children:&[],final_children:&[],delta:0},random_forces:&[],axis_forces:&[]};
        particles::update(&particles::Input {time:age.to_bits(),cap:p.linger.to_bits(),birth:&self.birth,bounds_flag:0,
            previous_position:self.anchor,current_position:self.anchor,initial_inverse:identity(),current_matrix:matrix,
            bind_begin:0,bind_end:0,sticky:0,local:0,circular:0,direction:0,force_resource:1,force_graph:Some(&graph),
            scalar_enabled:0,scalar_table:particles::Table {values:&[0.],probability:None},scale_table:scale,
            attributes:[particles::Attribute {mode:1,multiplier:p.color_scale[0].to_bits(),offset:p.color_offset[0].to_bits()},
                particles::Attribute {mode:3,multiplier:p.color_scale[1].to_bits(),offset:p.color_offset[1].to_bits()}],
            bounds_factor:1f32.to_bits(),terrain_enabled:0},&mut self.storage,&mut self.rng,
            &mut |_|Err("Magicdust particle terrain disabled"),&mut |_|{})?;
        if self.storage.life.iter().any(|v|!f32::from_bits(*v).is_finite() || !(0.5..=p.linger).contains(&f32::from_bits(*v)))
            || self.storage.positions.iter().flatten().chain(self.storage.velocities.iter().flatten()).any(|v|!f32::from_bits(*v).is_finite()) {
            return Err("Magicdust particle output invalid");
        }
        self.clock=now;Ok(())
    }
}
impl State {
    pub(crate) fn plan(&self,events:&Events,requests:&[Request],now:f64,paused:bool,p:&Profile,
        mut terrain:impl FnMut([f32;2])->Result<f32,&'static str>)->Result<Self,&'static str>{
        let context=events.context().filter(|(_,epoch,viewer)|*epoch!=0&&*viewer!=0).ok_or("Magicdust epoch unavailable")?;
        if !events.presentation_ready(now) || !now.is_finite() || self.clock.is_some_and(|old|now<old)
            || requests.len()>MAX_EMITTERS {return Err("Magicdust clock/authority/budget invalid");}
        let mut next=if self.context==Some(context){self.clone()}else{Self {context:Some(context),..Self::default()}};
        // A finite f64 age may round onto the f32 lifetime endpoint. Retire
        // only that emitter before step instead of failing all active impacts.
        next.rows.retain(|_,e|events.authorizes(&e.request) && now>=e.started
            && now-e.started<f64::from(p.linger) && ((now-e.started) as f32)<p.linger);
        let mut unique=BTreeSet::new();
        for request in requests {
            if !unique.insert(request.identity){return Err("Magicdust duplicate birth in frame");}
            if paused || !events.authorizes(request){continue;}
            if next.rows.contains_key(&request.identity){return Err("Magicdust identity repeated");}
            if next.rows.len()==MAX_EMITTERS{return Err("Magicdust live budget exceeded");}
            let y=terrain([request.position.x,request.position.z])?;if !y.is_finite(){return Err("Magicdust terrain nonfinite");}
            next.rows.insert(request.identity,Entry::new(*request,now,y));
        }
        for e in next.rows.values_mut(){
            let xz=[e.request.position.x,e.request.position.z];let y=terrain(xz)?;
            // The frozen Map10 grid is immutable. A changed provider is rejected;
            // it never teleports a living population onto a replacement terrain.
            if !y.is_finite() || y.to_bits()!=e.anchor[1]{return Err("Magicdust terrain changed or invalid");}
            e.step(now,p)?;
        }
        next.rows.retain(|_,e|e.live_indices().next().is_some());next.clock=Some(now);Ok(next)
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    use crate::ezreal_r_flash_events::test_fixture;
    fn signature(e:&Entry)->(Vec<u32>,Vec<[u32;3]>,Vec<[u32;3]>,[u32;55],u32,u32){
        (e.birth.clone(),e.storage.positions.clone(),e.storage.velocities.clone(),e.rng.words,e.rng.first,e.rng.second)
    }
    #[test]
    fn authored_single_emits_fifty_once_with_real_rotation_and_independent_probabilities(){
        let p=Profile::load().unwrap();let (_,_,mut events)=test_fixture([100.,5000.]);let requests=events.take(1.01,true,false);
        let s=State::default().plan(&events,&requests,1.01,false,&p,|_|Ok(75.)).unwrap();let e=s.rows.values().next().unwrap();
        assert_eq!(e.owner.counter,50);assert_eq!(e.birth.len(),50);assert_eq!(e.live_indices().count(),50);
        assert!(e.storage.life.iter().all(|v|(0.5..=4.).contains(&f32::from_bits(*v))));
        assert!(e.storage.factors.iter().all(|v|*v==3f32.to_bits()));
        assert!(e.storage.positions.iter().any(|v|f32::from_bits(v[1])>75.));
        assert!(e.storage.velocities.iter().any(|v|f32::from_bits(v[0]).abs()>1.));
        let n=s.plan(&events,&[],1.11,false,&p,|_|Ok(75.)).unwrap();assert_eq!(n.rows.values().next().unwrap().owner.counter,50);
        assert!(n.rows.values().next().unwrap().storage.velocities.iter().all(|v|f32::from_bits(v[1])<0.));
    }
    #[test]
    fn gravity_then_damping_matches_simple_independent_first_step_arithmetic(){
        let p=Profile::load().unwrap();let (_,_,mut events)=test_fixture([100.,5000.]);let requests=events.take(1.01,true,false);
        let s=State::default().plan(&events,&requests,1.01,false,&p,|_|Ok(75.)).unwrap();
        let old=s.rows.values().next().unwrap();let n=s.plan(&events,&[],1.11,false,&p,|_|Ok(75.)).unwrap();let new=n.rows.values().next().unwrap();
        // All particles remain inside radius2000 in this first0.1s step.
        // Uniform gravity makes vy=-20; drag8 leaves20% (small RSQRT rounding tolerated).
        for i in 0..50 {assert!((f32::from_bits(new.storage.velocities[i][1])+4.).abs()<0.001);
            let dy=f32::from_bits(new.storage.positions[i][1])-f32::from_bits(old.storage.positions[i][1]);assert!((dy+0.4).abs()<0.002);}
    }
    #[test]
    fn longest_authored_particles_remain_after_two_seconds_and_retire_at_four(){
        assert!(openleague_core::ezreal_r_accepted_impacts::HORIZON>=150,"separate retention proposal required");
        let mut p=Profile::load().unwrap();p.life.probability.constant=true;p.life.probability.constant_value=4.;
        let (mut snapshot,_,mut events)=test_fixture([100.,5000.]);let requests=events.take(1.01,true,false);
        let mut s=State::default().plan(&events,&requests,1.01,false,&p,|_|Ok(75.)).unwrap();
        for n in 1..=15 {let now=1.01+n as f64*0.25;snapshot.tick=101+(n*15/2) as u64;
            events.observe_test_frame(&snapshot,now,true,false).unwrap();assert!(events.take(now,true,false).is_empty());
            s=s.plan(&events,&[],now,false,&p,|_|Ok(75.)).unwrap();assert_eq!(s.rows.values().next().unwrap().live_indices().count(),50);}
        assert!(s.plan(&events,&[],5.01,false,&p,|_|Ok(75.)).unwrap().rows.is_empty());
    }
    #[test]
    fn pause_keeps_rng_but_gap_revelation_or_terrain_failure_cannot_replay(){
        let p=Profile::load().unwrap();let (mut snapshot,_,mut events)=test_fixture([100.,5000.]);let requests=events.take(1.01,true,false);
        let s=State::default().plan(&events,&requests,1.01,false,&p,|_|Ok(75.)).unwrap();let before=signature(s.rows.values().next().unwrap());
        let frozen=s.plan(&events,&[],1.01,true,&p,|_|Ok(75.)).unwrap();assert_eq!(signature(frozen.rows.values().next().unwrap()),before);
        for y in [f32::NAN,76.] {assert!(s.plan(&events,&[],1.02,false,&p,|_|Ok(y)).is_err());}
        assert!(s.plan(&events,&[],1.27,false,&p,|_|Ok(75.)).is_err());assert_eq!(signature(s.rows.values().next().unwrap()),before);
        let old=snapshot.ezreal_r_accepted_impacts.clone();snapshot.tick+=1;snapshot.ezreal_r_accepted_impacts=None;
        events.observe_test_frame(&snapshot,1.02,true,false).unwrap();snapshot.tick+=1;snapshot.ezreal_r_accepted_impacts=old;
        events.observe_test_frame(&snapshot,1.02,true,false).unwrap();assert!(events.take(1.02,true,false).is_empty());
        assert!(s.plan(&events,&[],1.02,false,&p,|_|Ok(75.)).unwrap().rows.is_empty());
    }
    #[test]
    fn rounded_lifetime_endpoint_retires_only_old_emitter_and_preserves_younger_impact(){
        let mut p=Profile::load().unwrap();p.life.probability.constant=true;p.life.probability.constant_value=4.;
        let (mut snapshot,_,mut events)=test_fixture([100.,5000.]);let first=events.take(1.01,true,false);
        let old_id=first[0].identity;
        let mut s=State::default().plan(&events,&first,1.01,false,&p,|_|Ok(75.)).unwrap();
        // A second accepted impact arrives a quarter-second later; both remain
        // currently authorized in the same bounded event journal.
        snapshot.tick=102;
        let rows=snapshot.ezreal_r_accepted_impacts.as_mut().unwrap()["events"].as_array_mut().unwrap();
        let mut second=rows[0].clone();second["order"]=serde_json::json!(2);second["tick"]=serde_json::json!(102);
        second["target"]=serde_json::json!(901);rows.push(second);
        events.observe_test_frame(&snapshot,1.26,true,false).unwrap();let fresh=events.take(1.26,true,false);
        assert_eq!(fresh.len(),1);let young_id=fresh[0].identity;
        s=s.plan(&events,&fresh,1.26,false,&p,|_|Ok(75.)).unwrap();
        for n in 2..=15 {let now=1.01+n as f64*0.25;snapshot.tick=101+(n*15/2) as u64;
            events.observe_test_frame(&snapshot,now,true,false).unwrap();assert!(events.take(now,true,false).is_empty());
            s=s.plan(&events,&[],now,false,&p,|_|Ok(75.)).unwrap();assert_eq!(s.rows.len(),2);}
        let now=1.01+f64::from(p.linger)-1e-10;
        let old_age=now-s.rows[&old_id].started;
        assert!(old_age<f64::from(p.linger));assert_eq!(old_age as f32,p.linger);
        snapshot.tick=221;events.observe_test_frame(&snapshot,now,true,false).unwrap();
        assert!(events.authorizes(&first[0]));assert!(events.authorizes(&fresh[0]));
        assert!(events.take(now,true,false).is_empty());
        let next=s.plan(&events,&[],now,false,&p,|_|Ok(75.)).unwrap();
        assert_eq!(next.rows.len(),1);assert!(!next.rows.contains_key(&old_id));
        assert_eq!(next.rows[&young_id].live_indices().count(),50);
        assert_eq!(s.rows.len(),2,"planning does not mutate its source");
    }

}
