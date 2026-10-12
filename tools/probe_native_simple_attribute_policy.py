"""Whole944540 with actual9442F0/9444B0/9443D0 bodies and native norm."""
from pathlib import Path
import json,itertools,datetime,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_simple_movement.py').read_text(encoding='utf-8').split('\ncontainer=')[0]
exec(compile(setup,'Simple attribute policy setup','exec'))
container=heap+0x22000;ages=heap+0x25000;output=heap+0x26000;velocities=heap+0x27000;auxiliary=heap+0x28000
def words(a,n):return [read32(a+j*4) for j in range(n)]
cases=[]
for count,mode,profile,(multiplier,offset) in itertools.product([0,1,3,4,5,7,8,9],[0,1,2,3,4,99,0xffffffff],range(3),[(0.,0.),(2.,-1.),(.125,3.)]):
 pattern=[[0,bits(.25),bits(.999),bits(1.)],[bits(-.5),0,bits(.5),0x7fa01234],[0xff800000,bits(1.),0x7f800000,0x7fa01234]][profile]
 age_values=[pattern[j%4] for j in range(count)];initial=[0xcccccccc+j for j in range(count)];velocity_values=[bits(v) for j in range(count) for v in [3.+j,4.,-2.]];auxiliary_values=[bits(j*.125) for j in range(count)];captures=[]
 for corrected in [False,True]:
  enabled=corrected;u.mem_write(container,b'\0'*0xb0);write32(container+0x20,ages);write32(container+0x24,ages+count*4);write32(container+0x38,velocities);write32(container+0x74,auxiliary);write32(container+0x80,output)
  for address,data in [(ages,age_values),(output,initial),(velocities,velocity_values),(auxiliary,auxiliary_values)]:
   for j,v in enumerate(data):write32(address+j*4,v)
  sp=stack+0x8000;u.mem_write(sp-0x100,b'\0'*0x140);write32(sp,end);write32(sp+4,container+0x80);write32(sp+8,mode);write32(sp+12,bits(multiplier));write32(sp+16,bits(offset));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,container);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
  u.emu_start(0x944540,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==sp+20 and restore is None
  captures.append({'output':words(output,count),'ages':words(ages,count),'velocities':words(velocities,count*3),'auxiliary':words(auxiliary,count)})
 cases.append({'mode':mode,'multiplier':bits(multiplier),'offset':bits(offset),'ages':age_values,'initial':initial,'velocities':velocity_values,'auxiliary':auxiliary_values,'emulator':captures[0],'cpu':captures[1]})
constants={hex(a):read32(a) for a in [0x1138c74]}
for address in blocks:kernel.VirtualFree(address,0,0x8000)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'entry':'944540','cases':cases,'constants':constants,'actual_cpu_sse_operations':cpu_calls,'emulator_cpu_case_disagreements':sum(c['cpu']!=c['emulator'] for c in cases),'adapters':[],'limits':['Whole dispatcher and three actual child bodies execute; velocity mode includes original5FA7C0 norm and x87 multiply/add. Explicit ages/velocity/auxiliary/output pointers and coefficients supplied.','Selected finite velocity/auxiliary/coefficient fields; negative/infinite/NaN ages. Native field names, resource reader and ordinary renderer not qualified.']}
(r/'data/4.20/simple_attribute_policy_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'sse':cpu_calls,'disagreements':proof['emulator_cpu_case_disagreements'],'constants':constants}))
