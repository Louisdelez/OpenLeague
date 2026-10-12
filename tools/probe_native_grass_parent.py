from pathlib import Path
import json,struct,itertools,datetime
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_fow_terrain_ray.py').read_text(encoding='utf-8').split('\ncases=[]')[0],'native setup','exec'))
spatial=terrain+0x2000;parent=terrain+0x3000;service=terrain+0x4000;root=terrain+0x4500;sentinel=terrain+0x5000
ancestors=[terrain+0x6000,terrain+0x6100];links=[terrain+0x7000+i*0x20 for i in range(5)];events=[]
def ret(pop):
 s=u.reg_read(UC_X86_REG_ESP);u.reg_write(UC_X86_REG_EIP,read32(s));u.reg_write(UC_X86_REG_ESP,s+4+pop)
def boundary(uc,a,size,user):
 if a==0x9606d0:
  s=u.reg_read(UC_X86_REG_ESP);events.append(dict(kind='expand',argument_bits=list(struct.unpack('<2I',u.mem_read(s+4,8)))))
 elif a==0x8a7c40:
  s=u.reg_read(UC_X86_REG_ESP);pointer=read32(s+8);events.append(dict(kind='erase',index=links.index(pointer)))
 elif a==0xc98528:
  s=u.reg_read(UC_X86_REG_ESP);assert read32(s+4) in links;events.append(dict(kind='free_link',index=links.index(read32(s+4))));ret(0)
 elif a==0x960350:events.append(dict(kind='cleanup',level=([parent]+ancestors).index(u.reg_read(UC_X86_REG_ECX)),parent_cleared=read32(spatial+0x28)==0))
 elif a==0x95fda0:
  events.append(dict(kind='destroy',level=([parent]+ancestors).index(u.reg_read(UC_X86_REG_ECX))));ret(0)
 elif a==0x9600f0:
  s=u.reg_read(UC_X86_REG_ESP);assert u.reg_read(UC_X86_REG_ECX)==root and read32(s+4)==spatial
  events.append(dict(kind='insert_root',parent_cleared=read32(spatial+0x28)==0));ret(4)
u.hook_add(unicorn.UC_HOOK_CODE,boundary)
boxes=[[-10,-10,10,10],[-9,-9,9,9],[10,10,-10,-10],[-11,0,1,1],[0,-11,1,1],[0,0,11,1],[0,0,1,11],[-2147483648,0,2147483647,1]]
verticals=[(0.,-4.,4.),(0.,-5.,5.),(0.,-6.,6.),(10.,-2.,2.),(-10.,-2.,2.),(0.,4.,-4.)]
member_profiles=[[],[True],[False,True,False],[False,False,True],[True,False,True],[False,False]]
cases=[]
for box,(cy,lo,hi),members,depth in itertools.product(boxes,verticals,member_profiles,[0,1,2]):
 for address in [spatial,parent,service,root,sentinel]+ancestors+links:u.mem_write(address,bytes(0x60))
 u.mem_write(spatial+0x2c,struct.pack('<4i',*box));f(spatial+4,cy);f(spatial+0x14,lo);f(spatial+0x20,hi);write32(spatial+0x28,parent)
 write32(parent,service);write32(service+4,root);u.mem_write(parent+0x10,struct.pack('<4i',-10,-10,10,10));u.mem_write(parent+0x20,struct.pack('<4f',-5.,5.,-4.,4.))
 write32(parent+0x44,sentinel);write32(parent+0x48,len(members));write32(sentinel,links[0] if members else sentinel);write32(sentinel+4,links[len(members)-1] if members else sentinel)
 for i,target in enumerate(members):
  write32(links[i],links[i+1] if i+1<len(members) else sentinel);write32(links[i]+4,links[i-1] if i else sentinel);write32(links[i]+8,spatial if target else spatial+0x80)
 chain=[parent]+ancestors[:depth]
 for i in range(depth):
  child,outer=chain[i:i+2];write32(child+0x30,outer);write32(outer+0x34,child);u.mem_write(outer+0x20,struct.pack('<4f',-5.,5.,-4.,4.))
 write32(0x14bef40,0);events.clear();write32(sp,end);write32(sp+4,spatial);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,parent)
 u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
 u.emu_start(0x95ff10,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
 remaining=[];link=read32(sentinel)
 while link!=sentinel:
  assert len(remaining)<6;remaining.append(links.index(link));link=read32(link)
 cases.append(dict(integer_bounds=box,center_y=cy,lower_y=lo,upper_y=hi,members=members,depth=depth,events=list(events),remaining_member_indices=remaining,member_count=read32(parent+0x48),parent_cleared=read32(spatial+0x28)==0,vertical_bits=[list(struct.unpack('<4I',u.mem_read(n+0x20,16))) for n in chain],child_present=[read32(n+0x34)!=0 for n in chain]))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x95ff10',actual_helpers=['0x9606d0','0x8a7c40','0x960350','0x960000'],native_addresses=len(visited),margin_bits=read32(0x1138b40),cases=cases,runtime_adapters=['Allocator free C98528 records supplied list links and returns; unlink/count instructions execute.','95FDA0 node destructor records detached node and returns; recursive cleanup and child detachment execute.','9600F0 root insertion boundary records target and returns; actual960000 no-child selection executes.'],limits=['Finite vertical values, explicit signed integerbounds, valid lists and supplied ancestor topology. No allocator/destructor or full insertion semantics qualified.','Child selection during reinsertion, registry/provider lifecycle and normal grass renderer remain open.'])
(r/'data/4.20/grass_parent_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),margin_bits=proof['margin_bits'])))
