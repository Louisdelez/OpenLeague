from pathlib import Path
import json,hashlib,itertools,struct
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
manager=vector+0x1000;old_node=vector+0x3000;new_node=vector+0x4000;source=vector+0x5000;old_points=vector+0x6000;new_points=vector+0x7000
regions=[('manager',manager,0x950),('old_node',old_node,52),('new_node',new_node,52),('source',source,48),('old_points',old_points,48),('new_points',new_points,48)]
calls=[];allocations=[];freed=[];visited=set();failure='none'
def snapshot():return {n:bytes(u.mem_read(a,z)).hex()for n,a,z in regions}
def hook(uc,a,z,user):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0xada670:
  pool=read(sp+4);size=read(sp+8);assert pool==19
  kind='node'if size==52 else'points';ref=new_node if kind=='node'else new_points;assert size in[12,24,36,52]
  result=0 if failure==kind else ref;calls.append({'kind':'allocate','pool':pool,'size':size,'result':result,'at_call':snapshot()})
  if result:allocations.append({'reference':result,'size':size})
  finish(result);return
 if a==0xada3e0:
  pool=read(sp+4);ref=read(sp+8);assert pool==19;assert ref not in freed;calls.append({'kind':'free','pool':pool,'reference':ref,'at_call':snapshot()});freed.append(ref);finish(0);return
 if a==0xca1ef0:
  dst=read(sp+4);src=read(sp+8);size=read(sp+12);calls.append({'kind':'copy','destination':dst,'source':src,'size':size,'at_call':snapshot()});u.mem_write(dst,bytes(u.mem_read(src,size)));finish(dst);return
 if a==0xae4550:calls.append({'kind':'construct_points','this':u.reg_read(UC_X86_REG_ECX),'source':read(sp+4),'count':read(sp+8),'scaling':read(sp+12),'at_call':snapshot()})
 if a==0xb11f20:calls.append({'kind':'remove_curve','key':read(sp+4),'at_call':snapshot()})
 assert any(lo<=a<hi for lo,hi in[(0xb10450,0xb10780),(0xae4550,0xae45f3),(0xb11f20,0xb120a0),(0xb12870,0xb12911)]),hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for pattern,layout,capacity,count,null_source,failure in itertools.product([0,165],['empty','existing','recycled','append'],[0,1,8],[0,1,2,3],[False,True],['none','node','points']):
 for n,a,z in regions:u.mem_write(a,bytes([pattern])*z)
 u.mem_write(manager,bytes(0x950));u.mem_write(new_node,bytes(52));u.mem_write(old_node,bytes(52));w(0x12100dc,19)
 for j in range(4):u.mem_write(source+j*12,struct.pack('<ffI',float(j),float(j*3+1),4));u.mem_write(old_points+j*12,struct.pack('<ffI',float(j),float(j+5),9))
 w(manager+0x948,capacity)
 if layout in['existing','append']:
  w(manager+0x938,old_node);w(manager+0x93c,old_node);w(manager+0x94c,1);w(old_node+4,7 if layout=='existing'else 99);w(old_node+8,31);w(old_node+12,old_points);w(old_node+16,2);w(old_node+20,4)
 if layout=='recycled':w(manager+0x940,old_node)
 calls.clear();allocations.clear();freed.clear();before=snapshot();w(stack,end)
 for j,v in enumerate([7,0xabcdef01,0 if null_source else source,count]):w(stack+4+j*4,v)
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,manager);u.emu_start(0xb10450,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'layout':layout,'capacity':capacity,'point_count':count,'null_source':null_source,'failure':failure,'before':before,'after':snapshot(),'result':u.reg_read(UC_X86_REG_EAX),'calls':list(calls),'allocations':list(allocations),'freed':list(freed)})
p={'passed':True,'complete':False,'case_count':len(rows),'native_sha256':hashlib.sha256(raw).hexdigest(),'regions':[{'name':n,'reference':a,'size':z}for n,a,z in regions],'native_addresses':len(visited),'cases':rows,'limits':['Actual B10450 curve admission, AE4550 point storage and B11F20 failed-new-entry removal execute original bodies. Allocator/free/memcpy are boundaries; full snapshots recorded before each call. Empty/existing/recycled/append, capacity0/1/8, point count0..3, NULL/nonNULL source, node/points failures.','Manager delayed subscriber list91C is empty; no delayed callback replay. Old/new nodes initialized zero, source/point banks and padding0/a5; arbitrary uninitialized node cleanup requires separate fault qualification. Full resource-reader curve section integration and Rust replay pending.']}
(r/'data/4.20/audio_resource_curve_admission_preparation.json').write_text(json.dumps(p,indent=2)+'\n',encoding='utf-8');(r/'tools/probe_native_audio_resource_curve_admission.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8');print('PASS',len(rows),'actual curve registration/storage/removal compositions')

