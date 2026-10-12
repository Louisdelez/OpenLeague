"""Full original9820F0 camera preparation with native math, original executable not launched."""
from pathlib import Path
import json,struct,itertools
r=Path(__file__).resolve().parents[1]
source=(r/'tools/qualify_native_camera_view.py').read_text(encoding='utf-8').split('\nu.hook_add(unicorn.UC_HOOK_CODE,hook)')[0]
exec(compile(source,'view setup','exec'));renderer=heap+0x5000;product=None;inverse=None;used_fallback=False
ranges=allowed+[(0x9820f0,0x982ab2),(0x9861d0,0x98624a),(0x8e0260,0x8e0318),(0x8e0320,0x8e03e2),(0x8dec10,0x8df16f),(0x8e3aa0,0x8e3c03)]
def prepare_hook(uc,a,size,user):
 global product,inverse,used_fallback
 if a==0xc975f5:finish(eax=u.reg_read(UC_X86_REG_EAX));return
 if a==0x8dec10:product=list(struct.unpack('<16I',u.mem_read(u.reg_read(UC_X86_REG_ECX),64)))
 if a==0x8df15e:used_fallback=True
 if a==0x982193:inverse=list(struct.unpack('<16I',u.mem_read(u.reg_read(UC_X86_REG_EBP)-0x54,64)))
 assert any(lo<=a<hi for lo,hi in ranges),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,prepare_hook)
identity=[1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.];cases=[]
for mode,position,direction,up,depth,dimensions,aspect,fallback in itertools.product([0,1,2,3,0xffffffff],[[0.,0.,0.],[-100.,500.,10000.]],[[0.,0.,1.],[0.,-1.,-1.],[0.,0.,0.]],[[0.,1.,0.],[0.,0.,0.]],[(1.,2.),(50.,65000.)],[(1.,1.),(1000.,1000.)],[1.,16./9.],[[0.]*16,identity]):
 near,far=depth;width,height=dimensions
 u.mem_write(camera,struct.pack('<16f',*position,near,far,*direction,*up,103.,0.,width,height,0.));write32(camera+0x30,mode);u.mem_write(renderer,b'\xa5'*0x240);write32(0x2d79078,renderer);u.mem_write(0x14beea0,struct.pack('<f',aspect));u.mem_write(0x2d77410,struct.pack('<16f',*fallback));product=None;inverse=None;used_fallback=False
 sp=stack+0x8000;u.mem_write(sp,struct.pack('<II',end,camera));u.reg_write(UC_X86_REG_ESP,sp);u.emu_start(0x9820f0,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end;assert product is not None and inverse is not None
 assert list(struct.unpack('<3f',u.mem_read(renderer+0x9c,12)))==position and struct.unpack('<f',u.mem_read(renderer+0x22c,4))[0]==far
 cases.append({'mode':mode,'position':position,'direction':direction,'up':up,'near':near,'far':far,'width':width,'height':height,'aspect_bits':read32(0x14beea0),'fallback_bits':list(struct.unpack('<16I',struct.pack('<16f',*fallback))),'used_fallback':used_fallback,'view_bits':list(struct.unpack('<16I',u.mem_read(renderer+0xa8,64))),'projection_bits':list(struct.unpack('<16I',u.mem_read(renderer+0xe8,64))),'product_bits':product,'inverse_bits':inverse,'corners_bits':list(struct.unpack('<24I',u.mem_read(renderer+0x128,96))),'plane_bits':list(struct.unpack('<24I',u.mem_read(renderer+0x188,96)))})
proof={'native_sha256':digest,'passed':True,'cases':cases,'complete':False,'limits':['Full9820F0 camera preparation and all original view/projection/product/inverse/plane math executed; only security-cookie check adapted.','Original near clip corners depth0 and far clip corners depth1; native row-major layout retained.','Inverse fallback global2D77410 supplied as zero/identity, actual runtime initialization unqualified.','Camera fields and aspect supplied; does not establish final player camera parameters or Bevy/GPU integration.']}
(r/'data/4.20/camera_prepare_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(f'Original complete camera preparation: {len(cases)} cases, {sum(c["used_fallback"] for c in cases)} inverse fallback cases')
