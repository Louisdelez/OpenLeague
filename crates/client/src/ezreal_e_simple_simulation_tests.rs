use super::*;
use crate::ezreal_e_simple_parameters::{Group,Missing};
use openleague_core::{native_scalar_parameter::ScalarParameter,native_vector_parameter::VectorParameter};
fn scalar(value:f32)->ScalarParameter{ScalarParameter::read_numeric("v",value,|key|(key=="v").then_some(vec![value])).unwrap().unwrap()}
fn vector(value:[f32;3])->VectorParameter{VectorParameter::read_nonrotation("v",value,256,|key|(key=="v").then_some(value.to_vec())).unwrap().unwrap()}
fn missing()->Missing{Missing {provenance:"test_explicit_neutral_binding_v1",quad_rotation:Some(scalar(0.)),
    angular_velocity:Some(scalar(0.)),size_over_life_base:1.,size_over_life:Some(scalar(1.)),offset:Some(vector([0.;3])),position_offset:vector([0.;3])}}
fn parameters(group:Group)->Parameters{Parameters::load(group,missing()).unwrap()}
fn matrix(x:f32)->[u32;16]{let mut m=std::array::from_fn(|i|if [0,5,10,15].contains(&i){1f32.to_bits()}else{0});m[12]=x.to_bits();m}
fn pose(previous:f32,current:f32)->Pose{Pose {previous:matrix(previous),current:matrix(current),previous_inverse:matrix(-previous)}}
fn frame<'a>(p:&'a Parameters,ordinal:u64,time:f32,pose:Pose)->Frame<'a>{Frame {ordinal,time,pose,
    emission:Emission {enabled:true,start:0.,life:p.authored_emitter_life,delay:0.,period:10.,window:10.,single:0,
        progress:time/p.authored_emitter_life,rate_factor:1.,attributes:sources::Attributes {life:None,position:None,velocity:None,rotation:None,offset:None},
        factors:factors::Sources {context:[0;3],offset_coefficients:[0;3],bounds_coefficients:[0;3],life_multiplier:None,offset_attribute:None,size_attribute:None},
        rotations:&[],rate_attribute:None},
    dynamics:Dynamics {particle_cap:p.authored_particle_linger,bounds_flag:0,sticky:0,local:0,circular:0,direction:0,
        force_resource:0,force_graph:None,scalar_enabled:0,scalar_over_life:&p.quad_rotation,terrain:0}}}
fn no_height(_: [u32;3])->Result<u32,&'static str>{Err("fixture terrain not selected")}
fn signature(s:&State)->(Vec<u32>,Vec<[u32;3]>,Vec<[u32;3]>,Vec<u32>,Vec<u32>,u64,u32,emission::State){
    (s.birth.clone(),s.storage.positions.clone(),s.storage.velocities.clone(),s.storage.scalar.clone(),s.storage.scales.clone(),s.ordinal,s.clock.to_bits(),s.owner.clone())}
fn random(r:&Rng55)->([u32;55],u32,u32){(r.words,r.first,r.second)}
#[test]
fn authored_e_groups_keep_distinct_rate_lifetime_size_and_color_contracts(){
    let m=parameters(Group::Magicdust);let d=parameters(Group::Dust);
    assert_eq!(m.rate.table,vec![200.]);assert_eq!(d.rate.table,vec![20.]);
    assert_eq!((m.authored_emitter_life,m.authored_emitter_linger,m.authored_particle_linger),(0.6,0.5,4.));
    assert_eq!((d.authored_emitter_life,d.authored_emitter_linger,d.authored_particle_linger),(3.,0.,1.));
    assert_eq!(m.life.probability.values,vec![1.,2.,4.]);assert_eq!(d.life.table,vec![1.]);
    assert_eq!(m.scale.table,vec![3.]);assert_eq!(m.scale.probability.begin,0.5);assert_eq!(m.scale.probability.difference,0.5);
    assert_eq!(d.scale.table[0],25.);assert!(d.scale.table[255]>149.);
    assert_eq!((m.particle_type,m.simple_orientation,d.particle_type,d.simple_orientation),(0,None,1,Some(2)));
    assert_eq!((m.attributes[1].mode,d.attributes[1].mode),(3,0));assert_eq!(d.bind,[0.8,0.6]);
}
#[test]
fn absent_fields_require_resolutions_and_numbered_only_xscale_requires_explicit_base(){
    for case in 0..4 {let mut input=missing();let group=if case<2 {Group::Magicdust}else{Group::Dust};
        match case{0=>input.quad_rotation=None,1=>input.angular_velocity=None,2=>input.size_over_life=None,_=>input.offset=None}
        assert!(Parameters::load(group,input).is_err());}
    let mut input=missing();input.size_over_life_base=2.;
    let doubled=Parameters::load(Group::Magicdust,input).unwrap();assert_eq!(doubled.xscale.table[0],4.);
    assert_eq!(parameters(Group::Magicdust).xscale.table[0],2.);
    let mut input=missing();input.provenance="";assert!(Parameters::load(Group::Dust,input).is_err());
    let mut input=missing();input.size_over_life_base=f32::NAN;assert!(Parameters::load(Group::Magicdust,input).is_err());
}
#[test]
fn dust_quadrot_uses_authored_boolean_base_and_uniform_degrees_without_losing_probability(){
    let p=parameters(Group::Dust);assert_eq!(p.quad_rotation.table,vec![1.]);
    assert!(p.quad_rotation.probability.fast);assert_eq!(p.quad_rotation.probability.begin,0.);
    assert_eq!(p.quad_rotation.probability.difference,360.);
    let initial=State::new(0.,pose(0.,0.)).unwrap();let rng=Rng55::seeded(73);
    let (born,out)=initial.plan(&p,&frame(&p,1,0.,pose(0.,0.)),&rng,&mut no_height).unwrap();
    assert_eq!(born.birth.len(),1);let angle=f32::from_bits(born.storage.scalar[0]);assert!((0. ..360.).contains(&angle));
    assert_ne!(random(&rng),random(&out));assert_eq!(born.storage.rates,vec![0]);
}
#[test]
fn real_magicdust_emits_along_moving_segment_and_preserves_authored_birth_variation(){
    let p=parameters(Group::Magicdust);let initial=State::new(0.,pose(0.,0.)).unwrap();let rng=Rng55::seeded(17);
    let (s,_)=initial.plan(&p,&frame(&p,1,0.05,pose(0.,10.)),&rng,&mut no_height).unwrap();
    assert_eq!(s.birth.len(),10);assert_eq!(s.owner.counter,10);
    assert!(s.storage.life.iter().all(|v|(1. ..=4.).contains(&f32::from_bits(*v))));
    assert!(s.storage.factors.iter().all(|v|(1.5..=3.).contains(&f32::from_bits(*v))));
    for (i,position) in s.storage.positions.iter().enumerate(){let expected=(i+1) as f32;
        assert!((f32::from_bits(position[0])-expected).abs()<=1.001);}
    assert!(s.storage.velocities.iter().all(|v|(-50. ..=-10.).contains(&f32::from_bits(v[2]))));
    assert!(initial.birth.is_empty());
}
#[test]
fn previous_inverse_is_advanced_with_mobile_pose_instead_of_reusing_initial_root(){
    let mut p=parameters(Group::Magicdust);p.offset=vector([0.;3]);p.velocity=vector([0.;3]);
    let rng=Rng55::seeded(17);let initial=State::new(0.,pose(0.,0.)).unwrap();
    let (first,rng)=initial.plan(&p,&frame(&p,1,0.,pose(0.,0.)),&rng,&mut no_height).unwrap();
    let mut f=frame(&p,2,0.1,pose(0.,1.));f.emission.enabled=false;f.dynamics.local=1;
    let (second,rng)=first.plan(&p,&f,&rng,&mut no_height).unwrap();assert_eq!(second.storage.positions[0][0],1f32.to_bits());
    let mut f=frame(&p,3,0.2,pose(1.,2.));f.emission.enabled=false;f.dynamics.local=1;
    let (third,_)=second.plan(&p,&f,&rng,&mut no_height).unwrap();assert_eq!(third.storage.positions[0][0],2f32.to_bits());
}
#[test]
fn same_clock_is_frozen_without_rng_replay_and_changed_pose_or_old_ordinal_is_rejected(){
    let p=parameters(Group::Dust);let rng=Rng55::seeded(29);let initial=State::new(0.,pose(0.,0.)).unwrap();
    let ordinal=(1u64<<53)+9;let (s,rng)=initial.plan(&p,&frame(&p,ordinal,0.,pose(0.,0.)),&rng,&mut no_height).unwrap();
    let (frozen,out)=s.plan(&p,&frame(&p,ordinal+1,0.,pose(0.,0.)),&rng,&mut no_height).unwrap();
    assert_eq!(frozen.birth,s.birth);assert_eq!(frozen.storage.positions,s.storage.positions);assert_eq!(frozen.owner,s.owner);assert_eq!(random(&rng),random(&out));
    assert!(s.plan(&p,&frame(&p,ordinal,0.1,pose(0.,0.)),&rng,&mut no_height).is_err());
    assert!(s.plan(&p,&frame(&p,ordinal+1,0.,pose(0.,1.)),&rng,&mut no_height).is_err());
}
#[test]
fn frame_gap_nonfinite_pose_broken_chain_and_changed_start_preserve_inputs(){
    let p=parameters(Group::Dust);let rng=Rng55::seeded(11);let initial=State::new(0.,pose(0.,0.)).unwrap();
    let (s,rng)=initial.plan(&p,&frame(&p,1,0.,pose(0.,0.)),&rng,&mut no_height).unwrap();let before=signature(&s);let random_before=random(&rng);
    for case in 0..5 {let mut f=frame(&p,2,0.1,pose(0.,0.));match case{0=>f.time=0.251,1=>f.pose.current[6]=f32::NAN.to_bits(),
        2=>f.pose.previous=matrix(3.),3=>f.emission.start=0.01,_=>f.dynamics.particle_cap=0.}
        assert!(s.plan(&p,&f,&rng,&mut no_height).is_err());assert_eq!(before,signature(&s));assert_eq!(random_before,random(&rng));}
}
#[test]
fn emission_budget_is_checked_before_any_terrain_call_or_particle_allocation(){
    let p=parameters(Group::Magicdust);let rng=Rng55::seeded(11);let initial=State::new(0.,pose(0.,0.)).unwrap();
    let mut f=frame(&p,1,0.,pose(0.,0.));f.emission.single=1;f.emission.rate_factor=2.;f.dynamics.terrain=1;
    let mut calls=0;assert!(initial.plan(&p,&f,&rng,&mut |_|{calls+=1;Ok(0)}).is_err());
    assert_eq!(calls,0);assert!(initial.birth.is_empty());
}
#[test]
fn terrain_failure_after_birth_sampling_rolls_back_owner_storage_and_rng(){
    let p=parameters(Group::Dust);let rng=Rng55::seeded(11);let initial=State::new(0.,pose(0.,0.)).unwrap();let before=signature(&initial);let r=random(&rng);
    let mut f=frame(&p,1,0.,pose(0.,0.));f.dynamics.terrain=1;let mut called=false;
    assert!(initial.plan(&p,&f,&rng,&mut |_|{called=true;Err("height missing")}).is_err());assert!(called);
    assert_eq!(signature(&initial),before);assert_eq!(random(&rng),r);
}
#[test]
fn expired_slots_are_reused_and_never_grow_past_the_bounded_population(){
    let mut p=parameters(Group::Dust);p.life=scalar(0.05);let rng=Rng55::seeded(11);let initial=State::new(0.,pose(0.,0.)).unwrap();
    let (mut s,mut rng)=initial.plan(&p,&frame(&p,1,0.,pose(0.,0.)),&rng,&mut no_height).unwrap();
    for i in 1..=30 {let mut f=frame(&p,i+1,i as f32*0.1,pose(0.,0.));f.emission.life=5.;
        (s,rng)=s.plan(&p,&f,&rng,&mut no_height).unwrap();assert!(s.birth.len()<=5);}
    assert!(s.owner.counter>30);assert!(s.live_indices().count()<=3);
}
#[test]
fn explicit_emission_gate_stops_births_without_replacing_authored_particle_linger(){
    let p=parameters(Group::Magicdust);let rng=Rng55::seeded(11);let initial=State::new(0.,pose(0.,0.)).unwrap();
    let (mut s,mut rng)=initial.plan(&p,&frame(&p,1,0.,pose(0.,0.)),&rng,&mut no_height).unwrap();
    let life=s.storage.life[0];for i in 1..=4 {let mut f=frame(&p,i+1,i as f32*0.2,pose(0.,0.));f.emission.enabled=false;
        (s,rng)=s.plan(&p,&f,&rng,&mut no_height).unwrap();}
    assert_eq!(s.owner.counter,1);assert_eq!(s.storage.life[0],life);assert_eq!(s.live_indices().count(),1);
    assert_eq!(p.authored_particle_linger,4.); // Renderer revocation is deliberately a separate owner decision.
}
#[test]
fn descriptor_nonfinite_and_missing_force_graph_fail_without_zero_substitution(){
    let mut p=parameters(Group::Dust);let rng=Rng55::seeded(11);let initial=State::new(0.,pose(0.,0.)).unwrap();
    p.angular_velocity.table[0]=f32::NAN;assert!(initial.plan(&p,&frame(&p,1,0.,pose(0.,0.)),&rng,&mut no_height).is_err());
    let p=parameters(Group::Dust);let mut f=frame(&p,1,0.,pose(0.,0.));f.dynamics.force_resource=1;
    assert!(initial.plan(&p,&f,&rng,&mut no_height).is_err());assert!(initial.birth.is_empty());
}
