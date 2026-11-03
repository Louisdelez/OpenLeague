//! Owned TT Capture composition of existing qualified numerical primitives.
//! Seed, source activation and source/global ownership are explicit local adapters.
use openleague_core::{native_random::Rng55,native_complex_particle_storage as storage,
    native_complex_frame_dispatch as frame,native_complex_movement as motion,
    native_complex_surface_prepare as prepare,native_complex_surface_tail as tail,
    native_complex_particle_age as age,native_complex_lifetime_scale as scale,
    native_complex_emission_gate as gate,native_complex_emission_count as count};
use crate::{relic_pickup_events::OwnerFrame,tt_capture_sampler as sampler};
pub const PER_GROUP:usize=35;
pub const PER_EVENT:usize=70;
#[derive(Clone,Debug)]
pub struct Particle {pub birth:u32,pub record:storage::Record}
#[derive(Clone,Debug)]
pub struct Emitter {
    pub index:usize,pub start:f32,pub previous:f32,pub emitted:u32,pub flag74:u8,
    pub particles:Vec<Particle>,pub frame:frame::State,pub previous_position:[f32;3],
    pub distance_anchor:f32,
}
fn finite_owner(owner:OwnerFrame)->Result<(),String>{
    if owner.native_position.iter().chain(&owner.native_matrix).any(|v|!f32::from_bits(*v).is_finite()) {
        return Err("TT Capture owner pose nonfinite".into());
    }Ok(())
}
impl Emitter {
    pub fn new(index:usize,start:f32,owner:OwnerFrame)->Result<Self,String> {
        finite_owner(owner)?;
        if index>=2 || !start.is_finite(){return Err("TT Capture initial clock/group invalid".into());}
        // Static933000 constructor:74=0,80=MIN,108=MIN,118=0,11C=0.
        Ok(Self {index,start,previous:f32::MIN,emitted:0,flag74:0,particles:Vec::new(),
            frame:frame::State {last_time:f32::MIN,initialized_particles:0},
            previous_position:owner.native_position.map(f32::from_bits),distance_anchor:f32::MIN})
    }
    pub fn step(&mut self,profile:&sampler::Profile,rotations:&[sampler::RotationSource],
        time:f32,owner:OwnerFrame,rng:&mut Rng55)->Result<(),String> {
        finite_owner(owner)?;
        if !time.is_finite() || time<self.start || (self.previous!=f32::MIN && time<self.previous) {
            return Err("TT Capture clock regressed or nonfinite".into());
        }
        if time==self.previous{return Ok(());}
        let mut next=self.clone();let mut random=rng.clone();
        // Whole-record swap preserves particle identity, strict native expiry >life.
        age::remove_expired(time,self.previous,&mut next.particles,
            |p|(f32::from_bits(p.record.life[0]),f32::from_bits(p.record.life[1])),|_,_|{});
        next.frame.initialized_particles=next.frame.initialized_particles.min(next.particles.len() as u32);
        let p=&profile.numeric;let position=owner.native_position.map(f32::from_bits);
        let duration=openleague_core::native_complex_instance_life::initial_duration(p.timing.life,false,1.);
        let past_end=openleague_core::native_complex_instance_life::evaluate_end_flag(time,self.start,duration,0,0.).past_end;
        let mut state=gate::State {field118:next.emitted,field108:next.distance_anchor};
        let mut count_error=None;
        let decision=gate::evaluate(gate::Inputs {time,elapsed:time-self.start,period:p.timing.period,
            active:p.timing.active,offset:p.timing.time_offset,duration,flag334:1,flag74:next.flag74,
            flag11c:0,past_end},&mut state,|_| {
                match count::evaluate_stationary(count::Inputs {time,elapsed:0.,period:p.timing.period,
                    owner_start:self.start,last_emission:self.previous,rate:0.,owner_scale:1.,limit:0,
                    emitted:next.emitted as i32,flag74:next.flag74,flag334:1},
                    count::RateTiming {active:p.timing.active,offset:p.timing.time_offset,duration},
                    &p.rate,&mut random) {
                    Ok(v)=>v.count,Err(error)=>{count_error=Some(format!("TT Capture count: {error:?}"));0}
                }
            }).map_err(|error|format!("TT Capture gate: {error:?}"))?;
        if let Some(error)=count_error{return Err(error);}
        next.distance_anchor=state.field108;
        if let gate::Decision::Count {value,birth_requested:true}=decision {
            if value!=PER_GROUP as i32 || next.emitted!=0 || next.flag74!=0 {
                return Err("TT Capture source batch must be exactly35 once".into());
            }
            next.particles.try_reserve_exact(PER_GROUP).map_err(|_|"TT Capture particle allocation")?;
            for index in 0..value as u32 {
                let b=sampler::sample_birth(profile,rotations,crate::relic_pickup_complex_simulation::BirthInputs {
                    time,previous:self.previous,count:value,index,previous_position:self.previous_position,
                    current_position:position,owner_start:self.start,instance_duration:duration,
                    life_owner_scale:1.,life_coefficients:[0.;3],life_symmetry:0},&mut random)?;
                //910180 fresh primary defaults:position/rotation0,scale1.
                // Compose through the qualified932F50 arithmetic; no guessed matrix.
                let source=crate::relic_pickup_complex_source_matrix::compose(
                    crate::relic_pickup_complex_source_matrix::PrimaryFields {position:[0;3],
                        rotation_degrees:[0;3],scale:[1f32.to_bits();3]})?.words().map(f32::from_bits);
                let pose=multiply_source_pose(&Mat4Words::translation(b.numeric.schedule.position),&source);
                // e-local-orient0: no owner rotation or optional shape appended.
                let distance=0.; // All35 first-frame births coincide; prior anchor is MIN.
                let packet=crate::relic_pickup_complex_simulation::packet(p,&b.numeric,
                    crate::relic_pickup_complex_simulation::PreparedBirth {pose,merged_offset:b.merged_offset,
                        world_acceleration:[0.;3],orbit_secondary:[0.;3],uv_aux:[0.;2],
                        rate_multiplier:1.,distance_anchor:distance,emitter_ordinal:next.emitted})?;
                // These are explicitly OWNED local initialization values. The
                // original mutable globals/uninitialized scratch are not recovered.
                let record=storage::Record::from_birth(&packet,storage::GlobalVectors {
                    unit:[0;3],scale:[1f32.to_bits();3],anchor:[0;3]},[0;3],0,false,|_|0.);
                next.emitted+=1;next.particles.push(Particle {birth:next.emitted,record});
                next.distance_anchor=distance;
            }
            next.flag74=1;
        }
        let initialized=next.frame.initialized_particles as usize;let old_time=next.frame.last_time;
        let mut events=Vec::new();
        frame::dispatch(time,0,0,next.particles.len() as u32,&mut next.frame,|event|events.push(event))
            .map_err(|error|format!("TT Capture frame: {error:?}"))?;
        for event in events {match event {
            frame::Event::Movement{..}=>for (index,particle) in next.particles.iter_mut().enumerate(){
                let r=&mut particle.record;let mut m=r.motion.map(f32::from_bits);
                motion::update(motion::Input {time,birth:f32::from_bits(r.life[0]),previous_time:old_time,
                    initialized:index<initialized,sampled_acceleration:[0.;3],sampled_velocity:[0.;3],sampled_drag:[0.;3],
                    force:false,lifetime_quad_rotation:false,local_rotation:false,owner_special_offset:false,
                    attach_owner:false,velocity_alignment:false,owner_matrix:None,local_matrix:None},&mut m)?;
                r.motion=m.map(f32::to_bits);
            },
            frame::Event::Surface{..}=>for (index,particle) in next.particles.iter_mut().enumerate(){
                let r=&mut particle.record;let m=r.motion.map(f32::from_bits);let s=r.surface.map(f32::from_bits);
                let prepared=prepare::prepare(prepare::Input {owner_matrix:s[..16].try_into().unwrap(),
                    motion_matrix:m[..16].try_into().unwrap(),motion_vector:m[16..19].try_into().unwrap(),direct:false})
                    .map_err(|error|format!("TT Capture surface prepare: {error:?}"))?;
                let age=age::evaluate(time,f32::from_bits(r.life[0]),f32::from_bits(r.life[1]));
                let bind=p.bind.sample_age(age.normalized,&mut random).map_err(|error|format!("TT Capture bind: {error:?}"))?;
                let output=tail::compose_without_terrain(tail::Input {prepared_matrix:prepared.matrix,
                    rotated_motion_vector:prepared.vector,accumulated_owner_translation:s[35..38].try_into().unwrap(),
                    owner_delta:std::array::from_fn(|a|position[a]-self.previous_position[a]),owner_extra_offset:[0.;3],
                    default_vector:[0.;3],sampled_vector:[0.;3],sampled_bind:bind,particle_life:age.elapsed,
                    frame_delta:if index<initialized{time-old_time}else{0.}});
                r.surface[16..32].copy_from_slice(&output.world_matrix.map(f32::to_bits));
                r.surface[32..35].copy_from_slice(&output.surface_vector.map(f32::to_bits));
                r.surface[35..38].copy_from_slice(&output.accumulated_owner_translation.map(f32::to_bits));
            },
            frame::Event::Color{..}=>for particle in &mut next.particles {
                let r=&mut particle.record;
                let (rgba,age)=p.lifetime_color.update_lifetime_color(std::array::from_fn(|i|f32::from_bits(r.color[i])),
                    time,f32::from_bits(r.life[0]),f32::from_bits(r.life[1]),&mut random)
                    .map_err(|error|format!("TT Capture lifetime color: {error:?}"))?;
                r.color[4..8].copy_from_slice(&rgba.map(f32::to_bits));
                let (_,live)=scale::update(&p.lifetime_scale,age.normalized,
                    std::array::from_fn(|i|f32::from_bits(r.scale[i])),1.,&mut random)
                    .map_err(|error|format!("TT Capture lifetime scale: {error:?}"))?;
                r.scale[3..6].copy_from_slice(&live.map(f32::to_bits));
                r.update_uv(age.elapsed,openleague_core::native_complex_uv_scroll::Flags(0));
                r.atlas[1]=0;
                r.field_64=openleague_core::native_complex_quad_binding::lookup_uv(age.normalized,
                    p.lookup.modes,p.lookup.scale,p.lookup.offset)?.map(f32::to_bits);
            },
            // Capture has no trail definition; no trail constructor is synthesized.
            frame::Event::NewParticle{..}=>{},
        }}
        if next.particles.iter().any(|p|p.record.motion.iter().chain(&p.record.surface)
            .chain(&p.record.color).chain(&p.record.scale).any(|v|!f32::from_bits(*v).is_finite())) {
            return Err("TT Capture nonfinite composed particle; no state/RNG commit".into());
        }
        next.previous=time;next.previous_position=position;*self=next;*rng=random;Ok(())
    }
    pub fn finished(&self,profile:&sampler::Profile,time:f32)->bool {
        self.flag74!=0 && self.particles.is_empty() && time-self.start>profile.numeric.timing.life+profile.numeric.linger.emitter
    }
}
// Local accessibility adapter for the established camera_view::multiply arithmetic.
// Body, f32 evaluation order and row-major indexing are copied exactly; core stays unchanged.
fn multiply_source_pose(a:&[f32;16],b:&[f32;16])->[f32;16] {
    std::array::from_fn(|i| {
        let row=i/4;let col=i%4;
        ((a[row*4]*b[col]+a[row*4+1]*b[4+col])+a[row*4+2]*b[8+col])+a[row*4+3]*b[12+col]
    })
}
struct Mat4Words;
impl Mat4Words {
    fn translation(position:[f32;3])->[f32;16] {
        let mut value=std::array::from_fn(|i|if [0,5,10,15].contains(&i){1.}else{0.});
        value[12..15].copy_from_slice(&position);value
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use bevy::prelude::*;
    fn owner(position:[f32;3])->OwnerFrame {
        OwnerFrame {binding:crate::relic_pickup_events::Binding {root:Entity::PLACEHOLDER,model:Handle::<Gltf>::default().id()},
            native_position:position.map(f32::to_bits),native_matrix:Mat4::IDENTITY.to_cols_array().map(f32::to_bits)}
    }
    fn seeded()->([sampler::Profile;2],[Vec<sampler::RotationSource>;2],Rng55) {
        let p=sampler::profiles().unwrap();let mut r=Rng55::seeded(42);
        let rotations=[p[0].retained(&mut r).unwrap(),p[1].retained(&mut r).unwrap()];(p,rotations,r)
    }
    fn rng_state(r:&Rng55)->(u32,u32,[u32;55]){(r.first,r.second,r.words)}
    #[test]
    fn source_single_batch_has70_mobile_particles_without_repeat_or_reseed() {
        let (profiles,rotations,mut rng)=seeded();let o=owner([7200.,0.,7500.]);
        let mut emitters=[Emitter::new(0,10.,o).unwrap(),Emitter::new(1,10.,o).unwrap()];
        for i in 0..2 {emitters[i].step(&profiles[i],&rotations[i],10.,o,&mut rng).unwrap();
            assert_eq!(emitters[i].particles.len(),PER_GROUP);assert_eq!(emitters[i].emitted,35);
            assert_eq!(emitters[i].flag74,1);assert!(emitters[i].particles.iter().all(|p|f32::from_bits(p.record.life[0])==10.));}
        assert_eq!(emitters.iter().map(|e|e.particles.len()).sum::<usize>(),PER_EVENT);
        let after=rng_state(&rng);let first=emitters[0].particles[0].record.surface;
        for i in 0..2 {emitters[i].step(&profiles[i],&rotations[i],10.,o,&mut rng).unwrap();}
        assert_eq!(rng_state(&rng),after);assert_eq!(emitters[0].particles[0].record.surface,first);
        for i in 0..2 {emitters[i].step(&profiles[i],&rotations[i],10.1,o,&mut rng).unwrap();
            assert_eq!(emitters[i].emitted,35);assert_eq!(emitters[i].particles.len(),35);}
        // Motion uses sampled birth velocity/drag: this rejects a stationary display substitute.
        assert_ne!(emitters[0].particles[0].record.surface[28..31],first[28..31]);
        assert!(emitters[1].particles.iter().all(|p|f32::from_bits(p.record.surface[29])>0.));
    }
    #[test]
    fn source_bind_follows_owner_delta_while_retaining_birth_identity() {
        let (profiles,rotations,mut rng)=seeded();let o=owner([0.;3]);
        let mut stationary=Emitter::new(0,10.,o).unwrap();stationary.step(&profiles[0],&rotations[0],10.,o,&mut rng).unwrap();
        let mut moving=stationary.clone();let mut other=rng.clone();
        stationary.step(&profiles[0],&rotations[0],10.1,o,&mut rng).unwrap();
        moving.step(&profiles[0],&rotations[0],10.1,owner([100.,0.,0.]),&mut other).unwrap();
        for (a,b) in stationary.particles.iter().zip(&moving.particles) {
            assert_eq!(a.birth,b.birth);assert_eq!(a.record.life,b.record.life);
            let difference=f32::from_bits(b.record.surface[28])-f32::from_bits(a.record.surface[28]);
            assert!((difference-100.).abs()<0.01);
        }
        assert_eq!(rng_state(&rng),rng_state(&other));
    }
    #[test]
    fn regressed_or_nonfinite_frame_preserves_all_particle_and_rng_state() {
        let (profiles,rotations,mut rng)=seeded();let o=owner([0.;3]);
        let mut e=Emitter::new(0,10.,o).unwrap();e.step(&profiles[0],&rotations[0],10.,o,&mut rng).unwrap();
        let state=rng_state(&rng);let before:Vec<_>=e.particles.iter().map(|p|(p.birth,p.record.motion,p.record.surface)).collect();
        for bad in [9.,f32::NAN,f32::INFINITY] {assert!(e.step(&profiles[0],&rotations[0],bad,o,&mut rng).is_err());}
        assert_eq!(rng_state(&rng),state);assert_eq!(e.previous,10.);
        assert_eq!(e.particles.iter().map(|p|(p.birth,p.record.motion,p.record.surface)).collect::<Vec<_>>(),before);
        assert!(e.step(&profiles[0],&rotations[0],10.1,owner([f32::NAN,0.,0.]),&mut rng).is_err());
        assert_eq!(rng_state(&rng),state);
    }
    #[test]
    fn captured_source_lifetime_retires_after_particles_without_new_emission() {
        let (profiles,rotations,mut rng)=seeded();let o=owner([0.;3]);
        let mut e=Emitter::new(0,0.,o).unwrap();e.step(&profiles[0],&rotations[0],0.,o,&mut rng).unwrap();
        assert!(!e.finished(&profiles[0],0.7));
        e.step(&profiles[0],&rotations[0],2.,o,&mut rng).unwrap();
        assert!(e.particles.is_empty());assert!(e.finished(&profiles[0],2.));assert_eq!(e.emitted,35);
        let state=rng_state(&rng);e.step(&profiles[0],&rotations[0],3.,o,&mut rng).unwrap();
        assert_eq!(rng_state(&rng),state);assert_eq!(e.emitted,35);
    }
}
