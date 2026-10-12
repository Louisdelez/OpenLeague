use super::*;
use crate::nexus_idle_particles::{Owner,Descriptor};
pub(crate) fn requests(world:&mut World,age:f64)->Vec<Request> {
    let mut out=Vec::new();
    for (source,side) in [(20,"Order"),(21,"Chaos")] {
        let actor=world.spawn_empty().id();
        for slot in 2..=7 {let bone=world.spawn_empty().id();let node=[8,3,4,5,6,7][usize::from(slot-2)];
            out.push(Request {owner:Owner {session:7,actor,attachment_generation:1,effect_id:u64::from(source)*100+u64::from(slot)},
                cycle:CycleId {session:7,source,serial:u64::from(source)},descriptor:Descriptor {slot,key:format!("IdleParticles{slot}"),
                    authored:format!("{side}_Nexus_Crystal_Glow.troy gnome{}",slot-1),resource:format!("{side}_Nexus_Crystal_Glow.troy"),
                    bone:format!("gnome{}",slot-1),node,skin_index:node-1},bone,
                attachment_world:Mat4::from_scale_rotation_translation(Vec3::splat(0.05),Quat::IDENTITY,Vec3::new(source as f32,2.,3.)),
                started_at:0.,age_seconds:age,native_idle_resource_flag:0x10});
        }
    }out
}
fn profiles()->[Profile;2] {[Profile::load(Side::Order).unwrap(),Profile::load(Side::Chaos).unwrap()]}
fn frame(requests:&[Request],ordinal:u64)->Frame {Frame {ordinal,session:Some(7),requests:requests.to_vec(),..default()}}
fn rng_equal(a:&Rng55,b:&Rng55)->bool {a.first==b.first&&a.second==b.second&&a.words==b.words}
#[test]
fn exact_profiles_preserve_native_curves_and_one_unconditional_birth_draw() {
    let p=profiles();assert_eq!((p[0].rate,p[1].rate),(2.5,3.));
    assert_ne!(p[0].birth_color.table,p[1].birth_color.table);
    for profile in &p {let mut rng=Rng55::seeded(42);let mut expected=rng.clone();let fraction=expected.fraction();
        let born=profile.birth(60.,f32::MIN,&mut rng).unwrap();assert!(rng_equal(&rng,&expected));
        assert_eq!(born.shared_uv.to_bits(),fraction.to_bits());assert_eq!(born.time,60.);assert_eq!(born.life,1.);
        assert_eq!(born.uv.origin,[[0.;2];2]);assert_eq!(born.uv.rate,[[0.;2];2]);
        let (start,_)=profile.lifetime_color.update_lifetime_color(born.color,60.,60.,1.,&mut rng).unwrap();
        let (middle,_)=profile.lifetime_color.update_lifetime_color(born.color,60.5,60.,1.,&mut rng).unwrap();
        let (end,_)=profile.lifetime_color.update_lifetime_color(born.color,61.,60.,1.,&mut rng).unwrap();
        assert_eq!(start[3],0.);assert!(middle[3]>start[3]);
        // Native tables sample i/256, so the last retained frame at age1 uses
        // 255/256 rather than the authored endpoint1. Removal is strictly >1.
        assert_eq!(end[3],born.color[3]*(1./128.));assert!(end[3]>0.&&end[3]<middle[3]);
        assert!(rng_equal(&rng,&expected));
    }
}
#[test]
fn twelve_emitters_use_actual_rates_strict_lifetime_and_duration_without_catchup() {
    let mut world=World::new();let mut r=requests(&mut world,0.);let p=profiles();let mut state=State::new(42);
    for (i,time) in [0.,0.34,0.41,0.68,0.82,1.02,1.03,1.2].into_iter().enumerate() {
        for r in &mut r {r.age_seconds=time;}
        state=state.planned(&frame(&r,i as u64+1),time,&p,true).unwrap().unwrap();
        assert!(state.live_count()<=48);assert_eq!(state.slots.len(),12);
        assert!(state.slots.iter().all(|s|s.particles.len()<=4));
    }
    assert!(state.slots.iter().filter(|s|s.side==Side::Chaos).all(|s|s.emitted>state.slots[0].emitted));
    for r in &mut r {r.age_seconds=100.;}
    state=state.planned(&frame(&r,20),100.,&p,true).unwrap().unwrap();assert_eq!(state.live_count(),0);
    let before=state.rng.clone();for r in &mut r {r.age_seconds=500.;}
    state=state.planned(&frame(&r,21),500.,&p,true).unwrap().unwrap();assert_eq!(state.live_count(),0);assert!(rng_equal(&before,&state.rng));
    let mut late=requests(&mut world,101.);for r in &mut late{r.cycle.session=8;r.owner.session=8;}
    let mut f=frame(&late,1);f.session=Some(8);
    assert_eq!(state.planned(&f,501.,&p,true).unwrap().unwrap().live_count(),0);
}
#[test]
fn rebind_fog_pause_on_phase_and_session_preserve_or_retire_exact_identities() {
    let mut world=World::new();let mut r=requests(&mut world,60.);let p=profiles();let mut s=State::new(42);
    s=s.planned(&frame(&r,1),60.,&p,true).unwrap().unwrap();let ids:Vec<_>=s.slots.iter().flat_map(|s|s.particles.iter().map(|p|p.id)).collect();
    let rng=s.rng.clone();s=s.planned(&frame(&[],2),60.1,&p,true).unwrap().unwrap();assert_eq!(s.live_count(),12);assert!(rng_equal(&s.rng,&rng));
    for r in &mut r {r.age_seconds=60.2;r.owner.attachment_generation+=1;r.attachment_world.w_axis.x+=100.;}
    s=s.planned(&frame(&r,3),60.2,&p,true).unwrap().unwrap();
    assert_eq!(ids,s.slots.iter().flat_map(|s|s.particles.iter().map(|p|p.id)).collect::<Vec<_>>());assert!(rng_equal(&s.rng,&rng));
    assert!(s.planned(&frame(&r,3),60.2,&p,true).unwrap().is_none());
    s=s.planned(&frame(&r,4),60.2,&p,true).unwrap().unwrap();assert!(rng_equal(&s.rng,&rng));
    for r in &mut r {r.cycle.serial+=1;r.age_seconds=0.;r.descriptor.resource=r.descriptor.resource.replace(".troy","_on.troy");}
    s=s.planned(&frame(&r,5),75.,&p,true).unwrap().unwrap();assert!(s.slots.is_empty());assert!(rng_equal(&s.rng,&rng));
    s=s.planned(&Frame {ordinal:1,session:Some(8),..default()},76.,&p,true).unwrap().unwrap();assert!(s.slots.is_empty());
}
#[test]
fn missing_images_and_later_bad_request_cannot_commit_rng_or_partial_batch() {
    let mut world=World::new();let mut r=requests(&mut world,58.);let p=profiles();let s=State::new(3);let initial=s.rng.clone();
    let s=s.planned(&frame(&r,1),58.,&p,false).unwrap().unwrap();assert_eq!(s.live_count(),0);assert!(rng_equal(&s.rng,&initial));
    for r in &mut r {r.age_seconds=60.;}
    let s=s.planned(&frame(&r,2),60.,&p,true).unwrap().unwrap();assert_eq!(s.live_count(),12);
    assert!(s.slots.iter().all(|s|s.particles[0].birth.time==60.));
    let before=s.rng.clone();r.last_mut().unwrap().descriptor.bone="invalid".into();
    assert!(s.planned(&frame(&r,3),60.5,&p,true).is_err());assert!(rng_equal(&before,&s.rng));assert_eq!(s.live_count(),12);
}
