from pathlib import Path
import json,struct,itertools,datetime
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_fow_terrain_ray.py').read_text(encoding='utf-8').split('\ncases=[]')[0],'native setup','exec'))
u.mem_map(terrain+0x10000,0x100000)
node=terrain+0x2000;service=terrain+0x3000;sentinel=terrain+0x4000;queue=terrain+0x5000;out=terrain+0x6000;cursor=terrain+0x10000;members=[];events=[];created=[]
def boundary(uc,a,size,user):
 global cursor
 if a==0x9933e0:
  s=u.reg_read(UC_X86_REG_ESP);size=read32(s+4);assert size in [12,0x50]
  pointer=cursor;cursor+=(size+15)&~15;u.mem_write(pointer,bytes(size));u.reg_write(UC_X86_REG_EAX,pointer);u.reg_write(UC_X86_REG_EIP,read32(s));u.reg_write(UC_X86_REG_ESP,s+4)
 elif a==0xc98528:
  s=u.reg_read(UC_X86_REG_ESP);u.reg_write(UC_X86_REG_EIP,read32(s));u.reg_write(UC_X86_REG_ESP,s+4)
 elif a==0x95fc70:
  events.append(dict(kind='create',bounds=list(struct.unpack('<4i',u.mem_read(u.reg_read(UC_X86_REG_EDX),16)))))
 elif a==0x9600f0:
  s=u.reg_read(UC_X86_REG_ESP);events.append(dict(kind='insert',member=members.index(read32(s+4))))
u.hook_add(unicorn.UC_HOOK_CODE,boundary)
boxes=[[-100,-100,100,100],[-11,-13,17,19],[10,20,-10,-20],[-2147483648,-2147483648,2147483647,2147483647]]
quarter_cases=[]
for bounds in boxes:
 u.mem_write(node+0x10,struct.pack('<4i',*bounds));write32(sp,end);write32(sp+4,out);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,node);u.emu_start(0x9605e0,end,count=10000)
 quarter_cases.append(dict(bounds=bounds,quarters=[list(struct.unpack('<4i',u.mem_read(out+i*16,16))) for i in range(4)]))
cases=[]
profiles=[[[5,5,10,10],[-10,-10,-5,-5],[-10,5,-5,10],[5,-10,10,-5],[-90,-90,90,90]],[[0,0,0,0]]*17,[[90,90,95,95],[-95,-95,-90,-90]]]
for profile,depth,max_depth,all_children in itertools.product(range(len(profiles)),[0,1],[0,2],[False,True]):
 cursor=terrain+0x10000;created.clear();events.clear();members=[]
 for address in [node,service,sentinel,queue]:u.mem_write(address,bytes(0x60))
 write32(service,max_depth);write32(service+8,queue);write32(queue,queue);write32(queue+4,queue)
 write32(node,service);write32(node+4,depth);u.mem_write(node+0x10,struct.pack('<4i',-100,-100,100,100));u.mem_write(node+0x20,struct.pack('<4f',-5.,5.,-5.,5.));write32(node+0x44,sentinel);u.mem_write(node+0x4c,b'\x01')
 if all_children:
  for i in range(4):write32(node+0x34+i*4,terrain+0x7000+i*0x100)
 for i,bounds in enumerate(profiles[profile]):
  actor=terrain+0x8000+i*0x60;link=terrain+0x9000+i*0x20;members.append(actor);u.mem_write(actor,bytes(0x40));u.mem_write(actor+0x2c,struct.pack('<4i',*bounds));f(actor+4,float(i));f(actor+0x14,-2.);f(actor+0x20,2.);write32(actor+0x28,node)
  write32(link,link+0x20 if i+1<len(profiles[profile]) else sentinel);write32(link+4,link-0x20 if i else sentinel);write32(link+8,actor)
 write32(sentinel,terrain+0x9000);write32(sentinel+4,terrain+0x9000+(len(members)-1)*0x20);write32(node+0x48,len(members))
 for addr in [0x2d712a8,0x2d712ac,0x2d712b0,0x14bef40]:write32(addr,0)
 write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,node);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
 try:u.emu_start(0x9603c0,end,count=1000000)
 except Exception as e:print('failure',profile,depth,max_depth,all_children,hex(u.reg_read(UC_X86_REG_EIP)),str(e));raise
 assert u.reg_read(UC_X86_REG_EIP)==end
 def list_members(address):
  stop=read32(address+0x44);p=read32(stop);values=[]
  while p!=stop:assert len(values)<30;values.append(members.index(read32(p+8)));p=read32(p)
  return values
 children=[]
 for i in range(4):
  p=read32(node+0x34+i*4)
  if not p or all_children:children.append(None);continue
  children.append(dict(bounds=list(struct.unpack('<4i',u.mem_read(p+0x10,16))),midpoint=list(struct.unpack('<2i',u.mem_read(p+8,8))),depth=read32(p+4),vertical_bits=list(struct.unpack('<4I',u.mem_read(p+0x20,16))),members=list_members(p),queued=bool(u.mem_read(p+0x4c,1)[0])))
 cases.append(dict(profile=profile,member_bounds=profiles[profile],depth=depth,max_depth=max_depth,all_children=all_children,events=list(events),remaining=list_members(node),children=children,flag=bool(u.mem_read(node+0x4c,1)[0]),queue_count=read32(service+0xc),member_parent_quadrants=[next((i for i in range(4) if read32(node+0x34+i*4)==read32(m+0x28)),None) for m in members]))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x9603c0',native_addresses=len(visited),quarter_cases=quarter_cases,cases=cases,runtime_adapters=['Only9933E0 allocation returns mappedstorage andC98528 releases return; nativeconstructors/listops/childassignment/redistribution/queue execute.'],limits=['Explicit validroot/memberlists andlimits; allchildren-present guard usesnonnull placeholders withoutdereference.','Actualallocatorfailure,poolrecycling,queueconsumer95ED30 andnormalactors/livegrassmask remainopen.'])
(r/'data/4.20/grass_subdivision_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(cases=len(cases),native_addresses=len(visited))))
