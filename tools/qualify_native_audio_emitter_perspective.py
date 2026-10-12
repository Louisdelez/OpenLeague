"""Full original8E2F30 perspective volume, native x87 FPTAN retained."""
from pathlib import Path
import json,struct,itertools
r=Path(__file__).resolve().parents[1]
source=(r/'tools/qualify_native_audio_emitter_orthographic.py').read_text(encoding='utf-8').split('u.hook_add(unicorn.UC_HOOK_CODE,volume_hook)')[0]
exec(compile(source,'volume setup','exec'));orthographic_hook=volume_hook

def perspective_hook(uc,a,size,user):
 if 0x8e2f30<=a<=0x8e30c6:return
 orthographic_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,perspective_hook)
identity=[1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.]
translation=identity[:];translation[12:15]=[100.,-50.,200.]
rotation=[0.,0.,-1.,0.,0.,1.,0.,0.,1.,0.,0.,0.,3.,4.,5.,1.]
cases=[]
for angle_a,angle_b,depth,factor,m in itertools.product([0.,.5,1.],[.25,.75],[(0.,10.),(1.,2.)],[.5,1.,2.],[identity,translation,rotation]):
 near,far=depth;u.mem_write(matrix,struct.pack('<16f',*m));u.mem_write(context,b'\xa5'*0x130);u.mem_write(0x14beea0,struct.pack('<f',factor))
 sp=stack+0x8000;u.mem_write(sp,struct.pack('<II5f',end,matrix,123.,angle_a,angle_b,near,far));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,context);u.emu_start(0x8e2f30,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
 cases.append({'angle_a':angle_a,'angle_b':angle_b,'near':near,'far':far,'factor':factor,'matrix_bits':list(struct.unpack('<16I',struct.pack('<16f',*m))),'corners_bits':list(struct.unpack('<27I',u.mem_read(context,108))),'coefficients_bits':list(struct.unpack('<24I',u.mem_read(context+0x6c,96))),'indices':list(struct.unpack('<18I',u.mem_read(context+0xcc,72))),'bounds_bits':list(struct.unpack('<6I',u.mem_read(context+0x114,24)))})
proof={'native_sha256':digest,'passed':True,'cases':cases,'complete':False,'limits':['Full8E2F30 perspective constructor with native x87FPTAN and all8E1220/8E3350/8E3AA0/66D6E0/8E2C00/8E30D0 dependencies executed. Security check adapted only.','Parameters angleA/B, near/far, transform and global14BEEA0 factor explicit controlled inputs. Actual runtime parameter meanings/selection not inferred.','Native near/far use different tangent scaling and asymmetric coordinates; retain original formulas, no generic FOV/aspect substitute.','SSErsqrt coefficient tolerance explicit; x87 processor/emulator differences require stated corner comparison tolerance. Runtime camera binding and particle lifecycle remain incomplete.']}
(r/'data/4.20/audio_emitter_perspective_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(f'Original complete perspective volume {len(cases)} cases passed')
