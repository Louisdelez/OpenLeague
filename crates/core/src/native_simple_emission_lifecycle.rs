//!941F00 lifecycle with prepared birth values; parameter production explicit.
use crate::{native_simple_emission_count as count,native_simple_birth_insert as insert,native_simple_particle_update::{State as Particles,Table},native_random::Rng55};
#[derive(Clone,Debug,PartialEq,Eq)]
pub struct State {pub previous:u32,pub emitted:u8,pub counter:u32,pub bounds_factor:u32}
pub struct Prepared<'a> {
    pub life:u32,pub scalar:u32,pub rate:u32,pub factor:u32,
    pub offset:[u32;3],pub position_offset:[u32;3],pub velocity:[u32;3],
    pub matrix:[u32;16],pub previous_position:[u32;3],pub current_position:[u32;3],
    pub bounds_factor:u32,pub scale:Table<'a>,pub terrain:u8,
}
/// Prepared values have already passed the native parameter/attribute/rotation
/// producers. This function does not substitute those source obligations.
/// Constant profile composition is qualified; generalized producers are pending.
#[derive(Clone,Copy)]
pub struct Birth {pub life:u32,pub scalar:u32,pub rotation:u32,pub factor:u32,pub offset:[u32;3],pub position_offset:[u32;3],pub velocity:[u32;3]}
pub fn update(state:&mut State,timing:count::Input,prepared:&Prepared,storage:&mut Particles,birth:&mut Vec<u32>,rng:&mut Rng55,height:&mut impl FnMut([u32;3])->Result<u32,&'static str>)->Result<i32,&'static str> {
    update_with_source(state,timing,prepared,storage,birth,rng,height,&mut |_,_|Ok(Birth {life:prepared.life,scalar:prepared.scalar,rotation:prepared.rate,factor:prepared.factor,offset:prepared.offset,position_offset:prepared.position_offset,velocity:prepared.velocity}))
}
/// Complete per-birth source stage runs before auxiliary/insertion draws, using
/// the same transactional RNG. Source must preserve intervening attribute/vector
/// probability order. External callbacks are not rolled back on failure.
pub fn update_with_source(state:&mut State,timing:count::Input,prepared:&Prepared,storage:&mut Particles,birth:&mut Vec<u32>,rng:&mut Rng55,height:&mut impl FnMut([u32;3])->Result<u32,&'static str>,source:&mut impl FnMut(i32,&mut Rng55)->Result<Birth,&'static str>)->Result<i32,&'static str> {
    update_with_rotation_source(state,timing,prepared,storage,birth,rng,height,source,&mut |_,position,velocity,_|Ok((position,velocity)))
}
/// Native rotation-list stage follows the auxiliary draw and transforms the
/// final11C birth offset and velocity. The earlier A8 position offset is added
/// afterwards. It shares the transactional birth RNG.
/// External callback state is not rolled back when a later stage fails.
pub fn update_with_rotation_source(state:&mut State,mut timing:count::Input,prepared:&Prepared,storage:&mut Particles,birth:&mut Vec<u32>,rng:&mut Rng55,height:&mut impl FnMut([u32;3])->Result<u32,&'static str>,source:&mut impl FnMut(i32,&mut Rng55)->Result<Birth,&'static str>,rotations:&mut impl FnMut(i32,[u32;3],[u32;3],&mut Rng55)->Result<([u32;3],[u32;3]),&'static str>)->Result<i32,&'static str> {
    timing.previous=f32::from_bits(state.previous);timing.emitted=state.emitted;
    let number=count::evaluate(timing)?;if number==0{return Ok(0);}
    if ![prepared.life,prepared.scalar,prepared.rate,prepared.factor,prepared.bounds_factor].iter().chain(&prepared.offset).chain(&prepared.position_offset).chain(&prepared.velocity).chain(&prepared.matrix).chain(&prepared.previous_position).chain(&prepared.current_position).all(|v|f32::from_bits(*v).is_finite()){return Err("unqualified prepared emission values");}
    let mut owner=state.clone();let mut particles=storage.clone();let mut births=birth.clone();let mut random=rng.clone();
    owner.previous=timing.time.to_bits();owner.bounds_factor=prepared.bounds_factor;
    let transform=|v:[f32;3]|std::array::from_fn::<_,3,_>(|j|((v[0]*f32::from_bits(prepared.matrix[j]))+(v[1]*f32::from_bits(prepared.matrix[4+j])))+(v[2]*f32::from_bits(prepared.matrix[8+j])));
    for index in 1..=number {
        let mut born=source(index,&mut random)?;
        if ![born.life,born.scalar,born.rotation,born.factor].iter().chain(&born.offset).chain(&born.position_offset).chain(&born.velocity).all(|v|f32::from_bits(*v).is_finite()){return Err("unqualified per-birth source values");}
        //942C3C auxiliary draw precedes list probabilities and insertion draws.
        let auxiliary=random.fraction().to_bits();
        (born.offset,born.velocity)=rotations(index,born.offset,born.velocity,&mut random)?;
        if !born.offset.iter().chain(&born.velocity).all(|v|f32::from_bits(*v).is_finite()){return Err("unqualified rotated per-birth vectors");}
        let local=std::array::from_fn::<_,3,_>(|j|f32::from_bits(born.offset[j])+f32::from_bits(born.position_offset[j]));
        let transformed=transform(local);let velocity=transform(born.velocity.map(f32::from_bits)).map(f32::to_bits);
        let fraction=(index as f32)*(1f32/number as f32);
        let position=std::array::from_fn(|j|{let previous=f32::from_bits(prepared.previous_position[j]);let delta=f32::from_bits(prepared.current_position[j])-previous;(transformed[j]+(previous+delta*fraction)).to_bits()});
        insert::insert(&mut particles,&mut births,&insert::Input {time:timing.time.to_bits(),life:born.life,position,velocity,scalar:born.scalar,rate:born.rotation,factor:born.factor,auxiliary,scale:prepared.scale,terrain:prepared.terrain},&mut random,height)?;
    }
    owner.emitted=1;owner.counter=owner.counter.wrapping_add(number as u32);
    *state=owner;*storage=particles;*birth=births;*rng=random;Ok(number)
}
/// Source rate sampling is gated before consuming shared RNG. Even when the
/// resulting count is zero, its draws are committed. Failed later production
/// leaves all owned state and RNG unchanged; external callbacks are not undone.
pub fn update_with_rate_source(state:&mut State,timing:count::Input,prepared:&Prepared,storage:&mut Particles,birth:&mut Vec<u32>,rng:&mut Rng55,height:&mut impl FnMut([u32;3])->Result<u32,&'static str>,rate:&mut impl FnMut(&mut Rng55)->Result<f32,&'static str>,source:&mut impl FnMut(i32,&mut Rng55)->Result<Birth,&'static str>)->Result<i32,&'static str> {
    update_with_rate_and_rotation_source(state,timing,prepared,storage,birth,rng,height,rate,source,&mut |_,offset,velocity,_|Ok((offset,velocity)))
}
/// Compose rate/attribute sampling and per-birth rotations on one RNG, retaining
/// the early rate gate, zero-count rate commit and owned-state rollback contract.
pub fn update_with_rate_and_rotation_source(state:&mut State,mut timing:count::Input,prepared:&Prepared,storage:&mut Particles,birth:&mut Vec<u32>,rng:&mut Rng55,height:&mut impl FnMut([u32;3])->Result<u32,&'static str>,rate:&mut impl FnMut(&mut Rng55)->Result<f32,&'static str>,source:&mut impl FnMut(i32,&mut Rng55)->Result<Birth,&'static str>,rotations:&mut impl FnMut(i32,[u32;3],[u32;3],&mut Rng55)->Result<([u32;3],[u32;3]),&'static str>)->Result<i32,&'static str> {
    timing.previous=f32::from_bits(state.previous);timing.emitted=state.emitted;
    if !count::eligible(timing)?{return Ok(0);}
    let mut owner=state.clone();let mut particles=storage.clone();let mut births=birth.clone();let mut random=rng.clone();
    timing.rate=rate(&mut random)?;
    let result=update_with_rotation_source(&mut owner,timing,prepared,&mut particles,&mut births,&mut random,height,source,rotations)?;
    *state=owner;*storage=particles;*birth=births;*rng=random;Ok(result)
}
#[cfg(test)]
mod tests {
    use super::*;use serde_json::Value;
    fn words(v:&Value)->Vec<u32>{v.as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect()}
    #[test]
    fn prepared_constant_lifecycle_matches128_whole_native_emissions() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/simple_emission_lifecycle_contract.json")).unwrap();let rows=proof["cases"].as_array().unwrap();assert_eq!(rows.len(),128);
        let identity=std::array::from_fn(|j|if [0,5,10,15].contains(&j){1f32.to_bits()}else{0});
        for (index,row) in rows.iter().enumerate(){let r=&row["cpu"];let f=|key:&str|r[key].as_f64().unwrap() as f32;
            let mut owner=State {previous:f("previous").to_bits(),emitted:r["latch"].as_u64().unwrap() as u8,counter:0,bounds_factor:0};
            let mut particles=Particles {last_time:0,life:vec![],ages:vec![],active:0,positions:vec![],velocities:vec![],scales:vec![],factors:vec![],scalar:vec![],rates:vec![],auxiliary:vec![],attribute_a:vec![],attribute_b:vec![],previous_heights:vec![],bounds:crate::native_simple_bounds_policy::State {bounds:crate::native_simple_particle_bounds::Bounds {minimum:[0;3],maximum:[0;3]},center:[0;3],last:0},counter:0};
            let mut birth=vec![];let mut rng=Rng55 {words:std::array::from_fn(|j|12345+j as u32*13579),first:0,second:0};
            update(&mut owner,count::Input {time:10.+f("age"),start:10.,previous:f("previous"),life:1.,delay:0.,period:100.,window:100.,rate:f("rate"),single:r["single"].as_u64().unwrap() as u32,emitted:r["latch"].as_u64().unwrap() as u8},&Prepared {life:2f32.to_bits(),scalar:0,rate:500f32.to_bits(),factor:0,offset:[10f32,20.,30.].map(f32::to_bits),position_offset:[0;3],velocity:[0;3],matrix:identity,previous_position:[60f32,170.,280.].map(f32::to_bits),current_position:[110f32,220.,330.].map(f32::to_bits),bounds_factor:1f32.to_bits(),scale:Table {values:&[1.],probability:None},terrain:0},&mut particles,&mut birth,&mut rng,&mut |_|panic!("native terrain flag is zero")).unwrap();
            let a=&r["arrays"];
            for (actual,key) in [(&birth,"0x8"),(&particles.life,"0x14"),(&particles.ages,"0x20"),(&particles.scales,"0x44"),(&particles.factors,"0x50"),(&particles.scalar,"0x5c"),(&particles.rates,"0x68"),(&particles.auxiliary,"0x74"),(&particles.attribute_a,"0x80"),(&particles.attribute_b,"0x8c"),(&particles.previous_heights,"0x98")]{assert_eq!(*actual,words(&a[key]),"{key} case{index}");}
            assert_eq!(particles.positions.iter().flatten().copied().collect::<Vec<_>>(),words(&a["0x2c"]),"position case{index}");assert_eq!(particles.velocities.iter().flatten().copied().collect::<Vec<_>>(),words(&a["0x38"]),"velocity case{index}");
            for (actual,key) in [(owner.previous,"last_emission"),(owner.counter,"counter"),(owner.bounds_factor,"bounds_factor"),(owner.emitted as u32,"emitted")]{assert_eq!(actual as u64,r[key].as_u64().unwrap(),"{key} case{index}");}
            assert_eq!(rng.words.as_slice(),words(&r["rng"]),"rng case{index}");assert_eq!(rng.first as u64,r["first"].as_u64().unwrap());assert_eq!(rng.second as u64,r["second"].as_u64().unwrap());
        }
    }
}
