from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
manager=vector+0x1000;queues=vector+0x2000;descriptor=vector+0x3000;action=vector+0x4000;vtable=vector+0x5000;clock=vector+0x6000;owner=vector+0x8000;binding=vector+0x9000;callback=vector+0x1f000
regions=[('manager',manager,28),('queues',queues,16),('descriptor',descriptor,32),('action',action,44),('new_owner',owner,56),('new_binding',binding,32),('clock',clock,128),('conversion_cache',0x14a7970,8)]
def snap():return {n:bytes(u.mem_read(a,z)).hex()for n,a,z in regions}
calls=[];freed=[];visited=set();failure='none'
def hook(uc,a,size,data):
 if a==0xada670:
  sp=u.reg_read(UC_X86_REG_ESP);pool=read(sp+4);size=read(sp+8);assert pool==19 and size in[56,32];result=0 if(failure=='owner'and size==56)or(failure=='binding'and size==32)else owner if size==56 else binding
  calls.append({'kind':'allocate','pool':pool,'size':size,'result':result,'at_call':snap()});finish(result);return
 if a==0xada3e0:
  sp=u.reg_read(UC_X86_REG_ESP);pool=read(sp+4);ref=read(sp+8);calls.append({'kind':'free','pool':pool,'reference':ref,'at_call':snap()});assert ref not in freed;freed.append(ref);finish(0);return
 if a==callback:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'action_virtual0','receiver':u.reg_read(UC_X86_REG_ECX),'arguments':[read(sp+4+j*4)for j in range(3)],'at_call':snap()});finish(0,12);return
 assert 0xaf5490<=a<0xaf55c3 or 0xb20ea0<=a<0xb20ed4 or 0xb21040<=a<0xb21281 or 0xaff610<=a<0xaff67c or 0xb212c0<=a<0xb212f0 or a==0x5642d0,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for pattern,queue_arg,capacity,failure,gain,pair_kind,duration,first,processed in itertools.product([0,0xa5],[0,1,2],[0,1],['none','owner','binding'],[0,1],['rise','fall','silence'],[0,1,97],[0,1,256],[0,1]):
 for n,a,z in regions:u.mem_write(a,bytes([pattern])*z)
 w(manager,1)
 for off,ptr in[(4,queues),(16,queues+8)]:w(manager+off,ptr);w(manager+off+4,0);w(manager+off+8,capacity)
 initial,target={'rise':(0,0x3f800000),'fall':(0x3f800000,0),'silence':(0xc4480000,0)}[pair_kind]
 for off,val in[(0,action),(4,3),(8,initial),(12,target),(16,duration),(20,4)]:w(descriptor+off,val)
 u.mem_write(descriptor+24,bytes([gain,processed]));w(action,vtable);w(vtable,callback);w(clock+124,31);w(0x14a7a28,clock);w(0x12100dc,19);w(0x12100f8,48);w(0x14a7970,0);w(0x14a7974,0)
 u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
 before=snap();calls.clear();freed.clear();w(stack,end)
 for i,arg in enumerate([descriptor,first,queue_arg]):w(stack+4+i*4,arg)
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,manager);u.emu_start(0xaf5490,end,count=5000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'queue_argument':queue_arg,'queue_capacity':capacity,'failure':failure,'gain':gain,'pair_kind':pair_kind,'duration':duration,'first_argument':first,'processed':processed,'before':before,'after':snap(),'calls':list(calls),'freed':list(freed),'result':u.reg_read(UC_X86_REG_EAX)})
d={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'case_count':len(rows),'native_addresses':len(visited),'floating_control':{'x87_control_word':895,'mxcsr':8064},'cases':rows,'limits':['Actual AF5490, B20EA0 constructor56, B21040 float/gain/clock/curve/binding setup, AFF610 binding growth and B212C0 cleanup execute. Allocation/free and action virtual0 are explicit ABI adapters. Both queues start empty, count-limit1 allows fresh allocation. No owner reuse, progress/B20EE0 selection, active owner attachment, source98 or complete registry/frame integration qualified. Rust replay pending.']}
(r/'data/4.20/audio_property_owner_creation_fp64_preparation.json').write_text(json.dumps(d,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual transition-owner construction/setup/queue publication/fallback/frees cases')
