"""Full original7D1A60 focus hold/rectangle/two-pass radius restriction."""
from pathlib import Path
import json,struct,itertools
r=Path(__file__).resolve().parents[1]
source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,'native setup','exec'));controller=heap+0x6000;service=heap+0x9000;vtable=heap+0x9100;ui=heap+0xa000;special=heap+0xa400;active=0;queries=0
write32(0x2d791a4,service);write32(service,vtable);write32(vtable+0x10,end+0x400);u.mem_write(service+0x14,b'\x01');write32(0x2d77e54,ui);write32(ui+0x13c,special)
def hook(uc,a,size,user):
 global queries
 if a==end+0x400:queries+=1;finish(eax=active);return
 assert 0x7d1a60<=a<=0x7d1d0f or 0x66d6e0<=a<=0x66d729,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
rectangle=[0.,100.,0.,100.];center=[50.,10.,50.];saved=[80.,5.,80.];cases=[]
for focus,radius,held,active,service_flag,special_flag in itertools.product([[-10.,0.,10.],[50.,0.,200.],[150.,0.,150.],[25.,30.,25.]],[-1.,0.,20.,100.],[0,1,2],[0,1],[0,2],[0,2]):
 u.mem_write(controller,b'\x00'*0x200);u.mem_write(controller+0x104,struct.pack('<6f',*focus,*saved));u.mem_write(controller+0x15c,struct.pack('<4f',*center,radius));u.mem_write(controller+0x1c5,bytes([held]));u.mem_write(service+0x17,bytes([service_flag]));u.mem_write(special+0xe9,bytes([special_flag]))
 for address,value in zip([0x123e88c,0x123e8ac,0x123e89c,0x123e8bc],rectangle):u.mem_write(address,struct.pack('<f',value))
 queries=0;sp=stack+0x8000;write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,controller);u.emu_start(0x7d1a60,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end and queries==1
 cases.append({'focus':focus,'saved':saved,'radius':radius,'rectangle':rectangle,'center':center,'held_raw':held,'active_raw':active,'service_flag_raw':service_flag,'special_flag_raw':special_flag,'output_bits':list(struct.unpack('<6I',u.mem_read(controller+0x104,24))),'output_held_raw':u.mem_read(controller+0x1c5,1)[0]})
proof={'native_sha256':digest,'passed':True,'cases':cases,'normalization_threshold_bits':read32(0x1138990),'complete':False,'limits':['Full7D1A60 and original66D6E0 normalization executed; only service virtual query adapter returns supplied active byte.','Required service singleton present/ready; missing singleton assertion/fatal path excluded. Rectangle globals and restriction center/radius supplied.','Hold trigger combines active service+service flag or special UI flag; saved focus and raw held byte retained exactly.','Rectangle clamp and radius restriction run twice; XZ distance selects restriction, XYZ normalization applies it. No generic2Dcircle substitute.','Original source producers for these bounds/context flags and input/follow behavior, camera shake and visible integration remain unqualified.']}
(r/'data/4.20/camera_focus_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(f'Original full camera focus update: {len(cases)} cases passed')
