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

list_header=vector+0x17000;list_data=list_header+0x100;target=vector+0x18000
requests=[]
def hook_request(uc,a,size,user):
 if a==0x76f0d0:
  requests.append(dict(cast_info=hex(u.reg_read(UC_X86_REG_ECX)-body),normalized_words=list(struct.unpack('<3I',u.mem_read(u.reg_read(UC_X86_REG_EDX),12))),position_words=list(struct.unpack('<3I',u.mem_read(body+0x60,12))),direction_before_words=list(struct.unpack('<3I',u.mem_read(body+0x6c,12)))))
  finish(0)
u.hook_add(unicorn.UC_HOOK_CODE,hook_request)
cases=[]
for direction,position,present,flags,height in itertools.product([[0.,0.,0.],[1400.,30.,0.],[-600.,200.,400.],[1e-6,0.,0.],[0.,1400.,0.],[0.,0.,1400.],[500.,-200.,500.],[-1.,2.,-3.]],[[0.,0.,0.],[500.,30.,100.],[-300.,20.,900.]],[False,True],[0,0x400],[0.,100.]):
 u.mem_write(body,b'\0'*0x600);u.mem_write(config,b'\0'*0x800);u.mem_write(target,b'\0'*0x100)
 w(body+0x140,config);w(body+0x57c,body);w(body+0x58c,vector+0x19000);w(vector+0x19014,config);u.mem_write(config+0x5a8,struct.pack('<f',height))
 fallback=[position[0]+15.,position[1]-5.,position[2]+30.];u.mem_write(body+0x11c,struct.pack('<3f',*fallback));u.mem_write(body+0x6c,struct.pack('<3f',*direction));u.mem_write(target+0x60,struct.pack('<3f',*position));w(target+0x1c,flags)
 w(list_header,list_data);w(list_header+4,list_data+4 if present else list_data);w(list_data,target)
 requests.clear();w(stack,end);w(stack+4,list_header);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,body);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
 
 try:u.emu_start(0x7631d0,end,count=3000)
 except Exception:
  print('FAULT',hex(u.reg_read(UC_X86_REG_EIP)),hex(u.reg_read(UC_X86_REG_ECX)),hex(u.reg_read(UC_X86_REG_ESI)),present);raise
 assert u.reg_read(UC_X86_REG_EIP)==end;assert u.reg_read(UC_X86_REG_EAX)&255==0;assert len(requests)==1
 assert list(struct.unpack('<3I',u.mem_read(body+0x6c,12)))==[0,0,0]
 cases.append(dict(direction=direction,position=position,fallback=fallback,target_present=present,flags=flags,height=height,request=requests[0],final_position_words=list(struct.unpack('<3I',u.mem_read(body+0x60,12))),final_direction_words=[0,0,0],return_value=False))
k.VirtualFree(machine,0,0x8000)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entries=['0x7631d0','0x7647b0','0x763740','0x66d6e0'],native_instruction_addresses=len(visited),actual_cpu_rsqrt_operations=cpu_operations,cases=cases,adapters=['76F0D0 impact-effect consumer is intercepted to record request; concrete consumer internals unexecuted.','Physical CPU RSQRTSS for original66D6E0; actual target selection executes with no target bone resource.'],limits=['Empty/present target span,flags0/400,bone lookup null,height0/100. Nonempty bone resource and missing target object remain unqualified.','Request dispatch and direction-zero order only; particle/audio consumer, damage and object deletion unqualified.','No client binding/GPU/audio acceptance or full-suite rerun.'])
(r/'data/4.20/missile_impact_callback_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(passed=True,cases=len(cases),cpu_rsqrt_operations=cpu_operations)))

