from pathlib import Path
import itertools,json,hashlib
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
h=vector+0x1000;active=vector+0x4000;arena=vector+0x5000;free_nodes=vector+0x6000
regions=[('header',h,28),('heap_active',active,16),('arena',arena,24),('heap_free',free_nodes,8)]
calls=[];freed=[];visited=set()
def snapshot():return {n:bytes(u.mem_read(a,z)).hex()for n,a,z in regions}
def hook(uc,a,z,user):
 if a==0xada3e0:sp=u.reg_read(UC_X86_REG_ESP);pool=read(sp+4);ref=read(sp+8);assert pool==19 and ref not in freed;calls.append({'pool':pool,'reference':ref,'at_call':snapshot()});freed.append(ref);finish(0);return
 assert 0xb12870<=a<0xb12911,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
active_layouts={'empty':[],'heap':[active,active+8],'embedded':[arena,arena+8],'mixed':[active,arena]};free_layouts={'empty':[],'heap':[free_nodes],'embedded':[arena+16],'mixed':[free_nodes,arena+16]}
for pattern,a_layout,f_layout,allocated,embedded,count_override in itertools.product([0,165],active_layouts,free_layouts,[0,1,0xffffffff],[False,True],[None,0,0xffffffff]):
 for n,a,z in regions:u.mem_write(a,bytes([pattern])*z)
 aa=active_layouts[a_layout];ff=free_layouts[f_layout]
 for refs in[aa,ff]:
  for j,ref in enumerate(refs):w(ref,refs[j+1]if j+1<len(refs)else 0);w(ref+4,100+j)
 for off,value in[(0,aa[0]if aa else 0),(4,aa[-1]if aa else 0),(8,ff[0]if ff else 0),(12,3),(16,allocated),(20,len(aa)if count_override is None else count_override),(24,arena if embedded else 0)]:w(h+off,value)
 calls.clear();freed.clear();before=snapshot();w(0x12100dc,19);w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,h);u.emu_start(0xb12870,end,count=2000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'active_layout':a_layout,'free_layout':f_layout,'allocated':allocated,'embedded':embedded,'count_override':count_override,'before':before,'after':snapshot(),'result':u.reg_read(UC_X86_REG_EAX),'calls':list(calls),'freed':list(freed)})
p={'passed':True,'complete':False,'case_count':len(rows),'native_sha256':hashlib.sha256(raw).hexdigest(),'regions':[{'name':n,'reference':a,'size':z}for n,a,z in regions],'native_addresses':len(visited),'cases':rows,'limits':['Actual B12870 list cleanup original body; free ABI boundary only. Move active nodes to free list (reversing active order), unsigned live-count decrement, preserve0 allocation-count bypass, skip individual free for nodes within embedded arena, free external nodes then arena. Header capacity/allocation count/head/tail cleared; native free-head/arena-pointer/live-count leftovers preserved.','Supplied valid lists, arena capacity3, allocated-count0/1/MAX and live-count0/MAX/actual, heap/embedded/mixed nodes. Cyclic/malformed lists and arena-range arithmetic wrap require separate qualification; complete curve removal/renderer startup not proved. Rust replay pending.']}
(r/'data/4.20/audio_curve_subscription_cleanup_preparation.json').write_text(json.dumps(p,indent=2)+'\n',encoding='utf-8');(r/'tools/probe_native_audio_curve_subscription_cleanup.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8');print('PASS',len(rows),'actual heap/embedded subscription cleanup/free order/count wrap/header preservation cases')
