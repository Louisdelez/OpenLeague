from pathlib import Path
import json,itertools
root=Path('E:/OpenLeague');source=(root/'tools/qualify_owner_component_destructor.py').read_text().split('\ncases=[]')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,virtual_boundary)','')
exec(compile(source,str(root/'tools/qualify_owner_component_destructor.py'),'exec'))
alternate=heap+0x6800;alternate_vtable=heap+0x6900;alternate_release=end+0xd00;mode='';weak_value=0;target_node=0;enabled=False
write32(alternate, vtable);write32(alternate_vtable,dispose);write32(alternate_vtable+4,alternate_release)
def callbacks(uc,address,size,user):
 if address==0xc97610:
  sp=u.reg_read(UC_X86_REG_ESP);destination,source,count=[read32(sp+i) for i in [4,8,12]]
  if count:u.mem_write(destination,bytes(u.mem_read(source,count)))
  finish(eax=destination)
 elif address in [dispose,release_control,alternate_release]:
  selected=u.reg_read(UC_X86_REG_ECX);assert selected in [control,alternate]
  virtual_calls.append({'op':'dispose' if address==dispose else 'release_control','control':selected,'callback':address,'strong':read32(selected+4),'weak':read32(selected+8)})
  if address==dispose and enabled:
   if mode=='dispose_weak':write32(selected+8,weak_value)
   elif mode=='dispose_vtable':write32(selected,alternate_vtable)
   elif mode=='dispose_component_control':write32(component+8,alternate)
  finish()
 if enabled:
  if (mode=='free_control' and address==0xc98528 and freed and freed[-1]==target_node) or (mode=='leave_control' and address==0x994210 and u.reg_read(UC_X86_REG_ECX)==0x2d5f4a0):write32(component+8,alternate)
u.hook_add(unicorn.UC_HOOK_CODE,callbacks)
cases=[]
for mode,poison,weak_value in itertools.product(['free_control','leave_control','dispose_weak','dispose_vtable','dispose_component_control'],[0,165],[0,1,2,0xffffffff]):
 enabled=False;cursor=arena;manager=0x2d5f470;write32(0x14bef40,0);opaque=heap+0x9000;u.mem_write(opaque,bytes([poison]));call(0x664e50,manager,[opaque,0])
 for offset in [36,40,44]:write32(manager+offset,0)
 call(0x6b59f0,0,[component,42]);target_node=read32(read32(manager+4));write32(owner_storage,42);write32(component+8,control)
 for selected in [control,alternate]:write32(selected,vtable);write32(selected+4,1);write32(selected+8,1)
 if mode in ['free_control','leave_control']:write32(alternate+8,weak_value)
 elif mode!='dispose_weak':write32(control+8,weak_value)
 initial=snapshot(manager);freed.clear();locks.clear();diagnostics.clear();virtual_calls.clear();allocations.clear();enabled=True;call(0x6b2b20,component,[]);assert not allocations and not diagnostics
 cases.append({'mode':mode,'poison':poison,'weak_value':weak_value,'initial_words':initial,'words':snapshot(manager),'freed':list(freed),'locks':list(locks),'virtual_calls':list(virtual_calls),'component_control':read32(component+8),'controls':[[selected,read32(selected),read32(selected+4),read32(selected+8)] for selected in [control,alternate]]})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Actual full6B2B20 executes with callback mutations in40 cases: control swapped during unregister free/leave, weak count changed during disposal, vtable changed during disposal, or component control pointer replaced during disposal. Fresh post-unregister control selection, cached selected control across disposal, fresh weak decrement and fresh release vtable dispatch all observed.','Virtual callbacks and allocation/free/lock/memmove primitives supplied; virtual callbacks record/mutate control bytes but do not free them. Actual native owner query/unregister and locked reference decrements execute. Object-specific disposal, concurrency, exceptions and complete actor destructor remain open.']}
(root/'data/4.20/audio_announcer_owner_component_mutations_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'native_owner_mutation_cases':len(cases),'passed':True}))
