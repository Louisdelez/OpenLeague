from pathlib import Path
import json,itertools
root=Path('E:/OpenLeague');source=(root/'tools/qualify_active_service_lifetimes.py').read_text().split('\ncases=[]')[0]
exec(compile(source,str(root/'tools/qualify_active_service_lifetimes.py'),'exec'))
cases=[]
for poison,count,shared_owner in itertools.product([0,165],[0,9],[False,True]):
 cursor=arena;fail=False;live={};write32(0x14bef40,0);write32(0x14bef58,0);u.mem_write(0x2d77b20,b'\1');u.mem_write(service,bytes([poison])*0x188);write32(service,0x10afe8c)
 for i in [12,16,20]:write32(service+i,0)
 u.mem_write(heap+0x9000,bytes([poison]));allocations.clear();freed.clear();call(0x7306c0,service+24,[0,0]);call(0x7307f0,service+56,[heap+0x9000,0]);initial=capture();write32(0x2d787b8,service);write32(0x123b12c,0x3f800000);write32(0x2d5f448,0xffffffff);metadata_labels=[]
 for index in range(count):
  storage=heap+0x5600+index*4;write32(storage,42 if shared_owner else 42+index);metadata=call(0x9933e0,0,[56]);call(0x6b26f0,metadata,[heap+0x4000,storage]);metadata_labels.append(metadata)
 created=capture();activation_packets.clear();call(0x72ec40,service+12,[]);activated=capture();steps=[]
 for metadata in metadata_labels:
  call(0x6b28c0,metadata,[1]);steps.append(capture())
 before=capture();write32(0x2d787b8,0);call(0x72a600,service+12,[]);destroyed=capture();assert not live
 cases.append({'poison':poison,'count':count,'shared_owner':shared_owner,'metadata_labels':metadata_labels,'initial':initial,'created':created,'activation_packets':list(activation_packets),'activated':activated,'destroyed_steps':steps,'before_service_teardown':before,'service_destroyed':destroyed})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Actual native72A600 service-member teardown,5DE550 owner registry teardown and72D5A0/730F20 compound registry teardown run after orderly native metadata listener disposal. Empty and previously grown registries, distinct/shared owners, two allocator fill patterns; all owned native blocks freed. No service/registry teardown helper-result adapters.','Service storage caller-owned188 bytes; full72A530 service scalar destructor and72A3B0 startup/settings not executed. Primitive allocator/free/memmove supplied; default deallocator only, failures/exceptions/reentrant custom route mutations and invalid teardown-before-owner ordering remain open.']}
(root/'data/4.20/audio_announcer_service_member_teardown_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'native_service_member_teardowns':len(cases),'native_metadata_components':sum(c['count'] for c in cases),'passed':True}))
