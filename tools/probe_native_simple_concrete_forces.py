"""Whole945620 through all concrete force bodies, multiple active particles."""
from pathlib import Path
import json,struct,itertools,datetime,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_particle_force_graph.py').read_text(encoding='utf-8').split('\nforce=')[0]
exec(compile(setup,'concrete Simple forces native setup','exec'))
cpu_hook.__code__=cpu_hook.__code__.replace(co_consts=tuple(0x9456d7 if c==0x93cbc1 else c for c in cpu_hook.__code__.co_consts))
container=heap+0x22000;owner=heap+0x23000;force=heap+0x24000;positions=heap+0x25000;velocities=heap+0x26000;ages=heap+0x27000;births=heap+0x28000
point=heap+0x29000;damping=heap+0x2a000;random_force=heap+0x2b000;axis_force=heap+0x2c000
def words(a,n):return [read32(a+j*4) for j in range(n)]
def observe(uc,a,size,user):
 if a in [0x93bdd0,0x93c450,0x93c900]:
  sp=u.reg_read(UC_X86_REG_ESP);p=read32(sp+8) if a==0x93bdd0 else read32(sp+4);v=read32(sp+12) if a==0x93bdd0 else read32(sp+8)
  index=(p-positions)//12;assert v==velocities+index*12
  events.append({'kind':hex(a),'index':index,'resource':u.reg_read(UC_X86_REG_ECX)-heap,'delta':read32(sp+4) if a==0x93bdd0 else None,'position':words(p,3),'velocity':words(v,3),'parameters':words(read32(sp+(16 if a==0x93bdd0 else 12)),3) if a!=0x93c450 else None})
u.hook_add(unicorn.UC_HOOK_CODE,observe)
cases=[]
for present,time,last,count,profile in itertools.product([False,True],[0.,.25,1.,2.],[0.,.25,.5],[0,1,4],range(2)):
 initial_ages=[0,bits(1.5),bits(.5),0x7fa01234][:count];initial_positions=[bits(x) for j in range(count) for x in ([0.,0.,0.] if profile==0 else [3.+j,4.,-2.])];initial_velocities=[bits(x) for j in range(count) for x in [1.,-2.+j,3.]];parameters=[bits(1.),bits(2.),bits(3.)];captures=[]
 for corrected in [False,True]:
  enabled=corrected;events=[];u.mem_write(container,b'\0'*0xb0);u.mem_write(owner,b'\0'*0x160);u.mem_write(force,b'\0'*0x80);write32(container,owner);write32(owner+0xe8,force if present else 0);write32(container+4,bits(last));write32(container+8,births);write32(container+0xc,births+count*4);write32(container+0x20,ages);write32(container+0x2c,positions);write32(container+0x38,velocities)
  for j,v in enumerate(parameters):write32(owner+0xc4+j*4,v)
  for address,values in [(ages,initial_ages),(positions,initial_positions),(velocities,initial_velocities)]:
   for j,v in enumerate(values):write32(address+j*4,v)
  write32(force+0x10,1)
  for j,v in enumerate([1.,-2.,.5]):write32(force+1+j*4,bits(v))
  for n,(offset,obj) in enumerate([(0x1c,point),(0x28,damping),(0x34,random_force),(0x40,axis_force)]):
   lst=heap+0x30000+n*0x100;write32(force+offset,lst);write32(force+offset+4,lst+4);write32(lst,obj);u.mem_write(obj,b'\0'*0x50)
  write32(point+0x20,bits(1.));write32(point+0x28,bits(5.));write32(damping+0x20,bits(.5));write32(damping+0x28,bits(5.))
  write32(random_force+0x40,2);write32(random_force+0x20,bits(5.));write32(random_force+0x2c,bits(.25))
  for j,v in enumerate([.5,1.,2.]):write32(random_force+0x30+j*4,bits(v))
  write32(axis_force+0x14,bits(1.));write32(0x2d6ece4,0);write32(0x2d6ece8,0)
  for j in range(55):write32(0x2d6ec08+j*4,12345+13579*j)
  sp=stack+0x8000;u.mem_write(sp-0x100,b'\0'*0x140);write32(sp,end);write32(sp+4,bits(time));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,container);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
  u.emu_start(0x945620,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==sp+8 and restore is None
  captures.append({'events':events.copy(),'positions':words(positions,count*3),'velocities':words(velocities,count*3),'parameters':words(owner+0xc4,3),'last_time':read32(container+4),'rng':words(0x2d6ec08,55),'first':read32(0x2d6ece4),'second':read32(0x2d6ece8)})
 cases.append({'present':present,'time':bits(time),'last_time':bits(last),'ages':initial_ages,'positions':initial_positions,'velocities':initial_velocities,'parameters':parameters,'emulator':captures[0],'cpu':captures[1]})
for address in blocks:kernel.VirtualFree(address,0,0x8000)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'entry':'945620','cases':cases,'actual_cpu_sse_operations':cpu_calls,'emulator_cpu_case_disagreements':sum(c['cpu']!=c['emulator'] for c in cases),'adapters':[],'limits':['Original dispatch and all force/norm/RNG bodies execute without endpoints. Explicit preallocated arrays and force resource fields supplied. Construction and ordinary renderer integration unqualified.','Selected finite time/force profiles; signaling NaN particle age skips via native ordered comparison. Default FP controls.']}
(r/'data/4.20/simple_concrete_forces_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'sse':cpu_calls,'disagreements':proof['emulator_cpu_case_disagreements']}))
