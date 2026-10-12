"""Actual8E36B0 six-plane bounds test and joined93F314 lifetime gate."""
from pathlib import Path
import json,struct,itertools
r=Path(__file__).resolve().parents[1]
source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,'native setup','exec'))
context=heap+0x4000;bounds_pointer=heap+0x5000;actor=heap+0x8000;config=heap+0x6000
normals=[[1.,0.,0.],[-1.,0.,0.],[0.,1.,0.],[0.,-1.,0.],[0.,0.,1.],[0.,0.,-1.]]
planes=[]
for i,normal in enumerate(normals):
 indices=[axis+3 if normal[axis]>=0 else axis for axis in range(3)]
 coefficients=normal+[1.];u.mem_write(context+0x6c+16*i,struct.pack('<4f',*coefficients));u.mem_write(context+0xcc+12*i,struct.pack('<3I',*indices));planes.append({'coefficients':coefficients,'indices':indices})
def bound_hook(uc,a,size,user):
 if a==0x93f3be:u.emu_stop();return
 assert 0x8e36b0<=a<=0x8e371b or 0x93f314<=a<0x93f3be,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,bound_hook)
def f32(v):return struct.unpack('<f',struct.pack('<f',v))[0]
def bits(values):return list(struct.unpack('<6I',struct.pack('<6f',*values)))
def expected(values):
 for plane in planes:
  c=plane['coefficients'];ind=plane['indices'];v=f32(f32(f32(values[ind[0]]*c[0])+f32(values[ind[1]]*c[1]))+f32(values[ind[2]]*c[2]));v=f32(v+c[3])
  if 0.>v:return False
 return True
inputs=[]
for center,extent in itertools.product(itertools.product([-2.,-1.,0.,1.,2.],repeat=3),[0.,.25,1.]):inputs.append([v-extent for v in center]+[v+extent for v in center])
for index,value in itertools.product(range(6),[float('nan'),float('inf'),float('-inf'),-0.]):
 b=[-.25,-.25,-.25,.25,.25,.25];b[index]=value;inputs.append(b)
cases=[];joined=[]
for values in inputs:
 u.mem_write(bounds_pointer,struct.pack('<6f',*values));sp=stack+0x7000;u.mem_write(sp,struct.pack('<II',end,bounds_pointer));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,context);u.emu_start(0x8e36b0,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end;inside=u.reg_read(UC_X86_REG_EAX)&255;assert bool(inside)==expected(values)
 cases.append({'bounds_bits':bits(values),'intersects_raw':inside})
 for flags in [0,1,16,24]:
  u.mem_write(actor,b'\0'*0x200);u.mem_write(actor+0x130,struct.pack('<6f',*values));u.mem_write(actor+0x1dc,bytes([flags]));write32(actor+0xe8,config);u.mem_write(config+0x1bc,b'\0');u.mem_write(actor+0xb4,struct.pack('<f',1.));u.mem_write(stack+0x8008,struct.pack('<f',2.));u.reg_write(UC_X86_REG_EBP,stack+0x8000);u.reg_write(UC_X86_REG_ESP,stack+0x7000);u.reg_write(UC_X86_REG_ECX,context);u.reg_write(UC_X86_REG_ESI,actor);u.emu_start(0x93f314,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==0x93f3be
  out=u.mem_read(actor+0x1dc,1)[0];suppressed=u.mem_read(stack+0x800f,1)[0];skip=bool(inside) and not flags&8;wanted=flags|(2 if not skip and (flags&16 or not flags&1) else 0);assert out==wanted and bool(suppressed)==skip
  joined.append({'bounds_bits':bits(values),'flags':flags,'gate_flags':out,'suppressed_raw':suppressed})
proof={'native_sha256':digest,'passed':True,'planes':planes,'cases':cases,'joined_cases':joined,'complete':False,'limits':['Actual8E36B0 executes six indexed plane tests, scalar SSE f32 product/add ordering; zero boundary and unordered NaN do not reject. No bounds normalization.','Actual93F314..3BE caller copies bounds130..144, calls8E36B0 and uses result in lifetime gate. Explicit synthetic six-plane context, flags, clock2, birth0/lifetime1 supplied.','Original camera plane generation/index selection and runtime bounds production not qualified; test planes are controlled inputs, not recovered game camera.','Full particle tick/child simulation and client lifecycle/audio integration remain incomplete.']}
(r/'data/4.20/audio_emitter_bounds_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(f'Original bounds {len(cases)} / joined finish {len(joined)} cases passed')
