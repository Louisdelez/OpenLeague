"""Original866E00 pitch rotation and8E24F0/8E2550 quantized sine/cosine lookup."""
from pathlib import Path
import json,struct,itertools
r=Path(__file__).resolve().parents[1]
source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,'native setup','exec'));point=heap+0x6000;origin=heap+0x7000;result=heap+0x5000

def bits(values):return list(struct.unpack('<'+'I'*len(values),struct.pack('<'+'f'*len(values),*values)))
def hook(uc,a,size,user):
 assert 0x866e00<=a<=0x866e9d or 0x8e24f0<=a<=0x8e2549 or 0x8e2550<=a<=0x8e25b1 or end+0x200<=a<end+0x206,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
table=list(struct.unpack('<3600I',u.mem_read(0x10cfab0,14400)));angles=bits([0.,-0.,1.,-1.,45.,56.9,90.,180.,360.,720.25,1e9])+[0x7fc00000,0x7f800000,0xff800000]
lookups=[]
# Small return stub stores the original x87 return value without changing it.
u.mem_write(end+0x200,b'\xd9\x1d'+struct.pack('<I',result))
for angle in angles:
 pair=[]
 for fn in [0x8e24f0,0x8e2550]:
  sp=stack+0x7000;u.mem_write(sp,struct.pack('<II',end+0x200,angle));u.reg_write(UC_X86_REG_ESP,sp);u.emu_start(fn,end+0x206,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end+0x206;pair.append(read32(result))
 lookups.append({'angle_bits':angle,'sin_bits':pair[0],'cos_bits':pair[1]})
cases=[]
for angle,p,o in itertools.product(angles,[[0.,0.,1.],[1.,2.,3.],[0.,0.,0.],[100.,-50.,200.]],[[0.,0.,0.],[1.,2.,3.],[100.,-50.,200.]]):
 pbits=bits(p);obits=bits(o);u.mem_write(point,struct.pack('<3I',*pbits));u.mem_write(origin,struct.pack('<3I',*obits));sp=stack+0x7000;u.mem_write(sp,struct.pack('<III',end,angle,origin));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,point);u.emu_start(0x866e00,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 cases.append({'angle_bits':angle,'point_bits':pbits,'origin_bits':obits,'output_bits':list(struct.unpack('<3I',u.mem_read(point,12)))})
proof={'native_sha256':digest,'passed':True,'sin_table_bits':table,'lookups':lookups,'cases':cases,'complete':False,'limits':['Full866E00 and original8E24F0/8E2550 executed without math adapters; explicit test stub stores x87 return value for standalone lookup fixtures.','Original3600float sine table read from executable address10CFAB0; indices use f32 multiplication/truncation and signed wrap.','Zero angle or both relativeYZzero leaves point unchanged; x coordinate always retained.','Nonfinite/out-of-i32-range angle lookup retains native CVTTSS2SI indefinite integer behavior; CPU exception status flags not compared.','This is the rotation helper, not complete normal camera producer or live rendering integration.']}
(r/'data/4.20/camera_rotation_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(f'Original camera rotation: {len(cases)} vector / {len(lookups)} dual lookup cases passed')
