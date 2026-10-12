from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/core/src/audio_path_source_terminal_cleanup.rs';s=p.read_text(encoding='utf-8')
a=s.index('fn parent_child_remove(');b=s.index('\n/// Original code explicitly',a);part=s[a:b].replace('owner.wrapping_add(24)','owner.wrapping_add(36)').replace('owner.wrapping_add(28)','owner.wrapping_add(40)');s=s[:a]+part+s[b:]
s=s.replace('owned:bool,actions:bool}', 'owned:bool,actions:bool,parents:bool}')
s=s.replace('fn parent_virtual30(&mut self,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("parent30 excluded from fixture"))}', 'fn parent_virtual30(&mut self,parent:u32,source:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{if !self.parents{return Err(Error::Backend("parent30 excluded from fixture"));}self.calls.push(json!({"kind":"parent_virtual30","receiver":parent,"source":source}));Ok(())}')
s=s.replace('fn terminal(owned:bool){','fn terminal(owned:bool,parents:bool){').replace('if owned{include_str!("../../../data/4.20/audio_path_source_terminal_owned_release_preparation.json")}else','if parents{include_str!("../../../data/4.20/audio_path_source_terminal_parent_release_preparation.json")}else if owned{include_str!("../../../data/4.20/audio_path_source_terminal_owned_release_preparation.json")}else').replace('if owned{320}else{160}', 'if parents{480}else if owned{320}else{160}')
s=s.replace(' for(n,r,size)in &regions{insert', ' if parents{regions.extend([("parents",0x4000d000,512),("parent_owners",0x4000e000,512),("parent_tables",0x4000f100,128)]);}\n for(n,r,size)in &regions{insert',1)
s=s.replace('"nodes"=>16,_=>*size', '"nodes"=>16,"parents"|"parent_owners"=>256,"parent_tables"=>64,_=>*size')
s=s.replace('regions,owned,actions:false}', 'regions,owned,actions:false,parents}').replace('regions,owned:false,actions:true}', 'regions,owned:false,actions:true,parents:false}')
s=s.replace('terminal(false);','terminal(false,false);').replace('terminal(true);','terminal(true,false);')
a=s.rfind('\n}');s=s[:a]+'\n #[test]fn audio_path_source_terminal_cleanup_matches480_native_parent30_terminal_child_table36_count40_swap_last_and_exact_physical_lifetime_cases(){terminal(true,true);}\n'+s[a:]
p.write_text(s,encoding='utf-8');print('Fixed actual parent child offsets and added480 native parent terminal replay')
