//! AF0880 / AFEF40 actor hierarchy contributions, original order and rounding.
//! Input nodes are the ordered sound-to-parent chain, not an inferred bank graph.
use std::collections::BTreeMap;
use crate::{audio_control_refresh::{State,Request,Backend},audio_random::NativeRandom,audio_rtpc_manager::Manager};
#[derive(Debug,Clone,Default)]
pub struct Node {
 pub reference:u32,pub props:BTreeMap<u8,f32>,pub global:BTreeMap<u8,f32>,
 pub objects:BTreeMap<u32,BTreeMap<u8,f32>>,pub cached:Vec<BTreeMap<u8,f32>>,
 pub ranges:BTreeMap<u8,[f32;2]>,pub flags55:u8,pub flags56:u8,pub rtpc_mask:u64,
 /// Native50 fields copied bit-for-bit into block3C/40/44/48; semantics are not inferred.
 pub extended:Option<[u32;4]>,
 /// Bus presence requires explicit verified-class bindings in apply_with_bus. Effects remain unsupported.
 pub bus:bool,pub effects:bool,
 /// Captured native caller flags [global,owner]. Required for non-unit state10;
 /// reserved upper bits are not reconstructed or inferred from node properties.
 pub gain_flags:Option<[u32;2]>,
}
#[derive(Debug,PartialEq)] pub enum Error {EmptyHierarchy,Unsupported(&'static str),InvalidValue,MissingBus(usize),UnexpectedBus(usize),Bus(crate::audio_bus_controls::Error),Gain(crate::audio_gain_entries::Error),Rtpc(crate::audio_rtpc_manager::Error)}
#[derive(Debug,Clone,PartialEq,serde::Serialize)]
#[serde(tag="kind",rename_all="lowercase")]
pub enum Call {Actor {node:usize,first:u32,last:u32},Rtpc {node:usize,parameter:u32,owner:u32},Draw {value:u16},Gain {node:usize,flags:u32,gain_bits:u32}}
fn add(state:&mut State,offset:usize,value:f32){state.set_value(offset,state.value(offset)+value);}
fn parameter(node:&Node,index:usize,p:u32,owner:u32,manager:&Manager,calls:&mut Vec<Call>)->Result<f32,Error>{
 calls.push(Call::Rtpc {node:index,parameter:p,owner});manager.evaluate(node.reference,p,owner).map(|v|v.value).map_err(Error::Rtpc)
}
/// Mutates the same 84-byte block/extras used by the whole voice refresh.
/// Cached states precede local properties; global and object states ignore mask;
/// random ranges apply only on first traversal, including all parent nodes.
fn validate(nodes:&[Node],allow_bus:bool)->Result<(),Error>{
 if nodes.is_empty(){return Err(Error::EmptyHierarchy);}
 for n in nodes {
  if n.bus && !allow_bus{return Err(Error::Unsupported("actor bus24"));}
  if n.effects{return Err(Error::Unsupported("actor effects4C"));}
  if n.global.get(&10).into_iter().chain(n.objects.values().filter_map(|p|p.get(&10))).any(|v|*v!=1.) {let Some(flags)=n.gain_flags else{return Err(Error::Unsupported("state10 native caller flags missing"));};if flags[0]&3!=1 || flags[1]&3!=0{return Err(Error::InvalidValue);}}
  if n.props.values().chain(n.global.values()).chain(n.objects.values().flat_map(|p|p.values())).chain(n.cached.iter().flat_map(|p|p.values())).chain(n.ranges.values().flatten()).any(|v|!v.is_finite()){return Err(Error::InvalidValue);}
 }
 Ok(())
}
fn check_output(state:&State)->Result<(),Error>{
 if state.extras.iter().any(|v|!v.is_finite()) || [0,8,12,16,20,28,44,48,52,56,76].iter().any(|o|!state.value(*o).is_finite()){return Err(Error::InvalidValue);}
 Ok(())
}
fn apply_local(node:&Node,index:usize,root:bool,state:&mut State,request:Request,manager:&Manager,rng:&mut NativeRandom,calls:&mut Vec<Call>)->Result<(),Error>{
  calls.push(Call::Actor {node:index,first:request.first,last:request.last});
  for cached in &node.cached {for (key,mask,offset) in [(0,1,0),(2,2,8),(3,4,12),(4,8,16)] {if request.mask&mask!=0 {if let Some(value)=cached.get(&key){add(state,offset,*value);}}}}
  for (key,mask,offset,p) in [(0,1,0,0),(33,1,20,36),(2,2,8,2),(3,4,12,3)] {
   if request.mask&mask!=0 {
    if let Some(value)=node.props.get(&key){add(state,offset,*value);}
    if node.rtpc_mask&(1u64<<p)!=0 {let value=parameter(node,index,p,request.owner,manager,calls)?;add(state,offset,value);}
   }
  }
  if request.mask&1!=0 && state.block[24]&2==0 && (node.flags56&1!=0 || root){state.block[24]=(state.block[24]&!1)|2|((node.flags56&2)>>1);}
  if request.mask&16!=0 && state.block[32]&1==0 && (node.flags55&0x80!=0 || root){
   let value=if node.rtpc_mask&(1u64<<35)!=0 {parameter(node,index,35,request.owner,manager,calls)?}else{node.props.get(&32).copied().unwrap_or(12.)};
   state.set_value(28,value);state.block[32]=(state.block[32]&!2)|((node.flags56>>1)&2)|1;
  }
  for (kind,props) in std::iter::once((0,&node.global)).chain(node.objects.get(&request.owner).map(|p|(1,p))) {for (key,offset) in [(0,0),(2,8),(3,12)] {if let Some(value)=props.get(&key){add(state,offset,*value);}}if let Some(&gain)=props.get(&10){if gain!=1. {let flags=node.gain_flags.expect("validated native gain flags")[kind];calls.push(Call::Gain{node:index,flags,gain_bits:gain.to_bits()});crate::audio_gain_entries::upsert(&mut state.entries,node.reference,flags,gain).map_err(Error::Gain)?;}}}
  if request.first!=0 {for (key,extra) in [(0,0),(2,1),(3,2)] {if let Some([min,max])=node.ranges.get(&key){
   let width=*max-*min;
   let value=if width==0. {*min}else{let draw=rng.draw();calls.push(Call::Draw {value:draw});let scaled=((f64::from(draw)*f64::from_bits(0x3f00002000400080))*f64::from(width)) as f32;*min+scaled};
   state.extras[extra]+=value;
  }}}
  if state.block[82]==0 && (node.flags55&0x40!=0 || root){
   state.block[82]=1;
   if let Some(raw)=node.extended {
    for (key,offset,p) in [(18,44,15),(19,48,16),(20,52,17),(21,56,18)] {
     add(state,offset,node.props.get(&key).copied().unwrap_or(0.));
     if node.rtpc_mask&(1u64<<p)!=0 {let value=parameter(node,index,p,request.owner,manager,calls)?;add(state,offset,value);}
    }
    for (offset,value) in [60,64,68,72].into_iter().zip(raw){state.block[offset..offset+4].copy_from_slice(&value.to_le_bytes());}
   }
  }
  if state.block[81]==0 && (node.flags55&0x10!=0 || root){
   state.block[81]=1;add(state,76,node.props.get(&22).copied().unwrap_or(0.));
   if node.rtpc_mask&(1u64<<19)!=0 {let value=parameter(node,index,19,request.owner,manager,calls)?;add(state,76,value);}
   state.block[80]=(node.flags55>>5)&1;
  }
 Ok(())
}
pub fn apply(nodes:&[Node],state:&mut State,request:Request,manager:&Manager,rng:&mut NativeRandom)->Result<Vec<Call>,Error>{
 validate(nodes,false)?;if state.entries.iter().any(|e|!e.gain.is_finite()){return Err(Error::InvalidValue);}let mut calls=Vec::new();for (index,node) in nodes.iter().enumerate(){apply_local(node,index,index+1==nodes.len(),state,request,manager,rng,&mut calls)?;}check_output(state)?;Ok(calls)
}
#[derive(Debug,Clone)] pub struct BusBinding {pub nodes:Vec<crate::audio_bus_controls::Node>,pub trace_base:usize}
pub type BusBindings=BTreeMap<usize,BusBinding>;
#[derive(Debug,Clone,serde::Serialize)] #[serde(untagged)] pub enum GraphCall {Actor(Call),Bus(crate::audio_bus_controls::Call)}
/// Native AF0880 selects the nearest enabled bus while recursing to parents;
/// parent contributions finish before its selected B02A70 bus chain executes.
pub fn apply_with_bus(nodes:&[Node],bindings:&BusBindings,state:&mut State,request:Request,manager:&Manager,rng:&mut NativeRandom)->Result<Vec<GraphCall>,Error>{
 validate(nodes,true)?;if state.entries.iter().any(|e|!e.gain.is_finite()){return Err(Error::InvalidValue);}for (i,n) in nodes.iter().enumerate(){if n.bus && !bindings.contains_key(&i){return Err(Error::MissingBus(i));}if !n.bus && bindings.contains_key(&i){return Err(Error::UnexpectedBus(i));}}for (&i,b) in bindings{if i>=nodes.len(){return Err(Error::UnexpectedBus(i));}crate::audio_bus_controls::validate(&b.nodes).map_err(Error::Bus)?;}
 fn visit(nodes:&[Node],bindings:&BusBindings,index:usize,state:&mut State,request:Request,manager:&Manager,rng:&mut NativeRandom,out:&mut Vec<GraphCall>)->Result<(),Error>{
  let node=&nodes[index];let mut local=Vec::new();apply_local(node,index,index+1==nodes.len(),state,request,manager,rng,&mut local)?;
  let selected=request.last!=0 && node.bus;
  if selected{for (key,offset,p) in [(23,36,22),(24,40,23)]{add(state,offset,node.props.get(&key).copied().unwrap_or(0.));if node.rtpc_mask&(1u64<<p)!=0{let value=parameter(node,index,p,request.owner,manager,&mut local)?;add(state,offset,value);}}}
  out.extend(local.into_iter().map(GraphCall::Actor));let next=Request{last:if selected{0}else{request.last},..request};if index+1<nodes.len(){visit(nodes,bindings,index+1,state,next,manager,rng,out)?;}
  if selected{let binding=&bindings[&index];let mut calls=crate::audio_bus_controls::apply(&binding.nodes,state,Request{last:0,..request},manager).map_err(Error::Bus)?;for c in &mut calls{match c{crate::audio_bus_controls::Call::Bus{node,..}|crate::audio_bus_controls::Call::Rtpc{node,..}|crate::audio_bus_controls::Call::Gain{node,..}=>*node+=binding.trace_base}}out.extend(calls.into_iter().map(GraphCall::Bus));}Ok(())
 }
 let mut out=Vec::new();visit(nodes,bindings,0,state,request,manager,rng,&mut out)?;check_output(state)?;if [state.value(36),state.value(40)].iter().any(|v|!v.is_finite()){return Err(Error::InvalidValue);}Ok(out)
}
/// Replaces only the parameter dependency of a complete refresh backend.
/// All spatial/source/routing/transition dependencies remain mandatory.
pub struct ActorBackend<'a,B> {pub dependencies:&'a mut B,pub nodes:&'a [Node],pub manager:&'a Manager,pub rng:&'a mut NativeRandom,pub calls:Vec<Call>}
impl<B:Backend> Backend for ActorBackend<'_,B>{
 fn spatial(&mut self,s:&mut State)->Result<(),crate::audio_control_refresh::Error>{self.dependencies.spatial(s)}
 fn optional(&mut self)->Result<(),crate::audio_control_refresh::Error>{self.dependencies.optional()}
 fn flag(&mut self,o:u32)->Result<u8,crate::audio_control_refresh::Error>{self.dependencies.flag(o)}
 fn source(&mut self)->Result<f32,crate::audio_control_refresh::Error>{self.dependencies.source()}
 fn routing(&mut self,s:&mut State)->Result<(),crate::audio_control_refresh::Error>{self.dependencies.routing(s)}
 fn parameters(&mut self,s:&mut State,r:Request)->Result<(),crate::audio_control_refresh::Error>{self.calls=apply(self.nodes,s,r,self.manager,self.rng).map_err(|_|crate::audio_control_refresh::Error::Backend("actor controls failed"))?;Ok(())}
 fn pair(&mut self,o:u32)->Result<[f32;2],crate::audio_control_refresh::Error>{self.dependencies.pair(o)}
 fn transition(&mut self,v:f32)->Result<(),crate::audio_control_refresh::Error>{self.dependencies.transition(v)}
}
#[cfg(test)] mod tests {
 use super::*;
 fn state()->State{let mut s=State {block:[0;84],flags:[0;5],entries:vec![],extras:[23.,29.,31.],d4:0.,d8:1.,dc:1.,cc:0.,d0:0.,pair:[0.;2],spatial:crate::audio_spatial_controls::Spatial::default(),pose:None,range_limit:0.,context:None,optional:false,owner:0};for (offset,value) in [(0,13.),(4,1.),(8,17.),(12,19.),(20,5.)]{s.set_value(offset,value);}s}
 fn props(v:&serde_json::Value)->BTreeMap<u8,f32>{v.as_object().unwrap().iter().map(|(k,v)|(k.parse().unwrap(),v.as_f64().unwrap() as f32)).collect()}
 fn fixture(row:&serde_json::Value)->(Vec<Node>,Manager){
   let nodes:Vec<_>=row["nodes"].as_array().unwrap().iter().map(|v|Node {reference:v["reference"].as_u64().unwrap() as u32,props:props(&v["props"]),global:props(&v["global"]),objects:BTreeMap::from([(77,props(&v["object"]))]),cached:v["cached"].as_array().unwrap().iter().map(props).collect(),ranges:v["ranges"].as_object().unwrap().iter().map(|(k,v)|(k.parse().unwrap(),[v[0].as_f64().unwrap() as f32,v[1].as_f64().unwrap() as f32])).collect(),flags55:v["flags55"].as_u64().unwrap() as u8,flags56:v["flags56"].as_u64().unwrap() as u8,extended:v["extended"].as_array().map(|a|std::array::from_fn(|i|a[i].as_u64().unwrap() as u32)),rtpc_mask:if v["rtpc"]==true {(1<<0)|(1<<2)|(1<<3)|(1<<15)|(1<<16)|(1<<17)|(1<<18)|(1<<19)|(1<<35)|(1<<36)}else{0},..Default::default()}).collect();
   let mut manager=Manager::default();manager.records.insert(100,crate::audio_rtpc_manager::Record {default:20.,overrides:BTreeMap::from([(0,25.),(77,75.)])});
   for (i,n) in nodes.iter().enumerate(){if n.rtpc_mask!=0 {for p in [0,2,3,15,16,17,18,19,35,36]{let begin=p as f32*0.125+i as f32*2.;manager.bindings.insert((n.reference,p),vec![crate::audio_rtpc_manager::RouteCurve {rtpc:100,curve:crate::audio_curves::Curve {scaling:0,points:vec![crate::audio_curves::Point {from:0.,to:begin,interp:4},crate::audio_curves::Point {from:100.,to:begin+10.,interp:4}]}}]);}}}
   (nodes,manager)
 }
 #[test] fn native_actor_hierarchies_match4608_cases(){
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_actor_controls_contract.json")).unwrap();assert_eq!(proof["case_count"],4608);assert_eq!(proof["default_property32_bits"],12f32.to_bits());
  for (case,row) in proof["cases"].as_array().unwrap().iter().enumerate(){
   let (nodes,manager)=fixture(row);
   let mut s=state();let mut rng=NativeRandom::seeded(17);let calls=apply(&nodes,&mut s,Request {mask:row["mask"].as_u64().unwrap() as u32,first:row["first"].as_u64().unwrap() as u32,owner:row["owner"].as_u64().unwrap() as u32,last:1},&manager,&mut rng).unwrap();
   let hex:String=s.block.iter().map(|b|format!("{b:02x}")).collect();assert_eq!(hex,row["output_block"].as_str().unwrap(),"block case {case}");assert_eq!(serde_json::json!(s.extras.map(f32::to_bits)),row["output_extras_bits"],"extras case {case}");assert_eq!(serde_json::json!(calls),row["calls"],"calls case {case}");assert_eq!(rng.state() as u64,row["rng"].as_u64().unwrap(),"rng case {case}");
  }
 }
 #[test] fn unsupported_dependencies_fail_without_silent_defaults(){
  let mut s=state();let before=s.block;let mut rng=NativeRandom::seeded(17);let req=Request {mask:u32::MAX,first:1,owner:77,last:1};let m=Manager::default();
  for n in [Node {bus:true,..Default::default()},Node {effects:true,..Default::default()},Node {global:BTreeMap::from([(10,0.5)]),..Default::default()}]{assert!(matches!(apply(&[n],&mut s,req,&m,&mut rng),Err(Error::Unsupported(_))));assert_eq!(s.block,before);assert_eq!(rng.state(),17);}
  assert_eq!(apply(&[],&mut s,req,&m,&mut rng),Err(Error::EmptyHierarchy));
 }

 struct Dependencies {calls:Vec<serde_json::Value>}
 impl Backend for Dependencies {
  fn spatial(&mut self,s:&mut State)->Result<(),crate::audio_control_refresh::Error>{self.calls.push(serde_json::json!({"kind":"spatial","owner":s.owner}));s.spatial.raw[..8].copy_from_slice(&[1.25f32.to_le_bytes(),2.5f32.to_le_bytes()].concat());Ok(())}
  fn optional(&mut self)->Result<(),crate::audio_control_refresh::Error>{panic!("not present")}
  fn flag(&mut self,owner:u32)->Result<u8,crate::audio_control_refresh::Error>{self.calls.push(serde_json::json!({"kind":"flag","owner":owner}));Ok(1)}
  fn source(&mut self)->Result<f32,crate::audio_control_refresh::Error>{self.calls.push(serde_json::json!({"kind":"source"}));Ok(-13.125)}
  fn routing(&mut self,_:&mut State)->Result<(),crate::audio_control_refresh::Error>{self.calls.push(serde_json::json!({"kind":"routing"}));Ok(())}
  fn parameters(&mut self,_:&mut State,_:Request)->Result<(),crate::audio_control_refresh::Error>{panic!("actor wrapper must replace this dependency")}
  fn pair(&mut self,owner:u32)->Result<[f32;2],crate::audio_control_refresh::Error>{self.calls.push(serde_json::json!({"kind":"pair","owner":owner}));Ok([2.,3.25])}
  fn transition(&mut self,value:f32)->Result<(),crate::audio_control_refresh::Error>{self.calls.push(serde_json::json!({"kind":"transition","value_bits":value.to_bits()}));Ok(())}
 }
 fn check_refresh(row:&serde_json::Value,case:usize){
   let (nodes,manager)=fixture(row);let mut s=state();s.block=[0xa5;84];s.extras=[0.;3];s.flags=[row["cflag"].as_u64().unwrap() as u8,0x5a,row["eflag"].as_u64().unwrap() as u8,0xa4,row["pflag"].as_u64().unwrap() as u8];s.owner=row["owner"].as_u64().unwrap() as u32;s.d4=1.25;s.d8=0.8;s.dc=0.5;s.pair=[0.,3.25];s.context=Some(6.5);
   let mut rng=NativeRandom::seeded(17);let mut dependencies=Dependencies {calls:Vec::new()};let mut backend=ActorBackend {dependencies:&mut dependencies,nodes:&nodes,manager:&manager,rng:&mut rng,calls:Vec::new()};
   s.refresh(&mut backend).unwrap();let actor_calls=serde_json::json!(backend.calls);drop(backend);
   let hex:String=s.block.iter().map(|b|format!("{b:02x}")).collect();assert_eq!(hex,row["output_block"].as_str().unwrap(),"block case {case}");assert_eq!(serde_json::json!(s.extras.map(f32::to_bits)),row["output_extras_bits"],"extras case {case}");assert_eq!(serde_json::json!(s.flags),row["output_flags"],"flags case {case}");assert_eq!(serde_json::json!([s.cc.to_bits(),s.d0.to_bits()]),row["output_cc_d0"],"cache case {case}");assert_eq!(rng.state() as u64,row["rng"].as_u64().unwrap(),"rng case {case}");
   let is_actor=|v:&serde_json::Value|matches!(v["kind"].as_str(),Some("actor"|"rtpc"|"draw"));let expected=row["calls"].as_array().unwrap();assert_eq!(actor_calls,serde_json::json!(expected.iter().filter(|v|is_actor(v)).collect::<Vec<_>>()),"actor calls case {case}");assert_eq!(serde_json::json!(dependencies.calls),serde_json::json!(expected.iter().filter(|v|!is_actor(v)).collect::<Vec<_>>()),"dependency calls case {case}");
 }
 #[test] fn whole_refresh_with_actual_actor_backend_matches1152_native_cases(){
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_actor_refresh_composition_contract.json")).unwrap();assert_eq!(proof["case_count"],1152);
  for (case,row) in proof["cases"].as_array().unwrap().iter().enumerate(){
   check_refresh(row,case);
  }
 }

 #[test] fn actual_actor_refresh_obeys_voice_cache_and_error_gate(){
  use crate::audio_active_voice_cache::{Store,Voice,Flags};
  let mut store=Store {voices:BTreeMap::from([(1,Voice {next:None,flags:Flags {raw:[0,0x5a,0,0xa4]}})])};let mut s=state();let mut rng=NativeRandom::seeded(17);let manager=Manager::default();let nodes=[Node {props:BTreeMap::from([(0,-31.)]),..Default::default()}];let mut dependencies=Dependencies {calls:vec![]};
  let mut backend=ActorBackend {dependencies:&mut dependencies,nodes:&nodes,manager:&manager,rng:&mut rng,calls:vec![]};
  assert_eq!(crate::audio_control_refresh::refresh_cached(&mut store,1,&mut s,&mut backend),Ok(true));assert_eq!(s.cc,-31.);let count=backend.dependencies.calls.len();assert_eq!(crate::audio_control_refresh::refresh_cached(&mut store,1,&mut s,&mut backend),Ok(false));assert_eq!(backend.dependencies.calls.len(),count);drop(backend);
  store.invalidate(Some(1)).unwrap();let unsupported=[Node {bus:true,..Default::default()}];let mut backend=ActorBackend {dependencies:&mut dependencies,nodes:&unsupported,manager:&manager,rng:&mut rng,calls:vec![]};assert!(crate::audio_control_refresh::refresh_cached(&mut store,1,&mut s,&mut backend).is_err());assert!(store.voices[&1].flags.needs_refresh());
 }

 #[test] fn native_extended_actor_selection_and_parameters_match5120_cases(){
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_actor_extended_contract.json")).unwrap();assert_eq!(proof["case_count"],5120);
  for (case,row) in proof["cases"].as_array().unwrap().iter().enumerate(){
   let (nodes,manager)=fixture(row);let mut s=state();for (o,v) in [(44,-4.),(48,12.),(52,0.25),(56,-0.)]{s.set_value(o,v);}for (o,v) in [(60,0x11111111u32),(64,0x22222222),(68,0x33333333),(72,0x44444444)]{s.block[o..o+4].copy_from_slice(&v.to_le_bytes());}s.block[82]=u8::from(row["initial_selected"].as_bool().unwrap());
   let mut rng=NativeRandom::seeded(17);let calls=apply(&nodes,&mut s,Request {mask:row["mask"].as_u64().unwrap() as u32,first:row["first"].as_u64().unwrap() as u32,owner:row["owner"].as_u64().unwrap() as u32,last:1},&manager,&mut rng).unwrap();
   let hex:String=s.block.iter().map(|b|format!("{b:02x}")).collect();assert_eq!(hex,row["output_block"].as_str().unwrap(),"block case {case}");assert_eq!(serde_json::json!(s.extras.map(f32::to_bits)),row["output_extras_bits"],"extras case {case}");assert_eq!(serde_json::json!(calls),row["calls"],"calls case {case}");assert_eq!(rng.state() as u64,row["rng"].as_u64().unwrap(),"rng case {case}");
  }
 }
 #[test] fn whole_refresh_with_extended_actor_backend_matches2560_native_cases(){
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_actor_extended_refresh_contract.json")).unwrap();assert_eq!(proof["case_count"],2560);for (case,row) in proof["cases"].as_array().unwrap().iter().enumerate(){check_refresh(row,case);}
 }

 #[test] fn whole_refresh_with_real_spatial_pose_and_actors_matches2048_native_cases(){
  use crate::audio_spatial_controls::{SpatialBackend,Pose,tests::{fixture as spatial_fixture,hex}};
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_spatial_refresh_composition_contract.json")).unwrap();assert_eq!(proof["case_count"],2048);
  for (case,row) in proof["cases"].as_array().unwrap().iter().enumerate(){
   let (actor_nodes,mut manager)=fixture(row);let (spatial_nodes,spatial_manager,registry)=spatial_fixture(row);manager.bindings.extend(spatial_manager.bindings);
   let mut s=state();s.block=[0xa5;84];s.extras=[0.;3];s.flags=[row["cflag"].as_u64().unwrap() as u8,0x5a,row["eflag"].as_u64().unwrap() as u8,0xa4,row["pflag"].as_u64().unwrap() as u8];s.owner=row["owner"].as_u64().unwrap() as u32;s.d4=1.25;s.d8=0.8;s.dc=0.5;s.pair=[0.,3.25];s.context=Some(6.5);s.pose=row["initial_pose"].as_str().map(|v|Pose {raw:hex(v)});
   let mut rng=NativeRandom::seeded(17);let mut dependencies=Dependencies {calls:vec![]};let mut actor=ActorBackend {dependencies:&mut dependencies,nodes:&actor_nodes,manager:&manager,rng:&mut rng,calls:vec![]};let mut backend=SpatialBackend {dependencies:&mut actor,nodes:&spatial_nodes,manager:&manager,registry:&registry,calls:vec![]};
   s.refresh(&mut backend).unwrap();let spatial_calls=serde_json::to_value(&backend.calls).unwrap().as_array().unwrap().clone();let actor_calls=serde_json::to_value(&backend.dependencies.calls).unwrap().as_array().unwrap().clone();let dependency_calls=backend.dependencies.dependencies.calls.clone();drop(backend);drop(actor);
   let block:String=s.block.iter().map(|b|format!("{b:02x}")).collect();assert_eq!(block,row["output_block"].as_str().unwrap(),"block {case}");assert_eq!(s.spatial.raw,hex(row["output_spatial"].as_str().unwrap()),"spatial {case}");assert_eq!(s.pose.as_ref().map(|p|p.raw),row["output_pose"].as_str().map(hex),"pose {case}");assert_eq!(serde_json::json!(s.flags),row["output_flags"],"flags {case}");assert_eq!(serde_json::json!([s.cc.to_bits(),s.d0.to_bits()]),row["output_cc_d0"],"cache {case}");assert_eq!(serde_json::json!(s.extras.map(f32::to_bits)),row["output_extras_bits"],"extras {case}");assert_eq!(rng.state() as u64,row["rng"].as_u64().unwrap(),"rng {case}");
   let at=dependency_calls.iter().position(|v|v["kind"]=="pair").unwrap();let calls:Vec<_>=spatial_calls.into_iter().chain(dependency_calls[..at].iter().cloned()).chain(actor_calls).chain(dependency_calls[at..].iter().cloned()).collect();let expected:Vec<_>=row["calls"].as_array().unwrap().iter().filter(|v|!matches!(v["kind"].as_str(),Some("lock"|"unlock"))).collect();assert_eq!(serde_json::json!(calls),serde_json::json!(expected),"calls {case}");
  }
 }
 #[test] fn whole_refresh_with_native_actor_flag_spatial_pose_and_actors_matches2048_cases(){
  use crate::audio_actor_flag::{FlagBackend,tests::fixture as flag_fixture};
  use crate::audio_spatial_controls::{SpatialBackend,Pose,tests::{fixture as spatial_fixture,hex}};
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_actor_flag_refresh_contract.json")).unwrap();assert_eq!(proof["case_count"],2048);
  for (case,row) in proof["cases"].as_array().unwrap().iter().enumerate(){
   let (actor_nodes,mut manager)=fixture(row);let (spatial_nodes,spatial_manager,registry)=spatial_fixture(row);manager.bindings.extend(spatial_manager.bindings);let (flag_nodes,flag_manager)=flag_fixture(row,true);manager.bindings.extend(flag_manager.bindings);
   let mut s=state();s.block=[0xa5;84];s.extras=[0.;3];s.flags=[row["cflag"].as_u64().unwrap() as u8,0x5a,row["eflag"].as_u64().unwrap() as u8,0xa4,row["pflag"].as_u64().unwrap() as u8];s.owner=row["owner"].as_u64().unwrap() as u32;s.d4=1.25;s.d8=0.8;s.dc=0.5;s.pair=[0.,3.25];s.context=Some(6.5);s.pose=row["initial_pose"].as_str().map(|v|Pose {raw:hex(v)});
   let mut rng=NativeRandom::seeded(17);let mut dependencies=Dependencies {calls:vec![]};let mut actor=ActorBackend {dependencies:&mut dependencies,nodes:&actor_nodes,manager:&manager,rng:&mut rng,calls:vec![]};let mut spatial_backend=SpatialBackend {dependencies:&mut actor,nodes:&spatial_nodes,manager:&manager,registry:&registry,calls:vec![]};
   let mut backend=FlagBackend {dependencies:&mut spatial_backend,nodes:&flag_nodes,manager:&manager,calls:vec![]};s.refresh(&mut backend).unwrap();let flag_calls=serde_json::to_value(&backend.calls).unwrap().as_array().unwrap().clone();let spatial_calls=serde_json::to_value(&backend.dependencies.calls).unwrap().as_array().unwrap().clone();let actor_calls=serde_json::to_value(&backend.dependencies.dependencies.calls).unwrap().as_array().unwrap().clone();let dependency_calls=backend.dependencies.dependencies.dependencies.calls.clone();drop(backend);drop(spatial_backend);drop(actor);
   let block:String=s.block.iter().map(|b|format!("{b:02x}")).collect();assert_eq!(block,row["output_block"].as_str().unwrap(),"block {case}");assert_eq!(s.spatial.raw,hex(row["output_spatial"].as_str().unwrap()),"spatial {case}");assert_eq!(s.pose.as_ref().map(|p|p.raw),row["output_pose"].as_str().map(hex),"pose {case}");assert_eq!(serde_json::json!(s.flags),row["output_flags"],"flags {case}");assert_eq!(serde_json::json!([s.cc.to_bits(),s.d0.to_bits()]),row["output_cc_d0"],"cache {case}");assert_eq!(serde_json::json!(s.extras.map(f32::to_bits)),row["output_extras_bits"],"extras {case}");assert_eq!(rng.state() as u64,row["rng"].as_u64().unwrap(),"rng {case}");
   let at=dependency_calls.iter().position(|v|v["kind"]=="pair").unwrap();let calls:Vec<_>=spatial_calls.into_iter().chain(flag_calls).chain(dependency_calls[..at].iter().cloned()).chain(actor_calls).chain(dependency_calls[at..].iter().cloned()).collect();let expected:Vec<_>=row["calls"].as_array().unwrap().iter().filter(|v|!matches!(v["kind"].as_str(),Some("lock"|"unlock"))).collect();assert_eq!(serde_json::json!(calls),serde_json::json!(expected),"calls {case}");
  }
 }
 #[test] fn whole_refresh_with_pair_transition_consumers_matches2048_native_cases(){
  use crate::audio_pair_controls::{PairBackend,tests::fixture as pair_fixture};
  use crate::audio_priority_transition::{TransitionBackend,tests::fixture as transition_fixture};
  use crate::audio_actor_flag::{FlagBackend,tests::fixture as flag_fixture};
  use crate::audio_spatial_controls::{SpatialBackend,Pose,tests::{fixture as spatial_fixture,hex}};
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_pair_transition_refresh_contract.json")).unwrap();assert_eq!(proof["case_count"],2048);
  for (case,row) in proof["cases"].as_array().unwrap().iter().enumerate(){
   let (actor_nodes,mut manager)=fixture(row);let (spatial_nodes,spatial_manager,registry)=spatial_fixture(row);manager.bindings.extend(spatial_manager.bindings);let (flag_nodes,flag_manager)=flag_fixture(row,true);manager.bindings.extend(flag_manager.bindings);let (pair_nodes,pair_manager)=pair_fixture(row,true);manager.bindings.extend(pair_manager.bindings);let mut priority=transition_fixture(row,true);
   let mut s=state();s.block=[0xa5;84];s.extras=[0.;3];s.flags=[row["cflag"].as_u64().unwrap() as u8,0x5a,row["eflag"].as_u64().unwrap() as u8,0xa4,row["pflag"].as_u64().unwrap() as u8];s.owner=row["owner"].as_u64().unwrap() as u32;s.d4=1.25;s.d8=0.8;s.dc=0.5;s.pair=[0.,3.25];s.context=Some(6.5);s.pose=row["initial_pose"].as_str().map(|v|Pose {raw:hex(v)});
   let mut rng=NativeRandom::seeded(17);let mut dependencies=Dependencies {calls:vec![]};let mut actor=ActorBackend {dependencies:&mut dependencies,nodes:&actor_nodes,manager:&manager,rng:&mut rng,calls:vec![]};let mut spatial_backend=SpatialBackend {dependencies:&mut actor,nodes:&spatial_nodes,manager:&manager,registry:&registry,calls:vec![]};
   let mut flag_backend=FlagBackend {dependencies:&mut spatial_backend,nodes:&flag_nodes,manager:&manager,calls:vec![]};let mut pair_backend=PairBackend {dependencies:&mut flag_backend,nodes:&pair_nodes,manager:&manager,calls:vec![]};let mut backend=TransitionBackend {dependencies:&mut pair_backend,store:&mut priority,voice:row["priority_voice"].as_u64().unwrap() as u32,local:std::array::from_fn(|i|row["priority_local"][i].as_u64().map(|v|v as u32)),global:row["priority_global"].as_u64().unwrap() as u32,calls:vec![]};
   s.refresh(&mut backend).unwrap();let transition_calls=serde_json::to_value(&backend.calls).unwrap().as_array().unwrap().clone();let pair_calls=serde_json::to_value(&backend.dependencies.calls).unwrap().as_array().unwrap().clone();let flag_calls=serde_json::to_value(&backend.dependencies.dependencies.calls).unwrap().as_array().unwrap().clone();let spatial_calls=serde_json::to_value(&backend.dependencies.dependencies.dependencies.calls).unwrap().as_array().unwrap().clone();let actor_calls=serde_json::to_value(&backend.dependencies.dependencies.dependencies.dependencies.calls).unwrap().as_array().unwrap().clone();let dependency_calls=backend.dependencies.dependencies.dependencies.dependencies.dependencies.calls.clone();drop(backend);drop(pair_backend);drop(flag_backend);drop(spatial_backend);drop(actor);
   let block:String=s.block.iter().map(|b|format!("{b:02x}")).collect();assert_eq!(block,row["output_block"].as_str().unwrap(),"block {case}");assert_eq!(s.spatial.raw,hex(row["output_spatial"].as_str().unwrap()),"spatial {case}");assert_eq!(s.pose.as_ref().map(|p|p.raw),row["output_pose"].as_str().map(hex),"pose {case}");assert_eq!(serde_json::json!(s.flags),row["output_flags"],"flags {case}");assert_eq!(serde_json::json!([s.cc.to_bits(),s.d0.to_bits()]),row["output_cc_d0"],"cache {case}");assert_eq!(serde_json::json!(s.extras.map(f32::to_bits)),row["output_extras_bits"],"extras {case}");assert_eq!(rng.state() as u64,row["rng"].as_u64().unwrap(),"rng {case}");
   assert_eq!(serde_json::json!(s.pair.map(f32::to_bits)),row["output_pair_bits"],"pair {case}");assert_eq!(serde_json::json!(priority.voices[&(row["priority_voice"].as_u64().unwrap() as u32)].value.to_bits()),row["priority_output_bits"],"priority {case}");for g in row["priority_after"].as_array().unwrap(){assert_eq!(serde_json::json!(priority.groups[&(g["reference"].as_u64().unwrap() as u32)].voices),g["after"],"order {case}");}
   let calls:Vec<_>=spatial_calls.into_iter().chain(flag_calls).chain(dependency_calls).chain(actor_calls).chain(pair_calls).chain(transition_calls).collect();let expected:Vec<_>=row["calls"].as_array().unwrap().iter().filter(|v|!matches!(v["kind"].as_str(),Some("lock"|"unlock"))).collect();assert_eq!(serde_json::json!(calls),serde_json::json!(expected),"calls {case}");
  }
 }
 #[test] fn whole_refresh_with_source_consumer_matches2048_native_cases(){
  use crate::audio_source_controls::{SourceBackend,tests::fixture as source_fixture};
  use crate::audio_pair_controls::{PairBackend,tests::fixture as pair_fixture};
  use crate::audio_priority_transition::{TransitionBackend,tests::fixture as transition_fixture};
  use crate::audio_actor_flag::{FlagBackend,tests::fixture as flag_fixture};
  use crate::audio_spatial_controls::{SpatialBackend,Pose,tests::{fixture as spatial_fixture,hex}};
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_source_refresh_contract.json")).unwrap();assert_eq!(proof["case_count"],2048);
  for (case,row) in proof["cases"].as_array().unwrap().iter().enumerate(){
   let (actor_nodes,mut manager)=fixture(row);let (spatial_nodes,spatial_manager,registry)=spatial_fixture(row);manager.bindings.extend(spatial_manager.bindings);let (flag_nodes,flag_manager)=flag_fixture(row,true);manager.bindings.extend(flag_manager.bindings);let (pair_nodes,pair_manager)=pair_fixture(row,true);manager.bindings.extend(pair_manager.bindings);let mut priority=transition_fixture(row,true);
   let mut s=state();s.block=[0xa5;84];s.extras=[0.;3];s.flags=[row["cflag"].as_u64().unwrap() as u8,0x5a,row["eflag"].as_u64().unwrap() as u8,0xa4,row["pflag"].as_u64().unwrap() as u8];s.owner=row["owner"].as_u64().unwrap() as u32;s.d4=1.25;s.d8=0.8;s.dc=0.5;s.pair=[0.,3.25];s.context=Some(6.5);s.pose=row["initial_pose"].as_str().map(|v|Pose {raw:hex(v)});
   let mut rng=NativeRandom::seeded(17);let mut dependencies=Dependencies {calls:vec![]};let mut actor=ActorBackend {dependencies:&mut dependencies,nodes:&actor_nodes,manager:&manager,rng:&mut rng,calls:vec![]};let mut spatial_backend=SpatialBackend {dependencies:&mut actor,nodes:&spatial_nodes,manager:&manager,registry:&registry,calls:vec![]};
   let mut flag_backend=FlagBackend {dependencies:&mut spatial_backend,nodes:&flag_nodes,manager:&manager,calls:vec![]};let mut pair_backend=PairBackend {dependencies:&mut flag_backend,nodes:&pair_nodes,manager:&manager,calls:vec![]};let mut backend=TransitionBackend {dependencies:&mut pair_backend,store:&mut priority,voice:row["priority_voice"].as_u64().unwrap() as u32,local:std::array::from_fn(|i|row["priority_local"][i].as_u64().map(|v|v as u32)),global:row["priority_global"].as_u64().unwrap() as u32,calls:vec![]};
   let (source_bindings,source_registry)=source_fixture(&row["source_entries"]);let mut source_backend=SourceBackend {dependencies:&mut backend,bindings:&source_bindings,source_reference:row["source_reference"].as_u64().unwrap() as u32,registry:&source_registry,calls:vec![]};
   s.refresh(&mut source_backend).unwrap();let source_calls=serde_json::to_value(&source_backend.calls).unwrap().as_array().unwrap().clone();drop(source_backend);let transition_calls=serde_json::to_value(&backend.calls).unwrap().as_array().unwrap().clone();let pair_calls=serde_json::to_value(&backend.dependencies.calls).unwrap().as_array().unwrap().clone();let flag_calls=serde_json::to_value(&backend.dependencies.dependencies.calls).unwrap().as_array().unwrap().clone();let spatial_calls=serde_json::to_value(&backend.dependencies.dependencies.dependencies.calls).unwrap().as_array().unwrap().clone();let actor_calls=serde_json::to_value(&backend.dependencies.dependencies.dependencies.dependencies.calls).unwrap().as_array().unwrap().clone();let dependency_calls=backend.dependencies.dependencies.dependencies.dependencies.dependencies.calls.clone();drop(backend);drop(pair_backend);drop(flag_backend);drop(spatial_backend);drop(actor);
   let block:String=s.block.iter().map(|b|format!("{b:02x}")).collect();assert_eq!(block,row["output_block"].as_str().unwrap(),"block {case}");assert_eq!(s.spatial.raw,hex(row["output_spatial"].as_str().unwrap()),"spatial {case}");assert_eq!(s.pose.as_ref().map(|p|p.raw),row["output_pose"].as_str().map(hex),"pose {case}");assert_eq!(serde_json::json!(s.flags),row["output_flags"],"flags {case}");assert_eq!(serde_json::json!([s.cc.to_bits(),s.d0.to_bits()]),row["output_cc_d0"],"cache {case}");assert_eq!(serde_json::json!(s.extras.map(f32::to_bits)),row["output_extras_bits"],"extras {case}");assert_eq!(rng.state() as u64,row["rng"].as_u64().unwrap(),"rng {case}");
   assert_eq!(serde_json::json!(s.pair.map(f32::to_bits)),row["output_pair_bits"],"pair {case}");assert_eq!(serde_json::json!(priority.voices[&(row["priority_voice"].as_u64().unwrap() as u32)].value.to_bits()),row["priority_output_bits"],"priority {case}");for g in row["priority_after"].as_array().unwrap(){assert_eq!(serde_json::json!(priority.groups[&(g["reference"].as_u64().unwrap() as u32)].voices),g["after"],"order {case}");}
   let calls:Vec<_>=spatial_calls.into_iter().chain(flag_calls).chain(source_calls).chain(dependency_calls).chain(actor_calls).chain(pair_calls).chain(transition_calls).collect();let expected:Vec<_>=row["calls"].as_array().unwrap().iter().filter(|v|!matches!(v["kind"].as_str(),Some("lock"|"unlock"))).collect();assert_eq!(serde_json::json!(calls),serde_json::json!(expected),"calls {case}");
  }
 }
 #[test] fn whole_refresh_with_routing_context_matches2048_native_cases(){
  use crate::audio_routing_context::{RoutingBackend,Voice,Context,InheritedConsumer,tests::SnapshotAllocator};
  use crate::audio_source_controls::{SourceBackend,tests::fixture as source_fixture};
  use crate::audio_pair_controls::{PairBackend,tests::fixture as pair_fixture};
  use crate::audio_priority_transition::{TransitionBackend,tests::fixture as transition_fixture};
  use crate::audio_actor_flag::{FlagBackend,tests::fixture as flag_fixture};
  use crate::audio_spatial_controls::{SpatialBackend,Pose,tests::{fixture as spatial_fixture,hex}};
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_routing_refresh_contract.json")).unwrap();assert_eq!(proof["case_count"],2048);
  for (case,row) in proof["cases"].as_array().unwrap().iter().enumerate(){
   let (actor_nodes,mut manager)=fixture(row);let (spatial_nodes,spatial_manager,registry)=spatial_fixture(row);manager.bindings.extend(spatial_manager.bindings);let (flag_nodes,flag_manager)=flag_fixture(row,true);manager.bindings.extend(flag_manager.bindings);let (pair_nodes,pair_manager)=pair_fixture(row,true);manager.bindings.extend(pair_manager.bindings);let mut priority=transition_fixture(row,true);
   let mut s=state();s.block=[0xa5;84];s.extras=[0.;3];s.flags=[row["cflag"].as_u64().unwrap() as u8,0x5a,row["eflag"].as_u64().unwrap() as u8,0xa4,row["pflag"].as_u64().unwrap() as u8];s.owner=row["owner"].as_u64().unwrap() as u32;s.d4=1.25;s.d8=0.8;s.dc=0.5;s.pair=[0.,3.25];s.context=if row["routing_mode"]==0 {Some(6.5)}else{None};s.pose=row["initial_pose"].as_str().map(|v|Pose {raw:hex(v)});
   let mut rng=NativeRandom::seeded(17);let mut dependencies=Dependencies {calls:vec![]};let mut actor=ActorBackend {dependencies:&mut dependencies,nodes:&actor_nodes,manager:&manager,rng:&mut rng,calls:vec![]};let mut spatial_backend=SpatialBackend {dependencies:&mut actor,nodes:&spatial_nodes,manager:&manager,registry:&registry,calls:vec![]};
   let mut flag_backend=FlagBackend {dependencies:&mut spatial_backend,nodes:&flag_nodes,manager:&manager,calls:vec![]};let mut pair_backend=PairBackend {dependencies:&mut flag_backend,nodes:&pair_nodes,manager:&manager,calls:vec![]};let mut backend=TransitionBackend {dependencies:&mut pair_backend,store:&mut priority,voice:row["priority_voice"].as_u64().unwrap() as u32,local:std::array::from_fn(|i|row["priority_local"][i].as_u64().map(|v|v as u32)),global:row["priority_global"].as_u64().unwrap() as u32,calls:vec![]};
   let (source_bindings,source_registry)=source_fixture(&row["source_entries"]);let mut source_backend=SourceBackend {dependencies:&mut backend,bindings:&source_bindings,source_reference:row["source_reference"].as_u64().unwrap() as u32,registry:&source_registry,calls:vec![]};
   let routing_mode=row["routing_mode"].as_u64().unwrap();let mut routing_voice=Voice {context:row["routing_initial_prefix"].as_str().map(|v|Context {reference:row["routing_context_reference"].as_u64().unwrap() as u32,raw:hex::<48>(v).to_vec()}),eligibility:None,mask:3,optional_mask:None,packed:5,source:row["source_reference"].as_u64().unwrap() as u32};
   let hierarchy:BTreeMap<u32,crate::audio_parameter_inheritance::Node>=actor_nodes.iter().enumerate().map(|(i,n)|(i as u32,crate::audio_parameter_inheritance::Node {reference:n.reference,parent:if i+1<actor_nodes.len(){Some(i as u32+1)}else{None},..Default::default()})).collect();let mut consumer=InheritedConsumer {nodes:&hierarchy,root:0,getter:|_,_,_|Err(crate::audio_parameter_inheritance::Error::InvalidControl)};let mut allocator=SnapshotAllocator {reference:row["routing_context_reference"].as_u64().unwrap() as u32,fail:routing_mode==3};let outputs=[1u32];let mut routing_backend=RoutingBackend {dependencies:&mut source_backend,voice:&mut routing_voice,outputs:if routing_mode==2 {None}else{Some(outputs.as_slice())},allocator:&mut allocator,consumer:&mut consumer,calls:vec![]};
   s.refresh(&mut routing_backend).unwrap();let routing_calls=serde_json::to_value(&routing_backend.calls).unwrap().as_array().unwrap().clone();drop(routing_backend);
   assert_eq!(routing_voice.context.as_ref().map_or(0,|v|v.reference) as u64,row["routing_output_reference"].as_u64().unwrap(),"routing reference {case}");assert_eq!(routing_voice.context.as_ref().map(|c|c.raw[..48].iter().map(|b|format!("{b:02x}")).collect::<String>()),row["routing_output_prefix"].as_str().map(str::to_owned),"routing prefix {case}");let source_calls=serde_json::to_value(&source_backend.calls).unwrap().as_array().unwrap().clone();drop(source_backend);let transition_calls=serde_json::to_value(&backend.calls).unwrap().as_array().unwrap().clone();let pair_calls=serde_json::to_value(&backend.dependencies.calls).unwrap().as_array().unwrap().clone();let flag_calls=serde_json::to_value(&backend.dependencies.dependencies.calls).unwrap().as_array().unwrap().clone();let spatial_calls=serde_json::to_value(&backend.dependencies.dependencies.dependencies.calls).unwrap().as_array().unwrap().clone();let actor_calls=serde_json::to_value(&backend.dependencies.dependencies.dependencies.dependencies.calls).unwrap().as_array().unwrap().clone();let dependency_calls=backend.dependencies.dependencies.dependencies.dependencies.dependencies.calls.clone();drop(backend);drop(pair_backend);drop(flag_backend);drop(spatial_backend);drop(actor);
   let block:String=s.block.iter().map(|b|format!("{b:02x}")).collect();assert_eq!(block,row["output_block"].as_str().unwrap(),"block {case}");assert_eq!(s.spatial.raw,hex(row["output_spatial"].as_str().unwrap()),"spatial {case}");assert_eq!(s.pose.as_ref().map(|p|p.raw),row["output_pose"].as_str().map(hex),"pose {case}");assert_eq!(serde_json::json!(s.flags),row["output_flags"],"flags {case}");assert_eq!(serde_json::json!([s.cc.to_bits(),s.d0.to_bits()]),row["output_cc_d0"],"cache {case}");assert_eq!(serde_json::json!(s.extras.map(f32::to_bits)),row["output_extras_bits"],"extras {case}");assert_eq!(rng.state() as u64,row["rng"].as_u64().unwrap(),"rng {case}");
   assert_eq!(serde_json::json!(s.pair.map(f32::to_bits)),row["output_pair_bits"],"pair {case}");assert_eq!(serde_json::json!(priority.voices[&(row["priority_voice"].as_u64().unwrap() as u32)].value.to_bits()),row["priority_output_bits"],"priority {case}");for g in row["priority_after"].as_array().unwrap(){assert_eq!(serde_json::json!(priority.groups[&(g["reference"].as_u64().unwrap() as u32)].voices),g["after"],"order {case}");}
   let calls:Vec<_>=spatial_calls.into_iter().chain(flag_calls).chain(source_calls).chain(routing_calls).chain(dependency_calls).chain(actor_calls).chain(pair_calls).chain(transition_calls).collect();let expected:Vec<_>=row["calls"].as_array().unwrap().iter().filter(|v|!matches!(v["kind"].as_str(),Some("lock"|"unlock"))).collect();assert_eq!(serde_json::json!(calls),serde_json::json!(expected),"calls {case}");
  }
 }
 fn compare_shared_rng_refresh(proof:&str,actual_bus:bool){
  use crate::audio_routing_context::{ActorRoutingBackend,Voice,Context,tests::SnapshotAllocator};
  use crate::audio_source_controls::{SourceBackend,tests::fixture as source_fixture};
  use crate::audio_pair_controls::{PairBackend,tests::fixture as pair_fixture};
  use crate::audio_priority_transition::{TransitionBackend,tests::fixture as transition_fixture};
  use crate::audio_actor_flag::{FlagBackend,tests::fixture as flag_fixture};
  use crate::audio_spatial_controls::{SpatialBackend,Pose,tests::{fixture as spatial_fixture,hex}};
  let proof:serde_json::Value=serde_json::from_str(proof).unwrap();assert_eq!(proof["case_count"],2048);
  for (case,row) in proof["cases"].as_array().unwrap().iter().enumerate(){
   let (mut actor_nodes,mut manager)=fixture(row);let (spatial_nodes,spatial_manager,registry)=spatial_fixture(row);manager.bindings.extend(spatial_manager.bindings);let (flag_nodes,flag_manager)=flag_fixture(row,true);manager.bindings.extend(flag_manager.bindings);let (pair_nodes,pair_manager)=pair_fixture(row,true);manager.bindings.extend(pair_manager.bindings);let mut priority=transition_fixture(row,true);
   let mut s=state();s.block=[0xa5;84];s.extras=[0.;3];s.flags=[row["cflag"].as_u64().unwrap() as u8,0x5a,row["eflag"].as_u64().unwrap() as u8,0xa4,row["pflag"].as_u64().unwrap() as u8];s.owner=row["owner"].as_u64().unwrap() as u32;s.d4=1.25;s.d8=0.8;s.dc=0.5;s.pair=[0.,3.25];s.context=if row["routing_mode"]==0 {Some(6.5)}else{None};s.pose=row["initial_pose"].as_str().map(|v|Pose {raw:hex(v)});
   let routing_mode=row["routing_mode"].as_u64().unwrap();let mut routing_voice=Voice {context:row["routing_initial_prefix"].as_str().map(|v|Context {reference:row["routing_context_reference"].as_u64().unwrap() as u32,raw:hex::<48>(v).to_vec()}),eligibility:Some(row["routing_graph"][actor_nodes.len()]["reference"].as_u64().unwrap() as u32),mask:3,optional_mask:None,packed:5,source:row["source_reference"].as_u64().unwrap() as u32};
   let hierarchy:BTreeMap<u32,crate::audio_parameter_inheritance::Node>=row["routing_graph"].as_array().unwrap().iter().map(|n|{let id=n["id"].as_u64().unwrap() as u32;(id,crate::audio_parameter_inheritance::Node{class:if n["class"]=="bus"{crate::audio_parameter_getters::Class::Bus}else{crate::audio_parameter_getters::Class::Sound},bus_link:n["bus_link"].as_u64().map(|v|v as u32),property0:n["property0"].as_f64().map(|v|v as f32),reference:n["reference"].as_u64().unwrap() as u32,parent:n["parent"].as_u64().map(|v|v as u32),bus_override:n["bus_override"].as_u64().map(|v|crate::audio_parameter_inheritance::BusOverride{node:v as u32,local_slot4:0.,local_slot_c:0.}),static_property8:n["static8"].as_f64().map(|v|v as f32),object_property8:n["object8"].as_f64().map(|v|BTreeMap::from([(77,v as f32)])).unwrap_or_default(),..Default::default()})}).collect();
   let inputs:BTreeMap<_,_>=[(8,0x110,-31.),(9,0x114,40.)].into_iter().map(|(p,slot,v)|((0,slot),crate::audio_parameter_getters::Input{static_value:Some(v),rtpc_enabled:row["nodes"][0]["rtpc"].as_bool().unwrap(),range:Some(crate::audio_parameter_getters::Range{min:row["routing_ranges"][p.to_string()][0].as_f64().unwrap() as f32,max:row["routing_ranges"][p.to_string()][1].as_f64().unwrap() as f32})})).collect();
   for (p,begin) in [(29,-2.5),(30,5.)]{manager.bindings.insert((actor_nodes[0].reference,p),vec![crate::audio_rtpc_manager::RouteCurve{rtpc:100,curve:crate::audio_curves::Curve{scaling:0,points:vec![crate::audio_curves::Point{from:0.,to:begin,interp:4},crate::audio_curves::Point{from:100.,to:begin+10.,interp:4}]}}]);}
   let bus_bindings=if actual_bus{actor_nodes[0].bus=true;let (nodes,bus_manager)=crate::audio_bus_controls::tests::fixture(&serde_json::json!({"nodes":row["bus_nodes"]}));manager.bindings.extend(bus_manager.bindings);Some(BusBindings::from([(0,BusBinding{nodes,trace_base:3})]))}else{None};
   let mut allocator=SnapshotAllocator {reference:row["routing_context_reference"].as_u64().unwrap() as u32,fail:routing_mode==3};let outputs=[1u32];let mut rng=NativeRandom::seeded(17);let mut dependencies=Dependencies {calls:vec![]};let mut actor=ActorRoutingBackend {dependencies:&mut dependencies,nodes:&actor_nodes,bus_bindings:bus_bindings.as_ref(),hierarchy:&hierarchy,root:0,inputs:&inputs,manager:&manager,rng:&mut rng,voice:&mut routing_voice,outputs:if routing_mode==2 {None}else{Some(outputs.as_slice())},allocator:&mut allocator,actor_calls:vec![],routing_calls:vec![]};let mut spatial_backend=SpatialBackend {dependencies:&mut actor,nodes:&spatial_nodes,manager:&manager,registry:&registry,calls:vec![]};
   let mut flag_backend=FlagBackend {dependencies:&mut spatial_backend,nodes:&flag_nodes,manager:&manager,calls:vec![]};let mut pair_backend=PairBackend {dependencies:&mut flag_backend,nodes:&pair_nodes,manager:&manager,calls:vec![]};let mut backend=TransitionBackend {dependencies:&mut pair_backend,store:&mut priority,voice:row["priority_voice"].as_u64().unwrap() as u32,local:std::array::from_fn(|i|row["priority_local"][i].as_u64().map(|v|v as u32)),global:row["priority_global"].as_u64().unwrap() as u32,calls:vec![]};
   let (source_bindings,source_registry)=source_fixture(&row["source_entries"]);let mut source_backend=SourceBackend {dependencies:&mut backend,bindings:&source_bindings,source_reference:row["source_reference"].as_u64().unwrap() as u32,registry:&source_registry,calls:vec![]};
   s.refresh(&mut source_backend).unwrap();
let source_calls=serde_json::to_value(&source_backend.calls).unwrap().as_array().unwrap().clone();drop(source_backend);let transition_calls=serde_json::to_value(&backend.calls).unwrap().as_array().unwrap().clone();let pair_calls=serde_json::to_value(&backend.dependencies.calls).unwrap().as_array().unwrap().clone();let flag_calls=serde_json::to_value(&backend.dependencies.dependencies.calls).unwrap().as_array().unwrap().clone();let spatial_calls=serde_json::to_value(&backend.dependencies.dependencies.dependencies.calls).unwrap().as_array().unwrap().clone();let routing_calls=serde_json::to_value(&backend.dependencies.dependencies.dependencies.dependencies.routing_calls).unwrap().as_array().unwrap().clone();let actor_calls=serde_json::to_value(&backend.dependencies.dependencies.dependencies.dependencies.actor_calls).unwrap().as_array().unwrap().clone();let dependency_calls=backend.dependencies.dependencies.dependencies.dependencies.dependencies.calls.clone();drop(backend);drop(pair_backend);drop(flag_backend);drop(spatial_backend);drop(actor);
   assert_eq!(routing_voice.context.as_ref().map_or(0,|v|v.reference) as u64,row["routing_output_reference"].as_u64().unwrap(),"routing reference {case}");assert_eq!(routing_voice.context.as_ref().map(|c|c.raw[..48].iter().map(|b|format!("{b:02x}")).collect::<String>()),row["routing_output_prefix"].as_str().map(str::to_owned),"routing prefix {case}");
   let block:String=s.block.iter().map(|b|format!("{b:02x}")).collect();assert_eq!(block,row["output_block"].as_str().unwrap(),"block {case}");assert_eq!(s.spatial.raw,hex(row["output_spatial"].as_str().unwrap()),"spatial {case}");assert_eq!(s.pose.as_ref().map(|p|p.raw),row["output_pose"].as_str().map(hex),"pose {case}");assert_eq!(serde_json::json!(s.flags),row["output_flags"],"flags {case}");assert_eq!(serde_json::json!([s.cc.to_bits(),s.d0.to_bits()]),row["output_cc_d0"],"cache {case}");assert_eq!(serde_json::json!(s.extras.map(f32::to_bits)),row["output_extras_bits"],"extras {case}");assert_eq!(rng.state() as u64,row["rng"].as_u64().unwrap(),"rng {case}");
   assert_eq!(serde_json::json!(s.pair.map(f32::to_bits)),row["output_pair_bits"],"pair {case}");assert_eq!(serde_json::json!(priority.voices[&(row["priority_voice"].as_u64().unwrap() as u32)].value.to_bits()),row["priority_output_bits"],"priority {case}");for g in row["priority_after"].as_array().unwrap(){assert_eq!(serde_json::json!(priority.groups[&(g["reference"].as_u64().unwrap() as u32)].voices),g["after"],"order {case}");}
   let calls:Vec<_>=spatial_calls.into_iter().chain(flag_calls).chain(source_calls).chain(routing_calls).chain(dependency_calls).chain(actor_calls).chain(pair_calls).chain(transition_calls).collect();let expected:Vec<_>=row["calls"].as_array().unwrap().iter().filter(|v|!matches!(v["kind"].as_str(),Some("lock"|"unlock"))).collect();assert_eq!(serde_json::json!(calls),serde_json::json!(expected),"calls {case}");
  }
 }
 #[test] fn whole_refresh_routing_and_actor_share_native_rng_in2048_cases(){compare_shared_rng_refresh({
            static FIXTURE: std::sync::OnceLock<String> = std::sync::OnceLock::new();
            FIXTURE.get_or_init(|| {
                const PATH: &str = concat!(env!("CARGO_MANIFEST_DIR"), "/../../data/4.20/audio_shared_rng_refresh_contract.json");
                let text = std::fs::read_to_string(PATH)
                    .unwrap_or_else(|error| panic!("cannot read frozen test fixture {PATH}: {error}"));
                assert_eq!(text.len(), 20656082, "frozen test fixture byte length: {PATH}");
                text
            }).as_str()
        },false);}
 #[test] fn audio_whole_actual_bus_routing_actor_and_shared_rng_match2048_native_cases(){compare_shared_rng_refresh({
            static FIXTURE: std::sync::OnceLock<String> = std::sync::OnceLock::new();
            FIXTURE.get_or_init(|| {
                const PATH: &str = concat!(env!("CARGO_MANIFEST_DIR"), "/../../data/4.20/audio_bus_shared_rng_refresh_contract.json");
                let text = std::fs::read_to_string(PATH)
                    .unwrap_or_else(|error| panic!("cannot read frozen test fixture {PATH}: {error}"));
                assert_eq!(text.len(), 23548126, "frozen test fixture byte length: {PATH}");
                text
            }).as_str()
        },true);}
 #[test] fn audio_actor_bus_recursion_and_local_controls_match1536_native_cases(){let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_actor_bus_composition_contract.json")).unwrap();assert_eq!(proof["case_count"],1536);for (case,row) in proof["cases"].as_array().unwrap().iter().enumerate(){
  let (mut nodes,mut manager)=fixture(row);let selected=row["bus_index"].as_u64().unwrap() as usize;nodes[selected].bus=true;for (i,n) in nodes.iter_mut().enumerate(){if n.rtpc_mask!=0{n.rtpc_mask|=(1<<22)|(1<<23);for p in [22,23]{let begin=p as f32*0.125+i as f32*2.;manager.bindings.insert((n.reference,p),vec![crate::audio_rtpc_manager::RouteCurve{rtpc:100,curve:crate::audio_curves::Curve{scaling:0,points:vec![crate::audio_curves::Point{from:0.,to:begin,interp:4},crate::audio_curves::Point{from:100.,to:begin+10.,interp:4}]}}]);}}}
  let (bus_nodes,bus_manager)=crate::audio_bus_controls::tests::fixture(&serde_json::json!({"nodes":row["bus_nodes"]}));manager.bindings.extend(bus_manager.bindings);let bindings=BusBindings::from([(selected,BusBinding{nodes:bus_nodes,trace_base:100})]);let mut s=state();let mut rng=NativeRandom::seeded(17);let calls=apply_with_bus(&nodes,&bindings,&mut s,Request{mask:row["mask"].as_u64().unwrap() as u32,first:row["first"].as_u64().unwrap() as u32,owner:row["owner"].as_u64().unwrap() as u32,last:row["last"].as_u64().unwrap() as u32},&manager,&mut rng).unwrap();assert_eq!(s.block,crate::audio_spatial_controls::tests::hex::<84>(row["output_block"].as_str().unwrap()),"block {case}");assert_eq!(serde_json::json!(s.extras.map(f32::to_bits)),row["output_extras_bits"],"extras {case}");assert_eq!(rng.state() as u64,row["rng"].as_u64().unwrap(),"RNG {case}");assert_eq!(serde_json::json!(calls),row["calls"],"trace {case}");
 }}
 #[test] fn audio_actor_bus_state_gain_mutation_matches1024_native_cases(){let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_actor_bus_state_gain_contract.json")).unwrap();assert_eq!(proof["case_count"],1024);for (case,row) in proof["cases"].as_array().unwrap().iter().enumerate(){
  let (mut nodes,mut manager)=fixture(row);let selected=row["bus_index"].as_u64().unwrap() as usize;nodes[selected].bus=true;for (i,n) in nodes.iter_mut().enumerate(){if n.rtpc_mask!=0{n.rtpc_mask|=(1<<22)|(1<<23);for p in [22,23]{let begin=p as f32*0.125+i as f32*2.;manager.bindings.insert((n.reference,p),vec![crate::audio_rtpc_manager::RouteCurve{rtpc:100,curve:crate::audio_curves::Curve{scaling:0,points:vec![crate::audio_curves::Point{from:0.,to:begin,interp:4},crate::audio_curves::Point{from:100.,to:begin+10.,interp:4}]}}]);}}}
  let (mut bus_nodes,bus_manager)=crate::audio_bus_controls::tests::fixture(&serde_json::json!({"nodes":row["bus_nodes"]}));manager.bindings.extend(bus_manager.bindings);
  for n in &mut nodes {n.gain_flags=Some([1,0]);}for n in &mut bus_nodes {n.gain_flags=Some(1);}
  for call in row["calls"].as_array().unwrap().iter().filter(|c|c["kind"]=="gain") {let index=call["node"].as_u64().unwrap() as usize;let flags=call["flags"].as_u64().unwrap() as u32;if index>=100{bus_nodes[index-100].gain_flags=Some(flags);}else{let kind=if flags&1==1{0}else{1};let pair=nodes[index].gain_flags.get_or_insert([1,0]);pair[kind]=flags;}}
  let bindings=BusBindings::from([(selected,BusBinding{nodes:bus_nodes,trace_base:100})]);let mut s=state();s.entries=row["before_gains"].as_array().unwrap().iter().map(|e|crate::audio_control_refresh::Entry{id:e["id"].as_u64().unwrap() as u32,flags:e["flags"].as_u64().unwrap() as u32,gain:f32::from_bits(e["gain_bits"].as_u64().unwrap() as u32)}).collect();let mut rng=NativeRandom::seeded(17);let calls=apply_with_bus(&nodes,&bindings,&mut s,Request{mask:row["mask"].as_u64().unwrap() as u32,first:row["first"].as_u64().unwrap() as u32,owner:row["owner"].as_u64().unwrap() as u32,last:row["last"].as_u64().unwrap() as u32},&manager,&mut rng).unwrap();assert_eq!(s.block,crate::audio_spatial_controls::tests::hex::<84>(row["output_block"].as_str().unwrap()),"block {case}");assert_eq!(serde_json::json!(s.extras.map(f32::to_bits)),row["output_extras_bits"],"extras {case}");assert_eq!(rng.state() as u64,row["rng"].as_u64().unwrap(),"RNG {case}");assert_eq!(serde_json::json!(calls),row["calls"],"trace {case}");let entries:Vec<_>=s.entries.iter().map(|e|serde_json::json!({"id":e.id,"flags":e.flags,"gain_bits":e.gain.to_bits()})).collect();assert_eq!(serde_json::json!(entries),row["after_gains"],"gains {case}");
 }}
 #[test] fn audio_whole_state_gain_refresh_matches512_native_cases(){let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_state_gain_refresh_contract.json")).unwrap();assert_eq!(proof["case_count"],512);for (case,row) in proof["cases"].as_array().unwrap().iter().enumerate(){
  let (mut nodes,mut manager)=fixture(row);let selected=row["bus_index"].as_u64().unwrap() as usize;nodes[selected].bus=true;for (i,n) in nodes.iter_mut().enumerate(){if n.rtpc_mask!=0{n.rtpc_mask|=(1<<22)|(1<<23);for p in [22,23]{let begin=p as f32*0.125+i as f32*2.;manager.bindings.insert((n.reference,p),vec![crate::audio_rtpc_manager::RouteCurve{rtpc:100,curve:crate::audio_curves::Curve{scaling:0,points:vec![crate::audio_curves::Point{from:0.,to:begin,interp:4},crate::audio_curves::Point{from:100.,to:begin+10.,interp:4}]}}]);}}}
  let (mut bus_nodes,bus_manager)=crate::audio_bus_controls::tests::fixture(&serde_json::json!({"nodes":row["bus_nodes"]}));manager.bindings.extend(bus_manager.bindings);
  for n in &mut nodes {n.gain_flags=Some([1,0]);}for n in &mut bus_nodes {n.gain_flags=Some(1);}
  for call in row["calls"].as_array().unwrap().iter().filter(|c|c["kind"]=="gain") {let index=call["node"].as_u64().unwrap() as usize;let flags=call["flags"].as_u64().unwrap() as u32;if index>=100{bus_nodes[index-100].gain_flags=Some(flags);}else{let kind=if flags&1==1{0}else{1};let pair=nodes[index].gain_flags.get_or_insert([1,0]);pair[kind]=flags;}}
  let bindings=BusBindings::from([(selected,BusBinding{nodes:bus_nodes,trace_base:100})]);let mut s=state();s.entries=row["before_gains"].as_array().unwrap().iter().map(|e|crate::audio_control_refresh::Entry{id:e["id"].as_u64().unwrap() as u32,flags:e["flags"].as_u64().unwrap() as u32,gain:f32::from_bits(e["gain_bits"].as_u64().unwrap() as u32)}).collect();let mut rng=NativeRandom::seeded(17);s.block=[0xa5;84];s.extras=[0.;3];s.flags=[if row["first"]==1{0}else{0x80},0x5a,0,0xa4,0];s.owner=row["owner"].as_u64().unwrap() as u32;s.d4=1.25;s.d8=0.8;s.dc=0.5;s.pair=[0.,3.25];
  struct QualifiedInterfaces<'a>{nodes:&'a[Node],bindings:&'a BusBindings,manager:&'a Manager,rng:&'a mut NativeRandom,calls:Vec<GraphCall>}
  impl Backend for QualifiedInterfaces<'_>{
   fn spatial(&mut self,_:&mut State)->Result<(),crate::audio_control_refresh::Error>{Ok(())}
   fn optional(&mut self)->Result<(),crate::audio_control_refresh::Error>{panic!("optional native branch absent")}
   fn flag(&mut self,_:u32)->Result<u8,crate::audio_control_refresh::Error>{Ok(0)}
   fn source(&mut self)->Result<f32,crate::audio_control_refresh::Error>{panic!("source native branch absent")}
   fn routing(&mut self,_:&mut State)->Result<(),crate::audio_control_refresh::Error>{panic!("routing native branch absent")}
   fn parameters(&mut self,s:&mut State,r:Request)->Result<(),crate::audio_control_refresh::Error>{self.calls=apply_with_bus(self.nodes,self.bindings,s,r,self.manager,self.rng).map_err(|_|crate::audio_control_refresh::Error::Backend("state gain controls failed"))?;Ok(())}
   fn pair(&mut self,_:u32)->Result<[f32;2],crate::audio_control_refresh::Error>{Ok([0.,3.25])}
   fn transition(&mut self,_:f32)->Result<(),crate::audio_control_refresh::Error>{panic!("unchanged pair must not transition")}
  }
  let mut backend=QualifiedInterfaces{nodes:&nodes,bindings:&bindings,manager:&manager,rng:&mut rng,calls:vec![]};s.refresh(&mut backend).unwrap();let calls=std::mem::take(&mut backend.calls);drop(backend);
  assert_eq!(serde_json::json!(s.flags),row["output_flags"],"flags {case}");assert_eq!(serde_json::json!([s.cc.to_bits(),s.d0.to_bits()]),row["output_cc_d0"],"cache {case}");assert_eq!(serde_json::json!(s.pair.map(f32::to_bits)),row["output_pair_bits"],"pair {case}");assert_eq!(s.block,crate::audio_spatial_controls::tests::hex::<84>(row["output_block"].as_str().unwrap()),"block {case}");assert_eq!(serde_json::json!(s.extras.map(f32::to_bits)),row["output_extras_bits"],"extras {case}");assert_eq!(rng.state() as u64,row["rng"].as_u64().unwrap(),"RNG {case}");assert_eq!(serde_json::json!(calls),row["calls"],"trace {case}");let entries:Vec<_>=s.entries.iter().map(|e|serde_json::json!({"id":e.id,"flags":e.flags,"gain_bits":e.gain.to_bits()})).collect();assert_eq!(serde_json::json!(entries),row["after_gains"],"gains {case}");
 }}
 #[test] fn audio_unresolved_actor_bus_bindings_fail_before_controls_or_draws(){let mut s=state();let before=s.block;let mut rng=NativeRandom::seeded(17);let m=Manager::default();let req=Request{mask:u32::MAX,first:1,owner:77,last:1};let nodes=[Node{bus:true,..Default::default()}];assert!(matches!(apply_with_bus(&nodes,&BusBindings::new(),&mut s,req,&m,&mut rng),Err(Error::MissingBus(0))));assert_eq!(s.block,before);assert_eq!(rng.state(),17);let bindings=BusBindings::from([(0,BusBinding{nodes:vec![crate::audio_bus_controls::Node::default()],trace_base:100})]);assert!(matches!(apply_with_bus(&[Node::default()],&bindings,&mut s,req,&m,&mut rng),Err(Error::UnexpectedBus(0))));assert_eq!(s.block,before);}

}
