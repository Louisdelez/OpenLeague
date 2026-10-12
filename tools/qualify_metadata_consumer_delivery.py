from pathlib import Path
import json,itertools
root=Path('E:/OpenLeague');source=(root/'tools/qualify_owner_metadata_lifecycle.py').read_text().split('\ncases=[]')[0]
exec(compile(source,str(root/'tools/qualify_owner_metadata_lifecycle.py'),'exec'))
events=[];gate=0
def consumer_boundary(uc,address,size,user):
 if address==end+0x1200:
  assert u.reg_read(UC_X86_REG_ECX)==heap+0x6000;events.append({'op':'gate','value':gate});finish(eax=gate)
 elif address in [end+0x1300,end+0x1400]:
  assert u.reg_read(UC_X86_REG_ECX)==heap+0x4000;events.append({'op':'actor','slot':0x24 if address==end+0x1300 else 0x2c,'flags_word':read32(metadata+36)});finish(eax=0xaabbccdd)
u.hook_add(unicorn.UC_HOOK_CODE,consumer_boundary)
cases=[]
for poison,offset,gate,index,mask in itertools.product([0,165],[0,8,16,24],[0,1,256],[0,3,4,31,32,255],[0,0xffffffff,0x12345678]):
 cursor=arena;fail=False;write32(0x14bef40,0);write32(0x14bef58,0);u.mem_write(0x2d77b20,b'\1');write32(0x2d787b8,0);write32(0x123b12c,0);allocations.clear();freed.clear();metadata=call(0x9933e0,0,[56]);call(0x6b26f0,metadata,[heap+0x4000,heap+0x5600]);write32(metadata+36,0xa5a5ffff);write32(metadata+40,mask)
 write32(0x2d787b8,heap+0x6000);write32(heap+0x6000,heap+0x6100);write32(heap+0x61b0,end+0x1200);write32(heap+0x4000,heap+0x4100);write32(heap+0x4124,end+0x1300);write32(heap+0x412c,end+0x1400)
 packet=heap+0x7800;u.mem_write(packet,bytes([poison])*20);u.mem_write(packet+5,bytes([index]));handler=read32(metadata+offset+4);events.clear();diagnostics.clear();allocations.clear();freed.clear();returned=call(0x5cce30,handler,[packet])&255;assert returned==1
 cases.append({'poison':poison,'offset':offset,'gate':gate,'index':index,'mask':mask,'metadata':metadata,'handler':handler,'packet':packet,'return_al':returned,'events':list(events),'diagnostics':list(diagnostics),'flags_word':read32(metadata+36),'result_mask':read32(metadata+40),'allocations':list(allocations),'freed':list(freed)})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Actual5CCE30 dispatches original constructor-created handlers through native65EE40 and all four real metadata consumer virtual methods.432 cases cover spectator AL gate (including256), actor slots24/2C, distinct flag bytes, mask set/clear, x86 shift masking and returning diagnostics for index>=4. No consumer-helper result adapters.','Game gate and actor virtual calls, diagnostic, allocators are supplied primitive boundaries. Actual actor method bodies, service event queue/storage, exceptions and world integration remain open.']}
(root/'data/4.20/audio_announcer_owner_metadata_consumer_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'native_consumer_delivery_cases':len(cases),'passed':True}))
