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

sequences=[]
for origin,destination,pattern,radius,dt in itertools.product([[0.,0.,0.],[100.,200.,300.],[-55.,24.,-90.]],[[2500.,10.,100.],[-1300.,40.,2600.]],[[True]*8,[True,True,False,False,True,False,True,True]],[0.,65.],[1./60.,1./30.]):
 u.mem_write(body,b'\0'*0x600);u.mem_write(config,b'\0'*0x800);w(body,0x10b2b5c);w(body+0x140,config)
 for off,v in [(0x564,1400.),(0x56c,3.4028234663852886e38)]:u.mem_write(body+off,struct.pack('<f',v))
 for off,vec in [(0x544,origin),(0x538,origin),(0x11c,destination),(0x60,origin)]:u.mem_write(body+off,struct.pack('<3f',*vec))
 for off,v in [(0x5f8,1400.),(0x600,1400.),(0x604,1400.),(0x5a8,100.)]:u.mem_write(config+off,struct.pack('<f',v))
 frames=[]
 for frame,live in enumerate(pattern):
  pos=[destination[0]+frame*15.,destination[1]+frame*2.,destination[2]-frame*12.]
  u.mem_write(target+0x60,struct.pack('<3f',*pos));u.mem_write(nowaddr,struct.pack('<3f',1.+frame*dt,dt,radius));w(aliveaddr,int(live))
  w(stack,end);w(stack+4,caster);w(stack+8,target);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,body);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
  u.emu_start(0x75f130,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end;assert u.reg_read(UC_X86_REG_EAX)&255==1
  frames.append(dict(live_target=live,target_position=pos,direction_words=list(struct.unpack('<3I',u.mem_read(body+0x6c,12))),moving_position_words=list(struct.unpack('<3I',u.mem_read(body+0x544,12))),target_words=list(struct.unpack('<3I',u.mem_read(body+0x11c,12)))))
 sequences.append(dict(origin=origin,destination=destination,radius=radius,dt=dt,frames=frames))
k.VirtualFree(machine,0,0x8000)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x75f130',native_instruction_addresses=sum(base<=a<base+len(image) for a in visited),actual_cpu_rsqrt_operations=cpu_operations,terrain_calls=terrain_calls,sequences=sequences,adapters=['Same explicit clock/target validity/radius and unobstructed terrain providers as72case motion contract.','Finite classification provider; native motion/basis/scaling/end predicate and clock wrapper execute.'],limits=['Moving targets and valid-invalid transitions,48sequences384frames; no intersection/end release or real obstruction.','No live binding or GPU/audio acceptance; zero gravity/acceleration/travel-time1400 profile.'])
(r/'data/4.20/missile_motion_sequences_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(passed=True,sequences=len(sequences),frames=sum(len(s['frames']) for s in sequences),cpu_rsqrt_operations=cpu_operations)))
