from pathlib import Path
import json,hashlib,itertools,struct
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
manager=vector+0x1000;queues=vector+0x2000;descriptor=vector+0x3000;action=vector+0x4000;vtable=vector+0x5000;clock=vector+0x6000;owners=vector+0x8000;bindings=vector+0x9000;callback=vector+0x1f000
regions=[('manager',manager,28),('queues',queues,24),('descriptor',descriptor,32),('action',action,44),('owners',owners,168),('bindings',bindings,96),('clock',clock,128),('conversion_cache',0x14a7970,8)]
def snap():return {n:bytes(u.mem_read(a,z)).hex()for n,a,z in regions}
calls=[];freed=[];visited=set()
def hook(uc,a,size,data):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0xada3e0:
  pool=read(sp+4);ref=read(sp+8);calls.append({'kind':'free','pool':pool,'reference':ref,'at_call':snap()});assert ref not in freed;freed.append(ref);finish(0);return
 if a==callback:
  calls.append({'kind':'action_virtual0','receiver':u.reg_read(UC_X86_REG_ECX),'arguments':[read(sp+4),read(sp+8),read(sp+12)&255],'at_call':snap()});finish(0,12);return
 if a==0xb20ee0:calls.append({'kind':'progress_owner','receiver':u.reg_read(UC_X86_REG_ECX),'time':read(sp+4),'at_call':snap()})
 assert 0xaf5490<=a<0xaf55c3 or 0xb20ee0<=a<0xb21038 or 0xb21290<=a<0xb212b4 or 0xaf5b40<=a<0xaf5b88 or 0xb21040<=a<0xb21281 or 0xb212c0<=a<0xb212f0 or a==0x5642d0,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for pattern,queue_arg,selection,old_gain,new_gain,first,duration,attached,capacity in itertools.product([0,0xa5],[0,1,2],['first','last','tie','none','nan'],[0,1],[0,1],[0,1,256],[0,1,97],[0,1],[2,3]):
 for n,a,z in regions:u.mem_write(a,bytes([pattern])*z)
 w(manager,3)
 for off,ptr in[(4,queues),(16,queues+12)]:
  w(manager+off,ptr);w(manager+off+4,3);w(manager+off+8,capacity)
  for i in range(3):w(ptr+i*4,owners+i*56)
 initial,target=0,0x3f800000
 for off,val in[(0,action),(4,3),(8,initial),(12,target),(16,duration),(20,4)]:w(descriptor+off,val)
 u.mem_write(descriptor+24,bytes([new_gain,1]));w(action,vtable);w(vtable,callback)
 scores={'first':[0.75,0.25,0.5],'last':[0.1,0.2,0.9],'tie':[0.8,0.8,0.2],'none':[-1.,-2.,float('nan')],'nan':[float('nan'),0.5,float('nan')]}[selection]
 for i in range(3):
  owner=owners+i*56;binding=bindings+i*32
  for off,val in[(0,5),(4,0x3f000000),(8,0x3f800000+i*0x800000),(12,0),(16,24),(20,40),(28,0),(32,binding),(36,attached),(40,8),(44,4),(48,1)]:w(owner+off,val)
  u.mem_write(owner+24,struct.pack('<f',scores[i]));u.mem_write(owner+52,bytes([(pattern&0xfc)|old_gain,attached]));w(binding,action)
 w(clock+124,31);w(0x14a7a28,clock);w(0x12100dc,19);w(0x12100f8,48);w(0x14a7970,0);w(0x14a7974,0)
 u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80);before=snap();calls.clear();freed.clear();w(stack,end)
 for i,arg in enumerate([descriptor,first,queue_arg]):w(stack+4+i*4,arg)
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,manager);u.emu_start(0xaf5490,end,count=6000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'queue_argument':queue_arg,'selection':selection,'old_gain':old_gain,'new_gain':new_gain,'first_argument':first,'duration':duration,'attached':attached,'queue_capacity':capacity,'before':before,'after':snap(),'calls':list(calls),'freed':list(freed),'result':u.reg_read(UC_X86_REG_EAX)})
d={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'case_count':len(rows),'native_addresses':len(visited),'floating_control':{'x87_control_word':895,'mxcsr':8064},'cases':rows,'limits':['Actual AF5490 highest-progress selection with native threshold -1.0, NaN rejection and first tie; B20EE0 final-time propagation, B21290 reset, AF5B40 first owner removal/swap tail, B21040 new setup/reused binding, queue publication or B212C0 cleanup execute. Pools already have3 supplied owner56 blocks and bindings; fresh allocation excluded. Capacity2/count3 cases intentionally qualify overfull supplied native storage.','B20EE0 called at start+duration, so final branch executes; interior interpolation ADF570 and real-clock progression remain open. x87 control word037f, MXCSR1f80 explicitly supplied. Action virtual0 is a controlled ABI callback; only its documented finish low byte compared, native stack upper bytes not normalized or qualified. Complete registry/source98/physical playback and Rust replay pending.']}
(r/'data/4.20/audio_property_owner_reuse_preparation.json').write_text(json.dumps(d,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual highest-progress reuse/terminal propagation/reset/swap/publication/free cases')
