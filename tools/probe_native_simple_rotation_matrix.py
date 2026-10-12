"""Whole8E03F0 axis-angle matrix, actual CRT reduction and native trig bodies."""
from pathlib import Path
import json,struct,itertools,datetime,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_simple_movement.py').read_text(encoding='utf-8').split('\ncontainer=')[0]
exec(compile(setup,'rotation matrix native setup','exec'))
matrix=heap+0x22000;axis=heap+0x23000
def words(a,n):return [read32(a+j*4) for j in range(n)]
def observe_matrix(uc,a,size,user):
 global reduced
 if a==0x8e045b:reduced=read32(u.reg_read(UC_X86_REG_EBP)+8)
u.hook_add(unicorn.UC_HOOK_CODE,observe_matrix)
axes=[[1.,0.,0.],[0.,1.,0.],[0.,0.,1.],[0.,-1.,0.],[0.,0.,0.],[1.,1.,1.],[.5,-.25,2.]]
angles=[0.,-0.,.1,-.1,1.,-1.,1.5707963,-1.5707963,3.1415927,-3.1415927,6.2831853,-6.2831853,10.,-10.,100.]
cases=[]
for angle_value,axis_values in itertools.product(angles,axes):
 captures=[]
 for corrected in [False,True]:
  enabled=corrected;reduced=None;u.mem_write(matrix,b'\xcc'*64)
  for j,v in enumerate(axis_values):write32(axis+j*4,bits(v))
  sp=stack+0x8000;u.mem_write(sp-0x600,b'\0'*0x640);write32(sp,end);write32(sp+4,bits(angle_value))
  for reg,value in [(UC_X86_REG_ESP,sp),(UC_X86_REG_ECX,matrix),(UC_X86_REG_EDX,axis),(UC_X86_REG_FPCW,0x37f),(UC_X86_REG_FPTAG,0xffff),(UC_X86_REG_MXCSR,0x1f80)]:u.reg_write(reg,value)
  u.emu_start(0x8e03f0,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==sp+4 and restore is None
  captures.append(dict(matrix=words(matrix,16),reduced_angle=reduced))
 cases.append(dict(angle=bits(angle_value),axis=[bits(v) for v in axis_values],emulator=captures[0],cpu=captures[1]))
constants={hex(a):read32(a) for a in [0x1138f8c,0x1138eac,0x113932c,0x1138a68,0x12237a8,0x14ae650]}
for address in blocks:kernel.VirtualFree(address,0,0x8000)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='8E03F0',cases=cases,constants=constants,actual_cpu_sse_operations=cpu_calls,emulator_cpu_case_disagreements=sum(c['cpu']!=c['emulator'] for c in cases),adapters=[],limits=['Selected finite axes/angles, explicit default FP controls and executable-image CRT globals; whole original CRT angle reduction executes. Host reference supplies SSE arithmetic only, x87 uses emulator.','List composition, source sampling and ordinary rendered integration remain incomplete.'])
assert proof['emulator_cpu_case_disagreements']==0
(r/'data/4.20/simple_rotation_matrix_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(cases),sse=cpu_calls,disagreements=proof['emulator_cpu_case_disagreements'],constants=constants)))
