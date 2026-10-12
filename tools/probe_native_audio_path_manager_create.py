from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
manager=vector+0x5000;table=vector+0x7000;node=vector+0x8000;calls=[];allocated=False;freed=False;visited=set()
def hook(uc,a,size,data):
 global allocated,freed
 if a==0xada670:
  sp=u.reg_read(UC_X86_REG_ESP);pool,size=read(sp+4),read(sp+8);assert pool==17 and size==108;ref=0 if failure else node;calls.append({'kind':'allocate','pool':pool,'bytes':size,'reference':ref});allocated=bool(ref)
  if ref:u.mem_write(node,bytes([pattern])*108)
  finish(ref);return
 if a==0xada3e0:
  sp=u.reg_read(UC_X86_REG_ESP);pool,ref=read(sp+4),read(sp+8);assert pool==17 and ref==node and allocated and not freed;freed=True;calls.append({'kind':'free','pool':pool,'reference':ref});finish(1);return
 if a==0x5642d0:calls.append({'kind':'destroy_node','reference':u.reg_read(UC_X86_REG_ECX)})
 assert 0xb13fa0<=a<0xb1400d or 0xb1b480<=a<0xb1b4dd or 0x5642d0<=a<0x5642d3,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for pattern,count,spare,limit,failure in itertools.product([0,0xa5],[0,1,3],[False,True],[0,1,3,255],[False,True]):
 calls.clear();allocated=freed=False;capacity=max(4,count)if spare else count;u.mem_write(manager,bytes([pattern])*16);w(manager,table if capacity else 0);w(manager+4,count);w(manager+8,capacity);w(manager+12,limit);u.mem_write(table,bytes([pattern])*capacity*4);w(0x12100dc,17)
 for i in range(count):w(table+i*4,vector+0x9000+i*128)
 def snap():return {'manager':bytes(u.mem_read(manager,16)).hex(),'table':bytes(u.mem_read(table,capacity*4)).hex(),'objects':[{'reference':node,'raw':bytes(u.mem_read(node,108)).hex(),'freed':freed}]if allocated else []}
 before=snap();w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,manager);u.emu_start(0xb13fa0,end,count=3000);assert u.reg_read(UC_X86_REG_EIP)==end;rows.append({'pattern':pattern,'failure':failure,'before':before,'after':snap(),'result':u.reg_read(UC_X86_REG_EAX),'calls':list(calls)})
proof={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0xb13fa0','case_count':len(rows),'cases':rows,'native_addresses':len(visited),'findings':['Maximum node count is checked before physical allocation. Allocation requests108 bytes; actual constructor executes. Publication requires spare existing table capacity; otherwise empty node destructor and physical free run and null is returned. No table growth occurs in this routine.'],'limits':['Physical allocation/free are controlled mandatory transports. Consistent supplied manager storage/count/capacity only. Rust manager create/publication, owning removal and full frame lifetime integration remain required.']}
(r/'data/4.20/audio_path_manager_create_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native manager create/publication cases')
