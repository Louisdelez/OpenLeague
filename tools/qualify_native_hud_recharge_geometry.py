from pathlib import Path
import struct,json,itertools,hashlib,datetime,shutil
exec(Path('E:/OpenLeague/tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0])
owner=vector+0x6000;element=vector+0x7000;bounds=vector+0x8000;vertices=vector+0x9000;indices=vector+0xa000;packet=vector+0xb000
rect=None;descriptors=[]
def hook(uc,a,n,unused):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0x9a4b30:
  assert read(sp+4)==element and read(sp+12)==0;u.mem_write(read(sp+8),struct.pack('<4f',*rect));finish(0,12);return
 if a==0x7444d0:
  assert u.reg_read(UC_X86_REG_ECX)==packet+0x40;descriptors.append(list(struct.unpack('<5I',u.mem_read(read(sp+4),20))));finish(0,4);return
 if a==0xc975f5:finish(0);return
 assert 0x9a0520<=a<=0x9a0538 or 0x9a0540<=a<=0x9a07f1 or 0x99e8d0<=a<=0x99ea0a,hex(a)
 visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
w(stack,end);w(stack+4,bounds);w(stack+8,indices);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0x9a0520,end,count=100);assert bytes(u.mem_read(bounds,2))==struct.pack('<H',7) and read(indices)==9
cases=[]
for dimensions,rect,color in itertools.product([[1280,800],[1920,1080],[640,480]],[[.1,.2,.3,.4],[.42,.80,.46,.85],[0.,0.,1.,1.],[.2,.1,.25,.8]],[0xffffffff,0xff8080ff,0x40201008]):
 descriptors.clear();u.mem_write(vertices,b'\xcc'*192);u.mem_write(indices,b'\xdd'*32);u.mem_write(packet,b'\0'*0x80);u.mem_write(bounds,struct.pack('<4f',1e9,1e9,-1e9,-1e9));w(owner+0x1c,dimensions[0]);w(owner+0x20,dimensions[1]);w(element+0x1dc,color)
 w(stack,end)
 for i,v in enumerate([owner,element,bounds,vertices,indices,packet]):w(stack+4+i*4,v)
 u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0x9a0540,end,count=1500);assert u.reg_read(UC_X86_REG_EIP)==end
 assert descriptors==[[0,4,0,2,0],[4,3,6,2,3]],descriptors
 assert list(struct.unpack('<9H',u.mem_read(indices,18)))==[0,2,1,1,2,3,4,5,6]
 assert bytes(u.mem_read(vertices+168,24))==b'\xcc'*24 and bytes(u.mem_read(indices+18,14))==b'\xdd'*14
 blob=bytes(u.mem_read(vertices,168));records=[]
 for i in range(7):
  x,y,z,c,s,t=struct.unpack_from('<3fI2f',blob,i*24);assert z==0 and c==color;records.append(dict(position=[x,y,z],color=c,uv=[s,t]))
 cases.append(dict(dimensions=dimensions,rect=list(struct.unpack('<4f',struct.pack('<4f',*rect))),color=color,vertices_hex=blob.hex(),vertices=records,indices=list(struct.unpack('<9H',u.mem_read(indices,18))),descriptors=list(descriptors),bounds=list(struct.unpack('<4f',u.mem_read(bounds,16))),packet_rect=list(struct.unpack('<4f',u.mem_read(packet+0x28,16)))))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x9a0540',size_getter='0x9a0520',base_quad_helper='0x99e8d0',native_cases=len(cases),native_addresses=len(visited),vertex_count=7,index_count=9,cases=cases,findings=['Original cooldown geometry emits four quad vertices and three line vertices, nine indices and two source draw descriptors; buffers outside exact output stay unchanged.','Native line seed: upper midpoint plus half-pixel offsets, center twice; last center carries half-rectangle width/height in UV for CooldownLine.vs_2_0 displacement.'],limits=['Rectangle getter9A4B30 adapted to supplied normalized rectangles; original layout/group/matrix producer qualified separately, not executed by this harness.','Descriptor vector append captures five raw fields; actual draw consumer, shaders, device states and framebuffer remain open. Cookie adapted.','Finite positive viewport and ordered rectangles only; allocation/null output policies and complete HUD rendering unqualified.'])
(r/'data/4.20/native_hud_recharge_geometry_contract.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name);shutil.copy2(Path('E:/mapslol3v3/inspect_recharge_geometry.py'),r/'tools/inspect_recharge_geometry.py')
print(json.dumps(dict(passed=True,native_cases=len(cases),vertex_count=7,index_count=9)))
