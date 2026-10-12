from pathlib import Path
import json,struct,datetime
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_fow_terrain_ray.py').read_text(encoding='utf-8').split('\ncases=[]')[0],'native setup','exec'))
wrapper=terrain+0x2000;pool=terrain+0x3000;old=[terrain+0x4000+i*0x100 for i in range(3)];stops=[terrain+0x5000+i*0x20 for i in range(3)];cursor=terrain+0x6000;owned=[];events=[]
def boundary(uc,a,size,user):
 global cursor
 if a==0x9933e0:
  s=u.reg_read(UC_X86_REG_ESP);size=read32(s+4);assert size in [12,16,80]
  p=cursor;cursor+=(size+15)&~15;u.mem_write(p,bytes(size));
  if size==80:owned.append(p)
  events.append(dict(kind='allocate',bytes=size));u.reg_write(UC_X86_REG_EAX,p);u.reg_write(UC_X86_REG_EIP,read32(s));u.reg_write(UC_X86_REG_ESP,s+4)
 elif a==0xc98528:
  s=u.reg_read(UC_X86_REG_ESP);events.append(dict(kind='free'));u.reg_write(UC_X86_REG_EIP,read32(s));u.reg_write(UC_X86_REG_ESP,s+4)
u.hook_add(unicorn.UC_HOOK_CODE,boundary)
def call(entry):
 write32(sp,end);write32(sp+4,0);write32(sp+8,0);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,wrapper);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
 u.emu_start(entry,end,count=1000000);assert u.reg_read(UC_X86_REG_EIP)==end
cases=[]
for initial_pool in [[],[0],[0,1,2]]:
 cursor=terrain+0x6000;owned=list(old);events.clear();u.mem_write(wrapper,bytes(16))
 for i,p in enumerate(old):
  u.mem_write(p,bytes(80));write32(p+0x44,stops[i]);write32(stops[i],stops[i]);write32(stops[i]+4,stops[i]);u.mem_write(p+0x4c,b'\x01');f(p+0x20,42.)
 for i,value in enumerate(initial_pool):write32(pool+i*4,old[value])
 write32(0x2d712a8,pool);write32(0x2d712ac,pool+len(initial_pool)*4);write32(0x2d712b0,pool+64);write32(0x14bef40,0)
 call(0x95ea20);service=read32(wrapper);root=read32(service+4);sentinel=read32(service+8)
 state=dict(root=owned.index(root),max_depth=read32(service),queue_count=read32(service+0xc),queue_empty=read32(sentinel)==sentinel,bounds=list(struct.unpack('<4i',u.mem_read(root+0x10,16))),midpoint=list(struct.unpack('<2i',u.mem_read(root+8,8))),depth=read32(root+4),vertical_bits=list(struct.unpack('<4I',u.mem_read(root+0x20,16))),parent_null=read32(root+0x30)==0,children_null=[read32(root+0x34+i*4)==0 for i in range(4)],queued=bool(u.mem_read(root+0x4c,1)[0]),members=read32(root+0x48),pool=[owned.index(read32(pool+i*4)) for i in range((read32(0x2d712ac)-pool)//4)])
 construct_events=list(events);events.clear();call(0x95eac0)
 cases.append(dict(initial_pool=initial_pool,constructor=state,construct_events=construct_events,wrapper_null=read32(wrapper)==0,final_pool=[owned.index(read32(pool+i*4)) for i in range((read32(0x2d712ac)-pool)//4)],destroy_events=list(events)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x95ea20',destroy='0x95eac0',native_addresses=len(visited),root_bounds=list(struct.unpack('<4i',u.mem_read(0x10b0ec4,16))),cases=cases,runtime_adapters=['Allocation9933E0/freeC98528 boundaries only; nativewrapper/service/root/listconstructors andcomplete95EAC0/95EB10/95FDA0 teardown execute.'],limits=['Suppliedglobalpool nodes withvalidemptysentinels; noallocationfailure/customhooks orpoolgrowth. Globalcross-service ownership andactualgamecaller/provider remainopen.'])
(r/'data/4.20/grass_tree_service_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),root_bounds=proof['root_bounds'])))
