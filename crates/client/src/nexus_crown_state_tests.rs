use super::*;
use crate::nexus_idle_particles::{Owner,Descriptor};
pub(super) fn requests(world:&mut World,age:f64)->Vec<Request> {
    let mut out=Vec::new();
    for (source,side) in [(20,"Order"),(21,"Chaos")] {
        let actor=world.spawn_empty().id();
        for slot in 8..=11 {
            let bone=world.spawn_empty().id();
            out.push(Request {owner:Owner {session:7,actor,attachment_generation:1,effect_id:u64::from(source)*100+u64::from(slot)},
                cycle:CycleId {session:7,source,serial:u64::from(source)},descriptor:Descriptor {slot,key:format!("IdleParticles{slot}"),
                    authored:format!("{side}_Nexus_Base_Glow.troy base{}",slot-5),resource:format!("{side}_Nexus_Base_Glow_on.troy"),
                    bone:format!("base{}",slot-5),node:usize::from(slot)+10,skin_index:usize::from(slot)+9},bone,
                attachment_world:Mat4::from_scale_rotation_translation(Vec3::splat(0.05),Quat::IDENTITY,Vec3::new(source as f32,2.,3.)),
                started_at:10.,age_seconds:age,native_idle_resource_flag:0x10});
        }
    }out
}
fn profiles()->[Profile;2] {[Profile::load(Side::Order).unwrap(),Profile::load(Side::Chaos).unwrap()]}
fn frame(requests:&[Request],ordinal:u64)->Frame {Frame {ordinal,session:Some(7),requests:requests.to_vec(),..default()}}
fn same_rng(a:&Rng55,b:&Rng55)->bool {a.words==b.words&&a.first==b.first&&a.second==b.second}
#[test]
fn eight_emitters_keep_five_particles_at_the_strict_native_lifetime_boundary() {
    let mut world=World::new();let mut r=requests(&mut world,0.);let p=profiles();let mut state=State::new(42);
    for (i,time) in [0.,0.5,1.,1.5,2.].into_iter().enumerate() {
        for r in &mut r {r.age_seconds=time;}
        state=state.planned(&frame(&r,i as u64+1),10.+time,&p,true).unwrap().unwrap();
        assert_eq!(state.live_count(),(i+1)*8);
    }
    assert_eq!(state.slots.len(),8);assert!(state.slots.iter().all(|s|s.particles.len()==5));
    let ids:std::collections::HashSet<_>=state.slots.iter().flat_map(|s|s.particles.iter().map(|p|p.id)).collect();assert_eq!(ids.len(),40);
    for r in &mut r {r.age_seconds=2.001;}
    state=state.planned(&frame(&r,6),12.001,&p,true).unwrap().unwrap();assert_eq!(state.live_count(),32);
    assert!(state.slots.iter().all(|s|s.particles.iter().all(|p|p.id.birth!=1)));
}
#[test]
fn latejoin_fog_rebind_and_pause_preserve_birth_identity_without_catchup_or_new_pose() {
    let mut world=World::new();let mut r=requests(&mut world,500.);let p=profiles();let mut s=State::new(42);
    s=s.planned(&frame(&r,1),510.,&p,true).unwrap().unwrap();assert_eq!(s.live_count(),8);
    assert!(s.slots.iter().all(|s|s.particles[0].birth.schedule.time==500.));
    let first=s.slots[0].particles[0].clone();let rng=s.rng.clone();
    s=s.planned(&frame(&[],2),510.4,&p,true).unwrap().unwrap();assert_eq!(s.live_count(),8);assert!(same_rng(&rng,&s.rng));
    for r in &mut r {r.age_seconds=500.7;r.owner.attachment_generation=2;r.attachment_world.w_axis.x+=100.;}
    s=s.planned(&frame(&r,3),510.7,&p,true).unwrap().unwrap();assert_eq!(s.live_count(),16);
    let retained=s.slots[0].particles.iter().find(|p|p.id==first.id).unwrap();
    assert_eq!(retained.birth.schedule.position,first.birth.schedule.position);assert_eq!(retained.orientation,first.orientation);
    assert_ne!(s.slots[0].particles[1].birth.schedule.position,first.birth.schedule.position);
    let rng=s.rng.clone();let ids=s.slots[0].particles.iter().map(|p|p.id).collect::<Vec<_>>();
    s=s.planned(&frame(&r,4),510.7,&p,true).unwrap().unwrap();assert!(same_rng(&rng,&s.rng));
    assert_eq!(s.slots[0].particles.iter().map(|p|p.id).collect::<Vec<_>>(),ids);
    assert!(s.planned(&frame(&r,4),510.7,&p,true).unwrap().is_none());
    s=s.planned(&frame(&[],5),520.,&p,true).unwrap().unwrap();assert_eq!(s.live_count(),0);
}
#[test]
fn cycle_session_and_invalid_later_request_are_transactional_and_bounded() {
    let mut world=World::new();let mut r=requests(&mut world,0.);let p=profiles();
    let s=State::new(1).planned(&frame(&r,1),10.,&p,true).unwrap().unwrap();let rng=s.rng.clone();
    r.last_mut().unwrap().age_seconds=f64::NAN;
    assert!(s.planned(&frame(&r,2),10.5,&p,true).is_err());assert!(same_rng(&rng,&s.rng));assert_eq!(s.live_count(),8);
    r.last_mut().unwrap().age_seconds=0.;
    for r in &mut r {r.cycle.serial+=100;r.owner.effect_id+=1000;}
    let next=s.planned(&frame(&r,3),11.,&p,true).unwrap().unwrap();
    assert_eq!(next.slots.len(),8);assert_eq!(next.live_count(),8);assert!(next.slots.iter().all(|s|s.particles[0].id.cycle>=100));
    let mut empty=frame(&[],4);empty.session=Some(8);
    let next=next.planned(&empty,12.,&p,true).unwrap().unwrap();assert_eq!(next.live_count(),0);assert!(next.slots.is_empty());
    assert!(next.planned(&empty,f64::NAN,&p,true).is_err());
}
#[test]
fn missing_resources_delay_admission_and_a_capacity_error_never_advances_rng() {
    let mut world=World::new();let mut r=requests(&mut world,10.);let p=profiles();let s=State::new(13);let original=s.rng.clone();
    let mut s=s.planned(&frame(&r,1),20.,&p,false).unwrap().unwrap();assert_eq!(s.live_count(),0);assert!(same_rng(&original,&s.rng));
    for r in &mut r {r.age_seconds=11.;}
    s=s.planned(&frame(&r,2),21.,&p,true).unwrap().unwrap();assert_eq!(s.live_count(),8);
    let particle=s.slots[0].particles[0].clone();s.slots[0].particles=vec![particle;5];let rng=s.rng.clone();
    for r in &mut r {r.age_seconds=11.5;}
    assert!(s.planned(&frame(&r,3),21.5,&p,true).is_err());assert!(same_rng(&rng,&s.rng));
    assert_eq!(s.slots[1].emitter.emitted,1);
}

fn startup_profiles()->Vec<Profile> {
    vec![Profile::load(Side::Order).unwrap(),Profile::load(Side::Chaos).unwrap(),
        Profile::load_startup(Side::Order).unwrap(),Profile::load_startup(Side::Chaos).unwrap()]
}
fn startup_requests(world:&mut World,age:f64)->Vec<Request> {
    requests(world,age).into_iter().map(|mut r|{r.descriptor.resource=r.descriptor.resource.replace("_on.troy",".troy");r}).collect()
}
#[test]
fn startup_batches_have_distinct_ids_and_preserve_each_native_birth_time() {
    let mut world=World::new();let mut r=startup_requests(&mut world,0.);let profiles=startup_profiles();
    let mut state=State::new(42).planned(&frame(&r,1),10.,&profiles,true).unwrap().unwrap();
    assert_eq!(state.live_count(),8);
    for r in &mut r {r.age_seconds=0.5;}
    state=state.planned(&frame(&r,2),10.5,&profiles,true).unwrap().unwrap();
    assert_eq!(state.live_count(),20); // Order4*(1+2), Chaos4*(1+1)
    let ids:std::collections::HashSet<_>=state.slots.iter().flat_map(|s|s.particles.iter().map(|p|p.id)).collect();
    assert_eq!(ids.len(),20);
    for slot in &state.slots {
        let values=slot.particles.iter().map(|p|(p.id.birth,p.birth.schedule.time)).collect::<Vec<_>>();
        if slot.side==Side::Order {assert_eq!(values,vec![(1,0.),(2,0.25),(3,0.5)]);}
        else {assert_eq!(values,vec![(1,0.),(2,0.5)]);}
    }
    for (ordinal,time) in [(3,0.75),(4,1.),(5,1.25),(6,1.5),(7,2.)] {
        for r in &mut r {r.age_seconds=time;}
        state=state.planned(&frame(&r,ordinal),10.+time,&profiles,true).unwrap().unwrap();
        for slot in &state.slots {
            assert!(slot.particles.len()<=if slot.side==Side::Order {6}else{5});
            assert!(slot.particles.iter().all(|p|slot.age-p.birth.schedule.time<=p.birth.life));
        }
    }
}
#[test]
fn startup_late_admission_and_fog_discard_missing_pose_credit_but_not_identity() {
    let mut world=World::new();let mut r=startup_requests(&mut world,60.);let profiles=startup_profiles();
    let mut state=State::new(42).planned(&frame(&r,1),70.,&profiles,true).unwrap().unwrap();
    assert_eq!(state.live_count(),8);assert!(state.slots.iter().all(|s|s.particles[0].birth.schedule.time==60.));
    let rng=state.rng.clone();let id=state.slots[0].particles[0].id;
    state=state.planned(&frame(&[],2),70.2,&profiles,true).unwrap().unwrap();
    for r in &mut r {r.age_seconds=60.4;r.owner.attachment_generation+=1;}
    state=state.planned(&frame(&r,3),70.4,&profiles,true).unwrap().unwrap();
    assert!(same_rng(&rng,&state.rng));assert_eq!(state.live_count(),8);
    assert_eq!(state.slots[0].particles[0].id,id);
    for r in &mut r {r.age_seconds=60.9;}
    state=state.planned(&frame(&r,4),70.9,&profiles,true).unwrap().unwrap();
    assert_eq!(state.slots[0].emitter.emitted,3);
    assert!(state.slots[0].particles.iter().filter(|p|p.id.birth>1).all(|p|p.birth.schedule.time>=60.4));
    // Resource unavailability is also a missing-pose admission interval.
    state=state.planned(&frame(&r,5),80.,&profiles,false).unwrap().unwrap();let rng=state.rng.clone();
    for r in &mut r {r.age_seconds=70.5;}
    state=state.planned(&frame(&r,6),80.5,&profiles,true).unwrap().unwrap();
    assert_eq!(state.live_count(),0);assert!(same_rng(&rng,&state.rng));
    for r in &mut r {r.age_seconds=100.;r.cycle.serial+=100;}
    state=state.planned(&frame(&r,7),110.,&profiles,true).unwrap().unwrap();
    assert_eq!(state.live_count(),0);assert!(same_rng(&rng,&state.rng));
}
#[test]
fn startup_capacity_failure_and_phase_replacement_are_separate_transactions() {
    let mut world=World::new();let mut r=startup_requests(&mut world,0.);let profiles=startup_profiles();
    let mut state=State::new(9).planned(&frame(&r,1),10.,&profiles,true).unwrap().unwrap();
    let particle=state.slots[0].particles[0].clone();state.slots[0].particles=vec![particle;6];
    let rng=state.rng.clone();for r in &mut r {r.age_seconds=0.5;}
    assert!(state.planned(&frame(&r,2),10.5,&profiles,true).is_err());assert!(same_rng(&rng,&state.rng));
    assert_eq!(state.slots[0].emitter.emitted,1);
    for r in &mut r {r.cycle.serial+=100;r.age_seconds=0.;r.descriptor.resource=r.descriptor.resource.replace(".troy","_on.troy");}
    let next=state.planned(&frame(&r,3),85.,&profiles,true).unwrap().unwrap();
    assert_eq!(next.live_count(),8);assert!(next.slots.iter().all(|s|s.phase==Phase::On && s.particles[0].id.birth==1));
    assert!(next.slots.iter().all(|s|s.particles[0].id.cycle>=100));
}
