from pathlib import Path
import json,struct,datetime,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_simple_cycle.py').read_text().split('frames=[]')[0],'native setup','exec'))
frame=stack+0x6000;manager=heap+0x1d000;driver=heap+0x1d100;vtable=heap+0x1d200;position=heap+0x1d300
write32(0x2d79078,manager);write32(manager+0x14,driver);write32(driver,vtable)
cases=[]
for height,span,fade in itertools.product([-100.,0.,23.5,1000.],[0.,1.,100.,100000.],[0.,1.,25.]):
 write32(frame-0x18,definition);f(position+4,height);f(definition+0x1cc,span);f(definition+0x1d0,fade);write32(frame-4,0x12345678)
 u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_ESP,frame-0x200);u.reg_write(UC_X86_REG_EDX,position)
 u.emu_start(0x93130f,0x93134e,count=100);assert u.reg_read(UC_X86_REG_EIP)==0x93134e
 stack_now=u.reg_read(UC_X86_REG_ESP);register,pointer,count=struct.unpack('<3I',u.mem_read(stack_now,12));assert register==227 and count==1
 values=floats(pointer,4);assert values[:3]==[height,span,fade];assert read32(pointer+12)==0x12345678
 cases.append(dict(height=height,range=span,fade=fade,uploaded_xyz=values[:3]))
proof=dict(passed=True,complete=False,native_sha256=digest,entry='0x93130f',stop='0x93134e before driver upload',cases=cases,findings=['Native upload setup sets c227.xyz to current position.y, definition1CC, definition1D0 with no clamp or scaling.','Fourth component not initialized in this span; shader uses xyz only.'],limits=['Definition and particle position inputs supplied. Native field reader/defaults and actual Annie values still to bind.','Device upload boundary and original GPU not executed.'])
(r/'data/4.20/projected_height_upload_contract.json').write_text(json.dumps(proof,indent=2)+'\n');print(len(cases),'native height uploads verified')
