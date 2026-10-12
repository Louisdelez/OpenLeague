from pathlib import Path
import shutil
r=Path('E:/OpenLeague');p=r/'crates/core/src/native_missile_owner_pose.rs';s=p.read_text(encoding='utf-8');assert 'matches180_original_factory' not in s
test='''
 #[test]
 fn matches180_original_factory_sync_binding_and_owner_phase() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/projectile_pose_composition_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),180);
  for c in cases {
   let live=c["effect_live"].as_bool().unwrap();let owner_live=c["owner_live"].as_bool().unwrap();let flags=c["flags"].as_u64().unwrap() as u32;
   let setup=crate::native_projectile_factory_pose::Setup::load(0,c["pending_flags"].as_u64().unwrap() as u32,[500.,600.,700.],live).unwrap();assert_eq!(flags,setup.troy_flags);
   let position=std::array::from_fn(|i|c["position"][i].as_f64().unwrap() as f32);let direction=std::array::from_fn(|i|c["direction"][i].as_f64().unwrap() as f32);
   let synced=crate::native_missile_position_sync::synchronize(position,0.,false).unwrap();assert_eq!(synced,position);
   let before=&c["before"];let words=|key:&str|before[key].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect::<Vec<_>>();
   let mut source=Source{requests:0,flags,visibility:0,params:[0;3],color:[0;8],matrix:words("source_matrix").try_into().unwrap(),channels:[0;3],field_80:0,position:words("source_position").try_into().unwrap(),direction:words("source_direction").try_into().unwrap()};
   let mut emitter=Emitter{flags:0,source_flags:before["source_flags"].as_u64().unwrap() as u32,channels:[0;3],field_80:0,params:[0;3],color:[0;8],matrix:words("matrix").try_into().unwrap(),bounds:crate::native_troy_position_bounds::Bounds{position:words("position").try_into().unwrap(),minimum:words("minimum").try_into().unwrap(),maximum:words("maximum").try_into().unwrap()},direction:words("direction").try_into().unwrap()};
   let actor=crate::native_actor_effect_owner::Actor{position:synced,direction,flags:0x400,type_tag:0,primary_status:1,current_id:8,field_50c:0};
   transfer(&mut source,&mut emitter,Config{group_vis:500f32.to_bits(),flags:0},live,Owner{actor:owner_live.then_some(actor),previous_id:7},&mut vec![],&mut |_,_|panic!("empty deferred queue")).unwrap();
   let expected=&c["result"];
   for (key,actual) in [("source_position",source.position.to_vec()),("source_direction",source.direction.to_vec()),("source_matrix",source.matrix.to_vec()),("position",emitter.bounds.position.to_vec()),("direction",emitter.direction.to_vec()),("matrix",emitter.matrix.to_vec()),("minimum",emitter.bounds.minimum.to_vec()),("maximum",emitter.bounds.maximum.to_vec())]{let values:Vec<u32>=expected[key].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect();assert_eq!(actual,values,"{key} {c}");}
   assert_eq!(emitter.source_flags,expected["source_flags"].as_u64().unwrap() as u32,"{c}");
  }
 }
'''
idx=s.rfind('}');p.write_text(s[:idx]+test+s[idx:],encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
