"""Original8E3350/8E33E0 plane construction,8E3AA0/66D6E0 normalization,8E30D0 indices."""
from pathlib import Path
import json,struct,itertools
r=Path(__file__).resolve().parents[1]
source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,'native setup','exec'))
context=heap+0x8000

def plane_hook(uc,a,size,user):
 if a==0xc975f5:finish(eax=u.reg_read(UC_X86_REG_EAX));return
 assert 0x8e3350<=a<=0x8e33d9 or 0x8e33e0<=a<=0x8e3476 or 0x8e3aa0<=a<=0x8e3c02 or 0x66d6e0<=a<=0x66d729 or 0x8e30d0<=a<=0x8e3344,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,plane_hook)
def run(address):
 sp=stack+0x8000;write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,context);u.emu_start(address,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
cases=[]
for mode,scale,shift,rotation in itertools.product(['perspective','orthographic'],[.001,1.,10.],[0.,100.],range(4)):
 local=[[0.,0.,0.],[1.,-1.,-1.],[1.,1.,-1.],[-1.,1.,-1.],[-1.,-1.,-1.],[2.,-2.,-2.],[2.,2.,-2.],[-2.,2.,-2.],[-2.,-2.,-2.]]
 points=[]
 for v in local:
  x,y,z=[value*scale for value in v]
  for _ in range(rotation):x,z=-z,x
  points.append([x+shift,y-shift,z+shift])
 u.mem_write(context,struct.pack('<27f',*(v for point in points for v in point)));run(0x8e3350 if mode=='perspective' else 0x8e33e0);run(0x8e30d0)
 coefficients=list(struct.unpack('<24I',u.mem_read(context+0x6c,96)));indices=list(struct.unpack('<18I',u.mem_read(context+0xcc,72)))
 cases.append({'mode':mode,'points_bits':list(struct.unpack('<27I',struct.pack('<27f',*(v for point in points for v in point)))),'coefficients_bits':coefficients,'indices':indices})
for mode in ['perspective','orthographic']:
 u.mem_write(context,b'\0'*0x130);run(0x8e3350 if mode=='perspective' else 0x8e33e0);run(0x8e30d0);assert bytes(u.mem_read(context+0x6c,96))==b'\0'*96
 cases.append({'mode':mode,'points_bits':[0]*27,'coefficients_bits':[0]*24,'indices':list(struct.unpack('<18I',u.mem_read(context+0xcc,72)))})
index_cases=[]
for normal in itertools.product([-1.,0.,1.,-0.,float('nan'),float('inf'),float('-inf')],repeat=3):
 coefficients=list(normal)+[0.]
 for i in range(6):u.mem_write(context+0x6c+i*16,struct.pack('<4f',*coefficients))
 run(0x8e30d0);indices=list(struct.unpack('<18I',u.mem_read(context+0xcc,72)));expected=[axis if value<0. else axis+3 for axis,value in enumerate(normal)]*6;assert indices==expected
 index_cases.append({'normal_bits':list(struct.unpack('<3I',struct.pack('<3f',*normal))),'indices':indices[:3]})
proof={'native_sha256':digest,'passed':True,'cases':cases,'index_cases':index_cases,'normalization_threshold_bits':struct.unpack('<I',u.mem_read(0x1138990,4))[0],'complete':False,'limits':['Actual perspective8E3350 and orthographic8E33E0 constructors,8E3AA0 planes,66D6E0 SSErsqrt/Newton refinement and8E30D0 selection executed. Security-cookie check explicitly adapted.','Inputs are controlled nine corners; camera projection constructor8E2F30/8E3480 and world transforms8E1220 not executed here.','SSErsqrt estimate can vary by processor/emulator; resulting coefficient tolerance must be explicit in Rust comparison, not claimed bit-identical.','Degenerate zero cross-product yields all-zero plane; negative normals select low values, zero/NaN select high values.','Actual Rust camera/config/bounds and particle lifecycle integration remain incomplete.']}
(r/'data/4.20/audio_emitter_planes_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(f'Original planes {len(cases)} / indices {len(index_cases)} cases passed')
