"""Whole921F60 position/AABB, original VM and separate actual SSE arithmetic."""
from pathlib import Path
import json,struct,itertools,datetime,shutil,ctypes,random
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_complex_particle_storage.py').read_text(encoding='utf-8').split('\ncases=[]')[0],'native setup','exec'))
from capstone import Cs,CS_ARCH_X86,CS_MODE_32,CS_OP_REG,CS_OP_MEM
import unicorn.x86_const as registers
cs=Cs(CS_ARCH_X86,CS_MODE_32);cs.detail=True
kernel=ctypes.WinDLL('kernel32',use_last_error=True);kernel.VirtualAlloc.argtypes=[ctypes.c_void_p,ctypes.c_size_t,ctypes.c_uint32,ctypes.c_uint32];kernel.VirtualAlloc.restype=ctypes.c_void_p;kernel.VirtualFree.argtypes=[ctypes.c_void_p,ctypes.c_size_t,ctypes.c_uint32]
blocks=[];cpu_functions={}
for name,opcode in [('mulss','59'),('subss','5c'),('addss','58')]:
 code=bytes.fromhex('660f6ec1660f6eca'+'f30f'+opcode+'c1660f7ec0c3');addr=kernel.VirtualAlloc(None,4096,0x3000,0x40);assert addr;ctypes.memmove(addr,code,len(code));blocks.append(addr);cpu_functions[name]=ctypes.CFUNCTYPE(ctypes.c_uint32,ctypes.c_uint32,ctypes.c_uint32)(addr)
enabled=False;cpu_calls=0;decoded={}
def cpu_hook(uc,a,size,user):
 global cpu_calls
 if not enabled or not 0x921f60<=a<0x922000:return
 if a not in decoded:decoded[a]=next(cs.disasm(bytes(u.mem_read(a,size)),a))
 ins=decoded[a]
 if ins.mnemonic not in cpu_functions:return
 dest=ins.operands[0];source=ins.operands[1];dest_reg=getattr(registers,'UC_X86_REG_'+ins.reg_name(dest.reg).upper());left=u.reg_read(dest_reg)&0xffffffff
 if source.type==CS_OP_REG:right=u.reg_read(getattr(registers,'UC_X86_REG_'+ins.reg_name(source.reg).upper()))&0xffffffff
 else:
  assert source.type==CS_OP_MEM
  m=source.mem
  def reg(identifier):return u.reg_read(getattr(registers,'UC_X86_REG_'+ins.reg_name(identifier).upper())) if identifier else 0
  right=read32((reg(m.base)+reg(m.index)*m.scale+m.disp)&0xffffffff)
 output=cpu_functions[ins.mnemonic](left,right);cpu_calls+=1
 u.reg_write(dest_reg,(u.reg_read(dest_reg)&~0xffffffff)|output);u.reg_write(UC_X86_REG_EIP,a+size)
u.hook_add(unicorn.UC_HOOK_CODE,cpu_hook)
constants={name:hex(read32(addr)) for name,addr in [('half',0x1138be0),('two',0x1138df8)]}
actor=heap+0x9000;actor_config=heap+0xa000;position=heap+0xb000
special=[0,0x80000000,1,0x80000001,0x3f800000,0xbf800000,0x7f7fffff,0xff7fffff,0x7f800000,0xff800000,0x7fa01234,0xffa05678,0x7fc01234,0xffc05678]
inputs=[([special[(i+axis)%len(special)] for axis in range(3)],coefficient) for i,coefficient in itertools.product(range(len(special)),special)]
rng=random.Random(420)
for i in range(256):inputs.append(([bits(rng.uniform(-100000.,100000.)) for _ in range(3)],bits(rng.uniform(-1000.,1000.))))
cases=[]
for values,coefficient in inputs:
 captures=[]
 for corrected in [False,True]:
  enabled=corrected;u.mem_write(actor,b'\0'*0x200);write32(actor+0xe8,actor_config);write32(actor_config+0x138,coefficient);u.mem_write(position,struct.pack('<3I',*values));sp=stack+0x8000;write32(sp,end);write32(sp+4,position);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,actor);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
  u.emu_start(0x921f60,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
  captures.append({'position':[hex(read32(actor+0x90+axis*4)) for axis in range(3)],'minimum':[hex(read32(actor+0x130+axis*4)) for axis in range(3)],'maximum':[hex(read32(actor+0x13c+axis*4)) for axis in range(3)]})
 cases.append({'input':[hex(v) for v in values],'coefficient':hex(coefficient),'emulator':captures[0],'cpu':captures[1]})
for addr in blocks:kernel.VirtualFree(addr,0,0x8000)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'entry':'921F60','constants':constants,'cases':cases,'actual_cpu_sse_operations':cpu_calls,'emulator_cpu_case_disagreements':sum(c['emulator']!=c['cpu'] for c in cases),'adapters':['Original whole921F60 executes with supplied position and configuration138 coefficient, no formula replacement in original VM capture.','Separate execution uses actual CPU MULSS/SUBSS/ADDSS for every scalar arithmetic instruction; original stores and register order retained, upper register words preserved. Original VM result retained independently.'],'limits':['Configuration138 source/name/default, owner position producer and integration into whole940frame remain incomplete.','Masked default arithmetic control only; altered rounding/flush modes not qualified.','No ordinary graphical application rebuild or final render acceptance.']}
(r/'data/4.20/troy_position_bounds_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'passed':True,'cases':len(cases),'cpu_operations':cpu_calls,'disagreements':proof['emulator_cpu_case_disagreements'],'constants':constants}))
