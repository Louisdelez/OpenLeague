from pathlib import Path
import json,itertools
root=Path('E:/OpenLeague');source=(root/'tools/qualify_active_service_lifetimes.py').read_text().split('\ncases=[]')[0]
exec(compile(source,str(root/'tools/qualify_active_service_lifetimes.py'),'exec'))
cases=[]
for poison,second_owner in itertools.product([0,165],[42,43]):
 cursor=arena;fail=False;live={};write32(0x14bef40,0);write32(0x14bef58,0);u.mem_write(0x2d77b20,b'\1');u.mem_write(service,bytes([poison])*0x188);write32(service,0x10afe8c)
 for i in [12,16,20]:write32(service+i,0)
 u.mem_write(heap+0x9000,bytes([poison]));allocations.clear();freed.clear();call(0x7306c0,service+24,[0,0]);call(0x7307f0,service+56,[heap+0x9000,0]);capture();write32(0x2d787b8,service);write32(0x123b12c,0x3f800000);write32(0x2d5f448,0xffffffff);metadata_labels=[]
 for storage,owner in [(heap+0x5600,42),(heap+0x5610,second_owner)]:
  write32(storage,owner);metadata=call(0x9933e0,0,[56]);call(0x6b26f0,metadata,[heap+0x4000,storage]);metadata_labels.append(metadata)
 capture();call(0x72ec40,service+12,[]);initial=capture();blocks=[[p,n] for p,n in sorted(live.items())];steps=[]
 for offset in [4,12,20,28]:
  for metadata in metadata_labels:
   for repeat in [False,True]:
    field=metadata+offset;call(0x72c620,service,[field]);steps.append({'field':field,'repeat':repeat,'state':capture()})
 assert read32(service+28)==0 and read32(service+64)==0
 cases.append({'poison':poison,'second_owner':second_owner,'service':service,'metadata_labels':metadata_labels,'owned_blocks':blocks,'initial':initial,'steps':steps})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Actual initialization, two metadata constructions, eight pending activations and64 native service removals across4 lifetimes. Same-owner metadata share four descriptor vectors; distinct owners create separate compound entries. Intermediate removal preserves remaining callback storage and keeps nonempty nodes, later removal frees them. Repeated missing callbacks covered. No helper-result adapters.','Rust activation/insertion still to port; initial native-activated graphs supplied for removal comparison. Primitive allocators/memmove provided, startup preconfigured; no live simulation or full service teardown claimed.']}
(root/'data/4.20/audio_announcer_shared_active_service_removals_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'native_shared_active_lifetimes':len(cases),'native_service_removals':64,'passed':True}))
