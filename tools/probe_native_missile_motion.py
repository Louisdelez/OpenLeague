"""Execute original concrete owner orientation and row normalization."""
from pathlib import Path
import ctypes,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'setup','exec'))
k=ctypes.WinDLL('kernel32',use_last_error=True);k.VirtualAlloc.argtypes=[ctypes.c_void_p,ctypes.c_size_t,ctypes.c_uint32,ctypes.c_uint32];k.VirtualAlloc.restype=ctypes.c_void_p;k.VirtualFree.argtypes=[ctypes.c_void_p,ctypes.c_size_t,ctypes.c_uint32]
code=bytes.fromhex('f30f5201f30f1102c3');machine=k.VirtualAlloc(None,4096,0x3000,0x40);assert machine;ctypes.memmove(machine,code,len(code));rsqrt=ctypes.CFUNCTYPE(None,ctypes.POINTER(ctypes.c_uint32),ctypes.POINTER(ctypes.c_uint32))(machine)
provider=vector+0x6000;handle=vector+0x7000;control=vector+0x7100;actor=vector+0x8000;output=vector+0xb000
cpu_operations=0

def hook_owner(uc,a,size,user):
 global cpu_operations
 if a in [0x5fa7d9,0x66d6f1,0x75fcca,0x75efc0,0x75f41f]:
  reg=UC_X86_REG_XMM2 if a in [0x66d6f1,0x75efc0,0x75f41f] else UC_X86_REG_XMM1; xmm=u.reg_read(reg);src=ctypes.c_uint32(xmm&0xffffffff);dst=ctypes.c_uint32();rsqrt(ctypes.byref(src),ctypes.byref(dst));u.reg_write(reg,(xmm&~0xffffffff)|dst.value);u.reg_write(UC_X86_REG_EIP,a+size);cpu_operations+=1
 visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook_owner)
body=vector+0x6000;config=vector+0x9000

u.mem_map(0,4096)
clock=vector+0x12000;clockvt=vector+0x12100;target=vector+0x13000;targetvt=vector+0x13400;caster=vector+0x14000;codebase=vector+0x15000
nowaddr=vector+0x16000;dtaddr=nowaddr+4;radiusaddr=nowaddr+8;aliveaddr=nowaddr+12
w(0x2d78c78,caster);w(0x2d791a8,clock);w(clock,clockvt);w(clockvt+0x20,codebase);w(clockvt+4,codebase+0x20);w(clockvt+8,codebase+0x40)
u.mem_write(codebase,bytes.fromhex('b801000000c3'))
for addr,valueaddr in [(codebase+0x20,nowaddr),(codebase+0x40,dtaddr),(codebase+0x80,radiusaddr)]:u.mem_write(addr,b'\xd9\x05'+struct.pack('<I',valueaddr)+b'\xc3')
u.mem_write(codebase+0x60,b'\xa1'+struct.pack('<I',aliveaddr)+b'\xc3');w(target,targetvt);w(targetvt+0x90,codebase+0x60);w(targetvt+0x1cc,codebase+0x80)
terrain_calls=0;end_calls=0

def boundary(uc,a,size,user):
 global terrain_calls,end_calls
 if a==0xc99e4e:finish(0);return
 if a==0x6a2560:terrain_calls+=1;finish(0,24);return
 if a==codebase+0xa0:end_calls+=1;finish(0,4);return
u.hook_add(unicorn.UC_HOOK_CODE,boundary)
cases=[]
for origin,destination,live,radius,dt in itertools.product([[0.,0.,0.],[100.,200.,300.],[-55.,24.,-90.]],[[2500.,10.,100.],[-1300.,40.,2600.]], [False,True],[0.,65.],[0.,1./60.,1./30.]):
 u.mem_write(body,b'\0'*0x600);u.mem_write(config,b'\0'*0x800);w(body,0x10b2b5c);w(body+0x140,config)
 for off,v in [(0x564,1400.),(0x56c,3.4028234663852886e38)]:u.mem_write(body+off,struct.pack('<f',v))
 for off,vec in [(0x544,origin),(0x538,origin),(0x11c,destination),(0x60,origin)]:u.mem_write(body+off,struct.pack('<3f',*vec))
 u.mem_write(target+0x60,struct.pack('<3f',destination[0]+50.,destination[1]+20.,destination[2]-30.))
 for off,v in [(0x5f8,1400.),(0x600,1400.),(0x604,1400.),(0x5a8,100.)]:u.mem_write(config+off,struct.pack('<f',v))
 u.mem_write(nowaddr,struct.pack('<3f',1.,dt,radius));w(aliveaddr,int(live))
 w(stack,end);w(stack+4,caster);w(stack+8,target);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,body);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
 before=terrain_calls
 try:u.emu_start(0x75f130,end,count=10000)
 except Exception:
  print('FAULT',hex(u.reg_read(UC_X86_REG_EIP)),hex(u.reg_read(UC_X86_REG_ESP)),origin,destination,live,radius,dt,sorted(hex(a) for a in visited if 0x75f500<=a<=0x75f835));raise
 assert u.reg_read(UC_X86_REG_EIP)==end;assert u.reg_read(UC_X86_REG_EAX)&255==1
 cases.append(dict(origin=origin,destination=destination,live_target=live,target_position=[destination[0]+50.,destination[1]+20.,destination[2]-30.],radius=radius,dt=dt,direction_words=list(struct.unpack('<3I',u.mem_read(body+0x6c,12))),moving_position_words=list(struct.unpack('<3I',u.mem_read(body+0x544,12))),target_words=list(struct.unpack('<3I',u.mem_read(body+0x11c,12))),terrain_calls=terrain_calls-before))
k.VirtualFree(machine,0,0x8000)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entries=['0x75f130','0x75ef50','0x75ec90','0x75f840','0x5f76f0'],native_instruction_addresses=sum(base<=a<base+len(image) for a in visited),actual_cpu_rsqrt_operations=cpu_operations,terrain_calls=terrain_calls,cases=cases,adapters=['Clock virtuals supply explicit now/dt; native5F76F0 wrapper executes.','Target90 supplies explicit valid flag; target1CC supplies radius.','Terrain6A2560 supplies unobstructed result; geometry behavior is not qualified.','Finite classificationC99E4E returns non-NaN for supplied finite coordinates.'],limits=['Zero gravity/acceleration,1400speed,min=max,zero travel time,finite inputs; positive travel time/acceleration/collision/end-crossing not qualified.','Full75F130 executes and reaches its real return; external clock,target traits,terrain/classification providers are adapted.','No Rust port of motion yet, no live client/GPU/audio acceptance.'])
(r/'data/4.20/missile_motion_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(passed=True,cases=len(cases),cpu_rsqrt_operations=cpu_operations,native_instruction_addresses=sum(base<=a<base+len(image) for a in visited),terrain_calls=terrain_calls)))

