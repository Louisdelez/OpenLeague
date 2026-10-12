"""Real738A3A/72B2D0/72B2F0 routing, actual registry callbacks and default588290."""
from pathlib import Path
import json,sys,itertools
exec(compile(Path('E:/OpenLeague/tools/qualify_active_service_lifetimes.py').read_text().split('\ncases=[]')[0],'active service prerequisites','exec'))
assert digest=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
service_calls=[];dispatch_inputs=[];activation_inputs=[]
def packet_track(uc,address,size,user):
 if address in [0x65e9e0,0x738a3a,0x72b2d0,0x72b2f0,0x72ec40,0x72eec0,0x588290,0x577e90,0x5cc140]:service_calls.append(address)
 if address==0x72eec0:
  sp=u.reg_read(UC_X86_REG_ESP);descriptor=read32(sp+4);dispatch_inputs.append({'this':u.reg_read(UC_X86_REG_ECX),'descriptor_hex':bytes(u.mem_read(descriptor,12)).hex(),'packet':read32(sp+8)})
 if address==0x72ec81:activation_inputs.append(bytes(u.mem_read(u.reg_read(UC_X86_REG_EBP)-0x2c,12)).hex())
u.hook_add(unicorn.UC_HOOK_CODE,packet_track)
def packet_snapshot():
 result=capture();result['service_hex']=bytes(u.mem_read(service,392)).hex();result['blocks']=[{'pointer':p,'bytes':n,'hex':bytes(u.mem_read(p,n)).hex()} for p,n in sorted(live.items())];return result
cases=[]
try:
 for poison,owner_id,gate in itertools.product([0,165],[42,0xffffffff],[0,1]):
  cursor=arena;fail=False;live={};allocations.clear();freed.clear();write32(0x14bef40,0);write32(0x14bef58,0);u.mem_write(0x2d77b20,b'\1');u.mem_write(service,bytes([poison])*392);write32(service,0x10afe8c)
  for i in [12,16,20]:write32(service+i,0)
  u.mem_write(heap+0x9000,bytes([poison]));call(0x7306c0,service+24,[0,0]);call(0x7307f0,service+56,[heap+0x9000,0]);initial=packet_snapshot()
  write32(0x2d787b8,service);write32(0x123b12c,0x3f800000);write32(0x2d5f448,0xffffffff);write32(0x2d62878,0x11223344);write32(heap+0x5600,owner_id)
  write32(heap+0x4000,heap+0x4100);write32(heap+0x4124,end+0x1300);write32(heap+0x412c,end+0x1400);u.mem_write(service+0x122,bytes([gate]))
  metadata=call(0x9933e0,0,[56]);call(0x6b26f0,metadata,[heap+0x4000,heap+0x5600]);created=packet_snapshot()
  wrapper=heap+0x7700;packet=heap+0x7900
  for off,value in [(0,0x109b2d4),(4,service),(8,0x738a3a),(12,0)]:write32(wrapper+off,value)
  commands=[(0,False,0xdd,42),(1,True,0xdd,42),(0,False,0x51,42),(0,False,0xe0,42),(0,False,1,42),
    (1,False,0x51,42),(1,True,0x51,42),(1,False,0x35,42),(1,True,0x35,42),(1,False,0xe0,42),(1,False,0xe1,42),
    (1,False,0x51,0x11223344),(1,False,0,42),(255,False,1,42),(1,True,303,42),(1,True,0xffff,0x11223344),
    (0,False,0x95,42),(0,True,0x95,42)]
  #95's source global pair is empty here; its original getter/consumer executes.
  assert read32(0x14c761c)==0 and read32(0x14c7620)==0
  steps=[]
  for j,(enabled,wide,code,owner) in enumerate(commands):
   u.mem_write(service+0x184,bytes([enabled]));data=bytearray([poison]*32);data[0]=0xfe if wide else code;data[1:5]=owner.to_bytes(4,'little');data[5]=3
   if wide:data[5:7]=code.to_bytes(2,'little')
   u.mem_write(packet,bytes(data));context=0x13570000+j;old_context=read32(service+0x5c);events.clear();service_calls.clear();dispatch_inputs.clear();activation_inputs.clear();activation_packets.clear()
   result=call(0x65e9e0,wrapper,[context,packet])&255;snapshot=packet_snapshot()
   dropped=code==0xdd or (enabled==0 and code not in [0x88,0x92,0x54,0x95,0xc6])
   assert read32(service+0x5c)==(old_context if dropped else context)
   assert (0x588290 in service_calls)==(not dropped and not (owner_id==owner==42 and code in [0x51,0x35,0xe0,0xe1]))
   steps.append({'enabled':enabled,'wide':wide,'code':code,'owner':owner,'context':context,'context_before':old_context,'packet_hex':data.hex(),'return_al':result,'native_calls':list(service_calls),'dispatch_inputs':list(dispatch_inputs),'activation_inputs':list(activation_inputs),'actor_events':list(events),'snapshot':snapshot})
  call(0x6b28c0,metadata,[1]);metadata_destroyed=packet_snapshot();write32(0x2d787b8,0);call(0x72a600,service+12,[]);destroyed=packet_snapshot();assert not live
  cases.append({'fill':poison,'service':service,'wrapper':wrapper,'packet':packet,'owner_id':owner_id,'gate':gate,'metadata':metadata,'initial':initial,'created':created,'steps':steps,'metadata_destroyed':metadata_destroyed,'destroyed':destroyed})
 proof={'passed':True,'native_sha256':digest,'cases':cases,'limits':['8 native service-member/owner-metadata lifetimes,144 real65E9E0→738A3A→72B2D0→72B2F0 invocations. Actual72EC40/72EEC0 activation and callback consumer bodies execute; fallback588290 is real for default opcodes and95 with its source-empty global pair.','Caller-owned service392 initialized only for these members. Primitive allocation/copy and actor virtual actions supplied by existing oracle. No whole service constructor, active95 global receiver, other588290 consumers or live simulation qualification.','Inputs have32 readable bytes. No size parameter is present in this wrapper; minimum extent of other packet consumers is not inferred from this fixture.']}
except Exception as error:
 import traceback;traceback.print_exc();proof={'passed':False,'error':repr(error),'pc':hex(u.reg_read(UC_X86_REG_EIP)),'cases_completed':len(cases),'native_calls':service_calls}
Path(sys.argv[1]).write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({k:v for k,v in proof.items() if k not in ['cases']}))
if not proof['passed']:sys.exit(1)

