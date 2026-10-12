from pathlib import Path
import struct,json
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_grass_spatial_extents.py').read_text(encoding='utf-8').split('profiles=')[0],'native prerequisites','exec'))
inputs=set()
def record_sqrt(uc,a,size,user):
 if a==0x5fa7d9:inputs.add(u.reg_read(UC_X86_REG_XMM1)&0xffffffff)
u.hook_add(unicorn.UC_HOOK_CODE,record_sqrt)
p=json.loads((r/'data/4.20/grass_spatial_extents_precise_contract.json').read_text(encoding='utf-8'))
for c in p['cases']:
 u.mem_write(spatial,bytes(0x40));write32(node+8,spatial);u.mem_write(spatial,struct.pack('<3f',*c['center']));f(spatial+0xc,c['initial_radius'])
 u.mem_write(spatial+0x10,struct.pack('<6f',*c['initial_local_bounds']));write32(spatial+0x28,0)
 u.mem_write(lower,struct.pack('<3f',*c['local_bounds'][:3]));u.mem_write(upper,struct.pack('<3f',*c['local_bounds'][3:]));write32(0x14ae660,int(c['integer_sse']));write32(0x2da52e8,0)
 write32(sp,end);write32(sp+4,lower);write32(sp+8,upper);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,node)
 u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
 u.emu_start(0x95f060,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
Path('E:/mapslol3v3/rsqrt-hardware-inputs.txt').write_text('\n'.join(map(str,sorted(inputs)))+'\n',encoding='utf-8');print('distinct sqrt inputs',len(inputs))
