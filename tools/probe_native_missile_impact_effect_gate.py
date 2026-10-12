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

actor=vector+0x17000;text=vector+0x18000;u.mem_write(text,b'impact.troy\0');route=[]
def selection(uc,a,size,user):
 if a in [0x76f346,0x751be0,0x76f5f9]:
  route.append({0x76f346:'hit_branch',0x751be0:'after_request',0x76f5f9:'none'}[a]);uc.emu_stop()
u.hook_add(unicorn.UC_HOOK_CODE,selection)
cases=[]
for forced,point_flag,hit_flag,after_flag,name_pointer in itertools.product([0,1,255],[False,True],[False,True],[False,True],[False,True]):
 u.mem_write(body,b'\0'*0x500);u.mem_write(config,b'\0'*0x800);u.mem_write(body+0x3b9,bytes([forced]));u.mem_write(config+0x37d,bytes([2 if point_flag else 0]));u.mem_write(config+0x37f,bytes([0x40 if hit_flag else 0]));u.mem_write(config+0x380,bytes([int(after_flag)]));w(config+0x6f8,16);w(config+0x6e4,text if name_pointer else 0)
 w(stack+0x1c,actor);w(stack+0x34,text);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_EDI,body);u.reg_write(UC_X86_REG_ESI,config);u.reg_write(UC_X86_REG_EBX,actor);route.clear();u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff)
 u.emu_start(0x76f323,end,count=500);assert len(route)==1
 expected='none' if not forced and not point_flag else 'hit_branch' if hit_flag else 'after_request' if after_flag and name_pointer else 'none';assert route[0]==expected
 cases.append(dict(forced=forced,point_flag=point_flag,hit_flag=hit_flag,after_flag=after_flag,name_pointer=name_pointer,route=route[0]))
k.VirtualFree(machine,0,0x8000)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x76f323',native_instruction_addresses=len(visited),cases=cases,adapters=['Execution stops at hit branch76F346, after-effect call751BE0 or no-named-effect continuation76F5F9; no downstream effect consumer is substituted.'],findings=['Outer gate: CastInfo3B9 nonzero or SpellData37D bit2; hit branch uses37F bit40; after gate uses380 bit1 and nonnull effect string pointer.','Original loader HaveHitEffect stores inner34B bit40; HaveAfterEffect stores inner34C bit1. Prefix34 agrees with consumer37F/380.'],limits=['Gate section only; hit branch effect creation and other impact consumers unqualified.','After string heap pointer mode only, capacity16; no-null inline string does not prove nonempty text.','No live game/particle/audio acceptance.'])
(r/'data/4.20/missile_impact_effect_gate_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(passed=True,cases=len(cases),native_instruction_addresses=len(visited))))
