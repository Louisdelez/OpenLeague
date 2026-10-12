from pathlib import Path
import json,itertools
root=Path('E:/OpenLeague');source=(root/'tools/qualify_owner_metadata_lifecycle.py').read_text().split('\ncases=[]')[0].replace("'callback_clone_new'","'engine_operator_new'")
exec(compile(source,str(root/'tools/qualify_owner_metadata_lifecycle.py'),'exec'))
service=heap+0x6000
def pending_snapshot():
 begin=read32(service+12);end_pointer=read32(service+16);words=[[service+i,read32(service+i)] for i in [12,16,20]]
 for pointer in range(begin,end_pointer,4):
  pair=read32(pointer);descriptor=read32(pair);words.extend([[pointer,pair],[pair,descriptor],[pair+4,read32(pair+4)]])
  if descriptor:words.extend([[descriptor+i,read32(descriptor+i)] for i in [0,4,8]])
 return words
cases=[]
for poison,flags,owner_id in itertools.product([0,165],[0,1,256,257],[42,0xffffffff]):
 cursor=arena;fail=False;write32(0x14bef40,0);write32(0x14bef58,0);u.mem_write(0x2d77b20,b'\1');u.mem_write(service,bytes([poison])*0x188);write32(service,0x10afe8c)
 for i in [12,16,20]:write32(service+i,0)
 write32(0x2d787b8,service);write32(0x123b12c,0x3f800000);write32(heap+0x5600,owner_id);allocations.clear();freed.clear();metadata=call(0x9933e0,0,[56]);assert call(0x6b26f0,metadata,[heap+0x4000,heap+0x5600])==metadata
 assert read32(service+16)-read32(service+12)==16
 constructor_allocations=list(allocations);constructor_freed=list(freed);constructed_words=[[metadata+i,read32(metadata+i)] for i in range(0,56,4)];pending=pending_snapshot();allocations.clear();freed.clear();assert call(0x6b28c0,metadata,[flags])==metadata;assert read32(service+16)==read32(service+12)
 cases.append({'poison':poison,'flags':flags,'owner_id':owner_id,'metadata':metadata,'constructor_allocations':constructor_allocations,'constructor_freed':constructor_freed,'constructed_words':constructed_words,'pending_words':pending,'destructor_freed':list(freed),'destructor_allocations':list(allocations),'empty_pending_words':pending_snapshot(),'live_words':[[metadata+i,read32(metadata+i)] for i in range(0,56,4)] if flags&1==0 else []})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Actual native metadata construction/destruction executes real service10AFE8C slots84/88,72C610/72C620,72D420/72D510 and real pending vector append/erase.16 native lifetimes include two descriptor clones per pending pair, callback/scalar disposal and full pending unregistration with actual native helpers; no service virtual result adapter.','Service188 bytes caller-owned, pending vector fields explicitly initialized empty without executing whole72A3B0 constructor. Active storage uninitialized/unused because all registered handlers remain pending until removed. Engine startup preconfigured; operator-new/malloc/free/memmove primitives supplied. Active registration processing, active storage lookup/removal, queue dispatch, service destruction and game integration remain open.']}
(root/'data/4.20/audio_announcer_owner_metadata_real_pending_service_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'native_real_pending_service_lifetimes':len(cases),'passed':True}))
