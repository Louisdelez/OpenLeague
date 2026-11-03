use super::*;
use openleague_core::{native_simple_particle_update as particles,native_simple_birth_factors as factors,native_simple_rotation_list as rotations,native_probability_curve::ProbabilityCurve};
fn identity()->[u32;16]{std::array::from_fn(|i|if [0,5,10,15].contains(&i){1f32.to_bits()}else{0})}
#[test] fn source_parameters_complete_lifecycle_with_moving_owner_and_transactional_failures(){let mut groups=0;
{
let fields:std::collections::HashMap<String,Vec<f32>>=[("e-rate".to_owned(),vec![50.0f32]),("p-life".to_owned(),vec![0.9f32]),("p-quadrot".to_owned(),vec![0.0f32]),("p-scale".to_owned(),vec![3.0f32]),("p-rotvel".to_owned(),vec![1.0f32]),("p-rotvel1".to_owned(),vec![0.0f32,0.0f32]),("p-rotvel2".to_owned(),vec![1.0f32,180.0f32]),("p-xscale".to_owned(),vec![1.0f32]),("p-xscale1".to_owned(),vec![0.0f32,5.0f32]),("p-xscale2".to_owned(),vec![1.0f32,0.4f32]),("p-offset".to_owned(),vec![20.0f32,50.0f32,0.0f32]),("p-offsetYP1".to_owned(),vec![0.0f32,0.0f32]),("p-offsetXP2".to_owned(),vec![1.0f32,1.0f32]),("p-offsetYP2".to_owned(),vec![1.0f32,3.0f32]),("p-offsetXP1".to_owned(),vec![0.0f32,0.0f32]),("p-vel".to_owned(),vec![0.0f32,100.0f32,0.0f32]),("p-velYP1".to_owned(),vec![0.0f32,0.5f32]),("p-velYP2".to_owned(),vec![1.0f32,1.5f32])].into_iter().collect();
let p=Parameters::read(|key|fields.get(key).cloned()).unwrap();
let mut owner=Owner{system_matrix:identity(),position:[100f32,200.,300.].map(f32::to_bits),inverse_fallback:identity()};
let rotation_probability=ProbabilityCurve{present:true,constant:false,constant_value:1.,fast:true,begin:0.,difference:360.,times:vec![0.,1.],values:vec![0.,360.]};
let rotations=vec![rotations::Source{table:&[1.],axis:[0f32,1.,0.].map(f32::to_bits),probability:Some(&rotation_probability)}];
let d=Definition{flags:0,life:1.5f32,lower:f32::MAX,upper:f32::MAX,delay:0.,emitter_linger:1.5f32,particle_linger:10.,period:f32::MAX,window:f32::MAX,single:0,emitter_local:1,sticky:0,local:0,circular:0,direction:0,scalar_enabled:0,bind:[1f32.to_bits();2],
attributes:[particles::Attribute{mode:1,multiplier:1f32.to_bits(),offset:0},particles::Attribute{mode:0,multiplier:1.0f32.to_bits(),offset:0}],rotations:&rotations,
factors:factors::Sources{context:[0;3],offset_coefficients:[0;3],bounds_coefficients:[0;3],life_multiplier:None,offset_attribute:None,size_attribute:None},force_resource:0,forces:None,terrain:0,quad_rotation_fallback:0,reset_value:0,manager_flag:None,definition_kind:0,rate_factor:1.,position:[0;3],position_probabilities:[None;3]};
let mut host=Host::new(&owner,0.).unwrap();let mut rng=Rng55::seeded(19);let mut high=0;
for n in 1..=151 {let time=(n-1) as f32/30.;if n==2 {
let before=host.state.birth.clone();let prior=(rng.first,rng.second,rng.words);let mut invalid=Owner{system_matrix:owner.system_matrix,position:owner.position,inverse_fallback:owner.inverse_fallback};invalid.position[0]=f32::NAN.to_bits();
assert!(host.planned(n,time,0.,&p,&d,&invalid,&rng,&mut |_|Err("disabled terrain")).is_err());assert_eq!(host.state.birth,before);assert_eq!((rng.first,rng.second,rng.words),prior);}
owner.position[0]=(100.+time*10.).to_bits();let (next,random)=host.planned(n,time,0.,&p,&d,&owner,&rng,&mut |_|Err("disabled terrain")).unwrap().unwrap();host=next;rng=random;
let state=host.state.particles.as_ref().unwrap();high=high.max(state.ages.iter().filter(|v|f32::from_bits(**v)<1.).count());assert!(state.positions.iter().flatten().all(|v|f32::from_bits(*v).is_finite()));
assert!(host.planned(n,time,0.,&p,&d,&owner,&rng,&mut |_|Err("disabled terrain")).unwrap().is_none());


}
assert!(host.finished());assert!(high>8);assert!(host.state.emission.counter>20,"births {}",host.state.emission.counter);assert_eq!(host.state.particles.as_ref().unwrap().active,0);assert_eq!(host.state.pose.current[12],owner.position[0]);
println!("Odin_HealthPackHeal/starTrailspin: {} births, {} peak live, finished",host.state.emission.counter,high);groups+=1;
}
{
let fields:std::collections::HashMap<String,Vec<f32>>=[("e-rate".to_owned(),vec![50.0f32]),("p-life".to_owned(),vec![1.0f32]),("p-scale".to_owned(),vec![100.0f32,100.0f32,100.0f32]),("p-rotvel".to_owned(),vec![-800.0f32,0.0f32,0.0f32]),("p-xscale".to_owned(),vec![1.0f32,1.0f32,1.0f32]),("p-xscale1".to_owned(),vec![0.0f32,1.0f32,1.0f32,1.0f32]),("p-xscale2".to_owned(),vec![1.0f32,0.525518f32,1.0f32,1.0f32]),("p-offset".to_owned(),vec![0.0f32,50.0f32,0.0f32]),("p-offsetYP1".to_owned(),vec![0.0f32,1.0f32]),("p-offsetYP2".to_owned(),vec![1.0f32,0.0f32]),("p-vel".to_owned(),vec![0.0f32,100.0f32,0.0f32])].into_iter().collect();
let p=Parameters::read(|key|fields.get(key).cloned()).unwrap();
let mut owner=Owner{system_matrix:identity(),position:[100f32,200.,300.].map(f32::to_bits),inverse_fallback:identity()};
let rotation_probability=ProbabilityCurve{present:true,constant:false,constant_value:1.,fast:true,begin:0.,difference:360.,times:vec![0.,1.],values:vec![0.,360.]};
let rotations=vec![];
let d=Definition{flags:0,life:1.0f32,lower:f32::MAX,upper:f32::MAX,delay:0.,emitter_linger:1.0f32,particle_linger:10.,period:f32::MAX,window:f32::MAX,single:0,emitter_local:1,sticky:0,local:0,circular:0,direction:0,scalar_enabled:0,bind:[1f32.to_bits();2],
attributes:[particles::Attribute{mode:1,multiplier:1f32.to_bits(),offset:0},particles::Attribute{mode:0,multiplier:1.0f32.to_bits(),offset:0}],rotations:&rotations,
factors:factors::Sources{context:[0;3],offset_coefficients:[0;3],bounds_coefficients:[0;3],life_multiplier:None,offset_attribute:None,size_attribute:None},force_resource:0,forces:None,terrain:0,quad_rotation_fallback:0,reset_value:0,manager_flag:None,definition_kind:0,rate_factor:1.,position:[0;3],position_probabilities:[None;3]};
let mut host=Host::new(&owner,0.).unwrap();let mut rng=Rng55::seeded(19);let mut high=0;
for n in 1..=151 {let time=(n-1) as f32/30.;if n==2 {
let before=host.state.birth.clone();let prior=(rng.first,rng.second,rng.words);let mut invalid=Owner{system_matrix:owner.system_matrix,position:owner.position,inverse_fallback:owner.inverse_fallback};invalid.position[0]=f32::NAN.to_bits();
assert!(host.planned(n,time,0.,&p,&d,&invalid,&rng,&mut |_|Err("disabled terrain")).is_err());assert_eq!(host.state.birth,before);assert_eq!((rng.first,rng.second,rng.words),prior);}
owner.position[0]=(100.+time*10.).to_bits();let (next,random)=host.planned(n,time,0.,&p,&d,&owner,&rng,&mut |_|Err("disabled terrain")).unwrap().unwrap();host=next;rng=random;
let state=host.state.particles.as_ref().unwrap();high=high.max(state.ages.iter().filter(|v|f32::from_bits(**v)<1.).count());assert!(state.positions.iter().flatten().all(|v|f32::from_bits(*v).is_finite()));
assert!(host.planned(n,time,0.,&p,&d,&owner,&rng,&mut |_|Err("disabled terrain")).unwrap().is_none());
if n==1 {assert_eq!(state.rates[0],(-800f32).to_bits());assert_eq!(state.factors[0],100f32.to_bits());}

}
assert!(host.finished());assert!(high>8);assert!(host.state.emission.counter>20,"births {}",host.state.emission.counter);assert_eq!(host.state.particles.as_ref().unwrap().active,0);assert_eq!(host.state.pose.current[12],owner.position[0]);
println!("Odin_HealthPackHeal/mesh: {} births, {} peak live, finished",host.state.emission.counter,high);groups+=1;
}
{
let fields:std::collections::HashMap<String,Vec<f32>>=[("e-rate".to_owned(),vec![50.0f32]),("p-life".to_owned(),vec![1.3f32]),("p-quadrot".to_owned(),vec![1.0f32]),("p-scale".to_owned(),vec![5.0f32]),("p-rotvel".to_owned(),vec![0.0f32,0.0f32,0.0f32]),("p-xscale".to_owned(),vec![1.0f32]),("p-xscale1".to_owned(),vec![0.0f32,0.0f32,0.0f32,0.0f32]),("p-xscale2".to_owned(),vec![0.0772963f32,5.19004f32,0.0f32,0.0f32]),("p-xscale3".to_owned(),vec![0.248f32,5.858f32,0.0f32,0.0f32]),("p-xscale4".to_owned(),vec![1.0f32,0.0f32,0.0f32,0.0f32]),("p-offset".to_owned(),vec![40.0f32,0.0f32,0.0f32]),("p-vel".to_owned(),vec![0.0f32,300.0f32,-200.0f32]),("p-velYP1".to_owned(),vec![0.0f32,0.25999999046325684f32]),("p-velYP2".to_owned(),vec![1.0f32,1.0f32])].into_iter().collect();
let p=Parameters::read(|key|fields.get(key).cloned()).unwrap();
let mut owner=Owner{system_matrix:identity(),position:[100f32,200.,300.].map(f32::to_bits),inverse_fallback:identity()};
let rotation_probability=ProbabilityCurve{present:true,constant:false,constant_value:1.,fast:true,begin:0.,difference:360.,times:vec![0.,1.],values:vec![0.,360.]};
let rotations=vec![rotations::Source{table:&[1.],axis:[0f32,1.,0.].map(f32::to_bits),probability:Some(&rotation_probability)}];
let d=Definition{flags:0,life:1.0f32,lower:f32::MAX,upper:f32::MAX,delay:0.,emitter_linger:1.0f32,particle_linger:10.,period:f32::MAX,window:f32::MAX,single:0,emitter_local:1,sticky:0,local:0,circular:0,direction:0,scalar_enabled:0,bind:[1f32.to_bits();2],
attributes:[particles::Attribute{mode:1,multiplier:1f32.to_bits(),offset:0},particles::Attribute{mode:0,multiplier:1.0f32.to_bits(),offset:0}],rotations:&rotations,
factors:factors::Sources{context:[0;3],offset_coefficients:[0;3],bounds_coefficients:[0;3],life_multiplier:None,offset_attribute:None,size_attribute:None},force_resource:0,forces:None,terrain:0,quad_rotation_fallback:0,reset_value:0,manager_flag:None,definition_kind:0,rate_factor:1.,position:[0;3],position_probabilities:[None;3]};
let mut host=Host::new(&owner,0.).unwrap();let mut rng=Rng55::seeded(19);let mut high=0;
for n in 1..=151 {let time=(n-1) as f32/30.;if n==2 {
let before=host.state.birth.clone();let prior=(rng.first,rng.second,rng.words);let mut invalid=Owner{system_matrix:owner.system_matrix,position:owner.position,inverse_fallback:owner.inverse_fallback};invalid.position[0]=f32::NAN.to_bits();
assert!(host.planned(n,time,0.,&p,&d,&invalid,&rng,&mut |_|Err("disabled terrain")).is_err());assert_eq!(host.state.birth,before);assert_eq!((rng.first,rng.second,rng.words),prior);}
owner.position[0]=(100.+time*10.).to_bits();let (next,random)=host.planned(n,time,0.,&p,&d,&owner,&rng,&mut |_|Err("disabled terrain")).unwrap().unwrap();host=next;rng=random;
let state=host.state.particles.as_ref().unwrap();high=high.max(state.ages.iter().filter(|v|f32::from_bits(**v)<1.).count());assert!(state.positions.iter().flatten().all(|v|f32::from_bits(*v).is_finite()));
assert!(host.planned(n,time,0.,&p,&d,&owner,&rng,&mut |_|Err("disabled terrain")).unwrap().is_none());


}
assert!(host.finished());assert!(high>8);assert!(host.state.emission.counter>20,"births {}",host.state.emission.counter);assert_eq!(host.state.particles.as_ref().unwrap().active,0);assert_eq!(host.state.pose.current[12],owner.position[0]);
println!("Summoner_Mana/starswirl: {} births, {} peak live, finished",host.state.emission.counter,high);groups+=1;
}
{
let fields:std::collections::HashMap<String,Vec<f32>>=[("e-rate".to_owned(),vec![50.0f32]),("p-life".to_owned(),vec![1.3f32]),("p-quadrot".to_owned(),vec![0.0f32]),("p-scale".to_owned(),vec![5.0f32]),("p-rotvel".to_owned(),vec![0.0f32,0.0f32,0.0f32]),("p-xscale".to_owned(),vec![1.0f32,1.0f32,1.0f32]),("p-xscale1".to_owned(),vec![0.0f32,0.0f32,0.0f32,0.0f32]),("p-xscale2".to_owned(),vec![0.0037037f32,0.0f32,0.0f32,0.0f32]),("p-xscale3".to_owned(),vec![0.248f32,2.62453f32,0.0f32,0.0f32]),("p-xscale4".to_owned(),vec![0.511f32,5.45f32,0.0f32,0.0f32]),("p-xscale5".to_owned(),vec![1.0f32,0.0f32,0.0f32,0.0f32]),("p-offset".to_owned(),vec![40.0f32,0.0f32,0.0f32]),("p-vel".to_owned(),vec![0.0f32,300.0f32,-100.0f32]),("p-velYP1".to_owned(),vec![0.0f32,0.25999999046325684f32]),("p-velYP2".to_owned(),vec![1.0f32,1.0f32])].into_iter().collect();
let p=Parameters::read(|key|fields.get(key).cloned()).unwrap();
let mut owner=Owner{system_matrix:identity(),position:[100f32,200.,300.].map(f32::to_bits),inverse_fallback:identity()};
let rotation_probability=ProbabilityCurve{present:true,constant:false,constant_value:1.,fast:true,begin:0.,difference:360.,times:vec![0.,1.],values:vec![0.,360.]};
let rotations=vec![rotations::Source{table:&[1.],axis:[0f32,1.,0.].map(f32::to_bits),probability:Some(&rotation_probability)}];
let d=Definition{flags:0,life:1.0f32,lower:f32::MAX,upper:f32::MAX,delay:0.,emitter_linger:1.0f32,particle_linger:10.,period:f32::MAX,window:f32::MAX,single:0,emitter_local:1,sticky:0,local:0,circular:0,direction:0,scalar_enabled:0,bind:[1f32.to_bits();2],
attributes:[particles::Attribute{mode:1,multiplier:1f32.to_bits(),offset:0},particles::Attribute{mode:3,multiplier:0.2f32.to_bits(),offset:0}],rotations:&rotations,
factors:factors::Sources{context:[0;3],offset_coefficients:[0;3],bounds_coefficients:[0;3],life_multiplier:None,offset_attribute:None,size_attribute:None},force_resource:0,forces:None,terrain:0,quad_rotation_fallback:0,reset_value:0,manager_flag:None,definition_kind:0,rate_factor:1.,position:[0;3],position_probabilities:[None;3]};
let mut host=Host::new(&owner,0.).unwrap();let mut rng=Rng55::seeded(19);let mut high=0;
for n in 1..=151 {let time=(n-1) as f32/30.;if n==2 {
let before=host.state.birth.clone();let prior=(rng.first,rng.second,rng.words);let mut invalid=Owner{system_matrix:owner.system_matrix,position:owner.position,inverse_fallback:owner.inverse_fallback};invalid.position[0]=f32::NAN.to_bits();
assert!(host.planned(n,time,0.,&p,&d,&invalid,&rng,&mut |_|Err("disabled terrain")).is_err());assert_eq!(host.state.birth,before);assert_eq!((rng.first,rng.second,rng.words),prior);}
owner.position[0]=(100.+time*10.).to_bits();let (next,random)=host.planned(n,time,0.,&p,&d,&owner,&rng,&mut |_|Err("disabled terrain")).unwrap().unwrap();host=next;rng=random;
let state=host.state.particles.as_ref().unwrap();high=high.max(state.ages.iter().filter(|v|f32::from_bits(**v)<1.).count());assert!(state.positions.iter().flatten().all(|v|f32::from_bits(*v).is_finite()));
assert!(host.planned(n,time,0.,&p,&d,&owner,&rng,&mut |_|Err("disabled terrain")).unwrap().is_none());

if n==2 {assert!(state.attribute_b.iter().zip(&state.auxiliary).any(|(a,b)|*a==(f32::from_bits(*b)*0.2).to_bits()));}
}
assert!(host.finished());assert!(high>8);assert!(host.state.emission.counter>20,"births {}",host.state.emission.counter);assert_eq!(host.state.particles.as_ref().unwrap().active,0);assert_eq!(host.state.pose.current[12],owner.position[0]);
println!("Summoner_Mana/shafts: {} births, {} peak live, finished",host.state.emission.counter,high);groups+=1;
}
assert_eq!(groups,4);}
