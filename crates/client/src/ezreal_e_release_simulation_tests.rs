use super::*;
use crate::ezreal_e_release_events::{test_fixture,test_event};
use openleague_core::{Point,ezreal_e_accepted_releases::Phase};
fn start()->(Events,Vec<Request>){let(mut s,o,mut e)=test_fixture();s.tick+=1;test_event(&mut s,o,1,Phase::Departure,Point{x:100.,z:5000.});e.observe_test_frame(&s,1.01,true,false).unwrap();let r=e.take(1.01,true,false);(e,r)}
#[test]
fn repeated_births_use_rotation_and_shared_rng_then_keep_particle_life_after_emission_stops(){
    let p=Profile::load().unwrap();let(e,r)=start();let a=State::default().plan(&e,&r,1.01,false,&p,|_|Ok(75.)).unwrap();let id=r[0].identity;
    let b=a.plan(&e,&[],1.135,false,&p,|_|Ok(75.)).unwrap();assert!(b.rows[&id].particles.live_indices().count()>1);assert_ne!(a.rows[&id].rng.words,b.rows[&id].rng.words);
    let c=b.plan(&e,&[],1.27,false,&p,|_|Ok(75.)).unwrap();let before=c.rows[&id].particles.births().to_vec();
    let d=c.plan(&e,&[],1.47,false,&p,|_|Ok(75.)).unwrap();assert_eq!(before,d.rows[&id].particles.births());assert!(d.rows[&id].particles.live_indices().next().is_some());
    let f=d.plan(&e,&[],1.67,false,&p,|_|Ok(75.)).unwrap();let end=f.plan(&e,&[],1.76,false,&p,|_|Ok(75.)).unwrap();assert!(end.rows.is_empty());
}
#[test]
fn terrain_gap_and_failed_particle_plan_leave_owned_state_and_rng_uncommitted(){
    let p=Profile::load().unwrap();let(e,r)=start();assert!(State::default().plan(&e,&r,1.01,false,&p,|_|Err("absent")).is_err());
    assert!(State::default().plan(&e,&r,1.01,false,&p,|_|Ok(f32::NAN)).is_err());
    let a=State::default().plan(&e,&r,1.01,false,&p,|_|Ok(75.)).unwrap();let id=r[0].identity;let rng=a.rows[&id].rng.words;
    assert!(a.plan(&e,&[],1.5,false,&p,|_|Ok(75.)).is_err());assert_eq!(a.rows[&id].rng.words,rng);
    let mut bad=Profile::load().unwrap();bad.parameters[0].rate=local::scalar(f32::MAX);
    assert!(a.plan(&e,&[],1.11,false,&bad,|_|Ok(75.)).is_err());assert_eq!(a.rows[&id].rng.words,rng);
    let grid=openleague_core::map10_dense_height::binding().unwrap();let min=grid.grid().spec().min_xz;
    assert!(map10_height(min).is_ok());assert!(map10_height([min[0]-1.,min[1]]).is_err());
}
#[test]
fn pause_retains_current_pose_without_rng_and_revocation_removes_it(){
    let p=Profile::load().unwrap();let(mut e,r)=start();let a=State::default().plan(&e,&r,1.01,false,&p,|_|Ok(75.)).unwrap();let id=r[0].identity;
    let b=a.plan(&e,&[],1.01,true,&p,|_|Ok(75.)).unwrap();assert_eq!(a.rows[&id].rng.words,b.rows[&id].rng.words);assert_eq!(a.rows[&id].center,b.rows[&id].center);
    assert!(b.plan(&e,&[],1.02,true,&p,|_|Ok(75.)).is_err());e.suspend();assert!(b.plan(&e,&[],1.01,true,&p,|_|Ok(75.)).is_err());
}
