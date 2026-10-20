//! Pure 941F00 -> 944E20 arithmetic for E's Simple groups, after the caller
//! has resolved controller gates and pose. No entity, renderer, network lookup,
//! factory, event replay, animation callback or implicit global-life policy.
use openleague_core::{native_random::Rng55,native_simple_emission_count as count,
    native_simple_emission_lifecycle as emission,native_simple_particle_update as particles,
    native_simple_birth_parameters as birth,native_simple_emission_sources as sources,
    native_simple_birth_factors as factors,native_simple_rotation_list as rotations,
    native_particle_force_graph as forces,native_scalar_parameter::ScalarParameter};
use crate::ezreal_e_simple_parameters::Parameters;
pub(crate) const MAX_SLOTS:usize=512;
pub(crate) const MAX_BIRTHS_PER_STEP:i32=256;
pub(crate) const MAX_STEP:f32=0.25;
/// All control/instance inputs are required. These fields are not native values
/// inferred from another effect. Caller must name its local binding separately.
pub(crate) struct Emission<'a> {
    pub enabled:bool,pub start:f32,pub life:f32,pub delay:f32,pub period:f32,pub window:f32,
    pub single:u32,pub progress:f32,pub rate_factor:f32,
    pub attributes:sources::Attributes<'a>,pub factors:factors::Sources<'a>,
    pub rotations:&'a [rotations::Source<'a>],pub rate_attribute:Option<&'a birth::RateAttribute<'a>>,
}
/// `previous_inverse` means the native frame-tail inverse for the previous pose,
/// not a fixed champion-root inverse retained across the whole projectile flight.
#[derive(Clone,Copy,Debug,PartialEq,Eq)]
pub(crate) struct Pose {pub previous:[u32;16],pub current:[u32;16],pub previous_inverse:[u32;16]}
pub(crate) struct Dynamics<'a> {
    pub particle_cap:f32,pub bounds_flag:u8,pub sticky:u8,pub local:u8,pub circular:u8,pub direction:u32,
    pub force_resource:u32,pub force_graph:Option<&'a forces::Input<'a>>,
    pub scalar_enabled:u8,pub scalar_over_life:&'a ScalarParameter,pub terrain:u8,
}
pub(crate) struct Frame<'a> {pub ordinal:u64,pub time:f32,pub pose:Pose,pub emission:Emission<'a>,pub dynamics:Dynamics<'a>}
#[derive(Clone)]
pub(crate) struct State {storage:particles::State,birth:Vec<u32>,owner:emission::State,
    clock:f32,ordinal:u64,pose:Pose,binding:Option<(crate::ezreal_e_simple_parameters::Group,&'static str,u32)>}
fn table(p:&ScalarParameter)->particles::Table<'_>{particles::Table {values:&p.table,probability:Some(&p.probability)}}
impl State {
    /// Explicit local empty allocation. The caller supplies its actual start and
    /// already resolved pose; this does not claim a recovered native constructor.
    pub(crate) fn new(time:f32,pose:Pose)->Result<Self,&'static str>{
        if !time.is_finite()||time<0.{return Err("E Simple start invalid");}validate_pose(pose)?;
        let center=pose.current[12..15].try_into().unwrap();
        Ok(Self {storage:particles::State {last_time:time.to_bits(),life:vec![],ages:vec![],active:0,
            positions:vec![],velocities:vec![],scales:vec![],factors:vec![],scalar:vec![],rates:vec![],auxiliary:vec![],
            attribute_a:vec![],attribute_b:vec![],previous_heights:vec![],bounds:openleague_core::native_simple_bounds_policy::State {
                bounds:openleague_core::native_simple_particle_bounds::Bounds {minimum:center,maximum:center},center,last:time.to_bits()},counter:0},
            birth:vec![],owner:emission::State {previous:time.to_bits(),emitted:0,counter:0,bounds_factor:1f32.to_bits()},clock:time,ordinal:0,pose,binding:None})
    }
    pub(crate) fn particles(&self)->&particles::State{&self.storage}
    pub(crate) fn births(&self)->&[u32]{&self.birth}
    pub(crate) fn live_indices(&self)->impl Iterator<Item=usize>+'_ {
        self.storage.ages.iter().enumerate().filter(|(_,a)|f32::from_bits(**a)<1.).map(|(i,_)|i)
    }
    /// State and caller RNG are read-only. Commit both returned values together.
    /// Terrain callbacks may observe attempted calls on error, as in the native
    /// primitive; their external side effects are not part of this transaction.
    pub(crate) fn plan(&self,p:&Parameters,frame:&Frame,rng:&Rng55,
        height:&mut impl FnMut([u32;3])->Result<u32,&'static str>)->Result<(Self,Rng55),&'static str>{
        let dt=frame.time-self.clock;
        if frame.ordinal==0||frame.ordinal<=self.ordinal||!dt.is_finite()||!(0. ..=MAX_STEP).contains(&dt)
            ||rng.first>=55||rng.second>=55{return Err("E Simple ordinal/clock/RNG invalid");}
        validate_pose(frame.pose)?;p.validate()?;
        if p.group==crate::ezreal_e_simple_parameters::Group::ArrivalHead
            && frame.dynamics.particle_cap.to_bits()!=f32::MAX.to_bits() {
            return Err("E arrival head requires its explicit local live-cap policy");
        }
        let e=&frame.emission;let d=&frame.dynamics;
        let binding=(p.group,p.provenance,e.start.to_bits());
        if self.binding.is_some_and(|old|old!=binding){return Err("E Simple group/binding/start changed");}
        if ![frame.time,e.start,e.life,e.delay,e.period,e.window,e.progress,e.rate_factor,d.particle_cap].iter().all(|v|v.is_finite())
            ||frame.time<e.start||e.life<=0.||e.period<=0.||e.window<0.||e.progress<0.||e.rate_factor<0.||d.particle_cap<=0.
            ||e.rotations.len()>32||d.terrain>1||d.local>1||d.sticky>1||d.circular>1||d.bounds_flag>1||d.scalar_enabled>1
            ||(d.force_resource==0)!=d.force_graph.is_none(){return Err("E Simple unresolved/invalid frame inputs");}
        crate::ezreal_e_simple_parameters::validate_scalar(d.scalar_over_life)?;
        if self.ordinal!=0&&frame.pose.previous!=self.pose.current{return Err("E Simple mobile pose chain broken");}
        if dt==0.&&self.ordinal!=0 {
            if frame.pose.current!=self.pose.current{return Err("E Simple pose changed at frozen clock");}
            let mut next=self.clone();next.ordinal=frame.ordinal;return Ok((next,rng.clone()));
        }
        validate_storage(&self.storage,&self.birth)?;
        let mut next=self.clone();let mut random=rng.clone();
        let values=birth::sample_base(&p.life.table,&p.quad_rotation.table,&p.scale.table,&p.angular_velocity.table,e.progress)?;
        let base=birth::BaseBirth {values,position:birth::sample_vector(&p.position_offset.table,e.progress)?,
            velocity:birth::sample_vector(&p.velocity.table,e.progress)?,offset:birth::sample_vector(&p.offset.table,e.progress)?};
        let curves=birth::BirthCurves {life:Some(&p.life.probability),factor:Some(&p.scale.probability),scalar:Some(&p.quad_rotation.probability),
            rotation:Some(&p.angular_velocity.probability),position:std::array::from_fn(|i|Some(&p.position_offset.probabilities[i])),
            velocity:std::array::from_fn(|i|Some(&p.velocity.probabilities[i])),offset:std::array::from_fn(|i|Some(&p.offset.probabilities[i]))};
        let source=sources::Sources {base:&base,curves:&curves,attributes:sources::Attributes {life:e.attributes.life,position:e.attributes.position,
            velocity:e.attributes.velocity,rotation:e.attributes.rotation,offset:e.attributes.offset},factors:&e.factors,rotations:e.rotations,
            rate_table:&p.rate.table,rate_probability:Some(&p.rate.probability),rate_factor:e.rate_factor,rate_attribute:e.rate_attribute};
        let previous_position=frame.pose.previous[12..15].try_into().unwrap();let current_position=frame.pose.current[12..15].try_into().unwrap();
        let scale=table(&p.xscale);
        let timing=count::Input {time:frame.time,start:e.start,previous:f32::from_bits(next.owner.previous),life:e.life,delay:e.delay,
            period:e.period,window:e.window,rate:0.,single:e.single,emitted:next.owner.emitted};
        if e.enabled {
            // Evaluate the same pure rate/count prefix on a disposable RNG first.
            // Prevent oversized allocations before the native insertion loop. The
            // real call below retains original rate/auxiliary/probability order.
            if count::eligible(timing)? {
                let mut probe=random.clone();let mut rate=birth::sample_rate(&p.rate.table,Some(&p.rate.probability),e.progress,e.rate_factor,&mut probe)?;
                if let Some(a)=e.rate_attribute{rate=birth::augment_rate(rate,e.progress,a,&mut probe)?;}
                let number=count::evaluate(count::Input {rate,..timing})?;
                let reusable=next.storage.ages.iter().filter(|a|f32::from_bits(**a)>=1.).count();
                if !(0..=MAX_BIRTHS_PER_STEP).contains(&number)
                    ||next.birth.len().saturating_add((number as usize).saturating_sub(reusable))>MAX_SLOTS
                    ||next.owner.counter.checked_add(number as u32).is_none(){return Err("E Simple emission budget/counter exceeded");}
            }
            let geometry=emission::Prepared {life:values.life,scalar:values.scalar,rate:values.rotation,factor:values.factor,
                offset:base.offset,position_offset:base.position,velocity:base.velocity,matrix:frame.pose.current,
                previous_position,current_position,bounds_factor:next.owner.bounds_factor,scale,terrain:d.terrain};
            sources::emit(&mut next.owner,timing,e.progress,&source,&geometry,&mut next.storage,&mut next.birth,&mut random,height)?;
        }
        particles::update(&particles::Input {time:frame.time.to_bits(),cap:d.particle_cap.to_bits(),birth:&next.birth,bounds_flag:d.bounds_flag,
            previous_position,current_position,initial_inverse:frame.pose.previous_inverse,current_matrix:frame.pose.current,
            bind_begin:p.bind[0].to_bits(),bind_end:p.bind[1].to_bits(),sticky:d.sticky,local:d.local,circular:d.circular,direction:d.direction,
            force_resource:d.force_resource,force_graph:d.force_graph,scalar_enabled:d.scalar_enabled,scalar_table:table(d.scalar_over_life),
            scale_table:scale,attributes:p.attributes,bounds_factor:next.owner.bounds_factor,terrain_enabled:d.terrain},
            &mut next.storage,&mut random,height,&mut |_|{})?;
        validate_storage(&next.storage,&next.birth)?;
        next.clock=frame.time;next.ordinal=frame.ordinal;next.pose=frame.pose;next.binding=Some(binding);Ok((next,random))
    }
}
fn validate_pose(pose:Pose)->Result<(),&'static str>{
    if pose.current.iter().chain(&pose.previous).chain(&pose.previous_inverse).any(|v|!f32::from_bits(*v).is_finite()){
        return Err("E Simple mobile pose nonfinite");}Ok(())
}
fn validate_storage(s:&particles::State,birth:&[u32])->Result<(),&'static str>{
    let n=birth.len();if n>MAX_SLOTS||[s.life.len(),s.ages.len(),s.positions.len(),s.velocities.len(),s.scales.len(),s.factors.len(),
        s.scalar.len(),s.rates.len(),s.auxiliary.len(),s.attribute_a.len(),s.attribute_b.len()].iter().any(|len|*len!=n)
        ||s.previous_heights.len()>MAX_SLOTS{return Err("E Simple storage budget/alignment invalid");}
    if s.life.iter().any(|v|!f32::from_bits(*v).is_finite()||f32::from_bits(*v)<=0.)
        ||birth.iter().chain(&s.ages).chain(&s.scales).chain(&s.factors).chain(&s.scalar).chain(&s.rates).chain(&s.auxiliary)
        .chain(&s.attribute_a).chain(&s.attribute_b).chain(&s.previous_heights).chain(s.positions.iter().flatten())
        .chain(s.velocities.iter().flatten()).any(|v|!f32::from_bits(*v).is_finite()) {return Err("E Simple nonfinite/invalid particle output");}Ok(())
}
#[cfg(test)]
#[path="ezreal_e_simple_simulation_tests.rs"]
mod tests;
