from pathlib import Path
import json,itertools
root=Path('E:/OpenLeague');source=(root/'tools/qualify_metadata_real_pending_service.py').read_text().split('\ncases=[]')[0]
exec(compile(source,str(root/'tools/qualify_metadata_real_pending_service.py'),'exec'))
events=[];activation_packets=[]
def actor_virtual(uc,address,size,user):
 if address==0x72ec81:activation_packets.append(bytes(u.mem_read(u.reg_read(UC_X86_REG_EBP)-0x2c,12)).hex())
 if address in [end+0x1300,end+0x1400]:
  assert u.reg_read(UC_X86_REG_ECX)==heap+0x4000;events.append({'slot':0x24 if address==end+0x1300 else 0x2c,'flags_word':read32(metadata+36)});finish()
u.hook_add(unicorn.UC_HOOK_CODE,actor_virtual)
def capture():
 global live
 allocated=list(allocations);released=list(freed)
 for a in allocated:live[a['pointer']]=a['bytes']
 for p in released:live.pop(p,None)
 result={'allocations':allocated,'freed':released,'words':[[service+i,read32(service+i)] for i in range(0,92,4)]}
 for p,n in sorted(live.items()):result['words'].extend([[p+i,read32(p+i)] for i in range(0,n,4)])
 allocations.clear();freed.clear();return result
cases=[]
for poison,owner_id,gate in itertools.product([0,165],[42,0xffffffff],[0,1]):
 cursor=arena;fail=False;live={};write32(0x14bef40,0);write32(0x14bef58,0);u.mem_write(0x2d77b20,b'\1');u.mem_write(service,bytes([poison])*0x188);write32(service,0x10afe8c)
 for i in [12,16,20]:write32(service+i,0)
 u.mem_write(heap+0x9000,bytes([poison]));allocations.clear();freed.clear();call(0x7306c0,service+24,[0,0]);call(0x7307f0,service+56,[heap+0x9000,0]);initial=capture();write32(0x2d787b8,service);write32(0x123b12c,0x3f800000);write32(0x2d5f448,0xffffffff);write32(heap+0x5600,owner_id);write32(heap+0x4000,heap+0x4100);write32(heap+0x4124,end+0x1300);write32(heap+0x412c,end+0x1400);u.mem_write(service+0x122,bytes([gate]));metadata=call(0x9933e0,0,[56]);call(0x6b26f0,metadata,[heap+0x4000,heap+0x5600]);created=capture();activation_packets.clear();call(0x72ec40,service+12,[]);activated=capture()
 dispatches=[]
 for code in [0x51,0x35,0xe0,0xe1]:
  descriptor=heap+0x7800;packet=heap+0x7900;u.mem_write(descriptor,bytes([poison])*12);write32(descriptor,owner_id);u.mem_write(descriptor+8,code.to_bytes(2,'little'));u.mem_write(packet,bytes([poison])*20);u.mem_write(packet+5,b'\3');events.clear();returned=call(0x72eec0,service+24,[descriptor,packet])&255;dispatches.append({'event_code':code,'return_al':returned,'actor_events':list(events),'state':capture()});assert returned==int(owner_id!=0xffffffff)
 call(0x6b28c0,metadata,[1]);destroyed=capture();assert read32(service+12)==read32(service+16) and read32(service+28)==0 and read32(service+64)==0
 cases.append({'poison':poison,'owner_id':owner_id,'gate':gate,'metadata':metadata,'initial':initial,'created':created,'activated':activated,'activation_packets':list(activation_packets),'dispatches':dispatches,'destroyed':destroyed})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Actual active constructors7306C0/7307F0, metadata registration,72EC40 pending activation, compound/owner insertion helpers,72EEC0 event dispatch with native callback consumers and72EE20 matching removal execute in8 lifetimes with32 event dispatches. Real service vtable gate718AD0 executes. Sentinel owner descriptors remain pending until actual metadata destruction. No service/registry/descriptor/consumer helper-result adapters.','Service188 bytes caller-owned and partial native member initialization; whole72A3B0 constructor/settings remain open. Primitive allocator/memmove/actor virtual calls supplied, startup preconfigured. Captures include only live allocated bytes; no post-free snapshots. Live simulation, exceptions, service teardown and full announcement playback remain open.']}
(root/'data/4.20/audio_announcer_active_service_lifetimes_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'native_active_service_lifetimes':len(cases),'native_dispatches':32,'passed':True}))
