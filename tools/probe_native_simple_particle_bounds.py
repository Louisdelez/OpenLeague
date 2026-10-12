"""Whole944C80 active-particle bounds; no endpoint adapters."""
from pathlib import Path
import json,itertools,datetime,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_simple_movement.py').read_text(encoding='utf-8').split('\ncontainer=')[0]
exec(compile(setup,'Simple bounds setup','exec'))
container=heap+0x22000;owner=heap+0x23000;ages=heap+0x25000;positions=heap+0x26000;scales=heap+0x27000
def words(a,n):return [read32(a+j*4) for j in range(n)]
cases=[]
for count,profile,scale_profile,factor,position_profile in itertools.product([0,1,4],range(3),range(3),[0.,1.,-2.,.5],range(3)):
 age_values=[[0,bits(.5),bits(1.),0x7fa01234],[bits(-.5),bits(.999),0xff800000,0x7fa01234],[bits(1.),bits(2.),0x7f800000,0x7fa01234]][profile][:count]
 initial_positions=[bits(v) for j in range(count) for v in [[0.,0.,0.],[3.+j,4.-j,-2.],[-3.-j,-4.+j,2.]][position_profile]];scale_values=[bits([0.,1.+j,-.5-j][scale_profile]) for j in range(count)];captures=[]
 for corrected in [False,True]:
  enabled=corrected;u.mem_write(container,b'\0'*0x200);u.mem_write(owner,b'\0'*0x160);write32(container,owner);write32(owner+0xe0,bits(factor));write32(container+0x20,ages);write32(container+0x24,ages+count*4);write32(container+0x2c,positions);write32(container+0x44,scales)
  for address,data in [(ages,age_values),(positions,initial_positions),(scales,scale_values)]:
   for j,v in enumerate(data):write32(address+j*4,v)
  sp=stack+0x8000;u.mem_write(sp-0x100,b'\0'*0x140);write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,container);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
  u.emu_start(0x944c80,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==sp+4 and restore is None
  captures.append({'minimum':words(container+0xa8,3),'maximum':words(container+0xb4,3),'ages':words(ages,count),'positions':words(positions,count*3),'scales':words(scales,count)})
 cases.append({'factor':bits(factor),'ages':age_values,'positions':initial_positions,'scales':scale_values,'emulator':captures[0],'cpu':captures[1]})
for address in blocks:kernel.VirtualFree(address,0,0x8000)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'entry':'944C80','cases':cases,'actual_cpu_sse_operations':cpu_calls,'emulator_cpu_case_disagreements':sum(c['cpu']!=c['emulator'] for c in cases),'adapters':[],'limits':['Actual full bounds body. Explicit ownerE0 factor, container44 scales,20 ages and2C positions. Selected finite fields including zero/negative scale and factor; expired/infinite/NaN ages.','Authoring defaults, owner producers and ordinary rendered integration remain incomplete.']}
(r/'data/4.20/simple_particle_bounds_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'sse':cpu_calls,'disagreements':proof['emulator_cpu_case_disagreements']}))
