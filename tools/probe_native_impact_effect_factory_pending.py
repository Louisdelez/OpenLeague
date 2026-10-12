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
 if a in [0x5fa7d9,0x66d6f1,0x75fcca,0x75efc0]:
  reg=UC_X86_REG_XMM2 if a in [0x66d6f1,0x75efc0] else UC_X86_REG_XMM1; xmm=u.reg_read(reg);src=ctypes.c_uint32(xmm&0xffffffff);dst=ctypes.c_uint32();rsqrt(ctypes.byref(src),ctypes.byref(dst));u.reg_write(reg,(xmm&~0xffffffff)|dst.value);u.reg_write(UC_X86_REG_EIP,a+size);cpu_operations+=1
 visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook_owner)
body=vector+0x6000;config=vector+0x9000

u.mem_map(0,4096)
name=vector+0x17000;position=vector+0x17100;secondary=vector+0x17200;direction=vector+0x17300;effect=vector+0x18000;actor=vector+0x19000
w(0x2d7c5b0,1);w(0x2d7c5b4,0)
factory_calls=[]
def hook_factory(uc,a,size,user):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0x7522b0:
  out=read(sp+4);u.mem_write(out,b'\0'*24);u.mem_write(out,b'impact.troy\0');w(out+16,11);w(out+20,15);finish(out);return
 if a==0x6cced0:finish(0,4);return
 if a==0x7172b0:
  factory_calls.append(dict(source=read(sp+4),position_words=list(struct.unpack('<3I',u.mem_read(read(sp+8),12)))))
  finish(effect);return
 if a==0xc975f5:finish(u.reg_read(UC_X86_REG_EAX));return
u.hook_add(unicorn.UC_HOOK_CODE,hook_factory)
cases=[]
for flags,source_position,second_position,scalar180,scalar140,actor_present in itertools.product([8,9,24,40,136,184],[[0.,0.,0.],[500.,30.,100.]],[[0.,0.,0.],[-20.,100.,30.]],[0.,.5],[1.,2.],[False,True]):
 u.mem_write(effect,b'\0'*0x200);u.mem_write(name,b'impact.troy\0');u.mem_write(position,struct.pack('<3f',*source_position));u.mem_write(secondary,struct.pack('<3f',*second_position));u.mem_write(direction,b'\0'*12)
 args=[123,position,actor if actor_present else 0,0,flags,0,0,secondary,0,direction,0,struct.unpack('<I',struct.pack('<f',scalar180))[0],struct.unpack('<I',struct.pack('<f',scalar140))[0]]
 w(stack,end)
 for i,v in enumerate(args):w(stack+4+i*4,v)
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,name);u.reg_write(UC_X86_REG_EDX,0);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
 factory_calls.clear()
 try:u.emu_start(0x751be0,end,count=5000)
 except Exception:print('FAULT',hex(u.reg_read(UC_X86_REG_EIP)),flags);raise
 assert u.reg_read(UC_X86_REG_EIP)==end
 if u.reg_read(UC_X86_REG_EAX)!=effect:print('RESULT',hex(u.reg_read(UC_X86_REG_EAX)),flags,factory_calls,hex(u.reg_read(UC_X86_REG_ESI)))
 assert u.reg_read(UC_X86_REG_EAX)==effect;assert len(factory_calls)==1
 cases.append(dict(flags=flags,source_position=source_position,secondary_position=second_position,scalar180=scalar180,scalar140=scalar140,actor_present=actor_present,factory=factory_calls[0],state=dict(flags144=read(effect+0x144),scalar180=read(effect+0x180),scalar140=read(effect+0x140),secondary_words=list(struct.unpack('<3I',u.mem_read(effect+0x131,12))),secondary_active=bool(u.mem_read(effect+0x184,1)[0]),flag130=bool(u.mem_read(effect+0x130,1)[0]))))
k.VirtualFree(machine,0,0x8000)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x751be0',native_instruction_addresses=len(visited),cases=cases,adapters=['Resource-name resolver7522B0 supplies short inline impact.troy; resource-group6CCED0 supplies0;7172B0 supplies newly zeroed pending wrapper. Actual resource resolution/allocation remains unqualified.','Security-cookie checkC975F5 returns; original weak acquisition,scalar setters,flag updates,secondary-position writes and unbound747BE0 execute.'],limits=['Flags include8, exclude4/40/100. Zero direction and no bound Troy. Original whole orchestration executes but graphics/resource constructor is supplied.','Live effect callbacks, nonzero direction, bone/skin aliases, attachment providers and scalar semantics remain unqualified.','No client build or live GPU/audio acceptance.'])
(r/'data/4.20/impact_effect_factory_pending_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(passed=True,cases=len(cases),native_instruction_addresses=len(visited))))

