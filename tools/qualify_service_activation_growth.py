from pathlib import Path
import json,itertools
root=Path('E:/OpenLeague');source=(root/'tools/qualify_active_service_lifetimes.py').read_text().split('\ncases=[]')[0]
exec(compile(source,str(root/'tools/qualify_active_service_lifetimes.py'),'exec'))
cases=[]
for poison,count,shared_owner in itertools.product([0,165],[2,9],[False,True]):
 cursor=arena;fail=False;live={};write32(0x14bef40,0);write32(0x14bef58,0);u.mem_write(0x2d77b20,b'\1');u.mem_write(service,bytes([poison])*0x188);write32(service,0x10afe8c)
 for i in [12,16,20]:write32(service+i,0)
 u.mem_write(heap+0x9000,bytes([poison]));allocations.clear();freed.clear();call(0x7306c0,service+24,[0,0]);call(0x7307f0,service+56,[heap+0x9000,0]);initial=capture();write32(0x2d787b8,service);write32(0x123b12c,0x3f800000);write32(0x2d5f448,0xffffffff);metadata_labels=[]
 for index in range(count):
  storage=heap+0x5600+index*4;write32(storage,42 if shared_owner else 42+index);metadata=call(0x9933e0,0,[56]);call(0x6b26f0,metadata,[heap+0x4000,storage]);metadata_labels.append(metadata)
 created=capture();activation_packets.clear();call(0x72ec40,service+12,[]);activated=capture();steps=[]
 for metadata in metadata_labels:
  call(0x6b28c0,metadata,[1]);steps.append(capture())
 assert read32(service+28)==0 and read32(service+64)==0 and read32(service+12)==read32(service+16)
 cases.append({'poison':poison,'count':count,'shared_owner':shared_owner,'metadata_labels':metadata_labels,'initial':initial,'created':created,'activation_packets':list(activation_packets),'activated':activated,'destroyed_steps':steps})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Eight actual native initialization/metadata creation/activation/destruction sequences with2 or9 components and distinct/shared owner IDs.36 identity entries trigger8-to64 registry growth; distinct owners also trigger compound registry rehash, shared owners grow callback vectors. Real descriptor callbacks, insertion/growth/rehash and active removal helpers run without helper-result adapters.','Service members initialized natively within caller-owned188-byte service storage, allocator startup preconfigured and primitive allocators/memmove supplied. Activation stack padding captured as explicit opaque input, not assigned gameplay semantics. Whole service constructor/settings, allocation failures, exceptions and world integration remain open.']}
(root/'data/4.20/audio_announcer_service_activation_growth_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'native_service_growth_sequences':len(cases),'native_metadata_components':sum(c['count'] for c in cases),'passed':True}))
