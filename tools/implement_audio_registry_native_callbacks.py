from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/core/src/audio_action_registry_value_update.rs';s=p.read_text(encoding='utf-8')
assert 'pub fn update_native_callbacks' not in s
s=s.replace('//! Native transition-owner construction composes in canonical storage; source virtual98 remains a required ABI service.','//! Complete native transitions, recursive input acquisition and action callbacks compose in canonical storage.')
s=s.replace('pub trait Services:properties::Services{','pub trait Services:properties::Services{\n fn observe_input_acquisition(&mut self,_source:u32,_selector:u32,_m:&BTreeMap<u32,Memory>){}\n fn observe_action_callback(&mut self,_action:u32,_ty:u32,_bits:u32,_finished:u32,_m:&BTreeMap<u32,Memory>){}')
s=s.replace('c,s,None)}','c,s,None,None)}').replace('Some((scratch,native_create::<S>)))}','Some((scratch,native_create::<S>)),None)}')
s=s.replace('native:Option<(u32,Creator<S>)>)->','native:Option<(u32,Creator<S>)>,callbacks:Option<(Acquire<S>,Apply<S>)>)->')
s=s.replace('if s.input_virtual98(input,3,m,d)?as u8==0{s.action_virtual0(action,ty,target,1,m,d)?;','if (if let Some((acquire,_))=callbacks{acquire(m,d,input,3,c.pool,s)?as u32}else{s.input_virtual98(input,3,m,d)?})as u8==0{if let Some((_,apply))=callbacks{apply(m,d,action,ty,target,1,c.pool,s)?;}else{s.action_virtual0(action,ty,target,1,m,d)?;}')
new=r'''
type Acquire<S>=fn(&mut BTreeMap<u32,Memory>,&mut BTreeSet<u32>,u32,u32,u32,&mut S)->Result<u8,Error>;
type Apply<S>=fn(&mut BTreeMap<u32,Memory>,&mut BTreeSet<u32>,u32,u32,u32,u32,u32,&mut S)->Result<(),Error>;
/// AF6FF0 composed with real AF5490, recursive Source98 and Action0/Source9C/CC.
/// Only allocation, notifications and dynamic selector boundaries remain ABI services.
pub fn update_native_callbacks<S:Services+crate::audio_property_owner_creation::Services+crate::audio_path_source_input_acquisition::Services+crate::audio_path_source_virtual_cleanup::InputReleaseServices>(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,registry:u32,key:u32,new:u32,instant:u32,skip_notify:u32,scratch:u32,c:Context,s:&mut S)->Result<(),Error>{
 update_impl(m,d,registry,key,new,instant,skip_notify,c,s,Some((scratch,native_create_callbacks::<S>)),Some((native_acquire::<S>,native_apply::<S>)))
}
fn native_acquire<S:Services+crate::audio_path_source_input_acquisition::Services>(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,source:u32,selector:u32,pool:u32,s:&mut S)->Result<u8,Error>{s.observe_input_acquisition(source,selector,m);crate::audio_path_source_input_acquisition::acquire_recursive(m,d,source,selector,pool,s)}
fn native_apply<S:Services+crate::audio_path_source_virtual_cleanup::InputReleaseServices>(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,action:u32,ty:u32,bits:u32,finished:u32,pool:u32,s:&mut S)->Result<(),Error>{s.observe_action_callback(action,ty,bits,finished&255,m);crate::audio_path_action_property_callback::apply(m,d,action,ty,bits,finished,pool,s)}
struct NativeCallbacks<'a,S>{backend:&'a mut S,pool:u32}
impl<S:Services>crate::audio_path_voice_empty_source_release::Services for NativeCallbacks<'_,S>{fn free(&mut self,p:u32,r:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>{crate::audio_path_voice_empty_source_release::Services::free(self.backend,p,r,m)}}
impl<S:Services+crate::audio_property_owner_creation::Services+crate::audio_path_source_virtual_cleanup::InputReleaseServices>crate::audio_property_owner_creation::Services for NativeCallbacks<'_,S>{
 fn allocate_owner(&mut self,p:u32,size:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{crate::audio_property_owner_creation::Services::allocate_owner(self.backend,p,size,m,d)}
 fn observe_owner_progression(&mut self,r:u32,time:u32,m:&BTreeMap<u32,Memory>){crate::audio_property_owner_creation::Services::observe_owner_progression(self.backend,r,time,m)}
 fn action_virtual0(&mut self,r:u32,ty:u32,bits:u32,finished:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<(),Error>{native_apply(m,d,r,ty,bits,finished,self.pool,self.backend)}
}
impl<S:Services+crate::audio_path_source_virtual_cleanup::InputReleaseServices>crate::audio_property_owner_progression::Services for NativeCallbacks<'_,S>{fn action_virtual0(&mut self,r:u32,ty:u32,bits:u32,finished:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<(),Error>{native_apply(m,d,r,ty,bits,finished,self.pool,self.backend)}}
fn native_create_callbacks<S:Services+crate::audio_property_owner_creation::Services+crate::audio_path_source_virtual_cleanup::InputReleaseServices>(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,manager:u32,scratch:u32,descriptor:Transition,c:Context,s:&mut S)->Result<Option<u32>,Error>{
 for(i,value)in[descriptor.action,descriptor.property_type,descriptor.initial_bits,descriptor.target_bits,descriptor.duration,descriptor.curve].into_iter().enumerate(){put(m,d,scratch.wrapping_add(i as u32*4),4,value)?;}put(m,d,scratch.wrapping_add(24),1,descriptor.flags as u32)?;put(m,d,scratch.wrapping_add(25),1,descriptor.processed as u32)?;
 s.observe_transition_creation(manager,descriptor,1,1,m);let context=crate::audio_property_owner_creation::Context{pool:c.pool,clock:c.property.clock,frame_quantum:c.property.frame_quantum,conversion_cache:c.property.conversion_cache};crate::audio_property_owner_creation::create(m,d,manager,scratch,1,1,context,&mut NativeCallbacks{backend:s,pool:c.pool})
}
/// Real B20EE0 with canonical property publication, recursive release and active voice flags.
pub fn progress_native_callbacks<S:Services+crate::audio_property_owner_creation::Services+crate::audio_path_source_virtual_cleanup::InputReleaseServices>(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,owner:u32,time:u32,pool:u32,s:&mut S)->Result<(),Error>{crate::audio_property_owner_creation::Services::observe_owner_progression(s,owner,time,m);crate::audio_property_owner_progression::update(m,d,owner,time,&mut NativeCallbacks{backend:s,pool})}
'''
s=s.replace('fn update_impl<S:Services>',new+'\nfn update_impl<S:Services>')
# Share the established explicit-backend rejection contract with a new whole-composition matrix.
base=s.split('#[cfg(test)]mod tests{',1)[1].split(' #[test]',1)[0]
base=base.replace('failure:bool,next:u32,stride:u32,owned:bool,callback_result:u32','failure:bool,next:u32,stride:u32,owned:bool,callback_result:u32,oom:String,owner_index:u32,binding_index:u32,allocated:Vec<(u32,u32)>')
base=base.replace('impl Services for Backend{','''impl Services for Backend{
 fn observe_transition_creation(&mut self,r:u32,t:Transition,first:u32,second:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"create_transition","receiver":r,"descriptor_words":[t.action,t.property_type,t.initial_bits,t.target_bits,t.duration,t.curve],"descriptor_flags":[t.flags,t.processed],"arguments":[first,second],"at_call":self.snapshot(m)}));}
 fn observe_input_acquisition(&mut self,r:u32,selector:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"input_virtual98","receiver":r,"selector":selector,"at_call":self.snapshot(m)}));}
 fn observe_action_callback(&mut self,r:u32,ty:u32,bits:u32,finished:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"action_virtual0","receiver":r,"arguments":[ty,bits,finished],"at_call":self.snapshot(m)}));}
''')
extra=r'''
 impl Backend{fn allocate(&mut self,p:u32,size:u32,m:&BTreeMap<u32,Memory>)->Result<Option<u32>,Error>{let fail=match size{56=>self.oom=="owner",32=>self.oom=="binding",60=>self.oom=="input",_=>return Err(Error::Backend("unexpected allocation"))};let result=if fail{0}else{match size{56=>{let r=0x4000c000+self.owner_index*64;self.owner_index+=1;r},32=>{let r=0x4000e000+self.binding_index*32;self.binding_index+=1;r},60=>0x40007000,_=>unreachable!()}};self.calls.push(json!({"kind":"allocate","pool":p,"size":size,"result":result,"at_call":self.snapshot(m)}));if result!=0{self.allocated.push((result,size));}Ok((result!=0).then_some(result))}}
 impl crate::audio_property_owner_creation::Services for Backend{
 fn allocate_owner(&mut self,p:u32,size:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{self.allocate(p,size,m)}
 fn observe_owner_progression(&mut self,r:u32,time:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"progress_owner","receiver":r,"time":time,"at_call":self.snapshot(m)}));}
 fn action_virtual0(&mut self,_:u32,_:u32,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{Err(Error::Backend("native composition must bypass controlled Action0"))}
 }
 impl crate::audio_path_source_input_acquisition::Services for Backend{
 fn allocate_input(&mut self,p:u32,size:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{self.allocate(p,size,m)}
 fn dynamic_owner_type(&mut self,_:u32,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u16,Error>{Err(Error::Backend("dynamic selector excluded from this native matrix"))}
 fn parent_virtual98(&mut self,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Err(Error::Backend("recursive native acquisition must bypass controlled parent"))}
 }
 #[test]fn audio_registry_native_callbacks_matches288_original_transition_creation_acquisition_progression_recursive_release_active_voice_flags_oom_and_complete_physical_lifetimes(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_registry_native_transition_callbacks_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],288);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){
 let regions=vec![("registry",0x40001000,108),("key_table",0x40002000,8),("state",0x40003000,24),("action",0x40004000,44),("properties",0x40005000,48),("source",0x40006000,120),("input_owner",0x40007000,60),("manager",0x40008000,28),("queues",0x40009000,64),("clock",0x4000a000,128),("voices",0x4000b000,424),("property_owners",0x4000c000,320),("bindings",0x4000e000,160),("conversion_cache",0x14a7970,8)];
 let mut m=BTreeMap::new();for(n,r,z)in &regions{let raw=bytes(row["before"][*n].as_str().unwrap());assert_eq!(raw.len(),*z);if *n=="property_owners"{for(j,slot)in raw.chunks(64).enumerate(){let reference=r+j as u32*64;m.insert(reference,Memory{reference,raw:slot[..56].to_vec()});m.insert(reference+56,Memory{reference:reference+56,raw:slot[56..].to_vec()});}}else{let size=if *n=="bindings"{32}else{*z};for(j,part)in raw.chunks(size).enumerate(){let reference=r+j as u32*size as u32;m.insert(reference,Memory{reference,raw:part.to_vec()});}}}
 m.insert(0x40018000,Memory{reference:0x40018000,raw:vec![0;32]});let mut d=BTreeSet::new();let mut s=Backend{calls:vec![],regions,failure:false,next:0,stride:0,owned:true,callback_result:0,oom:row["failure"].as_str().unwrap().to_owned(),owner_index:0,binding_index:0,allocated:vec![]};let c=Context{pool:19,owner_manager:0x40008000,callback_slot:0,property:crate::audio_path_property_owner_update::Context{clock:0x4000a000,frame_quantum:48,conversion_cache:0x14a7970},property_flags:[1,1,0,0,1]};
 update_native_callbacks(&mut m,&mut d,0x40001000,row["key"].as_u64().unwrap()as u32,row["new_value"].as_u64().unwrap()as u32,row["instant_argument"].as_u64().unwrap()as u32,1,0x40018000,c,&mut s).unwrap();
 assert_eq!(json!(s.calls),row["creation_calls"],"every creation/input/action/free/voice snapshot {i}");assert_eq!(s.snapshot(&m),row["after_creation"],"complete canonical creation physical bank {i}");s.calls.clear();
 for(step_index,step)in row["steps"].as_array().unwrap().iter().enumerate(){assert_eq!(s.snapshot(&m),step["before"],"progression input {i}/{step_index}");progress_native_callbacks(&mut m,&mut d,step["owner"].as_u64().unwrap()as u32,step["time"].as_u64().unwrap()as u32,19,&mut s).unwrap();assert_eq!(json!(s.calls),step["calls"],"all progression/action/release/voice snapshots {i}/{step_index}");assert_eq!(s.snapshot(&m),step["after"],"complete progression physical bank {i}/{step_index}");s.calls.clear();}
 assert_eq!(s.snapshot(&m),row["after"],"final physical lifetime {i}");let expected:BTreeSet<u32>=row["freed"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap()as u32).collect();assert_eq!(d,expected,"retired allocations {i}");let allocations:Vec<Value>=s.allocated.iter().map(|(reference,size)|json!({"reference":reference,"size":size})).collect();assert_eq!(json!(allocations),row["allocations"],"actual allocation identities and sizes {i}");for r in &d{assert_eq!(get(&m,&d,*r,1),Err(Error::UnresolvedReference));}
 }
 }
}
'''
s+='\n#[cfg(test)]mod native_callback_tests{'+base+extra
p.write_text(s,encoding='utf-8');print('Implemented real callbacks and288-case integration replay')
