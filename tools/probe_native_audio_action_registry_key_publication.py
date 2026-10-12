from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
registry=vector+0x1000;old_table=vector+0x2000;new_table=vector+0x3000;new_owner=vector+0x4000;owners=vector+0x5000;first_pool=vector+0x6000;second_pool=vector+0x7000;calls=[];visited=set();freed=[];phase='init';failure='none'
regions=[('registry',registry,108),('old_table',old_table,64),('new_table',new_table,128),('new_owner',new_owner,24),('owners',owners,96),('first_pool',first_pool,96),('second_pool',second_pool,128)]
def snap():return {n:bytes(u.mem_read(a,z)).hex()for n,a,z in regions}
def hook(uc,a,size,data):
 if a==read(0xfa41a0):
  sp=u.reg_read(UC_X86_REG_ESP);u.mem_write(read(sp+4),bytes([0x11])*24);finish(0,4);return
 if a==0xada670:
  sp=u.reg_read(UC_X86_REG_ESP);size=read(sp+8)
  if phase=='init':assert size in[96,128];result=first_pool if size==96 else second_pool
  else:
   assert size==24 or 64<=size<=96;result=0 if(failure=='owner'and size==24)or(failure=='table'and size!=24)else new_owner if size==24 else new_table
   calls.append({'kind':'allocate','pool':read(sp+4),'size':size,'result':result,'at_call':snap()})
  finish(result);return
 if a==0xada3e0:
  sp=u.reg_read(UC_X86_REG_ESP);reference=read(sp+8);assert reference not in freed;freed.append(reference);calls.append({'kind':'free','pool':read(sp+4),'reference':reference,'at_call':snap()});finish(1);return
 assert any(lo<=a<hi for lo,hi in[(0xaf66c0,0xaf672b),(0xaf6b80,0xaf6c5f),(0xaf6890,0xaf6950),(0xb15890,0xb15917),(0xb153b0,0xb15426),(0xaf7350,0xaf7387)]),hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);w(0x12100dc,19);rows=[]
for pattern,(count,capacity,present),match,failure in itertools.product([0,0xa5,0xff],[(0,0,False),(0,1,True),(1,1,True),(3,4,True),(4,4,True)],['first','last','missing'],['none','owner','table']):
 for n,a,z in regions:u.mem_write(a,bytes([pattern])*z)
 phase='init'
 for function in[0xaf66c0,0xaf6b80]:w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,registry);u.emu_start(function,end,count=1200);assert u.reg_read(UC_X86_REG_EIP)==end
 key=0x12345678;w(registry,old_table if present else 0);w(registry+4,count);w(registry+8,capacity)
 for i in range(4):w(old_table+i*8,key if count and ((match=='first'and i==0)or(match=='last'and i==count-1))else key+i+1);w(old_table+i*8+4,owners+i*24)
 before=snap();calls.clear();freed.clear();phase='key';w(stack,end);w(stack+4,key);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,registry);u.emu_start(0xaf6890,end,count=3000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'count':count,'capacity':capacity,'old_present':present,'match':match,'failure':failure,'key':key,'before':before,'after':snap(),'calls':list(calls),'result':u.reg_read(UC_X86_REG_EAX),'freed':sorted(freed)})
d={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'case_count':len(rows),'cases':rows,'native_addresses':len(visited),'limits':['Actual AF66C0/AF6B80 registry construction/initialization precedes each key case, then supplied existing table state is installed. Original AF6890 duplicate first-key success without allocation,24-byte owner constructor, B15890 insert and B153B0 capacity+8 grow/copy/free-before-publish execute. Missing allocation/table-growth owner cleanup AF7350 and free return2, successful/reused key return1. All physical bank and allocator/free snapshots captured.','Allocator/free and OS critical initialization are explicit ABI transports. Existing key table/owner contents supplied; registry manager startup/global publishing, caller and key/type resource provenance, actual property attachment and full frame remain open. Rust key publication replay pending.']}
(r/'data/4.20/audio_action_registry_key_publication_preparation.json').write_text(json.dumps(d,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual registry duplicate/new-key owner24/grow/free/publish/partial failure cases')
