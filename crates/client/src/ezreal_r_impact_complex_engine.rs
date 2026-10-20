//! Bounded adaptation of relic_pickup_complex_simulation for R groups1/4. Native source creation
//! and primary lookup producer are explicit mandatory inputs; trigger parity false.
use openleague_core::{native_random::Rng55,native_complex_vectors::Field,
    native_complex_birth as birth,native_complex_particle_storage as storage,
    native_complex_movement as movement,native_complex_surface_prepare as prepare,
    native_complex_surface_tail as tail,native_complex_particle_age as age,
    native_complex_lifetime_scale as scale,native_complex_frame_dispatch as frame};
use crate::ezreal_r_impact_complex_profile::Profile;
pub const BIRTH_ORDER:[Field;10]=[Field::PostOffset,Field::Scale,Field::QuadRotation,
    Field::Velocity,Field::Acceleration,Field::RotationVelocity,Field::BirthRotationAcceleration,
    Field::Drag,Field::OrbitVelocity,Field::Offset];
#[derive(Debug,Clone)]
pub struct SampledBirth {pub schedule:birth::Birth,pub emitter_age:f32,pub color:[f32;4],
    pub vectors:[[f32;3];10],pub life:f32,pub uv:openleague_core::native_complex_uv_scroll::Scroll,pub shared_uv:f32}
#[derive(Debug,Clone,Copy)]
pub struct BirthInputs {pub time:f32,pub previous:f32,pub count:i32,pub index:u32,
    pub previous_position:[f32;3],pub current_position:[f32;3],pub owner_start:f32,
    pub instance_duration:f32,pub life_owner_scale:f32,pub life_coefficients:[f32;3],pub life_symmetry:u32}
pub fn sample_birth(profile:&Profile,input:BirthInputs,rng:&mut Rng55)->Result<SampledBirth,&'static str> {
    if input.life_coefficients!=[0.;3] {return Err("nonzero life flex producer not admitted");}
    let schedule=birth::scheduled_birth(input.time,input.previous,input.count,input.index,
        input.previous_position,input.current_position).ok_or("invalid birth schedule")?;
    // Original9348BF uses the batch time; distributed schedule time remains particle birth time.
    let age_input=profile.timing.emitter_age_input(input.time,input.owner_start,input.instance_duration);
    let emitter_age=age_input.evaluate();
    // Original9355C2..9356A6 samples p-life before RGBA93580B and vector variations.
    let sampled_life=profile.life.sample_age(emitter_age.normalized,rng).map_err(|_|"birth life sampling")?;
    let (color,_)=profile.birth_color.create_birth_color_at_emitter_age(age_input,rng).map_err(|_|"birth RGBA sampling")?;
    let mut vectors=[[0.;3];10];
    for field in BIRTH_ORDER {let parameter=profile.vectors.field(field);
        let factor=parameter.create_multiplier([1.;3],rng);
        vectors[field as usize]=parameter.sample_age(emitter_age.normalized,factor).map_err(|_|"birth vector sampling")?;}
    let life=birth::finalized_life(birth::LifeInputs {sampled_life,owner_scale:input.life_owner_scale,
        scale_enabled:false,velocity:vectors[Field::Offset as usize],coefficients:input.life_coefficients,symmetry_flags:input.life_symmetry});
    // Original9360D8 unconditional shared fraction also feeds UV readers.
    let shared_uv=rng.fraction();
    let uv=profile.uv.sample_birth(emitter_age.normalized,shared_uv).map_err(|_|"birth UV sampling")?;
    Ok(SampledBirth {schedule,emitter_age:emitter_age.normalized,color,vectors,life,uv,shared_uv})
}
/// Exact head/tail channels must come from the qualified source-matrix/instance
/// producer. None of these inputs is inferred from a particle's visual appearance.
#[derive(Debug,Clone,Copy)]
pub struct PreparedBirth {pub pose:[f32;16],pub merged_offset:[f32;3],pub world_acceleration:[f32;3],
    pub orbit_secondary:[f32;3],pub uv_aux:[f32;2],pub rate_multiplier:f32,pub distance_anchor:f32,pub emitter_ordinal:u32}
pub fn packet(profile:&Profile,b:&SampledBirth,p:PreparedBirth)->Result<storage::BirthPacket,&'static str> {
    if p.pose.iter().chain(&p.merged_offset).chain(&p.world_acceleration).chain(&p.orbit_secondary)
        .chain(&p.uv_aux).chain([p.rate_multiplier,p.distance_anchor].iter()).any(|v|!v.is_finite()) {
        return Err("nonfinite prepared Complex birth producer");
    }
    let mut out=storage::BirthPacket([0;69]);out.0[..16].copy_from_slice(&p.pose.map(f32::to_bits));
    out.0[16..20].copy_from_slice(&b.color.map(f32::to_bits));
    for (offset,value) in [(0x50,p.merged_offset),(0x5c,b.vectors[Field::QuadRotation as usize]),
        (0x68,b.vectors[Field::Scale as usize]),(0x74,b.vectors[Field::Velocity as usize]),
        (0x80,b.vectors[Field::Acceleration as usize]),(0x8c,b.vectors[Field::RotationVelocity as usize]),
        (0x98,b.vectors[Field::BirthRotationAcceleration as usize]),(0xa4,b.vectors[Field::Drag as usize]),
        (0xb0,b.vectors[Field::OrbitVelocity as usize]),(0xbc,p.orbit_secondary),(0xc8,p.world_acceleration)] {
        out.0[offset/4..offset/4+3].copy_from_slice(&value.map(f32::to_bits));
    }
    out.0[0xd4/4..0xdc/4].copy_from_slice(&p.uv_aux.map(f32::to_bits));out.set_uv(b.uv);
    // Original936D6E: primary scalar multiplier * nested frame frequency.
    out.0[0xfc/4]=(profile.frame_rate*p.rate_multiplier).to_bits();
    for (offset,value) in [(0x100,b.schedule.time),(0x104,b.life),(0x108,b.shared_uv),(0x10c,p.distance_anchor)] {out.0[offset/4]=value.to_bits();}
    out.0[0x110/4]=p.emitter_ordinal;
    Ok(out)
}
#[derive(Debug,Clone,Copy)]
pub struct FrameInputs {pub owner_delta:[f32;3],pub owner_extra:[f32;3],pub default_vector:[f32;3],
    pub scale_owner:f32,pub lookup_modes:[u32;2],pub lookup_scale:[f32;2],pub lookup_offset:[f32;2],
    pub surface_direct:bool,pub local_matrix:Option<[f32;16]>,pub attach_matrix:Option<[f32;16]>}
#[derive(Debug,Clone)]
pub struct Host {pub storage:storage::Storage,pub frame:frame::State,pub ordinal:u64,pub start:f32,
    pub last_update:f32,pub last_birth:f32,pub emitted:i32,pub has_emitted:u8,pub previous_position:[f32;3],pub distance_anchor:f32}
impl Host {
    pub fn new(start:f32,position:[f32;3])->Self {Self {storage:storage::Storage::default(),
        frame:frame::State {last_time:f32::MIN,initialized_particles:0},ordinal:0,start,
        last_update:f32::MIN,last_birth:start,emitted:0,has_emitted:0,previous_position:position,distance_anchor:f32::MIN}}
    pub fn append(&mut self,p:&storage::BirthPacket,globals:storage::GlobalVectors,scratch:[u32;3]) {
        self.storage.append(storage::Record::from_birth(p,globals,scratch,0,false,|_|0.));
        self.emitted+=1;self.has_emitted=1;
    }
    /// Native938900 callback order is kept. Selected nested velocity/acceleration/
    /// drag are null zero parameters, and optional forces/terrain/trails are absent.
    pub fn update(&mut self,profile:&Profile,time:f32,input:FrameInputs,rng:&mut Rng55)->Result<bool,&'static str> {
        let mut next=self.clone();let mut next_rng=rng.clone();
        let previous=next.frame.last_time;
        // Original938A42/939485 uses the pre-dispatch initialized count for
        // every record. Freshly appended particles get zero integration delta.
        let initialized_count=next.frame.initialized_particles as usize;
        let mut events=Vec::new();let count=next.storage.particles.len() as u32;
        let changed=frame::dispatch(time,0,profile.kind as i32,count,&mut next.frame,|e|events.push(e)).map_err(|_|"invalid Complex frame count")?;
        if !changed {return Ok(false);}
        for event in events {match event {
            frame::Event::Movement{..}=>for (index,record) in next.storage.particles.iter_mut().enumerate() {
                let initialized=index<initialized_count;
                let mut motion=record.motion.map(f32::from_bits);
                movement::update(movement::Input {time,birth:f32::from_bits(record.life[0]),previous_time:previous,initialized,
                    sampled_acceleration:[0.;3],sampled_velocity:[0.;3],sampled_drag:[0.;3],force:false,lifetime_quad_rotation:false,
                    local_rotation:input.local_matrix.is_some(),owner_special_offset:false,attach_owner:input.attach_matrix.is_some(),
                    velocity_alignment:false,owner_matrix:input.attach_matrix,local_matrix:input.local_matrix},&mut motion)?;
                record.motion=motion.map(f32::to_bits);
            },
            frame::Event::Surface{..}=>for (index,record) in next.storage.particles.iter_mut().enumerate() {
                let initialized=index<initialized_count;
                let motion=record.motion.map(f32::from_bits);let surface=record.surface.map(f32::from_bits);
                let prepared=prepare::prepare(prepare::Input {owner_matrix:surface[..16].try_into().unwrap(),
                    motion_matrix:motion[..16].try_into().unwrap(),motion_vector:motion[16..19].try_into().unwrap(),
                    direct:input.surface_direct}).map_err(|_|"Complex surface matrix preparation")?;
                let particle_age=age::evaluate(time,f32::from_bits(record.life[0]),f32::from_bits(record.life[1]));
                let sampled_bind=profile.bind.sample_age(particle_age.normalized,&mut next_rng).map_err(|_|"bind sampling")?;
                let result=tail::compose_without_terrain(tail::Input {prepared_matrix:prepared.matrix,rotated_motion_vector:prepared.vector,
                    accumulated_owner_translation:surface[35..38].try_into().unwrap(),owner_delta:input.owner_delta,
                    owner_extra_offset:input.owner_extra,default_vector:input.default_vector,sampled_vector:[0.;3],
                    sampled_bind,particle_life:particle_age.elapsed,frame_delta:if initialized{time-previous}else{0.}});
                record.surface[16..32].copy_from_slice(&result.world_matrix.map(f32::to_bits));
                // Original9398CF/9398EB/939904 retains accumulated displacement
                // at +0x8C..94;939AD1/939ADE/939AEB publishes vector +0x80..88.
                record.surface[35..38].copy_from_slice(&result.accumulated_owner_translation.map(f32::to_bits));
                record.surface[32..35].copy_from_slice(&result.surface_vector.map(f32::to_bits));
            },
            frame::Event::Color{..}=>for record in &mut next.storage.particles {
                let birth=f32::from_bits(record.life[0]);let life=f32::from_bits(record.life[1]);
                let stored=std::array::from_fn(|i|f32::from_bits(record.color[i]));
                let (rgba,particle_age)=profile.lifetime_color.update_lifetime_color(stored,time,birth,life,&mut next_rng).map_err(|_|"lifetime RGBA sampling")?;
                record.color[4..8].copy_from_slice(&rgba.map(f32::to_bits));
                let (_,live_scale)=scale::update(&profile.lifetime_scale,particle_age.normalized,
                    std::array::from_fn(|i|f32::from_bits(record.scale[i])),input.scale_owner,&mut next_rng).map_err(|_|"lifetime scale sampling")?;
                record.scale[3..6].copy_from_slice(&live_scale.map(f32::to_bits));
                record.update_uv(particle_age.elapsed,openleague_core::native_complex_uv_scroll::Flags(0));
                // Selected frequency=0, original939F75: fmod(0,numframes)+startframe.
                record.atlas[1]=(profile.start_frame as f32).to_bits();
                for axis in 0..2 {let value=match input.lookup_modes[axis] {0=>input.lookup_scale[axis],
                    1=>input.lookup_scale[axis]*particle_age.normalized+input.lookup_offset[axis],
                    3=>input.lookup_scale[axis]*f32::from_bits(record.field_58[0])+input.lookup_offset[axis],
                    _=>return Err("velocity dependent primary lookup not admitted")};record.field_64[axis]=value.to_bits();}
            },
            // Original93A550 immediately returns when the selected resource's
            // nested+0x3AC trail-name vector is empty, as all three profiles are.
            frame::Event::NewParticle{..}=>{},
        }}
        next.ordinal=next.ordinal.checked_add(1).ok_or("Complex ordinal overflow")?;
        *self=next;*rng=next_rng;Ok(true)
    }
    pub fn expire(&mut self,time:f32,kind:u32)->Result<usize,&'static str> {
        struct NullTrails;impl storage::TrailBackend for NullTrails {fn release_particle_trail(&mut self,_:[u32;2]){}fn set_particle_index(&mut self,_:[u32;2],_:usize){}fn drop_slot(&mut self,_:[u32;2]){}}
        let count=self.storage.expire_native(time,f32::MIN,kind,&mut NullTrails,|_,_|{})?;
        self.frame.initialized_particles=self.storage.particles.len() as u32;Ok(count)
    }
    pub fn finished(&self,profile:&Profile,time:f32)->bool {
        time-self.start>profile.timing.life+profile.linger.emitter && self.storage.particles.is_empty()
    }
}
#[derive(Debug,Clone,Copy)]
pub struct Instance {pub duration:f32,pub rate_owner_scale:f32,pub life_owner_scale:f32,
    pub life_coefficients:[f32;3],pub life_symmetry:u32,pub limit:i32,pub single_flag:u32,
    pub stopped_flag:u8,pub past_end:bool,pub globals:storage::GlobalVectors,pub motion_scratch:[u32;3]}
impl Host {
    /// Full candidate sequence, composed from qualified native gate/count/birth/
    /// buffers. The original whole934340 production sequence is not asserted.
    /// The provider performs native source transforms and any intervening draws.
    pub fn planned_frame(&self,ordinal:u64,profile:&Profile,time:f32,position:[f32;3],
        instance:Instance,frame_input:FrameInputs,rng:&Rng55,
        mut prepared:impl FnMut(&SampledBirth,u32,&mut Rng55)->Result<PreparedBirth,&'static str>)
        ->Result<Option<(Self,Rng55)>,&'static str> {
        if ordinal==0 || !time.is_finite() || time<self.start || time<self.last_update {
            return Err("invalid Complex ordinal/time");
        }
        if ordinal<=self.ordinal {return Ok(None);}
        if instance.duration<=0. || !instance.duration.is_finite() || !instance.rate_owner_scale.is_finite() {
            return Err("invalid supplied Complex instance");
        }
        let mut next=self.clone();let mut random=rng.clone();next.expire(time,profile.kind)?;
        let elapsed=time-self.start;let mut state=openleague_core::native_complex_emission_gate::State {
            field118:next.emitted as u32,field108:next.distance_anchor};
        let mut count_error=None;
        let decision=openleague_core::native_complex_emission_gate::evaluate(
            openleague_core::native_complex_emission_gate::Inputs {time,elapsed,period:profile.timing.period,
                active:profile.timing.active,offset:profile.timing.time_offset,duration:instance.duration,
                flag334:instance.single_flag,flag74:next.has_emitted,flag11c:instance.stopped_flag,past_end:instance.past_end},
            &mut state,|_|match openleague_core::native_complex_emission_count::evaluate_stationary(
                openleague_core::native_complex_emission_count::Inputs {time,elapsed,period:profile.timing.period,owner_start:self.start,
                    last_emission:next.last_birth,rate:0.,owner_scale:instance.rate_owner_scale,limit:instance.limit,
                    emitted:next.emitted,flag74:next.has_emitted,flag334:instance.single_flag},
                openleague_core::native_complex_emission_count::RateTiming {active:profile.timing.active,offset:profile.timing.time_offset,duration:instance.duration},
                &profile.rate,&mut random) {Ok(v)=>v.count,Err(_)=>{count_error=Some("Complex count sampling");0}})
            .map_err(|_|"Complex emission gate")?;
        if let Some(error)=count_error{return Err(error);}
        next.emitted=state.field118 as i32;next.distance_anchor=state.field108;
        if let openleague_core::native_complex_emission_gate::Decision::Count {value,birth_requested:true}=decision {
            if value>256 || next.emitted.checked_add(value).is_none() || next.storage.particles.len().checked_add(value as usize).is_none_or(|n|n>256) {return Err("Complex selected batch/counter overflow");}
            for index in 0..value as u32 {
                let b=sample_birth(profile,BirthInputs {time,previous:self.last_update,count:value,index,
                    previous_position:self.previous_position,current_position:position,owner_start:self.start,
                    instance_duration:instance.duration,life_owner_scale:instance.life_owner_scale,
                    life_coefficients:instance.life_coefficients,life_symmetry:instance.life_symmetry},&mut random)?;
                let p=prepared(&b,next.emitted as u32,&mut random)?;
                let packet=packet(profile,&b,p)?;
                next.append(&packet,instance.globals,instance.motion_scratch);
                next.distance_anchor=p.distance_anchor;
            }
            next.last_birth=time;
        }
        // Original934586..934599 calls936E50/938900 only for a nonempty
        // particle container. Instance+80 still advances at9345CC..9345D2.
        if !next.storage.particles.is_empty(){next.update(profile,time,frame_input,&mut random)?;}
        next.last_update=time;next.previous_position=position;next.ordinal=ordinal;
        Ok(Some((next,random)))
    }
}


#[cfg(test)]
mod sampler_order_tests {
 use super::*;
 // These five raw outputs give exact fractions 1/4,1/2,3/4,1/8,7/8.
 // Source indices34/37/40/43/46 stay zero, so each mix is 0xaa<<5.
 fn fractions()->Rng55 {
  let mut words=[0;55];
  for (i,value) in [0x4000_0000u32,0x8000_0000,0xc000_0000,0x2000_0000,0xe000_0000].into_iter().enumerate(){
   words[i+1]=value^(0xaau32<<5);
  }
  Rng55 {words,first:0,second:31}
 }
 fn input()->BirthInputs {BirthInputs {time:0.125,previous:0.,count:2,index:0,
  previous_position:[0.;3],current_position:[4.,8.,12.],owner_start:0.,instance_duration:1.,
  life_owner_scale:1.,life_coefficients:[0.;3],life_symmetry:0}}
 fn expect_draws(rng:&Rng55,count:u32){
  let mut expected=fractions();for _ in 0..count{expected.fraction();}
  assert_eq!((rng.first,rng.second),(count,(31+3*count)%55));assert_eq!(rng.words,expected.words);
 }
 #[test] fn authored_spinlines_life_uses_first_fraction_while_zero_axes_still_consume_their_draws(){
  let p=Profile::load(0).unwrap();let mut rng=fractions();let got=sample_birth(&p,input(),&mut rng).unwrap();
  // Authored three-knot curve: at1/4 interpolate [.0,.2] to [.7,.4], then base life.5.
  let expected=(0.25f32/0.7*0.2+0.2)*0.5;
  assert!((got.life-expected).abs()<1e-7);
  let old_last=(0.125f32/0.7*0.2+0.2)*0.5;assert!((got.life-old_last).abs()>0.01);
  assert_eq!(got.vectors[Field::Velocity as usize],[0.,0.,1200.]);
  assert_eq!(got.vectors[Field::Offset as usize],[0.,0.,20.]);
  assert_eq!(got.shared_uv,0.125);assert_eq!(got.color,[1.;4]);
  assert_eq!(got.uv.origin,[[0.;2];2]);assert_eq!(got.uv.rate,[[0.;2];2]);
  expect_draws(&rng,4);
 }
 #[test] fn authored_rays_life_precedes_scale_rotation_and_the_unconditional_shared_fraction(){
  let p=Profile::load(1).unwrap();let mut rng=fractions();let got=sample_birth(&p,input(),&mut rng).unwrap();
  // Life(.5+1/4)*.3; ScaleX(1+1/2)*30; ScaleZ(2*3/4); angle360*1/8.
  assert_eq!(got.life.to_bits(),(0.75f32*0.3).to_bits());
  assert_eq!(got.vectors[Field::Scale as usize],[45.,1.,1.5]);
  assert_eq!(got.vectors[Field::QuadRotation as usize],[0.,45.,0.]);
  assert_eq!(got.shared_uv,0.875);assert_eq!(got.color,[1.;4]);expect_draws(&rng,5);
 }
 #[test] fn batch_age_is_shared_but_birth_time_position_and_authored_constant_tables_remain_distinct(){
  for index in 0..2 {
   let p=Profile::load(index).unwrap();assert_eq!(p.life.table.len(),1);assert_eq!(p.birth_color.table.len(),1);
   assert!(p.vectors.fields.iter().all(|v|v.table.len()==1));assert!(p.uv.parameters.iter().all(|v|v.table.len()==1));
   let first=sample_birth(&p,input(),&mut fractions()).unwrap();let mut end=input();end.index=1;
   let last=sample_birth(&p,end,&mut fractions()).unwrap();
   assert_eq!(first.emitter_age,last.emitter_age);assert_eq!(first.schedule.time,0.0625);assert_eq!(last.schedule.time,0.125);
   assert_eq!(first.schedule.position,[2.,4.,6.]);assert_eq!(last.schedule.position,[4.,8.,12.]);
   assert_eq!(first.life.to_bits(),last.life.to_bits());assert_eq!(first.vectors,last.vectors);
  }
  // A deliberately varied table distinguishes batch-age lookup from per-particle birth age.
  let mut p=Profile::load(0).unwrap();p.parameters.life.table=vec![2.,4.];p.parameters.life.probability.constant=true;p.parameters.life.probability.constant_value=1.;
  let mut varied=input();varied.instance_duration=0.2;
  let got=sample_birth(&p,varied,&mut fractions()).unwrap();assert_eq!(got.life,4.);
  assert!(got.emitter_age>0.5);assert!(p.timing.emitter_age_input(got.schedule.time,0.,varied.instance_duration).evaluate().normalized<0.5);
 }
}
