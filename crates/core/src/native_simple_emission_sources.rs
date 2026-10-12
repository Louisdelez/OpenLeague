//! Composed941F00 producers. Native descriptor population remains caller-owned.
use crate::{native_simple_birth_parameters as b,native_simple_birth_factors as factors,native_simple_rotation_list as rotations,native_simple_emission_lifecycle as emission,native_simple_emission_count as count,native_simple_particle_update::{State,Table},native_random::Rng55,native_probability_curve::ProbabilityCurve};
/// Bridge for9437E0's Sources::emission callback. Pose comes from943300; no
/// independent owner matrix or translation is synthesized by the birth adapter.
pub fn emit_from_frame(time:u32,progress:u32,resource:u32,storage:&mut Option<State>,birth:&mut Vec<u32>,pose:&crate::native_simple_pose::State,owner:&mut emission::State,rng:&mut Rng55,mut timing:count::Input,sources:&Sources,scale:Table,terrain:u8,height:&mut impl FnMut([u32;3])->Result<u32,&'static str>)->Result<i32,&'static str>{
    if resource==0{return Err("native particle allocation unqualified");}
    let storage=storage.as_mut().ok_or("missing native particle storage")?;
    timing.time=f32::from_bits(time);
    let base=sources.base;
    let geometry=emission::Prepared {life:base.values.life,scalar:base.values.scalar,rate:base.values.rotation,factor:base.values.factor,offset:base.offset,position_offset:base.position,velocity:base.velocity,matrix:pose.current,previous_position:pose.previous[12..15].try_into().unwrap(),current_position:pose.current[12..15].try_into().unwrap(),bounds_factor:owner.bounds_factor,scale,terrain};
    emit(owner,timing,f32::from_bits(progress),sources,&geometry,storage,birth,rng,height)
}
pub struct Attributes<'a> {pub life:Option<&'a b::LifeAttribute<'a>>,pub position:Option<&'a b::VectorAttribute<'a>>,pub velocity:Option<&'a b::VectorAttribute<'a>>,pub rotation:Option<&'a b::ScalarAttribute<'a>>,pub offset:Option<&'a b::VectorAttribute<'a>>}
pub struct Sources<'a> {pub base:&'a b::BaseBirth,pub curves:&'a b::BirthCurves<'a>,pub attributes:Attributes<'a>,pub factors:&'a factors::Sources<'a>,pub rotations:&'a [rotations::Source<'a>],pub rate_table:&'a [f32],pub rate_probability:Option<&'a ProbabilityCurve>,pub rate_factor:f32,pub rate_attribute:Option<&'a b::RateAttribute<'a>>}
struct Prepared<'a> {sources:&'a Sources<'a>,life:u32,position:[u32;3],velocity:[u32;3],rotation:u32,offset_weight:[u32;3],factors:factors::Prepared,rotations:Vec<rotations::Element<'a>>}
impl<'a> Prepared<'a> {
    fn sample(s:&'a Sources<'a>,progress:f32)->Result<Self,&'static str>{
        let life=match s.attributes.life{Some(a)=>b::prepare_attribute_life(s.base.values.life,progress,a)?,None=>s.base.values.life};
        let position=match s.attributes.position{Some(a)=>b::prepare_attribute_vector(s.base.position,progress,a)?,None=>s.base.position};
        let velocity=match s.attributes.velocity{Some(a)=>b::prepare_attribute_vector(s.base.velocity,progress,a)?,None=>s.base.velocity};
        let rotation=match s.attributes.rotation{Some(a)=>b::prepare_attribute_scalar(s.base.values.rotation,progress,a)?,None=>s.base.values.rotation};
        let offset_weight=match s.attributes.offset{Some(a)=>b::sample_vector(a.table,progress)?,None=>[0;3]};
        Ok(Self {sources:s,life,position,velocity,rotation,offset_weight,factors:factors::prepare(s.factors)?,rotations:rotations::sample(s.rotations,progress)?})
    }
    fn birth(&self,rng:&mut Rng55)->Result<emission::Birth,&'static str>{
        let s=self.sources;let c=s.curves;
        let life=match s.attributes.life{Some(a)=>b::attribute_life_birth_raw(self.life,c.life,a,rng)?,None=>b::probability(self.life,c.life,rng)};
        let vector=|base:[u32;3],curves:[Option<&ProbabilityCurve>;3],attribute:Option<&b::VectorAttribute>,rng:&mut Rng55|match attribute{Some(a)=>b::attribute_vector_birth(base,curves,a,rng),None=>std::array::from_fn(|j|b::probability(base[j],curves[j],rng))};
        let mut born=s.base.birth_with_offset_source(c,rng,life,
            &mut |rng|vector(self.position,c.position,s.attributes.position,rng),
            &mut |rng|vector(self.velocity,c.velocity,s.attributes.velocity,rng),
            &mut |rng|match s.attributes.rotation{Some(a)=>b::attribute_scalar_birth(self.rotation,c.rotation,a,rng),None=>b::probability(self.rotation,c.rotation,rng)},
            &mut |rng|match s.attributes.offset{Some(a)=>b::offset_attribute_birth(s.base.offset,self.offset_weight,c.offset,a,rng),None=>std::array::from_fn(|j|b::probability(s.base.offset[j],c.offset[j],rng))});
        self.factors.apply(&mut born)?;Ok(born)
    }
}
/// Compose source stages with auxiliary draw, rotation lists and insertion.
/// The lifecycle commits owned emitter/particle/RNG state together. Source
/// descriptors, storage and pose must be supplied; no resource defaults invented.
pub fn emit(state:&mut emission::State,timing:count::Input,progress:f32,sources:&Sources,geometry:&emission::Prepared,storage:&mut State,birth:&mut Vec<u32>,rng:&mut Rng55,height:&mut impl FnMut([u32;3])->Result<u32,&'static str>)->Result<i32,&'static str>{
    let mut gate=timing;gate.previous=f32::from_bits(state.previous);gate.emitted=state.emitted;
    if !count::eligible(gate)?{return Ok(0);}
    // Rate draws precede count evaluation and all raw birth-source sampling.
    // A zero count commits the rate RNG and never reads birth descriptors.
    let mut random=rng.clone();
    gate.rate=b::sample_rate(sources.rate_table,sources.rate_probability,progress,sources.rate_factor,&mut random)?;
    if let Some(a)=sources.rate_attribute{gate.rate=b::augment_rate(gate.rate,progress,a,&mut random)?;}
    if count::evaluate(gate)?==0{*rng=random;return Ok(0);}
    let p=Prepared::sample(sources,progress)?;
    let g=emission::Prepared {life:p.life,scalar:sources.base.values.scalar,rate:sources.base.values.rotation,factor:sources.base.values.factor,offset:geometry.offset,position_offset:geometry.position_offset,velocity:geometry.velocity,matrix:geometry.matrix,previous_position:geometry.previous_position,current_position:geometry.current_position,bounds_factor:p.factors.bounds,scale:Table {values:geometry.scale.values,probability:geometry.scale.probability},terrain:geometry.terrain};
    let result=emission::update_with_rotation_source(state,gate,&g,storage,birth,&mut random,height,
        &mut |_,rng|p.birth(rng),
        &mut |_,offset,velocity,rng|rotations::evaluate(&p.rotations,rng)?.apply(offset,velocity))?;
    *rng=random;Ok(result)
}
