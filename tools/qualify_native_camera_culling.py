"""Full original9863A0 camera-to-culling volume; CRT initialization adapters only."""
from pathlib import Path
import json,struct,itertools
r=Path(__file__).resolve().parents[1]
source=(r/'tools/qualify_native_audio_emitter_perspective.py').read_text(encoding='utf-8').split('u.hook_add(unicorn.UC_HOOK_CODE,perspective_hook)')[0]
exec(compile(source,'volume setup','exec'));camera=heap+0x6000;world=None;used_inverse_fallback=False
ranges=[(0x9863a0,0x986501),(0x986250,0x986397),(0x8dffa0,0x8e025b),(0x8de480,0x8de4f2),(0x8de500,0x8de56a),(0x716810,0x716882),(0x8df600,0x8df68f),(0x8df790,0x8dfb00),(0x8dec10,0x8df16f),(0x8e2e80,0x8e2f03)]
def culling_hook(uc,a,size,user):
 global world,used_inverse_fallback
 if a==0x8df15e:used_inverse_fallback=True
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0xc982e4:
  ptr,size,count,ctor,dtor=[read32(sp+i) for i in [4,8,12,16,20]];assert size==16 and count==6 and ctor==0x6bd9d0 and dtor==0x5642d0
  # All96bytes are immediately overwritten by the original initializer memset.
  u.mem_write(ptr,b'\x00'*(size*count));finish(20);return
 if a==0xca1d00:
  ptr,value,length=[read32(sp+i) for i in [4,8,12]];assert value==0 and length in [0x6c,0x60,0x48];u.mem_write(ptr,b'\x00'*length);finish(eax=ptr);return
 if a in [0x8e2f30,0x8e3480]:world=list(struct.unpack('<16I',u.mem_read(read32(sp+4),64)))
 if any(lo<=a<hi for lo,hi in ranges):return
 perspective_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,culling_hook)
identity=[1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.]
cases=[]
for mode,position,direction,up,aspect,fallback in itertools.product([0,1,2,3,0xffffffff],[[0.,0.,0.],[1.,2.,3.],[-100.,500.,10000.]],[[0.,0.,1.],[0.,-1.,-1.],[1.,2.,3.],[0.,0.,0.]],[[0.,1.,0.],[0.,0.,0.]],[.5,16./9.],[[0.]*16,identity]):
 u.mem_write(camera,struct.pack('<16f',*position,50.,65000.,*direction,*up,103.,0.,1000.,1000.,0.));write32(camera+0x30,mode);u.mem_write(context,b'\xa5'*0x130);u.mem_write(0x14beea0,struct.pack('<f',aspect));u.mem_write(0x2d77410,struct.pack('<16f',*fallback));world=None;used_inverse_fallback=False
 sp=stack+0x8000;write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,context);u.reg_write(UC_X86_REG_EDX,camera);u.emu_start(0x9863a0,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end;assert world is not None
 cases.append({'mode':mode,'position':position,'direction':direction,'up':up,'aspect_bits':read32(0x14beea0),'fallback_bits':list(struct.unpack('<16I',struct.pack('<16f',*fallback))),'world_matrix_bits':world,'used_inverse_fallback':used_inverse_fallback,'corners_bits':list(struct.unpack('<27I',u.mem_read(context,108))),'coefficients_bits':list(struct.unpack('<24I',u.mem_read(context+0x6c,96))),'indices':list(struct.unpack('<18I',u.mem_read(context+0xcc,72))),'bounds_bits':list(struct.unpack('<6I',u.mem_read(context+0x114,24)))})
proof={'native_sha256':digest,'passed':True,'cases':cases,'complete':False,'limits':['Full9863A0,986250,8DEC10,projection volume constructors and original transform/planes/bounds/index math executed. Only CRT array initialization/memsets and security-cookie check adapted.','CRT array constructor adapter initializes storage that original8E2E80 immediately overwrites; it does not replace volume math.','Global2D77410 inverse fallback supplied as zero/identity; runtime initialization unknown. Camera fields and aspect controlled inputs.','This joins native camera math to culling volumes, without proving visible client camera binding or full emitter lifecycle.']}
(r/'data/4.20/camera_culling_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(f'Original full camera-to-culling volume: {len(cases)} cases passed')
