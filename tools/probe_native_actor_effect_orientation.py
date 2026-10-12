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
 if a==0x5fa7d9:
  xmm=u.reg_read(UC_X86_REG_XMM1);src=ctypes.c_uint32(xmm&0xffffffff);dst=ctypes.c_uint32();rsqrt(ctypes.byref(src),ctypes.byref(dst));u.reg_write(UC_X86_REG_XMM1,(xmm&~0xffffffff)|dst.value);u.reg_write(UC_X86_REG_EIP,a+size);cpu_operations+=1
 visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook_owner)
w(provider,vt);w(vt+0x24,0x718dd0);w(provider+4,handle);w(provider+8,control);w(provider+0x1c,actor);w(handle,actor);w(control+4,2);w(control+8,2)
identity=[1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.]
matrices=[identity,[0.,0.,-2.,0.,0.,3.,0.,0.,4.,0.,0.,0.,123.,456.,789.,2.],[1.,2.,3.,0.,4.,5.,6.,0.,7.,8.,9.,0.,-99.,50.,77.,0.],[0.]*16,[.25,0.,0.,0.,0.,-5.,0.,0.,0.,0.,99.,0.,0.,0.,0.,1.]]
cases=[]
for matrix in matrices:
 u.mem_write(actor+0x18c0,struct.pack('<16f',*matrix));u.mem_write(output,b'\xa5'*64);w(stack,end);w(stack+4,output);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,provider);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.emu_start(0x719890,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end;assert (u.reg_read(UC_X86_REG_EAX)&255)==1;assert read(control+4)==2
 words=list(struct.unpack('<16I',u.mem_read(output,64)));assert words[12:]==[0,0,0,0x3f800000]
 cases.append(dict(input=matrix,result_words=words))
k.VirtualFree(machine,0,0x8000)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entries=['0x719890','0x8de500','0x718f70','0x5fa7c0'],native_instruction_addresses=len(visited),actual_cpu_rsqrt_operations=cpu_operations,cases=cases,adapters=['Original orientation/copy/normalization/approximate sqrt execute; only RSQRTSS uses same physical x86 CPU as Rust port.','Live weak-owner acquisition uses original functions with explicit object matrix fields.'],limits=['Exceptional/nonfinite/denormal matrices and expired-owner assertion path not qualified.','Provider binding to Annie projection remains unproven; no new GPU fidelity qualification.'])
(r/'data/4.20/actor_effect_owner_orientation_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(passed=True,cases=len(cases),cpu_rsqrt_operations=cpu_operations,native_instruction_addresses=len(visited))))
