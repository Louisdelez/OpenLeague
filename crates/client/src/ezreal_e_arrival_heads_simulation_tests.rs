use super::*;
use crate::ezreal_e_release_events::{test_fixture,test_event};
use openleague_core::Point;
fn start(phase:Phase)->(Events,Vec<Request>){
    let(mut s,o,mut e)=test_fixture();s.tick+=1;
    test_event(&mut s,o,(1u64<<53)+7,phase,Point{x:100.,z:5000.});
    e.observe_test_frame(&s,1.01,true,false).unwrap();let r=e.take(1.01,true,false);(e,r)
}
#[test]
fn zero_linger_is_exclusive_to_head_group_and_never_a_live_cap(){
    let p=Profile::load().unwrap();let original=&p.parameters[0];assert!(original.validate().is_ok());
    for group in [crate::ezreal_e_simple_parameters::Group::Magicdust,
        crate::ezreal_e_simple_parameters::Group::Dust,crate::ezreal_e_simple_parameters::Group::ReleaseFlash]{
        let mut changed=original.clone();changed.group=group;assert!(changed.validate().is_err());
    }
    for linger in [-0.,-1.,1.,f32::NAN]{let mut changed=original.clone();changed.authored_particle_linger=linger;assert!(changed.validate().is_err());}
    let(e,r)=start(Phase::Arrival);let s=State::default().plan(&e,&r,1.01,false,&p,|_|Ok(75.)).unwrap();
    assert!(s.rows[&r[0].identity].particles.iter().all(|p|p.live_indices().count()==1));
    let entry=&s.rows[&r[0].identity];let scalar=local::scalar(1.);
    let pose=simple::Pose{previous:entry.pose,current:entry.pose,previous_inverse:local::translated_inverse(entry.pose).unwrap()};
    let mut frame=simple::Frame{ordinal:2,time:0.1,pose,emission:simple::Emission{
        enabled:true,start:0.,life:1.5,delay:0.,period:f32::MAX,window:f32::MAX,single:0,progress:0.1/1.5,rate_factor:1.,
        attributes:sources::Attributes{life:None,position:None,velocity:None,rotation:None,offset:None},
        factors:factors::Sources{context:[0;3],offset_coefficients:[0;3],bounds_coefficients:[0;3],
            life_multiplier:None,offset_attribute:None,size_attribute:None},rotations:&[],rate_attribute:None},
        dynamics:simple::Dynamics{particle_cap:0.,bounds_flag:1,sticky:0,local:0,circular:0,direction:0,
            force_resource:0,force_graph:None,scalar_enabled:0,scalar_over_life:&scalar,terrain:0}};
    for cap in [0.,0.2,1.] {frame.dynamics.particle_cap=cap;
        assert_eq!(entry.particles[0].plan(original,&frame,&entry.rng,&mut |_|Err("unexpected terrain")).err(),
            Some("E arrival head requires its explicit local live-cap policy"));}
    frame.dynamics.particle_cap=f32::MAX;
    assert!(entry.particles[0].plan(original,&frame,&entry.rng,&mut |_|Err("unexpected terrain")).is_ok());
}
#[test]
fn arrival_only_shared_head_order_is_transactional_when_second_group_fails(){
    let p=Profile::load().unwrap();let(e,r)=start(Phase::Departure);
    assert!(State::default().plan(&e,&r,1.01,false,&p,|_|panic!("departure must not sample")).unwrap().rows.is_empty());
    let(e,r)=start(Phase::Arrival);let a=State::default().plan(&e,&r,1.01,false,&p,|_|Ok(75.)).unwrap();let id=r[0].identity;
    let b=a.plan(&e,&[],1.135,false,&p,|_|Ok(75.)).unwrap();assert!(b.rows[&id].particles.iter().all(|p|p.live_indices().count()>1));
    assert_ne!(a.rows[&id].rng.words,b.rows[&id].rng.words);
    let before=a.rows[&id].rng.words;let first=a.rows[&id].particles[0].births().to_vec();
    let mut bad=Profile::load().unwrap();bad.parameters[1].rate=local::scalar(f32::MAX);
    assert!(a.plan(&e,&[],1.135,false,&bad,|_|Ok(75.)).is_err());
    assert_eq!(a.rows[&id].rng.words,before);assert_eq!(a.rows[&id].particles[0].births(),first);
    // Binding cannot silently swap head1/head2 pools on a later update.
    let mut swapped=Profile::load().unwrap();swapped.parameters.swap(0,1);
    assert!(a.plan(&e,&[],1.135,false,&swapped,|_|Ok(75.)).is_err());
}
#[test]
fn probability_four_late_births_survive_old_one_point_seven_bound(){
    let mut p=Profile::load().unwrap();
    // Deterministic extreme of the authored P curve, not a changed production
    // profile. It discriminates the prior maximum-before-P lifetime mistake.
    for group in &mut p.parameters {group.life.probability=local::scalar(4.).probability;group.life.probability.constant_value=4.;}
    let(e,r)=start(Phase::Arrival);let id=r[0].identity;
    let mut s=State::default().plan(&e,&r,1.01,false,&p,|_|Ok(75.)).unwrap();
    for age in [0.2,0.4,0.6,0.8,1.,1.2,1.4,1.49]{s=s.plan(&e,&[],1.01+age,false,&p,|_|Ok(75.)).unwrap();}
    let births=s.rows[&id].particles[0].births().to_vec();
    for age in [1.6,1.8,2.0]{s=s.plan(&e,&[],1.01+age,false,&p,|_|Ok(75.)).unwrap();}
    assert_eq!(s.rows[&id].particles[0].births(),births);
    assert!(s.rows[&id].particles.iter().all(|p|p.live_indices().next().is_some()));
    s=s.plan(&e,&[],3.21,false,&p,|_|Ok(75.)).unwrap();
    s=s.plan(&e,&[],1.01+p.end+0.000001,false,&p,|_|Ok(75.)).unwrap();assert!(s.rows.is_empty());
}
#[test]
fn pause_ground_failure_and_revocation_never_replay_or_partially_commit(){
    let p=Profile::load().unwrap();let(mut e,r)=start(Phase::Arrival);
    assert!(State::default().plan(&e,&r,1.01,false,&p,|_|Err("missing ground")).is_err());
    assert!(State::default().plan(&e,&r,1.01,false,&p,|_|Ok(f32::NAN)).is_err());
    let a=State::default().plan(&e,&r,1.01,false,&p,|_|Ok(75.)).unwrap();let id=r[0].identity;
    let b=a.plan(&e,&[],1.01,true,&p,|_|Ok(75.)).unwrap();
    assert_eq!(a.rows[&id].rng.words,b.rows[&id].rng.words);assert_eq!(a.rows[&id].center,b.rows[&id].center);
    assert!(b.plan(&e,&[],1.02,true,&p,|_|Ok(75.)).is_err());
    assert!(b.plan(&e,&[],1.4,false,&p,|_|Ok(75.)).is_err());
    e.suspend();assert!(b.plan(&e,&[],1.01,true,&p,|_|Ok(75.)).is_err());
    let(e,r)=start(Phase::Arrival);assert!(State::default().plan(&e,&r,1.01,true,&p,|_|Ok(75.)).unwrap().rows.is_empty());
}
