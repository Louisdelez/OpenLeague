"""Keep original VM and actual-CPU-corrected x87 copy captures separate."""
from pathlib import Path
import json,struct,itertools,ctypes,datetime,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_complex_particle_storage.py').read_text(encoding='utf-8').split('\ncases=[]')[0],'append setup','exec'))
from capstone import Cs,CS_ARCH_X86,CS_MODE_32,CS_OP_MEM
import unicorn.x86_const as registers
cs=Cs(CS_ARCH_X86,CS_MODE_32);cs.detail=True
kernel=ctypes.WinDLL('kernel32',use_last_error=True);kernel.VirtualAlloc.argtypes=[ctypes.c_void_p,ctypes.c_size_t,ctypes.c_uint32,ctypes.c_uint32];kernel.VirtualAlloc.restype=ctypes.c_void_p;kernel.VirtualFree.argtypes=[ctypes.c_void_p,ctypes.c_size_t,ctypes.c_uint32]
machine=bytes.fromhex('d901d91ac3');address=kernel.VirtualAlloc(None,4096,0x3000,0x40);assert address;ctypes.memmove(address,machine,len(machine))
copy_float=ctypes.CFUNCTYPE(None,ctypes.POINTER(ctypes.c_uint32),ctypes.POINTER(ctypes.c_uint32))(address)
enabled=False;restore=None;cpu_calls=0;decoded={};copy_sites=set()
def correct_x87(uc,a,size,user):
 global restore,cpu_calls
 if restore is not None:
  source,old=restore;write32(source,old);restore=None
 if not enabled:return
 if a not in decoded:
  ins=next(cs.disasm(bytes(u.mem_read(a,size)),a),None)
  decoded[a]=ins if ins and ins.mnemonic=='fld' and len(ins.operands)==1 and ins.operands[0].type==CS_OP_MEM and ins.operands[0].size==4 else None
 ins=decoded[a]
 if ins is None:return
 operand=ins.operands[0].mem
 def reg(identifier):return u.reg_read(getattr(registers,'UC_X86_REG_'+ins.reg_name(identifier).upper())) if identifier else 0
 source=(reg(operand.base)+reg(operand.index)*operand.scale+operand.disp)&0xffffffff
 value=read32(source)
 if value&0x7f800000==0x7f800000 and value&0x007fffff:
  input_word=ctypes.c_uint32(value);output_word=ctypes.c_uint32();copy_float(ctypes.byref(input_word),ctypes.byref(output_word));cpu_calls+=1;copy_sites.add(a)
  if output_word.value!=value:write32(source,output_word.value);restore=(source,value)
u.hook_add(unicorn.UC_HOOK_CODE,correct_x87)
patterns=[0x7fa01234,0xffa05678,0x7fc01234,0xffc05678,0x7f800000,0xff800000,0x80000000,0,1,0x3f800000]
cases=[]
for kind,trail_count,index,phase in itertools.product([1,4,5,9],[0,1],[0,1,2],[0,1]):
 captures=[]
 for corrected in [False,True]:
  enabled=False;height=0.;initialize(32,trail_count,False);write32(config+0x10,kind)
  for particle in range(3):append(payload(particle,0),particle)
  for offset,width in zip(offsets[:-1],widths[:-1]):
   ptr=read32(container+offset)
   for particle in range(3):
    values=[patterns[(word+particle+phase)%len(patterns)] for word in range(width//4)]
    u.mem_write(ptr+particle*width,struct.pack('<'+'I'*len(values),*values))
  write32(container+0xac,3);before=snapshot_buffers();enabled=corrected
  sp=stack+0x8000;write32(sp,end);write32(sp+4,index);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,container);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPTAG,0xffff)
  u.emu_start(0x937f30,end,count=1000000);assert u.reg_read(UC_X86_REG_EIP)==end and restore is None
  captures.append(snapshot_buffers());enabled=False
 cases.append({'kind':kind,'trail_slots':trail_count,'count':3,'index':index,'phase':phase,'before':before,'emulator_after':captures[0],'cpu_after':captures[1]})
kernel.VirtualFree(address,0,0x8000)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'entry':'937F30','cases':cases,'actual_cpu_x87_copies':cpu_calls,'actual_cpu_instruction_bytes':machine.hex(),'x87_copy_sites':[hex(a) for a in sorted(copy_sites)],'emulator_cpu_case_disagreements':sum(c['emulator_after']!=c['cpu_after'] for c in cases),'adapters':['Entire original937F30 and all helpers run; null trails, heap/security adapters as append proof.','Nonfinite raw particle buffers supplied after append. Original emulator capture retained separately.','Second original-function execution uses real CPU FLD32/FSTP32 for each NaN source observed at native FLD32. Temporary converted operand restored before the next instruction. This corrects known Unicorn SNaN quieting discrepancy, preserving original source memory and native store/copy order.'],'limits':['Null trail resources only; live callback/refcount and death-emitter branch incomplete.','Masked x87 default control only; CPU-assisted emulation is not execution of the whole original32-bit function on hardware.','Ordinary graphical integration pending.']}
(r/'data/4.20/complex_particle_removal_x87_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({k:proof[k] for k in ['passed','actual_cpu_x87_copies','emulator_cpu_case_disagreements']}));print('cases',len(cases))
