from pathlib import Path
import json,struct,datetime,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_fow_terrain_ray.py').read_text(encoding='utf-8').split('\ncases=[]')[0],'native setup','exec'))
node=terrain+0x2000;spatial=terrain+0x3000;lower=terrain+0x4000;upper=terrain+0x4010;parent=terrain+0x5000;events=[]
def boundary(uc,a,size,user):
 if a==0x95f370:events.append(dict(kind='bounds',local_bits=list(struct.unpack('<6I',u.mem_read(spatial+0x10,24))),radius_bits=read32(spatial+0xc)))
 elif a==0x95ff10:
  s=u.reg_read(UC_X86_REG_ESP);assert u.reg_read(UC_X86_REG_ECX)==parent and read32(s+4)==spatial
  events.append(dict(kind='parent',integer_bounds=list(struct.unpack('<4i',u.mem_read(spatial+0x2c,16))),radius_bits=read32(spatial+0xc)))
  u.reg_write(UC_X86_REG_EIP,read32(s));u.reg_write(UC_X86_REG_ESP,s+8)
u.hook_add(unicorn.UC_HOOK_CODE,boundary)
profiles=[[-5.,-7.,-9.,5.,7.,9.],[-1.,-2.,-2.,1.,2.,2.],[0.]*6,[5.,7.,9.,-5.,-7.,-9.]]
cases=[]
for local,initial_radius,local_same,parent_present,center,int_sse in itertools.product(profiles,[0.,3.,99.],[False,True],[False,True],[[0.,0.,0.],[10.5,20.25,-30.75]],[False,True]):
 u.mem_write(spatial,bytes(0x40));write32(node+8,spatial);u.mem_write(spatial,struct.pack('<3f',*center));f(spatial+0xc,initial_radius)
 initial_local=local if local_same else [0.]*6;u.mem_write(spatial+0x10,struct.pack('<6f',*initial_local));write32(spatial+0x28,parent if parent_present else 0);u.mem_write(spatial+0x2c,struct.pack('<4i',101,202,303,404))
 u.mem_write(lower,struct.pack('<3f',*local[:3]));u.mem_write(upper,struct.pack('<3f',*local[3:]));write32(0x14ae660,int(int_sse));write32(0x2da52e8,0)
 events.clear();write32(sp,end);write32(sp+4,lower);write32(sp+8,upper);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,node)
 u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
 u.emu_start(0x95f060,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
 cases.append(dict(center=center,local_bounds=local,initial_local_bounds=initial_local,initial_radius=initial_radius,parent_present=parent_present,integer_sse=int_sse,events=list(events),final_local_bits=list(struct.unpack('<6I',u.mem_read(spatial+0x10,24))),final_radius_bits=read32(spatial+0xc),final_integer_bounds=list(struct.unpack('<4i',u.mem_read(spatial+0x2c,16)))))
 events.clear();write32(sp,end);write32(sp+4,lower);write32(sp+8,upper);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,node)
 u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
 u.emu_start(0x95f060,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
 cases[-1]['repeat']=dict(events=list(events),final_local_bits=list(struct.unpack('<6I',u.mem_read(spatial+0x10,24))),final_radius_bits=read32(spatial+0xc),final_integer_bounds=list(struct.unpack('<4i',u.mem_read(spatial+0x2c,16))))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x95f060',local_setter='0x95f2c0',actual_bound_recalculation='0x95f370',native_addresses=len(visited),cases=cases,runtime_adapters=['Only95FF10parentreindexboundary recordsupdatedstate andreturns. Original localsetter, sqrt/CRT, radiuscomparison andboundrecalculation execute.'],limits=['Suppliedfinite localbounds, centers, cachedlocal/radius states andintegerprofiles. Actual source/storage/lifecycle notgenerated.','Rustport, nonfinite/hardwareexception andarbitrary x87precision boundaries remainopen; parentreindexandlive grassrenderer notqualified.'])
(r/'data/4.20/grass_spatial_extents_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(cases=len(cases),native_addresses=len(visited))))
