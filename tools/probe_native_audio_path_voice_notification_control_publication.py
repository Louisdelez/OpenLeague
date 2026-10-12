from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
voice=vector+0x4000;storage=vector+0x8000;free_slot=vector+0x9000;allocated=vector+0xa000;queue=0x14a82f0;calls=[];visited=set();freed=[]
def hook(uc,a,size,data):
 if a==0xada670:
  sp=u.reg_read(UC_X86_REG_ESP);pool,n=read(sp+4),read(sp+8);assert pool==17 and n==20;reference=0 if failure else allocated;calls.append({'kind':'allocate','pool':pool,'bytes':n,'reference':reference});
  if reference:u.mem_write(reference,bytes([pattern])*20)
  finish(reference);return
 if a==0xada3e0:
  sp=u.reg_read(UC_X86_REG_ESP);pool,ref=read(sp+4),read(sp+8);assert pool==17 and ref not in freed;freed.append(ref);calls.append({'kind':'free','pool':pool,'reference':ref});finish(1);return
 if a==0xaecee0:
  sp=u.reg_read(UC_X86_REG_ESP);assert u.reg_read(UC_X86_REG_ECX)==voice and read(sp+4)==1;calls.append({'kind':'voice_action','voice':voice,'argument':1,'queue_at_call':bytes(u.mem_read(queue,28)).hex(),'voice_at_call':bytes(u.mem_read(voice,424)).hex()});return
 assert 0xaecee0<=a<0xaecf00 or 0xaf36b0<=a<0xaf36f1 or 0xaf34d0<=a<0xaf3560 or 0xb1c080<=a<0xb1c0fc or 0xb1be30<=a<0xb1be90 or 0xb1bf30<=a<0xb1c080,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for pattern,count,kind,phase,blocked,cached,failure,limit,pooled in itertools.product([0,0xa5],[0,1,3],['first','last','missing','duplicate'],[0,1,2,3],[False,True],[False,True],[False,True],[0,4],[False,True]):
 calls.clear();freed.clear();u.mem_write(0x14a7a7c,bytes(28));w(0x14a7a7c+8,vector+0xb000);w(0x14a7a7c+12,1);w(0x14a7a7c+16,1);w(0x14a7a7c+24,vector+0xb000);u.mem_write(vector+0xb000,bytes([pattern])*20);w(vector+0xb000,0);u.mem_write(voice,bytes([pattern])*424);w(voice+108,vector+0xd000 if blocked else 0);u.mem_write(storage,bytes([pattern])*60);u.mem_write(free_slot,bytes([0x33])*20);w(free_slot,0);u.mem_write(allocated,bytes([0x33])*20)
 for i in range(count):ref=storage+i*20;w(ref,storage+(i+1)*20 if i+1<count else 0);w(ref+4,voice if (kind=='first'and i==0)or(kind=='last'and i==count-1)or kind=='duplicate'else voice+512+i*512);w(ref+8,phase);w(ref+12,0x11223344);w(ref+16,0x55667788)
 w(queue,storage if count else 0);w(queue+4,storage+(count-1)*20 if count else 0);w(queue+8,free_slot if cached else 0);w(queue+12,3 if pooled else 0);w(queue+16,limit);w(queue+20,count);w(queue+24,storage if pooled else 0);w(0x1210228,17);w(0x14a82e0,0x12345678)
 def snap():return {'control_queue':bytes(u.mem_read(0x14a7a7c,28)).hex(),'control_node':bytes(u.mem_read(vector+0xb000,20)).hex(),'voice':bytes(u.mem_read(voice,424)).hex(),'queue':bytes(u.mem_read(queue,28)).hex(),'storage':bytes(u.mem_read(storage,60)).hex(),'free_slot':bytes(u.mem_read(free_slot,20)).hex(),'allocated':bytes(u.mem_read(allocated,20)).hex()}
 before=snap();w(stack,end);w(stack+4,voice);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,0);u.emu_start(0xb1c080,end,count=3000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'count':count,'kind':kind,'phase':phase,'blocked':blocked,'cached':cached,'failure':failure,'limit':limit,'pooled':pooled,'before':before,'after':snap(),'result':u.reg_read(UC_X86_REG_EAX),'calls':list(calls),'freed':list(freed)})
proof={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0xb1c080','case_count':len(rows),'cases':rows,'native_addresses':len(visited),'limits':['Actual notification B1C080 queue scan and native B1BE30 append/free-slot allocation and B1BF30 removal execute, both pooled slot recycling and physically freed nonpooled nodes, preserving full header/node padding and frame12345678. Allocation/free physical transports controlled. Actual AECEE0 immediate action now executes, clears voice108 and calls actual AF36B0/AF34D0 to enqueue [voice,control4,argument1,float0] into its separate original control queue with one supplied preallocated20-byte slot. Both queue headers/nodes and voice bytes captured. Control queue allocator/full retry/AF3AA0 drain/virtual callback effects, real producers/source constructors, malformed cycles and Rust replay remain required; this preparation is not audible output acceptance.']}
(r/'data/4.20/audio_path_voice_notification_control_publication_preparation.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS',len(rows),'actual notification queue/list cases')
