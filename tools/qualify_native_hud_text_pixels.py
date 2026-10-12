from pathlib import Path
import json, struct, hashlib, datetime, itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0], 'text pixels prerequisites','exec'))
owner=vector+0x6000;packet=vector+0x6100;record=vector+0x6200;captured=[]
w(packet+0x1c,record);w(packet+0x20,record+0x120);w(packet+0x28,0);w(packet+0x2c,0)
w(record,0x12345678);w(record+4,1);w(record+8,0xffa1b2c3);u.mem_write(record+0x1c,b'Gold\0')
def hook(uc,a,size,user):
 if a==0x9a5cf0:
  sp=uc.reg_read(UC_X86_REG_ESP);args=[read(sp+4+i*4) for i in range(5)]
  assert args[0]==0x12345678 and args[1]==1 and read(args[2])==0xffa1b2c3 and args[4]==record+0x1c
  captured.append(list(struct.unpack('<4I',u.mem_read(args[3],16))));finish(0,20);return
 assert 0x99fa40<=a<=0x99fce5,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
f=lambda x:struct.unpack('<f',struct.pack('<f',x))[0]
b=lambda x:struct.unpack('<I',struct.pack('<f',x))[0]
c0=struct.unpack('<f',u.mem_read(0x1138c1c,4))[0];c1=struct.unpack('<f',u.mem_read(0x1138bc4,4))[0];fixed=struct.unpack('<f',u.mem_read(0x1138cb8,4))[0]
cases=[]
for width,height,scalar,flag,coords in itertools.product([800,1280,1920],[600,768,1080],[0.,0.5,1.,1.15,2.],[0,1],[[0.,0.,1.,1.],[0.125,0.5,0.375,0.625],[-0.01,-0.2,1.01,1.2]]):
 scale=f(f(f(scalar*c0)*c1)+0.5)
 if flag:scale=fixed
 reciprocal=f(1./scale)
 expected=[b(float(__import__('math').floor(f(f(coords[i]*reciprocal)*f(width if i%2==0 else height))))) for i in range(4)]
 w(owner+0x10,width);w(owner+0x14,height);u.mem_write(owner+0x18,struct.pack('<f',scalar));u.mem_write(record+0x11c,bytes([flag]));u.mem_write(record+0xc,struct.pack('<4f',*coords))
 w(stack,end);w(stack+4,packet);w(stack+8,0);w(stack+12,0);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,owner);captured.clear();u.emu_start(0x99fa40,end,count=1000)
 assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==stack+16
 assert captured==[expected],(width,height,scalar,flag,coords,captured,expected)
 assert read(owner+0x1c)==b(scale)
 cases.append(dict(width=width,height=height,owner_scalar=scalar,fixed_scale=bool(flag),normalized_rect=coords,scale_bits=b(scale),pixel_rect_bits=captured[0]))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x99fa40',case_count=len(cases),native_addresses=len(visited),constant_bits=[b(c0),b(c1),b(fixed)],cases=cases,findings=['Original text packet draw executes, including native SSE floor rounding and normalized-to-pixel conversions.','Dynamic scale = f32(f32(f32(owner_scalar * constant0) * constant1) + 0.5); fixed flag uses source constant1.15f.','All four pixel corners floor(f32(f32(normalized * f32(1/scale)) * viewport)). Owner+1C is updated with selected scale.'],limits=['Prepared packet record and viewport/owner fields supplied; element preparation, original configuration producers and multiple packet font flush callbacks remain open.','Text draw wrapper is adapted at9A5CF0; qualified separately by native_hud_text_draw_contract.json. Empty font flush vector supplied.','Selected finite scale/ranges; original font device owner-scale consumption, framebuffer projection and actual widget rendering remain open.'])
(r/'data/4.20/native_hud_text_pixels_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(passed=True,cases=len(cases),native_addresses=len(visited),constant_bits=proof['constant_bits'])))
