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

cases=[]
for direction,next_position,target_position,radius in itertools.product([[1.,0.,0.],[-1.,0.,0.],[1.,5.,2.],[0.,100.,0.],[0.,0.,1.],[-2.,0.,3.]],[[0.,0.,0.],[500.,30.,100.],[600.,99.,100.],[650.,-20.,100.]],[[500.,20.,100.],[600.,90.,100.],[0.,0.,0.]],[0.,65.]):
 u.mem_write(body+0x6c,struct.pack('<3f',*direction));u.mem_write(output,struct.pack('<6f',*next_position,*target_position))
 w(stack,end);w(stack+4,output);w(stack+8,output+12);u.mem_write(stack+12,struct.pack('<f',radius));u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,body);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
 u.emu_start(0x75f840,end,count=1000);assert u.reg_read(UC_X86_REG_EIP)==end
 cases.append(dict(direction=direction,next_position=next_position,target_position=target_position,radius=radius,crossed=bool(u.reg_read(UC_X86_REG_EAX)&255)))
k.VirtualFree(machine,0,0x8000)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x75f840',native_instruction_addresses=len(visited),actual_cpu_rsqrt_operations=cpu_operations,cases=cases,adapters=['Physical CPU RSQRTSS operand for original66D6E0; no function return adapters.'],limits=['Finite ordinary directions,zeroXZ included. Crossing predicate only; lifecycle callback and impact effects not qualified.','No live client/GPU/audio acceptance.'])
(r/'data/4.20/missile_end_crossing_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(passed=True,cases=len(cases),cpu_rsqrt_operations=cpu_operations)))
