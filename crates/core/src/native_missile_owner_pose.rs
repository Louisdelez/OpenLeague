//! Concrete projectile owner connected to the qualified Troy owner phase.
use crate::{native_actor_effect_owner::Owner,native_troy_owner_pose::{self,Backend,Config,DeferredCall},native_troy_properties::{Source,Emitter}};
struct Provider<'a,F> {owner:Owner,matrix:Option<[u32;16]>,dispatch:&'a mut F}
impl<F:FnMut(DeferredCall,&mut Vec<DeferredCall>)> Backend for Provider<'_,F> {
 fn eligible(&mut self)->u8 {u8::from(self.owner.eligible())}
 fn position(&mut self)->Option<[u32;3]> {self.owner.position().map(|v|v.map(f32::to_bits))}
 fn direction(&mut self)->Option<[u32;3]> {self.owner.direction().map(|v|v.map(f32::to_bits))}
 fn orientation(&mut self)->Option<[u32;16]> {self.matrix}
 fn primary_status(&mut self)->u8 {self.owner.primary_status()}
 fn secondary_status(&mut self)->u8 {u8::from(self.owner.secondary_status())}
 fn deferred(&mut self,call:DeferredCall,pending:&mut Vec<DeferredCall>) {(self.dispatch)(call,pending)}
}
pub fn transfer(source:&mut Source,emitter:&mut Emitter,config:Config,linked:bool,owner:Owner,pending:&mut Vec<DeferredCall>,dispatch:&mut impl FnMut(DeferredCall,&mut Vec<DeferredCall>))->Result<(),&'static str> {
 let matrix=if linked && owner.eligible() && source.flags&0x10!=0 && source.flags&0x20==0 {
    let (ok,m)=crate::native_missile_effect_owner::orientation(owner.direction())?;ok.then_some(m.map(f32::to_bits))
 }else{None};
 let mut provider=Provider {owner,matrix,dispatch};
 native_troy_owner_pose::transfer(source,emitter,config,linked,pending,&mut provider);
 Ok(())
}
#[cfg(test)]
mod tests {
 use super::*;
 use crate::{native_actor_effect_owner::Actor,native_troy_position_bounds::Bounds};
 #[test]
 fn concrete_owner_phase_matches72_original_binding_and_pose_executions() {
    let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/missile_effect_owner_pose_pipeline_contract.json")).unwrap();
    let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),72);
    for (n,row) in cases.iter().enumerate() {
        let identity=[1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.].map(f32::to_bits);
        let position=[-1.,-2.,-3.].map(f32::to_bits);let direction=[-4.,-5.,-6.].map(f32::to_bits);
        let mut source=Source {requests:0,flags:row["flags"].as_u64().unwrap() as u32,visibility:0,params:[0;3],color:[0;8],matrix:identity,channels:[0;3],field_80:0,position,direction};
        let mut emitter=Emitter {flags:0,source_flags:0x80,channels:[0;3],field_80:0,params:[0;3],color:[0;8],matrix:identity,bounds:Bounds {position,minimum:[0;3],maximum:[0;3]},direction};
        let actor=Actor {position:[100.,200.,300.],direction:std::array::from_fn(|i|row["direction"][i].as_f64().unwrap() as f32),flags:0x400,type_tag:0,primary_status:1,current_id:8,field_50c:0};
        let owner=Owner {actor:row["owner_live"].as_bool().unwrap().then_some(actor),previous_id:7};let linked=row["provider_present"].as_bool().unwrap() && row["effect_live"].as_bool().unwrap();
        transfer(&mut source,&mut emitter,Config {group_vis:500f32.to_bits(),flags:0},linked,owner,&mut Vec::new(),&mut |_,_|panic!("unexpected empty-queue dispatch")).unwrap();
        let r=&row["result"];
        for (key,actual) in [("source_position",source.position.to_vec()),("source_direction",source.direction.to_vec()),("source_matrix",source.matrix.to_vec()),("position",emitter.bounds.position.to_vec()),("direction",emitter.direction.to_vec()),("matrix",emitter.matrix.to_vec()),("minimum",emitter.bounds.minimum.to_vec()),("maximum",emitter.bounds.maximum.to_vec())] {
            let expected:Vec<_>=r[key].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect();assert_eq!(actual,expected,"case{n} {key}");
        }
        assert_eq!(emitter.source_flags,r["source_flags"].as_u64().unwrap() as u32,"case{n}");
    }
 }

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
}
