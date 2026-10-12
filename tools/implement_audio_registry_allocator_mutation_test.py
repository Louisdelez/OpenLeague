from pathlib import Path
p=Path('E:/OpenLeague/crates/core/src/audio_action_registry_value_update.rs');s=p.read_text(encoding='utf-8');head,body=s.split('#[cfg(test)]mod native_callback_tests{',1)
assert 'mutation:String' not in body
body=body.replace('allocated:Vec<(u32,u32)>','allocated:Vec<(u32,u32)>,mutation:String,mutated:bool')
body=body.replace('allocated:vec![]','allocated:vec![],mutation:String::new(),mutated:false')
body=body.replace('fn allocate(&mut self,p:u32,size:u32,m:&BTreeMap<u32,Memory>)','fn allocate(&mut self,p:u32,size:u32,m:&mut BTreeMap<u32,Memory>)')
needle='if result!=0{self.allocated.push((result,size));}Ok((result!=0).then_some(result))'
assert needle in body
body=body.replace(needle,'''if result!=0{self.allocated.push((result,size));}
 if size==56&&!self.mutated&&!self.mutation.is_empty(){self.mutated=true;let(at,value)=match self.mutation.as_str(){"selected_blob_swap"=>(0x40010010,0x40013000),"selected_table_swap"=>(0x40011004,0),"action_blob_swap"=>(0x40004010,0x40013000),"queue_capacity_zero"=>(0x40008018,0),_=>return Err(Error::Backend("unknown native allocator mutation"))};put(m,&BTreeSet::new(),at,4,value)?;}
 Ok((result!=0).then_some(result))''')
marker=' #[test]fn audio_registry_selected_child_callbacks_matches288';test=body[body.index(marker):];assert test.endswith('}\n');test=test[:-2]
test=test.replace('audio_registry_selected_child_callbacks_matches288_original_first_duplicate_later_match_zero_count_padding_targets_transition_lifetimes_and_active_voice_physical_cases','audio_registry_allocator_mutation_callbacks_matches256_original_selected_blob_table_action_blob_queue_capacity_reloads_cached_values_oom_and_complete_physical_lifetimes')
test=test.replace('audio_registry_selected_child_callbacks_preparation.json','audio_registry_allocator_mutation_callbacks_preparation.json').replace('p["case_count"],288','p["case_count"],256')
test=test.replace('"selected_properties"=>"selected_properties",','"selected_properties"=>"selected_properties","alternate_properties"=>"alternate_properties",')
test=test.replace('mutation:String::new(),mutated:false','mutation:row["mutation"].as_str().unwrap().to_owned(),mutated:false')
body=body[:-2]+test+'}\n';p.write_text(head+'#[cfg(test)]mod native_callback_tests{'+body,encoding='utf-8');print('Added256 canonical allocator mutation lifecycle replays')
