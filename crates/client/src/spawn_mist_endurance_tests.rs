use crate::{spawn_mist_sources,spawn_mist_host,spawn_mist_surface,relic_pickup_complex_simulation,relic_pickup_complex_sources};
use openleague_core::{native_random::Rng55,native_complex_particle_storage::GlobalVectors};
use crate::relic_pickup_seven_host::Owner;
use serde_json::Value;
fn word(v:&Value)->u32{v.as_u64().unwrap()as u32}
fn words<const N:usize>(v:&Value)->[u32;N]{std::array::from_fn(|i|word(&v[i]))}
fn vec<const N:usize>(v:&Value)->[f32;N]{std::array::from_fn(|i|v[i].as_f64().unwrap()as f32)}
fn owner(v:&Value)->Owner{Owner{root_token:10,model_token:20,matrix:vec::<16>(&v["matrix"]).map(f32::to_bits),position:vec::<3>(&v["position"]).map(f32::to_bits)}}
fn rng(v:&Value)->(u32,u32,[u32;55]){(word(&v["first"]),word(&v["second"]),words(&v["words"]))}
fn actual(r:&Rng55)->(u32,u32,[u32;55]){(r.first,r.second,r.words)}
#[cfg_attr(test,test)]
pub fn original168_long_pause_mist_frames_match_native_cap_rng_expiry_and_surface_without_reset(){
 let oracle:Value=serde_json::from_str(include_str!("../../../data/4.20/spawn_mist/probe_longjump.json")).unwrap();assert_eq!(oracle["passed"],true);let mut failures=vec![];let mut frames=0;let mut records=0;
 for seq in oracle["sequences"].as_array().unwrap(){
  let effect=match seq["effect"].as_str().unwrap(){"Order_Spawn"=>spawn_mist_sources::Effect::Order,"Chaos_Spawn"=>spawn_mist_sources::Effect::Chaos,_=>panic!("source effect")};
  let factory:Value=serde_json::from_str(if effect==spawn_mist_sources::Effect::Order{include_str!("../../../data/4.20/spawn_mist/Order_Spawn_numeric_factory_v5.json")}else{include_str!("../../../data/4.20/spawn_mist/Chaos_Spawn_numeric_factory_v5.json")}).unwrap();
  let definition:Value=serde_json::from_str(if effect==spawn_mist_sources::Effect::Order{include_str!("../../../data/4.20/map10_particles/definitions/Order_Spawn.json")}else{include_str!("../../../data/4.20/map10_particles/definitions/Chaos_Spawn.json")}).unwrap();
  let source=spawn_mist_sources::Profile::from_documents(effect,&definition,&factory,seq["provider_capability"].as_bool().unwrap()).unwrap();
  let native=spawn_mist_host::HostSource::new(source,&factory,relic_pickup_complex_sources::LocalPolicy{life_owner_scale:1.,actor_rate_scale:1.,scale_owner:1.,owner_flags:0,owner_extra:[0.;3],motion_scratch:[0;3],globals:GlobalVectors{unit:[0;3],scale:[1f32.to_bits();3],anchor:[0;3]}}).unwrap();
  let initial=owner(&seq["initial_owner"]);let mut random=Rng55::seeded(42);let mut created=native.create(initial,0.,&mut random).unwrap();assert_eq!(actual(&random),rng(&seq["initial_rng"]));let mut host=relic_pickup_complex_simulation::Host::new(0.,initial.position.map(f32::from_bits));
  let mut independent_rng=Rng55::seeded(42);let mut wrapped=spawn_mist_host::EffectState::new(&native,initial,0.,&mut independent_rng).unwrap();assert_eq!(actual(&independent_rng),actual(&random));
  for row in seq["frames"].as_array().unwrap(){
   let previous=owner(&row["previous_owner"]);let current=owner(&row["current_owner"]);let ordinal=u64::from(word(&row["ordinal"]));let time=f32::from_bits(word(&row["time_word"]));
   if actual(&random)!=rng(&row["rng_before"]){failures.push(serde_json::json!({"effect":seq["effect"],"tag":seq["tag"],"frame":ordinal,"rng_before":true}));}
   assert_eq!(wrapped.owner,previous);let before=random.clone();
   let frame=native.frame(&mut created.context,created.instance,previous,current,time).unwrap();created.instance=frame.instance;
   let mut packets=Vec::new();
   let plan=host.planned_frame(ordinal,&native.profile,time,current.position.map(f32::from_bits),frame.instance,frame.particles,&random,|birth,id,rng|{
    let prepared=native.birth(&mut created.context,created.instance,current,birth,id,rng)?;
    packets.push(relic_pickup_complex_simulation::packet(&native.profile,birth,prepared)?.0);
    Ok(prepared)
   }).unwrap().unwrap();host=plan.0;random=plan.1;
   if ordinal==2 {assert_eq!(packets.len(),1,"actual native rate1 count cap after long pause");}
   if ordinal==3 {assert!(packets.is_empty(),"same time emits no second batch");}
   let expected_packets=row["birth_packets"].as_array().unwrap().iter().map(words::<69>).collect::<Vec<_>>();
   if packets!=expected_packets{failures.push(serde_json::json!({"effect":seq["effect"],"tag":seq["tag"],"frame":ordinal,"birth_packets":true}));}
   let wrapper_plan=wrapped.planned_frame(&native,ordinal,time,current,&before).unwrap().unwrap();
   assert_eq!(actual(&wrapper_plan.rng),actual(&random));wrapped=wrapper_plan.state;host=wrapped.host.clone();
   if actual(&random)!=rng(&row["rng_after"]){failures.push(serde_json::json!({"effect":seq["effect"],"tag":seq["tag"],"frame":ordinal,"rng_after":true}));}
   if host.storage.particles.len()!=row["particles"].as_array().unwrap().len(){failures.push(serde_json::json!({"effect":seq["effect"],"frame":ordinal,"count":host.storage.particles.len()}));}
   let wrapped_surfaces=wrapped.surfaces(native.getter_source,|_,_|Err("disabled authored branch must not consume a lookup".into())).unwrap();
   for (i,record) in host.storage.particles.iter().enumerate(){
    for offset in [4,0x10,0x1c,0x28,0x34,0x40,0x4c,0x58,0x64,0x70,0x7c,0x88]{let got=record.native_words(offset).unwrap();let expected=row["particles"][i][format!("0x{offset:x}")].as_array().unwrap().iter().map(word).collect::<Vec<_>>();let diffs=got.iter().zip(&expected).enumerate().filter(|(_, (a,b))|a!=b).map(|(i,(a,b))|serde_json::json!({"word":i,"actual":a,"native":b})).collect::<Vec<_>>();if !diffs.is_empty(){failures.push(serde_json::json!({"effect":seq["effect"],"tag":seq["tag"],"frame":ordinal,"record":i,"buffer":offset,"differences":diffs}));}}
    // Real factory primary_raw_words supply PRIMARY+478/45C. Nested is distinct.
    assert!(!native.getter_source.attribute_enabled);
    let got=wrapped_surfaces[i];
    let expected=words::<56>(&row["surface_records"][i]);
    let diffs=got.iter().zip(&expected).enumerate().filter(|(_, (a,b))|a!=b).map(|(i,(a,b))|serde_json::json!({"word":i,"actual":a,"native":b})).collect::<Vec<_>>();
    if !diffs.is_empty(){failures.push(serde_json::json!({"effect":seq["effect"],"tag":seq["tag"],"frame":ordinal,"record":i,"surface_differences":diffs}));}
    records+=1;
   }
   for (value,key) in [(host.last_update.to_bits(),"0x80"),(host.last_birth.to_bits(),"0x78"),(host.distance_anchor.to_bits(),"0x108"),(host.emitted as u32,"0x118")]{if value!=word(&row["instance_fields"][key]){failures.push(serde_json::json!({"effect":seq["effect"],"tag":seq["tag"],"frame":ordinal,"instance":key,"actual":value,"native":row["instance_fields"][key]}));}}
   if host.frame.last_time.to_bits()!=word(&row["storage_last_time"])||host.frame.initialized_particles!=word(&row["storage_initialized"]){failures.push(serde_json::json!({"effect":seq["effect"],"tag":seq["tag"],"frame":ordinal,"storage_state":true}));}
   frames+=1;
  }
  assert!(!host.finished(&native.profile,6.),"infinite mist emitter remains active");
 }
 assert_eq!(frames,168);assert_eq!(records,264);
 println!("{}",serde_json::json!({"frames":frames,"records":records,"failures":failures,"failure_count":failures.len(),"gpu_verified":false}));if !failures.is_empty(){std::process::exit(1);}
}
