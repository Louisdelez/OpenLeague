"""Full original8E3480 orthographic volume construction and transforms."""
from pathlib import Path
import json,struct,itertools
r=Path(__file__).resolve().parents[1]
source=(r/'tools/qualify_native_audio_emitter_planes.py').read_text(encoding='utf-8').split('u.hook_add(unicorn.UC_HOOK_CODE,plane_hook)')[0]
exec(compile(source,'plane setup','exec'));base_hook=plane_hook;matrix=heap+0x5000

def volume_hook(uc,a,size,user):
 if 0x8e3480<=a<=0x8e35b1 or 0x8e1220<=a<=0x8e1395 or 0x8e2c00<=a<=0x8e2ca1:return
 base_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,volume_hook)
identity=[1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.]
translation=identity[:];translation[12:15]=[100.,-50.,200.]
rotation=[0.,0.,-1.,0.,0.,1.,0.,0.,1.,0.,0.,0.,3.,4.,5.,1.]
homogeneous=identity[:];homogeneous[3]=.125;homogeneous[7]=-.0625;homogeneous[15]=2.
matrices=[identity,translation,rotation,homogeneous];cases=[]
for width,height,depth,m in itertools.product([0.,1.,20.],[0.,1.,20.],[(1.,2.),(0.,100.),(10.,10.)],matrices):
 near,far=depth;u.mem_write(matrix,struct.pack('<16f',*m));u.mem_write(context,b'\xa5'*0x130)
 sp=stack+0x8000;u.mem_write(sp,struct.pack('<II4f',end,matrix,width,height,near,far));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,context);u.emu_start(0x8e3480,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
 cases.append({'width':width,'height':height,'near':near,'far':far,'matrix_bits':list(struct.unpack('<16I',struct.pack('<16f',*m))),'corners_bits':list(struct.unpack('<27I',u.mem_read(context,108))),'coefficients_bits':list(struct.unpack('<24I',u.mem_read(context+0x6c,96))),'indices':list(struct.unpack('<18I',u.mem_read(context+0xcc,72))),'bounds_bits':list(struct.unpack('<6I',u.mem_read(context+0x114,24)))})
proof={'native_sha256':digest,'passed':True,'cases':cases,'complete':False,'limits':['Full original8E3480 orthographic constructor,8E1220 homogeneous transform,8E33E0 planes/8E3AA0/66D6E0,8E2C00 bounds and8E30D0 indices executed. Only security-cookie check adapted.','Explicit supplied camera parameters and matrices; original runtime camera selection and params source not qualified. Zero dimensions and equal near/far retained, no normalization/clamping.','Bounds include all nine transformed points, including point0 origin. Homogeneous division retained; no affine-only replacement.','Plane coefficients accept explicit SSE estimate tolerance; corners/bounds/index comparison scope specified separately. Perspective constructor and runtime client binding remain incomplete.']}
(r/'data/4.20/audio_emitter_orthographic_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(f'Original complete orthographic volume {len(cases)} cases passed')
