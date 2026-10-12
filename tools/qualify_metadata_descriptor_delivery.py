from pathlib import Path
import json,itertools
root=Path('E:/OpenLeague');source=(root/'tools/qualify_owner_metadata_lifecycle.py').read_text().split('\ncases=[]')[0]
exec(compile(source,str(root/'tools/qualify_owner_metadata_lifecycle.py'),'exec'))
cases=[]
for poison,(offset,method,code),owner_id,sentinel in itertools.product([0,165],[(0,0x6b9680,0x51),(8,0x6b96c0,0x35),(16,0x6b9700,0xe0),(24,0x6b9740,0xe1)],[0,42,0xffffffff],[0,0xffffffff]):
 cursor=arena;fail=False;write32(0x14bef40,0);write32(0x14bef58,0);u.mem_write(0x2d77b20,b'\1');write32(0x2d787b8,0);write32(0x123b12c,0);write32(0x2d5f448,sentinel);write32(heap+0x5600,owner_id);allocations.clear();freed.clear()
 metadata=call(0x9933e0,0,[56]);call(0x6b26f0,metadata,[heap+0x4000,heap+0x5600]);callback=call(0x9933e0,0,[12]);write32(callback,0x1086078);write32(callback+4,metadata+offset);write32(callback+8,method);packet=heap+0x7800;u.mem_write(packet,bytes([poison])*20);before=bytes(u.mem_read(packet,20)).hex();allocations.clear();freed.clear()
 returned=call(0x5cce30,callback,[packet])&255;after=bytes(u.mem_read(packet,20)).hex();assert returned==int(owner_id!=sentinel)
 cases.append({'poison':poison,'offset':offset,'method':method,'event_code':code,'owner_id':owner_id,'sentinel':sentinel,'metadata':metadata,'callback':callback,'packet':packet,'packet_before':before,'packet_after':after,'return_al':returned,'allocations':list(allocations),'freed':list(freed)})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Actual5CCE30 callback delivery executes native descriptor methods, actual adjustor thunks and6B28A0 borrowed-owner read after original metadata construction;48 descriptor cases cover four event codes, owner and sentinel identity, packet padding and AL return. No descriptor or owner helper-result adapter.','Callback objects/packet/owner storage supplied; constructor primitive allocators and absent-service precondition retained. Descriptor generation is not event service registration or event-consumer execution; generic65EE40 target dispatch, real service storage and actual actor lifetime remain open.']}
(root/'data/4.20/audio_announcer_owner_metadata_descriptor_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'native_descriptor_delivery_cases':len(cases),'passed':True}))
