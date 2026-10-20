use super::*;
use openleague_core::{native_complex_particle_storage::GlobalVectors,native_complex_vectors::Field};
fn identity()->[f32;16]{std::array::from_fn(|i|if [0,5,10,15].contains(&i){1.}else{0.})}
fn parameters()->Parameters{Parameters::load("explicit_test_binding",2.).unwrap()}
fn random()->Rng55{Rng55::seeded(420)}
fn rng_words(r:&Rng55)->(u32,u32,[u32;55]){(r.first,r.second,r.words)}
fn bytes(s:&State)->Vec<Vec<u32>>{s.particles().iter().map(|r|[4,0x10,0x1c,0x28,0x34,0x40,0x4c,0x58,0x64,0x70,0x7c,0x88]
    .into_iter().flat_map(|at|r.native_words(at).unwrap()).collect()).collect()}
fn frame(s:&State,time:f32,position:[f32;3])->Frame{
    let previous=s.host.previous_position;
    Frame {provenance:"explicit_test_binding",ordinal:s.ordinal()+1,time,previous_position:previous,current_position:position,
        instance:Instance {duration:2.,rate_owner_scale:1.,life_owner_scale:1.,life_coefficients:[0.;3],life_symmetry:0,limit:0,
            single_flag:0,stopped_flag:0,past_end:false,globals:GlobalVectors {unit:[0;3],scale:[1f32.to_bits();3],anchor:[0;3]},motion_scratch:[0;3]},
        birth:BirthSource {orientation:identity(),primary:identity(),world_acceleration:[0.;3],orbit_secondary:[0.;3],uv_aux:[0.;2],rate_multiplier:1.,distance_anchor:0.},
        dynamics:Dynamics {owner_delta:std::array::from_fn(|a|position[a]-previous[a]),owner_extra:[0.;3],default_vector:[0.;3],scale_owner:1.,
            lookup_modes:[1,0],lookup_scale:[1.;2],lookup_offset:[0.;2],surface_direct:false,local_matrix:None,attach_matrix:None}}
}
fn born()->(Parameters,State,Rng55){
    let p=parameters();let (s,r)=State::new(&p,0.,[100.,200.,300.],&random()).unwrap();
    let (s,r)=s.plan(&p,frame(&s,0.,[100.,200.,300.]),&r).unwrap();(p,s,r)
}
#[test]
fn raw_source_probability_curves_and_absent_global_life_are_distinct(){
    let p=parameters();assert!(p.fields.get("e-life").is_none());assert_eq!(p.timing.life,2.);
    assert!(Parameters::load("",2.).is_err());assert!(Parameters::load("explicit",f32::NAN).is_err());
    assert!(Parameters::load("explicit",0.).is_err());
    let second=Parameters::load("other_configuration",3.).unwrap();assert_eq!(second.timing.life,3.);assert_eq!(p.fields,second.fields);
    let x=p.vectors.field(Field::Scale);assert_eq!(x.table[0],[60.;3]);
    assert!(x.probabilities[0].is_some());assert!(x.probabilities[1].is_some());
    assert!(!p.vectors.field(Field::Acceleration).authored); // native null reader, not an authored zero
}
#[test]
fn retention_and_birth_consume_one_shared_rng_in_native_field_order(){
    let p=parameters();let initial=random();let (s,r)=State::new(&p,0.,[0.;3],&initial).unwrap();
    let mut retention=initial.clone();retention.fraction();assert_eq!(rng_words(&r),rng_words(&retention));assert_eq!(s.retained.len(),1);
    let mut sampled_rng=r.clone();let b=engine::sample_birth(&p,&s.retained,engine::BirthInputs {time:0.,previous:f32::MIN,
        count:1,index:0,previous_position:[0.;3],current_position:[0.;3],owner_start:0.,instance_duration:2.,life_owner_scale:1.,life_coefficients:[0.;3],life_symmetry:0},&mut sampled_rng).unwrap();
    let mut expected=r.clone();let life_fraction=expected.fraction();
    assert_eq!(b.life.to_bits(),(0.3f32*(0.5f32*life_fraction+0.5)).to_bits());
    // Life, scaleX/Y, quadrotX, offsetX/Y, shared, retained rotation.
    let mut shared=0.;for n in 2..=8{let v=expected.fraction();if n==7{shared=v;}}
    assert_eq!(b.shared_uv.to_bits(),shared.to_bits());assert_eq!(rng_words(&sampled_rng),rng_words(&expected));
    assert_eq!(rng_words(&initial),rng_words(&random()));
}
#[test]
fn retained_rotation_changes_offset_without_a_second_shared_uv_draw(){
    let p=parameters();let (s,r)=State::new(&p,0.,[0.;3],&random()).unwrap();
    let input=engine::BirthInputs {time:0.1,previous:0.,count:1,index:0,previous_position:[0.;3],current_position:[0.;3],owner_start:0.,
        instance_duration:2.,life_owner_scale:1.,life_coefficients:[0.;3],life_symmetry:0};
    let mut a=r.clone();let mut b=r.clone();let rotated=engine::sample_birth(&p,&s.retained,input,&mut a).unwrap();
    let raw=engine::sample_birth(&p,&[],input,&mut b).unwrap();
    assert_ne!(rotated.vectors[Field::Offset as usize],raw.vectors[Field::Offset as usize]);
    assert_eq!(rotated.shared_uv.to_bits(),raw.shared_uv.to_bits());b.fraction();assert_eq!(rng_words(&a),rng_words(&b));
}
#[test]
fn batch_emitter_age_is_separate_from_distributed_particle_birth_age(){
    let p=parameters();let (s,r)=State::new(&p,0.,[0.;3],&random()).unwrap();
    let input=engine::BirthInputs {time:0.2,previous:0.,count:4,index:0,previous_position:[0.;3],current_position:[40.,0.,0.],owner_start:0.,
        instance_duration:2.,life_owner_scale:1.,life_coefficients:[0.;3],life_symmetry:0};
    let mut a=r.clone();let mut b=r.clone();let early=engine::sample_birth(&p,&s.retained,input,&mut a).unwrap();
    let late=engine::sample_birth(&p,&s.retained,engine::BirthInputs {index:3,..input},&mut b).unwrap();
    assert_eq!(early.schedule.time,0.05);assert_eq!(late.schedule.time,0.2);assert_eq!(early.schedule.position,[10.,0.,0.]);
    assert_eq!(early.emitter_age.to_bits(),late.emitter_age.to_bits());assert_eq!(early.vectors,late.vectors);
    assert_eq!(early.life.to_bits(),late.life.to_bits());assert_eq!(rng_words(&a),rng_words(&b));
}
#[test]
fn moving_births_use_distributed_positions_and_newborns_have_zero_integration(){
    let (p,s,r)=born();assert_eq!(s.particles().len(),1);assert_eq!(s.particles()[0].life[0],0f32.to_bits());
    assert_eq!(s.particles()[0].surface[12..15],[100.,200.,300.].map(f32::to_bits));
    let (n,_)=s.plan(&p,frame(&s,0.1,[200.,200.,300.]),&r).unwrap();
    assert_eq!(n.particles().len(),17);let fresh=&n.particles()[1..];
    assert_eq!(fresh.first().unwrap().surface[12],106.25f32.to_bits());
    assert_eq!(fresh.last().unwrap().surface[12],200f32.to_bits());
    assert!(fresh.iter().all(|x|x.motion[16..19]==[0;3]));
    assert_ne!(n.particles()[0].surface[28..31],s.particles()[0].surface[28..31]);
    assert!(n.particles()[0].surface[32..35].iter().any(|x|f32::from_bits(*x)!=0.));
}
#[test]
fn frozen_clock_advances_full_width_ordinal_only_and_rejects_motion(){
    let (p,s,r)=born();let mut f=frame(&s,0.,s.host.previous_position);f.ordinal=(1u64<<53)+19;
    let (n,q)=s.plan(&p,f,&r).unwrap();assert_eq!(n.ordinal(),f.ordinal);assert_eq!(bytes(&s),bytes(&n));assert_eq!(rng_words(&q),rng_words(&r));
    assert!(n.plan(&p,f,&q).is_err());
    let moving=frame(&n,0.,[101.,200.,300.]);assert!(n.plan(&p,moving,&q).is_err());
}
#[test]
fn atlas_advances_with_particle_age_wraps_and_reuses_shared_fraction(){
    assert_eq!(engine::atlas_frame(0.5,0.,9.).unwrap(),4.5);
    assert_eq!(engine::atlas_frame(0.5,0.5,9.).unwrap(),0.);
    assert_eq!(engine::atlas_frame(0.5,1.,9.).unwrap(),4.5);
    assert_eq!(engine::atlas_frame(1.,0.,9.).unwrap(),0.);
    for a in [-1.,f32::NAN,f32::INFINITY]{assert!(engine::atlas_frame(0.5,a,9.).is_err());}
    let (p,s,r)=born();let mut f=frame(&s,0.1,s.host.previous_position);f.instance.stopped_flag=1;
    let (n,_)=s.plan(&p,f,&r).unwrap();assert_eq!(n.particles().len(),1);
    let particle=&n.particles()[0];let expected=engine::atlas_frame(f32::from_bits(particle.field_58[0]),0.1,9.).unwrap();
    assert_eq!(particle.atlas[1],expected.to_bits());assert_ne!(particle.atlas[1],s.particles()[0].atlas[1]);
}
#[test]
fn malformed_frame_or_changed_configuration_preserves_state_and_rng(){
    let (p,s,r)=born();let old=bytes(&s);let random=rng_words(&r);let good=frame(&s,0.1,s.host.previous_position);
    let mut bad=good;bad.time=0.251;assert!(s.plan(&p,bad,&r).is_err());
    bad=good;bad.previous_position[0]+=1.;assert!(s.plan(&p,bad,&r).is_err());
    bad=good;bad.dynamics.owner_delta[0]=1.;assert!(s.plan(&p,bad,&r).is_err());
    bad=good;bad.birth.primary[15]=0.;assert!(s.plan(&p,bad,&r).is_err());
    bad=good;bad.instance.globals.anchor[0]=f32::NAN.to_bits();assert!(s.plan(&p,bad,&r).is_err());
    bad=good;bad.dynamics.lookup_modes[0]=2;assert!(s.plan(&p,bad,&r).is_err());
    assert!(s.plan(&Parameters::load("changed",2.).unwrap(),good,&r).is_err());
    assert_eq!(bytes(&s),old);assert_eq!(rng_words(&r),random);
}
#[test]
fn overflowing_batch_and_late_arithmetic_failure_are_transactional(){
    let p=parameters();let (s,r)=State::new(&p,0.,[0.;3],&random()).unwrap();let old=bytes(&s);let random=rng_words(&r);
    let mut f=frame(&s,0.,[0.;3]);f.instance.single_flag=1;f.instance.rate_owner_scale=2.;
    assert!(s.plan(&p,f,&r).is_err()); // 320 requested before append, bounded256
    f=frame(&s,0.,[0.;3]);f.birth.rate_multiplier=f32::MAX;
    assert!(s.plan(&p,f,&r).is_err()); // packet frequency overflow after sampling
    assert_eq!(bytes(&s),old);assert_eq!(rng_words(&r),random);
}
#[test]
fn emission_stop_allows_existing_lifetime_and_exact_endpoint_expiry(){
    let (p,s,r)=born();let life=f32::from_bits(s.particles()[0].life[1]);assert!((0.15..=0.3).contains(&life));
    let mut current=s;let mut random=r;
    if life>MAX_STEP{let mut f=frame(&current,MAX_STEP,current.host.previous_position);f.instance.stopped_flag=1;
        (current,random)=current.plan(&p,f,&random).unwrap();}
    let mut end=frame(&current,life,current.host.previous_position);end.instance.stopped_flag=1;
    let (at_end,random)=current.plan(&p,end,&random).unwrap();assert_eq!(at_end.particles().len(),1);
    let mut after=frame(&at_end,f32::from_bits(life.to_bits()+1),at_end.host.previous_position);after.instance.stopped_flag=1;
    let (expired,_)=at_end.plan(&p,after,&random).unwrap();assert!(expired.particles().is_empty());
}
#[test]
fn owner_binding_moves_only_the_permitted_fraction_and_preserves_birth_pose(){
    let (p,s,r)=born();let mut still=frame(&s,0.1,s.host.previous_position);still.instance.stopped_flag=1;
    let mut moved=frame(&s,0.1,[200.,200.,300.]);moved.instance.stopped_flag=1;
    let (a,ra)=s.plan(&p,still,&r).unwrap();let (b,rb)=s.plan(&p,moved,&r).unwrap();
    assert_eq!(rng_words(&ra),rng_words(&rb));assert_eq!(a.particles()[0].surface[..16],b.particles()[0].surface[..16]);
    let difference=f32::from_bits(b.particles()[0].surface[28])-f32::from_bits(a.particles()[0].surface[28]);
    assert!((difference-25.).abs()<0.001);
}
