from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/core/src/audio_path_source_action_list_cleanup.rs';s=p.read_text(encoding='utf-8')
s=s.replace('pub trait Services:terminal::Services{', 'pub trait Services:terminal::Services{\n fn observe_source_virtualcc(&mut self,_source:u32,_memory:&BTreeMap<u32,Memory>){}\n fn observe_voice_flag_clear(&mut self,_voice:u32,_memory:&BTreeMap<u32,Memory>){}')
anchor='/// A matched registry key returns1'
helper="""/// Original AFFCB0 empty action branch calls AF3420 even when head16 is0.
/// This entry is specifically for the post-destruction phase. Nonempty action
/// property propagation requires the complete D0 path and returns an error here.
pub fn refresh_after_action_destruction(m:&mut BTreeMap<u32,Memory>,dead:&BTreeSet<u32>,source:u32,s:&mut impl Services)->Result<(),Error>{
 if get(m,dead,source.wrapping_add(16),4)?!=0{return Err(Error::Backend("nonempty sourceD0 property propagation requires full query path"));}
 s.observe_source_virtualcc(source,m);let owner=get(m,dead,source.wrapping_add(28),4)?;if owner==0{return Ok(());}let mut voice=get(m,dead,owner.wrapping_add(12),4)?;let mut seen=BTreeSet::new();
 while voice!=0{if !seen.insert(voice){return Err(Error::CyclicList);}s.observe_voice_flag_clear(voice,m);let flag=get(m,dead,voice.wrapping_add(300),1)?;put(m,dead,voice.wrapping_add(300),1,flag&0xdf)?;let flag=get(m,dead,voice.wrapping_add(302),1)?;put(m,dead,voice.wrapping_add(302),1,flag&0xbf)?;voice=get(m,dead,voice.wrapping_add(16),4)?;}Ok(())
}
"""
assert anchor in s;s=s.replace(anchor,helper+anchor)
s=s.replace('struct Backend(Vec<Value>);','struct Backend(Vec<Value>,bool);').replace('Backend(vec![])','Backend(vec![],false)')
s=s.replace('}out}\n struct Backend', '}if m.contains_key(&0x40007000){for(n,r,size)in [("source_owner",0x40007000,64),("voices",0x40018000,1272)]{out[n]=json!(hex(&(0..size).map(|i|crate::audio_path_memory::read(m,r+i as u32,1).unwrap()[0]).collect::<Vec<_>>()));}}out}\n struct Backend')
s=s.replace(' impl Services for Backend{',' impl Services for Backend{\n fn observe_source_virtualcc(&mut self,r:u32,m:&BTreeMap<u32,Memory>){self.0.push(json!({"kind":"source_virtualcc","receiver":r,"at_call":snapshot(m)}));}\n fn observe_voice_flag_clear(&mut self,r:u32,m:&BTreeMap<u32,Memory>){self.0.push(json!({"kind":"clear_voice_flags","receiver":r,"at_call":snapshot(m)}));}')
a='fn source_virtuald0(&mut self,r:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{self.0.push(json!({"kind":"source_virtuald0","receiver":r,"at_call":snapshot(m)}));Ok(())}'
b='fn source_virtuald0(&mut self,r:u32,m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>)->Result<(),Error>{self.0.push(json!({"kind":"source_virtuald0","receiver":r,"at_call":snapshot(m)}));if self.1{refresh_after_action_destruction(m,dead,r,self)?;}Ok(())}'
assert a in s;s=s.replace(a,b)
start=s.index(' #[test]fn audio_path_source_action_list_cleanup_matches576_native_nonempty_registry_and_action_list_composed_callbacks_free_order_and_canonical_lifetimes')
end=s.rfind('\n}')
t=s[start:end].replace('audio_path_source_action_list_cleanup_matches576_native_nonempty_registry_and_action_list_composed_callbacks_free_order_and_canonical_lifetimes','audio_path_source_action_list_cleanup_matches576_native_actual_source_d0_cc_voice_flag_clear_and_full_action_registry_destruction_cases').replace('audio_path_source_action_list_registry_destroy_preparation.json','audio_path_source_action_list_native_query_destroy_preparation.json').replace('("registry_owners",0x40005500,128)]','("registry_owners",0x40005500,128),("source_owner",0x40007000,64),("voices",0x40018000,1272)]').replace('"children"=>256,_=>size','"children"=>256,"voices"=>424,_=>size').replace('Backend(vec![],false)','Backend(vec![],true)')
s=s[:end]+t+s[end:]
s=s.replace(' fn observe_source_virtualcc(', ' fn observe_source_virtuald0(&mut self,_source:u32,_memory:&BTreeMap<u32,Memory>){}\n fn observe_source_virtualcc(',1)
a='pub fn destroy(m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>,source:u32,argument:u32,pool:u32,registry:u32,source_manager:u32,owner_manager:u32,callback_manager:u32,s:&mut impl Services)->Result<(),Error>{'
assert a in s
b=a.replace('pub fn destroy(', 'fn destroy_impl(').replace('s:&mut impl Services)->', 's:&mut impl Services,native_query:bool)->')
wrappers=a+'destroy_impl(m,dead,source,argument,pool,registry,source_manager,owner_manager,callback_manager,s,false)}\n/// Compose actual B00350 with FF1CD8 empty D0, CC and native voice flag clear.\n'+a.replace('pub fn destroy(', 'pub fn destroy_native_query(')+'if get(m,dead,source,4)?!=0xff1cd8{return Err(Error::Backend("sourceD0 vtable is not native FF1CD8"));}destroy_impl(m,dead,source,argument,pool,registry,source_manager,owner_manager,callback_manager,s,true)}\n'
s=s.replace(a,wrappers+b)
s=s.replace('}if argument as u8!=0{s.source_virtuald0(source,m,dead)?;}Ok(())', '}if argument as u8!=0{if native_query{s.observe_source_virtuald0(source,m);refresh_after_action_destruction(m,dead,source,s)?;}else{s.source_virtuald0(source,m,dead)?;}}Ok(())')
s=s.replace(' impl Services for Backend{',' impl Services for Backend{\n fn observe_source_virtuald0(&mut self,r:u32,m:&BTreeMap<u32,Memory>){self.0.push(json!({"kind":"source_virtuald0","receiver":r,"at_call":snapshot(m)}));}')
start=s.index(' #[test]fn audio_path_source_action_list_cleanup_matches576_native_actual_source_d0_cc_voice_flag_clear_and_full_action_registry_destruction_cases')
s=s[:start]+s[start:].replace('destroy(&mut m,','destroy_native_query(&mut m,')
p.write_text(s,encoding='utf-8');print('Added actual post-destruction D0/CC/voice flag path and native576 full physical replay')
