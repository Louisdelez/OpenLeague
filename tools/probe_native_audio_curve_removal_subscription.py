from pathlib import Path
import itertools,json,hashlib
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
manager=vector+0x1000;curve=vector+0x3000;points=vector+0x7000;bound=vector+0x8000;bound_free=vector+0x9000;pending=vector+0xa000;pending_free=vector+0xb000;allocated=vector+0xc000
regions=[('manager',manager,0x950),('curve',curve,52),('points',points,24),('bound',bound,24),('bound_free',bound_free,8),('pending',pending,24),('pending_free',pending_free,12),('allocated',allocated,64)]
calls=[];allocations=[];freed=[];visited=set();index=0;failure=False
snapshot=lambda:{n:bytes(u.mem_read(a,z)).hex()for n,a,z in regions}
def hook(uc,a,z,user):
 global index
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0xada670:
  pool=read(sp+4);size=read(sp+8);assert pool==19 and size==12
  result=0 if failure else allocated+index*16;assert index<4
  calls.append({'kind':'allocate','pool':pool,'size':size,'result':result,'at_call':snapshot()})
  if result:allocations.append({'reference':result,'size':size});index+=1
  finish(result);return
 if a==0xada3e0:
  pool=read(sp+4);ref=read(sp+8);calls.append({'kind':'free','pool':pool,'reference':ref,'at_call':snapshot()});freed.append(ref);finish(0);return
 if a==0xb131d0:calls.append({'kind':'unlink_subscriber','target':read(sp+4),'at_call':snapshot()})
 assert any(lo<=a<hi for lo,hi in[(0xb11f20,0xb120a0),(0xb12870,0xb12911),(0xb131d0,0xb1328c)]),hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
layouts={'empty':[],'single':[33],'multiple':[33,44,55],'duplicate':[33,33,44]}
for pattern,layout,delay_layout,capacity,failure,has_pending_free,has_bound_free in itertools.product([0,165],layouts,['empty','same','other'],[0,1,8],[False,True],[False,True],[False,True]):
 for n,a,z in regions:u.mem_write(a,bytes([pattern])*z)
 u.mem_write(manager,bytes(0x950));u.mem_write(curve,bytes(52));w(0x12100dc,19)
 w(manager+0x938,curve);w(manager+0x93c,curve);w(manager+0x94c,1);w(manager+0x948,8);w(manager+0x92c,capacity)
 w(curve+4,7);w(curve+8,0xabcdef01);w(curve+12,points);w(curve+16,2);w(curve+20,19);w(curve+40,0xffffffff)
 targets=layouts[layout]
 for j,t in enumerate(targets):a=bound+j*8;w(a,bound+(j+1)*8 if j+1<len(targets)else 0);w(a+4,t)
 w(curve+24,bound if targets else 0);w(curve+28,bound+(len(targets)-1)*8 if targets else 0);w(curve+44,len(targets))
 if has_bound_free:w(curve+32,bound_free);w(bound_free,0);w(bound_free+4,77)
 if delay_layout!='empty':w(manager+0x91c,pending);w(manager+0x920,pending);w(manager+0x930,1);w(pending,0);w(pending+4,33 if delay_layout=='same'else 99);w(pending+8,99)
 if has_pending_free:w(manager+0x924,pending_free);w(pending_free,0);w(pending_free+4,0x99887766);w(pending_free+8,88)
 calls.clear();allocations.clear();freed.clear();index=0;before=snapshot();u.mem_write(stack-0x1000,bytes(0x1100));w(stack,end);w(stack+4,7);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,manager);u.emu_start(0xb11f20,end,count=5000);terminal=u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'layout':layout,'delay_layout':delay_layout,'capacity':capacity,'failure':failure,'has_pending_free':has_pending_free,'has_bound_free':has_bound_free,'terminal':terminal,'before':before,'after':snapshot(),'calls':list(calls),'allocations':list(allocations),'freed':list(freed),'stopped_pc':u.reg_read(UC_X86_REG_EIP)})
p={'passed':True,'complete':False,'case_count':len(rows),'terminal_case_count':sum(x['terminal']for x in rows),'instruction_limited_case_count':sum(not x['terminal']for x in rows),'native_sha256':hashlib.sha256(raw).hexdigest(),'regions':[{'name':n,'reference':a,'size':z}for n,a,z in regions],'native_addresses':len(visited),'cases':rows,'limits':['Actual B11F20/B131D0/B12870 execute; only allocator/free ABI boundaries supplied. Full state snapshots at every allocation/free/unlink entry and termination captured.','Supplied valid curve/list structures with duplicate bound recipients, same/other delayed recipient, capacity and allocation failure, available free nodes. No whole runtime/startup or callback payload qualification. Nonterminal cases remain instruction-limited evidence. Rust replay pending.']}
(r/'data/4.20/audio_curve_removal_subscription_preparation.json').write_text(json.dumps(p,indent=2)+'\n',encoding='utf-8');(r/'tools/probe_native_audio_curve_removal_subscription.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8');print('Captured',len(rows),'native removals;',p['terminal_case_count'],'terminal;',p['instruction_limited_case_count'],'instruction-limited')
