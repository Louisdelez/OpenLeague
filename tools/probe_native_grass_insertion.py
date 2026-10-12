from pathlib import Path
import json,struct,itertools,datetime
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_fow_terrain_ray.py').read_text(encoding='utf-8').split('\ncases=[]')[0],'native setup','exec'))
spatial=terrain+0x2000;service=terrain+0x3000;nodes=[terrain+0x4000+i*0x100 for i in range(6)];sentinels=[terrain+0x5000+i*0x20 for i in range(6)];queue=terrain+0x6000;alloc=terrain+0x7000;alloc_cursor=alloc;events=[]
def boundary(uc,a,size,user):
 global alloc_cursor
 if a==0x9933e0:
  s=u.reg_read(UC_X86_REG_ESP);assert read32(s+4)==12
  pointer=alloc_cursor;alloc_cursor+=0x10;assert alloc_cursor<terrain+0x9000;u.mem_write(pointer,bytes(12));u.reg_write(UC_X86_REG_EAX,pointer);u.reg_write(UC_X86_REG_EIP,read32(s));u.reg_write(UC_X86_REG_ESP,s+4)
 elif a==0x9600f0:events.append(dict(kind='insert',node=nodes.index(u.reg_read(UC_X86_REG_ECX))))
 elif a==0x95eda0:
  s=u.reg_read(UC_X86_REG_ESP);events.append(dict(kind='schedule',node=nodes.index(read32(s+4))))
u.hook_add(unicorn.UC_HOOK_CODE,boundary)
boxes=[[-8,-8,-6,-6],[6,-8,8,-6],[-8,6,-6,8],[6,6,8,8],[-1,-1,1,1],[0,0,0,0],[10,10,-10,-10],[-2147483648,-1,2147483647,1],[2147483647,1,2147483647,1]]
cases=[]
for box,topology,count,queued,vertical in itertools.product(boxes,['none','quadrants','nested'],[0,15,16],[False,True],[(0.,-2.,2.),(10.,-2.,2.)]):
 alloc_cursor=alloc
 for address in [spatial,service,queue]+nodes+sentinels:u.mem_write(address,bytes(0x60))
 write32(service+8,queue);write32(queue,queue);write32(queue+4,queue);write32(service+0xc,0)
 all_bounds=[[-10,-10,10,10],[0,0,10,10],[0,-10,10,0],[-10,-10,0,0],[-10,0,0,10],[5,5,10,10]]
 for i,address in enumerate(nodes):
  write32(address,service);u.mem_write(address+0x10,struct.pack('<4i',*all_bounds[i]));u.mem_write(address+8,struct.pack('<2i',0,0) if i!=1 else struct.pack('<2i',5,5))
  u.mem_write(address+0x20,struct.pack('<4f',-5.,5.,-4.,4.));write32(address+0x44,sentinels[i]);write32(sentinels[i],sentinels[i]);write32(sentinels[i]+4,sentinels[i]);write32(address+0x48,count);u.mem_write(address+0x4c,bytes([queued]))
  existing=[terrain+0x9000+(i*17+j)*0x10 for j in range(count)]
  if existing:
   write32(sentinels[i],existing[0]);write32(sentinels[i]+4,existing[-1])
   for j,link in enumerate(existing):write32(link,existing[j+1] if j+1<count else sentinels[i]);write32(link+4,existing[j-1] if j else sentinels[i]);write32(link+8,spatial+0x100)
 if queued:
  existing=[terrain+0xa000+i*0x10 for i in range(len(nodes))];write32(queue,existing[0]);write32(queue+4,existing[-1]);write32(service+0xc,len(nodes))
  for i,link in enumerate(existing):write32(link,existing[i+1] if i+1<len(nodes) else queue);write32(link+4,existing[i-1] if i else queue);write32(link+8,nodes[i])
 if topology!='none':
  for i in range(4):write32(nodes[0]+0x34+i*4,nodes[i+1])
 if topology=='nested':write32(nodes[1]+0x34,nodes[5])
 cy,lo,hi=vertical;u.mem_write(spatial+0x2c,struct.pack('<4i',*box));f(spatial+4,cy);f(spatial+0x14,lo);f(spatial+0x20,hi)
 events.clear();write32(sp,end);write32(sp+4,spatial);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,nodes[0]);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
 u.emu_start(0x960000,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
 target=nodes.index(read32(spatial+0x28));entries=[];link=read32(sentinels[target])
 while link!=sentinels[target]:assert len(entries)<20;entries.append(read32(link+8)==spatial);link=read32(link)
 queue_nodes=[];link=read32(queue)
 while link!=queue:assert len(queue_nodes)<8;queue_nodes.append(nodes.index(read32(link+8)));link=read32(link)
 cases.append(dict(integer_bounds=box,topology=topology,initial_count=count,initial_queued=queued,vertical=list(vertical),events=list(events),target=target,vertical_bits=[list(struct.unpack('<4I',u.mem_read(n+0x20,16))) for n in nodes],counts=[read32(n+0x48) for n in nodes],queued_flags=[bool(u.mem_read(n+0x4c,1)[0]) for n in nodes],entries=entries,queue=queue_nodes,queue_count=read32(service+0xc)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x960000',actual_helpers=['0x9600f0','0x8a87e0','0x8a8400','0x95eda0'],native_addresses=len(visited),cases=cases,runtime_adapters=['Only9933E0 allocation returns mapped12byte storage; originallink construction,valuecopy,append,parentassignment,verticalupdates andqueue scheduling execute.'],limits=['Finite verticalinputs, supplied integerbounds/tree topology withvalid populatedlists/counts andinitialqueue/flags.','Allocatorfailure/exhaustion, actual split processing anddestruction/pool lifecycle, normalactorregistry/livegrassmask remainopen.'])
(r/'data/4.20/grass_insertion_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(cases=len(cases),native_addresses=len(visited))))
