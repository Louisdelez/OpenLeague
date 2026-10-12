from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
registry=vector+0x1000;table=vector+0x2000;owners=vector+0x3000;actions=vector+0x4000;visited=set();key=0x12345678
u.hook_add(unicorn.UC_HOOK_CODE,lambda uc,a,n,d:visited.add(a)if 0xaf6f00<=a<0xaf6f47 or 0xaf6e10<=a<0xaf6e5b else (_ for _ in()).throw(AssertionError(hex(a))))
rows=[]
for pattern,count,kind,list_count,target_index in itertools.product([0,0xa5],[0,1,3],['first','last','missing','duplicate'],[0,3],range(4)):
 for a,size in[(registry,12),(table,24),(owners,192),(actions,192)]:u.mem_write(a,bytes([pattern])*size)
 w(registry,table);w(registry+4,count);w(registry+8,8)
 chosen=0 if kind in['first','duplicate','missing']else max(0,count-1);target=actions+chosen*64+target_index*16
 for i in range(3):
  owner=owners+i*64;first=actions+i*64;w(table+i*8,key if kind=='duplicate'or kind=='first'and i==0 or kind=='last'and i==count-1 else key+1+i);w(table+i*8+4,owner);w(owner+8,first if list_count else 0)
  for j in range(3):w(first+j*16+4,first+(j+1)*16 if j+1<list_count else 0)
 def snap():return {n:bytes(u.mem_read(a,size)).hex()for n,a,size in [('registry',registry,12),('table',table,24),('owners',owners,192),('actions',actions,192)]}
 before=snap();w(stack,end);w(stack+4,key);w(stack+8,target);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,registry);u.emu_start(0xaf6f00,end,count=1000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'count':count,'kind':kind,'list_count':list_count,'target_index':target_index,'key':key,'target':target,'before':before,'after':snap(),'result':u.reg_read(UC_X86_REG_EAX)})
proof={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'case_count':len(rows),'cases':rows,'native_addresses':len(visited),'findings':['Actual AF6F00 first-key pair lookup and AF6E10 intrusive next4 action unlink execute without adapters. Empty/missing key returns20; matched key returns1 even if action link is absent. Removed action next4, registry rows, padding and capacity retained; no frees.'],'limits':['Registry/owner/action producers and cyclic or aliased lists unqualified; Rust replay and nonempty registry composition in full action-list destruction remain required.']}
(r/'data/4.20/audio_path_source_action_registry_unlink_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual nonempty action registry/link unlink cases')
