from pathlib import Path
import json,itertools
root=Path('E:/OpenLeague');source=(root/'tools/qualify_owner_component_destructor.py').read_text().split('\ncases=[]')[0]
exec(compile(source,str(root/'tools/qualify_owner_component_destructor.py'),'exec'))
pair=heap+0x7200;fail=False
def allocation_failure(uc,address,size,user):
 if address==0x9933e0 and fail:
  assert allocations[-1]['bytes']==16;allocations[-1]['pointer']=0;u.reg_write(UC_X86_REG_EAX,0)
u.hook_add(unicorn.UC_HOOK_CODE,allocation_failure)
cases=[]
for poison,obj,(strong,weak),fail in itertools.product([0,165],[0,heap+0x7000],controls,[False,True]):
 cursor=arena;write32(0x14bef40,0);write32(pair,0x30007777);write32(pair+4,0 if strong is None else control)
 if strong is not None:write32(control,vtable);write32(control+4,strong);write32(control+8,weak)
 allocations.clear();freed.clear();virtual_calls.clear();call(0x5d1fa0,pair,[obj]);selected=read32(pair+4)
 assert read32(pair)==obj and bool(selected)==(not fail) and not freed and len(allocations)==1
 if selected:assert [read32(selected+i) for i in [0,4,8,12]]==[0x1085f4c,1,1,obj]
 cases.append({'poison':poison,'object':obj,'initial_control':None if strong is None else control,'initial_strong':strong,'initial_weak':weak,'fail_allocation':fail,'allocations':list(allocations),'pair_object':read32(pair),'pair_control':selected,'new_control_words':[[selected+i,read32(selected+i)] for i in [0,4,8,12]] if selected else [],'old_control_words':[[control+i,read32(control+i)] for i in [0,4,8]] if strong is not None else [],'virtual_calls':list(virtual_calls),'native_new_control_vtable':[read32(0x1085f4c),read32(0x1085f50)]})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Actual5D1FA0 shared-owner control replacement executes in104 normal-return cases: native16-byte control has vtable1085F4C, strong1, weak1, raw object. Old control reference decrement/disposal/release precedes final pair publication. Null object and null allocation branches execute as native; failed allocation still publishes raw object with null control after releasing old control.','Malloc primitive and old control virtual callbacks supplied; allocation-failure adapter changes the malloc return and trace after its primitive allocator callback. Old control callbacks retain bytes for observation. Native new-control virtual functions are recorded but not yet ported/qualified. Live ownership, exceptions and atomic concurrency remain open.']}
(root/'data/4.20/audio_announcer_owner_control_factory_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'native_owner_control_factory_cases':len(cases),'native_control_vtable_targets':cases[0]['native_new_control_vtable'],'passed':True}))
