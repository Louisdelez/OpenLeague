from pathlib import Path
import json,itertools,hashlib
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
manager=vector+0x1000;curves=vector+0x3000;delayed=vector+0x4000;bound=vector+0x5000;free_delay=vector+0x6000;free_bound=vector+0x7000
regions=[('manager',manager,0x950),('curves',curves,104),('delayed',delayed,48),('bound',bound,64),('free_delay',free_delay,12),('free_bound',free_bound,16)]
visited=set()
def snapshot():return {n:bytes(u.mem_read(a,z)).hex()for n,a,z in regions}
def hook(uc,a,z,user):assert 0xb131d0<=a<0xb1328c,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
layouts={'empty':[],'single':[33],'multiple':[33,44,55],'duplicate':[33,44,33]}
for pattern,delay_layout,curve_layout,target,count_override in itertools.product([0,165],layouts,['empty','single','two','duplicate'],[33,44,127,0],[None,0,0xffffffff]):
 for n,a,z in regions:u.mem_write(a,bytes([pattern])*z)
 u.mem_write(manager,bytes(0x950));w(free_delay,0);w(free_bound,0);w(free_bound+8,0);w(manager+0x924,free_delay)
 ids=layouts[delay_layout]
 for j,key in enumerate(ids):at=delayed+j*12;w(at,delayed+(j+1)*12 if j+1<len(ids)else 0);w(at+4,key);w(at+8,7)
 w(manager+0x91c,delayed if ids else 0);w(manager+0x920,delayed+(len(ids)-1)*12 if ids else 0);w(manager+0x930,len(ids)if count_override is None else count_override)
 lists=[] if curve_layout=='empty'else [[33]] if curve_layout=='single'else [[127],[33,44]] if curve_layout=='two'else [[33,44,33],[33]]
 for j,keys in enumerate(lists):node=curves+j*52;start=bound+j*32;w(node,curves+(j+1)*52 if j+1<len(lists)else 0);w(node+4,7+j);w(node+24,start if keys else 0);w(node+28,start+(len(keys)-1)*8 if keys else 0);w(node+32,free_bound+j*8);w(node+44,len(keys)if count_override is None else count_override)
 for j,keys in enumerate(lists):
  for k,key in enumerate(keys):at=bound+j*32+k*8;w(at,bound+j*32+(k+1)*8 if k+1<len(keys)else 0);w(at+4,key)
 w(manager+0x938,curves if lists else 0);w(manager+0x93c,curves+(len(lists)-1)*52 if lists else 0);before=snapshot();w(stack,end);w(stack+4,target);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,manager);u.emu_start(0xb131d0,end,count=2000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'delay_layout':delay_layout,'curve_layout':curve_layout,'target':target,'count_override':count_override,'before':before,'after':snapshot()})
p={'passed':True,'complete':False,'case_count':len(rows),'native_sha256':hashlib.sha256(raw).hexdigest(),'regions':[{'name':n,'reference':a,'size':z}for n,a,z in regions],'native_addresses':len(visited),'cases':rows,'limits':['Actual B131D0 original unsubscription body executed without service adapters. Delayed list searched first; otherwise each curve-bound list in order. First matching reference only; unlink head/interior/tail, decrement unsigned count (including0/MAX wrap), preserve unused bytes, push removed physical node to its matching free list; no free/allocator/callback.','Typed target references supplied; no callback or recipient object dereference. Whole B10450 delayed admission transfer/requeue, B11F20 bound requeue/cleanup and Rust replay pending.']}
(r/'data/4.20/audio_curve_subscriber_unlink_preparation.json').write_text(json.dumps(p,indent=2)+'\n',encoding='utf-8');(r/'tools/probe_native_audio_curve_subscriber_unlink.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8');print('PASS',len(rows),'actual delayed/curve subscriber first-match unlink/free-list/count-wrap cases')
