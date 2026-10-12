from pathlib import Path
import shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'setup','exec'))
u.mem_map(0,0x1000)
wrapper=vector+0x6000;effect=vector+0x7000;effect_control=vector+0x7100;provider=vector+0x8000;provider_control=vector+0x8100;old=vector+0x9000;old_control=vector+0x9100;capture=vector+0x5000;events=[];actor=vector+0xc000;metadata=vector+0xe000;owner_actor=vector+0xf000;owner_handle=vector+0x11000;owner_control=vector+0x11100
w(effect,0x10d6db4)
import ctypes
k=ctypes.WinDLL('kernel32',use_last_error=True);k.VirtualAlloc.argtypes=[ctypes.c_void_p,ctypes.c_size_t,ctypes.c_uint32,ctypes.c_uint32];k.VirtualAlloc.restype=ctypes.c_void_p;k.VirtualFree.argtypes=[ctypes.c_void_p,ctypes.c_size_t,ctypes.c_uint32]
code=bytes.fromhex('f30f5201f30f1102c3');machine=k.VirtualAlloc(None,4096,0x3000,0x40);assert machine;ctypes.memmove(machine,code,len(code));rsqrt=ctypes.CFUNCTYPE(None,ctypes.POINTER(ctypes.c_uint32),ctypes.POINTER(ctypes.c_uint32))(machine);cpu_operations=0
def bind_hook(uc,a,size,user):
 global cpu_operations
 if a in [0x9941b0,0x994210]:finish(0);return
 if a in [0x5fa7d9,0x66d6f1]:
  reg=UC_X86_REG_XMM1 if a==0x5fa7d9 else UC_X86_REG_XMM2;xmm=u.reg_read(reg);src=ctypes.c_uint32(xmm&0xffffffff);dst=ctypes.c_uint32();rsqrt(ctypes.byref(src),ctypes.byref(dst));u.reg_write(reg,(xmm&~0xffffffff)|dst.value);u.reg_write(UC_X86_REG_EIP,a+size);cpu_operations+=1

 if a==0x9286c0:
  sp=u.reg_read(UC_X86_REG_ESP);ptr=read(sp+4);ctrl=read(sp+8);assert u.reg_read(UC_X86_REG_ECX)==effect;events.append(dict(provider=hex(ptr),control=hex(ctrl)))
 visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,bind_hook)
cases=[]
for provider_present,effect_live,owner_live,flags,direction in itertools.product([False,True],[False,True],[False,True],[0,0x10,0x30],[[0.,0.,1.],[1.,2.,3.],[0.,-1.,0.]]):
 old_present=False;effect_old_present=False
 u.mem_write(effect,b'\0'*0x180);w(effect,0x10d6db4);w(effect+0xc8,vector+0xa000 if effect_old_present else 0);w(effect+0xcc,vector+0xa100 if effect_old_present else 0);w(vector+0xa104,3);w(vector+0xa108,3);u.mem_write(wrapper,b'\0'*0x180);w(wrapper+0x148,old if old_present else 0);w(wrapper+0x14c,old_control if old_present else 0);w(old_control+4,3);w(old_control+8,3)
 w(wrapper+0x11c,effect);w(wrapper+0x120,effect_control);w(effect_control+4,3 if effect_live else 0);w(effect_control+8,3);w(provider_control+4,3);w(provider_control+8,3)
 w(provider,0x10b0d20);w(provider+4,owner_handle);w(provider+8,owner_control);w(provider+0x1c,owner_actor);w(provider+0xc,7);w(owner_handle,owner_actor);w(owner_control+4,2 if owner_live else 0);w(owner_control+8,3);w(owner_actor+0x1c,0x400);w(owner_actor+0x114,8);w(owner_actor+0x118,1);u.mem_write(owner_actor+0x60,struct.pack('<3f',100.,200.,300.));u.mem_write(owner_actor+0x6c,struct.pack('<3f',*direction));ptr=provider if provider_present else 0;ctrl=provider_control if provider_present else 0;w(stack,end);w(stack+4,ptr);w(stack+8,ctrl);events=[];u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,wrapper);u.emu_start(0x6c9bd0,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 assert read(wrapper+0x148)==ptr and read(wrapper+0x14c)==ctrl
 assert len(events)==int(effect_live)
 if events:assert events[0]==dict(provider=hex(ptr),control=hex(ctrl))
 assert read(effect+0xc8)==(ptr if effect_live else vector+0xa000 if effect_old_present else 0)
 assert read(effect+0xcc)==(ctrl if effect_live else vector+0xa100 if effect_old_present else 0)
 # Run original owner phase with the concrete producer just attached above.
 u.mem_write(actor,b'\0'*0x300);w(actor+0xe8,metadata);u.mem_write(metadata+0x138,struct.pack('<f',500.));w(metadata+0x1bc,0);w(effect+0x114,actor);w(effect+0x24,flags)
 u.mem_write(effect+0x40,struct.pack('<3f',-1.,-2.,-3.));u.mem_write(effect+0x4c,struct.pack('<3f',-4.,-5.,-6.))
 identity=[1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.];u.mem_write(effect+0x88,struct.pack('<16f',*identity));u.mem_write(actor+0x90,struct.pack('<3f',-1.,-2.,-3.));u.mem_write(actor+0x9c,struct.pack('<3f',-4.,-5.,-6.));u.mem_write(actor+0xf0,struct.pack('<16f',*identity));w(actor+0x70,0x80)
 w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_EBP,stack-0x100);u.reg_write(UC_X86_REG_EDI,effect);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.emu_start(0x94099a,0x940aee,count=100000);assert u.reg_read(UC_X86_REG_EIP)==0x940aee
 def words(address,count):return list(struct.unpack('<'+'I'*count,u.mem_read(address,count*4)))
 cases.append(dict(provider_present=provider_present,effect_live=effect_live,owner_live=owner_live,flags=flags,direction=direction,result=dict(source_position=words(effect+0x40,3),source_direction=words(effect+0x4c,3),source_matrix=words(effect+0x88,16),position=words(actor+0x90,3),direction=words(actor+0x9c,3),matrix=words(actor+0xf0,16),minimum=words(actor+0x130,3),maximum=words(actor+0x13c,3),source_flags=read(actor+0x70))))
k.VirtualFree(machine,0,0x8000)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entries=['0x6c9bd0','0x9286c0','0x94099a..0x940aee'],actual_cpu_rsqrt_operations=cpu_operations,native_instruction_addresses=len(visited),cases=cases,adapters=['Native shared/weak assignment/acquisition/release helpers execute.','Actual effect virtual68/9286C0 and full94099A..940AEE owner phase execute with concrete10B0D20 producer methods. No owner virtual return adapted.','RSQRTSS executes on local CPU; mutex endpoints adapted to single-threaded empty callback queue.'],limits=['Full projectile creation/update not executed here; old references retain extra ownership so destructor branches are not exercised.','Provider construction763BDC=10B0D20 established statically, not whole live gameplay.'])
(r/'data/4.20/missile_effect_owner_pose_pipeline_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(passed=True,cases=len(cases),native_instruction_addresses=len(visited))))
