from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/core/src/audio_dynamic_input_owner_selector.rs';s=p.read_text(encoding='utf-8')
start=s.index(' #[test]fn audio_dynamic_input_owner_selector_matches240');t=s[start:-2]
t=t.replace('audio_dynamic_input_owner_selector_matches240_original_static_gate_collision_missing_binding_constant_curves_retained_x87_near_integer_nan_inf_overflow_low16_and_complete_physical_cases','audio_dynamic_input_owner_selector_matches792_original_all9_interpolation_step_default_scaling_zero_db_exponential_cache_initialization_rtpc_defaults_retained_x87_and_complete_physical_cases').replace('audio_dynamic_input_owner_selector_preparation.json','audio_dynamic_input_owner_selector_curves_preparation.json').replace('p["case_count"],240','p["case_count"],792')
s=s[:-2]+t+'}\n'
addition=r'''
struct NativeRtpc<'a,S>{backend:&'a mut S,context:Context}
impl<S:crate::audio_path_source_input_acquisition::Services>crate::audio_path_voice_empty_source_release::Services for NativeRtpc<'_,S>{
 fn free(&mut self,p:u32,r:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>{crate::audio_path_voice_empty_source_release::Services::free(self.backend,p,r,m)}
}
impl<S:crate::audio_path_source_input_acquisition::Services+Services>crate::audio_path_source_input_acquisition::Services for NativeRtpc<'_,S>{
 fn allocate_input(&mut self,p:u32,size:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{self.backend.allocate_input(p,size,m,d)}
 fn dynamic_owner_type(&mut self,source:u32,parameter:u32,owner:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u16,Error>{if parameter!=9{return Err(Error::Backend("source selector parameter must be9"));}select(m,d,source,owner,self.context,self.backend)}
 fn parent_virtual98(&mut self,r:u32,selector:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{self.backend.parent_virtual98(r,selector,m,d)}
 fn observe_parent_input98(&mut self,r:u32,selector:u32,m:&BTreeMap<u32,Memory>){self.backend.observe_parent_input98(r,selector,m)}
}
/// Source98/owner60 construction with real canonical RTPC dynamic type producer.
/// Allocator, parent observers and notification boundary services remain caller-owned.
pub fn acquire_native_rtpc<S:crate::audio_path_source_input_acquisition::Services+Services>(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,source:u32,selector:u32,pool:u32,c:Context,s:&mut S)->Result<u8,Error>{
 crate::audio_path_source_input_acquisition::acquire_recursive(m,d,source,selector,pool,&mut NativeRtpc{backend:s,context:c})
}
'''
s+=addition;p.write_text(s,encoding='utf-8')
print('Added792 full-curve replays and native Source98 RTPC entry')
