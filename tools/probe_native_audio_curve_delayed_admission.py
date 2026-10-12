from pathlib import Path
import json,itertools,struct,hashlib
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
manager=vector+0x1000;old_node=vector+0x3000;new_node=vector+0x4000;source=vector+0x5000;new_points=vector+0x7000;delayed=vector+0x8000;bound=vector+0x9000;old_bound=vector+0xa000
regions=[('manager',manager,0x950),('old_node',old_node,52),('new_node',new_node,52),('source',source,24),('new_points',new_points,24),('delayed',delayed,36),('new_bound',bound,64),('old_bound',old_bound,8)]
calls=[];allocations=[];freed=[];visited=set();failure='none';bound_index=0
snapshot=lambda:{n:bytes(u.mem_read(a,z)).hex()for n,a,z in regions}
def hook(uc,a,z,user):
 global bound_index
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0xada670:
  pool=read(sp+4);size=read(sp+8);assert pool==19
  if size==52:kind='node';ref=new_node
  elif size==24:kind='points';ref=new_points
  elif size==8:kind='bound';ref=bound+bound_index*16
  else:raise AssertionError(('allocation',size))
  result=0 if failure==kind else ref;calls.append({'kind':'allocate','pool':pool,'size':size,'result':result,'at_call':snapshot()})
  if result:allocations.append({'reference':result,'size':size});bound_index+=int(size==8)
  finish(result);return
 if a==0xada3e0:
  pool=read(sp+4);ref=read(sp+8);calls.append({'kind':'free','pool':pool,'reference':ref,'at_call':snapshot()});freed.append(ref);finish(0);return
 if a==0xca1ef0:dst=read(sp+4);src=read(sp+8);size=read(sp+12);u.mem_write(dst,bytes(u.mem_read(src,size)));finish(dst);return
 if a==0xb131d0:calls.append({'kind':'unlink_subscriber','target':read(sp+4),'at_call':snapshot()})
 assert any(lo<=a<hi for lo,hi in[(0xb10450,0xb10780),(0xae4550,0xae45f3),(0xb11f20,0xb120a0),(0xb12870,0xb12911),(0xb131d0,0xb1328c)]),hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
layouts={'empty':[],'single':[(33,7)],'mixed':[(33,7),(44,99),(55,7)],'interior':[(33,99),(44,7),(55,99)]}
for pattern,layout,delay_layout,failure in itertools.product([0,165],['empty','other','existing','recycled'],layouts,['none','node','points','bound']):
 for n,a,z in regions:u.mem_write(a,bytes([pattern])*z)
 u.mem_write(manager,bytes(0x950));u.mem_write(old_node,bytes(52));u.mem_write(new_node,bytes(52));w(manager+0x948,8);w(manager+0x92c,8);w(0x12100dc,19);u.mem_write(source,struct.pack('<ffIffI',0.,1.,4,1.,7.,4))
 if layout in['other','existing']:
  w(manager+0x938,old_node);w(manager+0x93c,old_node);w(manager+0x94c,1);w(old_node+4,99 if layout=='other'else 7)
  if layout=='other':w(old_node+24,old_bound);w(old_node+28,old_bound);w(old_node+44,1);w(old_node+40,8);w(old_bound,0);w(old_bound+4,33)
 if layout=='recycled':w(manager+0x940,old_node)
 ids=layouts[delay_layout]
 for j,(target,key)in enumerate(ids):at=delayed+j*12;w(at,delayed+(j+1)*12 if j+1<len(ids)else 0);w(at+4,target);w(at+8,key)
 w(manager+0x91c,delayed if ids else 0);w(manager+0x920,delayed+(len(ids)-1)*12 if ids else 0);w(manager+0x930,len(ids));calls.clear();allocations.clear();freed.clear();bound_index=0;before=snapshot();w(stack,end)
 for j,v in enumerate([7,0xabcdef01,source,2]):w(stack+4+j*4,v)
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,manager);u.emu_start(0xb10450,end,count=2500);terminal=u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'layout':layout,'delay_layout':delay_layout,'failure':failure,'terminal':terminal,'before':before,'after':snapshot(),'result':u.reg_read(UC_X86_REG_EAX)if terminal else None,'stopped_pc':u.reg_read(UC_X86_REG_EIP),'calls':list(calls),'allocations':list(allocations),'freed':list(freed)})
p={'passed':True,'complete':False,'case_count':len(rows),'terminal_case_count':sum(x['terminal']for x in rows),'instruction_limited_case_count':sum(not x['terminal']for x in rows),'native_sha256':hashlib.sha256(raw).hexdigest(),'regions':[{'name':n,'reference':a,'size':z}for n,a,z in regions],'native_addresses':len(visited),'cases':rows,'limits':['Actual B10450 admission plus B131D0 unlink/B11F20 failed-node removal/B12870 cleanup/AE4550 storage; allocator/free/memcpy boundaries only. Delayed bound targets supplied, no callback/recipient-body substitute. Terminal results and all entry/final physical snapshots captured.','128 combinations0/a5, empty/other/existing/recycled curve lists, empty/single/mixed/interior pending targets, node/point/bound OOM. Bound OOM can discard selected pending entry without changing admission return. Missing curve may requeue same pending target and revisit appended entries; nonterminal cases retain2500instruction-limited partial evidence, not successful qualification. Rust replay pending.']}
(r/'data/4.20/audio_curve_delayed_admission_preparation.json').write_text(json.dumps(p,indent=2)+'\n',encoding='utf-8');(r/'tools/probe_native_audio_curve_delayed_admission.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8');print('Native delayed admission:',len(rows),'cases;',p['terminal_case_count'],'terminal;',p['instruction_limited_case_count'],'instruction-limited')
