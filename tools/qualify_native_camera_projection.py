"""Execute full original9861D0 dispatcher and original projection matrix constructors."""
from pathlib import Path
import json,struct,itertools
r=Path(__file__).resolve().parents[1]
source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,'native setup','exec'));camera=heap+0x8000;output=heap+0x6000
allowed=[(0x9861d0,0x98624a),(0x8e0260,0x8e0318),(0x8e0320,0x8e03e2),(0x8de500,0x8de56a)]
def hook(uc,a,size,user):assert any(lo<=a<hi for lo,hi in allowed),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
inputs=[]
for mode,fov,aspect,depth in itertools.product([0,1,2,3,0xffffffff],[0.,45.,103.,180.,-45.],[0.,.5,4./3.,16./9.],[(50.,65000.),(1.,2.),(0.,0.)]):inputs.append((mode,fov,aspect,depth,1000.,1000.))
for mode,width,height,depth in itertools.product([1,2],[0.,1000.,-1000.],[0.,1000.],[(50.,65000.),(1.,2.),(0.,0.)]):inputs.append((mode,103.,1.,depth,width,height))
cases=[]
for mode,fov,aspect,(near,far),width,height in inputs:
 u.mem_write(camera,b'\x00'*64);u.mem_write(camera+0xc,struct.pack('<2f',near,far));u.mem_write(camera+0x2c,struct.pack('<fI2f',fov,mode,width,height));u.mem_write(output,b'\xa5'*64);u.mem_write(0x14beea0,struct.pack('<f',aspect))
 sp=stack+0x7000;u.mem_write(sp,struct.pack('<II',end,output));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,camera)
 u.emu_start(0x9861d0,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 cases.append({'mode':mode,'fov_degrees':fov,'aspect_bits':read32(0x14beea0),'near':near,'far':far,'width':width,'height':height,'matrix_bits':list(struct.unpack('<16I',u.mem_read(output,64)))})
proof={'native_sha256':digest,'passed':True,'cases':cases,'complete':False,'limits':['Full9861D0 dispatcher and original8E0260/8E0320/8DE500 executed without constructor or math adapters.','Perspective x87 FPTAN and reciprocal aspect; orthographic native width/height and non-reversed depth preserved.','Zero width/height/aspect/angle and equal depths retained as native exceptional arithmetic, no arbitrary clamp.','These are native projection matrices, not yet translated into Bevy reversed depth/GPU clip conventions; visible client integration remains unqualified.']}
(r/'data/4.20/camera_projection_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(f'Original full camera projection: {len(cases)} cases passed')
