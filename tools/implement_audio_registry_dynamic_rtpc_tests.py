from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/core/src/audio_dynamic_input_owner_selector.rs';s=p.read_text(encoding='utf-8')
helper=r'''
#[cfg(target_arch="x86_64")]
fn loaded(bits:u32)->Result<u32,Error>{
 let mut result=0u32;let mut control=[0x037f0000u32,0,0];
 unsafe{std::arch::asm!("fnstcw word ptr [{control}]","fldcw word ptr [{control} + 2]","fld dword ptr [{bits}]","fstp dword ptr [{result}]","fldcw word ptr [{control}]",control=in(reg)control.as_mut_ptr(),bits=in(reg)&bits,result=in(reg)&mut result,out("st(0)")_,options(nostack));}Ok(result)
}
#[cfg(not(target_arch="x86_64"))]fn loaded(_:u32)->Result<u32,Error>{Err(Error::Backend("native RTPC input x87 conversion unavailable"))}
'''
s=s.replace('/// Returned bytes retain',helper+'\n/// Returned bytes retain')
old='let input=value(m,d,c.manager,get(m,d,entry.wrapping_add(4),4)?,owner)?;';assert old in s;s=s.replace(old,'let input=loaded(value(m,d,c.manager,get(m,d,entry.wrapping_add(4),4)?,owner)?)?;')
start=s.index(' #[test]fn audio_dynamic_input_owner_selector_matches240');end=s.index(' #[test]fn audio_dynamic_input_owner_selector_matches792',start);t=s[start:end]
t=t.replace('audio_dynamic_input_owner_selector_matches240_original_static_gate_collision_missing_binding_constant_curves_retained_x87_near_integer_nan_inf_overflow_low16_and_complete_physical_cases','audio_dynamic_input_owner_selector_matches126_original_owner_global_default_override_collision_sorted_duplicate_keys_signaling_nan_input_x87_publication_and_complete_physical_cases').replace('audio_dynamic_input_owner_selector_preparation.json','audio_dynamic_input_owner_selector_overrides_preparation.json').replace('p["case_count"],240','p["case_count"],126').replace('select(&mut m,&d,0x40001000,0,Context','select(&mut m,&d,0x40001000,row["owner"].as_u64().unwrap()as u32,Context')
s=s.replace('\n}\n\nstruct NativeRtpc',t+'\n}\n\nstruct NativeRtpc');assert t in s;p.write_text(s,encoding='utf-8')
p=r/'crates/core/src/audio_action_registry_value_update.rs';s=p.read_text(encoding='utf-8');a=s.index(' #[test]fn audio_registry_selected_child_callbacks_matches288');b=s.index(' #[test]fn audio_registry_allocator_mutation_callbacks_matches256',a);t=s[a:b]
t=t.replace('audio_registry_selected_child_callbacks_matches288_original_first_duplicate_later_match_zero_count_padding_targets_transition_lifetimes_and_active_voice_physical_cases','audio_registry_dynamic_rtpc_callbacks_matches192_original_transition_acquisition_real_rtpc_source_type_constructor_callback_release_active_voice_progression_oom_and_complete_physical_lifetimes').replace('audio_registry_selected_child_callbacks_preparation.json','audio_registry_dynamic_rtpc_callbacks_preparation.json').replace('p["case_count"],288','p["case_count"],192')
t=t.replace('"selected_properties"=>"selected_properties",','"selected_properties"=>"selected_properties","rtpc_manager"=>"rtpc_manager","rtpc_binding"=>"rtpc_binding","rtpc_collision"=>"rtpc_collision","rtpc_curves"=>"rtpc_curves","rtpc_points"=>"rtpc_points",')
t=t.replace('0x40018000','0x4001c000').replace('update_native_callbacks(&mut m,&mut d,0x40001000,row["key"].as_u64().unwrap()as u32,row["new_value"].as_u64().unwrap()as u32,row["instant_argument"].as_u64().unwrap()as u32,1,0x4001c000,c,&mut s)','update_native_rtpc_callbacks(&mut m,&mut d,0x40001000,row["key"].as_u64().unwrap()as u32,row["new_value"].as_u64().unwrap()as u32,row["instant_argument"].as_u64().unwrap()as u32,1,0x4001c000,0x40014000,c,&mut s)')
assert 'update_native_rtpc_callbacks(&mut' in t
extra=r'''
 impl crate::audio_dynamic_input_owner_selector::Services for Backend{
 fn observe_rtpc_manager(&mut self,r:u32,source:u32,parameter:u32,owner:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"rtpc_manager","receiver":r,"arguments":[source,parameter,owner],"at_call":self.snapshot(m)}));}
 fn observe_rtpc_curve(&mut self,r:u32,input:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"curve","receiver":r,"input_bits":input,"at_call":self.snapshot(m)}));}
 }
'''
s=s[:-2]+extra+t+'}\n';p.write_text(s,encoding='utf-8')
print('Added192 full registry/RTPC and126 real override/NaN cases; native input x87 publication composed')
