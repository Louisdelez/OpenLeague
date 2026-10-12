from pathlib import Path
import json,struct,datetime,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_simple_cycle.py').read_text().split('frames=[]')[0],'native setup','exec'))
frame=stack+0x7000;manager=heap+0x1d000;driver=manager+0x100;vtable=manager+0x200;matrix=manager+0x300
write32(0x2d79078,manager);write32(manager+0x14,driver);write32(driver,vtable);cases=[]
for bound,x,y in [(False,0.,0.)]+[(True,x,y) for x,y in itertools.product([0.,.125,.5,1.,2.],[-1.,0.,.75,1.])]:
 write32(frame+0x1c,matrix if bound else 0);f(matrix+0x40,x);f(matrix+0x44,y)
 u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_ESP,frame-0x400)
 u.emu_start(0x95c633,0x95c73e,count=500);assert u.reg_read(UC_X86_REG_EIP)==0x95c73e
 top=u.reg_read(UC_X86_REG_ESP);register,pointer,count=struct.unpack('<3I',u.mem_read(top,12));assert register==0 and count==3
 data=floats(pointer,12);expected=[0.,0.,0.,1.,1.,0.,0.,0.,x if bound else 0.,y if bound else 0.,0.,0.];assert data==expected
 cases.append(dict(matrix_present=bound,uv=[x,y],pixel_constants=data))
proof=dict(passed=True,complete=False,native_sha256=digest,entry='0x95c633',stop='0x95c73e before driver upload',cases=cases,findings=['Type5 uploads pixel constants0..2; c2.xy directly copies matrix object40/44 without clamping, null matrix produces0,0.','Caller9312E9..931301 populates these two UV values from Simple storage80/8C before92E130 matrix construction.'],limits=['Native constant preparation only; shader/device upload and Simple color-table producer not executed.'])
(r/'data/4.20/legacy_projected_color_uv_contract.json').write_text(json.dumps(proof,indent=2)+'\n');print(len(cases),'native color UV cases verified')
