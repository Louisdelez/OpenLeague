from pathlib import Path
import json,itertools
root=Path('E:/OpenLeague');source=(root/'tools/qualify_owner_control_factory.py').read_text().split('\ncases=[]')[0]
exec(compile(source,str(root/'tools/qualify_owner_control_factory.py'),'exec'))
obj=heap+0x7000;object_vtable=heap+0x7300;object_delete=end+0xe00;object_calls=[]
write32(obj,object_vtable);write32(obj+0x30,owner_storage);write32(object_vtable,object_delete)
def object_boundary(uc,address,size,user):
 if address==object_delete:
  sp=u.reg_read(UC_X86_REG_ESP);assert u.reg_read(UC_X86_REG_ECX)==obj and read32(sp+4)==1
  object_calls.append({'object':obj,'flags':read32(sp+4)});finish(4,obj)
u.hook_add(unicorn.UC_HOOK_CODE,object_boundary)
cases=[]
for poison,strong,weak,owner_id in itertools.product([0,165],[0,1,2,0xffffffff],[0,1,2,0xffffffff],[42,0xffffffff]):
 cursor=arena;manager=0x2d5f470;write32(0x14bef40,0);opaque=heap+0x9000;u.mem_write(opaque,bytes([poison]));call(0x664e50,manager,[opaque,0])
 for offset in [36,40,44]:write32(manager+offset,0)
 write32(component+4,0);write32(component+8,0);write32(owner_storage,owner_id);fail=False;call(0x5d1fa0,component+4,[obj]);selected=read32(component+8);assert read32(component+4)==obj and selected!=0
 write32(selected+4,strong);write32(selected+8,weak)
 if owner_id!=0xffffffff:call(0x6b59f0,0,[component,owner_id])
 initial=snapshot(manager);allocations.clear();freed.clear();locks.clear();diagnostics.clear();virtual_calls.clear();object_calls.clear();call(0x6b2b20,component,[])
 assert not allocations and not diagnostics and not virtual_calls
 assert len(object_calls)==int(strong==1) and (selected in freed)==(strong==1 and weak==1)
 cases.append({'poison':poison,'strong':strong,'weak':weak,'owner_id':owner_id,'object':obj,'component':component,'control':selected,'native_control_vtable':[read32(0x1085f4c+i) for i in [0,4,8]],'initial_words':initial,'words':snapshot(manager),'object_delete_calls':list(object_calls),'freed':list(freed),'locks':list(locks),'control_freed':selected in freed,'retained_component_control':read32(component+8),'live_control_words':[[selected+i,read32(selected+i)] for i in [0,4,8,12]] if selected not in freed else []})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['64 complete native control lifetimes execute actual5D1FA0 construction,6B2B20 owner-component destructor,5A3220 raw-object disposal,5D5B40 control release and real slot8 scalar control delete. Native control16-byte allocation, real vtable, strong/weak transitions and control free execute without control virtual-result adapters.','Raw-object scalar delete callback supplied and records object/flag1 without releasing its bytes; object-specific metadata destructor remains open. Malloc/free, engine array allocator, locks/memmove primitives and explicit metadata fields supplied. No post-free control reads retained. Live concurrency, exceptions and full actor destructor remain open.']}
(root/'data/4.20/audio_announcer_owner_real_control_lifecycle_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'native_owner_real_control_lifetimes':len(cases),'native_control_vtable_targets':cases[0]['native_control_vtable'],'passed':True}))
