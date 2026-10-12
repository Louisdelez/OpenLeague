from pathlib import Path
import json,struct,datetime,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_fow_terrain_ray.py').read_text(encoding='utf-8').split('\ncases=[]')[0],'native setup','exec'))
spatial=terrain+0x2000;cases=[]
values=[0.,-0.,.99999,-.00001,8388607.5,8388608.,2147483648.,4294967296.,-2147483904.,2.**63]
locals=[[-5.,-7.,-9.,5.,7.,9.],[-.1,-.2,-.3,.4,.5,.6],[0.]*6,[5.,7.,9.,-5.,-7.,-9.],[-.00001,0.,-.00001,.00001,0.,.00001]]
for value,local,int_sse,ceil_sse in itertools.product(values,locals,[False,True],[False,True]):
 u.mem_write(spatial,bytes(0x40));u.mem_write(spatial,struct.pack('<3f',value,123.,-value));u.mem_write(spatial+0x10,struct.pack('<6f',*local))
 write32(0x14ae660,int(int_sse));write32(0x2da52e8,int(ceil_sse))
 write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,spatial)
 u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
 try:u.emu_start(0x95f370,end,count=100000)
 except Exception as e:
  print(json.dumps(dict(value=str(value),integer_sse=int_sse,ceil_sse=ceil_sse,completed_cases=len(cases),instruction=hex(u.reg_read(UC_X86_REG_EIP)),error=str(e))));raise
 assert u.reg_read(UC_X86_REG_EIP)==end
 cases.append(dict(center_bits=list(struct.unpack('<3I',u.mem_read(spatial,12))),local_bounds_bits=list(struct.unpack('<6I',u.mem_read(spatial+0x10,24))),integer_sse=int_sse,ceil_sse=ceil_sse,integer_bounds=list(struct.unpack('<4i',u.mem_read(spatial+0x2c,16)))))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x95f370',native_addresses=len(visited),cases=cases,runtime_adapters=[],initial_failure=dict(completed_cases=180,input='NaN',integer_sse=False,ceil_sse=False,instruction='0xdf64c8',error='UC_ERR_READ_UNMAPPED'),limits=['Complete95F370 and originalCRT run with twointeger-conversion/twoceil profiles, defaultnearest SSE and x87control037F. Finite positions/localbounds supplied.','NaN/Inf prerequisite path remainsunqualified afterunmappedCRT read; notsubstituted. Hardwareexceptions, nondefaultrounding/FTZ/DAZ, originalCPU-profile producer and index lifecycle/renderintegration remainopen.'])
(r/'data/4.20/grass_spatial_rounding_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited))))
