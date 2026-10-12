from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/core/src/audio_dynamic_input_owner_selector.rs';s=p.read_text(encoding='utf-8')
start=s.index(' #[test]fn audio_dynamic_input_owner_selector_matches240');end=s.index(' #[test]fn audio_dynamic_input_owner_selector_matches792',start);t=s[start:end]
t=t.replace('audio_dynamic_input_owner_selector_matches240_original_static_gate_collision_missing_binding_constant_curves_retained_x87_near_integer_nan_inf_overflow_low16_and_complete_physical_cases','audio_dynamic_input_owner_acquisition_matches960_original_real_rtpc_type_constructor60_counter_wrap_existing_skip_oom_flags_and_complete_physical_cases').replace('audio_dynamic_input_owner_selector_preparation.json','audio_dynamic_input_owner_acquisition_preparation.json').replace('p["case_count"],240','p["case_count"],960')
s=s.replace('regions:Vec<(String,u32,usize)>}','regions:Vec<(String,u32,usize)>,failure:bool}').replace('calls:vec![],regions}','calls:vec![],regions,failure:false}')
t=t.replace('let d=BTreeSet::new();','let mut d=BTreeSet::new();').replace('calls:vec![],regions}','calls:vec![],regions,failure:row["allocation_failure"].as_bool().unwrap()}')
t=t.replace('let actual=select(&mut m,&d,0x40001000,0,Context{manager:0x40003000,conversion_cache:0x14a7970},&mut s).unwrap();','s.calls.push(json!({"kind":"input_virtual98","receiver":0x40001000u32,"selector":3,"at_call":s.snapshot(&m)}));let actual=acquire_native_rtpc(&mut m,&mut d,0x40001000,3,19,Context{manager:0x40003000,conversion_cache:0x14a7970},&mut s).unwrap();')
extra=r'''
 impl crate::audio_path_voice_empty_source_release::Services for Backend{fn free(&mut self,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("acquire does not retire owners in this matrix"))}}
 impl crate::audio_path_source_input_acquisition::Services for Backend{
 fn allocate_input(&mut self,p:u32,size:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{assert_eq!(size,60);let result=if self.failure{0}else{0x4000b000};self.calls.push(json!({"kind":"allocate","pool":p,"size":size,"result":result,"at_call":self.snapshot(m)}));Ok((result!=0).then_some(result))}
 fn dynamic_owner_type(&mut self,_:u32,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u16,Error>{Err(Error::Backend("actual dynamic selector must bypass controlled ABI return"))}
 fn parent_virtual98(&mut self,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Err(Error::Backend("no parents in this full dynamic acquisition matrix"))}
 }
'''
s=s[:s.index(' #[test]fn audio_dynamic_input_owner_selector_matches240')]+extra+s[s.index(' #[test]fn audio_dynamic_input_owner_selector_matches240'):]
s=s.replace('\n}\n\nstruct NativeRtpc',t+'\n}\n\nstruct NativeRtpc')
assert t in s;p.write_text(s,encoding='utf-8')
p=r/'crates/core/src/audio_action_registry_value_update.rs';s=p.read_text(encoding='utf-8')
s=s.replace('u32,u32,u32,&mut S)->Result<u8,Error>','u32,u32,u32,Context,&mut S)->Result<u8,Error>')
s=s.replace('Some((native_acquire::<S>,native_apply::<S>))','Some((native_acquire::<S>,native_apply::<S>,0))')
s=s.replace('source:u32,selector:u32,pool:u32,s:&mut S)->Result<u8,Error>{s.observe_input_acquisition(source,selector,m);crate::audio_path_source_input_acquisition::acquire_recursive(m,d,source,selector,pool,s)}','source:u32,selector:u32,_rtpc_manager:u32,c:Context,s:&mut S)->Result<u8,Error>{s.observe_input_acquisition(source,selector,m);crate::audio_path_source_input_acquisition::acquire_recursive(m,d,source,selector,c.pool,s)}')
s=s.replace('callbacks:Option<(Acquire<S>,Apply<S>)>','callbacks:Option<(Acquire<S>,Apply<S>,u32)>')
s=s.replace('Some((acquire,_))=callbacks{acquire(m,d,input,3,c.pool,s)?','Some((acquire,_,rtpc_manager))=callbacks{acquire(m,d,input,3,rtpc_manager,c,s)?').replace('Some((_,apply))=callbacks','Some((_,apply,_))=callbacks')
new=r'''
/// Complete registry transition pipeline with the canonical dynamic RTPC source type producer.
pub fn update_native_rtpc_callbacks<S:Services+crate::audio_property_owner_creation::Services+crate::audio_path_source_input_acquisition::Services+crate::audio_path_source_virtual_cleanup::InputReleaseServices+crate::audio_dynamic_input_owner_selector::Services>(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,registry:u32,key:u32,new:u32,instant:u32,skip_notify:u32,scratch:u32,rtpc_manager:u32,c:Context,s:&mut S)->Result<(),Error>{
 update_impl(m,d,registry,key,new,instant,skip_notify,c,s,Some((scratch,native_create_callbacks::<S>)),Some((native_rtpc_acquire::<S>,native_apply::<S>,rtpc_manager)))
}
fn native_rtpc_acquire<S:Services+crate::audio_path_source_input_acquisition::Services+crate::audio_dynamic_input_owner_selector::Services>(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,source:u32,selector:u32,rtpc_manager:u32,c:Context,s:&mut S)->Result<u8,Error>{
 s.observe_input_acquisition(source,selector,m);crate::audio_dynamic_input_owner_selector::acquire_native_rtpc(m,d,source,selector,c.pool,crate::audio_dynamic_input_owner_selector::Context{manager:rtpc_manager,conversion_cache:c.property.conversion_cache},s)
}
'''
s=s.replace('fn native_apply<S:',new+'\nfn native_apply<S:');p.write_text(s,encoding='utf-8')
print('Added960 full acquisition replays and registry dynamic RTPC composition entry')
