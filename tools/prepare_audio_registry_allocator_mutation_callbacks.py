from pathlib import Path
r=Path('E:/OpenLeague');s=(r/'tools/probe_native_audio_registry_selected_child_callbacks.py').read_text(encoding='utf-8')
s=s.replace('child_properties=vector+0x12000','child_properties=vector+0x12000;alternate_properties=vector+0x13000')
s=s.replace("('selected_properties',child_properties,32)]","('selected_properties',child_properties,32),('alternate_properties',alternate_properties,48)]")
s=s.replace("failure='none';owner_index", "failure='none';mutated=False;mutation='none';owner_index")
s=s.replace('global owner_index,binding_index','global owner_index,binding_index,mutated')
s=s.replace('finish(result);return','''if size==56 and not mutated:
   mutated=True
   if mutation=='selected_blob_swap':w(child+16,alternate_properties)
   elif mutation=='selected_table_swap':w(child_table+4,0)
   elif mutation=='action_blob_swap':w(action+16,alternate_properties)
   elif mutation=='queue_capacity_zero':w(manager+24,0)
   else:raise AssertionError(mutation)
  finish(result);return''')
s=s.replace('time,instant,child_kind in itertools.product','time,instant,child_kind,mutation in itertools.product')
s=s.replace("[0,1,97],[35],[0,1],['first_duplicate','missing_key','zero_count_padding']", "[0,97],[35],[0,1],['first_duplicate'],['selected_blob_swap','selected_table_swap','action_blob_swap','queue_capacity_zero']")
s=s.replace('owner_index=binding_index=0;key=', 'owner_index=binding_index=0;mutated=False;key=')
needle='w(source,0xff1cd8);'
inject='''u.mem_write(alternate_properties,bytes([5,0,1,2,3,4]))
 for i,bits in enumerate([0x40a00000,0x40800000,0xc0000000,0x3f000000,0xbf000000]):
  if mutation=='action_blob_swap':w(alternate_properties+8+i*8,bits);w(alternate_properties+12+i*8,0)
  else:w(alternate_properties+8+i*4,bits)
 '''
s=s.replace(needle,inject+needle).replace("'child_kind':child_kind,", "'mutation':mutation,'child_kind':child_kind,")
s=s.replace('audio_registry_selected_child_callbacks_preparation.json','audio_registry_allocator_mutation_callbacks_preparation.json')
s=s.replace('Rust replay pending.', 'Allocation adapter changes selected property pointer, selected table entry, action property pointer or queue capacity after its recorded entry snapshot and before returning. Mutation occurs on first56-byte allocation call, even when that call returnsNULL. Rust replay pending.')
(r/'tools/probe_native_audio_registry_allocator_mutation_callbacks.py').write_text(s,encoding='utf-8');print('Prepared allocation-mutation original-runtime probe')
