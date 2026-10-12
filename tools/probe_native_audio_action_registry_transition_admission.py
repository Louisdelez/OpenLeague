from pathlib import Path
import itertools,json,hashlib
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
registry=vector+0x1000;keys=vector+0x2000;owners=vector+0x3000;old_table=vector+0x4000;new_tables=vector+0x5000
regions=[('registry',registry,108),('keys',keys,24),('owners',owners,48),('old_table',old_table,72),('new_tables',new_tables,256)]
def snapshot():return {n:bytes(u.mem_read(a,z)).hex()for n,a,z in regions}
calls=[];freed=[];allocated=[];visited=set();failure=False;next_index=0
def hook(uc,a,z,data):
 global next_index
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0xada670:
  pool=read(sp+4);size=read(sp+8);assert pool==19 and size<=128;result=0 if failure else new_tables+next_index*128;calls.append({'kind':'allocate','pool':pool,'size':size,'result':result,'at_call':snapshot()})
  if result:allocated.append({'reference':result,'size':size});next_index+=1
  finish(result);return
 if a==0xada3e0:
  pool=read(sp+4);ref=read(sp+8);calls.append({'kind':'free','pool':pool,'reference':ref,'at_call':snapshot()});assert ref not in freed;freed.append(ref);finish(0);return
 assert 0xaf69b0<=a<0xaf6a2b or 0xaf6f50<=a<0xaf6fec or 0xaf95a0<=a<0xaf9623,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for pattern,key_layout,array_kind,(start,target),reverse,failure in itertools.product([0,0xa5],['empty','one','duplicate','missing'],['empty','spare','full','duplicates'],[(0x11223344,0x55667788),(0x11223344,0x11223344)],[0,1,0x100,0x101],[False,True]):
 for n,a,z in regions:u.mem_write(a,bytes([pattern])*z)
 entries=[]if key_layout=='empty'else [(200 if key_layout=='missing'else 7,owners)]+([(7,owners+24)]if key_layout=='duplicate'else [])
 w(registry,keys);w(registry+4,len(entries))
 for j,(key,ref)in enumerate(entries):w(keys+j*8,key);w(keys+j*8+4,ref)
 for j in range(2):
  ref=owners+j*24;w(ref,37+j);w(ref+4,0xabc00000+j);w(ref+8,0);w(ref+12,0);w(ref+16,0);w(ref+20,0)
 count=0 if array_kind=='empty'else 2 if array_kind=='duplicates'else 1;capacity=0 if array_kind=='empty'else 2 if array_kind in ['spare','duplicates']else 1
 w(owners+12,old_table if array_kind!='empty'else 0);w(owners+16,count);w(owners+20,capacity)
 for j in range(count):w(old_table+j*12,0x11223344 if array_kind=='duplicates'else 0x99);w(old_table+j*12+4,0x55667788 if array_kind=='duplicates'else 0xaa);w(old_table+j*12+8,31+j)
 w(0x12100dc,19);calls.clear();freed.clear();allocated.clear();next_index=0;before=snapshot();w(stack,end)
 for j,arg in enumerate([7,start,target,97,reverse]):w(stack+4+j*4,arg)
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,registry);u.emu_start(0xaf69b0,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'key_layout':key_layout,'array_kind':array_kind,'from':start,'to':target,'duration':97,'reverse':reverse,'allocation_failure':failure,'old_capacity':capacity,'before':before,'after':snapshot(),'result':u.reg_read(UC_X86_REG_EAX),'calls':list(calls),'freed':list(freed),'allocations':list(allocated)})
proof={'passed':True,'complete':False,'case_count':len(rows),'native_sha256':hashlib.sha256(raw).hexdigest(),'regions':[{'name':n,'reference':a,'size':z}for n,a,z in regions],'native_addresses':len(visited),'cases':rows,'limits':['Actual AF69B0/AF6F50/AF95A0 transition registration/growth runs original bodies with only allocator/free adapters. First key/duplicate transition updates, missing status20, OOM status2, empty/spare/full arrays, capacity+5 growth/copy/free-before-pointer publication, asymmetric/symmetric/equal endpoints and reverse low-byte flags captured.','Initial registry owners supplied; full AFB320 resource reader and bank/startup producers remain open. Rust replay pending.']}
(r/'data/4.20/audio_action_registry_transition_admission_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual transition insertion/update/symmetric/growth/failure physical cases')
