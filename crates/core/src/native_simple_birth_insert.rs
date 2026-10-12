//! Actual943CD0 insertion/reuse policy after source-owned birth sampling.
use crate::{native_simple_particle_update::{State,Table},native_random::Rng55};
pub struct Input<'a> {pub time:u32,pub life:u32,pub position:[u32;3],pub velocity:[u32;3],pub scalar:u32,pub rate:u32,pub factor:u32,pub auxiliary:u32,pub scale:Table<'a>,pub terrain:u8}
/// Finite birth payloads, aligned actual storage. Native first age>=1 slot is
/// reused before growing arrays. Active count/counter belong to other bodies.
pub fn insert(state:&mut State,birth:&mut Vec<u32>,input:&Input,rng:&mut Rng55,height:&mut impl FnMut([u32;3])->Result<u32,&'static str>)->Result<usize,&'static str> {
    let count=birth.len();
    if [state.life.len(),state.ages.len(),state.positions.len(),state.velocities.len(),state.scales.len(),state.factors.len(),state.scalar.len(),state.rates.len(),state.auxiliary.len(),state.attribute_a.len(),state.attribute_b.len()].iter().any(|n|*n!=count) {return Err("misaligned native birth storage");}
    if ![input.time,input.life,input.scalar,input.rate,input.factor,input.auxiliary].iter().chain(&input.position).chain(&input.velocity).all(|v|f32::from_bits(*v).is_finite()){return Err("unqualified nonfinite birth payload");}
    let mut random=rng.clone();let mut scale=[0];
    crate::native_simple_scalar_phase::update(1,input.scale.values,input.scale.probability,&[0],&mut scale,&mut random)?;
    let scale=(f32::from_bits(scale[0])*f32::from_bits(input.factor)).to_bits();
    let index=state.ages.iter().position(|age|f32::from_bits(*age)>=1.).unwrap_or(count);
    if input.terrain!=0&&index<count&&index>=state.previous_heights.len(){return Err("unqualified missing recycled terrain slot");}
    let terrain=if input.terrain!=0 {Some(height([input.position[0],input.position[2],input.position[1]])?)}else{None};
    fn scalar(v:&mut Vec<u32>,i:usize,x:u32){if i==v.len(){v.push(x);}else{v[i]=x;}}
    fn triple(v:&mut Vec<[u32;3]>,i:usize,x:[u32;3]){if i==v.len(){v.push(x);}else{v[i]=x;}}
    scalar(birth,index,input.time);scalar(&mut state.life,index,input.life);scalar(&mut state.ages,index,0);
    triple(&mut state.positions,index,input.position);triple(&mut state.velocities,index,input.velocity);
    for (array,value) in [(&mut state.scales,scale),(&mut state.factors,input.factor),(&mut state.scalar,input.scalar),(&mut state.rates,input.rate),(&mut state.auxiliary,input.auxiliary),(&mut state.attribute_a,0),(&mut state.attribute_b,0)]{scalar(array,index,value);}
    //943CD0 append follows98's own end pointer; retained heights may outnumber
    // particle slots. Reusing a particle writes its indexed98 slot instead.
    if let Some(height)=terrain{if index==count{state.previous_heights.push(height);}else{state.previous_heights[index]=height;}}
    *rng=random;Ok(index)
}
#[cfg(test)]
mod tests {
    use super::*;use serde_json::Value;
    fn words(v:&Value)->Vec<u32>{v.as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect()}
    #[test]
    fn insertion_reuse_probability_and_terrain_match80_native_cpu_cases() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/simple_birth_insert_contract.json")).unwrap();let rows=proof["cases"].as_array().unwrap();assert_eq!(rows.len(),80);
        for (i,r) in rows.iter().enumerate(){
            let a=&r["initial"];let triples=|key:&str|words(&a[key]).chunks_exact(3).map(|v|v.try_into().unwrap()).collect::<Vec<[u32;3]>>();
            let mut s=State {last_time:0,life:words(&a["0x14"]),ages:words(&a["0x20"]),active:0,positions:triples("0x2c"),velocities:triples("0x38"),scales:words(&a["0x44"]),factors:words(&a["0x50"]),scalar:words(&a["0x5c"]),rates:words(&a["0x68"]),auxiliary:words(&a["0x74"]),attribute_a:words(&a["0x80"]),attribute_b:words(&a["0x8c"]),previous_heights:words(&a["0x98"]),bounds:crate::native_simple_bounds_policy::State {bounds:crate::native_simple_particle_bounds::Bounds {minimum:[0;3],maximum:[0;3]},center:[0;3],last:0},counter:0};
            let mode=r["mode"].as_u64().unwrap();let curve=crate::native_probability_curve::ProbabilityCurve {present:true,constant:mode==1,constant_value:0.5,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let mut birth=words(&a["0x8"]);let mut rng=Rng55 {words:std::array::from_fn(|j|12345+j as u32*13579),first:0,second:0};let mut events=vec![];
            insert(&mut s,&mut birth,&Input {time:10.125f32.to_bits(),life:2f32.to_bits(),position:[3f32,4.,5.].map(f32::to_bits),velocity:[0.25f32,-0.5,1.].map(f32::to_bits),scalar:(-0.5f32).to_bits(),rate:500f32.to_bits(),factor:r["factor"].as_u64().unwrap() as u32,auxiliary:0.125f32.to_bits(),scale:Table {values:&[1.,2.,3.],probability:if mode==0{None}else{Some(&curve)}},terrain:r["terrain"].as_u64().unwrap() as u8},&mut rng,&mut |arguments|{events.push(serde_json::json!({"arguments":arguments,"height":2f32.to_bits()}));Ok(2f32.to_bits())}).unwrap();
            let arrays=&r["cpu"]["arrays"];
            for (actual,key) in [(&birth,"0x8"),(&s.life,"0x14"),(&s.ages,"0x20"),(&s.scales,"0x44"),(&s.factors,"0x50"),(&s.scalar,"0x5c"),(&s.rates,"0x68"),(&s.auxiliary,"0x74"),(&s.attribute_a,"0x80"),(&s.attribute_b,"0x8c"),(&s.previous_heights,"0x98")]{assert_eq!(*actual,words(&arrays[key]),"{key} case{i}");}
            assert_eq!(s.positions.iter().flatten().copied().collect::<Vec<_>>(),words(&arrays["0x2c"]),"positions case{i}");assert_eq!(s.velocities.iter().flatten().copied().collect::<Vec<_>>(),words(&arrays["0x38"]),"velocities case{i}");
            assert_eq!(rng.words.as_slice(),words(&r["cpu"]["rng"]),"rng case{i}");assert_eq!(rng.first as u64,r["cpu"]["first"].as_u64().unwrap());assert_eq!(rng.second as u64,r["cpu"]["second"].as_u64().unwrap());assert_eq!(events,r["cpu"]["events"].as_array().unwrap().clone(),"height events case{i}");
        }
    }
    #[test]
    fn insertion_matches_all13_arrays_from48_native_cpu_emissions() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/simple_birth_cpu_contract.json")).unwrap();let rows=proof["cases"].as_array().unwrap();assert_eq!(rows.len(),48);
        for (i,row) in rows.iter().enumerate(){
            let r=&row["cpu"];let mut s=State {last_time:0,life:vec![],ages:vec![],active:0,positions:vec![],velocities:vec![],scales:vec![],factors:vec![],scalar:vec![],rates:vec![],auxiliary:vec![],attribute_a:vec![],attribute_b:vec![],previous_heights:vec![],bounds:crate::native_simple_bounds_policy::State {bounds:crate::native_simple_particle_bounds::Bounds {minimum:[0;3],maximum:[0;3]},center:[0;3],last:0},counter:0};
            let mut birth=vec![];let mut rng=Rng55 {words:std::array::from_fn(|j|12345+j as u32*13579),first:0,second:0};
            for (index,c) in r["calls"].as_array().unwrap().iter().enumerate(){
                let f=|v:&Value|(v.as_f64().unwrap() as f32).to_bits();let scalars=|j:usize|f(&c["scalars"][j]);
                let auxiliary=rng.fraction().to_bits();assert_eq!(auxiliary,scalars(3),"birth draw case{i}/{index}");
                assert_eq!(insert(&mut s,&mut birth,&Input {time:f(&c["now"]),life:f(&c["life"]),position:std::array::from_fn(|j|f(&c["position"][j])),velocity:std::array::from_fn(|j|f(&c["velocity"][j])),scalar:scalars(0),rate:scalars(1),factor:scalars(2),auxiliary,scale:Table {values:&[1.],probability:None},terrain:0},&mut rng,&mut |_|panic!("native terrain flag is zero")).unwrap(),index);
            }
            let arrays=&r["stored"]["arrays"];
            for (actual,key) in [(&birth,"0x8"),(&s.life,"0x14"),(&s.ages,"0x20"),(&s.scales,"0x44"),(&s.factors,"0x50"),(&s.scalar,"0x5c"),(&s.rates,"0x68"),(&s.auxiliary,"0x74"),(&s.attribute_a,"0x80"),(&s.attribute_b,"0x8c"),(&s.previous_heights,"0x98")]{assert_eq!(*actual,words(&arrays[key]),"{key} case{i}");}
            assert_eq!(s.positions.iter().flatten().copied().collect::<Vec<_>>(),words(&arrays["0x2c"]),"positions case{i}");assert_eq!(s.velocities.iter().flatten().copied().collect::<Vec<_>>(),words(&arrays["0x38"]),"velocities case{i}");
            assert_eq!(rng.words.as_slice(),words(&r["stored"]["rng"]),"rng case{i}");assert_eq!(rng.first as u64,r["stored"]["first"].as_u64().unwrap());assert_eq!(rng.second as u64,r["stored"]["second"].as_u64().unwrap());assert_eq!(s.active as u64,r["stored"]["active"].as_u64().unwrap());
        }
    }
}
