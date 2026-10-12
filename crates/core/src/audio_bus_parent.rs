//! Verified Bus B023C0/B02540 attachment, AE0A80 search/insertion and kind propagation.
use crate::audio_bus_registry::Bus;
use std::collections::{BTreeMap,BTreeSet};
#[derive(Debug,Clone)] pub struct Node{pub bus:Bus,pub children:[Vec<u32>;2]}
#[derive(Debug,Default)] pub struct Graph{pub nodes:BTreeMap<u32,Node>}
#[derive(Debug,PartialEq,Eq)] pub enum Error{MissingNode(u32),WrongClass,MalformedList,CyclicGraph,Backend(&'static str)}
#[derive(Debug,Clone,Copy)] pub struct Reservation{pub reference:u32,pub capacity:u32}
pub trait Backend{
 fn reserve(&mut self,parent:u32,selector:u8,required:u32)->Result<Option<Reservation>,Error>;
 fn retain(&mut self,node:u32)->Result<(),Error>;
 fn release(&mut self,node:u32)->Result<(),Error>;
}
#[derive(Debug,Clone,serde::Serialize)] #[serde(tag="kind",rename_all="snake_case")]
pub enum Call{Reserve{selector:u8},Link{child:u32,parent:u32},InheritKind{node:u32,kind_value:u8},Retain{node:u32},Release{node:u32}}
#[derive(Debug)] pub struct ResultInfo{pub status:u32,pub calls:Vec<Call>}
fn validate(graph:&Graph)->Result<(),Error>{
 fn walk(graph:&Graph,id:u32,active:&mut BTreeSet<u32>,done:&mut BTreeSet<u32>)->Result<(),Error>{if done.contains(&id){return Ok(());}if !active.insert(id){return Err(Error::CyclicGraph);}let n=graph.nodes.get(&id).ok_or(Error::MissingNode(id))?;for children in &n.children{for child in children{walk(graph,*child,active,done)?;}}active.remove(&id);done.insert(id);Ok(())}
 for (&id,n) in &graph.nodes{if id==0 || n.bus.reference!=id{return Err(Error::MissingNode(id));}if n.bus.word(0)!=0xff1380{return Err(Error::WrongClass);}for (selector,list) in n.children.iter().enumerate(){let o=0x40+selector*16;if n.bus.word(o+4) as usize!=list.len() || (!list.is_empty() && n.bus.word(o)==0){return Err(Error::MalformedList);}for &r in list{if !graph.nodes.contains_key(&r){return Err(Error::MissingNode(r));}}}}
 let mut active=BTreeSet::new();let mut done=BTreeSet::new();for id in graph.nodes.keys(){walk(graph,*id,&mut active,&mut done)?;}Ok(())
}
fn search(graph:&Graph,list:&[u32],id:u32)->Result<(usize,bool),Error>{let mut lo=0isize;let mut hi=list.len() as isize-1;while lo<=hi{let mid=lo+(hi-lo)/2;let key=graph.nodes.get(&list[mid as usize]).ok_or(Error::MissingNode(list[mid as usize]))?.bus.word(8);if id<key{hi=mid-1;}else if id>key{lo=mid+1;}else{return Ok((mid as usize,true));}}Ok((lo as usize,false))}
fn descendant(graph:&Graph,start:u32,target:u32)->bool{let n=&graph.nodes[&start];n.children.iter().flatten().any(|r|*r==target || descendant(graph,*r,target))}
fn propagate(graph:&mut Graph,id:u32,value:u8,calls:&mut Vec<Call>){calls.push(Call::InheritKind{node:id,kind_value:value});let n=graph.nodes.get_mut(&id).expect("validated descendant");n.bus.raw[0xc4]=(n.bus.raw[0xc4]&0x7f)|(value<<7);let children=n.children[1].clone();for child in children{propagate(graph,child,value,calls);}}
pub fn attach(graph:&mut Graph,parent:u32,child:u32,backend:&mut impl Backend)->Result<ResultInfo,Error>{
 validate(graph)?;let p=graph.nodes.get(&parent).ok_or(Error::MissingNode(parent))?;let c=graph.nodes.get(&child).ok_or(Error::MissingNode(child))?;
 let selector=(c.bus.raw[0x2f]>>1)&1;let child_id=c.bus.word(8);let (index,found)=search(graph,&p.children[usize::from(selector)],child_id)?;
 let mut status=if c.bus.word(0x24)!=0{21}else if found{5}else if selector!=0 && p.bus.word(8)==child_id{23}else{1};let mut calls=Vec::new();
 if status==1{if parent==child || descendant(graph,child,parent){return Err(Error::CyclicGraph);}let o=0x40+usize::from(selector)*16;let len=p.children[usize::from(selector)].len() as u32;let capacity=p.bus.word(o+8);
  if len>=capacity{calls.push(Call::Reserve{selector});match backend.reserve(parent,selector,len.saturating_add(1))?{Some(r)=>{let n=graph.nodes.get_mut(&parent).unwrap();n.bus.set_word(o,r.reference);n.bus.set_word(o+8,r.capacity);if r.reference==0 || len>=r.capacity{status=2;}},None=>status=2}}
  if status==1{let n=graph.nodes.get_mut(&parent).unwrap();if n.children[usize::from(selector)].try_reserve(1).is_err(){status=2;}else{n.children[usize::from(selector)].insert(index,child);n.bus.set_word(o+4,len+1);}}
  if status==1{calls.push(Call::Link{child,parent});let parent_kind=graph.nodes[&parent].bus.raw[0xc4]>>7;let n=graph.nodes.get_mut(&child).unwrap();n.bus.set_word(0x24,parent);let child_kind=n.bus.raw[0xc4]>>7;if child_kind!=parent_kind{propagate(graph,child,parent_kind,&mut calls);}calls.push(Call::Retain{node:parent});backend.retain(parent)?;}
 }
 calls.push(Call::Release{node:child});backend.release(child)?;Ok(ResultInfo{status,calls})
}
/// Connect qualified attachment to the bank's actual mutable child object.
/// Graph contents and lifetime/reservation operations must be supplied by the caller.
pub struct BankBackend<'a,B,P>{pub dependencies:&'a mut B,pub graph:&'a mut Graph,pub operations:&'a mut P,pub attachments:Vec<ResultInfo>}
impl<B:crate::audio_bus_bank::Backend,P:Backend> crate::audio_bus_bank::Backend for BankBackend<'_,B,P>{
 fn lookup(&mut self,id:u32,s:u32)->Result<Option<u32>,crate::audio_bus_bank::Error>{self.dependencies.lookup(id,s)}
 fn retain(&mut self,n:u32)->Result<(),crate::audio_bus_bank::Error>{self.dependencies.retain(n)}
 fn release(&mut self,n:u32)->Result<(),crate::audio_bus_bank::Error>{self.dependencies.release(n)}
 fn allocate_control(&mut self,size:u32)->Result<Option<u32>,crate::audio_bus_bank::Error>{self.dependencies.allocate_control(size)}
 fn stage(&mut self,s:crate::audio_bus_bank::Stage,b:&mut Bus,c:&mut crate::audio_bus_bank::Cursor<'_>)->Result<u32,crate::audio_bus_bank::Error>{self.dependencies.stage(s,b,c)}
 fn attach(&mut self,parent:u32,child:&mut Bus)->Result<u32,crate::audio_bus_bank::Error>{
  let id=child.reference;
  let node=self.graph.nodes.get_mut(&id).ok_or(crate::audio_bus_bank::Error::Parent(Error::MissingNode(id)))?;
  node.bus=child.clone();
  let result=attach(self.graph,parent,id,self.operations);
  *child=self.graph.nodes[&id].bus.clone();
  let out=result.map_err(crate::audio_bus_bank::Error::Parent)?;let status=out.status;self.attachments.push(out);Ok(status)
 }
}
#[cfg(test)] mod tests{
 use super::*;
 struct Snapshot{failure:bool}
 impl Backend for Snapshot{fn reserve(&mut self,_:u32,s:u8,_:u32)->Result<Option<Reservation>,Error>{Ok(if self.failure{None}else{Some(Reservation{reference:0x30005000+u32::from(s)*0x100,capacity:4})})}fn retain(&mut self,_:u32)->Result<(),Error>{Ok(())}fn release(&mut self,_:u32)->Result<(),Error>{Ok(())}}
 fn node(reference:u32,id:u32)->Node{let mut bus=Bus{reference,raw:[0;200]};bus.set_word(0,0xff1380);bus.set_word(8,id);Node{bus,children:[vec![],vec![]]}}
 #[test] fn audio_bus_parent_attachment_matches5120_native_cases(){let p:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_bus_parent_attachment_contract.json")).unwrap();assert_eq!(p["case_count"],5120);for (case,row) in p["cases"].as_array().unwrap().iter().enumerate(){let mut graph=Graph::default();for (r,id) in [(0x30001000,row["parent_id"].as_u64().unwrap() as u32),(0x30002000,row["child_id"].as_u64().unwrap() as u32),(0x30006000,101),(0x30006100,303),(0x30006500,0),(0x30006600,0)]{graph.nodes.insert(r,node(r,id));}let parent=graph.nodes.get_mut(&0x30001000).unwrap();parent.bus.raw=crate::audio_spatial_controls::tests::hex(row["before_parent"].as_str().unwrap());if row["populated"]==true{parent.children=[vec![0x30006000,0x30006100],vec![0x30006000,0x30006100]];}let child=graph.nodes.get_mut(&0x30002000).unwrap();child.bus.raw=crate::audio_spatial_controls::tests::hex(row["before_child"].as_str().unwrap());let depth=row["depth"].as_u64().unwrap() as usize;child.children[1]=[0x30006500,0x30006600][..depth].to_vec();for r in [0x30006500,0x30006600]{graph.nodes.get_mut(&r).unwrap().bus.raw[0xc4]=0x25|row["child_kind"].as_u64().unwrap() as u8;}let mut backend=Snapshot{failure:row["reserve_failure"].as_bool().unwrap()};let out=attach(&mut graph,0x30001000,0x30002000,&mut backend).unwrap();assert_eq!(u64::from(out.status),row["result"].as_u64().unwrap(),"status {case}");assert_eq!(serde_json::json!(out.calls),row["calls"],"trace {case}");assert_eq!(graph.nodes[&0x30001000].bus.raw,crate::audio_spatial_controls::tests::hex::<200>(row["after_parent"].as_str().unwrap()),"parent {case}");assert_eq!(graph.nodes[&0x30002000].bus.raw,crate::audio_spatial_controls::tests::hex::<200>(row["after_child"].as_str().unwrap()),"child {case}");assert_eq!(serde_json::json!(graph.nodes[&0x30001000].children),row["lists"],"lists {case}");let flags:Vec<_>=[0x30006500,0x30006600][..depth].iter().map(|r|graph.nodes[r].bus.raw[0xc4]).collect();assert_eq!(serde_json::json!(flags),row["desc_flags"],"kind {case}");}}
 #[test] fn audio_bus_parent_cycle_fails_before_callbacks(){let mut graph=Graph::default();let mut parent=node(1,10);parent.children[1]=vec![1];parent.bus.set_word(0x50,5);parent.bus.set_word(0x54,1);graph.nodes.insert(1,parent);graph.nodes.insert(2,node(2,20));assert!(matches!(attach(&mut graph,1,2,&mut Snapshot{failure:false}),Err(Error::CyclicGraph)));assert_eq!(graph.nodes[&2].bus.word(0x24),0);}
}
