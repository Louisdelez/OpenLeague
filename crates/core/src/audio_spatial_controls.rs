//! Native AF3060/AFECA0/AFEE20/AF19E0 spatial controls and pose arithmetic.
//! Registry values are explicit native resource snapshots; lock/destruction is separate.
use std::collections::BTreeMap;
use crate::audio_rtpc_manager::Manager;
#[derive(Debug,Clone,Default)] pub struct Spatial {pub raw:[u8;16]}
impl Spatial {pub fn values(&self)->[f32;3]{std::array::from_fn(|i|f32::from_le_bytes(self.raw[i*4..i*4+4].try_into().unwrap()))}pub fn flag(&self)->u8{self.raw[12]}fn set(&mut self,i:usize,v:f32){self.raw[i*4..i*4+4].copy_from_slice(&v.to_le_bytes());}}
#[derive(Debug,Clone)] pub struct Pose {pub raw:[u8;60]}
impl Default for Pose {fn default()->Self{Self {raw:[0;60]}}}
impl Pose {fn set(&mut self,o:usize,v:f32){self.raw[o..o+4].copy_from_slice(&v.to_le_bytes());}}
#[derive(Debug,Clone,Default)] pub struct Node {pub reference:u32,pub flags2f:u8,pub props:BTreeMap<u8,f32>,pub rtpc_mask:u64,pub attenuation:Option<u32>}
#[derive(Debug,Clone)] pub struct Attenuation {pub selected:u8,pub curves:Vec<Option<Vec<f32>>>}
#[derive(Debug,Clone,Default)] pub struct Registry {pub records:BTreeMap<u32,Attenuation>}
#[derive(Debug,PartialEq)] pub enum Error {EmptyHierarchy,InvalidValue,InvalidResource,Rtpc(crate::audio_rtpc_manager::Error)}
#[derive(Debug,Clone,PartialEq,serde::Serialize)] #[serde(tag="kind",rename_all="lowercase")]
pub enum Call {Chosen {node:usize},Rtpc {node:usize,parameter:u32,owner:u32},Attenuation {node:usize},Lookup {id:u32},Release}
fn parameter(nodes:&[Node],i:usize,p:u32,owner:u32,manager:&Manager,calls:&mut Vec<Call>)->Result<f32,Error>{calls.push(Call::Rtpc {node:i,parameter:p,owner});manager.evaluate(nodes[i].reference,p,owner).map(|v|v.value).map_err(Error::Rtpc)}
/// Native getter returns the selected curve's last point's first field, not its
/// evaluated gain. Missing descriptor/resource/selected curve/points returns false.
fn attenuation(nodes:&[Node],i:usize,registry:&Registry,calls:&mut Vec<Call>)->Result<Option<f32>,Error>{
 calls.push(Call::Attenuation {node:i});let Some(id)=nodes[i].attenuation else{return Ok(None)};calls.push(Call::Lookup {id});let Some(record)=registry.records.get(&id) else{return Ok(None)};
 let result=if record.selected==255 {Ok(None)}else{match record.curves.get(usize::from(record.selected)){None=>Err(Error::InvalidResource),Some(None)=>Ok(None),Some(Some(points))=>match points.last(){None=>Err(Error::InvalidResource),Some(v) if !v.is_finite()=>Err(Error::InvalidValue),Some(v)=>Ok(Some(*v))}}};
 calls.push(Call::Release);result
}
pub fn apply(nodes:&[Node],owner:u32,spatial:&mut Spatial,pose:Option<&mut Pose>,manager:&Manager,registry:&Registry)->Result<Vec<Call>,Error>{
 if nodes.is_empty(){return Err(Error::EmptyHierarchy);}let i=nodes.iter().position(|n|n.flags2f&0x10!=0).unwrap_or(nodes.len()-1);let n=&nodes[i];let mut calls=vec![Call::Chosen {node:i}];
 let a=n.rtpc_mask&(1<<20)!=0;let b=n.rtpc_mask&(1<<21)!=0;
 let pair=if a||b {[if a {parameter(nodes,i,20,owner,manager,&mut calls)?}else{0.},if b {parameter(nodes,i,21,owner,manager,&mut calls)?}else{0.}]}else{[n.props.get(&11).copied().unwrap_or(0.),n.props.get(&12).copied().unwrap_or(0.)]};
 let third=n.props.get(&13).copied().unwrap_or(0.);if pair.iter().chain([third].iter()).any(|v|!v.is_finite()){return Err(Error::InvalidValue);}
 for (j,v) in pair.into_iter().chain([third]).enumerate(){spatial.set(j,v);}spatial.raw[12]=(n.flags2f>>5)&1;
 if let Some(pose)=pose {
  let a=n.rtpc_mask&(1u64<<37)!=0;let b=n.rtpc_mask&(1u64<<38)!=0;
  if a||b {
   let mut range=0f32;let mut x=if a {parameter(nodes,i,37,owner,manager,&mut calls)?}else{0.};
   if a {if let Some(value)=attenuation(nodes,i,registry,&mut calls)? {range=value;x=(range*f32::from_bits(0x3c23d70a))*x;}}
   pose.set(20,x);pose.set(24,0.);
   let z=if b {let mut v=parameter(nodes,i,38,owner,manager,&mut calls)?;if range!=0. {v=(range*f32::from_bits(0x3c23d70a))*v;}else if let Some(value)=attenuation(nodes,i,registry,&mut calls)? {v=(value*f32::from_bits(0x3c23d70a))*v;}v}else{1.};
   if !x.is_finite() || !z.is_finite(){return Err(Error::InvalidValue);}pose.set(28,z);
  }
  pose.raw[56]=(pose.raw[56]&!4)|if a||b {4}else{0};
 }
 Ok(calls)
}
/// Supplies the real spatial and optional pose dependency to whole voice refresh.
pub struct SpatialBackend<'a,B>{pub dependencies:&'a mut B,pub nodes:&'a [Node],pub manager:&'a Manager,pub registry:&'a Registry,pub calls:Vec<Call>}
impl<B:crate::audio_control_refresh::Backend> crate::audio_control_refresh::Backend for SpatialBackend<'_,B>{
 fn spatial(&mut self,s:&mut crate::audio_control_refresh::State)->Result<(),crate::audio_control_refresh::Error>{self.calls=apply(self.nodes,s.owner,&mut s.spatial,s.pose.as_mut(),self.manager,self.registry).map_err(|_|crate::audio_control_refresh::Error::Backend("spatial controls failed"))?;Ok(())}
 fn optional(&mut self)->Result<(),crate::audio_control_refresh::Error>{self.dependencies.optional()}
 fn flag(&mut self,o:u32)->Result<u8,crate::audio_control_refresh::Error>{self.dependencies.flag(o)}
 fn source(&mut self)->Result<f32,crate::audio_control_refresh::Error>{self.dependencies.source()}
 fn routing(&mut self,s:&mut crate::audio_control_refresh::State)->Result<(),crate::audio_control_refresh::Error>{self.dependencies.routing(s)}
 fn parameters(&mut self,s:&mut crate::audio_control_refresh::State,r:crate::audio_control_refresh::Request)->Result<(),crate::audio_control_refresh::Error>{self.dependencies.parameters(s,r)}
 fn pair(&mut self,o:u32)->Result<[f32;2],crate::audio_control_refresh::Error>{self.dependencies.pair(o)}
 fn transition(&mut self,v:f32)->Result<(),crate::audio_control_refresh::Error>{self.dependencies.transition(v)}
}
#[cfg(test)] pub(crate) mod tests {
 use super::*;
 pub(crate) fn fixture(row:&serde_json::Value)->(Vec<Node>,Manager,Registry){
  let nodes:Vec<_>=row["nodes"].as_array().unwrap().iter().map(|v|Node {reference:v["reference"].as_u64().unwrap() as u32,flags2f:v["flags2f"].as_u64().unwrap() as u8,props:v["props"].as_object().unwrap().iter().map(|(k,v)|(k.parse().unwrap(),v.as_f64().unwrap() as f32)).collect(),rtpc_mask:((v["rtpc_mask"].as_u64().unwrap()&1)<<20)|((v["rtpc_mask"].as_u64().unwrap()&2)<<20)|((v["pose_mask"].as_u64().unwrap_or(0)&1)<<37)|((v["pose_mask"].as_u64().unwrap_or(0)&2)<<37),attenuation:v["attenuation"].as_u64().map(|v|v as u32)}).collect();
  let mut manager=Manager::default();manager.records.insert(100,crate::audio_rtpc_manager::Record {default:20.,overrides:BTreeMap::from([(0,25.),(77,75.)])});
  for (i,n) in nodes.iter().enumerate(){for p in [20,21,37,38]{let begin=p as f32*0.125+i as f32*2.+row["nodes"][i]["variant"].as_f64().unwrap_or(0.) as f32;manager.bindings.insert((n.reference,p),vec![crate::audio_rtpc_manager::RouteCurve {rtpc:100,curve:crate::audio_curves::Curve {scaling:0,points:vec![crate::audio_curves::Point {from:0.,to:begin,interp:4},crate::audio_curves::Point {from:100.,to:begin+10.,interp:4}]}}]);}}
  let mut registry=Registry::default();if let Some(mode)=row["att_mode"].as_u64(){if mode!=1 {let endpoint=row["endpoint"].as_f64().unwrap() as f32;registry.records.insert(1234,Attenuation {selected:if mode==2 {255}else{1},curves:vec![None,if mode==3 {None}else{Some(if mode==4 {vec![endpoint]}else{vec![0.,5.,endpoint]})}]});}}
  (nodes,manager,registry)
 }
 pub(crate) fn hex<const N:usize>(s:&str)->[u8;N]{std::array::from_fn(|i|u8::from_str_radix(&s[i*2..i*2+2],16).unwrap())}
 #[test] fn original_spatial_selection_and_controls_match1920_cases(){
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_spatial_controls_contract.json")).unwrap();assert_eq!(proof["case_count"],1920);
  for (case,row) in proof["cases"].as_array().unwrap().iter().enumerate(){let (nodes,m,r)=fixture(row);let mut s=Spatial {raw:[0xa5;16]};let calls=apply(&nodes,row["owner"].as_u64().unwrap() as u32,&mut s,None,&m,&r).unwrap();assert_eq!(s.raw,hex(row["output"].as_str().unwrap()),"case {case}");assert_eq!(serde_json::json!(calls),row["calls"],"calls {case}");}
 }
 #[test] fn original_spatial_pose_and_attenuation_match9216_cases(){
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_spatial_pose_contract.json")).unwrap();assert_eq!(proof["case_count"],9216);assert_eq!(proof["percent_bits"],0.01f32.to_bits());
  for (case,row) in proof["cases"].as_array().unwrap().iter().enumerate(){let (nodes,m,r)=fixture(row);let mut s=Spatial {raw:[0xa5;16]};let mut pose=Pose {raw:hex(row["initial_pose"].as_str().unwrap())};let calls=apply(&nodes,row["owner"].as_u64().unwrap() as u32,&mut s,Some(&mut pose),&m,&r).unwrap();assert_eq!(s.raw,hex(row["output"].as_str().unwrap()),"spatial {case}");assert_eq!(pose.raw,hex(row["output_pose"].as_str().unwrap()),"pose {case}");let expected:Vec<_>=row["calls"].as_array().unwrap().iter().filter(|v|!matches!(v["kind"].as_str(),Some("lock"|"unlock"))).collect();assert_eq!(serde_json::json!(calls),serde_json::json!(expected),"calls {case}");}
 }
 #[test] fn invalid_spatial_inputs_and_empty_resources_fail_explicitly(){let mut s=Spatial::default();let m=Manager::default();assert_eq!(apply(&[],0,&mut s,None,&m,&Registry::default()),Err(Error::EmptyHierarchy));let n=Node {props:BTreeMap::from([(13,f32::NAN)]),..Default::default()};assert_eq!(apply(&[n],0,&mut s,None,&m,&Registry::default()),Err(Error::InvalidValue));let n=Node {rtpc_mask:1u64<<37,attenuation:Some(1234),..Default::default()};let r=Registry {records:BTreeMap::from([(1234,Attenuation {selected:0,curves:vec![Some(vec![])]})])};assert_eq!(apply(&[n],0,&mut s,Some(&mut Pose::default()),&m,&r),Err(Error::InvalidResource));}
}
