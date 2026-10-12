//!941F00 scalar/vector source stages; attribute sources and resource binding pending.
use crate::{native_scalar_parameter::baked_scalar_index,native_probability_curve::{ProbabilityCurve,apply_probability},native_random::Rng55};
#[derive(Clone,Copy,Debug)]
pub struct Values {pub life:u32,pub scalar:u32,pub factor:u32,pub rotation:u32}
///948FB0 lookup intentionally does not consume the descriptor probability.
pub fn sample(table:&[f32],progress:f32)->Result<u32,&'static str> {
    if !table.iter().all(|v|v.is_finite()){return Err("unqualified nonfinite birth table");}
    let index=baked_scalar_index(table.len(),progress).map_err(|_|"invalid birth table")?;
    Ok(table[index].to_bits())
}
pub fn sample_base(life:&[f32],scalar:&[f32],factor:&[f32],rotation:&[f32],progress:f32)->Result<Values,&'static str> {
    Ok(Values {life:sample(life,progress)?,scalar:sample(scalar,progress)?,factor:sample(factor,progress)?,rotation:sample(rotation,progress)?})
}
/// Per-birth probability stage. Caller must retain native ordering with vector
/// and attribute draws; this helper does not schedule the complete emission.
pub fn probability(value:u32,curve:Option<&ProbabilityCurve>,rng:&mut Rng55)->u32 {
    apply_probability(curve,f32::from_bits(value),rng).to_bits()
}
///942B99 negative life fallback, before native insertion. Zero stays zero.
pub fn lifetime(value:u32)->u32 {if f32::from_bits(value)<0.{0x7f7fffff}else{value}}

///949210 copies the indexed vector without consuming component probabilities.
pub fn sample_vector(table:&[[f32;3]],progress:f32)->Result<[u32;3],&'static str> {
    if !table.iter().flatten().all(|v|v.is_finite()){return Err("unqualified nonfinite birth vector table");}
    let index=baked_scalar_index(table.len(),progress).map_err(|_|"invalid birth vector table")?;
    Ok(table[index].map(f32::to_bits))
}
pub struct BaseBirth {pub values:Values,pub position:[u32;3],pub velocity:[u32;3],pub offset:[u32;3]}
pub struct BirthCurves<'a> {
    pub life:Option<&'a ProbabilityCurve>,pub factor:Option<&'a ProbabilityCurve>,pub scalar:Option<&'a ProbabilityCurve>,pub rotation:Option<&'a ProbabilityCurve>,
    pub position:[Option<&'a ProbabilityCurve>;3],pub velocity:[Option<&'a ProbabilityCurve>;3],pub offset:[Option<&'a ProbabilityCurve>;3],
}
fn vector_probability(base:[u32;3],curves:[Option<&ProbabilityCurve>;3],rng:&mut Rng55)->[u32;3] {
    std::array::from_fn(|j|probability(base[j],curves[j],rng))
}
impl BaseBirth {
    /// Selected941F00 source path with attribute flags and rotation list absent.
    /// Native order: life, positionXYZ, scale, scalar, velocityXYZ, rotation,
    /// offsetXYZ. Lifecycle consumes auxiliary/insertion RNG after this stage.
    pub fn birth(&self,curves:&BirthCurves,rng:&mut Rng55)->crate::native_simple_emission_lifecycle::Birth {
        let life=lifetime(probability(self.values.life,curves.life,rng));
        self.birth_after_life(curves,rng,life)
    }
    /// Continue native source order after a supplied, fully evaluated life stage.
    pub fn birth_after_life(&self,curves:&BirthCurves,rng:&mut Rng55,life:u32)->crate::native_simple_emission_lifecycle::Birth {
        self.birth_with_vectors(curves,rng,life,&mut |rng|vector_probability(self.position,curves.position,rng),&mut |rng|vector_probability(self.velocity,curves.velocity,rng))
    }
    /// Source callbacks occupy the native position and velocity stages. Scalar,
    /// rotation and offset draws remain interleaved with their original order.
    pub fn birth_with_vectors(&self,curves:&BirthCurves,rng:&mut Rng55,life:u32,position:&mut impl FnMut(&mut Rng55)->[u32;3],velocity:&mut impl FnMut(&mut Rng55)->[u32;3])->crate::native_simple_emission_lifecycle::Birth {
        self.birth_with_attribute_rotation(curves,rng,life,position,velocity,&mut |rng|probability(self.values.rotation,curves.rotation,rng))
    }
    /// Preserve rotation's stage after velocity and before offset probability.
    pub fn birth_with_attribute_rotation(&self,curves:&BirthCurves,rng:&mut Rng55,life:u32,position:&mut impl FnMut(&mut Rng55)->[u32;3],velocity:&mut impl FnMut(&mut Rng55)->[u32;3],rotation:&mut impl FnMut(&mut Rng55)->u32)->crate::native_simple_emission_lifecycle::Birth {
        self.birth_with_offset_source(curves,rng,life,position,velocity,rotation,&mut |rng|vector_probability(self.offset,curves.offset,rng))
    }
    /// Final11C offset stage follows rotation108 probability and precedes the
    /// auxiliary/list draws. Source owns raw-weight sampling and attribute lookup.
    pub fn birth_with_offset_source(&self,curves:&BirthCurves,rng:&mut Rng55,life:u32,position:&mut impl FnMut(&mut Rng55)->[u32;3],velocity:&mut impl FnMut(&mut Rng55)->[u32;3],rotation:&mut impl FnMut(&mut Rng55)->u32,offset:&mut impl FnMut(&mut Rng55)->[u32;3])->crate::native_simple_emission_lifecycle::Birth {
        let position_offset=position(rng);
        let factor=probability(self.values.factor,curves.factor,rng);
        let scalar=probability(self.values.scalar,curves.scalar,rng);
        let velocity=velocity(rng);
        let rotation=rotation(rng);
        let offset=offset(rng);
        crate::native_simple_emission_lifecycle::Birth {life,scalar,rotation,factor,offset,position_offset,velocity}
    }
}

///948EE0 rate sampler followed by contextEC multiplication. Rate attribute
/// augmentation93FB10 must be provided separately when its native flag is set.
pub fn sample_rate(table:&[f32],curve:Option<&ProbabilityCurve>,progress:f32,factor:f32,rng:&mut Rng55)->Result<f32,&'static str> {
    if !factor.is_finite(){return Err("unqualified emission context factor");}
    let base=sample(table,progress)?;
    let result=f32::from_bits(probability(base,curve,rng))*factor;
    if !result.is_finite(){return Err("unqualified nonfinite effective emission rate");}
    Ok(result)
}
pub struct RateAttribute<'a> {pub key:u32,pub table:&'a [f32],pub probability:Option<&'a ProbabilityCurve>,pub attributes:&'a crate::native_particle_attributes::Attributes}
///941FCF..942002 sampled weight precedes attribute lookup, even when missing.
/// Preserve the multiplication/addition intermediate before the final f32 store.
/// Selected finite native profiles qualified; x87 rounding extremes pending.
pub fn augment_rate(base:f32,progress:f32,attribute:&RateAttribute,rng:&mut Rng55)->Result<f32,&'static str> {
    if !base.is_finite(){return Err("unqualified nonfinite base emission rate");}
    let weight=sample_rate(attribute.table,attribute.probability,progress,1.,rng)?;
    let value=f32::from_bits(attribute.attributes.read(attribute.key));
    let result=((value as f64)*(weight as f64)+(base as f64)) as f32;
    if !result.is_finite(){return Err("unqualified nonfinite augmented emission rate");}
    Ok(result)
}
pub struct LifeAttribute<'a> {pub key:u32,pub table:&'a [f32],pub probability:Option<&'a ProbabilityCurve>,pub attributes:&'a crate::native_particle_attributes::Attributes}
///9420D7..94210A reads raw attribute weight without its probability.
pub fn prepare_attribute_life(base:u32,progress:f32,attribute:&LifeAttribute)->Result<u32,&'static str> {
    let weight=f32::from_bits(sample(attribute.table,progress)?);
    let value=f32::from_bits(attribute.attributes.read(attribute.key));
    let result=((value as f64)*(weight as f64)+(f32::from_bits(base) as f64)) as f32;
    if !result.is_finite(){return Err("unqualified prepared attribute life");}
    Ok(result.to_bits())
}
///942530..942623: own probability first, then attribute probability applied to
/// augmented life70, followed by attribute multiplication/addition. Raw weight
/// is not the per-birth probability base. Negative fallback happens afterwards.
/// Selected finite x87 profiles qualified; rounding extremes remain pending.
pub fn attribute_life_birth(prepared:u32,own:Option<&ProbabilityCurve>,attribute:&LifeAttribute,rng:&mut Rng55)->Result<u32,&'static str> {
    attribute_life_birth_raw(prepared,own,attribute,rng).map(lifetime)
}
pub fn attribute_life_birth_raw(prepared:u32,own:Option<&ProbabilityCurve>,attribute:&LifeAttribute,rng:&mut Rng55)->Result<u32,&'static str> {
    let own=f32::from_bits(probability(prepared,own,rng));
    let value=f32::from_bits(attribute.attributes.read(attribute.key));
    let weighted=f32::from_bits(probability(prepared,attribute.probability,rng));
    let result=((value as f64)*(weighted as f64)+(own as f64)) as f32;
    if !result.is_finite(){return Err("unqualified attribute birth life");}
    Ok(result.to_bits())
}
pub struct VectorAttribute<'a> {pub key:u32,pub table:&'a [[f32;3]],pub probability:[Option<&'a ProbabilityCurve>;3],pub attributes:&'a crate::native_particle_attributes::Attributes}
/// Initial vector attribute stage949210 followed by separate SSE mul/add.
pub fn prepare_attribute_vector(base:[u32;3],progress:f32,attribute:&VectorAttribute)->Result<[u32;3],&'static str> {
    let weight=sample_vector(attribute.table,progress)?;
    let value=f32::from_bits(attribute.attributes.read(attribute.key));
    let result=std::array::from_fn(|j|{let product=value*f32::from_bits(weight[j]);(product+f32::from_bits(base[j])).to_bits()});
    if !result.iter().all(|v|f32::from_bits(*v).is_finite()){return Err("unqualified prepared attribute vector");}
    Ok(result)
}
///9492F0 per-birth component probabilities. Both own and attribute probabilities
/// use the augmented vector. Final nonfinite values are rejected transactionally
/// by the lifecycle's per-birth source validation.
pub fn attribute_vector_birth(prepared:[u32;3],own:[Option<&ProbabilityCurve>;3],attribute:&VectorAttribute,rng:&mut Rng55)->[u32;3] {
    let own=vector_probability(prepared,own,rng);
    let value=f32::from_bits(attribute.attributes.read(attribute.key));
    let weighted=vector_probability(prepared,attribute.probability,rng);
    std::array::from_fn(|j|{let product=value*f32::from_bits(weighted[j]);(product+f32::from_bits(own[j])).to_bits()})
}
///942A45..942B4C final11C offset: own probabilities, then lookup and probability
/// on RAW348 weight, followed by separate f32 multiply/add. There is no earlier
/// attribute augmentation here. Caller samples weight with sample_vector.
pub fn offset_attribute_birth(base:[u32;3],raw_weight:[u32;3],own:[Option<&ProbabilityCurve>;3],attribute:&VectorAttribute,rng:&mut Rng55)->[u32;3] {
    let own=vector_probability(base,own,rng);
    let value=f32::from_bits(attribute.attributes.read(attribute.key));
    let weighted=vector_probability(raw_weight,attribute.probability,rng);
    std::array::from_fn(|j|{let product=value*f32::from_bits(weighted[j]);(product+f32::from_bits(own[j])).to_bits()})
}
pub type ScalarAttribute<'a> = LifeAttribute<'a>;
/// Raw-weight scalar preparation is shared by life and rotation, without draws.
pub fn prepare_attribute_scalar(base:u32,progress:f32,attribute:&ScalarAttribute)->Result<u32,&'static str> {
    prepare_attribute_life(base,progress,attribute)
}
/// Own probability then attribute probability applied to augmented scalar.
/// Rotation remains signed. Final nonfinite output is rejected by lifecycle
/// validation; selected finite x87 profiles are qualified, extremes pending.
pub fn attribute_scalar_birth(prepared:u32,own:Option<&ProbabilityCurve>,attribute:&ScalarAttribute,rng:&mut Rng55)->u32 {
    let own=f32::from_bits(probability(prepared,own,rng));
    let value=f32::from_bits(attribute.attributes.read(attribute.key));
    let weighted=f32::from_bits(probability(prepared,attribute.probability,rng));
    (((value as f64)*(weighted as f64)+(own as f64)) as f32).to_bits()
}
#[cfg(test)]
mod tests {
    use super::*;use serde_json::Value;use crate::native_simple_emission_lifecycle::{State,Prepared,update};use crate::native_simple_emission_count as count;use crate::native_simple_particle_update::{State as Particles,Table};
    fn words(v:&Value)->Vec<u32>{v.as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect()}
    #[test]
    fn variable_birth_tables_and_constant_probabilities_match40_native_emissions() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/simple_birth_parameters_contract.json")).unwrap();let rows=proof["cases"].as_array().unwrap();assert_eq!(rows.len(),40);
        let identity=std::array::from_fn(|j|if [0,5,10,15].contains(&j){1f32.to_bits()}else{0});
        for (index,row) in rows.iter().enumerate(){let r=&row["cpu"];let f=|key:&str|r[key].as_f64().unwrap() as f32;
            let table=|key:&str|r["tables"][key].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();
            let base=sample_base(&table("0x88"),&table("0xc4"),&table("0xd8"),&table("0x108"),f("progress")).unwrap();
            let constant=crate::native_probability_curve::ProbabilityCurve {present:true,constant:true,constant_value:7.,fast:false,begin:0.,difference:0.,times:vec![],values:vec![]};
            let mut source_rng=Rng55 {words:std::array::from_fn(|j|12345+j as u32*13579),first:0,second:0};
            let life=lifetime(probability(base.life,Some(&constant),&mut source_rng));
            let factor=probability(base.factor,Some(&constant),&mut source_rng);
            let scalar=probability(base.scalar,Some(&constant),&mut source_rng);
            let rotation=probability(base.rotation,Some(&constant),&mut source_rng);
            let mut owner=State {previous:f("previous").to_bits(),emitted:r["latch"].as_u64().unwrap() as u8,counter:0,bounds_factor:0};
            let mut particles=Particles {last_time:0,life:vec![],ages:vec![],active:0,positions:vec![],velocities:vec![],scales:vec![],factors:vec![],scalar:vec![],rates:vec![],auxiliary:vec![],attribute_a:vec![],attribute_b:vec![],previous_heights:vec![],bounds:crate::native_simple_bounds_policy::State {bounds:crate::native_simple_particle_bounds::Bounds {minimum:[0;3],maximum:[0;3]},center:[0;3],last:0},counter:0};
            let mut birth=vec![];let mut rng=Rng55 {words:std::array::from_fn(|j|12345+j as u32*13579),first:0,second:0};
            update(&mut owner,count::Input {time:10.+f("age"),start:10.,previous:f("previous"),life:1.,delay:0.,period:100.,window:100.,rate:f("rate"),single:r["single"].as_u64().unwrap() as u32,emitted:r["latch"].as_u64().unwrap() as u8},&Prepared {life,scalar,rate:rotation,factor,offset:[10f32,20.,30.].map(f32::to_bits),position_offset:[0;3],velocity:[0;3],matrix:identity,previous_position:[60f32,170.,280.].map(f32::to_bits),current_position:[110f32,220.,330.].map(f32::to_bits),bounds_factor:1f32.to_bits(),scale:Table {values:&[1.],probability:None},terrain:0},&mut particles,&mut birth,&mut rng,&mut |_|panic!("native terrain flag is zero")).unwrap();
            let a=&r["arrays"];
            for (actual,key) in [(&birth,"0x8"),(&particles.life,"0x14"),(&particles.ages,"0x20"),(&particles.scales,"0x44"),(&particles.factors,"0x50"),(&particles.scalar,"0x5c"),(&particles.rates,"0x68"),(&particles.auxiliary,"0x74"),(&particles.attribute_a,"0x80"),(&particles.attribute_b,"0x8c"),(&particles.previous_heights,"0x98")]{assert_eq!(*actual,words(&a[key]),"{key} case{index}");}
            assert_eq!(particles.positions.iter().flatten().copied().collect::<Vec<_>>(),words(&a["0x2c"]),"position case{index}");assert_eq!(particles.velocities.iter().flatten().copied().collect::<Vec<_>>(),words(&a["0x38"]),"velocity case{index}");
            for (actual,key) in [(owner.previous,"last_emission"),(owner.counter,"counter"),(owner.bounds_factor,"bounds_factor"),(owner.emitted as u32,"emitted")]{assert_eq!(actual as u64,r[key].as_u64().unwrap(),"{key} case{index}");}
            assert_eq!(rng.words.as_slice(),words(&r["rng"]),"rng case{index}");assert_eq!(rng.first as u64,r["first"].as_u64().unwrap());assert_eq!(rng.second as u64,r["second"].as_u64().unwrap());
        }
    }
    #[test]
    fn per_birth_scalar_draws_match160_whole_native_emissions() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/simple_birth_probability_contract.json")).unwrap();let rows=proof["cases"].as_array().unwrap();assert_eq!(rows.len(),160);
        let identity=std::array::from_fn(|j|if [0,5,10,15].contains(&j){1f32.to_bits()}else{0});
        for (index,row) in rows.iter().enumerate(){let r=&row["cpu"];let f=|key:&str|r[key].as_f64().unwrap() as f32;
            let table=|key:&str|r["tables"][key].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();
            let base=sample_base(&table("0x88"),&table("0xc4"),&table("0xd8"),&table("0x108"),f("progress")).unwrap();
            let mode=r["mode"].as_u64().unwrap();
            let curve=crate::native_probability_curve::ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:7.,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let probability_curve=if mode==0{None}else{Some(&curve)};
            let mut owner=State {previous:f("previous").to_bits(),emitted:r["latch"].as_u64().unwrap() as u8,counter:0,bounds_factor:0};
            let mut particles=Particles {last_time:0,life:vec![],ages:vec![],active:0,positions:vec![],velocities:vec![],scales:vec![],factors:vec![],scalar:vec![],rates:vec![],auxiliary:vec![],attribute_a:vec![],attribute_b:vec![],previous_heights:vec![],bounds:crate::native_simple_bounds_policy::State {bounds:crate::native_simple_particle_bounds::Bounds {minimum:[0;3],maximum:[0;3]},center:[0;3],last:0},counter:0};
            let mut birth=vec![];let mut rng=Rng55 {words:std::array::from_fn(|j|12345+j as u32*13579),first:0,second:0};
            crate::native_simple_emission_lifecycle::update_with_source(&mut owner,count::Input {time:10.+f("age"),start:10.,previous:f("previous"),life:1.,delay:0.,period:100.,window:100.,rate:f("rate"),single:r["single"].as_u64().unwrap() as u32,emitted:r["latch"].as_u64().unwrap() as u8},&Prepared {life:base.life,scalar:base.scalar,rate:base.rotation,factor:base.factor,offset:[10f32,20.,30.].map(f32::to_bits),position_offset:[0;3],velocity:[0;3],matrix:identity,previous_position:[60f32,170.,280.].map(f32::to_bits),current_position:[110f32,220.,330.].map(f32::to_bits),bounds_factor:1f32.to_bits(),scale:Table {values:&[1.],probability:None},terrain:0},&mut particles,&mut birth,&mut rng,&mut |_|panic!("native terrain flag is zero"),&mut |_,rng| {
                let life=lifetime(probability(base.life,probability_curve,rng));
                let factor=probability(base.factor,probability_curve,rng);
                let scalar=probability(base.scalar,probability_curve,rng);
                let rotation=probability(base.rotation,probability_curve,rng);
                Ok(crate::native_simple_emission_lifecycle::Birth {life,scalar,rotation,factor,offset:[10f32,20.,30.].map(f32::to_bits),position_offset:[0;3],velocity:[0;3]})
            }).unwrap();
            let a=&r["arrays"];
            for (actual,key) in [(&birth,"0x8"),(&particles.life,"0x14"),(&particles.ages,"0x20"),(&particles.scales,"0x44"),(&particles.factors,"0x50"),(&particles.scalar,"0x5c"),(&particles.rates,"0x68"),(&particles.auxiliary,"0x74"),(&particles.attribute_a,"0x80"),(&particles.attribute_b,"0x8c"),(&particles.previous_heights,"0x98")]{assert_eq!(*actual,words(&a[key]),"{key} case{index}");}
            assert_eq!(particles.positions.iter().flatten().copied().collect::<Vec<_>>(),words(&a["0x2c"]),"position case{index}");assert_eq!(particles.velocities.iter().flatten().copied().collect::<Vec<_>>(),words(&a["0x38"]),"velocity case{index}");
            for (actual,key) in [(owner.previous,"last_emission"),(owner.counter,"counter"),(owner.bounds_factor,"bounds_factor"),(owner.emitted as u32,"emitted")]{assert_eq!(actual as u64,r[key].as_u64().unwrap(),"{key} case{index}");}
            assert_eq!(rng.words.as_slice(),words(&r["rng"]),"rng case{index}");assert_eq!(rng.first as u64,r["first"].as_u64().unwrap());assert_eq!(rng.second as u64,r["second"].as_u64().unwrap());
        }
    }
    #[test]
    fn interleaved_scalar_vector_sources_match160_native_emissions() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/simple_birth_vectors_contract.json")).unwrap();let rows=proof["cases"].as_array().unwrap();assert_eq!(rows.len(),160);
        let identity=std::array::from_fn(|j|if [0,5,10,15].contains(&j){1f32.to_bits()}else{0});
        for (index,row) in rows.iter().enumerate(){let r=&row["cpu"];let f=|key:&str|r[key].as_f64().unwrap() as f32;
            let table=|key:&str|r["tables"][key].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();
            let base=sample_base(&table("0x88"),&table("0xc4"),&table("0xd8"),&table("0x108"),f("progress")).unwrap();
            let mode=r["mode"].as_u64().unwrap();
            let curve=crate::native_probability_curve::ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:7.,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let probability_curve=if mode==0{None}else{Some(&curve)};
            let vector=|key:&str|r["vector_tables"][key].as_array().unwrap().iter().map(|v|std::array::from_fn(|j|v[j].as_f64().unwrap() as f32)).collect::<Vec<[f32;3]>>();
            let birth_base=BaseBirth {values:base,position:sample_vector(&vector("0xa8"),f("progress")).unwrap(),velocity:sample_vector(&vector("0xec"),f("progress")).unwrap(),offset:sample_vector(&vector("0x11c"),f("progress")).unwrap()};
            let component_curves=|key:&str|std::array::from_fn::<_,3,_>(|j|{let mode=r["vector_modes"][key][j].as_u64().unwrap();ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:0.5,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]}});
            let position_curves=component_curves("0xa8");let velocity_curves=component_curves("0xec");let offset_curves=component_curves("0x11c");
            let curves=BirthCurves {life:probability_curve,factor:probability_curve,scalar:probability_curve,rotation:probability_curve,position:std::array::from_fn(|j|position_curves[j].present.then_some(&position_curves[j])),velocity:std::array::from_fn(|j|velocity_curves[j].present.then_some(&velocity_curves[j])),offset:std::array::from_fn(|j|offset_curves[j].present.then_some(&offset_curves[j]))};
            let mut owner=State {previous:f("previous").to_bits(),emitted:r["latch"].as_u64().unwrap() as u8,counter:0,bounds_factor:0};
            let mut particles=Particles {last_time:0,life:vec![],ages:vec![],active:0,positions:vec![],velocities:vec![],scales:vec![],factors:vec![],scalar:vec![],rates:vec![],auxiliary:vec![],attribute_a:vec![],attribute_b:vec![],previous_heights:vec![],bounds:crate::native_simple_bounds_policy::State {bounds:crate::native_simple_particle_bounds::Bounds {minimum:[0;3],maximum:[0;3]},center:[0;3],last:0},counter:0};
            let mut birth=vec![];let mut rng=Rng55 {words:std::array::from_fn(|j|12345+j as u32*13579),first:0,second:0};
            crate::native_simple_emission_lifecycle::update_with_source(&mut owner,count::Input {time:10.+f("age"),start:10.,previous:f("previous"),life:1.,delay:0.,period:100.,window:100.,rate:f("rate"),single:r["single"].as_u64().unwrap() as u32,emitted:r["latch"].as_u64().unwrap() as u8},&Prepared {life:base.life,scalar:base.scalar,rate:base.rotation,factor:base.factor,offset:[10f32,20.,30.].map(f32::to_bits),position_offset:[0;3],velocity:[0;3],matrix:identity,previous_position:[60f32,170.,280.].map(f32::to_bits),current_position:[110f32,220.,330.].map(f32::to_bits),bounds_factor:1f32.to_bits(),scale:Table {values:&[1.],probability:None},terrain:0},&mut particles,&mut birth,&mut rng,&mut |_|panic!("native terrain flag is zero"),&mut |_,rng| {Ok(birth_base.birth(&curves,rng))}).unwrap();
            let a=&r["arrays"];
            for (actual,key) in [(&birth,"0x8"),(&particles.life,"0x14"),(&particles.ages,"0x20"),(&particles.scales,"0x44"),(&particles.factors,"0x50"),(&particles.scalar,"0x5c"),(&particles.rates,"0x68"),(&particles.auxiliary,"0x74"),(&particles.attribute_a,"0x80"),(&particles.attribute_b,"0x8c"),(&particles.previous_heights,"0x98")]{assert_eq!(*actual,words(&a[key]),"{key} case{index}");}
            assert_eq!(particles.positions.iter().flatten().copied().collect::<Vec<_>>(),words(&a["0x2c"]),"position case{index}");assert_eq!(particles.velocities.iter().flatten().copied().collect::<Vec<_>>(),words(&a["0x38"]),"velocity case{index}");
            for (actual,key) in [(owner.previous,"last_emission"),(owner.counter,"counter"),(owner.bounds_factor,"bounds_factor"),(owner.emitted as u32,"emitted")]{assert_eq!(actual as u64,r[key].as_u64().unwrap(),"{key} case{index}");}
            assert_eq!(rng.words.as_slice(),words(&r["rng"]),"rng case{index}");assert_eq!(rng.first as u64,r["first"].as_u64().unwrap());assert_eq!(rng.second as u64,r["second"].as_u64().unwrap());
        }
    }
    #[test]
    fn rotation_sources_match160_whole_native_emissions() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/simple_rotation_emission_contract.json")).unwrap();let rows=proof["cases"].as_array().unwrap();assert_eq!(rows.len(),160);
        let identity=std::array::from_fn(|j|if [0,5,10,15].contains(&j){1f32.to_bits()}else{0});
        for (index,row) in rows.iter().enumerate(){let r=&row["cpu"];let f=|key:&str|r[key].as_f64().unwrap() as f32;
            let table=|key:&str|r["tables"][key].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();
            let base=sample_base(&table("0x88"),&table("0xc4"),&table("0xd8"),&table("0x108"),f("progress")).unwrap();
            let mode=r["mode"].as_u64().unwrap();
            let curve=crate::native_probability_curve::ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:7.,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let probability_curve=if mode==0{None}else{Some(&curve)};
            let vector=|key:&str|r["vector_tables"][key].as_array().unwrap().iter().map(|v|std::array::from_fn(|j|v[j].as_f64().unwrap() as f32)).collect::<Vec<[f32;3]>>();
            let birth_base=BaseBirth {values:base,position:sample_vector(&vector("0xa8"),f("progress")).unwrap(),velocity:sample_vector(&vector("0xec"),f("progress")).unwrap(),offset:sample_vector(&vector("0x11c"),f("progress")).unwrap()};
            let component_curves=|key:&str|std::array::from_fn::<_,3,_>(|j|{let mode=r["vector_modes"][key][j].as_u64().unwrap();ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:0.5,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]}});
            let position_curves=component_curves("0xa8");let velocity_curves=component_curves("0xec");let offset_curves=component_curves("0x11c");
            let curves=BirthCurves {life:probability_curve,factor:probability_curve,scalar:probability_curve,rotation:probability_curve,position:std::array::from_fn(|j|position_curves[j].present.then_some(&position_curves[j])),velocity:std::array::from_fn(|j|velocity_curves[j].present.then_some(&velocity_curves[j])),offset:std::array::from_fn(|j|offset_curves[j].present.then_some(&offset_curves[j]))};
            let rotation_tables=r["rotation_tables"].as_array().unwrap().iter().map(|t|t.as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>()).collect::<Vec<_>>();
            let rotation_curves=r["rotation_modes"].as_array().unwrap().iter().map(|v|{let mode=v.as_u64().unwrap();ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:0.5,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]}}).collect::<Vec<_>>();
            let rotation_sources=rotation_tables.iter().enumerate().map(|(i,table)|crate::native_simple_rotation_list::Source {table,axis:std::array::from_fn(|j|(r["rotation_axes"][i][j].as_f64().unwrap() as f32).to_bits()),probability:rotation_curves[i].present.then_some(&rotation_curves[i])}).collect::<Vec<_>>();
            let rotation_elements=crate::native_simple_rotation_list::sample(&rotation_sources,f("progress")).unwrap();
            let mut owner=State {previous:f("previous").to_bits(),emitted:r["latch"].as_u64().unwrap() as u8,counter:0,bounds_factor:0};
            let mut particles=Particles {last_time:0,life:vec![],ages:vec![],active:0,positions:vec![],velocities:vec![],scales:vec![],factors:vec![],scalar:vec![],rates:vec![],auxiliary:vec![],attribute_a:vec![],attribute_b:vec![],previous_heights:vec![],bounds:crate::native_simple_bounds_policy::State {bounds:crate::native_simple_particle_bounds::Bounds {minimum:[0;3],maximum:[0;3]},center:[0;3],last:0},counter:0};
            let mut birth=vec![];let mut rng=Rng55 {words:std::array::from_fn(|j|12345+j as u32*13579),first:0,second:0};
            crate::native_simple_emission_lifecycle::update_with_rotation_source(&mut owner,count::Input {time:10.+f("age"),start:10.,previous:f("previous"),life:1.,delay:0.,period:100.,window:100.,rate:f("rate"),single:r["single"].as_u64().unwrap() as u32,emitted:r["latch"].as_u64().unwrap() as u8},&Prepared {life:base.life,scalar:base.scalar,rate:base.rotation,factor:base.factor,offset:[10f32,20.,30.].map(f32::to_bits),position_offset:[0;3],velocity:[0;3],matrix:identity,previous_position:[60f32,170.,280.].map(f32::to_bits),current_position:[110f32,220.,330.].map(f32::to_bits),bounds_factor:1f32.to_bits(),scale:Table {values:&[1.],probability:None},terrain:0},&mut particles,&mut birth,&mut rng,&mut |_|panic!("native terrain flag is zero"),&mut |_,rng| {Ok(birth_base.birth(&curves,rng))},&mut |_,position,velocity,rng|crate::native_simple_rotation_list::evaluate(&rotation_elements,rng)?.apply(position,velocity)).unwrap();
            let a=&r["arrays"];
            for (actual,key) in [(&birth,"0x8"),(&particles.life,"0x14"),(&particles.ages,"0x20"),(&particles.scales,"0x44"),(&particles.factors,"0x50"),(&particles.scalar,"0x5c"),(&particles.rates,"0x68"),(&particles.auxiliary,"0x74"),(&particles.attribute_a,"0x80"),(&particles.attribute_b,"0x8c"),(&particles.previous_heights,"0x98")]{assert_eq!(*actual,words(&a[key]),"{key} case{index}");}
            assert_eq!(particles.positions.iter().flatten().copied().collect::<Vec<_>>(),words(&a["0x2c"]),"position case{index}");assert_eq!(particles.velocities.iter().flatten().copied().collect::<Vec<_>>(),words(&a["0x38"]),"velocity case{index}");
            for (actual,key) in [(owner.previous,"last_emission"),(owner.counter,"counter"),(owner.bounds_factor,"bounds_factor"),(owner.emitted as u32,"emitted")]{assert_eq!(actual as u64,r[key].as_u64().unwrap(),"{key} case{index}");}
            assert_eq!(rng.words.as_slice(),words(&r["rng"]),"rng case{index}");assert_eq!(rng.first as u64,r["first"].as_u64().unwrap());assert_eq!(rng.second as u64,r["second"].as_u64().unwrap());
        }
    }
    #[test]
    fn final_offset_attribute_matches384_whole_native_emissions() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/simple_offset_attribute_contract.json")).unwrap();let rows=proof["cases"].as_array().unwrap();assert_eq!(rows.len(),384);
        let identity=std::array::from_fn(|j|if [0,5,10,15].contains(&j){1f32.to_bits()}else{0});
        for (index,row) in rows.iter().enumerate(){let r=&row["cpu"];let f=|key:&str|r[key].as_f64().unwrap() as f32;
            let table=|key:&str|r["tables"][key].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();
            let base=sample_base(&table("0x88"),&table("0xc4"),&table("0xd8"),&table("0x108"),f("progress")).unwrap();
            let mode=r["mode"].as_u64().unwrap();
            let curve=crate::native_probability_curve::ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:7.,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let probability_curve=if mode==0{None}else{Some(&curve)};
            let vector=|key:&str|r["vector_tables"][key].as_array().unwrap().iter().map(|v|std::array::from_fn(|j|v[j].as_f64().unwrap() as f32)).collect::<Vec<[f32;3]>>();
            let birth_base=BaseBirth {values:base,position:sample_vector(&vector("0xa8"),f("progress")).unwrap(),velocity:sample_vector(&vector("0xec"),f("progress")).unwrap(),offset:sample_vector(&vector("0x11c"),f("progress")).unwrap()};
            let component_curves=|key:&str|std::array::from_fn::<_,3,_>(|j|{let mode=r["vector_modes"][key][j].as_u64().unwrap();ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:0.5,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]}});
            let position_curves=component_curves("0xa8");let velocity_curves=component_curves("0xec");let offset_curves=component_curves("0x11c");
            let curves=BirthCurves {life:probability_curve,factor:probability_curve,scalar:probability_curve,rotation:probability_curve,position:std::array::from_fn(|j|position_curves[j].present.then_some(&position_curves[j])),velocity:std::array::from_fn(|j|velocity_curves[j].present.then_some(&velocity_curves[j])),offset:std::array::from_fn(|j|offset_curves[j].present.then_some(&offset_curves[j]))};
            let rotation_tables=r["rotation_tables"].as_array().unwrap().iter().map(|t|t.as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>()).collect::<Vec<_>>();
            let rotation_curves=r["rotation_modes"].as_array().unwrap().iter().map(|v|{let mode=v.as_u64().unwrap();ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:0.5,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]}}).collect::<Vec<_>>();
            let rotation_sources=rotation_tables.iter().enumerate().map(|(i,table)|crate::native_simple_rotation_list::Source {table,axis:std::array::from_fn(|j|(r["rotation_axes"][i][j].as_f64().unwrap() as f32).to_bits()),probability:rotation_curves[i].present.then_some(&rotation_curves[i])}).collect::<Vec<_>>();
            let rotation_elements=crate::native_simple_rotation_list::sample(&rotation_sources,f("progress")).unwrap();
            let offset_weights=r["offset_weights"].as_array().unwrap().iter().map(|v|std::array::from_fn(|j|v[j].as_f64().unwrap() as f32)).collect::<Vec<[f32;3]>>();
            let offset_attribute_curves=std::array::from_fn::<_,3,_>(|j|{let mode=r["offset_weight_modes"][j].as_u64().unwrap();ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:0.5,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]}});
            let attributes=crate::native_particle_attributes::Attributes::from_snapshot(if r["present"]==1{vec![(7,f("attribute_value").to_bits())]}else{vec![]}).unwrap();
            let offset_attribute=VectorAttribute {key:7,table:&offset_weights,probability:std::array::from_fn(|j|offset_attribute_curves[j].present.then_some(&offset_attribute_curves[j])),attributes:&attributes};
            let raw_offset_weight=sample_vector(offset_attribute.table,f("progress")).unwrap();
            let mut owner=State {previous:f("previous").to_bits(),emitted:r["latch"].as_u64().unwrap() as u8,counter:0,bounds_factor:0};
            let mut particles=Particles {last_time:0,life:vec![],ages:vec![],active:0,positions:vec![],velocities:vec![],scales:vec![],factors:vec![],scalar:vec![],rates:vec![],auxiliary:vec![],attribute_a:vec![],attribute_b:vec![],previous_heights:vec![],bounds:crate::native_simple_bounds_policy::State {bounds:crate::native_simple_particle_bounds::Bounds {minimum:[0;3],maximum:[0;3]},center:[0;3],last:0},counter:0};
            let mut birth=vec![];let mut rng=Rng55 {words:std::array::from_fn(|j|12345+j as u32*13579),first:0,second:0};
            crate::native_simple_emission_lifecycle::update_with_rotation_source(&mut owner,count::Input {time:10.+f("age"),start:10.,previous:f("previous"),life:1.,delay:0.,period:100.,window:100.,rate:f("rate"),single:r["single"].as_u64().unwrap() as u32,emitted:r["latch"].as_u64().unwrap() as u8},&Prepared {life:base.life,scalar:base.scalar,rate:base.rotation,factor:base.factor,offset:[10f32,20.,30.].map(f32::to_bits),position_offset:[0;3],velocity:[0;3],matrix:identity,previous_position:[60f32,170.,280.].map(f32::to_bits),current_position:[110f32,220.,330.].map(f32::to_bits),bounds_factor:1f32.to_bits(),scale:Table {values:&[1.],probability:None},terrain:0},&mut particles,&mut birth,&mut rng,&mut |_|panic!("native terrain flag is zero"),&mut |birth_index,rng| {
                let life=lifetime(probability(birth_base.values.life,curves.life,rng));
                let born=birth_base.birth_with_offset_source(&curves,rng,life,&mut |rng|vector_probability(birth_base.position,curves.position,rng),&mut |rng|vector_probability(birth_base.velocity,curves.velocity,rng),&mut |rng|probability(birth_base.values.rotation,curves.rotation,rng),&mut |rng|offset_attribute_birth(birth_base.offset,raw_offset_weight,curves.offset,&offset_attribute,rng));
                assert_eq!(born.offset.as_slice(),words(&r["augmented_offsets"][birth_index as usize-1]),"augmented offset case{index}, birth{birth_index}");Ok(born)
            },&mut |_,position,velocity,rng|crate::native_simple_rotation_list::evaluate(&rotation_elements,rng)?.apply(position,velocity)).unwrap();
            let a=&r["arrays"];
            for (actual,key) in [(&birth,"0x8"),(&particles.life,"0x14"),(&particles.ages,"0x20"),(&particles.scales,"0x44"),(&particles.factors,"0x50"),(&particles.scalar,"0x5c"),(&particles.rates,"0x68"),(&particles.auxiliary,"0x74"),(&particles.attribute_a,"0x80"),(&particles.attribute_b,"0x8c"),(&particles.previous_heights,"0x98")]{assert_eq!(*actual,words(&a[key]),"{key} case{index}");}
            assert_eq!(particles.positions.iter().flatten().copied().collect::<Vec<_>>(),words(&a["0x2c"]),"position case{index}");assert_eq!(particles.velocities.iter().flatten().copied().collect::<Vec<_>>(),words(&a["0x38"]),"velocity case{index}");
            for (actual,key) in [(owner.previous,"last_emission"),(owner.counter,"counter"),(owner.bounds_factor,"bounds_factor"),(owner.emitted as u32,"emitted")]{assert_eq!(actual as u64,r[key].as_u64().unwrap(),"{key} case{index}");}
            assert_eq!(rng.words.as_slice(),words(&r["rng"]),"rng case{index}");assert_eq!(rng.first as u64,r["first"].as_u64().unwrap());assert_eq!(rng.second as u64,r["second"].as_u64().unwrap());
        }
    }
    #[test]
    fn rate_gates_and_shared_birth_rng_match320_whole_native_emissions() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/simple_rate_source_contract.json")).unwrap();let rows=proof["cases"].as_array().unwrap();assert_eq!(rows.len(),320);
        let identity=std::array::from_fn(|j|if [0,5,10,15].contains(&j){1f32.to_bits()}else{0});
        for (index,row) in rows.iter().enumerate(){let r=&row["cpu"];let f=|key:&str|r[key].as_f64().unwrap() as f32;
            let table=|key:&str|r["tables"][key].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();
            let base=sample_base(&table("0x88"),&table("0xc4"),&table("0xd8"),&table("0x108"),f("progress")).unwrap();
            let mode=r["mode"].as_u64().unwrap();
            let curve=crate::native_probability_curve::ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:7.,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let probability_curve=if mode==0{None}else{Some(&curve)};
            let vector=|key:&str|r["vector_tables"][key].as_array().unwrap().iter().map(|v|std::array::from_fn(|j|v[j].as_f64().unwrap() as f32)).collect::<Vec<[f32;3]>>();
            let birth_base=BaseBirth {values:base,position:sample_vector(&vector("0xa8"),f("progress")).unwrap(),velocity:sample_vector(&vector("0xec"),f("progress")).unwrap(),offset:sample_vector(&vector("0x11c"),f("progress")).unwrap()};
            let component_curves=|key:&str|std::array::from_fn::<_,3,_>(|j|{let mode=r["vector_modes"][key][j].as_u64().unwrap();ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:0.5,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]}});
            let position_curves=component_curves("0xa8");let velocity_curves=component_curves("0xec");let offset_curves=component_curves("0x11c");
            let curves=BirthCurves {life:probability_curve,factor:probability_curve,scalar:probability_curve,rotation:probability_curve,position:std::array::from_fn(|j|position_curves[j].present.then_some(&position_curves[j])),velocity:std::array::from_fn(|j|velocity_curves[j].present.then_some(&velocity_curves[j])),offset:std::array::from_fn(|j|offset_curves[j].present.then_some(&offset_curves[j]))};
            let rate_table=r["rate_table"].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();
            let rate_curve=ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:0.5,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let mut owner=State {previous:f("previous").to_bits(),emitted:r["latch"].as_u64().unwrap() as u8,counter:0,bounds_factor:0};
            let mut particles=Particles {last_time:0,life:vec![],ages:vec![],active:0,positions:vec![],velocities:vec![],scales:vec![],factors:vec![],scalar:vec![],rates:vec![],auxiliary:vec![],attribute_a:vec![],attribute_b:vec![],previous_heights:vec![],bounds:crate::native_simple_bounds_policy::State {bounds:crate::native_simple_particle_bounds::Bounds {minimum:[0;3],maximum:[0;3]},center:[0;3],last:0},counter:0};
            let mut birth=vec![];let mut rng=Rng55 {words:std::array::from_fn(|j|12345+j as u32*13579),first:0,second:0};
            crate::native_simple_emission_lifecycle::update_with_rate_source(&mut owner,count::Input {time:10.+f("age"),start:10.,previous:f("previous"),life:if r["gate"]==2{0.125}else{1.},delay:if r["gate"]==3{1.}else{0.},period:100.,window:if r["gate"]==4{0.}else{100.},rate:f("rate"),single:r["single"].as_u64().unwrap() as u32,emitted:r["latch"].as_u64().unwrap() as u8},&Prepared {life:base.life,scalar:base.scalar,rate:base.rotation,factor:base.factor,offset:[10f32,20.,30.].map(f32::to_bits),position_offset:[0;3],velocity:[0;3],matrix:identity,previous_position:[60f32,170.,280.].map(f32::to_bits),current_position:[110f32,220.,330.].map(f32::to_bits),bounds_factor:1f32.to_bits(),scale:Table {values:&[1.],probability:None},terrain:0},&mut particles,&mut birth,&mut rng,&mut |_|panic!("native terrain flag is zero"),&mut |rng|sample_rate(&rate_table,(mode!=0).then_some(&rate_curve),f("progress"),f("rate_factor"),rng),&mut |_,rng| {Ok(birth_base.birth(&curves,rng))}).unwrap();
            let a=&r["arrays"];
            for (actual,key) in [(&birth,"0x8"),(&particles.life,"0x14"),(&particles.ages,"0x20"),(&particles.scales,"0x44"),(&particles.factors,"0x50"),(&particles.scalar,"0x5c"),(&particles.rates,"0x68"),(&particles.auxiliary,"0x74"),(&particles.attribute_a,"0x80"),(&particles.attribute_b,"0x8c"),(&particles.previous_heights,"0x98")]{assert_eq!(*actual,words(&a[key]),"{key} case{index}");}
            assert_eq!(particles.positions.iter().flatten().copied().collect::<Vec<_>>(),words(&a["0x2c"]),"position case{index}");assert_eq!(particles.velocities.iter().flatten().copied().collect::<Vec<_>>(),words(&a["0x38"]),"velocity case{index}");
            for (actual,key) in [(owner.previous,"last_emission"),(owner.counter,"counter"),(owner.bounds_factor,"bounds_factor"),(owner.emitted as u32,"emitted")]{assert_eq!(actual as u64,r[key].as_u64().unwrap(),"{key} case{index}");}
            assert_eq!(rng.words.as_slice(),words(&r["rng"]),"rng case{index}");assert_eq!(rng.first as u64,r["first"].as_u64().unwrap());assert_eq!(rng.second as u64,r["second"].as_u64().unwrap());
        }
    }
    #[test]
    fn rate_attribute_and_shared_birth_rng_match384_whole_native_emissions() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/simple_rate_attribute_contract.json")).unwrap();let rows=proof["cases"].as_array().unwrap();assert_eq!(rows.len(),384);
        let identity=std::array::from_fn(|j|if [0,5,10,15].contains(&j){1f32.to_bits()}else{0});
        for (index,row) in rows.iter().enumerate(){let r=&row["cpu"];let f=|key:&str|r[key].as_f64().unwrap() as f32;
            let table=|key:&str|r["tables"][key].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();
            let base=sample_base(&table("0x88"),&table("0xc4"),&table("0xd8"),&table("0x108"),f("progress")).unwrap();
            let mode=r["mode"].as_u64().unwrap();
            let curve=crate::native_probability_curve::ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:7.,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let probability_curve=if mode==0{None}else{Some(&curve)};
            let vector=|key:&str|r["vector_tables"][key].as_array().unwrap().iter().map(|v|std::array::from_fn(|j|v[j].as_f64().unwrap() as f32)).collect::<Vec<[f32;3]>>();
            let birth_base=BaseBirth {values:base,position:sample_vector(&vector("0xa8"),f("progress")).unwrap(),velocity:sample_vector(&vector("0xec"),f("progress")).unwrap(),offset:sample_vector(&vector("0x11c"),f("progress")).unwrap()};
            let component_curves=|key:&str|std::array::from_fn::<_,3,_>(|j|{let mode=r["vector_modes"][key][j].as_u64().unwrap();ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:0.5,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]}});
            let position_curves=component_curves("0xa8");let velocity_curves=component_curves("0xec");let offset_curves=component_curves("0x11c");
            let curves=BirthCurves {life:probability_curve,factor:probability_curve,scalar:probability_curve,rotation:probability_curve,position:std::array::from_fn(|j|position_curves[j].present.then_some(&position_curves[j])),velocity:std::array::from_fn(|j|velocity_curves[j].present.then_some(&velocity_curves[j])),offset:std::array::from_fn(|j|offset_curves[j].present.then_some(&offset_curves[j]))};
            let rate_table=r["rate_table"].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();
            let rate_curve=ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:0.5,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let weight_mode=r["weight_mode"].as_u64().unwrap();
            let weight_table=r["weight_table"].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();
            let weight_curve=ProbabilityCurve {present:weight_mode!=0,constant:weight_mode==1,constant_value:0.5,fast:weight_mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let attributes=crate::native_particle_attributes::Attributes::from_snapshot(if r["present"]==1{vec![(7,f("attribute_value").to_bits())]}else{vec![]}).unwrap();
            let attribute=RateAttribute {key:7,table:&weight_table,probability:(weight_mode!=0).then_some(&weight_curve),attributes:&attributes};
            let mut owner=State {previous:f("previous").to_bits(),emitted:r["latch"].as_u64().unwrap() as u8,counter:0,bounds_factor:0};
            let mut particles=Particles {last_time:0,life:vec![],ages:vec![],active:0,positions:vec![],velocities:vec![],scales:vec![],factors:vec![],scalar:vec![],rates:vec![],auxiliary:vec![],attribute_a:vec![],attribute_b:vec![],previous_heights:vec![],bounds:crate::native_simple_bounds_policy::State {bounds:crate::native_simple_particle_bounds::Bounds {minimum:[0;3],maximum:[0;3]},center:[0;3],last:0},counter:0};
            let mut birth=vec![];let mut rng=Rng55 {words:std::array::from_fn(|j|12345+j as u32*13579),first:0,second:0};
            crate::native_simple_emission_lifecycle::update_with_rate_source(&mut owner,count::Input {time:10.+f("age"),start:10.,previous:f("previous"),life:if r["gate"]==2{0.125}else{1.},delay:if r["gate"]==3{1.}else{0.},period:100.,window:if r["gate"]==4{0.}else{100.},rate:f("rate"),single:r["single"].as_u64().unwrap() as u32,emitted:r["latch"].as_u64().unwrap() as u8},&Prepared {life:base.life,scalar:base.scalar,rate:base.rotation,factor:base.factor,offset:[10f32,20.,30.].map(f32::to_bits),position_offset:[0;3],velocity:[0;3],matrix:identity,previous_position:[60f32,170.,280.].map(f32::to_bits),current_position:[110f32,220.,330.].map(f32::to_bits),bounds_factor:1f32.to_bits(),scale:Table {values:&[1.],probability:None},terrain:0},&mut particles,&mut birth,&mut rng,&mut |_|panic!("native terrain flag is zero"),&mut |rng| {
                let base=sample_rate(&rate_table,(mode!=0).then_some(&rate_curve),f("progress"),f("rate_factor"),rng)?;
                let augmented=augment_rate(base,f("progress"),&attribute,rng)?;
                assert_eq!(augmented.to_bits() as u64,r["effective_rate"][0].as_u64().unwrap(),"effective rate case{index}");
                Ok(augmented)
            },&mut |_,rng| {Ok(birth_base.birth(&curves,rng))}).unwrap();
            let a=&r["arrays"];
            for (actual,key) in [(&birth,"0x8"),(&particles.life,"0x14"),(&particles.ages,"0x20"),(&particles.scales,"0x44"),(&particles.factors,"0x50"),(&particles.scalar,"0x5c"),(&particles.rates,"0x68"),(&particles.auxiliary,"0x74"),(&particles.attribute_a,"0x80"),(&particles.attribute_b,"0x8c"),(&particles.previous_heights,"0x98")]{assert_eq!(*actual,words(&a[key]),"{key} case{index}");}
            assert_eq!(particles.positions.iter().flatten().copied().collect::<Vec<_>>(),words(&a["0x2c"]),"position case{index}");assert_eq!(particles.velocities.iter().flatten().copied().collect::<Vec<_>>(),words(&a["0x38"]),"velocity case{index}");
            for (actual,key) in [(owner.previous,"last_emission"),(owner.counter,"counter"),(owner.bounds_factor,"bounds_factor"),(owner.emitted as u32,"emitted")]{assert_eq!(actual as u64,r[key].as_u64().unwrap(),"{key} case{index}");}
            assert_eq!(rng.words.as_slice(),words(&r["rng"]),"rng case{index}");assert_eq!(rng.first as u64,r["first"].as_u64().unwrap());assert_eq!(rng.second as u64,r["second"].as_u64().unwrap());
        }
    }
    #[test]
    fn life_attribute_two_stages_match384_whole_native_emissions() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/simple_life_attribute_contract.json")).unwrap();let rows=proof["cases"].as_array().unwrap();assert_eq!(rows.len(),384);
        let identity=std::array::from_fn(|j|if [0,5,10,15].contains(&j){1f32.to_bits()}else{0});
        for (index,row) in rows.iter().enumerate(){let r=&row["cpu"];let f=|key:&str|r[key].as_f64().unwrap() as f32;
            let table=|key:&str|r["tables"][key].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();
            let base=sample_base(&table("0x88"),&table("0xc4"),&table("0xd8"),&table("0x108"),f("progress")).unwrap();
            let mode=r["mode"].as_u64().unwrap();
            let curve=crate::native_probability_curve::ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:7.,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let probability_curve=if mode==0{None}else{Some(&curve)};
            let vector=|key:&str|r["vector_tables"][key].as_array().unwrap().iter().map(|v|std::array::from_fn(|j|v[j].as_f64().unwrap() as f32)).collect::<Vec<[f32;3]>>();
            let birth_base=BaseBirth {values:base,position:sample_vector(&vector("0xa8"),f("progress")).unwrap(),velocity:sample_vector(&vector("0xec"),f("progress")).unwrap(),offset:sample_vector(&vector("0x11c"),f("progress")).unwrap()};
            let component_curves=|key:&str|std::array::from_fn::<_,3,_>(|j|{let mode=r["vector_modes"][key][j].as_u64().unwrap();ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:0.5,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]}});
            let position_curves=component_curves("0xa8");let velocity_curves=component_curves("0xec");let offset_curves=component_curves("0x11c");
            let curves=BirthCurves {life:probability_curve,factor:probability_curve,scalar:probability_curve,rotation:probability_curve,position:std::array::from_fn(|j|position_curves[j].present.then_some(&position_curves[j])),velocity:std::array::from_fn(|j|velocity_curves[j].present.then_some(&velocity_curves[j])),offset:std::array::from_fn(|j|offset_curves[j].present.then_some(&offset_curves[j]))};
            let rate_table=r["rate_table"].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();
            let rate_curve=ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:0.5,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let weight_mode=r["weight_mode"].as_u64().unwrap();
            let weight_table=r["weight_table"].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();
            let weight_curve=ProbabilityCurve {present:weight_mode!=0,constant:weight_mode==1,constant_value:0.5,fast:weight_mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let attributes=crate::native_particle_attributes::Attributes::from_snapshot(if r["present"]==1{vec![(7,f("attribute_value").to_bits())]}else{vec![]}).unwrap();
            let attribute=RateAttribute {key:7,table:&weight_table,probability:(weight_mode!=0).then_some(&weight_curve),attributes:&attributes};
            let life_weight_mode=r["life_weight_mode"].as_u64().unwrap();
            let life_weight_table=r["life_weight_table"].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();
            let life_weight_curve=ProbabilityCurve {present:life_weight_mode!=0,constant:life_weight_mode==1,constant_value:0.5,fast:life_weight_mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let life_attribute=LifeAttribute {key:7,table:&life_weight_table,probability:(life_weight_mode!=0).then_some(&life_weight_curve),attributes:&attributes};
            let prepared_life=prepare_attribute_life(base.life,f("progress"),&life_attribute).unwrap();
            if let Some(expected)=r["prepared_life"].as_array().unwrap().first(){assert_eq!(prepared_life as u64,expected.as_u64().unwrap(),"prepared life case{index}");}
            let mut owner=State {previous:f("previous").to_bits(),emitted:r["latch"].as_u64().unwrap() as u8,counter:0,bounds_factor:0};
            let mut particles=Particles {last_time:0,life:vec![],ages:vec![],active:0,positions:vec![],velocities:vec![],scales:vec![],factors:vec![],scalar:vec![],rates:vec![],auxiliary:vec![],attribute_a:vec![],attribute_b:vec![],previous_heights:vec![],bounds:crate::native_simple_bounds_policy::State {bounds:crate::native_simple_particle_bounds::Bounds {minimum:[0;3],maximum:[0;3]},center:[0;3],last:0},counter:0};
            let mut birth=vec![];let mut rng=Rng55 {words:std::array::from_fn(|j|12345+j as u32*13579),first:0,second:0};
            crate::native_simple_emission_lifecycle::update_with_rate_source(&mut owner,count::Input {time:10.+f("age"),start:10.,previous:f("previous"),life:if r["gate"]==2{0.125}else{1.},delay:if r["gate"]==3{1.}else{0.},period:100.,window:if r["gate"]==4{0.}else{100.},rate:f("rate"),single:r["single"].as_u64().unwrap() as u32,emitted:r["latch"].as_u64().unwrap() as u8},&Prepared {life:base.life,scalar:base.scalar,rate:base.rotation,factor:base.factor,offset:[10f32,20.,30.].map(f32::to_bits),position_offset:[0;3],velocity:[0;3],matrix:identity,previous_position:[60f32,170.,280.].map(f32::to_bits),current_position:[110f32,220.,330.].map(f32::to_bits),bounds_factor:1f32.to_bits(),scale:Table {values:&[1.],probability:None},terrain:0},&mut particles,&mut birth,&mut rng,&mut |_|panic!("native terrain flag is zero"),&mut |rng| {
                let base=sample_rate(&rate_table,(mode!=0).then_some(&rate_curve),f("progress"),f("rate_factor"),rng)?;
                let augmented=augment_rate(base,f("progress"),&attribute,rng)?;
                assert_eq!(augmented.to_bits() as u64,r["effective_rate"][0].as_u64().unwrap(),"effective rate case{index}");
                Ok(augmented)
            },&mut |_,rng| {let life=attribute_life_birth(prepared_life,curves.life,&life_attribute,rng)?;Ok(birth_base.birth_after_life(&curves,rng,life))}).unwrap();
            let a=&r["arrays"];
            for (actual,key) in [(&birth,"0x8"),(&particles.life,"0x14"),(&particles.ages,"0x20"),(&particles.scales,"0x44"),(&particles.factors,"0x50"),(&particles.scalar,"0x5c"),(&particles.rates,"0x68"),(&particles.auxiliary,"0x74"),(&particles.attribute_a,"0x80"),(&particles.attribute_b,"0x8c"),(&particles.previous_heights,"0x98")]{assert_eq!(*actual,words(&a[key]),"{key} case{index}");}
            assert_eq!(particles.positions.iter().flatten().copied().collect::<Vec<_>>(),words(&a["0x2c"]),"position case{index}");assert_eq!(particles.velocities.iter().flatten().copied().collect::<Vec<_>>(),words(&a["0x38"]),"velocity case{index}");
            for (actual,key) in [(owner.previous,"last_emission"),(owner.counter,"counter"),(owner.bounds_factor,"bounds_factor"),(owner.emitted as u32,"emitted")]{assert_eq!(actual as u64,r[key].as_u64().unwrap(),"{key} case{index}");}
            assert_eq!(rng.words.as_slice(),words(&r["rng"]),"rng case{index}");assert_eq!(rng.first as u64,r["first"].as_u64().unwrap());assert_eq!(rng.second as u64,r["second"].as_u64().unwrap());
        }
    }
    #[test]
    fn vector_attribute_two_stages_match384_whole_native_emissions() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/simple_vector_attributes_contract.json")).unwrap();let rows=proof["cases"].as_array().unwrap();assert_eq!(rows.len(),384);
        let identity=std::array::from_fn(|j|if [0,5,10,15].contains(&j){1f32.to_bits()}else{0});
        for (index,row) in rows.iter().enumerate(){let r=&row["cpu"];let f=|key:&str|r[key].as_f64().unwrap() as f32;
            let table=|key:&str|r["tables"][key].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();
            let base=sample_base(&table("0x88"),&table("0xc4"),&table("0xd8"),&table("0x108"),f("progress")).unwrap();
            let mode=r["mode"].as_u64().unwrap();
            let curve=crate::native_probability_curve::ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:7.,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let probability_curve=if mode==0{None}else{Some(&curve)};
            let vector=|key:&str|r["vector_tables"][key].as_array().unwrap().iter().map(|v|std::array::from_fn(|j|v[j].as_f64().unwrap() as f32)).collect::<Vec<[f32;3]>>();
            let birth_base=BaseBirth {values:base,position:sample_vector(&vector("0xa8"),f("progress")).unwrap(),velocity:sample_vector(&vector("0xec"),f("progress")).unwrap(),offset:sample_vector(&vector("0x11c"),f("progress")).unwrap()};
            let component_curves=|key:&str|std::array::from_fn::<_,3,_>(|j|{let mode=r["vector_modes"][key][j].as_u64().unwrap();ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:0.5,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]}});
            let position_curves=component_curves("0xa8");let velocity_curves=component_curves("0xec");let offset_curves=component_curves("0x11c");
            let curves=BirthCurves {life:probability_curve,factor:probability_curve,scalar:probability_curve,rotation:probability_curve,position:std::array::from_fn(|j|position_curves[j].present.then_some(&position_curves[j])),velocity:std::array::from_fn(|j|velocity_curves[j].present.then_some(&velocity_curves[j])),offset:std::array::from_fn(|j|offset_curves[j].present.then_some(&offset_curves[j]))};
            let rate_table=r["rate_table"].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();
            let rate_curve=ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:0.5,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let weight_mode=r["weight_mode"].as_u64().unwrap();
            let weight_table=r["weight_table"].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();
            let weight_curve=ProbabilityCurve {present:weight_mode!=0,constant:weight_mode==1,constant_value:0.5,fast:weight_mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let attributes=crate::native_particle_attributes::Attributes::from_snapshot(if r["present"]==1{vec![(7,f("attribute_value").to_bits())]}else{vec![]}).unwrap();
            let attribute=RateAttribute {key:7,table:&weight_table,probability:(weight_mode!=0).then_some(&weight_curve),attributes:&attributes};
            let life_weight_mode=r["life_weight_mode"].as_u64().unwrap();
            let life_weight_table=r["life_weight_table"].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();
            let life_weight_curve=ProbabilityCurve {present:life_weight_mode!=0,constant:life_weight_mode==1,constant_value:0.5,fast:life_weight_mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let life_attribute=LifeAttribute {key:7,table:&life_weight_table,probability:(life_weight_mode!=0).then_some(&life_weight_curve),attributes:&attributes};
            let prepared_life=prepare_attribute_life(base.life,f("progress"),&life_attribute).unwrap();
            if let Some(expected)=r["prepared_life"].as_array().unwrap().first(){assert_eq!(prepared_life as u64,expected.as_u64().unwrap(),"prepared life case{index}");}
            let attribute_vector=|key:&str|r["attribute_vectors"][key].as_array().unwrap().iter().map(|v|std::array::from_fn(|j|v[j].as_f64().unwrap() as f32)).collect::<Vec<[f32;3]>>();
            let vector_attribute_curves=|key:&str|std::array::from_fn::<_,3,_>(|j|{let mode=r["attribute_vector_modes"][key][j].as_u64().unwrap();ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:0.5,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]}});
            let position_weights=attribute_vector("0x36c");let velocity_weights=attribute_vector("0x3e4");
            let position_attribute_curves=vector_attribute_curves("0x36c");let velocity_attribute_curves=vector_attribute_curves("0x3e4");
            let position_attribute=VectorAttribute {key:7,table:&position_weights,probability:std::array::from_fn(|j|position_attribute_curves[j].present.then_some(&position_attribute_curves[j])),attributes:&attributes};
            let velocity_attribute=VectorAttribute {key:7,table:&velocity_weights,probability:std::array::from_fn(|j|velocity_attribute_curves[j].present.then_some(&velocity_attribute_curves[j])),attributes:&attributes};
            let prepared_position=prepare_attribute_vector(birth_base.position,f("progress"),&position_attribute).unwrap();
            let prepared_velocity=prepare_attribute_vector(birth_base.velocity,f("progress"),&velocity_attribute).unwrap();
            if let Some(expected)=r["prepared_vectors"].as_array().unwrap().first(){assert_eq!(prepared_position.as_slice(),words(&expected["position"]),"prepared position case{index}");assert_eq!(prepared_velocity.as_slice(),words(&expected["velocity"]),"prepared velocity case{index}");}
            let mut owner=State {previous:f("previous").to_bits(),emitted:r["latch"].as_u64().unwrap() as u8,counter:0,bounds_factor:0};
            let mut particles=Particles {last_time:0,life:vec![],ages:vec![],active:0,positions:vec![],velocities:vec![],scales:vec![],factors:vec![],scalar:vec![],rates:vec![],auxiliary:vec![],attribute_a:vec![],attribute_b:vec![],previous_heights:vec![],bounds:crate::native_simple_bounds_policy::State {bounds:crate::native_simple_particle_bounds::Bounds {minimum:[0;3],maximum:[0;3]},center:[0;3],last:0},counter:0};
            let mut birth=vec![];let mut rng=Rng55 {words:std::array::from_fn(|j|12345+j as u32*13579),first:0,second:0};
            crate::native_simple_emission_lifecycle::update_with_rate_source(&mut owner,count::Input {time:10.+f("age"),start:10.,previous:f("previous"),life:if r["gate"]==2{0.125}else{1.},delay:if r["gate"]==3{1.}else{0.},period:100.,window:if r["gate"]==4{0.}else{100.},rate:f("rate"),single:r["single"].as_u64().unwrap() as u32,emitted:r["latch"].as_u64().unwrap() as u8},&Prepared {life:base.life,scalar:base.scalar,rate:base.rotation,factor:base.factor,offset:[10f32,20.,30.].map(f32::to_bits),position_offset:[0;3],velocity:[0;3],matrix:identity,previous_position:[60f32,170.,280.].map(f32::to_bits),current_position:[110f32,220.,330.].map(f32::to_bits),bounds_factor:1f32.to_bits(),scale:Table {values:&[1.],probability:None},terrain:0},&mut particles,&mut birth,&mut rng,&mut |_|panic!("native terrain flag is zero"),&mut |rng| {
                let base=sample_rate(&rate_table,(mode!=0).then_some(&rate_curve),f("progress"),f("rate_factor"),rng)?;
                let augmented=augment_rate(base,f("progress"),&attribute,rng)?;
                assert_eq!(augmented.to_bits() as u64,r["effective_rate"][0].as_u64().unwrap(),"effective rate case{index}");
                Ok(augmented)
            },&mut |_,rng| {let life=attribute_life_birth(prepared_life,curves.life,&life_attribute,rng)?;Ok(birth_base.birth_with_vectors(&curves,rng,life,&mut |rng|attribute_vector_birth(prepared_position,curves.position,&position_attribute,rng),&mut |rng|attribute_vector_birth(prepared_velocity,curves.velocity,&velocity_attribute,rng)))}).unwrap();
            let a=&r["arrays"];
            for (actual,key) in [(&birth,"0x8"),(&particles.life,"0x14"),(&particles.ages,"0x20"),(&particles.scales,"0x44"),(&particles.factors,"0x50"),(&particles.scalar,"0x5c"),(&particles.rates,"0x68"),(&particles.auxiliary,"0x74"),(&particles.attribute_a,"0x80"),(&particles.attribute_b,"0x8c"),(&particles.previous_heights,"0x98")]{assert_eq!(*actual,words(&a[key]),"{key} case{index}");}
            assert_eq!(particles.positions.iter().flatten().copied().collect::<Vec<_>>(),words(&a["0x2c"]),"position case{index}");assert_eq!(particles.velocities.iter().flatten().copied().collect::<Vec<_>>(),words(&a["0x38"]),"velocity case{index}");
            for (actual,key) in [(owner.previous,"last_emission"),(owner.counter,"counter"),(owner.bounds_factor,"bounds_factor"),(owner.emitted as u32,"emitted")]{assert_eq!(actual as u64,r[key].as_u64().unwrap(),"{key} case{index}");}
            assert_eq!(rng.words.as_slice(),words(&r["rng"]),"rng case{index}");assert_eq!(rng.first as u64,r["first"].as_u64().unwrap());assert_eq!(rng.second as u64,r["second"].as_u64().unwrap());
        }
    }
    #[test]
    fn rotation_attribute_two_stages_match384_whole_native_emissions() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/simple_rotation_attribute_contract.json")).unwrap();let rows=proof["cases"].as_array().unwrap();assert_eq!(rows.len(),384);
        let identity=std::array::from_fn(|j|if [0,5,10,15].contains(&j){1f32.to_bits()}else{0});
        for (index,row) in rows.iter().enumerate(){let r=&row["cpu"];let f=|key:&str|r[key].as_f64().unwrap() as f32;
            let table=|key:&str|r["tables"][key].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();
            let base=sample_base(&table("0x88"),&table("0xc4"),&table("0xd8"),&table("0x108"),f("progress")).unwrap();
            let mode=r["mode"].as_u64().unwrap();
            let curve=crate::native_probability_curve::ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:7.,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let probability_curve=if mode==0{None}else{Some(&curve)};
            let vector=|key:&str|r["vector_tables"][key].as_array().unwrap().iter().map(|v|std::array::from_fn(|j|v[j].as_f64().unwrap() as f32)).collect::<Vec<[f32;3]>>();
            let birth_base=BaseBirth {values:base,position:sample_vector(&vector("0xa8"),f("progress")).unwrap(),velocity:sample_vector(&vector("0xec"),f("progress")).unwrap(),offset:sample_vector(&vector("0x11c"),f("progress")).unwrap()};
            let component_curves=|key:&str|std::array::from_fn::<_,3,_>(|j|{let mode=r["vector_modes"][key][j].as_u64().unwrap();ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:0.5,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]}});
            let position_curves=component_curves("0xa8");let velocity_curves=component_curves("0xec");let offset_curves=component_curves("0x11c");
            let curves=BirthCurves {life:probability_curve,factor:probability_curve,scalar:probability_curve,rotation:probability_curve,position:std::array::from_fn(|j|position_curves[j].present.then_some(&position_curves[j])),velocity:std::array::from_fn(|j|velocity_curves[j].present.then_some(&velocity_curves[j])),offset:std::array::from_fn(|j|offset_curves[j].present.then_some(&offset_curves[j]))};
            let rate_table=r["rate_table"].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();
            let rate_curve=ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:0.5,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let weight_mode=r["weight_mode"].as_u64().unwrap();
            let weight_table=r["weight_table"].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();
            let weight_curve=ProbabilityCurve {present:weight_mode!=0,constant:weight_mode==1,constant_value:0.5,fast:weight_mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let attributes=crate::native_particle_attributes::Attributes::from_snapshot(if r["present"]==1{vec![(7,f("attribute_value").to_bits())]}else{vec![]}).unwrap();
            let attribute=RateAttribute {key:7,table:&weight_table,probability:(weight_mode!=0).then_some(&weight_curve),attributes:&attributes};
            let life_weight_mode=r["life_weight_mode"].as_u64().unwrap();
            let life_weight_table=r["life_weight_table"].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();
            let life_weight_curve=ProbabilityCurve {present:life_weight_mode!=0,constant:life_weight_mode==1,constant_value:0.5,fast:life_weight_mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let life_attribute=LifeAttribute {key:7,table:&life_weight_table,probability:(life_weight_mode!=0).then_some(&life_weight_curve),attributes:&attributes};
            let prepared_life=prepare_attribute_life(base.life,f("progress"),&life_attribute).unwrap();
            if let Some(expected)=r["prepared_life"].as_array().unwrap().first(){assert_eq!(prepared_life as u64,expected.as_u64().unwrap(),"prepared life case{index}");}
            let attribute_vector=|key:&str|r["attribute_vectors"][key].as_array().unwrap().iter().map(|v|std::array::from_fn(|j|v[j].as_f64().unwrap() as f32)).collect::<Vec<[f32;3]>>();
            let vector_attribute_curves=|key:&str|std::array::from_fn::<_,3,_>(|j|{let mode=r["attribute_vector_modes"][key][j].as_u64().unwrap();ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:0.5,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]}});
            let position_weights=attribute_vector("0x36c");let velocity_weights=attribute_vector("0x3e4");
            let position_attribute_curves=vector_attribute_curves("0x36c");let velocity_attribute_curves=vector_attribute_curves("0x3e4");
            let position_attribute=VectorAttribute {key:7,table:&position_weights,probability:std::array::from_fn(|j|position_attribute_curves[j].present.then_some(&position_attribute_curves[j])),attributes:&attributes};
            let velocity_attribute=VectorAttribute {key:7,table:&velocity_weights,probability:std::array::from_fn(|j|velocity_attribute_curves[j].present.then_some(&velocity_attribute_curves[j])),attributes:&attributes};
            let prepared_position=prepare_attribute_vector(birth_base.position,f("progress"),&position_attribute).unwrap();
            let prepared_velocity=prepare_attribute_vector(birth_base.velocity,f("progress"),&velocity_attribute).unwrap();
            if let Some(expected)=r["prepared_vectors"].as_array().unwrap().first(){assert_eq!(prepared_position.as_slice(),words(&expected["position"]),"prepared position case{index}");assert_eq!(prepared_velocity.as_slice(),words(&expected["velocity"]),"prepared velocity case{index}");}
            let rotation_weight_mode=r["rotation_weight_mode"].as_u64().unwrap();
            let rotation_weight_table=r["rotation_weight_table"].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();
            let rotation_weight_curve=ProbabilityCurve {present:rotation_weight_mode!=0,constant:rotation_weight_mode==1,constant_value:0.5,fast:rotation_weight_mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let rotation_attribute=ScalarAttribute {key:7,table:&rotation_weight_table,probability:(rotation_weight_mode!=0).then_some(&rotation_weight_curve),attributes:&attributes};
            let prepared_rotation=prepare_attribute_scalar(base.rotation,f("progress"),&rotation_attribute).unwrap();
            if let Some(expected)=r["prepared_rotation"].as_array().unwrap().first(){assert_eq!(prepared_rotation as u64,expected.as_u64().unwrap(),"prepared rotation case{index}");}
            let mut owner=State {previous:f("previous").to_bits(),emitted:r["latch"].as_u64().unwrap() as u8,counter:0,bounds_factor:0};
            let mut particles=Particles {last_time:0,life:vec![],ages:vec![],active:0,positions:vec![],velocities:vec![],scales:vec![],factors:vec![],scalar:vec![],rates:vec![],auxiliary:vec![],attribute_a:vec![],attribute_b:vec![],previous_heights:vec![],bounds:crate::native_simple_bounds_policy::State {bounds:crate::native_simple_particle_bounds::Bounds {minimum:[0;3],maximum:[0;3]},center:[0;3],last:0},counter:0};
            let mut birth=vec![];let mut rng=Rng55 {words:std::array::from_fn(|j|12345+j as u32*13579),first:0,second:0};
            crate::native_simple_emission_lifecycle::update_with_rate_source(&mut owner,count::Input {time:10.+f("age"),start:10.,previous:f("previous"),life:if r["gate"]==2{0.125}else{1.},delay:if r["gate"]==3{1.}else{0.},period:100.,window:if r["gate"]==4{0.}else{100.},rate:f("rate"),single:r["single"].as_u64().unwrap() as u32,emitted:r["latch"].as_u64().unwrap() as u8},&Prepared {life:base.life,scalar:base.scalar,rate:base.rotation,factor:base.factor,offset:[10f32,20.,30.].map(f32::to_bits),position_offset:[0;3],velocity:[0;3],matrix:identity,previous_position:[60f32,170.,280.].map(f32::to_bits),current_position:[110f32,220.,330.].map(f32::to_bits),bounds_factor:1f32.to_bits(),scale:Table {values:&[1.],probability:None},terrain:0},&mut particles,&mut birth,&mut rng,&mut |_|panic!("native terrain flag is zero"),&mut |rng| {
                let base=sample_rate(&rate_table,(mode!=0).then_some(&rate_curve),f("progress"),f("rate_factor"),rng)?;
                let augmented=augment_rate(base,f("progress"),&attribute,rng)?;
                assert_eq!(augmented.to_bits() as u64,r["effective_rate"][0].as_u64().unwrap(),"effective rate case{index}");
                Ok(augmented)
            },&mut |_,rng| {let life=attribute_life_birth(prepared_life,curves.life,&life_attribute,rng)?;Ok(birth_base.birth_with_attribute_rotation(&curves,rng,life,&mut |rng|attribute_vector_birth(prepared_position,curves.position,&position_attribute,rng),&mut |rng|attribute_vector_birth(prepared_velocity,curves.velocity,&velocity_attribute,rng),&mut |rng|attribute_scalar_birth(prepared_rotation,curves.rotation,&rotation_attribute,rng)))}).unwrap();
            let a=&r["arrays"];
            for (actual,key) in [(&birth,"0x8"),(&particles.life,"0x14"),(&particles.ages,"0x20"),(&particles.scales,"0x44"),(&particles.factors,"0x50"),(&particles.scalar,"0x5c"),(&particles.rates,"0x68"),(&particles.auxiliary,"0x74"),(&particles.attribute_a,"0x80"),(&particles.attribute_b,"0x8c"),(&particles.previous_heights,"0x98")]{assert_eq!(*actual,words(&a[key]),"{key} case{index}");}
            assert_eq!(particles.positions.iter().flatten().copied().collect::<Vec<_>>(),words(&a["0x2c"]),"position case{index}");assert_eq!(particles.velocities.iter().flatten().copied().collect::<Vec<_>>(),words(&a["0x38"]),"velocity case{index}");
            for (actual,key) in [(owner.previous,"last_emission"),(owner.counter,"counter"),(owner.bounds_factor,"bounds_factor"),(owner.emitted as u32,"emitted")]{assert_eq!(actual as u64,r[key].as_u64().unwrap(),"{key} case{index}");}
            assert_eq!(rng.words.as_slice(),words(&r["rng"]),"rng case{index}");assert_eq!(rng.first as u64,r["first"].as_u64().unwrap());assert_eq!(rng.second as u64,r["second"].as_u64().unwrap());
        }
    }
    #[test]
    fn combined_sources_match384_whole_native_emissions() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/simple_combined_sources_contract.json")).unwrap();let rows=proof["cases"].as_array().unwrap();assert_eq!(rows.len(),384);
        let identity=std::array::from_fn(|j|if [0,5,10,15].contains(&j){1f32.to_bits()}else{0});
        for (index,row) in rows.iter().enumerate(){let r=&row["cpu"];let f=|key:&str|r[key].as_f64().unwrap() as f32;
            let table=|key:&str|r["tables"][key].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();
            let base=sample_base(&table("0x88"),&table("0xc4"),&table("0xd8"),&table("0x108"),f("progress")).unwrap();
            let mode=r["mode"].as_u64().unwrap();
            let curve=crate::native_probability_curve::ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:7.,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let probability_curve=if mode==0{None}else{Some(&curve)};
            let vector=|key:&str|r["vector_tables"][key].as_array().unwrap().iter().map(|v|std::array::from_fn(|j|v[j].as_f64().unwrap() as f32)).collect::<Vec<[f32;3]>>();
            let birth_base=BaseBirth {values:base,position:sample_vector(&vector("0xa8"),f("progress")).unwrap(),velocity:sample_vector(&vector("0xec"),f("progress")).unwrap(),offset:sample_vector(&vector("0x11c"),f("progress")).unwrap()};
            let component_curves=|key:&str|std::array::from_fn::<_,3,_>(|j|{let mode=r["vector_modes"][key][j].as_u64().unwrap();ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:0.5,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]}});
            let position_curves=component_curves("0xa8");let velocity_curves=component_curves("0xec");let offset_curves=component_curves("0x11c");
            let curves=BirthCurves {life:probability_curve,factor:probability_curve,scalar:probability_curve,rotation:probability_curve,position:std::array::from_fn(|j|position_curves[j].present.then_some(&position_curves[j])),velocity:std::array::from_fn(|j|velocity_curves[j].present.then_some(&velocity_curves[j])),offset:std::array::from_fn(|j|offset_curves[j].present.then_some(&offset_curves[j]))};
            let rate_table=r["rate_table"].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();
            let rate_curve=ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:0.5,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let weight_mode=r["weight_mode"].as_u64().unwrap();
            let weight_table=r["weight_table"].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();
            let weight_curve=ProbabilityCurve {present:weight_mode!=0,constant:weight_mode==1,constant_value:0.5,fast:weight_mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let attributes=crate::native_particle_attributes::Attributes::from_snapshot(if r["present"]==1{vec![(7,f("attribute_value").to_bits())]}else{vec![]}).unwrap();
            let attribute=RateAttribute {key:7,table:&weight_table,probability:(weight_mode!=0).then_some(&weight_curve),attributes:&attributes};
            let life_weight_mode=r["life_weight_mode"].as_u64().unwrap();
            let life_weight_table=r["life_weight_table"].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();
            let life_weight_curve=ProbabilityCurve {present:life_weight_mode!=0,constant:life_weight_mode==1,constant_value:0.5,fast:life_weight_mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let life_attribute=LifeAttribute {key:7,table:&life_weight_table,probability:(life_weight_mode!=0).then_some(&life_weight_curve),attributes:&attributes};
            let prepared_life=prepare_attribute_life(base.life,f("progress"),&life_attribute).unwrap();
            if let Some(expected)=r["prepared_life"].as_array().unwrap().first(){assert_eq!(prepared_life as u64,expected.as_u64().unwrap(),"prepared life case{index}");}
            let attribute_vector=|key:&str|r["attribute_vectors"][key].as_array().unwrap().iter().map(|v|std::array::from_fn(|j|v[j].as_f64().unwrap() as f32)).collect::<Vec<[f32;3]>>();
            let vector_attribute_curves=|key:&str|std::array::from_fn::<_,3,_>(|j|{let mode=r["attribute_vector_modes"][key][j].as_u64().unwrap();ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:0.5,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]}});
            let position_weights=attribute_vector("0x36c");let velocity_weights=attribute_vector("0x3e4");
            let position_attribute_curves=vector_attribute_curves("0x36c");let velocity_attribute_curves=vector_attribute_curves("0x3e4");
            let position_attribute=VectorAttribute {key:7,table:&position_weights,probability:std::array::from_fn(|j|position_attribute_curves[j].present.then_some(&position_attribute_curves[j])),attributes:&attributes};
            let velocity_attribute=VectorAttribute {key:7,table:&velocity_weights,probability:std::array::from_fn(|j|velocity_attribute_curves[j].present.then_some(&velocity_attribute_curves[j])),attributes:&attributes};
            let prepared_position=prepare_attribute_vector(birth_base.position,f("progress"),&position_attribute).unwrap();
            let prepared_velocity=prepare_attribute_vector(birth_base.velocity,f("progress"),&velocity_attribute).unwrap();
            if let Some(expected)=r["prepared_vectors"].as_array().unwrap().first(){assert_eq!(prepared_position.as_slice(),words(&expected["position"]),"prepared position case{index}");assert_eq!(prepared_velocity.as_slice(),words(&expected["velocity"]),"prepared velocity case{index}");}
            let rotation_weight_mode=r["rotation_weight_mode"].as_u64().unwrap();
            let rotation_weight_table=r["rotation_weight_table"].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();
            let rotation_weight_curve=ProbabilityCurve {present:rotation_weight_mode!=0,constant:rotation_weight_mode==1,constant_value:0.5,fast:rotation_weight_mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let rotation_attribute=ScalarAttribute {key:7,table:&rotation_weight_table,probability:(rotation_weight_mode!=0).then_some(&rotation_weight_curve),attributes:&attributes};
            let prepared_rotation=prepare_attribute_scalar(base.rotation,f("progress"),&rotation_attribute).unwrap();
            if let Some(expected)=r["prepared_rotation"].as_array().unwrap().first(){assert_eq!(prepared_rotation as u64,expected.as_u64().unwrap(),"prepared rotation case{index}");}
            let rotation_tables=r["rotation_tables"].as_array().unwrap().iter().map(|t|t.as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>()).collect::<Vec<_>>();
            let rotation_curves=r["rotation_modes"].as_array().unwrap().iter().map(|v|{let mode=v.as_u64().unwrap();ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:0.5,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]}}).collect::<Vec<_>>();
            let rotation_sources=rotation_tables.iter().enumerate().map(|(i,table)|crate::native_simple_rotation_list::Source {table,axis:std::array::from_fn(|j|(r["rotation_axes"][i][j].as_f64().unwrap() as f32).to_bits()),probability:rotation_curves[i].present.then_some(&rotation_curves[i])}).collect::<Vec<_>>();
            let rotation_elements=crate::native_simple_rotation_list::sample(&rotation_sources,f("progress")).unwrap();
            let offset_weights=r["offset_weights"].as_array().unwrap().iter().map(|v|std::array::from_fn(|j|v[j].as_f64().unwrap() as f32)).collect::<Vec<[f32;3]>>();
            let offset_attribute_curves=std::array::from_fn::<_,3,_>(|j|{let mode=r["offset_weight_modes"][j].as_u64().unwrap();ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:0.5,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]}});
            let offset_attribute=VectorAttribute {key:7,table:&offset_weights,probability:std::array::from_fn(|j|offset_attribute_curves[j].present.then_some(&offset_attribute_curves[j])),attributes:&attributes};
            let raw_offset_weight=sample_vector(offset_attribute.table,f("progress")).unwrap();
            let mut owner=State {previous:f("previous").to_bits(),emitted:r["latch"].as_u64().unwrap() as u8,counter:0,bounds_factor:0};
            let mut particles=Particles {last_time:0,life:vec![],ages:vec![],active:0,positions:vec![],velocities:vec![],scales:vec![],factors:vec![],scalar:vec![],rates:vec![],auxiliary:vec![],attribute_a:vec![],attribute_b:vec![],previous_heights:vec![],bounds:crate::native_simple_bounds_policy::State {bounds:crate::native_simple_particle_bounds::Bounds {minimum:[0;3],maximum:[0;3]},center:[0;3],last:0},counter:0};
            let mut birth=vec![];let mut rng=Rng55 {words:std::array::from_fn(|j|12345+j as u32*13579),first:0,second:0};
            crate::native_simple_emission_lifecycle::update_with_rate_and_rotation_source(&mut owner,count::Input {time:10.+f("age"),start:10.,previous:f("previous"),life:if r["gate"]==2{0.125}else{1.},delay:if r["gate"]==3{1.}else{0.},period:100.,window:if r["gate"]==4{0.}else{100.},rate:f("rate"),single:r["single"].as_u64().unwrap() as u32,emitted:r["latch"].as_u64().unwrap() as u8},&Prepared {life:base.life,scalar:base.scalar,rate:base.rotation,factor:base.factor,offset:[10f32,20.,30.].map(f32::to_bits),position_offset:[0;3],velocity:[0;3],matrix:identity,previous_position:[60f32,170.,280.].map(f32::to_bits),current_position:[110f32,220.,330.].map(f32::to_bits),bounds_factor:1f32.to_bits(),scale:Table {values:&[1.],probability:None},terrain:0},&mut particles,&mut birth,&mut rng,&mut |_|panic!("native terrain flag is zero"),&mut |rng| {
                let base=sample_rate(&rate_table,(mode!=0).then_some(&rate_curve),f("progress"),f("rate_factor"),rng)?;
                let augmented=augment_rate(base,f("progress"),&attribute,rng)?;
                assert_eq!(augmented.to_bits() as u64,r["effective_rate"][0].as_u64().unwrap(),"effective rate case{index}");
                Ok(augmented)
            },&mut |birth_index,rng| {
                let life=attribute_life_birth(prepared_life,curves.life,&life_attribute,rng)?;
                let born=birth_base.birth_with_offset_source(&curves,rng,life,&mut |rng|attribute_vector_birth(prepared_position,curves.position,&position_attribute,rng),&mut |rng|attribute_vector_birth(prepared_velocity,curves.velocity,&velocity_attribute,rng),&mut |rng|attribute_scalar_birth(prepared_rotation,curves.rotation,&rotation_attribute,rng),&mut |rng|offset_attribute_birth(birth_base.offset,raw_offset_weight,curves.offset,&offset_attribute,rng));
                assert_eq!(born.offset.as_slice(),words(&r["augmented_offsets"][birth_index as usize-1]),"augmented offset case{index}, birth{birth_index}");Ok(born)
            },&mut |_,offset,velocity,rng|crate::native_simple_rotation_list::evaluate(&rotation_elements,rng)?.apply(offset,velocity)).unwrap();
            let a=&r["arrays"];
            for (actual,key) in [(&birth,"0x8"),(&particles.life,"0x14"),(&particles.ages,"0x20"),(&particles.scales,"0x44"),(&particles.factors,"0x50"),(&particles.scalar,"0x5c"),(&particles.rates,"0x68"),(&particles.auxiliary,"0x74"),(&particles.attribute_a,"0x80"),(&particles.attribute_b,"0x8c"),(&particles.previous_heights,"0x98")]{assert_eq!(*actual,words(&a[key]),"{key} case{index}");}
            assert_eq!(particles.positions.iter().flatten().copied().collect::<Vec<_>>(),words(&a["0x2c"]),"position case{index}");assert_eq!(particles.velocities.iter().flatten().copied().collect::<Vec<_>>(),words(&a["0x38"]),"velocity case{index}");
            for (actual,key) in [(owner.previous,"last_emission"),(owner.counter,"counter"),(owner.bounds_factor,"bounds_factor"),(owner.emitted as u32,"emitted")]{assert_eq!(actual as u64,r[key].as_u64().unwrap(),"{key} case{index}");}
            assert_eq!(rng.words.as_slice(),words(&r["rng"]),"rng case{index}");assert_eq!(rng.first as u64,r["first"].as_u64().unwrap());assert_eq!(rng.second as u64,r["second"].as_u64().unwrap());
        }
    }
    #[test]
    fn birth_factors_match384_whole_native_emissions() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/simple_birth_factors_contract.json")).unwrap();let rows=proof["cases"].as_array().unwrap();assert_eq!(rows.len(),384);
        let identity=std::array::from_fn(|j|if [0,5,10,15].contains(&j){1f32.to_bits()}else{0});
        for (index,row) in rows.iter().enumerate(){let r=&row["cpu"];let f=|key:&str|r[key].as_f64().unwrap() as f32;
            let table=|key:&str|r["tables"][key].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();
            let base=sample_base(&table("0x88"),&table("0xc4"),&table("0xd8"),&table("0x108"),f("progress")).unwrap();
            let mode=r["mode"].as_u64().unwrap();
            let curve=crate::native_probability_curve::ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:7.,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let probability_curve=if mode==0{None}else{Some(&curve)};
            let vector=|key:&str|r["vector_tables"][key].as_array().unwrap().iter().map(|v|std::array::from_fn(|j|v[j].as_f64().unwrap() as f32)).collect::<Vec<[f32;3]>>();
            let birth_base=BaseBirth {values:base,position:sample_vector(&vector("0xa8"),f("progress")).unwrap(),velocity:sample_vector(&vector("0xec"),f("progress")).unwrap(),offset:sample_vector(&vector("0x11c"),f("progress")).unwrap()};
            let component_curves=|key:&str|std::array::from_fn::<_,3,_>(|j|{let mode=r["vector_modes"][key][j].as_u64().unwrap();ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:0.5,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]}});
            let position_curves=component_curves("0xa8");let velocity_curves=component_curves("0xec");let offset_curves=component_curves("0x11c");
            let curves=BirthCurves {life:probability_curve,factor:probability_curve,scalar:probability_curve,rotation:probability_curve,position:std::array::from_fn(|j|position_curves[j].present.then_some(&position_curves[j])),velocity:std::array::from_fn(|j|velocity_curves[j].present.then_some(&velocity_curves[j])),offset:std::array::from_fn(|j|offset_curves[j].present.then_some(&offset_curves[j]))};
            let rate_table=r["rate_table"].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();
            let rate_curve=ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:0.5,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let weight_mode=r["weight_mode"].as_u64().unwrap();
            let weight_table=r["weight_table"].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();
            let weight_curve=ProbabilityCurve {present:weight_mode!=0,constant:weight_mode==1,constant_value:0.5,fast:weight_mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let attributes=crate::native_particle_attributes::Attributes::from_snapshot(if r["present"]==1{vec![(7,f("attribute_value").to_bits())]}else{vec![]}).unwrap();
            let attribute=RateAttribute {key:7,table:&weight_table,probability:(weight_mode!=0).then_some(&weight_curve),attributes:&attributes};
            let life_weight_mode=r["life_weight_mode"].as_u64().unwrap();
            let life_weight_table=r["life_weight_table"].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();
            let life_weight_curve=ProbabilityCurve {present:life_weight_mode!=0,constant:life_weight_mode==1,constant_value:0.5,fast:life_weight_mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let life_attribute=LifeAttribute {key:7,table:&life_weight_table,probability:(life_weight_mode!=0).then_some(&life_weight_curve),attributes:&attributes};
            let prepared_life=prepare_attribute_life(base.life,f("progress"),&life_attribute).unwrap();
            if let Some(expected)=r["prepared_life"].as_array().unwrap().first(){assert_eq!(prepared_life as u64,expected.as_u64().unwrap(),"prepared life case{index}");}
            let attribute_vector=|key:&str|r["attribute_vectors"][key].as_array().unwrap().iter().map(|v|std::array::from_fn(|j|v[j].as_f64().unwrap() as f32)).collect::<Vec<[f32;3]>>();
            let vector_attribute_curves=|key:&str|std::array::from_fn::<_,3,_>(|j|{let mode=r["attribute_vector_modes"][key][j].as_u64().unwrap();ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:0.5,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]}});
            let position_weights=attribute_vector("0x36c");let velocity_weights=attribute_vector("0x3e4");
            let position_attribute_curves=vector_attribute_curves("0x36c");let velocity_attribute_curves=vector_attribute_curves("0x3e4");
            let position_attribute=VectorAttribute {key:7,table:&position_weights,probability:std::array::from_fn(|j|position_attribute_curves[j].present.then_some(&position_attribute_curves[j])),attributes:&attributes};
            let velocity_attribute=VectorAttribute {key:7,table:&velocity_weights,probability:std::array::from_fn(|j|velocity_attribute_curves[j].present.then_some(&velocity_attribute_curves[j])),attributes:&attributes};
            let prepared_position=prepare_attribute_vector(birth_base.position,f("progress"),&position_attribute).unwrap();
            let prepared_velocity=prepare_attribute_vector(birth_base.velocity,f("progress"),&velocity_attribute).unwrap();
            if let Some(expected)=r["prepared_vectors"].as_array().unwrap().first(){assert_eq!(prepared_position.as_slice(),words(&expected["position"]),"prepared position case{index}");assert_eq!(prepared_velocity.as_slice(),words(&expected["velocity"]),"prepared velocity case{index}");}
            let rotation_weight_mode=r["rotation_weight_mode"].as_u64().unwrap();
            let rotation_weight_table=r["rotation_weight_table"].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();
            let rotation_weight_curve=ProbabilityCurve {present:rotation_weight_mode!=0,constant:rotation_weight_mode==1,constant_value:0.5,fast:rotation_weight_mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let rotation_attribute=ScalarAttribute {key:7,table:&rotation_weight_table,probability:(rotation_weight_mode!=0).then_some(&rotation_weight_curve),attributes:&attributes};
            let prepared_rotation=prepare_attribute_scalar(base.rotation,f("progress"),&rotation_attribute).unwrap();
            if let Some(expected)=r["prepared_rotation"].as_array().unwrap().first(){assert_eq!(prepared_rotation as u64,expected.as_u64().unwrap(),"prepared rotation case{index}");}
            let rotation_tables=r["rotation_tables"].as_array().unwrap().iter().map(|t|t.as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>()).collect::<Vec<_>>();
            let rotation_curves=r["rotation_modes"].as_array().unwrap().iter().map(|v|{let mode=v.as_u64().unwrap();ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:0.5,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]}}).collect::<Vec<_>>();
            let rotation_sources=rotation_tables.iter().enumerate().map(|(i,table)|crate::native_simple_rotation_list::Source {table,axis:std::array::from_fn(|j|(r["rotation_axes"][i][j].as_f64().unwrap() as f32).to_bits()),probability:rotation_curves[i].present.then_some(&rotation_curves[i])}).collect::<Vec<_>>();
            let rotation_elements=crate::native_simple_rotation_list::sample(&rotation_sources,f("progress")).unwrap();
            let offset_weights=r["offset_weights"].as_array().unwrap().iter().map(|v|std::array::from_fn(|j|v[j].as_f64().unwrap() as f32)).collect::<Vec<[f32;3]>>();
            let offset_attribute_curves=std::array::from_fn::<_,3,_>(|j|{let mode=r["offset_weight_modes"][j].as_u64().unwrap();ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:0.5,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]}});
            let offset_attribute=VectorAttribute {key:7,table:&offset_weights,probability:std::array::from_fn(|j|offset_attribute_curves[j].present.then_some(&offset_attribute_curves[j])),attributes:&attributes};
            let raw_offset_weight=sample_vector(offset_attribute.table,f("progress")).unwrap();
            let factor_vector=|key:&str|std::array::from_fn(|j|(r[key][j].as_f64().unwrap() as f32).to_bits());
            let factor_attribute=|enabled:&str,multiplier:&str| (r[enabled]==1).then_some(crate::native_simple_birth_factors::AttributeFactor {key:7,multiplier:f(multiplier).to_bits(),attributes:&attributes});
            let factors=crate::native_simple_birth_factors::prepare(&crate::native_simple_birth_factors::Sources {context:factor_vector("factor_context"),offset_coefficients:factor_vector("factor_offset_coefficients"),bounds_coefficients:factor_vector("factor_bounds_coefficients"),life_multiplier:(r["factor_life_enabled"]==1).then_some(f("factor_life_value").to_bits()),offset_attribute:factor_attribute("factor_offset_enabled","factor_offset_multiplier"),size_attribute:factor_attribute("factor_size_enabled","factor_size_multiplier")}).unwrap();
            if let Some(expected)=r["prepared_factors"].as_array().unwrap().first(){for (actual,key) in [(factors.offset_context,"offset_context"),(factors.bounds,"bounds"),(factors.offset_attribute,"offset_attribute"),(factors.size_attribute,"size_attribute")]{assert_eq!(actual as u64,expected[key].as_u64().unwrap(),"prepared factor {key} case{index}");}}
            let mut owner=State {previous:f("previous").to_bits(),emitted:r["latch"].as_u64().unwrap() as u8,counter:0,bounds_factor:0};
            let mut particles=Particles {last_time:0,life:vec![],ages:vec![],active:0,positions:vec![],velocities:vec![],scales:vec![],factors:vec![],scalar:vec![],rates:vec![],auxiliary:vec![],attribute_a:vec![],attribute_b:vec![],previous_heights:vec![],bounds:crate::native_simple_bounds_policy::State {bounds:crate::native_simple_particle_bounds::Bounds {minimum:[0;3],maximum:[0;3]},center:[0;3],last:0},counter:0};
            let mut birth=vec![];let mut rng=Rng55 {words:std::array::from_fn(|j|12345+j as u32*13579),first:0,second:0};
            crate::native_simple_emission_lifecycle::update_with_rate_and_rotation_source(&mut owner,count::Input {time:10.+f("age"),start:10.,previous:f("previous"),life:if r["gate"]==2{0.125}else{1.},delay:if r["gate"]==3{1.}else{0.},period:100.,window:if r["gate"]==4{0.}else{100.},rate:f("rate"),single:r["single"].as_u64().unwrap() as u32,emitted:r["latch"].as_u64().unwrap() as u8},&Prepared {life:base.life,scalar:base.scalar,rate:base.rotation,factor:base.factor,offset:[10f32,20.,30.].map(f32::to_bits),position_offset:[0;3],velocity:[0;3],matrix:identity,previous_position:[60f32,170.,280.].map(f32::to_bits),current_position:[110f32,220.,330.].map(f32::to_bits),bounds_factor:factors.bounds,scale:Table {values:&[1.],probability:None},terrain:0},&mut particles,&mut birth,&mut rng,&mut |_|panic!("native terrain flag is zero"),&mut |rng| {
                let base=sample_rate(&rate_table,(mode!=0).then_some(&rate_curve),f("progress"),f("rate_factor"),rng)?;
                let augmented=augment_rate(base,f("progress"),&attribute,rng)?;
                assert_eq!(augmented.to_bits() as u64,r["effective_rate"][0].as_u64().unwrap(),"effective rate case{index}");
                Ok(augmented)
            },&mut |birth_index,rng| {
                let life=attribute_life_birth_raw(prepared_life,curves.life,&life_attribute,rng)?;
                let mut born=birth_base.birth_with_offset_source(&curves,rng,life,&mut |rng|attribute_vector_birth(prepared_position,curves.position,&position_attribute,rng),&mut |rng|attribute_vector_birth(prepared_velocity,curves.velocity,&velocity_attribute,rng),&mut |rng|attribute_scalar_birth(prepared_rotation,curves.rotation,&rotation_attribute,rng),&mut |rng|offset_attribute_birth(birth_base.offset,raw_offset_weight,curves.offset,&offset_attribute,rng));
                assert_eq!(born.offset.as_slice(),words(&r["augmented_offsets"][birth_index as usize-1]),"augmented offset case{index}, birth{birth_index}");
                factors.apply(&mut born)?;
                let scaled=&r["scaled_births"][birth_index as usize-1];assert_eq!(born.life as u64,scaled["life"].as_u64().unwrap(),"scaled life case{index}");assert_eq!(born.factor as u64,scaled["factor"].as_u64().unwrap(),"scaled factor case{index}");assert_eq!(born.offset.as_slice(),words(&scaled["offset"]),"scaled offset case{index}");Ok(born)
            },&mut |_,offset,velocity,rng|crate::native_simple_rotation_list::evaluate(&rotation_elements,rng)?.apply(offset,velocity)).unwrap();
            let a=&r["arrays"];
            for (actual,key) in [(&birth,"0x8"),(&particles.life,"0x14"),(&particles.ages,"0x20"),(&particles.scales,"0x44"),(&particles.factors,"0x50"),(&particles.scalar,"0x5c"),(&particles.rates,"0x68"),(&particles.auxiliary,"0x74"),(&particles.attribute_a,"0x80"),(&particles.attribute_b,"0x8c"),(&particles.previous_heights,"0x98")]{assert_eq!(*actual,words(&a[key]),"{key} case{index}");}
            assert_eq!(particles.positions.iter().flatten().copied().collect::<Vec<_>>(),words(&a["0x2c"]),"position case{index}");assert_eq!(particles.velocities.iter().flatten().copied().collect::<Vec<_>>(),words(&a["0x38"]),"velocity case{index}");
            for (actual,key) in [(owner.previous,"last_emission"),(owner.counter,"counter"),(owner.bounds_factor,"bounds_factor"),(owner.emitted as u32,"emitted")]{assert_eq!(actual as u64,r[key].as_u64().unwrap(),"{key} case{index}");}
            assert_eq!(rng.words.as_slice(),words(&r["rng"]),"rng case{index}");assert_eq!(rng.first as u64,r["first"].as_u64().unwrap());assert_eq!(rng.second as u64,r["second"].as_u64().unwrap());
        }
    }
    #[test]
    fn composed_producers_match384_whole_native_emissions() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/simple_birth_factors_contract.json")).unwrap();let rows=proof["cases"].as_array().unwrap();assert_eq!(rows.len(),384);
        let identity=std::array::from_fn(|j|if [0,5,10,15].contains(&j){1f32.to_bits()}else{0});
        for (index,row) in rows.iter().enumerate(){let r=&row["cpu"];let f=|key:&str|r[key].as_f64().unwrap() as f32;
            let table=|key:&str|r["tables"][key].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();
            let base=sample_base(&table("0x88"),&table("0xc4"),&table("0xd8"),&table("0x108"),f("progress")).unwrap();
            let mode=r["mode"].as_u64().unwrap();
            let curve=crate::native_probability_curve::ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:7.,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let probability_curve=if mode==0{None}else{Some(&curve)};
            let vector=|key:&str|r["vector_tables"][key].as_array().unwrap().iter().map(|v|std::array::from_fn(|j|v[j].as_f64().unwrap() as f32)).collect::<Vec<[f32;3]>>();
            let birth_base=BaseBirth {values:base,position:sample_vector(&vector("0xa8"),f("progress")).unwrap(),velocity:sample_vector(&vector("0xec"),f("progress")).unwrap(),offset:sample_vector(&vector("0x11c"),f("progress")).unwrap()};
            let component_curves=|key:&str|std::array::from_fn::<_,3,_>(|j|{let mode=r["vector_modes"][key][j].as_u64().unwrap();ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:0.5,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]}});
            let position_curves=component_curves("0xa8");let velocity_curves=component_curves("0xec");let offset_curves=component_curves("0x11c");
            let curves=BirthCurves {life:probability_curve,factor:probability_curve,scalar:probability_curve,rotation:probability_curve,position:std::array::from_fn(|j|position_curves[j].present.then_some(&position_curves[j])),velocity:std::array::from_fn(|j|velocity_curves[j].present.then_some(&velocity_curves[j])),offset:std::array::from_fn(|j|offset_curves[j].present.then_some(&offset_curves[j]))};
            let rate_table=r["rate_table"].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();
            let rate_curve=ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:0.5,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let weight_mode=r["weight_mode"].as_u64().unwrap();
            let weight_table=r["weight_table"].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();
            let weight_curve=ProbabilityCurve {present:weight_mode!=0,constant:weight_mode==1,constant_value:0.5,fast:weight_mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let attributes=crate::native_particle_attributes::Attributes::from_snapshot(if r["present"]==1{vec![(7,f("attribute_value").to_bits())]}else{vec![]}).unwrap();
            let attribute=RateAttribute {key:7,table:&weight_table,probability:(weight_mode!=0).then_some(&weight_curve),attributes:&attributes};
            let life_weight_mode=r["life_weight_mode"].as_u64().unwrap();
            let life_weight_table=r["life_weight_table"].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();
            let life_weight_curve=ProbabilityCurve {present:life_weight_mode!=0,constant:life_weight_mode==1,constant_value:0.5,fast:life_weight_mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let life_attribute=LifeAttribute {key:7,table:&life_weight_table,probability:(life_weight_mode!=0).then_some(&life_weight_curve),attributes:&attributes};
            let prepared_life=prepare_attribute_life(base.life,f("progress"),&life_attribute).unwrap();
            if let Some(expected)=r["prepared_life"].as_array().unwrap().first(){assert_eq!(prepared_life as u64,expected.as_u64().unwrap(),"prepared life case{index}");}
            let attribute_vector=|key:&str|r["attribute_vectors"][key].as_array().unwrap().iter().map(|v|std::array::from_fn(|j|v[j].as_f64().unwrap() as f32)).collect::<Vec<[f32;3]>>();
            let vector_attribute_curves=|key:&str|std::array::from_fn::<_,3,_>(|j|{let mode=r["attribute_vector_modes"][key][j].as_u64().unwrap();ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:0.5,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]}});
            let position_weights=attribute_vector("0x36c");let velocity_weights=attribute_vector("0x3e4");
            let position_attribute_curves=vector_attribute_curves("0x36c");let velocity_attribute_curves=vector_attribute_curves("0x3e4");
            let position_attribute=VectorAttribute {key:7,table:&position_weights,probability:std::array::from_fn(|j|position_attribute_curves[j].present.then_some(&position_attribute_curves[j])),attributes:&attributes};
            let velocity_attribute=VectorAttribute {key:7,table:&velocity_weights,probability:std::array::from_fn(|j|velocity_attribute_curves[j].present.then_some(&velocity_attribute_curves[j])),attributes:&attributes};
            let prepared_position=prepare_attribute_vector(birth_base.position,f("progress"),&position_attribute).unwrap();
            let prepared_velocity=prepare_attribute_vector(birth_base.velocity,f("progress"),&velocity_attribute).unwrap();
            if let Some(expected)=r["prepared_vectors"].as_array().unwrap().first(){assert_eq!(prepared_position.as_slice(),words(&expected["position"]),"prepared position case{index}");assert_eq!(prepared_velocity.as_slice(),words(&expected["velocity"]),"prepared velocity case{index}");}
            let rotation_weight_mode=r["rotation_weight_mode"].as_u64().unwrap();
            let rotation_weight_table=r["rotation_weight_table"].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();
            let rotation_weight_curve=ProbabilityCurve {present:rotation_weight_mode!=0,constant:rotation_weight_mode==1,constant_value:0.5,fast:rotation_weight_mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let rotation_attribute=ScalarAttribute {key:7,table:&rotation_weight_table,probability:(rotation_weight_mode!=0).then_some(&rotation_weight_curve),attributes:&attributes};
            let prepared_rotation=prepare_attribute_scalar(base.rotation,f("progress"),&rotation_attribute).unwrap();
            if let Some(expected)=r["prepared_rotation"].as_array().unwrap().first(){assert_eq!(prepared_rotation as u64,expected.as_u64().unwrap(),"prepared rotation case{index}");}
            let rotation_tables=r["rotation_tables"].as_array().unwrap().iter().map(|t|t.as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>()).collect::<Vec<_>>();
            let rotation_curves=r["rotation_modes"].as_array().unwrap().iter().map(|v|{let mode=v.as_u64().unwrap();ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:0.5,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]}}).collect::<Vec<_>>();
            let rotation_sources=rotation_tables.iter().enumerate().map(|(i,table)|crate::native_simple_rotation_list::Source {table,axis:std::array::from_fn(|j|(r["rotation_axes"][i][j].as_f64().unwrap() as f32).to_bits()),probability:rotation_curves[i].present.then_some(&rotation_curves[i])}).collect::<Vec<_>>();
            let rotation_elements=crate::native_simple_rotation_list::sample(&rotation_sources,f("progress")).unwrap();
            let offset_weights=r["offset_weights"].as_array().unwrap().iter().map(|v|std::array::from_fn(|j|v[j].as_f64().unwrap() as f32)).collect::<Vec<[f32;3]>>();
            let offset_attribute_curves=std::array::from_fn::<_,3,_>(|j|{let mode=r["offset_weight_modes"][j].as_u64().unwrap();ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:0.5,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]}});
            let offset_attribute=VectorAttribute {key:7,table:&offset_weights,probability:std::array::from_fn(|j|offset_attribute_curves[j].present.then_some(&offset_attribute_curves[j])),attributes:&attributes};
            let raw_offset_weight=sample_vector(offset_attribute.table,f("progress")).unwrap();
            let factor_vector=|key:&str|std::array::from_fn(|j|(r[key][j].as_f64().unwrap() as f32).to_bits());
            let factor_attribute=|enabled:&str,multiplier:&str| (r[enabled]==1).then_some(crate::native_simple_birth_factors::AttributeFactor {key:7,multiplier:f(multiplier).to_bits(),attributes:&attributes});
            let factors=crate::native_simple_birth_factors::prepare(&crate::native_simple_birth_factors::Sources {context:factor_vector("factor_context"),offset_coefficients:factor_vector("factor_offset_coefficients"),bounds_coefficients:factor_vector("factor_bounds_coefficients"),life_multiplier:(r["factor_life_enabled"]==1).then_some(f("factor_life_value").to_bits()),offset_attribute:factor_attribute("factor_offset_enabled","factor_offset_multiplier"),size_attribute:factor_attribute("factor_size_enabled","factor_size_multiplier")}).unwrap();
            if let Some(expected)=r["prepared_factors"].as_array().unwrap().first(){for (actual,key) in [(factors.offset_context,"offset_context"),(factors.bounds,"bounds"),(factors.offset_attribute,"offset_attribute"),(factors.size_attribute,"size_attribute")]{assert_eq!(actual as u64,expected[key].as_u64().unwrap(),"prepared factor {key} case{index}");}}
            let mut owner=State {previous:f("previous").to_bits(),emitted:r["latch"].as_u64().unwrap() as u8,counter:0,bounds_factor:0};
            let mut particles=Particles {last_time:0,life:vec![],ages:vec![],active:0,positions:vec![],velocities:vec![],scales:vec![],factors:vec![],scalar:vec![],rates:vec![],auxiliary:vec![],attribute_a:vec![],attribute_b:vec![],previous_heights:vec![],bounds:crate::native_simple_bounds_policy::State {bounds:crate::native_simple_particle_bounds::Bounds {minimum:[0;3],maximum:[0;3]},center:[0;3],last:0},counter:0};
            let mut birth=vec![];let mut rng=Rng55 {words:std::array::from_fn(|j|12345+j as u32*13579),first:0,second:0};
            let factor_sources=crate::native_simple_birth_factors::Sources {context:factor_vector("factor_context"),offset_coefficients:factor_vector("factor_offset_coefficients"),bounds_coefficients:factor_vector("factor_bounds_coefficients"),life_multiplier:(r["factor_life_enabled"]==1).then_some(f("factor_life_value").to_bits()),offset_attribute:factor_attribute("factor_offset_enabled","factor_offset_multiplier"),size_attribute:factor_attribute("factor_size_enabled","factor_size_multiplier")};
            let sources=crate::native_simple_emission_sources::Sources {base:&birth_base,curves:&curves,attributes:crate::native_simple_emission_sources::Attributes {life:Some(&life_attribute),position:Some(&position_attribute),velocity:Some(&velocity_attribute),rotation:Some(&rotation_attribute),offset:Some(&offset_attribute)},factors:&factor_sources,rotations:&rotation_sources,rate_table:&rate_table,rate_probability:(mode!=0).then_some(&rate_curve),rate_factor:f("rate_factor"),rate_attribute:Some(&attribute)};
            crate::native_simple_emission_sources::emit(&mut owner,count::Input {time:10.+f("age"),start:10.,previous:f("previous"),life:if r["gate"]==2{0.125}else{1.},delay:if r["gate"]==3{1.}else{0.},period:100.,window:if r["gate"]==4{0.}else{100.},rate:f("rate"),single:r["single"].as_u64().unwrap() as u32,emitted:r["latch"].as_u64().unwrap() as u8},f("progress"),&sources,&Prepared {life:base.life,scalar:base.scalar,rate:base.rotation,factor:base.factor,offset:[10f32,20.,30.].map(f32::to_bits),position_offset:[0;3],velocity:[0;3],matrix:identity,previous_position:[60f32,170.,280.].map(f32::to_bits),current_position:[110f32,220.,330.].map(f32::to_bits),bounds_factor:factors.bounds,scale:Table {values:&[1.],probability:None},terrain:0},&mut particles,&mut birth,&mut rng,&mut |_|panic!("native terrain flag is zero")).unwrap();
            let a=&r["arrays"];
            for (actual,key) in [(&birth,"0x8"),(&particles.life,"0x14"),(&particles.ages,"0x20"),(&particles.scales,"0x44"),(&particles.factors,"0x50"),(&particles.scalar,"0x5c"),(&particles.rates,"0x68"),(&particles.auxiliary,"0x74"),(&particles.attribute_a,"0x80"),(&particles.attribute_b,"0x8c"),(&particles.previous_heights,"0x98")]{assert_eq!(*actual,words(&a[key]),"{key} case{index}");}
            assert_eq!(particles.positions.iter().flatten().copied().collect::<Vec<_>>(),words(&a["0x2c"]),"position case{index}");assert_eq!(particles.velocities.iter().flatten().copied().collect::<Vec<_>>(),words(&a["0x38"]),"velocity case{index}");
            for (actual,key) in [(owner.previous,"last_emission"),(owner.counter,"counter"),(owner.bounds_factor,"bounds_factor"),(owner.emitted as u32,"emitted")]{assert_eq!(actual as u64,r[key].as_u64().unwrap(),"{key} case{index}");}
            assert_eq!(rng.words.as_slice(),words(&r["rng"]),"rng case{index}");assert_eq!(rng.first as u64,r["first"].as_u64().unwrap());assert_eq!(rng.second as u64,r["second"].as_u64().unwrap());
        }
    }
    struct FrameProducedSources<'a> {sources:&'a crate::native_simple_emission_sources::Sources<'a>,single:u32}
    impl crate::native_simple_animation_policy::Backend for FrameProducedSources<'_> {
        fn lookup(&mut self,_:u32)->Option<crate::native_simple_animation_clock::Clip>{panic!("native fixture has no animation")}
        fn special_kind11(&mut self,_:&mut crate::native_simple_animation_policy::State){panic!("native fixture has no animation")}
        fn evaluate_uncompressed(&mut self,_:crate::native_simple_animation_clock::Clip,_:u32,_:u32,_:&mut crate::native_simple_animation_policy::State){panic!("native fixture has no animation")}
        fn evaluate_compressed(&mut self,_:crate::native_simple_animation_clock::Clip,_:u32,_:u32,_:&mut crate::native_simple_animation_policy::State){panic!("native fixture has no animation")}
    }
    impl crate::native_simple_concrete_frame::Sources for FrameProducedSources<'_> {
        fn emission(&mut self,time:u32,progress:u32,resource:&mut u32,storage:&mut Option<Particles>,birth:&mut Vec<u32>,pose:&crate::native_simple_pose::State,owner:&mut State,rng:&mut Rng55)->Result<(),&'static str>{
            crate::native_simple_emission_sources::emit_from_frame(time,progress,*resource,storage,birth,pose,owner,rng,count::Input {time:f32::from_bits(time),start:10.,previous:f32::from_bits(owner.previous),life:1.,delay:0.,period:100.,window:100.,rate:0.,single:self.single,emitted:owner.emitted},self.sources,Table {values:&[1.],probability:None},0,&mut |_|Err("native terrain disabled"))?;Ok(())
        }
        fn modifier(&mut self,_:u32,_:u32,_:u32,_:&mut [u32;16])->Result<(),&'static str>{Err("native fixture has no modifier")}
        fn initialize_manager(&mut self,_:&mut crate::native_simple_auxiliary::Helper)->Result<u8,&'static str>{Err("native fixture has no helper")}
        fn evaluated_pose(&mut self,_:[u32;16])->Result<[u32;16],&'static str>{Err("native fixture has no animation")}
    }

    #[test]
    fn composed_sources_match576_full_native_frames() {
        use crate::{native_simple_concrete_frame as cf,native_simple_frame as frame,native_simple_control as control,native_simple_pose as pose,native_simple_emission_lifecycle as emission,native_simple_animation_policy as animation,native_simple_particle_update as particles,native_simple_bounds_policy as bounds,native_simple_particle_bounds::Bounds};
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/simple_sources_frame_contract.json")).unwrap();let rows=proof["cases"].as_array().unwrap();assert_eq!(rows.len(),576);
        let identity=std::array::from_fn(|j|if [0,5,10,15].contains(&j){1f32.to_bits()}else{0});
        for (index,row) in rows.iter().enumerate(){let r=&row["cpu"];let f=|key:&str|r[key].as_f64().unwrap() as f32;let n=|key:&str|r[key].as_u64().unwrap() as u32;
            let table=|key:&str|r["tables"][key].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();
            let base=sample_base(&table("0x88"),&table("0xc4"),&table("0xd8"),&table("0x108"),f("age")).unwrap();
            let mode=r["mode"].as_u64().unwrap();
            let curve=crate::native_probability_curve::ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:7.,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let probability_curve=if mode==0{None}else{Some(&curve)};
            let vector=|key:&str|r["vector_tables"][key].as_array().unwrap().iter().map(|v|std::array::from_fn(|j|v[j].as_f64().unwrap() as f32)).collect::<Vec<[f32;3]>>();
            let birth_base=BaseBirth {values:base,position:sample_vector(&vector("0xa8"),f("age")).unwrap(),velocity:sample_vector(&vector("0xec"),f("age")).unwrap(),offset:sample_vector(&vector("0x11c"),f("age")).unwrap()};
            let component_curves=|key:&str|std::array::from_fn::<_,3,_>(|j|{let mode=r["vector_modes"][key][j].as_u64().unwrap();ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:0.5,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]}});
            let position_curves=component_curves("0xa8");let velocity_curves=component_curves("0xec");let offset_curves=component_curves("0x11c");
            let curves=BirthCurves {life:probability_curve,factor:probability_curve,scalar:probability_curve,rotation:probability_curve,position:std::array::from_fn(|j|position_curves[j].present.then_some(&position_curves[j])),velocity:std::array::from_fn(|j|velocity_curves[j].present.then_some(&velocity_curves[j])),offset:std::array::from_fn(|j|offset_curves[j].present.then_some(&offset_curves[j]))};
            let rate_table=r["rate_table"].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();
            let rate_curve=ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:0.5,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let weight_mode=r["weight_mode"].as_u64().unwrap();
            let weight_table=r["weight_table"].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();
            let weight_curve=ProbabilityCurve {present:weight_mode!=0,constant:weight_mode==1,constant_value:0.5,fast:weight_mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let attributes=crate::native_particle_attributes::Attributes::from_snapshot(if r["present"]==1{vec![(7,f("attribute_value").to_bits())]}else{vec![]}).unwrap();
            let attribute=RateAttribute {key:7,table:&weight_table,probability:(weight_mode!=0).then_some(&weight_curve),attributes:&attributes};
            let life_weight_mode=r["life_weight_mode"].as_u64().unwrap();
            let life_weight_table=r["life_weight_table"].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();
            let life_weight_curve=ProbabilityCurve {present:life_weight_mode!=0,constant:life_weight_mode==1,constant_value:0.5,fast:life_weight_mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let life_attribute=LifeAttribute {key:7,table:&life_weight_table,probability:(life_weight_mode!=0).then_some(&life_weight_curve),attributes:&attributes};
            let attribute_vector=|key:&str|r["attribute_vectors"][key].as_array().unwrap().iter().map(|v|std::array::from_fn(|j|v[j].as_f64().unwrap() as f32)).collect::<Vec<[f32;3]>>();
            let vector_attribute_curves=|key:&str|std::array::from_fn::<_,3,_>(|j|{let mode=r["attribute_vector_modes"][key][j].as_u64().unwrap();ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:0.5,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]}});
            let position_weights=attribute_vector("0x36c");let velocity_weights=attribute_vector("0x3e4");
            let position_attribute_curves=vector_attribute_curves("0x36c");let velocity_attribute_curves=vector_attribute_curves("0x3e4");
            let position_attribute=VectorAttribute {key:7,table:&position_weights,probability:std::array::from_fn(|j|position_attribute_curves[j].present.then_some(&position_attribute_curves[j])),attributes:&attributes};
            let velocity_attribute=VectorAttribute {key:7,table:&velocity_weights,probability:std::array::from_fn(|j|velocity_attribute_curves[j].present.then_some(&velocity_attribute_curves[j])),attributes:&attributes};
            let rotation_weight_mode=r["rotation_weight_mode"].as_u64().unwrap();
            let rotation_weight_table=r["rotation_weight_table"].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();
            let rotation_weight_curve=ProbabilityCurve {present:rotation_weight_mode!=0,constant:rotation_weight_mode==1,constant_value:0.5,fast:rotation_weight_mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let rotation_attribute=ScalarAttribute {key:7,table:&rotation_weight_table,probability:(rotation_weight_mode!=0).then_some(&rotation_weight_curve),attributes:&attributes};
            let rotation_tables=r["rotation_tables"].as_array().unwrap().iter().map(|t|t.as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>()).collect::<Vec<_>>();
            let rotation_curves=r["rotation_modes"].as_array().unwrap().iter().map(|v|{let mode=v.as_u64().unwrap();ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:0.5,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]}}).collect::<Vec<_>>();
            let rotation_sources=rotation_tables.iter().enumerate().map(|(i,table)|crate::native_simple_rotation_list::Source {table,axis:std::array::from_fn(|j|(r["rotation_axes"][i][j].as_f64().unwrap() as f32).to_bits()),probability:rotation_curves[i].present.then_some(&rotation_curves[i])}).collect::<Vec<_>>();
            let offset_weights=r["offset_weights"].as_array().unwrap().iter().map(|v|std::array::from_fn(|j|v[j].as_f64().unwrap() as f32)).collect::<Vec<[f32;3]>>();
            let offset_attribute_curves=std::array::from_fn::<_,3,_>(|j|{let mode=r["offset_weight_modes"][j].as_u64().unwrap();ProbabilityCurve {present:mode!=0,constant:mode==1,constant_value:0.5,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]}});
            let offset_attribute=VectorAttribute {key:7,table:&offset_weights,probability:std::array::from_fn(|j|offset_attribute_curves[j].present.then_some(&offset_attribute_curves[j])),attributes:&attributes};
            let factor_vector=|key:&str|std::array::from_fn(|j|(r[key][j].as_f64().unwrap() as f32).to_bits());
            let factor_attribute=|enabled:&str,multiplier:&str| (r[enabled]==1).then_some(crate::native_simple_birth_factors::AttributeFactor {key:7,multiplier:f(multiplier).to_bits(),attributes:&attributes});
            let mut previous=identity;previous[12..15].copy_from_slice(&[60f32,170.,280.].map(f32::to_bits));let mut inverse=identity;inverse[12..15].copy_from_slice(&[-60f32,-170.,-280.].map(f32::to_bits));let mut current=identity;current[12..15].copy_from_slice(&[110f32,220.,330.].map(f32::to_bits));
            let mut owner=cf::State {emission:emission::State {previous:f("previous").to_bits(),emitted:n("latch") as u8,counter:0,bounds_factor:1f32.to_bits()},frame:frame::State {particles:1,helper:None,animation:animation::State {clock:0.25f32.to_bits(),resource:0,pose_flag:0},tail:crate::native_simple_finish::State {previous,previous_inverse:inverse,last_time:10f32.to_bits(),finished:0}},pose:pose::State {current,previous,initial_inverse:inverse},particles:Some(particles::State {last_time:10f32.to_bits(),life:vec![],ages:vec![],active:0,positions:vec![],velocities:vec![],scales:vec![],factors:vec![],scalar:vec![],rates:vec![],auxiliary:vec![],attribute_a:vec![],attribute_b:vec![],previous_heights:vec![],bounds:bounds::State {bounds:Bounds {minimum:[-1f32,-2.,-3.].map(f32::to_bits),maximum:[1f32,2.,3.].map(f32::to_bits)},center:[60f32,170.,280.].map(f32::to_bits),last:10f32.to_bits()},counter:0}),birth:vec![]};
            let time=(10.+f("age")).to_bits();let input=cf::Input {frame:frame::Input {control:control::Input {flags:0,time,start:10f32.to_bits(),life:1f32.to_bits(),lower:100f32.to_bits(),upper:100f32.to_bits(),delay:0,emitter_linger:0,particle_linger:0,last_step:n("frame_flag")},position:[110f32,220.,330.].map(f32::to_bits),previous_position:[60f32,170.,280.].map(f32::to_bits),reset_value:0,manager_flag:None,definition_kind:0,clip_index:0,mapping:0,inverse_fallback:identity},pose:pose::Input {emitter_local:1,warm:n("latch") as u8,system_matrix:identity,position:[110f32,220.,330.].map(f32::to_bits),inverse_fallback:identity,modifier:0},particles:particles::Input {time,cap:f32::MAX.to_bits(),birth:&[],bounds_flag:n("frame_flag") as u8,previous_position:[60f32,170.,280.].map(f32::to_bits),current_position:[110f32,220.,330.].map(f32::to_bits),initial_inverse:inverse,current_matrix:current,bind_begin:0,bind_end:0,sticky:0,local:0,circular:0,direction:0,force_resource:0,force_graph:None,scalar_enabled:0,scalar_table:particles::Table {values:&[],probability:None},scale_table:particles::Table {values:&[1.],probability:None},attributes:[particles::Attribute {mode:0,multiplier:0.5f32.to_bits(),offset:0},particles::Attribute {mode:0,multiplier:1f32.to_bits(),offset:0}],bounds_factor:1f32.to_bits(),terrain_enabled:0}};
            let mut rng=Rng55 {words:std::array::from_fn(|j|12345+j as u32*13579),first:0,second:0};let mut events=vec![];
            let factor_sources=crate::native_simple_birth_factors::Sources {context:factor_vector("factor_context"),offset_coefficients:factor_vector("factor_offset_coefficients"),bounds_coefficients:factor_vector("factor_bounds_coefficients"),life_multiplier:(r["factor_life_enabled"]==1).then_some(f("factor_life_value").to_bits()),offset_attribute:factor_attribute("factor_offset_enabled","factor_offset_multiplier"),size_attribute:factor_attribute("factor_size_enabled","factor_size_multiplier")};
            let sources=crate::native_simple_emission_sources::Sources {base:&birth_base,curves:&curves,attributes:crate::native_simple_emission_sources::Attributes {life:Some(&life_attribute),position:Some(&position_attribute),velocity:Some(&velocity_attribute),rotation:Some(&rotation_attribute),offset:Some(&offset_attribute)},factors:&factor_sources,rotations:&rotation_sources,rate_table:&rate_table,rate_probability:(mode!=0).then_some(&rate_curve),rate_factor:f("rate_factor"),rate_attribute:Some(&attribute)};
            cf::update(&mut owner,&input,&mut rng,&mut FrameProducedSources {sources:&sources,single:n("single")},&mut |_|Err("native terrain disabled"),&mut |event|match event {particles::Event::Entry(a)=>events.push(serde_json::json!(format!("0x{a:x}"))),_=>panic!("no native force/circular child in this fixture")}).unwrap();
            let s=owner.particles.as_ref().unwrap();let a=&r["arrays"];
            for (actual,key) in [(&owner.birth,"0x8"),(&s.life,"0x14"),(&s.ages,"0x20"),(&s.scales,"0x44"),(&s.factors,"0x50"),(&s.scalar,"0x5c"),(&s.rates,"0x68"),(&s.auxiliary,"0x74"),(&s.attribute_a,"0x80"),(&s.attribute_b,"0x8c"),(&s.previous_heights,"0x98")]{assert_eq!(*actual,words(&a[key]),"{key} case{index}");}
            assert_eq!(s.positions.iter().flatten().copied().collect::<Vec<_>>(),words(&a["0x2c"]),"position case{index}");assert_eq!(s.velocities.iter().flatten().copied().collect::<Vec<_>>(),words(&a["0x38"]),"velocity case{index}");
            for (actual,key) in [(s.last_time,"last_time"),(s.active,"active"),(s.counter,"update_counter"),(s.bounds.last,"bounds_last"),(owner.emission.previous,"last_emission"),(owner.emission.counter,"counter"),(owner.emission.bounds_factor,"bounds_factor"),(owner.emission.emitted as u32,"emitted"),(owner.frame.tail.last_time,"emitter_last_time"),(owner.frame.tail.finished as u32,"emitter_finished"),(owner.frame.animation.clock,"emitter_clock")]{assert_eq!(actual,n(key),"{key} case{index}");}
            for (actual,key) in [(s.bounds.bounds.minimum.as_slice(),"minimum"),(s.bounds.bounds.maximum.as_slice(),"maximum"),(s.bounds.center.as_slice(),"center"),(owner.pose.current.as_slice(),"emitter_current"),(owner.frame.tail.previous.as_slice(),"emitter_previous"),(owner.frame.tail.previous_inverse.as_slice(),"emitter_inverse")]{assert_eq!(actual,words(&r[key]),"{key} case{index}");}
            assert_eq!(rng.words.as_slice(),words(&r["rng"]),"rng case{index}");assert_eq!(rng.first,n("first"));assert_eq!(rng.second,n("second"));assert_eq!(events,r["events"].as_array().unwrap().clone(),"events case{index}");
        }
    }
}
