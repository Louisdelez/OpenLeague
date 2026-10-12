"""Original94520B..9452F1 scalar integration: actual binary SSE, no adapters."""
from pathlib import Path
import json,itertools,datetime,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_simple_movement.py').read_text(encoding='utf-8').split('\ncontainer=')[0]
exec(compile(setup,'Simple scalar integration native setup','exec'))
cpu_hook.__code__=cpu_hook.__code__.replace(co_consts=tuple(0x9452f1 if c==0x945120 else c for c in cpu_hook.__code__.co_consts))
container=heap+0x22000;ages=heap+0x25000;output=heap+0x26000;rates=heap+0x27000;frame=stack+0x4000
def stop(uc,a,size,user):
 if a==0x9452f1:u.emu_stop()
u.hook_add(unicorn.UC_HOOK_CODE,stop)
def words(a,n):return [read32(a+j*4) for j in range(n)]
cases=[]
for count,profile,delta,pattern in itertools.product([0,1,3,4,5,7,8,9,17],range(3),[0.,.125,-.5,2.],range(3)):
 agepattern=[[0,bits(.25),bits(.999),bits(1.)],[bits(-.5),0,bits(.5),0x7fa01234],[0xff800000,bits(1.),0x7f800000,0x7fa01234]][profile]
 initial_ages=[agepattern[j%4] for j in range(count)]
 initial=[bits([0.,float(j+1),-float(j+1)][pattern]) for j in range(count)]
 initial_rates=[bits([1.,-float(j+1),.5*(j+1)][pattern]) for j in range(count)]
 captures=[]
 for corrected in [False,True]:
  enabled=corrected;u.mem_write(container,b'\0'*0xb0);write32(container+0x20,ages);write32(container+0x5c,output);write32(container+0x68,rates)
  for address,data in [(ages,initial_ages),(output,initial),(rates,initial_rates)]:
   for j,v in enumerate(data):write32(address+j*4,v)
  sp=stack+0x8000;u.mem_write(sp-0x100,b'\0'*0x140);u.mem_write(frame-0x100,b'\0'*0x140);write32(frame-8,count);write32(frame-0x14,container);write32(frame-0x10,bits(delta));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_EDI,container);u.reg_write(UC_X86_REG_XMM1,bits(1.));u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
  u.emu_start(0x94520b,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==0x9452f1 and u.reg_read(UC_X86_REG_ESP)==sp and restore is None
  captures.append({'output':words(output,count),'rates':words(rates,count),'ages':words(ages,count)})
 cases.append({'ages':initial_ages,'initial':initial,'rates':initial_rates,'delta':bits(delta),'emulator':captures[0],'cpu':captures[1]})
for address in blocks:kernel.VirtualFree(address,0,0x8000)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'range':'94520B..9452F1','cases':cases,'actual_cpu_sse_operations':cpu_calls,'emulator_cpu_case_disagreements':sum(c['cpu']!=c['emulator'] for c in cases),'adapters':[],'limits':['Actual unrolled four-particle blocks and scalar remainder. Explicit container20/5C/68 arrays and delta frame-10 supplied; remaining particle cycle and resource producers incomplete.','Selected finite rates/outputs/deltas; negative/infinite/NaN ages and default FP mode.']}
(r/'data/4.20/simple_scalar_integration_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'sse':cpu_calls,'disagreements':proof['emulator_cpu_case_disagreements']}))
