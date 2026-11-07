use super::*;
#[test]fn every_native_pickup_draw_packet_and_index_matches_whole_original_caller(){
 let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/relic_pickup/simple_full_draw_vectors.json")).unwrap();
 let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),96);
 let view=std::array::from_fn(|i|f32::from_bits(proof["view_bits"][i].as_u64().unwrap() as u32));
 for c in cases {let profile=match c["group"].as_str().unwrap(){"starTrailspin"=>Profile::HealStarTrail,"mesh"=>Profile::HealMesh,"starswirl"=>Profile::ManaStarSwirl,"shafts"=>Profile::ManaShafts,_=>panic!()};
  let word=|key:&str|f32::from_bits(c[key].as_u64().unwrap() as u32);let v=|key:&str,i:usize|f32::from_bits(c[key][i].as_u64().unwrap() as u32);
  let particle=Particle{position:std::array::from_fn(|i|v("position_bits",i)),scale:word("scale_bits"),rotation:word("angle_bits"),age:0.5,lookup:std::array::from_fn(|i|v("lookup_bits",i))};
  let frame=Frame{instance_e0:word("owner_e0_bits"),system_bc:word("system_bc_bits"),system_c0:word("system_c0_bits"),rgba:std::array::from_fn(|i|v("rgba_bits",i)),scroll:[0.;2]};
  let config=Config::for_profile(profile);assert_eq!(config.particle_type,c["particle_type"].as_u64().unwrap() as u32);assert_eq!(config.orientation,c["orientation"].as_u64().unwrap() as u32);
  let p=packet(config,particle,frame,Some(view)).unwrap().unwrap();assert_eq!(p.native.words.into_iter().flatten().collect::<Vec<_>>(),c["output_words"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect::<Vec<_>>());
  assert_eq!(p.indices,c["index_words"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u16).collect::<Vec<_>>().as_slice());
 }
}
#[test]fn draw_binding_rejects_missing_producers_and_skips_retired_or_unordered_particles(){
 let p=Particle{position:[0.;3],scale:1.,rotation:0.,age:0.,lookup:[0.;2]};let f=Frame{instance_e0:1.,system_bc:1.,system_c0:1.,rgba:[1.;4],scroll:[0.;2]};
 assert!(packet(Config::for_profile(Profile::HealStarTrail),p,f,None).is_err());
 for age in [1.,2.,f32::NAN]{assert!(packet(Config::for_profile(Profile::HealStarTrail),Particle{age,..p},f,None).unwrap().is_none());}
 let config=Config::for_profile(Profile::ManaShafts);assert!(packet(config,p,Frame{instance_e0:f32::NAN,..f},None).is_err());
 assert!(packet(Config{particle_type:3,..config},p,f,None).is_err());
 assert!(packet(config,p,f,None).unwrap().is_some());
 let mut state=openleague_core::native_simple_particle_update::State{last_time:0,life:vec![],ages:vec![0],active:1,positions:vec![],velocities:vec![],scales:vec![],factors:vec![],scalar:vec![],rates:vec![],auxiliary:vec![],attribute_a:vec![],attribute_b:vec![],previous_heights:vec![],bounds:openleague_core::native_simple_bounds_policy::State{bounds:openleague_core::native_simple_particle_bounds::Bounds{minimum:[0;3],maximum:[0;3]},center:[0;3],last:0},counter:0};
 assert!(particle(&state,0).is_err());state.positions.push([0;3]);state.scales.push(1f32.to_bits());state.scalar.push((-800f32).to_bits());state.attribute_a.push(0.25f32.to_bits());state.attribute_b.push(0.75f32.to_bits());
 let loaded=particle(&state,0).unwrap();assert_eq!(loaded.rotation,-800.);assert_eq!(loaded.lookup,[0.25,0.75]);assert_eq!(loaded.scale,1.);assert!(particle(&state,1).is_err());
}
