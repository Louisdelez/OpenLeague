from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
node=vector+0x6000;old=vector+0x7000;new=vector+0xa000;calls=[];freed=[];allocations=[];visited=set()
def hook(uc,a,size,data):
 if a==0xada670:
  sp=u.reg_read(UC_X86_REG_ESP);pool,size=read(sp+4),read(sp+8);assert pool==17 and size==(capacity+8)*4;pointer=0 if failure else new;calls.append({'kind':'allocate','pool':pool,'bytes':size,'reference':pointer})
  if pointer:u.mem_write(new,bytes([pattern])*size);allocations.append({'reference':new,'bytes':size})
  finish(pointer);return
 if a==0xada3e0:
  sp=u.reg_read(UC_X86_REG_ESP);pool,pointer=read(sp+4),read(sp+8);assert pool==17 and pointer==old and pointer not in freed;freed.append(pointer);calls.append({'kind':'free','pool':pool,'reference':pointer});finish(1);return
 assert 0xb14010<=a<0xb140a5 or 0xaff610<=a<0xaff67d,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for pattern,count,spare,kind,failure in itertools.product([0,0xa5,0xff],[0,1,3,7,8],[False,True],['first','last','missing','null'],[False,True]):
 calls.clear();freed.clear();allocations.clear();capacity=8 if spare else count;u.mem_write(node,bytes([pattern])*108);w(node+32,old if capacity else 0);w(node+36,count);w(node+40,capacity);u.mem_write(old,bytes([pattern])*(capacity*4));w(0x12100dc,17)
 for i in range(count):w(old+i*4,vector+0x8000+i*64)
 key=0 if kind=='null'else(vector+0x8000 if kind=='first'else vector+0x8000+(max(count,1)-1)*64 if kind=='last'else vector+0x9000)
 def snap():return {'node':bytes(u.mem_read(node,108)).hex(),'allocations':[{'reference':old,'raw':bytes(u.mem_read(old,capacity*4)).hex(),'freed':old in freed}]if capacity and not allocations else ([{'reference':old,'raw':bytes(u.mem_read(old,capacity*4)).hex(),'freed':old in freed}]if capacity else [])+[{'reference':v['reference'],'raw':bytes(u.mem_read(v['reference'],v['bytes'])).hex(),'freed':False}for v in allocations]}
 before=snap();w(stack,end);w(stack+4,node);w(stack+8,key);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,vector+0x5000);u.emu_start(0xb14010,end,count=3000);assert u.reg_read(UC_X86_REG_EIP)==end;rows.append({'key':key,'before':before,'after':snap(),'result':u.reg_read(UC_X86_REG_EAX),'calls':list(calls)})
proof={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0xb14010','case_count':len(rows),'cases':rows,'native_addresses':len(visited),'findings':['Eight bindings is the hard count ceiling, tested before duplicate scan. Duplicate status40 leaves bytes unchanged. Null link keys are not rejected by insertion. Actual AFF610 grows capacity by8, copies active refs then frees old allocation; OOM status40 preserves old storage. Successful append increments count36 and reference byte45.'],'limits':['Physical allocation/free are controlled mandatory transports. Rust binding registration, link/target constructors, manager publication/removal and whole-lifetime frame composition remain required.']}
(r/'data/4.20/audio_path_binding_registration_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native binding registration/growth cases')
