use super::*;
use crate::{relic_pickup_events,relic_pickup_seven_live,relic_pickup_seven_identity,relic_pickup_simulation};
fn fingerprint(host:&relic_pickup_simulation::Host)->Vec<u32>{
 let Some(state)=&host.state.particles else{return vec![]};
 state.life.iter().chain(&state.ages).chain(&state.scales).chain(&state.scalar)
  .chain(state.positions.iter().flatten()).chain(state.velocities.iter().flatten()).copied().collect()
}
#[test]
fn native_seed_owned_global_order_stale_plan_retirement_and_all_class_completion(){
 use relic_pickup_seven_identity::GROUPS;
 let mut world=World::new();let root=world.spawn_empty().id();
 let owner=relic_pickup_events::OwnerFrame {binding:relic_pickup_events::Binding {root,model:Handle::<Gltf>::default().id()},
  native_position:[10f32.to_bits(),20f32.to_bits(),30f32.to_bits()],
  native_matrix:[0.,0.,-1.,0.,0.,1.,0.,0.,1.,0.,0.,0.,901.,902.,903.,1.].map(f32::to_bits)};
 let key=relic_pickup_events::Key {session:7,pickup_tick:100,picker:3};
 let mut requests=crate::relic_pickup_events::owned_order_fixture(key,owner);
 let mut previous_requests=crate::relic_pickup_events::owned_order_fixture(key,owner);
 let filetime=116_444_736_000_000_000u64+1_234_567*10_000;
 let (mut current,_)=configured(filetime,"controlled numeric lifecycle fixture; no GPU or historical trigger parity".into()).unwrap();
 let mut previous=crate::relic_pickup_live::initialized_order_fixture(openleague_core::native_random::Rng55::from_filetime(filetime));
 let mut changed_simple=false;
 for frame in 0..30 {
  let now=f64::from((frame as f32)/60.);
  let a=current.planned(&requests,now).unwrap();let b=previous.planned(&previous_requests,now).unwrap();
  assert_eq!(a.groups().map(|g|g.group).collect::<Vec<_>>(),GROUPS);
  let old=b.groups().map(|g|fingerprint(g.host)).collect::<Vec<_>>();
  let new=a.groups().filter_map(|g|match g.state {relic_pickup_seven_live::GroupState::Simple {host,..}=>Some(fingerprint(host)),_=>None}).collect::<Vec<_>>();
  changed_simple|=old!=new;
  current.commit(a,&mut requests).unwrap();previous.commit(b,&mut previous_requests).unwrap();
 }
 assert!(changed_simple,"Shared authored seven-group RNG order must change at least one former Simple particle stream");
 assert_ne!((current.host.rng.first,current.host.rng.second,current.host.rng.words),(previous.rng.first,previous.rng.second,previous.rng.words));
 // A stale accepted snapshot blocks the whole owned plan, including mutable
 // source context and every RNG word; no partial seven-group commit can occur.
 let pending=current.planned(&requests,0.5).unwrap();let before=(current.host.ordinal,current.host.rng.first,current.host.rng.second,current.host.rng.words);
 requests.requests.get_mut(&key).unwrap().observed_snapshot_tick+=1;
 assert!(current.commit(pending,&mut requests).is_err());assert_eq!((current.host.ordinal,current.host.rng.first,current.host.rng.second,current.host.rng.words),before);
 requests.requests.get_mut(&key).unwrap().observed_snapshot_tick-=1;
 // Loss of the accepted owner retires all seven groups as one effect, retaining
 // the shared stream state when no remaining effects request a native frame.
 requests.requests.get_mut(&key).unwrap().owner=None;
 let retired=current.planned(&requests,0.5).unwrap();assert!(retired.groups().next().is_none());
 assert_eq!(retired.next.retired.len(),1);current.commit(retired,&mut requests).unwrap();
 assert!(current.host.effects().is_empty());assert_eq!((current.host.rng.first,current.host.rng.second,current.host.rng.words),(before.1,before.2,before.3));
 // A second fresh effect must complete only when both Simple and Complex
 // instances have finished; the accepted request is completed exactly once.
 let mut completed_requests=crate::relic_pickup_events::owned_order_fixture(key,owner);
 let (mut completed,_)=configured(filetime,"controlled numeric lifecycle fixture; no GPU or historical trigger parity".into()).unwrap();
 let mut finished_at=None;
 for frame in 0..900 {
  let time=f64::from((frame as f32)/60.);let plan=completed.planned(&completed_requests,time).unwrap();
  completed.commit(plan,&mut completed_requests).unwrap();
  if completed_requests.requests.is_empty(){finished_at=Some(time);break;}
 }
 assert!(finished_at.is_some());assert!(completed.host.effects().is_empty());
 assert_eq!(completed_requests.retired.iter().filter(|r|r.key==key&&r.reason=="completed").count(),1);
 let clock:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/random_seed_clock_contract.json")).unwrap();
 let seed_cases=clock["startup_cases"].as_array().unwrap().len();
 for row in clock["startup_cases"].as_array().unwrap(){
  let(live,_)=configured(row["filetime"].as_u64().unwrap(),"controlled exact native startup seed witness".into()).unwrap();
  assert_eq!((live.host.rng.first,live.host.rng.second),(0,31));
  assert_eq!(live.host.rng.words,std::array::from_fn::<_,55,_>(|i|row["rng"]["words"][i].as_u64().unwrap() as u32));
  assert!(live.host.effects().is_empty());assert_eq!(live.host.ordinal,0);
 }
 println!("{}",serde_json::json!({"passed":true,"native_startup_seed_cases":seed_cases,"changed_previous_simple_stream":changed_simple,"stale_snapshot_atomic_rejection":true,"owner_retirement_all_seven":true,"all_class_completion_at":finished_at,"normal_activation_admitted":false,"original_trigger_parity":false}));
}
