from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/core/src/audio_path_voice_cleanup.rs';s=p.read_text(encoding='utf-8');a=s.index('pub trait NativeTerminalSourcesServices');b=s.index('#[cfg(test)]',a)
t=s[a:b].replace('NativeTerminalSourcesServices','NativeTerminalActionSourcesServices').replace('TerminalSources','TerminalActionSources').replace('cleanup_native_terminal_sources','cleanup_native_terminal_action_sources')
t=t.replace('crate::audio_path_source_terminal_cleanup::Services{}','crate::audio_path_source_terminal_cleanup::Services+crate::audio_path_source_action_list_cleanup::Services{}').replace('crate::audio_path_source_terminal_cleanup::Services>','crate::audio_path_source_terminal_cleanup::Services+crate::audio_path_source_action_list_cleanup::Services>')
t=t.replace('manager:u32,callback_manager:u32,downstream:', 'manager:u32,callback_manager:u32,registry:u32,downstream:')
t=t.replace('crate::audio_path_source_terminal_cleanup::release_reference(&mut c.memory,&mut c.retired,r,self.manager,c.pool,c.owner_manager,self.callback_manager,self.downstream)', 'crate::audio_path_source_action_list_cleanup::release_reference_native_actions(&mut c.memory,&mut c.retired,r,self.manager,c.pool,self.registry,c.owner_manager,self.callback_manager,self.downstream)')
t=t.replace('source_manager:u32,callback_manager:u32,s:', 'source_manager:u32,callback_manager:u32,action_registry:u32,s:').replace('manager:source_manager,callback_manager,downstream:s','manager:source_manager,callback_manager,registry:action_registry,downstream:s')
s=s[:b]+'/// Complete terminal-source/action graph dispatch with shared live allocations.\n'+t+s[b:];p.write_text(s,encoding='utf-8')
p=r/'crates/core/src/audio_path_voice_control_drain.rs';s=p.read_text(encoding='utf-8');s=s.replace('struct Pipeline{terminal_sources:', 'struct Pipeline{terminal_actions:bool,terminal_sources:').replace('Pipeline{terminal_sources:','Pipeline{terminal_actions:false,terminal_sources:')
s=s.replace('let result=if self.terminal_sources{','let result=if self.terminal_actions{crate::audio_path_voice_cleanup::cleanup_native_terminal_action_sources(&mut c,v,&mut heads,0x4001a000,0,0x40001000,self)}else if self.terminal_sources{')
pos=s.index(' impl crate::audio_path_voice_destructor::Services for Pipeline')
impl="""
 impl crate::audio_path_source_action_list_cleanup::Services for Pipeline{
 fn observe_destroy_action_list(&mut self,r:u32,arg:u32,_:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"destroy_action_list","receiver":r,"argument":arg}));}
 fn observe_source_virtuald0(&mut self,r:u32,_:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"source_virtuald0","receiver":r}));}
 fn observe_source_virtualcc(&mut self,r:u32,_:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"source_virtualcc","receiver":r}));}
 fn observe_registry_unlink(&mut self,r:u32,key:u32,action:u32,_:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"remove_action_registry","receiver":r,"key":key,"action":action}));}
 fn observe_child_reference_release(&mut self,r:u32,_:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"source_virtual08","receiver":r}));}
 fn source_virtuald0(&mut self,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{Err(Error::Backend("native terminal action dispatcher must execute D0 directly"))}
 }
"""
s=s[:pos]+impl+s[pos:]
a=s.index(' #[test]fn audio_path_voice_control_drain_matches512_native_actual_last_source_reference_manager_unlink_complete_source_voice_destructors_and_canonical_lifetime_cases') if ' #[test]fn audio_path_voice_control_drain_matches512_native_actual_last_source_reference_manager_unlink_complete_source_voice_destructors_and_canonical_lifetime_cases' in s else s.index(' #[test] fn audio_path_voice_control_drain_matches512_native_actual_last_source_reference_manager_unlink_complete_source_voice_destructors_and_canonical_lifetime_cases')
b=s.find('\n #[test]',a+10);b=s.rfind('\n}') if b<0 else b
t=s[a:b].replace('audio_path_voice_control_drain_matches512_native_actual_last_source_reference_manager_unlink_complete_source_voice_destructors_and_canonical_lifetime_cases','audio_path_voice_control_drain_matches512_native_complete_voice_last_source_nonempty_action_registry_children_base_query_and_all_physical_lifetime_cases').replace('audio_path_voice_control_drain_terminal_source_preparation.json','audio_path_voice_control_drain_terminal_actions_preparation.json').replace('terminal_actions:false','terminal_actions:true')
extra=[('action_registry',0x40001000,12,12),('action_registry_table',0x40001100,24,24),('action_registry_owners',0x40001200,192,64),('actions',0x40002000,384,128),('action_tables',0x40003000,192,64),('action_properties',0x4000b000,384,128),('child_sources',0x4000e000,768,256)]
load='for(n,base,size,chunk)in ['+','.join(f'("{n}",{base},{size},{chunk})'for n,base,size,chunk in extra)+']{let raw=bytes(b[n].as_str().unwrap());assert_eq!(raw.len(),size);for(j,part)in raw.chunks(chunk).enumerate(){let reference=base+j as u32*chunk as u32;assert!(c.memory.insert(reference,Memory{reference,raw:part.to_vec()}).is_none());}}'
assert 'let raw=bytes(b["references"].as_str().unwrap());' in t;t=t.replace('let raw=bytes(b["references"].as_str().unwrap());',load+'let raw=bytes(b["references"].as_str().unwrap());')
fields=','.join(f'"{n}":hex(&(0..{size}).map(|offset|crate::audio_path_memory::read(&backend.cleanup.memory,{base}+offset,1).unwrap()[0]).collect::<Vec<_>>())'for n,base,size,chunk in extra)+','
t=t.replace('json!({"source_manager":','json!({'+fields+'"source_manager":')
checks='for j in 0..3u32{let gone=row["selector"]==4&&j<row["count"].as_u64().unwrap()as u32;for base in [0x40002000,0x40003000,0x4000b000]{let stride=if base==0x40003000{64}else{128};assert_eq!(backend.cleanup.retired.contains(&(base+j*stride)),gone,"action physical lifetime {i}");}assert!(!backend.cleanup.retired.contains(&(0x4000e000+j*256)));}'
t=t.replace('for source in [0x40011000u32',checks+'for source in [0x40011000u32')
pos=s.rfind('\n}');s=s[:pos]+t+s[pos:];p.write_text(s,encoding='utf-8');print('Added production terminal-action voice cleanup dispatcher and512 full native pipeline replay')
