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
 if a in [0x5fa7d9,0x66d6f1,0x75fcca]:
  reg=UC_X86_REG_XMM2 if a==0x66d6f1 else UC_X86_REG_XMM1; xmm=u.reg_read(reg);src=ctypes.c_uint32(xmm&0xffffffff);dst=ctypes.c_uint32();rsqrt(ctypes.byref(src),ctypes.byref(dst));u.reg_write(reg,(xmm&~0xffffffff)|dst.value);u.reg_write(UC_X86_REG_EIP,a+size);cpu_operations+=1
 visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook_owner)
body=vector+0x6000;config=vector+0x9000
cases=[]
for origin,target,height,first_time,second_time in itertools.product([[0.,0.,0.],[100.,200.,300.],[-55.,24.,-90.]],[[0.,0.,0.],[500.,10.,100.],[-300.,40.,600.],[0.,500.,0.]],[0.,100.],[.25,1.],[0.,2.]):
 u.mem_write(body,b'\0'*0x600);w(body+0x140,config);u.mem_write(body+0x544,struct.pack('<3f',*origin));u.mem_write(body+0x11c,struct.pack('<3f',*target));u.mem_write(config+0x5a8,struct.pack('<f',height));u.mem_write(config+0x608,struct.pack('<f',first_time));u.mem_write(config+0x60c,struct.pack('<f',second_time));w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,body);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.emu_start(0x75fb00,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end;assert u.reg_read(UC_X86_REG_EAX)&255==1
 words=list(struct.unpack('<3I',u.mem_read(body+0x6c,12)));cases.append(dict(origin=origin,target=target,height=height,first_time=first_time,second_time=second_time,direction_words=words,travel_time_word=read(body+0x570)))
k.VirtualFree(machine,0,0x8000)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entries=['0x75fb00','0x66d6e0'],native_instruction_addresses=len(visited),actual_cpu_rsqrt_operations=cpu_operations,cases=cases,adapters=['Original whole75FB00 executes with positive config+608 fixed-time branch, native66D6E0 and physical CPU RSQRTSS operands.','Explicit cast target, initial origin, target height augmentation and native time fields.'],limits=['Zero/negative first time invokes75FF20/75EF50 fallback not qualified here.','Static vtable entry identified; exact Annie targeted-missile subtype dispatch remains unproven.','No ordinary game integration or GPU/audio acceptance; finite fields/default arithmetic mode only.'])
(r/'data/4.20/missile_initial_direction_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(passed=True,cases=len(cases),cpu_rsqrt_operations=cpu_operations,native_instruction_addresses=len(visited))))

