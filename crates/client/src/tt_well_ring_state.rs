//! Selected actorless Ring composition. Original Well/provider/global parity stays unknown.
//! Seed, source activation and source/global ownership are explicit local adapters.
use openleague_core::{native_random::Rng55,native_complex_particle_storage as storage,
    native_complex_frame_dispatch as frame,native_complex_movement as motion,
    native_complex_surface_prepare as prepare,native_complex_surface_tail as tail,
    native_complex_particle_age as age,native_complex_lifetime_scale as scale,
    native_complex_emission_gate as gate,native_complex_emission_count as count};
use crate::tt_well_ring_sampler as sampler;
#[derive(Clone,Copy,Debug,PartialEq)]
pub struct OwnerFrame {pub native_position:[u32;3]}
#[derive(Clone,Debug)]
pub struct Particle {pub birth:u32,pub record:storage::Record}
#[derive(Clone,Debug)]
pub struct Emitter {
    pub start:f32,pub previous:f32,pub last_emission:f32,pub emitted:u32,pub serial:u32,pub flag74:u8,
    pub particles:Vec<Particle>,pub frame:frame::State,pub previous_position:[f32;3],
    pub distance_anchor:f32,
}
fn finite_owner(owner:OwnerFrame)->Result<(),String>{
    if owner.native_position.iter().any(|v|!f32::from_bits(*v).is_finite()) {
        return Err("TT Well Ring owner pose nonfinite".into());
    }Ok(())
}
impl Emitter {
    pub fn new(start:f32,owner:OwnerFrame)->Result<Self,String> {
        finite_owner(owner)?;
        if !start.is_finite() || start<0.{return Err("TT Well Ring initial clock/group invalid".into());}
        // Static933000 constructor:74=0,78=0,80=MIN,108=MIN,118=0,11C=0.
        // serial is an independent owned identity; it is never the resettable118.
        Ok(Self {start,previous:f32::MIN,last_emission:0.,emitted:0,serial:0,flag74:0,particles:Vec::new(),
            frame:frame::State {last_time:f32::MIN,initialized_particles:0},
            previous_position:owner.native_position.map(f32::from_bits),distance_anchor:f32::MIN})
    }
    pub fn step(&mut self,profile:&sampler::Profile,rotations:&[crate::tt_capture_sampler::RotationSource],
        time:f32,owner:OwnerFrame,rng:&mut Rng55)->Result<(),String> {
        finite_owner(owner)?;
        if !time.is_finite() || time<self.start || (self.previous!=f32::MIN && time<self.previous) {
            return Err("TT Well Ring clock regressed or nonfinite".into());
        }
        if owner.native_position.map(f32::from_bits)!=self.previous_position {
            return Err("Ring stationary map owner changed; new activation generation required".into());
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
            active:p.timing.active,offset:p.timing.time_offset,duration,flag334:0,flag74:next.flag74,
            flag11c:0,past_end},&mut state,|_| {
                match count::evaluate_stationary(count::Inputs {time,elapsed:0.,period:p.timing.period,
                    owner_start:self.start,last_emission:self.last_emission,rate:0.,owner_scale:1.,limit:0,
                    emitted:next.emitted as i32,flag74:next.flag74,flag334:0},
                    count::RateTiming {active:p.timing.active,offset:p.timing.time_offset,duration},
                    &p.rate,&mut random) {
                    Ok(v)=>v.count,Err(error)=>{count_error=Some(format!("TT Well Ring count: {error:?}"));0}
                }
            }).map_err(|error|format!("TT Well Ring gate: {error:?}"))?;
        if let Some(error)=count_error{return Err(error);}
        next.distance_anchor=state.field108;next.emitted=state.field118;
        if let gate::Decision::Count {value,birth_requested:true}=decision {
            // Preserve the count helper's native cap and limit. No local batch/population cap.
            let add=u32::try_from(value).map_err(|_|"Ring negative birth count")?;
            let serial=next.serial.checked_add(add).ok_or("Ring particle identity overflow")?;
            let emitted=next.emitted.checked_add(add).filter(|v|*v<=i32::MAX as u32)
                .ok_or("Ring source emitted counter outside supported signed count domain")?;
            let length=next.particles.len().checked_add(add as usize).ok_or("Ring storage length overflow")?;
            if length>i32::MAX as usize{return Err("Ring frame count outside native signed domain".into());}
            next.particles.try_reserve_exact(add as usize).map_err(|_|"TT Well Ring particle allocation")?;
            // Native9351C8 sets78 at the reached positive batch, independently of80.
            next.last_emission=time;
            let _=(serial,emitted);
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
                let distance=0.; // Selected stationary map owner: every scheduled owner position coincides.
                // This is an OWNED no-property-request source policy, not the original carrier.
                let packet=crate::relic_pickup_complex_simulation::packet(p,&b.numeric,
                    crate::relic_pickup_complex_simulation::PreparedBirth {pose,merged_offset:b.merged_offset,
                        world_acceleration:[0.;3],orbit_secondary:[0.;3],uv_aux:[0.;2],
                        rate_multiplier:1.,distance_anchor:distance,emitter_ordinal:next.emitted})?;
                // These are explicitly OWNED local initialization values. The
                // original mutable globals/uninitialized scratch are not recovered.
                let record=storage::Record::from_birth(&packet,storage::GlobalVectors {
                    unit:[0;3],scale:[1f32.to_bits();3],anchor:[0;3]},[0;3],0,false,|_|0.);
                next.emitted+=1;next.serial+=1;next.particles.push(Particle {birth:next.serial,record});
                next.distance_anchor=distance;
            }
            next.flag74=1;
        }
        let initialized=next.frame.initialized_particles as usize;let old_time=next.frame.last_time;
        let mut events=Vec::new();
        // Nested flags: vecalign4 + randomstart32; kind0 resolves alignmentfalse.
        frame::dispatch(time,36,0,next.particles.len() as u32,&mut next.frame,|event|events.push(event))
            .map_err(|error|format!("TT Well Ring frame: {error:?}"))?;
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
                    .map_err(|error|format!("TT Well Ring surface prepare: {error:?}"))?;
                let age=age::evaluate(time,f32::from_bits(r.life[0]),f32::from_bits(r.life[1]));
                let bind=p.bind.sample_age(age.normalized,&mut random).map_err(|error|format!("TT Well Ring bind: {error:?}"))?;
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
                    .map_err(|error|format!("TT Well Ring lifetime color: {error:?}"))?;
                r.color[4..8].copy_from_slice(&rgba.map(f32::to_bits));
                let (_,live)=scale::update(&p.lifetime_scale,age.normalized,
                    std::array::from_fn(|i|f32::from_bits(r.scale[i])),1.,&mut random)
                    .map_err(|error|format!("TT Well Ring lifetime scale: {error:?}"))?;
                r.scale[3..6].copy_from_slice(&live.map(f32::to_bits));
                r.update_uv(age.elapsed,openleague_core::native_complex_uv_scroll::Flags(0));
                r.atlas[1]=sampler::atlas_frame(f32::from_bits(r.field_58[0]),age.elapsed,f32::from_bits(r.atlas[0]))?.to_bits();
                r.field_64=openleague_core::native_complex_quad_binding::lookup_uv(age.normalized,
                    p.lookup.modes,p.lookup.scale,p.lookup.offset)?.map(f32::to_bits);
            },
            // Selected no-overlay Ring contract admits an empty trail definition only.
            frame::Event::NewParticle{..}=>{},
        }}
        if next.particles.iter().any(|p|p.record.motion.iter().chain(&p.record.surface)
            .chain(&p.record.color).chain(&p.record.scale).any(|v|!f32::from_bits(*v).is_finite())) {
            return Err("TT Well Ring nonfinite composed particle; no state/RNG commit".into());
        }
        next.previous=time;next.previous_position=position;*self=next;*rng=random;Ok(())
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
    fn source()->(sampler::Profile,Vec<crate::tt_capture_sampler::RotationSource>,Rng55){
        let p=sampler::profile().unwrap();let mut rng=Rng55::seeded(42);
        let r=p.retained(&mut rng).unwrap();(p,r,rng)
    }
    fn owner()->OwnerFrame{OwnerFrame{native_position:[0,0,0]}}
    #[test]
    fn continuous_births_preserve_separate_native78_80_and_allow_batch_above32(){
        let(p,r,mut rng)=source();let mut e=Emitter::new(0.,owner()).unwrap();
        assert_eq!(e.last_emission.to_bits(),0);assert_eq!(e.previous.to_bits(),f32::MIN.to_bits());
        e.step(&p,&r,0.149,owner(),&mut rng).unwrap();assert_eq!(e.serial,0);
        e.step(&p,&r,0.15,owner(),&mut rng).unwrap();let first=e.serial;assert!(first>0);
        let anchor=e.last_emission;
        for time in [0.151,0.152,0.153,0.154,0.155,0.156,0.157]{
            e.step(&p,&r,time,owner(),&mut rng).unwrap();
            assert_eq!(e.last_emission.to_bits(),anchor.to_bits());
        }
        assert_ne!(e.previous.to_bits(),e.last_emission.to_bits());
        e.step(&p,&r,0.16,owner(),&mut rng).unwrap();assert_eq!(e.serial,first+1);
        let before=e.serial;e.step(&p,&r,0.5,owner(),&mut rng).unwrap();
        assert!(e.serial-before>32);assert_eq!(e.emitted,e.serial);
        let ids:std::collections::HashSet<_>=e.particles.iter().map(|p|p.birth).collect();
        assert_eq!(ids.len(),e.particles.len());
    }
    #[test]
    fn persistent_emitter_renews_three_second_particles_without_emitter_ttl3(){
        let(p,r,mut rng)=source();let mut e=Emitter::new(0.,owner()).unwrap();
        e.step(&p,&r,0.15,owner(),&mut rng).unwrap();let old=e.serial;
        e.step(&p,&r,4.,owner(),&mut rng).unwrap();
        assert!(e.serial>old);assert!(e.particles.iter().all(|p|p.birth>old));
        assert_eq!(p.numeric.timing.life.to_bits(),f32::MAX.to_bits());
        assert!(!e.particles.is_empty());
    }
    #[test]
    fn stationary_owner_violation_or_equal_frame_never_partially_commits_rng_or_storage(){
        let(p,r,mut rng)=source();let mut e=Emitter::new(0.,owner()).unwrap();
        e.step(&p,&r,0.15,owner(),&mut rng).unwrap();let before=format!("{e:?}");let random=rng.clone();
        e.step(&p,&r,0.15,owner(),&mut rng).unwrap();assert_eq!(format!("{e:?}"),before);
        assert!(e.step(&p,&r,0.2,OwnerFrame{native_position:[1f32.to_bits(),0,0]},&mut rng).is_err());
        assert_eq!(format!("{e:?}"),before);
        assert_eq!((rng.first,rng.second,rng.words),(random.first,random.second,random.words));
    }
}
