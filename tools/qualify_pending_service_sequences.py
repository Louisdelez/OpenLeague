from pathlib import Path
import json,itertools
root=Path('E:/OpenLeague');source=(root/'tools/qualify_metadata_real_pending_service.py').read_text().split('\ncases=[]')[0]
exec(compile(source,str(root/'tools/qualify_metadata_real_pending_service.py'),'exec'))
cases=[]
for poison,count in itertools.product([0,165],[1,2,4,7,12]):
 cursor=arena;fail=False;write32(0x14bef40,0);write32(0x14bef58,0);u.mem_write(0x2d77b20,b'\1');write32(0x2d787b8,0);write32(0x123b12c,0);allocations.clear();freed.clear();metadata=call(0x9933e0,0,[56]);call(0x6b26f0,metadata,[heap+0x4000,heap+0x5600]);u.mem_write(service,bytes([poison])*0x188);write32(service,0x10afe8c)
 for i in [12,16,20]:write32(service+i,0)
 steps=[]
 for index in range(count):
  offset=(index%4)*8;field=metadata+offset+4;temporary=0;allocations.clear();freed.clear()
  if index%3!=0:
   temporary=call(0x9933e0,0,[12]);write32(temporary,0x1086078);write32(temporary+4,metadata+offset);write32(temporary+8,[0x6b9680,0x6b96c0,0x6b9700,0x6b9740][index%4])
  write32(heap+0x7900,temporary);call(0x72c610,service,[field,heap+0x7900])
  if temporary:call(0x578010,temporary,[1])
  steps.append({'op':'register','index':index,'field':field,'temporary':temporary,'allocations':list(allocations),'freed':list(freed),'pending_words':pending_snapshot()})
 for index in reversed(range(count)):
  field=metadata+(index%4)*8+4;allocations.clear();freed.clear();call(0x72c620,service,[field]);steps.append({'op':'unregister','index':index,'field':field,'allocations':list(allocations),'freed':list(freed),'pending_words':pending_snapshot()})
 assert read32(service+12)==read32(service+16)
 cases.append({'poison':poison,'count':count,'metadata':metadata,'steps':steps})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Actual72C610/72C620 pending registration/removal in10 original sequences,52 registrations and52 removals. Covers repeated handler-storage identities, null descriptors, growing1/2/3/4/6/9/13 pointer capacities and stable first-match removal. Actual clone/scalar/vector bodies execute without service/helper-result adapters.','Pending storage caller-initialized empty; active fallback is never reached. Metadata callbacks exist and remain caller-owned. Operator-new/malloc/free/memmove/engine pointer-array primitives supplied; allocator startup preconfigured. Pending allocation failure, active storage/dispatch and service teardown remain required.']}
(root/'data/4.20/audio_announcer_pending_service_sequences_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'native_pending_sequences':len(cases),'native_pending_registrations':sum(c['count'] for c in cases),'native_pending_removals':sum(c['count'] for c in cases),'passed':True}))
