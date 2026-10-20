//! Pure mobile E Complex state. No scene, actor, target, clock, GPU or network
//! lookup occurs here. All instance policy is supplied by the composing host.
use openleague_core::{native_random::Rng55,native_complex_particle_storage::Record};
use crate::{ezreal_e_complex_engine as engine,ezreal_e_complex_parameters::{Parameters,Rotation}};
pub(crate) use engine::{Instance,FrameInputs as Dynamics};
pub(crate) const MAX_STEP:f32=0.25;
pub(crate) const MAX_PARTICLES:usize=256;

#[derive(Clone,Copy,Debug)]
pub(crate) struct BirthSource {
    /// Current owner orientation, without translation; schedule supplies XYZ.
    pub orientation:[f32;16],
    /// Actual primary source matrix or an explicitly named local binding.
    pub primary:[f32;16],
    pub world_acceleration:[f32;3],pub orbit_secondary:[f32;3],pub uv_aux:[f32;2],
    pub rate_multiplier:f32,pub distance_anchor:f32,
}
#[derive(Clone,Copy,Debug)]
pub(crate) struct Frame {
    pub provenance:&'static str,pub ordinal:u64,pub time:f32,
    pub previous_position:[f32;3],pub current_position:[f32;3],
    pub instance:Instance,pub birth:BirthSource,pub dynamics:Dynamics,
}
#[derive(Clone,Debug)]
pub(crate) struct State {
    host:engine::Host,retained:Vec<Rotation>,binding:(&'static str,u32),
}
fn finite(v:impl Iterator<Item=f32>)->bool{v.into_iter().all(f32::is_finite)}
fn affine(matrix:&[f32;16])->bool{
    finite(matrix.iter().copied())&&matrix[3]==0.&&matrix[7]==0.&&matrix[11]==0.&&matrix[15]==1.
}
fn multiply(a:&[f32;16],b:&[f32;16])->[f32;16]{
    std::array::from_fn(|i|{let r=i/4;let c=i%4;
        ((a[r*4]*b[c]+a[r*4+1]*b[4+c])+a[r*4+2]*b[8+c])+a[r*4+3]*b[12+c]})
}
fn words_finite(record:&Record)->bool{
    record.life.iter().chain(&record.motion).chain(&record.surface).chain(&record.color)
        .chain(&record.scale).chain(&record.uv).chain(&record.atlas).chain(&record.field_58)
        .chain(&record.field_64).chain(&record.field_70).chain(&record.field_7c)
        .all(|v|f32::from_bits(*v).is_finite())
}
impl State {
    pub(crate) fn new(parameters:&Parameters,start:f32,position:[f32;3],rng:&Rng55)->Result<(Self,Rng55),&'static str>{
        if parameters.kind!=0||!start.is_finite()||!finite(position.into_iter()){return Err("E Complex initial clock/position invalid");}
        let (retained,random)=parameters.retained(rng)?;
        Ok((Self {host:engine::Host::new(start,position),retained,binding:parameters.binding()},random))
    }
    pub(crate) fn particles(&self)->&[Record]{&self.host.storage.particles}
    pub(crate) fn ordinal(&self)->u64{self.host.ordinal}
    pub(crate) fn time(&self)->f32{if self.host.ordinal==0{self.host.start}else{self.host.last_update}}
    /// Shared RNG is returned, never stored or reseeded here. The outer host
    /// must commit all three group plans atomically in authored group order.
    pub(crate) fn plan(&self,parameters:&Parameters,frame:Frame,rng:&Rng55)->Result<(Self,Rng55),&'static str>{
        let old_time=self.time();let delta=frame.time-old_time;
        let i=frame.instance;let d=frame.dynamics;let b=frame.birth;
        if parameters.kind!=0||self.binding!=parameters.binding()||frame.provenance!=self.binding.0||frame.provenance.trim().is_empty()
            ||frame.ordinal<=self.host.ordinal||frame.ordinal==0||!frame.time.is_finite()||!delta.is_finite()||!(0.0..=MAX_STEP).contains(&delta)
            ||frame.previous_position.map(f32::to_bits)!=self.host.previous_position.map(f32::to_bits)
            ||!finite(frame.current_position.into_iter()) {return Err("E Complex frame provenance/clock/pose invalid");}
        if i.duration<=0.||i.rate_owner_scale<0.||i.life_owner_scale<=0.||i.limit<0||i.life_coefficients!=[0.;3]
            ||!(0.0..2147483648.0).contains(&(parameters.rate.maximum*i.rate_owner_scale))
            ||i.single_flag>1||i.stopped_flag>1||!finite([i.duration,i.rate_owner_scale,i.life_owner_scale].into_iter())
            ||!finite(i.globals.unit.into_iter().chain(i.globals.scale).chain(i.globals.anchor).chain(i.motion_scratch).map(f32::from_bits))
            ||!affine(&b.orientation)||!affine(&b.primary)||b.orientation[12..15]!=[0.;3]
            ||!finite(b.world_acceleration.into_iter().chain(b.orbit_secondary).chain(b.uv_aux).chain([b.rate_multiplier,b.distance_anchor]))
            ||b.rate_multiplier<0.||!finite(d.owner_delta.into_iter().chain(d.owner_extra).chain(d.default_vector)
                .chain([d.scale_owner]).chain(d.lookup_scale).chain(d.lookup_offset))||d.scale_owner<0.
            ||d.lookup_modes.iter().any(|v|!matches!(*v,0|1|3))
            ||d.local_matrix.as_ref().is_some_and(|m|!affine(m))||d.attach_matrix.as_ref().is_some_and(|m|!affine(m)) {
            return Err("E Complex supplied instance/source invalid");
        }
        let owner_delta=std::array::from_fn::<_,3,_>(|a|frame.current_position[a]-frame.previous_position[a]);
        if !finite(owner_delta.into_iter())||d.owner_delta.map(f32::to_bits)!=owner_delta.map(f32::to_bits){return Err("E Complex owner delta differs from supplied poses");}
        if self.host.ordinal!=0&&delta==0.{
            if frame.current_position.map(f32::to_bits)!=frame.previous_position.map(f32::to_bits){return Err("E Complex moving pose on frozen clock");}
            let mut next=self.clone();next.host.ordinal=frame.ordinal;return Ok((next,rng.clone()));
        }
        let Some((host,random))=self.host.planned_frame(frame.ordinal,parameters,&self.retained,frame.time,
            frame.current_position,i,d,rng,|birth,ordinal,_|{
                let mut pose=b.orientation;pose[12..15].copy_from_slice(&birth.schedule.position);
                let pose=multiply(&pose,&b.primary);
                let merged_offset=std::array::from_fn(|axis|birth.vectors[openleague_core::native_complex_vectors::Field::Offset as usize][axis]
                    +birth.vectors[openleague_core::native_complex_vectors::Field::PostOffset as usize][axis]);
                Ok(engine::PreparedBirth {pose,merged_offset,world_acceleration:b.world_acceleration,orbit_secondary:b.orbit_secondary,
                    uv_aux:b.uv_aux,rate_multiplier:b.rate_multiplier,distance_anchor:b.distance_anchor,emitter_ordinal:ordinal})
            })? else{return Err("E Complex stale plan");};
        if host.storage.particles.len()>MAX_PARTICLES||host.storage.particles.iter().any(|r|!words_finite(r)){
            return Err("E Complex particle output invalid; state and RNG not committed");
        }
        Ok((Self {host,retained:self.retained.clone(),binding:self.binding},random))
    }
}

#[cfg(test)]
#[path="ezreal_e_complex_simulation_tests.rs"]
mod tests;
