"""Original986150 camera defaults,9861D0 render/98648B culling dispatch."""
from pathlib import Path
import json,struct,itertools
r=Path(__file__).resolve().parents[1]
source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,'native setup','exec'));camera=heap+0x8000;position=heap+0x7000;output=heap+0x6000;calls=[]
def dispatch_hook(uc,a,size,user):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a in [0x8e0320,0x8e0260]:
  calls.append({'kind':'perspective' if a==0x8e0320 else 'orthographic','parameter_bits':[read32(sp+i) for i in [4,8,12,16]]});finish(eax=output);return
 if a in [0x8e2f30,0x8e3480]:
  offsets=[12,16,20,24] if a==0x8e2f30 else [8,12,16,20]
  calls.append({'kind':'perspective' if a==0x8e2f30 else 'orthographic','parameter_bits':[read32(sp+i) for i in offsets]});finish(24 if a==0x8e2f30 else 20,eax=output);return
 if a in [0x9864c5,0x9864f8]:u.emu_stop();return
 assert 0x986150<=a<=0x9861c2 or 0x9861d0<=a<=0x986249 or 0x986485<=a<=0x9864f8,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,dispatch_hook);initializers=[]
for xyz in [[0.,0.,0.],[1.,2.,3.],[-100.,500.,10000.],[1e6,-1e6,1e6]]:
 u.mem_write(position,struct.pack('<3f',*xyz));u.mem_write(camera,b'\xa5'*64);sp=stack+0x7000;u.mem_write(sp,struct.pack('<II',end,position));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,camera);u.emu_start(0x986150,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 initializers.append({'position':xyz,'camera_words':list(struct.unpack('<16I',u.mem_read(camera,64)))})
cases=[]
for mode,fov,aspect in itertools.product([0,1,2,3,0xffffffff],[45.,103.],[1.,4./3.,16./9.]):
 write32(camera+0x30,mode);u.mem_write(camera+0x2c,struct.pack('<f',fov));u.mem_write(0x14beea0,struct.pack('<f',aspect));calls=[]
 sp=stack+0x7000;u.mem_write(sp,struct.pack('<II',end,output));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,camera);u.emu_start(0x9861d0,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end;render=calls[:];calls=[]
 bp=stack+0x8000;write32(bp-8,camera);write32(bp-4,output);u.reg_write(UC_X86_REG_EBP,bp);u.reg_write(UC_X86_REG_ESP,stack+0x7000);u.emu_start(0x986485,end,count=10000);assert u.reg_read(UC_X86_REG_EIP) in [0x9864c5,0x9864f8];cull=calls[:]
 assert len(render)==len(cull)==1;assert render[0]['kind']==('orthographic' if mode in [1,2] else 'perspective');assert cull[0]['kind']==('perspective' if mode==0 else 'orthographic')
 cases.append({'mode':mode,'fov_degrees':fov,'aspect_bits':read32(0x14beea0),'render':render[0],'culling':cull[0]})
proof={'native_sha256':digest,'passed':True,'initializers':initializers,'cases':cases,'render_degrees_factor_bits':read32(0x1138a68),'culling_pi_bits':read32(0x1138eac),'culling_degrees_factor_bits':read32(0x1138a3c),'complete':False,'limits':['Actual986150 initialization and9861D0 render dispatcher executed; projection matrix constructors explicitly capture-only adapters.','Actual986485 culling dispatcher fragment executed with supplied matrix storage; earlier9863A0 view conversion/inversion excluded, volume constructors capture-only adapters.','Mode1/2 render orthographic, other modes perspective; culling mode0 perspective and allnonzero orthographic. Raw mismatch retained.','Generic defaults are not proven final in-game camera settings; subsequent camera setters/global aspect initialization and real camera runtime binding unqualified.']}
(r/'data/4.20/camera_parameters_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(f'Original camera {len(initializers)} initializer / {len(cases)} dual-dispatch cases passed')
