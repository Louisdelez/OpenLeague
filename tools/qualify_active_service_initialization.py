from pathlib import Path
import json,itertools
root=Path('E:/OpenLeague');source=(root/'tools/qualify_metadata_real_pending_service.py').read_text().split('\ncases=[]')[0]
exec(compile(source,str(root/'tools/qualify_metadata_real_pending_service.py'),'exec'))
cases=[]
for poison,opaque in itertools.product([0,165],[0,165]):
 cursor=arena;fail=False;write32(0x14bef40,0);write32(0x14bef58,0);u.mem_write(0x2d77b20,b'\1');u.mem_write(service,bytes([poison])*0x188);write32(service,0x10afe8c)
 for i in [12,16,20]:write32(service+i,0)
 u.mem_write(heap+0x9000,bytes([opaque]));allocations.clear();freed.clear();call(0x7306c0,service+24,[0,0]);call(0x7307f0,service+56,[heap+0x9000,0])
 words=[[service+i,read32(service+i)] for i in range(24,92,4)]
 for a in allocations:words.extend([[a['pointer']+i,read32(a['pointer']+i)] for i in range(0,a['bytes'],4)])
 initial_allocations=list(allocations);initial_freed=list(freed);queries=[]
 for field in [0,heap+0x4000,heap+0x417c,0xffffffff]:
  allocations.clear();freed.clear();call(0x72c620,service,[field]);queries.append({'field':field,'allocations':list(allocations),'freed':list(freed)});assert not allocations and not freed
 assert all(read32(a)==v for a,v in words)
 cases.append({'poison':poison,'opaque_byte':opaque,'service':service,'allocations':initial_allocations,'freed':initial_freed,'words':words,'missing_queries':queries})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Actual7306C0 compound descriptor registry and7307F0 owner/storage identity registry construction at service+24/+56 execute, with actual sentinel/bucket helpers. Four native initializations and16 real72C620->72D510->72EE20 active-missing removals run without constructor/lookup helper result adapters.','Caller-owned service188 bytes with empty pending vector; whole72A3B0 constructor not executed. Active registries remain empty; this proof does not cover activation, active insertion, matching removal or event dispatch. Allocator startup preconfigured, primitive allocators/memmove provided; opaque constructor byte supplied explicitly.']}
(root/'data/4.20/audio_announcer_active_service_initialization_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'native_active_registry_initializations':len(cases),'native_missing_active_removals':16,'passed':True}))
