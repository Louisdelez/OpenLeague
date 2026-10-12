from pathlib import Path
import json,struct,itertools,datetime
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_fow_terrain_ray.py').read_text(encoding='utf-8').split('\ncases=[]')[0],'native setup','exec'))
tree_wrapper=terrain+0x2000;wrapper=terrain+0x3000;object_pool=terrain+0x4000;recycled=terrain+0x5000;position=terrain+0x6000;lower=terrain+0x6100;upper=terrain+0x6200;node_pool=terrain+0x7000;cursor=terrain+0x8000;events=[];object_pointer=0;reservations=[]
estimates={v['input_bits']:v['estimate_bits'] for v in json.loads((r/'data/4.20/grass_spatial_extents_hardware_contract.json').read_text(encoding='utf-8'))['rsqrt_estimates']}
def snapshot(kind):
 p=object_pointer
 return dict(kind=kind,center_bits=list(struct.unpack('<3I',u.mem_read(p,12))),radius_bits=read32(p+0xc),local_bits=list(struct.unpack('<6I',u.mem_read(p+0x10,24))),integer_bounds=list(struct.unpack('<4i',u.mem_read(p+0x2c,16))))
def boundary(uc,a,size,user):
 global cursor,object_pointer
 if a==0x9933e0:
  s=u.reg_read(UC_X86_REG_ESP);n=read32(s+4);assert n in [4,8,12,16,64,80]
  p=cursor;cursor+=(n+15)&~15;u.mem_write(p,bytes(n));u.reg_write(UC_X86_REG_EAX,p);u.reg_write(UC_X86_REG_EIP,read32(s));u.reg_write(UC_X86_REG_ESP,s+4)
 elif a==0xc98528:
  s=u.reg_read(UC_X86_REG_ESP);u.reg_write(UC_X86_REG_EIP,read32(s));u.reg_write(UC_X86_REG_ESP,s+4)
 elif a==0x96b078:
  reservations.append(u.reg_read(UC_X86_REG_EDI))
 elif a==0x95eea2:
  object_pointer=u.reg_read(UC_X86_REG_EAX);events.append(snapshot('constructed'))
 elif a==0x95f370:events.append(snapshot('bounds'))
 elif a==0x9600f0:events.append(snapshot('insert'))
 elif a==0x5fa7dd:
  bits=u.reg_read(UC_X86_REG_XMM3)&0xffffffff;assert bits in estimates,hex(bits);old=u.reg_read(UC_X86_REG_XMM1);u.reg_write(UC_X86_REG_XMM1,(old&~0xffffffff)|estimates[bits])
u.hook_add(unicorn.UC_HOOK_CODE,boundary)
def call(entry,ecx,args=[]):
 write32(sp,end)
 for i,v in enumerate(args):write32(sp+4+i*4,v)
 u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,ecx);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
 u.emu_start(entry,end,count=1000000);assert u.reg_read(UC_X86_REG_EIP)==end
cases=[]
for reuse,center,local,sse in itertools.product([False,True],[[0.,0.,0.],[10.5,20.25,-30.75]],[[-5.,-7.,-9.,5.,7.,9.],[0.]*6,[-.1,-.2,-.3,.4,.5,.6]],[False,True]):
 cursor=terrain+0x8000;u.mem_write(recycled,bytes(64));u.mem_write(recycled+0x10,struct.pack('<6f',2.,3.,4.,5.,6.,7.));u.mem_write(recycled+0x2c,struct.pack('<4i',101,202,303,404))
 for a in [0x14bef40,0x2d712ac,0x2d712a8,0x2d712b0]:write32(a,0)
 call(0x95ea20,tree_wrapper,[0,0]);service=read32(tree_wrapper);root=read32(service+4);write32(wrapper,tree_wrapper);write32(wrapper+8,0)
 write32(0x2d712b4,object_pool);write32(0x2d712b8,object_pool+(4 if reuse else 0));write32(0x2d712bc,object_pool+(4 if reuse else 0));write32(object_pool,recycled)
 write32(0x2d712a8,node_pool);write32(0x2d712ac,node_pool);write32(0x2d712b0,node_pool+128);write32(0x14ae660,int(sse));write32(0x2da52e8,0)
 u.mem_write(position,struct.pack('<3f',*center));u.mem_write(lower,struct.pack('<3f',*local[:3]));u.mem_write(upper,struct.pack('<3f',*local[3:]));row=dict(reuse=reuse,center=center,local=local,integer_sse=sse)
 for repeat in [False,True]:
  events.clear();reservations.clear();call(0x95ee90,wrapper,[position,lower,upper]);assert read32(wrapper+8)==object_pointer
  result=dict(events=list(events),final=snapshot('final'),root_members=read32(root+0x48),parent_is_root=read32(object_pointer+0x28)==root,owner_is_wrapper=read32(object_pointer+0x3c)==wrapper,object_pool_size=(read32(0x2d712b8)-read32(0x2d712b4))//4)
  call(0x95f1d0,object_pointer);result['after_unregister']=dict(parent_null=read32(object_pointer+0x28)==0,root_members=read32(root+0x48),object_pool_size=(read32(0x2d712b8)-read32(0x2d712b4))//4,pool_top_same=read32(read32(0x2d712b8)-4)==object_pointer)
  result['pool_capacity']=(read32(0x2d712bc)-read32(0x2d712b4))//4;result['reservations']=list(reservations)
  if repeat:row['repeat']=result
  else:row.update(result)
 cases.append(row)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x95ee90',object_constructor='0x95f230',unregister='0x95f1d0',native_addresses=len(visited),cases=cases,runtime_adapters=['Allocation9933E0/freeC98528 andsame-PC RSQRTSS estimates only. Registration/constructor/bounds/radius/treeinsertion/unregister/objectpoolpush execute.'],limits=['Zeroednewallocation storage andexplicitrecycled local/integerstate, finitepositions/bounds,twointegerprofiles,defaultroot andpreallocatedpools. Freshinteger fields areallocator-supplied, notinitializedby95F230.','Small supplied successful allocations only; OOM/custom allocator and global cross-context ownership remain unqualified. Wrapper/model/camera and live grass rendering remain open.'])
(r/'data/4.20/grass_object_growth_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(cases=len(cases),native_addresses=len(visited))))
