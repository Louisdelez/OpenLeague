"""Original9454BF..9455EF bounds update policy and actual944C80."""
from pathlib import Path
import json,itertools,datetime,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_simple_movement.py').read_text(encoding='utf-8').split('\ncontainer=')[0]
exec(compile(setup,'Simple bounds policy setup','exec'))
cpu_hook.__code__=cpu_hook.__code__.replace(co_consts=tuple(0x9455ef if c==0x945120 else c for c in cpu_hook.__code__.co_consts))
container=heap+0x22000;owner=heap+0x23000;ages=heap+0x25000;positions=heap+0x26000;scales=heap+0x27000;frame=stack+0x4000
def words(a,n):return [read32(a+j*4) for j in range(n)]
def observe(uc,a,size,user):
 if a==0x9455ef:u.emu_stop()
 if a==0x944c80:events.append({'kind':'bounds','last':read32(container+0xc0)})
u.hook_add(unicorn.UC_HOOK_CODE,observe)
cases=[]
for flag,(time,last),center_values,owner_values,count,profile,factor in itertools.product([0,1],[(0.,0.),(.01,0.),(.25,0.),(1.,.5),(-.5,1.),(1.,1.)],[[0.,0.,0.],[1.,2.,3.]],[[0.,0.,0.],[2.,-1.,4.]],[0,1,4],range(2),[0.,1.,-2.]):
 age_values=[[0,bits(.5),bits(1.),0x7fa01234],[bits(1.),bits(2.),0x7f800000,0x7fa01234]][profile][:count];initial_positions=[bits(v) for j in range(count) for v in [3.+j,4.-j,-2.]];scale_values=[bits(1.+j) for j in range(count)];initial_minimum=[bits(v) for v in [-1.,-2.,-3.]];initial_maximum=[bits(v) for v in [1.,2.,3.]];center=[bits(v) for v in center_values];owner_center=[bits(v) for v in owner_values];captures=[]
 for corrected in [False,True]:
  enabled=corrected;events=[];u.mem_write(container,b'\0'*0x200);u.mem_write(owner,b'\0'*0x160);write32(container,owner);write32(owner+0xe0,bits(factor));write32(container+0x20,ages);write32(container+0x24,ages+count*4);write32(container+0x2c,positions);write32(container+0x44,scales);write32(container+0xc0,bits(last))
  for address,data in [(ages,age_values),(positions,initial_positions),(scales,scale_values),(container+0xa8,initial_minimum),(container+0xb4,initial_maximum),(container+0xc4,center),(owner+0xc4,owner_center)]:
   for j,v in enumerate(data):write32(address+j*4,v)
  sp=stack+0x8000;u.mem_write(sp-0x100,b'\0'*0x140);u.mem_write(frame-0x100,b'\0'*0x140);write32(frame+8,bits(time));write32(frame+0x10,flag);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_EDI,container);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
  u.emu_start(0x9454bf,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==0x9455ef and u.reg_read(UC_X86_REG_ESP)==sp and restore is None
  captures.append({'minimum':words(container+0xa8,3),'maximum':words(container+0xb4,3),'center':words(container+0xc4,3),'last':read32(container+0xc0),'events':events.copy()})
 cases.append({'flag':flag,'time':bits(time),'last':bits(last),'minimum':initial_minimum,'maximum':initial_maximum,'center':center,'owner_center':owner_center,'factor':bits(factor),'ages':age_values,'positions':initial_positions,'scales':scale_values,'emulator':captures[0],'cpu':captures[1]})
threshold=read32(0x1138ac8)
for address in blocks:kernel.VirtualFree(address,0,0x8000)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'range':'9454BF..9455EF','threshold':threshold,'cases':cases,'actual_cpu_sse_operations':cpu_calls,'emulator_cpu_case_disagreements':sum(c['cpu']!=c['emulator'] for c in cases),'adapters':[],'limits':['Actual policy and whole944C80 bounds helper execute. Explicit flag, time, owner center and bounds fields supplied; selected finite fields.','Surrounding particle cycle, terrain provider and ordinary rendered integration incomplete.']}
(r/'data/4.20/simple_bounds_policy_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'sse':cpu_calls,'disagreements':proof['emulator_cpu_case_disagreements'],'threshold':threshold}))
