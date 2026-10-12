from pathlib import Path
import json,struct,datetime,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_fow_terrain_ray.py').read_text(encoding='utf-8').split('\ncases=[]')[0],'native setup','exec'))
spatial=terrain+0x2000;cases=[]
for center,local in itertools.product([[0.,0.,0.],[10.5,20.25,-30.75],[-10.5,0.,-.25],[16777216.,123.,16777216.]], [[-5.,-7.,-9.,5.,7.,9.],[-.1,-.2,-.3,.4,.5,.6],[0.]*6,[5.,7.,9.,-5.,-7.,-9.],[-.00001,0.,-.00001,.00001,0.,.00001]]):
 u.mem_write(spatial,bytes(0x40));u.mem_write(spatial,struct.pack('<3f',*center));u.mem_write(spatial+0x10,struct.pack('<6f',*local))
 write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,spatial)
 u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
 u.emu_start(0x95f370,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
 cases.append(dict(center=center,local_bounds=local,integer_bounds=list(struct.unpack('<4i',u.mem_read(spatial+0x2c,16)))))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x95f370',native_addresses=len(visited),cases=cases,runtime_adapters=[],limits=['Complete original95F370 and internalCRT routines execute without adapters on supplied finite centers/localbounds, including negative/inverted/tinyfractional/largecoordinates.','Local bounds/provider creation, NaN/infinite/overflow/hardwareexception modes, actual tree lifecycle and Rust port remain open.'])
(r/'data/4.20/grass_spatial_bounds_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),sample=cases[5])))
