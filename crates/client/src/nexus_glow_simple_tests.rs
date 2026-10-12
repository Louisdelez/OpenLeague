use super::*;
fn profiles()->[Profile;2]{[Profile::load(Side::Order).unwrap(),Profile::load(Side::Chaos).unwrap()]}
pub(crate) fn requests(world:&mut World,age:f64)->Vec<Request>{
    let mut r=crate::nexus_glow_state::tests::requests(world,age);
    for r in &mut r {r.cycle.serial+=100;r.descriptor.resource=r.descriptor.resource.replace(".troy","_on.troy");}
    r
}
fn frame(r:&[Request],ordinal:u64)->Frame{Frame{session:Some(7),ordinal,requests:r.to_vec(),..default()}}
fn equal(a:&Rng55,b:&Rng55)->bool{a.first==b.first&&a.second==b.second&&a.words==b.words}
#[test]
fn exact_simple_profiles_emit_one_auxiliary_draw_per_birth_and_preserve_absent_duration(){
    let p=profiles();assert_eq!(p[0].authored_duration,Some(-1.));assert_eq!(p[1].authored_duration,None);
    assert!(p[0].rate.table.iter().all(|v|*v==4.));assert!(p[1].rate.table.iter().all(|v|*v==3.));
    let mut world=World::new();let r=requests(&mut world,12.);let rng=Rng55::seeded(17);let mut expected=rng.clone();
    let (s,random)=State::default().planned(&frame(&r,1),12.,&p,true,&rng).unwrap().unwrap();
    assert_eq!(s.live_count(),12);
    for slot in &s.slots{
        assert_eq!(slot.storage.auxiliary[0],expected.fraction().to_bits());assert_eq!(slot.birth,[12f32.to_bits()]);
        assert_eq!(slot.storage.scales[0],if slot.side==Side::Order{100f32.to_bits()}else{50f32.to_bits()});
        assert_eq!(slot.identities,[1]);
    }
    assert!(equal(&random,&expected));
}
#[test]
fn native_simple_age_lookup_expiry_reuse_and_long_runtime_stay_bounded(){
    let p=profiles();let mut world=World::new();let mut r=requests(&mut world,0.);
    let mut s=State::default();let mut rng=Rng55::seeded(19);
    for step in 0..=180{
        let now=f64::from(step)/30.;for r in &mut r{r.age_seconds=now;}
        (s,rng)=s.planned(&frame(&r,step as u64+1),now,&p,true,&rng).unwrap().unwrap();
        for slot in &s.slots{
            assert!(slot.birth.len()<=SLOT_CAPACITY);assert_eq!(slot.birth.len(),slot.identities.len());
            for i in slot.live_indices(){assert!(f32::from_bits(slot.storage.ages[i])<1.);
                if step>0 {assert_eq!(slot.storage.attribute_a[i],slot.storage.ages[i]);assert_eq!(slot.storage.attribute_b[i],p[slot.side.index()].color_v.to_bits());}
            }
        }
        if step==30{assert!(!s.slots[0].live_indices().any(|i|s.slots[0].identities[i]==1));}
    }
    assert!(s.slots.iter().all(|s|s.emitted>10));
    for r in &mut r{r.age_seconds=10000.;}
    let (s,_)=s.planned(&frame(&r,182),10000.,&p,true,&rng).unwrap().unwrap();
    assert!(s.slots.iter().all(|s|s.birth.len()<=SLOT_CAPACITY));assert!(s.live_count()<=24);
}
#[test]
fn fog_rebind_and_epoch_preserve_age_without_replaying_births_but_phase_and_session_retire(){
    let p=profiles();let mut world=World::new();let mut r=requests(&mut world,20.);let rng=Rng55::seeded(23);
    let (s,rng)=State::default().planned(&frame(&r,1),20.,&p,true,&rng).unwrap().unwrap();let id=s.slots[0].id(0);
    let (hidden,random)=s.planned(&frame(&[],2),20.1,&p,true,&rng).unwrap().unwrap();assert_eq!(hidden.live_count(),12);assert!(equal(&rng,&random));
    for r in &mut r{r.age_seconds=20.2;r.owner.attachment_generation+=1;r.attachment_world.w_axis.x+=2.;}
    let (s,rng)=hidden.planned(&frame(&r,3),20.2,&p,true,&random).unwrap().unwrap();assert_eq!(s.slots[0].id(0),id);
    assert_eq!(s.slots[0].emitted,1);assert_eq!(s.slots[0].storage.positions[0][0],440f32.to_bits());
    let (hidden,rng)=s.planned(&frame(&[],4),22.,&p,true,&rng).unwrap().unwrap();assert_eq!(hidden.live_count(),0);
    for r in &mut r{r.age_seconds=22.;}
    let (s,_)=hidden.planned(&frame(&r,5),22.,&p,true,&rng).unwrap().unwrap();assert_eq!(s.live_count(),0);assert_eq!(s.slots[0].emitted,1);
    assert!(s.planned(&frame(&r,5),22.1,&p,true,&rng).unwrap().is_none());
    for r in &mut r{r.cycle.serial+=100;r.descriptor.resource=r.descriptor.resource.replace("_on.troy",".troy");}
    let (s,_)=s.planned(&frame(&r,6),22.2,&p,true,&rng).unwrap().unwrap();assert!(s.slots.is_empty());
    let empty=Frame{session:None,ordinal:7,..default()};assert!(s.planned(&empty,22.3,&p,true,&rng).unwrap().unwrap().0.slots.is_empty());
}
#[test]
fn invalid_later_slot_preserves_state_rng_and_rejected_clock_does_not_age_particles(){
    let p=profiles();let mut world=World::new();let mut r=requests(&mut world,5.);let rng=Rng55::seeded(29);
    let (s,random)=State::default().planned(&frame(&r,1),5.,&p,true,&rng).unwrap().unwrap();
    r.last_mut().unwrap().descriptor.node=999;
    assert!(s.planned(&frame(&r,2),6.,&p,true,&random).is_err());assert_eq!(s.slots[0].age,5.);assert_eq!(s.slots[0].emitted,1);
    assert!(s.planned(&frame(&[],2),4.,&p,true,&random).is_err());assert_eq!(random.first,12);
}
