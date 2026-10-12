from pathlib import Path
import json,struct,itertools,datetime
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_fow_terrain_ray.py').read_text(encoding='utf-8').split('\ncases=[]')[0],'native setup','exec'))
u.mem_map(terrain+0x10000,0x100000)
nodes=[terrain+0x2000+i*0x100 for i in range(7)];sentinels=[terrain+0x3000+i*0x20 for i in range(7)];service=terrain+0x4000;queue=terrain+0x5000;pool=terrain+0x6000;bounds=terrain+0x7000;cursor=terrain+0x10000;owned=[];events=[]
def boundary(uc,a,size,user):
 global cursor
 if a==0x9933e0:
  s=u.reg_read(UC_X86_REG_ESP);size=read32(s+4);assert size in [12,0x50]
  p=cursor;cursor+=(size+15)&~15;u.mem_write(p,bytes(size))
  if size==0x50:owned.append(p);events.append(dict(kind='allocate_node',node=owned.index(p)))
  u.reg_write(UC_X86_REG_EAX,p);u.reg_write(UC_X86_REG_EIP,read32(s));u.reg_write(UC_X86_REG_ESP,s+4)
 elif a==0xc98528:
  s=u.reg_read(UC_X86_REG_ESP);u.reg_write(UC_X86_REG_EIP,read32(s));u.reg_write(UC_X86_REG_ESP,s+4)
 elif a==0x95fda0:events.append(dict(kind='destroy',node=owned.index(u.reg_read(UC_X86_REG_ECX))))
 elif a==0x8a7c40:events.append(dict(kind='remove_queue'))
u.hook_add(unicorn.UC_HOOK_CODE,boundary)
def call(entry,ecx,edx=0,args=[]):
 write32(sp,end)
 for i,value in enumerate(args):write32(sp+4+i*4,value)
 u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,ecx);u.reg_write(UC_X86_REG_EDX,edx);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
 u.emu_start(entry,end,count=1000000);assert u.reg_read(UC_X86_REG_EIP)==end
def queue_values():
 p=read32(queue);values=[]
 while p!=queue:assert len(values)<20;values.append(owned.index(read32(p+8)));p=read32(p)
 return values
cases=[]
for topology,queue_profile,member_count,existing_pool in itertools.product(['root','chain','branch'],['none','all','flag_only','duplicate'],[0,3],[False,True]):
 cursor=terrain+0x10000;owned=list(nodes);events.clear()
 for address in nodes+sentinels+[service,queue,pool,bounds]:u.mem_write(address,bytes(0x100))
 for i,p in enumerate(nodes):
  write32(p,service);write32(p+0x44,sentinels[i]);write32(sentinels[i],sentinels[i]);write32(sentinels[i]+4,sentinels[i]);u.mem_write(p+0x20,struct.pack('<4f',-1.,1.,-2.,2.))
 count=1 if topology=='root' else 3 if topology=='chain' else 5
 children=[[None]*4 for _ in range(7)]
 if topology=='chain':children[0][0]=1;children[1][2]=2
 if topology=='branch':children[0]=[1,2,3,4]
 for i in range(count):
  for slot,child in enumerate(children[i]):
   if child is not None:write32(nodes[i]+0x34+slot*4,nodes[child]);write32(nodes[child]+0x30,nodes[i])
  write32(nodes[i]+0x48,member_count)
  if member_count:
   links=[terrain+0x8000+(i*4+j)*0x10 for j in range(member_count)];write32(sentinels[i],links[0]);write32(sentinels[i]+4,links[-1])
   for j,p in enumerate(links):write32(p,links[j+1] if j+1<member_count else sentinels[i]);write32(p+4,links[j-1] if j else sentinels[i]);write32(p+8,terrain+0xc000)
  u.mem_write(nodes[i]+0x4c,bytes([queue_profile!='none']))
 initial_queue=list(reversed(range(count))) if queue_profile=='all' else [0,0]+list(range(1,count)) if queue_profile=='duplicate' else []
 write32(service+8,queue);write32(service+0xc,len(initial_queue));links=[terrain+0xa000+i*0x10 for i in range(len(initial_queue))];write32(queue,links[0] if links else queue);write32(queue+4,links[-1] if links else queue)
 for i,value in enumerate(initial_queue):write32(links[i],links[i+1] if i+1<len(links) else queue);write32(links[i]+4,links[i-1] if i else queue);write32(links[i]+8,nodes[value])
 initial_pool=[5,6] if existing_pool else []
 for i,value in enumerate(initial_pool):write32(pool+i*4,nodes[value])
 write32(0x2d712a8,pool);write32(0x2d712ac,pool+4*len(initial_pool));write32(0x2d712b0,pool+4*32);write32(0x14bef40,0)
 call(0x95fda0,nodes[0]);destroy_events=list(events);final_pool=[owned.index(read32(pool+i*4)) for i in range((read32(0x2d712ac)-pool)//4)]
 before_reuse=dict(queue=queue_values(),queue_count=read32(service+0xc),pool=final_pool,member_counts=[read32(p+0x48) for p in nodes[:count]],queued_flags=[bool(u.mem_read(p+0x4c,1)[0]) for p in nodes[:count]])
 events.clear();reused=[]
 for step in range(len(final_pool)+1):
  values=[-11-step,-13,17+step,19];u.mem_write(bounds,struct.pack('<4i',*values));call(0x95fc70,service,bounds,[step+2]);p=u.reg_read(UC_X86_REG_EAX)
  reused.append(dict(node=owned.index(p),bounds=list(struct.unpack('<4i',u.mem_read(p+0x10,16))),midpoint=list(struct.unpack('<2i',u.mem_read(p+8,8))),depth=read32(p+4),vertical_bits=list(struct.unpack('<4I',u.mem_read(p+0x20,16))),parent_null=read32(p+0x30)==0,children_null=[read32(p+0x34+i*4)==0 for i in range(4)],queued=bool(u.mem_read(p+0x4c,1)[0]),member_count=read32(p+0x48),sentinel_empty=read32(read32(p+0x44))==read32(p+0x44)))
 cases.append(dict(topology=topology,children=children[:count],queue_profile=queue_profile,member_count=member_count,initial_queue=initial_queue,initial_pool=initial_pool,destroy_events=destroy_events,after_destroy=before_reuse,reuse_events=list(events),reused=reused,final_pool_size=(read32(0x2d712ac)-pool)//4))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x95fda0',reuse='0x95fc70',native_addresses=len(visited),cases=cases,runtime_adapters=['Only9933E0 returnsstorage andC98528 release returns. Nativequeuedremove,recursivechilddestruction,listclear,poolpush,poppointer andconstructor reset execute.'],limits=['Suppliedvalid node/lists/queue/pool withpreallocated32pointer capacity. Poolgrowth/allocatorfailure andactualsource lifecycle notqualified.','Flagonly/duplicatequeue states explicitlyprovided stresscases; no assertionthatactualgame producers create them. Actors referencingdestroyednodes are notcleared byoriginaldestructor; callerownership remainsopen.'])
(r/'data/4.20/grass_pool_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(cases=len(cases),native_addresses=len(visited))))
