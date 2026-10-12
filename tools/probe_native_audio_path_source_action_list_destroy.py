from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
source=vector+0x1000;actions=vector+0x2000;tables=vector+0x3000;blobs=vector+0x4000;registry=vector+0x5000;manager=vector+0x6000;children=vector+0x8000;vt=vector+0xc000;calls=[];visited=set();w(source,vt);w(vt+0xd0,vector+0xf020);w(0x14a7a34,registry);w(registry,tables+0x500);w(registry+4,0);w(0x14a7a08,manager);w(0xfa4424,vector+0xf000);w(0xfa4428,vector+0xf010);w(0x12100dc,19)
def snap():return {n:bytes(u.mem_read(a,size)).hex()for n,a,size in [('source',source,160),('actions',actions,128),('tables',tables,128),('blobs',blobs,128),('children',children,1536)]}
def hook(uc,a,size,data):
 if a==0xaf6f00:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'remove_action_registry','receiver':u.reg_read(UC_X86_REG_ECX),'key':read(sp+4),'action':read(sp+8),'source_at_call':bytes(u.mem_read(source,160)).hex()});return
 if a==0xb00180:calls.append({'kind':'child_source_virtual08','receiver':u.reg_read(UC_X86_REG_ECX),'at_call':snap()});return
 if a in [vector+0xf000,vector+0xf010]:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'lock'if a==vector+0xf000 else'unlock','receiver':read(sp+4)});finish(1,4);return
 if a==vector+0xf020:calls.append({'kind':'source_virtuald0','receiver':u.reg_read(UC_X86_REG_ECX),'at_call':snap()});finish(1);return
 if a==0xada3e0:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'free','pool':read(sp+4),'reference':read(sp+8),'at_call':snap()});finish(1);return
 assert 0xb00350<=a<0xb00499 or 0xaf6f00<=a<0xaf6f47 or 0xb22650<=a<0xb22658 or 0xb00180<=a<0xb00243 or 0xaf6430<=a<0xaf6445,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for pattern,action_count,entry_count,blob,argument,duplicate,flag in itertools.product([0,0xa5],[0,1,2],[0,1,3],[False,True],[0,1,256],[False,True],[0,2]):
 for a,size in[(source,160),(actions,128),(tables,128),(blobs,128),(children,1536)]:u.mem_write(a,bytes([pattern])*size)
 w(source,vt);w(source+16,actions if action_count else 0)
 for i in range(2):
  action=actions+i*64;table=tables+i*64;w(action+8,actions+64 if i+1<action_count else 0);w(action+16,blobs+i*64 if blob else 0);w(action+20,table);w(action+24,entry_count);w(action+28,8);w(action+32,0x1234+i)
  for j in range(3):
   child=children+(i*3+j)*256;w(table+j*12,0x5678 if duplicate else 0x5678+j);w(table+j*12+4,child);w(child,0xff1cd8);w(child+12,2);w(child+20,0xabcdef);u.mem_write(child+47,bytes([flag]))
 calls.clear();before=snap();w(stack,end);w(stack+4,argument);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,source);u.emu_start(0xb00350,end,count=7000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'action_count':action_count,'entry_count':entry_count,'blob':blob,'argument':argument,'duplicate':duplicate,'flag':flag,'before':before,'after':snap(),'calls':list(calls)})
proof={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'case_count':len(rows),'cases':rows,'native_addresses':len(visited),'limits':['Actual B00350 action head-pop, AF6F00 empty action registry, B22650 child.word20 clear and B00180/AF6430 actual child reference decrement/critical section choice execute. Duplicate entry keys, retained shift tails, vtableFF10EC, count-before-buffer-free, blob/table/action frees and final low-byte argument gate captured at every call/free.','SourceD0 query and OS critical sections are mandatory controlled boundaries. Child references start at2; their terminal source destructor branches excluded. Nonempty action registry, constructors, callbacks/concurrent mutations, Rust replay and complete source terminal action graph integration remain required.']}
(r/'data/4.20/audio_path_source_action_list_destroy_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual action-list destruction and child source reference cases')
