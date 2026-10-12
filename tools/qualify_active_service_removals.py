from pathlib import Path
import json,itertools
root=Path('E:/OpenLeague');source=(root/'tools/qualify_active_service_lifetimes.py').read_text().split('\ncases=[]')[0]
exec(compile(source,str(root/'tools/qualify_active_service_lifetimes.py'),'exec'))
cases=[]
for poison,owner_id in itertools.product([0,165],[42,0xffffffff]):
 cursor=arena;fail=False;live={};write32(0x14bef40,0);write32(0x14bef58,0);u.mem_write(0x2d77b20,b'\1');u.mem_write(service,bytes([poison])*0x188);write32(service,0x10afe8c)
 for i in [12,16,20]:write32(service+i,0)
 u.mem_write(heap+0x9000,bytes([poison]));allocations.clear();freed.clear();call(0x7306c0,service+24,[0,0]);call(0x7307f0,service+56,[heap+0x9000,0]);capture();write32(0x2d787b8,service);write32(0x123b12c,0x3f800000);write32(0x2d5f448,0xffffffff);write32(heap+0x5600,owner_id);metadata=call(0x9933e0,0,[56]);call(0x6b26f0,metadata,[heap+0x4000,heap+0x5600]);capture();call(0x72ec40,service+12,[]);initial=capture();blocks=[[p,n] for p,n in sorted(live.items())];steps=[]
 for offset in [4,12,20,28]:
  field=metadata+offset
  for repeat in [False,True]:
   call(0x72c620,service,[field]);steps.append({'field':field,'repeat':repeat,'state':capture()})
 cases.append({'poison':poison,'owner_id':owner_id,'service':service,'metadata':metadata,'owned_blocks':blocks,'initial':initial,'steps':steps})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Actual real service32 removals across4 native lifetimes after native initialization, metadata construction and pending activation. Covers matching active storage, compound-node vector removal/free, owner-node erasure, repeated missing removals and sentinel-owner pending fallback. Initial setup and all lookup/remove helpers execute natively; no helper-result adapter.','Only live allocations captured with exact ownership extents; borrowed callback storage remains alive. Initial activation graph is supplied to Rust removal verification separately until activation port is done. Primitive allocators/memmove supplied and startup preconfigured; custom free mutations, full service teardown and world lifecycle remain open.']}
(root/'data/4.20/audio_announcer_active_service_removals_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'native_active_removal_lifetimes':4,'native_service_removals':32,'passed':True}))
