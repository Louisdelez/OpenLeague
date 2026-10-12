"""Original944EF9..945120 movement policy with real axis/circular bodies."""
from pathlib import Path
import json,struct,itertools,datetime,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_simple_circular_motion.py').read_text(encoding='utf-8').split('\nposition=')[0]
exec(compile(setup,'Simple movement policy native setup','exec'))
cpu_hook.__code__=cpu_hook.__code__.replace(co_consts=tuple(0x945120 if c==0x944c80 else c for c in cpu_hook.__code__.co_consts))
container=heap+0x22000;instance=heap+0x23000;definition=heap+0x24000;positions=heap+0x25000;velocities=heap+0x26000;ages=heap+0x27000;frame=stack+0x4000
def words(a,n):return [read32(a+j*4) for j in range(n)]
def observe(uc,a,size,user):
 if a==0x945120:u.emu_stop();return
 if a==0x944a10:
  sp=u.reg_read(UC_X86_REG_ESP);p=u.reg_read(UC_X86_REG_EDX);v=u.reg_read(UC_X86_REG_ECX);index=(p-positions)//12;assert v==velocities+index*12
  events.append({'kind':'axis','index':index,'axis':words(read32(sp+8),3),'center':words(read32(sp+4),3),'delta':None,'axis_a':None,'axis_b':None})
 if a==0x9448c0:
  sp=u.reg_read(UC_X86_REG_ESP);p=u.reg_read(UC_X86_REG_ECX);v=u.reg_read(UC_X86_REG_EDX);index=(p-positions)//12;assert v==velocities+index*12
  events.append({'kind':'circular','index':index,'axis':None,'center':words(read32(sp+4),3),'delta':read32(sp+8),'axis_a':read32(sp+12),'axis_b':read32(sp+16)})
u.hook_add(unicorn.UC_HOOK_CODE,observe)
cases=[]
for circular,direction,count,delta,profile,center_values in itertools.product([False,True],[0,1,2,3,4,5,6,99,0xffffffff],[0,1,4],[0.,.125,-.5,2.],range(2),[[0.,0.,0.],[1.,2.,3.]]):
 initial_ages=[0,bits(.5),bits(1.),0x7fa01234][:count];initial_positions=[bits(x) for j in range(count) for x in ([0.,0.,0.] if profile==0 else [3.+j,4.,-2.])];initial_velocities=[bits(x) for j in range(count) for x in [1.,-2.+j,3.]];center=[bits(v) for v in center_values];captures=[]
 for corrected in [False,True]:
  enabled=corrected;events=[];u.mem_write(container,b'\0'*0xb0);u.mem_write(instance,b'\0'*0x160);u.mem_write(definition,b'\0'*0x200);write32(container,instance);write32(instance+4,definition);u.mem_write(definition+0x152,bytes([int(circular)]));write32(definition+0x154,direction);write32(container+0x20,ages);write32(container+0x2c,positions);write32(container+0x38,velocities)
  for j,v in enumerate(center):write32(instance+0xc4+j*4,v)
  for address,values in [(ages,initial_ages),(positions,initial_positions),(velocities,initial_velocities)]:
   for j,v in enumerate(values):write32(address+j*4,v)
  sp=stack+0x8000;u.mem_write(sp-0x100,b'\0'*0x140);u.mem_write(frame-0x100,b'\0'*0x140);write32(frame-0x10,bits(delta));write32(frame-8,count);write32(frame-0x14,container);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_EDI,container);u.reg_write(UC_X86_REG_ESI,count);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
  u.emu_start(0x944ef9,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==0x945120 and u.reg_read(UC_X86_REG_ESP)==sp and restore is None
  captures.append({'events':events.copy(),'positions':words(positions,count*3),'velocities':words(velocities,count*3),'center':words(instance+0xc4,3)})
 cases.append({'circular':circular,'direction':direction,'delta':bits(delta),'ages':initial_ages,'positions':initial_positions,'velocities':initial_velocities,'center':center,'emulator':captures[0],'cpu':captures[1]})
for address in blocks:kernel.VirtualFree(address,0,0x8000)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'range':'944EF9..945120','cases':cases,'actual_cpu_sse_operations':cpu_calls,'emulator_cpu_case_disagreements':sum(c['cpu']!=c['emulator'] for c in cases),'adapters':[],'limits':['Original policy and both actual motion bodies execute. Supplied definition152/154, centerC4/C8/CC and arrays; source names/defaults not inferred. Surrounding particle update and ordinary integration incomplete.','Selected finite movement profiles, ordered age filter includes NaN skip; zero-radius raw outputs retained. Default FP controls and zeroed caller frame.']}
(r/'data/4.20/simple_movement_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'sse':cpu_calls,'disagreements':proof['emulator_cpu_case_disagreements']}))
