//! Native AEEF20 cleanup and AECE30 registration release. Downstream source
//! and ownership operations are required services, not implicit no-ops.
use std::collections::{BTreeMap,BTreeSet};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};
fn word(b:&[u8],o:usize)->u32{u32::from_le_bytes(b[o..o+4].try_into().unwrap())}
fn set(b:&mut[u8],o:usize,v:u32){b[o..o+4].copy_from_slice(&v.to_le_bytes());}
#[derive(Clone,Copy,Debug,PartialEq,Eq)]pub enum Call{EffectStop,RemoveRegistration,RemoveBinding,ReleaseOwner,ReleaseQuery,DestroySecondary,LookupSourceProperty,ApplySourceProperty,RemoveSourceVoice,ReleaseInput,ReleaseStream,ReleaseCache,DestroyInput,SourceVirtual08,SourceVirtual8c,SourceDestructor}
pub struct Runtime{pub pool:u32,pub binding_manager:u32,pub owner_manager:u32,pub query_manager:u32,pub source_manager:u32,pub global_registry:u32,pub registration_scratch:[u8;24],pub memory:BTreeMap<u32,Memory>,pub retired:BTreeSet<u32>}
pub trait Services{
 fn observe_call(&mut self,_kind:Call,_receiver:u32,_arguments:&[u32],_payload:Option<&[u8]>,_voice:&Memory,_context:&Runtime){}
 fn call(&mut self,kind:Call,receiver:u32,arguments:&[u32],payload:Option<&[u8]>,voice:&mut Memory,context:&mut Runtime)->Result<u32,Error>;
 /// Mutable source payload is borrowed from the current registration frame.
 /// Legacy controlled services delegate to call; native dispatchers override it.
 fn call_source_virtual8c(&mut self,receiver:u32,payload:&mut[u8],voice:&mut Memory,context:&mut Runtime)->Result<u32,Error>{self.call(Call::SourceVirtual8c,receiver,&[],Some(payload),voice,context)}
 fn free(&mut self,pool:u32,reference:u32,voice:&mut Memory,context:&mut Runtime)->Result<(),Error>;
}
impl Runtime{
 fn read(&self,r:u32,n:usize)->Result<&[u8],Error>{if self.retired.iter().any(|base|r>=*base&&self.memory.get(base).map(|m|r.wrapping_sub(*base)<m.raw.len()as u32).unwrap_or(r==*base)){return Err(Error::UnresolvedReference);}crate::audio_path_memory::read(&self.memory,r,n)}
 fn read_word(&self,r:u32,o:u32)->Result<u32,Error>{Ok(word(self.read(r.wrapping_add(o),4)?,0))}
 fn release(&mut self,s:&mut impl Services,r:u32,v:&mut Memory)->Result<(),Error>{s.free(self.pool,r,v,self)?;self.retired.insert(r);Ok(())}
 fn write(&mut self,r:u32,b:&[u8])->Result<(),Error>{self.read(r,b.len())?;let base=*self.memory.range(..=r).next_back().ok_or(Error::UnresolvedReference)?.0;let offset=r.wrapping_sub(base)as usize;self.memory.get_mut(&base).unwrap().raw[offset..offset+b.len()].copy_from_slice(b);Ok(())}
 fn invoke(&mut self,s:&mut impl Services,c:Call,r:u32,a:&[u32],v:&mut Memory)->Result<u32,Error>{s.call(c,r,a,None,v,self)}
 pub fn release_registration(&mut self,v:&mut Memory,s:&mut impl Services)->Result<(),Error>{
 if v.reference==0||v.raw.len()<416{return Err(Error::InvalidAllocation);}
 if v.raw[303]&0x40!=0{self.invoke(s,Call::EffectStop,v.reference,&[0],v)?;}
 if v.raw[302]&0x10!=0{return Ok(());}v.raw[302]|=0x10;
 for(offset,selector)in[(408,1),(412,2)]{let r=word(&v.raw,offset);if r!=0{self.invoke(s,Call::RemoveRegistration,r,&[v.reference,selector],v)?;set(&mut v.raw,offset,0);}}
 self.invoke(s,Call::RemoveRegistration,self.global_registry,&[v.reference,0],v)?;
 let mut payload=self.registration_scratch;for o in [0,8,12]{set(&mut payload,o,0);}set(&mut payload,4,word(&v.raw,104));set(&mut payload,16,3);payload[20..22].copy_from_slice(&0x100u16.to_le_bytes());self.registration_scratch=payload;
 let result=s.call_source_virtual8c(word(&v.raw,96),&mut payload,v,self);self.registration_scratch=payload;result.map(|_|())
 }
 pub fn cleanup(&mut self,v:&mut Memory,s:&mut impl Services)->Result<(),Error>{
 if v.reference==0||v.raw.len()<416{return Err(Error::InvalidAllocation);}self.release_registration(v,s)?;
 let node=word(&v.raw,400);if node!=0{
 if self.read_word(node,24)?&2!=0{let state=crate::audio_path_source_state::nearest(&self.memory,word(&v.raw,96))?;self.write(state.wrapping_add(4),&0u32.to_le_bytes())?;self.write(state,&0u32.to_le_bytes())?;}
 self.invoke(s,Call::RemoveBinding,self.binding_manager,&[node,v.reference],v)?;set(&mut v.raw,400,0);set(&mut v.raw,404,0);
 }
 for offset in [80,84]{let r=word(&v.raw,offset);if r!=0{self.invoke(s,Call::ReleaseOwner,self.owner_manager,&[r,v.reference.wrapping_add(8)],v)?;}}
 v.raw[301]&=!1;
 let query=word(&v.raw,72);if query!=0{self.invoke(s,Call::ReleaseQuery,self.query_manager,&[query,v.reference],v)?;}
 let secondary=word(&v.raw,104);if secondary!=0{let old=self.read_word(secondary,96)?;let count=old^((old.wrapping_sub(1)^old)&0x3fffffff);self.write(secondary.wrapping_add(96),&count.to_le_bytes())?;if count&0x3fffffff==0{self.invoke(s,Call::DestroySecondary,secondary,&[],v)?;self.release(s,secondary,v)?;}}
 let source=word(&v.raw,48);if source!=0{
 if self.read_word(source,60)?==0{let property=self.invoke(s,Call::LookupSourceProperty,self.source_manager.wrapping_add(0x12c0),&[self.read_word(source,8)?],v)?;self.write(source.wrapping_add(60),&property.to_le_bytes())?;}
 let property=self.read_word(source,60)?;if property!=0{self.invoke(s,Call::ApplySourceProperty,v.reference,&[property],v)?;}
 let source=word(&v.raw,48);if source!=0{self.invoke(s,Call::SourceDestructor,source,&[0],v)?;self.release(s,source,v)?;}set(&mut v.raw,48,0);
 }
 let allocation=word(&v.raw,24);if allocation!=0{set(&mut v.raw,28,0);self.release(s,allocation,v)?;set(&mut v.raw,24,0);set(&mut v.raw,32,0);}
 self.invoke(s,Call::RemoveSourceVoice,word(&v.raw,96),&[v.reference],v)?;
 if word(&v.raw,332)!=0{self.invoke(s,Call::ReleaseInput,word(&v.raw,100),&[],v)?;set(&mut v.raw,332,0);}
 let stream=word(&v.raw,20);if stream!=0{self.invoke(s,Call::ReleaseStream,stream,&[0],v)?;set(&mut v.raw,20,0);}
 let owned_input=self.read_word(word(&v.raw,100),16)?&0x100!=0;self.invoke(s,Call::SourceVirtual08,word(&v.raw,96),&[],v)?;
 let cache=word(&v.raw,396);if cache!=0{self.invoke(s,Call::ReleaseCache,cache,&[],v)?;set(&mut v.raw,396,0);}
 if owned_input{let input=word(&v.raw,100);if input!=0{self.invoke(s,Call::DestroyInput,input,&[],v)?;self.release(s,input,v)?;}}
 Ok(())
 }
}
/// Structured views contain no duplicate live regions during cleanup. The
/// physical region map lends allocations to native manager helpers and receives
/// live allocations back; freed regions remain only as guarded snapshots.
pub struct Bindings{pub nodes:crate::audio_frame_node_update::Runtime,pub bindings:crate::audio_timed_node_update::Runtime,pub selection:crate::audio_timed_node_selection::Runtime,pub lifetime:crate::audio_path_lifecycle::Runtime}
struct Disposal<'a,S>{downstream:&'a mut S,voice:&'a mut Memory,context:&'a mut Runtime}
impl<S:Services+crate::audio_path_manager::Disposal> crate::audio_path_manager::Services for Disposal<'_,S>{
 fn allocate(&mut self,p:u32,n:u32)->Result<Option<Memory>,Error>{crate::audio_path_manager::Services::allocate(self.downstream,p,n)}
 fn free(&mut self,p:u32,m:&Memory)->Result<(),Error>{self.context.memory.insert(m.reference,m.clone());Services::free(self.downstream,p,m.reference,self.voice,self.context)?;self.context.retired.insert(m.reference);Ok(())}
 fn observe_empty_destructor(&mut self,r:u32){crate::audio_path_manager::Services::observe_empty_destructor(self.downstream,r)}
}
impl<S:Services+crate::audio_path_manager::Disposal> crate::audio_path_manager::Disposal for Disposal<'_,S>{
 fn observe_manager(&mut self,h:&[u8;12],t:&Memory){crate::audio_path_manager::Disposal::observe_manager(self.downstream,h,t)}
 fn observe_node_retirement(&mut self,b:&[u8]){crate::audio_path_manager::Disposal::observe_node_retirement(self.downstream,b)}
}
struct Owned<'a,S>{graph:&'a mut Bindings,manager:&'a crate::audio_path_manager::Runtime,owners:&'a mut crate::audio_path_voice_owner_release::Runtime,downstream:&'a mut S}
fn lend(c:&mut Runtime,destination:&mut BTreeMap<u32,Memory>,r:u32)->Result<(),Error>{if r==0{return Ok(());}if c.retired.contains(&r){return Err(Error::UnresolvedReference);}if destination.contains_key(&r){return Err(Error::InvalidAllocation);}let m=c.memory.remove(&r).ok_or(Error::UnresolvedReference)?;destination.insert(r,m);Ok(())}
fn restore(c:&mut Runtime,source:&mut BTreeMap<u32,Memory>,r:u32){if let Some(m)=source.remove(&r){c.memory.insert(r,m);}}
impl<S:Services+crate::audio_path_manager::Disposal> Services for Owned<'_,S>{
 fn call_source_virtual8c(&mut self,r:u32,p:&mut[u8],v:&mut Memory,c:&mut Runtime)->Result<u32,Error>{self.downstream.call_source_virtual8c(r,p,v,c)}

 fn call(&mut self,k:Call,r:u32,a:&[u32],p:Option<&[u8]>,v:&mut Memory,c:&mut Runtime)->Result<u32,Error>{
 match k{
 Call::ReleaseOwner=>{self.downstream.observe_call(k,r,a,p,v,c);self.owners.remove(a[0],a[1])},
 Call::RemoveBinding=>{self.downstream.observe_call(k,r,a,p,v,c);let n=a[0];let binding=c.read_word(n,32)?;let mask=c.read_word(n,8)?;let auxiliary=c.read_word(n,104)?;
 let imports=[(n,true),(binding,binding!=0&&c.memory.contains_key(&binding)&&!c.retired.contains(&binding)),(mask,mask!=0&&c.memory.contains_key(&mask)&&!c.retired.contains(&mask)),(auxiliary,auxiliary!=0&&c.memory.contains_key(&auxiliary)&&!c.retired.contains(&auxiliary))];
 let mut distinct=BTreeSet::new();for(reference,import)in imports{if import&&!distinct.insert(reference){return Err(Error::InvalidAllocation);}}
 if self.graph.nodes.nodes.contains_key(&n)||(imports[1].1&&self.graph.bindings.tables.contains_key(&binding))||(imports[2].1&&self.graph.selection.masks.contains_key(&mask))||(imports[3].1&&self.graph.lifetime.auxiliary.contains_key(&auxiliary)){return Err(Error::InvalidAllocation);}
 lend(c,&mut self.graph.nodes.nodes,n)?;if imports[1].1{lend(c,&mut self.graph.bindings.tables,binding)?;}if imports[2].1{lend(c,&mut self.graph.selection.masks,mask)?;}if imports[3].1{lend(c,&mut self.graph.lifetime.auxiliary,auxiliary)?;}

 let g=&mut self.graph;let result=self.manager.remove_binding(&mut g.nodes,&mut g.bindings,&mut g.selection,&mut g.lifetime,n,a[1],&mut Disposal{downstream:self.downstream,voice:v,context:c});
 restore(c,&mut g.nodes.nodes,n);restore(c,&mut g.bindings.tables,binding);restore(c,&mut g.selection.masks,mask);restore(c,&mut g.lifetime.auxiliary,auxiliary);result},
 _=>self.downstream.call(k,r,a,p,v,c)
 }
 }
 fn free(&mut self,p:u32,r:u32,v:&mut Memory,c:&mut Runtime)->Result<(),Error>{Services::free(self.downstream,p,r,v,c)}
}
pub fn cleanup_owned_bindings(context:&mut Runtime,voice:&mut Memory,graph:&mut Bindings,manager:&crate::audio_path_manager::Runtime,owners:&mut crate::audio_path_voice_owner_release::Runtime,services:&mut(impl Services+crate::audio_path_manager::Disposal))->Result<(),Error>{context.cleanup(voice,&mut Owned{graph,manager,owners,downstream:services})}
/// Native registry and source release services required by the list dispatcher.
pub trait NativeListsServices:Services+crate::audio_path_voice_registration::Observer+crate::audio_path_voice_empty_source_release::Services{}
impl<T:Services+crate::audio_path_voice_registration::Observer+crate::audio_path_voice_empty_source_release::Services> NativeListsServices for T{}
struct Lists<'a,S>{heads:&'a mut crate::audio_path_voice_registration::Heads,downstream:&'a mut S}
fn hide_retired(c:&mut Runtime)->BTreeMap<u32,Memory>{let keys:Vec<_>=c.retired.iter().copied().collect();keys.into_iter().filter_map(|r|c.memory.remove(&r).map(|m|(r,m))).collect()}
fn restore_retired(c:&mut Runtime,m:BTreeMap<u32,Memory>){for(r,m)in m{c.memory.entry(r).or_insert(m);}}
impl<S:NativeListsServices> Services for Lists<'_,S>{
 fn call_source_virtual8c(&mut self,r:u32,p:&mut[u8],v:&mut Memory,c:&mut Runtime)->Result<u32,Error>{self.downstream.call_source_virtual8c(r,p,v,c)}

 fn observe_call(&mut self,k:Call,r:u32,a:&[u32],p:Option<&[u8]>,v:&Memory,c:&Runtime){self.downstream.observe_call(k,r,a,p,v,c)}
 fn call(&mut self,k:Call,r:u32,a:&[u32],p:Option<&[u8]>,v:&mut Memory,c:&mut Runtime)->Result<u32,Error>{match k{
 Call::RemoveRegistration=>{self.downstream.observe_call(k,r,a,p,v,c);if c.retired.contains(&r){return Err(Error::UnresolvedReference);}let inactive=hide_retired(c);let result=crate::audio_path_voice_registration::remove(&mut c.memory,self.heads,r,v,a[1],self.downstream);restore_retired(c,inactive);result.map(|_|1)},
 Call::RemoveSourceVoice=>{self.downstream.observe_call(k,r,a,p,v,c);let inactive=hide_retired(c);let result=crate::audio_path_voice_empty_source_release::remove_releasing(&mut c.memory,&mut c.retired,r,a[0],Some(v),c.pool,self.downstream);restore_retired(c,inactive);result.map(|_|1)},
 _=>self.downstream.call(k,r,a,p,v,c)}}
 fn free(&mut self,p:u32,r:u32,v:&mut Memory,c:&mut Runtime)->Result<(),Error>{Services::free(self.downstream,p,r,v,c)}
}
impl<S:NativeListsServices+crate::audio_path_manager::Disposal> crate::audio_path_manager::Services for Lists<'_,S>{fn allocate(&mut self,p:u32,n:u32)->Result<Option<Memory>,Error>{crate::audio_path_manager::Services::allocate(self.downstream,p,n)}fn free(&mut self,p:u32,m:&Memory)->Result<(),Error>{crate::audio_path_manager::Services::free(self.downstream,p,m)}fn observe_empty_destructor(&mut self,r:u32){crate::audio_path_manager::Services::observe_empty_destructor(self.downstream,r)}}
impl<S:NativeListsServices+crate::audio_path_manager::Disposal> crate::audio_path_manager::Disposal for Lists<'_,S>{fn observe_manager(&mut self,h:&[u8;12],t:&Memory){crate::audio_path_manager::Disposal::observe_manager(self.downstream,h,t)}fn observe_node_retirement(&mut self,b:&[u8]){crate::audio_path_manager::Disposal::observe_node_retirement(self.downstream,b)}}
pub fn cleanup_native_lists(c:&mut Runtime,v:&mut Memory,heads:&mut crate::audio_path_voice_registration::Heads,s:&mut impl NativeListsServices)->Result<(),Error>{c.cleanup(v,&mut Lists{heads,downstream:s})}
pub fn cleanup_native_lists_owned_bindings(c:&mut Runtime,v:&mut Memory,graph:&mut Bindings,manager:&crate::audio_path_manager::Runtime,owners:&mut crate::audio_path_voice_owner_release::Runtime,heads:&mut crate::audio_path_voice_registration::Heads,s:&mut(impl NativeListsServices+crate::audio_path_manager::Disposal))->Result<(),Error>{cleanup_owned_bindings(c,v,graph,manager,owners,&mut Lists{heads,downstream:s})}
/// Full list and source-body dispatch uses one canonical live-region map.
pub trait NativeSourcesServices:NativeListsServices+crate::audio_path_source_virtual_cleanup::Services{}
impl<T:NativeListsServices+crate::audio_path_source_virtual_cleanup::Services> NativeSourcesServices for T{}
struct Sources<'a,S>{manager:u32,downstream:&'a mut S}
impl<S:NativeSourcesServices> Services for Sources<'_,S>{
 fn observe_call(&mut self,k:Call,r:u32,a:&[u32],p:Option<&[u8]>,v:&Memory,c:&Runtime){self.downstream.observe_call(k,r,a,p,v,c)}
 fn call(&mut self,k:Call,r:u32,a:&[u32],p:Option<&[u8]>,v:&mut Memory,c:&mut Runtime)->Result<u32,Error>{match k{
 Call::SourceVirtual08=>{self.downstream.observe_call(k,r,a,p,v,c);crate::audio_path_source_virtual_cleanup::release_reference(&mut c.memory,&mut c.retired,r,self.manager,c.pool,self.downstream)},
 Call::SourceVirtual8c=>Err(Error::Backend("native source8c requires mutable frame payload")),
 _=>self.downstream.call(k,r,a,p,v,c)}}
 fn call_source_virtual8c(&mut self,r:u32,p:&mut[u8],v:&mut Memory,c:&mut Runtime)->Result<u32,Error>{
 if p.len()!=24{return Err(Error::Truncated);}self.downstream.observe_call(Call::SourceVirtual8c,r,&[],Some(p),v,c);
 // Only the transient24-byte caller frame is represented by this typed view;
 // source/owner regions are borrowed directly from the canonical map.
 let mut payload=Memory{reference:0,raw:p.to_vec()};let result=crate::audio_path_source_virtual_cleanup::propagate_release(&mut c.memory,&mut c.retired,r,&mut payload,c.pool,self.downstream);p.copy_from_slice(&payload.raw);result.map(|_|1)
 }
 fn free(&mut self,p:u32,r:u32,v:&mut Memory,c:&mut Runtime)->Result<(),Error>{Services::free(self.downstream,p,r,v,c)}
}
impl<S:NativeSourcesServices> crate::audio_path_voice_registration::Observer for Sources<'_,S>{fn observe_unlink(&mut self,s:u32,r:u32){crate::audio_path_voice_registration::Observer::observe_unlink(self.downstream,s,r)}}
impl<S:NativeSourcesServices> crate::audio_path_voice_empty_source_release::Services for Sources<'_,S>{
 fn free(&mut self,p:u32,r:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>{crate::audio_path_voice_empty_source_release::Services::free(self.downstream,p,r,m)}
 fn observe_parent_removal(&mut self,p:u32,r:u32){crate::audio_path_voice_empty_source_release::Services::observe_parent_removal(self.downstream,p,r)}
 fn observe_empty_source_release(&mut self,r:u32,m:&BTreeMap<u32,Memory>){crate::audio_path_voice_empty_source_release::Services::observe_empty_source_release(self.downstream,r,m)}
}
impl<S:NativeSourcesServices+crate::audio_path_manager::Disposal> crate::audio_path_manager::Services for Sources<'_,S>{fn allocate(&mut self,p:u32,n:u32)->Result<Option<Memory>,Error>{crate::audio_path_manager::Services::allocate(self.downstream,p,n)}fn free(&mut self,p:u32,m:&Memory)->Result<(),Error>{crate::audio_path_manager::Services::free(self.downstream,p,m)}fn observe_empty_destructor(&mut self,r:u32){crate::audio_path_manager::Services::observe_empty_destructor(self.downstream,r)}}
impl<S:NativeSourcesServices+crate::audio_path_manager::Disposal> crate::audio_path_manager::Disposal for Sources<'_,S>{fn observe_manager(&mut self,h:&[u8;12],t:&Memory){crate::audio_path_manager::Disposal::observe_manager(self.downstream,h,t)}fn observe_node_retirement(&mut self,b:&[u8]){crate::audio_path_manager::Disposal::observe_node_retirement(self.downstream,b)}}
pub fn cleanup_native_sources(c:&mut Runtime,v:&mut Memory,heads:&mut crate::audio_path_voice_registration::Heads,source_manager:u32,s:&mut impl NativeSourcesServices)->Result<(),Error>{cleanup_native_lists(c,v,heads,&mut Sources{manager:source_manager,downstream:s})}
pub fn cleanup_native_sources_owned_bindings(c:&mut Runtime,v:&mut Memory,graph:&mut Bindings,manager:&crate::audio_path_manager::Runtime,owners:&mut crate::audio_path_voice_owner_release::Runtime,heads:&mut crate::audio_path_voice_registration::Heads,source_manager:u32,s:&mut(impl NativeSourcesServices+crate::audio_path_manager::Disposal))->Result<(),Error>{cleanup_native_lists_owned_bindings(c,v,graph,manager,owners,heads,&mut Sources{manager:source_manager,downstream:s})}
/// Full list and source-body dispatch uses one canonical live-region map.
pub trait NativeTerminalSourcesServices:NativeListsServices+crate::audio_path_source_virtual_cleanup::Services+crate::audio_path_source_terminal_cleanup::Services{}
impl<T:NativeListsServices+crate::audio_path_source_virtual_cleanup::Services+crate::audio_path_source_terminal_cleanup::Services> NativeTerminalSourcesServices for T{}
struct TerminalSources<'a,S>{manager:u32,callback_manager:u32,downstream:&'a mut S}
impl<S:NativeTerminalSourcesServices> Services for TerminalSources<'_,S>{
 fn observe_call(&mut self,k:Call,r:u32,a:&[u32],p:Option<&[u8]>,v:&Memory,c:&Runtime){self.downstream.observe_call(k,r,a,p,v,c)}
 fn call(&mut self,k:Call,r:u32,a:&[u32],p:Option<&[u8]>,v:&mut Memory,c:&mut Runtime)->Result<u32,Error>{match k{
 Call::SourceVirtual08=>{self.downstream.observe_call(k,r,a,p,v,c);crate::audio_path_source_terminal_cleanup::release_reference(&mut c.memory,&mut c.retired,r,self.manager,c.pool,c.owner_manager,self.callback_manager,self.downstream)},
 Call::SourceVirtual8c=>Err(Error::Backend("native source8c requires mutable frame payload")),
 _=>self.downstream.call(k,r,a,p,v,c)}}
 fn call_source_virtual8c(&mut self,r:u32,p:&mut[u8],v:&mut Memory,c:&mut Runtime)->Result<u32,Error>{
 if p.len()!=24{return Err(Error::Truncated);}self.downstream.observe_call(Call::SourceVirtual8c,r,&[],Some(p),v,c);
 // Only the transient24-byte caller frame is represented by this typed view;
 // source/owner regions are borrowed directly from the canonical map.
 let mut payload=Memory{reference:0,raw:p.to_vec()};let result=crate::audio_path_source_virtual_cleanup::propagate_release(&mut c.memory,&mut c.retired,r,&mut payload,c.pool,self.downstream);p.copy_from_slice(&payload.raw);result.map(|_|1)
 }
 fn free(&mut self,p:u32,r:u32,v:&mut Memory,c:&mut Runtime)->Result<(),Error>{Services::free(self.downstream,p,r,v,c)}
}
impl<S:NativeTerminalSourcesServices> crate::audio_path_voice_registration::Observer for TerminalSources<'_,S>{fn observe_unlink(&mut self,s:u32,r:u32){crate::audio_path_voice_registration::Observer::observe_unlink(self.downstream,s,r)}}
impl<S:NativeTerminalSourcesServices> crate::audio_path_voice_empty_source_release::Services for TerminalSources<'_,S>{
 fn free(&mut self,p:u32,r:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>{crate::audio_path_voice_empty_source_release::Services::free(self.downstream,p,r,m)}
 fn observe_parent_removal(&mut self,p:u32,r:u32){crate::audio_path_voice_empty_source_release::Services::observe_parent_removal(self.downstream,p,r)}
 fn observe_empty_source_release(&mut self,r:u32,m:&BTreeMap<u32,Memory>){crate::audio_path_voice_empty_source_release::Services::observe_empty_source_release(self.downstream,r,m)}
}
impl<S:NativeTerminalSourcesServices+crate::audio_path_manager::Disposal> crate::audio_path_manager::Services for TerminalSources<'_,S>{fn allocate(&mut self,p:u32,n:u32)->Result<Option<Memory>,Error>{crate::audio_path_manager::Services::allocate(self.downstream,p,n)}fn free(&mut self,p:u32,m:&Memory)->Result<(),Error>{crate::audio_path_manager::Services::free(self.downstream,p,m)}fn observe_empty_destructor(&mut self,r:u32){crate::audio_path_manager::Services::observe_empty_destructor(self.downstream,r)}}
impl<S:NativeTerminalSourcesServices+crate::audio_path_manager::Disposal> crate::audio_path_manager::Disposal for TerminalSources<'_,S>{fn observe_manager(&mut self,h:&[u8;12],t:&Memory){crate::audio_path_manager::Disposal::observe_manager(self.downstream,h,t)}fn observe_node_retirement(&mut self,b:&[u8]){crate::audio_path_manager::Disposal::observe_node_retirement(self.downstream,b)}}
pub fn cleanup_native_terminal_sources(c:&mut Runtime,v:&mut Memory,heads:&mut crate::audio_path_voice_registration::Heads,source_manager:u32,callback_manager:u32,s:&mut impl NativeTerminalSourcesServices)->Result<(),Error>{cleanup_native_lists(c,v,heads,&mut TerminalSources{manager:source_manager,callback_manager,downstream:s})}
pub fn cleanup_native_terminal_sources_owned_bindings(c:&mut Runtime,v:&mut Memory,graph:&mut Bindings,manager:&crate::audio_path_manager::Runtime,owners:&mut crate::audio_path_voice_owner_release::Runtime,heads:&mut crate::audio_path_voice_registration::Heads,source_manager:u32,callback_manager:u32,s:&mut(impl NativeTerminalSourcesServices+crate::audio_path_manager::Disposal))->Result<(),Error>{cleanup_native_lists_owned_bindings(c,v,graph,manager,owners,heads,&mut TerminalSources{manager:source_manager,callback_manager,downstream:s})}
/// Complete terminal-source/action graph dispatch with shared live allocations.
pub trait NativeTerminalActionSourcesServices:NativeListsServices+crate::audio_path_source_virtual_cleanup::Services+crate::audio_path_source_terminal_cleanup::Services+crate::audio_path_source_action_list_cleanup::Services{}
impl<T:NativeListsServices+crate::audio_path_source_virtual_cleanup::Services+crate::audio_path_source_terminal_cleanup::Services+crate::audio_path_source_action_list_cleanup::Services> NativeTerminalActionSourcesServices for T{}
struct TerminalActionSources<'a,S>{manager:u32,callback_manager:u32,registry:u32,downstream:&'a mut S}
impl<S:NativeTerminalActionSourcesServices> Services for TerminalActionSources<'_,S>{
 fn observe_call(&mut self,k:Call,r:u32,a:&[u32],p:Option<&[u8]>,v:&Memory,c:&Runtime){self.downstream.observe_call(k,r,a,p,v,c)}
 fn call(&mut self,k:Call,r:u32,a:&[u32],p:Option<&[u8]>,v:&mut Memory,c:&mut Runtime)->Result<u32,Error>{match k{
 Call::SourceVirtual08=>{self.downstream.observe_call(k,r,a,p,v,c);crate::audio_path_source_action_list_cleanup::release_reference_native_actions(&mut c.memory,&mut c.retired,r,self.manager,c.pool,self.registry,c.owner_manager,self.callback_manager,self.downstream)},
 Call::SourceVirtual8c=>Err(Error::Backend("native source8c requires mutable frame payload")),
 _=>self.downstream.call(k,r,a,p,v,c)}}
 fn call_source_virtual8c(&mut self,r:u32,p:&mut[u8],v:&mut Memory,c:&mut Runtime)->Result<u32,Error>{
 if p.len()!=24{return Err(Error::Truncated);}self.downstream.observe_call(Call::SourceVirtual8c,r,&[],Some(p),v,c);
 // Only the transient24-byte caller frame is represented by this typed view;
 // source/owner regions are borrowed directly from the canonical map.
 let mut payload=Memory{reference:0,raw:p.to_vec()};let result=crate::audio_path_source_virtual_cleanup::propagate_release(&mut c.memory,&mut c.retired,r,&mut payload,c.pool,self.downstream);p.copy_from_slice(&payload.raw);result.map(|_|1)
 }
 fn free(&mut self,p:u32,r:u32,v:&mut Memory,c:&mut Runtime)->Result<(),Error>{Services::free(self.downstream,p,r,v,c)}
}
impl<S:NativeTerminalActionSourcesServices> crate::audio_path_voice_registration::Observer for TerminalActionSources<'_,S>{fn observe_unlink(&mut self,s:u32,r:u32){crate::audio_path_voice_registration::Observer::observe_unlink(self.downstream,s,r)}}
impl<S:NativeTerminalActionSourcesServices> crate::audio_path_voice_empty_source_release::Services for TerminalActionSources<'_,S>{
 fn free(&mut self,p:u32,r:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>{crate::audio_path_voice_empty_source_release::Services::free(self.downstream,p,r,m)}
 fn observe_parent_removal(&mut self,p:u32,r:u32){crate::audio_path_voice_empty_source_release::Services::observe_parent_removal(self.downstream,p,r)}
 fn observe_empty_source_release(&mut self,r:u32,m:&BTreeMap<u32,Memory>){crate::audio_path_voice_empty_source_release::Services::observe_empty_source_release(self.downstream,r,m)}
}
impl<S:NativeTerminalActionSourcesServices+crate::audio_path_manager::Disposal> crate::audio_path_manager::Services for TerminalActionSources<'_,S>{fn allocate(&mut self,p:u32,n:u32)->Result<Option<Memory>,Error>{crate::audio_path_manager::Services::allocate(self.downstream,p,n)}fn free(&mut self,p:u32,m:&Memory)->Result<(),Error>{crate::audio_path_manager::Services::free(self.downstream,p,m)}fn observe_empty_destructor(&mut self,r:u32){crate::audio_path_manager::Services::observe_empty_destructor(self.downstream,r)}}
impl<S:NativeTerminalActionSourcesServices+crate::audio_path_manager::Disposal> crate::audio_path_manager::Disposal for TerminalActionSources<'_,S>{fn observe_manager(&mut self,h:&[u8;12],t:&Memory){crate::audio_path_manager::Disposal::observe_manager(self.downstream,h,t)}fn observe_node_retirement(&mut self,b:&[u8]){crate::audio_path_manager::Disposal::observe_node_retirement(self.downstream,b)}}
pub fn cleanup_native_terminal_action_sources(c:&mut Runtime,v:&mut Memory,heads:&mut crate::audio_path_voice_registration::Heads,source_manager:u32,callback_manager:u32,action_registry:u32,s:&mut impl NativeTerminalActionSourcesServices)->Result<(),Error>{cleanup_native_lists(c,v,heads,&mut TerminalActionSources{manager:source_manager,callback_manager,registry:action_registry,downstream:s})}
pub fn cleanup_native_terminal_action_sources_owned_bindings(c:&mut Runtime,v:&mut Memory,graph:&mut Bindings,manager:&crate::audio_path_manager::Runtime,owners:&mut crate::audio_path_voice_owner_release::Runtime,heads:&mut crate::audio_path_voice_registration::Heads,source_manager:u32,callback_manager:u32,action_registry:u32,s:&mut(impl NativeTerminalActionSourcesServices+crate::audio_path_manager::Disposal))->Result<(),Error>{cleanup_native_lists_owned_bindings(c,v,graph,manager,owners,heads,&mut TerminalActionSources{manager:source_manager,callback_manager,registry:action_registry,downstream:s})}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 fn kind(c:Call)->&'static str{match c{Call::EffectStop=>"effect_stop",Call::RemoveRegistration=>"remove_registration",Call::RemoveBinding=>"remove_binding",Call::ReleaseOwner=>"release_owner",Call::ReleaseQuery=>"release_query",Call::DestroySecondary=>"destroy_secondary",Call::LookupSourceProperty=>"lookup_source_property",Call::ApplySourceProperty=>"apply_source_property",Call::RemoveSourceVoice=>"remove_source_voice",Call::ReleaseInput=>"release_input",Call::ReleaseStream=>"release_stream",Call::ReleaseCache=>"release_cache",Call::DestroyInput=>"destroy_input",Call::SourceVirtual08=>"source_virtual08",Call::SourceVirtual8c=>"source_virtual8c",Call::SourceDestructor=>"source_destructor"}}
 struct Backend{calls:Vec<Value>}
 impl Services for Backend{
 fn observe_call(&mut self,c:Call,r:u32,a:&[u32],_:Option<&[u8]>,_:&Memory,_:&Runtime){self.calls.push(json!({"kind":kind(c),"receiver":r,"arguments":a}));}
 fn call(&mut self,c:Call,r:u32,a:&[u32],p:Option<&[u8]>,_:&mut Memory,_:&mut Runtime)->Result<u32,Error>{let event=if c==Call::SourceVirtual8c{json!({"kind":kind(c),"receiver":r,"payload":hex(p.unwrap())})}else if matches!(c,Call::SourceVirtual08|Call::SourceDestructor){json!({"kind":kind(c),"receiver":r})}else{json!({"kind":kind(c),"receiver":r,"arguments":a})};self.calls.push(event);Ok(if c==Call::LookupSourceProperty{0}else{1})}
 fn free(&mut self,p:u32,r:u32,v:&mut Memory,c:&mut Runtime)->Result<(),Error>{self.calls.push(json!({"kind":"free","pool":p,"reference":r,"voice_at_call":hex(&v.raw),"resource_at_call":hex(&c.memory[&0x40009000].raw)}));Ok(())}
 }
 #[test]fn audio_path_voice_cleanup_matches48_native_outer_registration_phase_state_clear_optional_resources_callback_free_order_and_full_memory_cases(){
 let p:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_path_voice_cleanup_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],48);for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let b=&row["before"];let mut v=Memory{reference:0x40004000,raw:bytes(b["voice"].as_str().unwrap())};let mut c=Runtime{pool:19,binding_manager:0,owner_manager:0,query_manager:0,source_manager:0,global_registry:0x12100e0,registration_scratch:row["registration_scratch_initial"].as_str().map(|s|bytes(s).try_into().unwrap()).unwrap_or([0;24]),retired:BTreeSet::new(),memory:[("source",0x40005000),("root",0x40006000),("node",0x40008000),("resource",0x40009000),("secondary",0x4000a000)].into_iter().map(|(name,reference)|(reference,Memory{reference,raw:bytes(b[name].as_str().unwrap())})).collect()};let mut backend=Backend{calls:vec![]};c.cleanup(&mut v,&mut backend).unwrap();assert_eq!(json!(backend.calls),row["calls"],"ordered mandatory services and state before physical frees {i}");let mut after=json!({"voice":hex(&v.raw)});for(name,reference)in[("source",0x40005000),("root",0x40006000),("node",0x40008000),("resource",0x40009000),("secondary",0x4000a000)]{after[name]=json!(hex(&c.memory[&reference].raw));}assert_eq!(after,row["after"],"full voice/source/resource/padding bytes {i}");}
 }
 impl crate::audio_path_manager::Services for Backend{
 fn allocate(&mut self,_:u32,_:u32)->Result<Option<Memory>,Error>{Err(Error::Backend("cleanup must not allocate nodes"))}
 fn free(&mut self,_:u32,_:&Memory)->Result<(),Error>{Err(Error::Backend("physical retirement is routed through canonical cleanup region transport"))}
 fn observe_empty_destructor(&mut self,r:u32){self.calls.push(json!({"kind":"destroy_node","reference":r}));}
 }
 impl crate::audio_path_manager::Disposal for Backend{}
 #[test]fn audio_path_voice_cleanup_matches48_native_actual_binding_owner_last_node_retirement_physical_free_state_and_canonical_regions(){
 let p:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_path_voice_cleanup_owned_binding_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],48);for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let b=&row["before"];let mut v=Memory{reference:0x40004000,raw:bytes(b["voice"].as_str().unwrap())};let mut c=Runtime{pool:19,binding_manager:0x4001a000,owner_manager:0,query_manager:0,source_manager:0,global_registry:0x12100e0,registration_scratch:row["registration_scratch_initial"].as_str().map(|s|bytes(s).try_into().unwrap()).unwrap_or([0;24]),retired:BTreeSet::new(),memory:[("source",0x40005000),("root",0x40006000),("node",0x40008000),("resource",0x40009000),("secondary",0x4000a000),("binding",0x4001c000),("mask",0x4001d000),("auxiliary",0x4001e000)].into_iter().map(|(name,reference)|(reference,Memory{reference,raw:bytes(b[name].as_str().unwrap())})).collect()};
 let manager_raw=bytes(b["manager"].as_str().unwrap());let mut graph=Bindings{nodes:crate::audio_frame_node_update::Runtime{reference:0x4001a000,header:manager_raw[..12].try_into().unwrap(),table:Memory{reference:0x4001b000,raw:bytes(b["table"].as_str().unwrap())},nodes:BTreeMap::new()},bindings:crate::audio_timed_node_update::Runtime::default(),selection:crate::audio_timed_node_selection::Runtime::default(),lifetime:crate::audio_path_lifecycle::Runtime::default()};let map=|rows:&Value|rows.as_array().unwrap().iter().map(|m|{let reference=m["reference"].as_u64().unwrap()as u32;(reference,Memory{reference,raw:bytes(m["raw"].as_str().unwrap())})}).collect();let mut owners=crate::audio_path_voice_owner_release::Runtime{owners:map(&b["owners"]),tables:map(&b["owner_tables"])};let manager=crate::audio_path_manager::Runtime{limit:4,pool:19};let mut backend=Backend{calls:vec![]};cleanup_owned_bindings(&mut c,&mut v,&mut graph,&manager,&mut owners,&mut backend).unwrap();assert_eq!(json!(backend.calls),row["calls"],"native physical call/free order and state {i}");let mut header=graph.nodes.header.to_vec();header.extend_from_slice(&4u32.to_le_bytes());let mut after=json!({"voice":hex(&v.raw),"manager":hex(&header),"table":hex(&graph.nodes.table.raw),"owners":owners.owners.values().map(|m|json!({"reference":m.reference,"raw":hex(&m.raw)})).collect::<Vec<_>>(),"owner_tables":owners.tables.values().map(|m|json!({"reference":m.reference,"raw":hex(&m.raw)})).collect::<Vec<_>>()});for(name,r)in[("source",0x40005000),("root",0x40006000),("node",0x40008000),("resource",0x40009000),("secondary",0x4000a000),("binding",0x4001c000),("mask",0x4001d000),("auxiliary",0x4001e000)]{after[name]=json!(hex(&c.memory[&r].raw));}assert_eq!(after,row["after"],"complete canonical blocks and retired snapshots {i}");assert!(graph.nodes.nodes.is_empty()&&graph.bindings.tables.is_empty()&&graph.selection.masks.is_empty()&&graph.lifetime.auxiliary.is_empty());if row["node_kind"].as_u64().unwrap()!=0{assert_eq!(c.read_word(0x40008000,24),Err(Error::UnresolvedReference));}
 }
 }
 #[test]fn audio_path_voice_cleanup_matches288_native_retained_empty_missing_wrapping_unpublished_and_normal_binding_regions(){
 let p:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_path_voice_cleanup_binding_branches_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],288);for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let b=&row["before"];let mut v=Memory{reference:0x40004000,raw:bytes(b["voice"].as_str().unwrap())};let mut c=Runtime{pool:19,binding_manager:0x4001a000,owner_manager:0,query_manager:0,source_manager:0,global_registry:0x12100e0,registration_scratch:row["registration_scratch_initial"].as_str().map(|s|bytes(s).try_into().unwrap()).unwrap_or([0;24]),retired:BTreeSet::new(),memory:[("source",0x40005000),("root",0x40006000),("node",0x40008000),("resource",0x40009000),("secondary",0x4000a000),("binding",0x4001c000),("mask",0x4001d000),("auxiliary",0x4001e000)].into_iter().map(|(name,reference)|(reference,Memory{reference,raw:bytes(b[name].as_str().unwrap())})).collect()};
 let manager_raw=bytes(b["manager"].as_str().unwrap());let mut graph=Bindings{nodes:crate::audio_frame_node_update::Runtime{reference:0x4001a000,header:manager_raw[..12].try_into().unwrap(),table:Memory{reference:0x4001b000,raw:bytes(b["table"].as_str().unwrap())},nodes:BTreeMap::new()},bindings:crate::audio_timed_node_update::Runtime::default(),selection:crate::audio_timed_node_selection::Runtime::default(),lifetime:crate::audio_path_lifecycle::Runtime::default()};let map=|rows:&Value|rows.as_array().unwrap().iter().map(|m|{let reference=m["reference"].as_u64().unwrap()as u32;(reference,Memory{reference,raw:bytes(m["raw"].as_str().unwrap())})}).collect();let mut owners=crate::audio_path_voice_owner_release::Runtime{owners:map(&b["owners"]),tables:map(&b["owner_tables"])};let manager=crate::audio_path_manager::Runtime{limit:4,pool:19};let mut backend=Backend{calls:vec![]};cleanup_owned_bindings(&mut c,&mut v,&mut graph,&manager,&mut owners,&mut backend).unwrap();assert_eq!(json!(backend.calls),row["calls"],"native physical call/free order and state {i}");let mut header=graph.nodes.header.to_vec();header.extend_from_slice(&4u32.to_le_bytes());let mut after=json!({"voice":hex(&v.raw),"manager":hex(&header),"table":hex(&graph.nodes.table.raw),"owners":owners.owners.values().map(|m|json!({"reference":m.reference,"raw":hex(&m.raw)})).collect::<Vec<_>>(),"owner_tables":owners.tables.values().map(|m|json!({"reference":m.reference,"raw":hex(&m.raw)})).collect::<Vec<_>>()});for(name,r)in[("source",0x40005000),("root",0x40006000),("node",0x40008000),("resource",0x40009000),("secondary",0x4000a000),("binding",0x4001c000),("mask",0x4001d000),("auxiliary",0x4001e000)]{after[name]=json!(hex(&c.memory[&r].raw));}assert_eq!(after,row["after"],"complete canonical blocks and retired snapshots {i}");assert!(graph.nodes.nodes.is_empty()&&graph.bindings.tables.is_empty()&&graph.selection.masks.is_empty()&&graph.lifetime.auxiliary.is_empty());if row["node_kind"].as_u64().unwrap()!=0&&row["binding_profile"]=="normal"{assert_eq!(c.read_word(0x40008000,24),Err(Error::UnresolvedReference));}
 }
 }

}
