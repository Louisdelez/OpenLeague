from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
slot=vector+0x1000;old=vector+0x2000;new=vector+0x4000;calls=[];visited=set();w(0x12100dc,19)
def snap():return {'slot':bytes(u.mem_read(slot,4)).hex(),'old':bytes(u.mem_read(old,4096)).hex(),'new':bytes(u.mem_read(new,4096)).hex()}
def hook(uc,a,size,data):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0xada670:calls.append({'kind':'allocate','pool':read(sp+4),'size':read(sp+8),'result':0 if failure else new,'at_call':snap()});finish(0 if failure else new);return
 if a==0xca1ef0:
  dest,src,n=read(sp+4),read(sp+8),read(sp+12);calls.append({'kind':'memcpy','destination':dest,'source':src,'size':n,'at_call':snap()})
  if n:u.mem_write(dest,bytes(u.mem_read(src,n)))
  finish(dest);return
 if a==0xada3e0:calls.append({'kind':'free','pool':read(sp+4),'reference':read(sp+8),'at_call':snap()});finish(1);return
 assert 0xaefe40<=a<0xaefeec,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for pattern,count,property_type,failure in itertools.product([0,0xa5],[None,0,1,3,4,7,255],[0,5,255,0x12345678],[False,True]):
 u.mem_write(old,bytes([pattern])*4096);u.mem_write(new,bytes([pattern^0x5a])*4096);w(slot,0 if count is None else old)
 if count is not None:
  u.mem_write(old,bytes([count]));offset=(count+4)&~3
  for i in range(count):u.mem_write(old+1+i,bytes([(5+i)%256]));w(old+offset+i*8,0x3f800000+i);w(old+offset+i*8+4,0x90000000+i)
 before=snap();calls.clear();w(stack,end);w(stack+4,property_type);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,slot);u.emu_start(0xaefe40,end,count=3000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'count':count,'property_type':property_type,'allocation_failure':failure,'before':before,'after':snap(),'result':u.reg_read(UC_X86_REG_EAX),'calls':list(calls)})
d={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'case_count':len(rows),'cases':rows,'native_addresses':len(visited),'limits':['Actual AFEE40 size alignment, count-byte wrap255 to0, low-byte type insertion, old-type and8-byte pair copies, old free before publishing new pointer, preserved uninitialized new pair bytes and allocation failure all execute. Complete physical blocks and boundary snapshots compared.','Allocator/free/CRTmemcpy are explicit ABI adapters with caller supplied physical blocks. Function does not initialize new float/owner pair; caller must supply those writes. Rust replay and complete nonempty D0 owner graph remain required.']}
(r/'data/4.20/audio_path_source_property_append_preparation.json').write_text(json.dumps(d,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual AFEE40 append cases including255-byte count wrap and untouched new pair')
