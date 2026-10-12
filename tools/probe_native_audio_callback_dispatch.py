from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');s=(r/'tools/probe_native_audio_bank_media_lookup.py').read_text(encoding='utf-8').split('\nfor pattern,')[0];s=s.replace('u.hook_add(unicorn.UC_HOOK_CODE,guard_media)','media_hook=u.hook_add(unicorn.UC_HOOK_CODE,guard_media)');exec(compile(s,'setup','exec'))
local=[(0xae9f60,0xae9fce),(0xaeaf90,0xaeaff1),(0xaff610,0xaff67a),(0xb06987,0xb069a2),(0xaeb7c4,0xaeb7e2)];regions.extend(local);header=0x14a7a5c;storage=heap+0x9400;keys=[heap+0x15000+i*16 for i in range(9)];rows=[]
u.hook_del(media_hook)
def guard_dispatch(uc,a,n,d):
 if a in keys:
  sp=u.reg_read(UC_X86_REG_ESP);reason=read(sp+4,'I')[0];calls.append({'kind':'callback','reference':a,'reason':reason})
  if action!='none':
   saved=u.context_save()
   if action in ['self','first']:result=invoke(0xaeaf90,[a if action=='self'else first],0)
   else:result=invoke(0xae9f60,[keys[-1]],0)
   u.context_restore(saved);calls.append({'kind':'mutation_result','status':result})
  ret(0,0);return
 if any(lo<=a<hi for lo,hi in local):return
 guard_media(uc,a,n,d)
u.hook_add(unicorn.UC_HOOK_CODE,guard_dispatch)
for reason,pattern,count,spare,layout,action in itertools.product([0,1],[0,0xa5],[0,1,2,4,8],[0,2],['unique','repeat'],['none','self','first','append','failed_append']):
 calls.clear();allocations.clear();next_pointer=heap+0xa000;count_allocate=0;fail_nth=1 if action=='failed_append'else 0;capacity=count+spare;put(header,'3I',storage if capacity else 0,count,capacity);first=keys[0]
 if capacity:
  u.mem_write(storage,bytes([pattern])*(capacity*4));allocations.append({'reference':storage,'size':capacity*4,'freed':False})
  for i in range(count):put(storage+i*4,'I',keys[i if layout=='unique'else i%2])
 def snapshot():return {'header':bytes(u.mem_read(header,12)).hex(),'allocations':[{**a,'raw':bytes(u.mem_read(a['reference'],a['size'])).hex()}for a in allocations]}
 before=snapshot();sp=stack+0x4000;u.reg_write(UC_X86_REG_ESP,sp);start,end=(0xb06987,0xb069a2)if reason==0 else(0xaeb7c4,0xaeb7e2);
 try:u.emu_start(start,end,count=200000)
 except Exception:
  print('FAILED',reason,pattern,count,spare,layout,action,'header',bytes(u.mem_read(header,12)).hex(),'calls',calls,'eip',hex(u.reg_read(UC_X86_REG_EIP)));raise
 assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==sp
 rows.append({'reason':reason,'pattern':pattern,'count':count,'spare':spare,'layout':layout,'action':action,'first':first,'append':keys[-1],'failure_nth':fail_nth,'before':before,'after':snapshot(),'calls':list(calls)})
proof={'passed':True,'complete':False,'case_count':len(rows),'native_sha256':hashlib.sha256(b).hexdigest(),'cases':rows,'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in local],'adapters':['Actual normal-frame/shutdown reverse callback loop slices execute. Controlled callback transport invokes actual native registration/removal with saved/restored caller context; physical pool allocation/free adapted.'],'limits':['Only callback loop slices are qualified, not complete audio frame or shutdown producers/concurrency/device. Fixture callbacks mutate registry for ordering acceptance; actual Meter delivery is checked in a separate composition.']}
(r/'data/4.20/audio_callback_dispatch_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native reverse dispatch including registry mutation and allocation failure')
