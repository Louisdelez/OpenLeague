from pathlib import Path
import json,itertools
root=Path('E:/OpenLeague')
source=(root/'tools/qualify_owner_metadata_lifecycle.py').read_text().split('\ncases=[]')[0]
exec(compile(source,str(root/'tools/qualify_owner_metadata_lifecycle.py'),'exec'))
service=heap+0x6000;service_vtable=heap+0x6100
events=[];mode=0
def service_boundary(uc,address,size,user):
 if address not in [end+0x1000,end+0x1100]:return
 sp=u.reg_read(UC_X86_REG_ESP);field=read32(sp+4);assert u.reg_read(UC_X86_REG_ECX)==service
 if address==end+0x1000:
  temporary=read32(read32(sp+8));events.append({'op':'register','field':field,'handler':read32(field),'temporary':temporary,'owner':read32(temporary+4),'method':read32(temporary+8)})
  if mode==1:write32(0x2d787b8,0)
  finish(pop=8)
 else:
  events.append({'op':'unregister','field':field,'handler':read32(field)})
  if mode==2:write32(0x2d787b8,0)
  finish(pop=4)
u.hook_add(unicorn.UC_HOOK_CODE,service_boundary)
cases=[]
for poison,flags,mode in itertools.product([0,165],[0,1,256,257],[0,1,2]):
 cursor=arena;fail=False;write32(0x14bef40,0);write32(0x14bef58,0);u.mem_write(0x2d77b20,b'\1');write32(0x2d787b8,service);write32(0x123b12c,0x3f800000);write32(service,service_vtable);write32(service_vtable+0x84,end+0x1000);write32(service_vtable+0x88,end+0x1100);allocations.clear();freed.clear();events.clear()
 metadata=call(0x9933e0,0,[56]);assert call(0x6b26f0,metadata,[heap+0x4000,heap+0x5600])==metadata
 words=[[metadata+i,read32(metadata+i)] for i in range(0,56,4)];created_allocations=list(allocations);created_freed=list(freed);created_events=list(events);allocations.clear();freed.clear();events.clear()
 assert call(0x6b28c0,metadata,[flags])==metadata
 cases.append({'poison':poison,'flags':flags,'mode':mode,'metadata':metadata,'constructed_words':words,'constructor_allocations':created_allocations,'constructor_freed':created_freed,'constructor_events':created_events,'destructor_freed':list(freed),'destructor_events':list(events),'final_service':read32(0x2d787b8),'live_words':[[metadata+i,read32(metadata+i)] for i in range(0,56,4)] if flags&1==0 else []})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Actual native metadata construction/destruction executes with service manager present;24 cases cover exact slot84/88 arguments, four registration methods, reverse unregistration order and service removal during first registration/unregistration. Service virtual functions are supplied primitive boundaries recording calls and controlled global mutation; their native implementation/event delivery is not qualified here.','Allocator startup preconfigured; malloc/free/operator-new primitives supplied. No post-free metadata snapshots. Live game ownership/service implementation, exceptions and event dispatch remain open.']}
(root/'data/4.20/audio_announcer_owner_metadata_service_boundary_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'native_service_boundary_cases':len(cases),'passed':True}))
