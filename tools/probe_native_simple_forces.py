"""Whole945620 active-particle force dispatch;93BDD0 is an explicit endpoint."""
from pathlib import Path
import json,struct,itertools,datetime,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_simple_particle_age.py').read_text(encoding='utf-8').split('\ncontainer=')[0]
exec(compile(setup,'Simple force dispatcher setup','exec'))
cpu_hook.__code__=cpu_hook.__code__.replace(co_consts=tuple(0x945620 if c==0x944e20 else 0x9456d7 if c==0x944edd else c for c in cpu_hook.__code__.co_consts))
container=heap+0x22000;owner=heap+0x23000;resource=heap+0x24000;births=heap+0x25000;ages=heap+0x26000;positions=heap+0x27000;velocities=heap+0x28000
def words(address,n):return [read32(address+j*4) for j in range(n)]
def force_hook(uc,a,size,user):
 if a==0x93bdd0:
  sp=u.reg_read(UC_X86_REG_ESP);position=read32(sp+8);velocity=read32(sp+12);parameters=read32(sp+16);assert u.reg_read(UC_X86_REG_ECX)==resource
  index=(position-positions)//12;assert velocity==velocities+index*12
  events.append({'index':index,'delta':read32(sp+4),'position':words(position,3),'velocity':words(velocity,3),'parameters':words(parameters,3)})
  for j in range(3):write32(position+j*4,0x3f800000+index*3+j);write32(velocity+j*4,0x40000000+index*3+j)
  finish(pop=16)
u.hook_add(unicorn.UC_HOOK_CODE,force_hook)
profiles=[0,0x80000000,1,bits(.25),bits(1.),0xff7fffff,0x7f800000,0x7fa01234]
age_profiles=[0,bits(.5),bits(1.),bits(2.),0x7fa05678,0xff800000]
cases=[]
for index,(present,time,last,count) in enumerate(itertools.product([False,True],profiles,profiles,[0,1,4])):
 initial_ages=[age_profiles[(index+j)%len(age_profiles)] for j in range(count)];initial_positions=[0x3e800000+j for j in range(count*3)];initial_velocities=[0xbf800000+j for j in range(count*3)];parameters=[0x3f800000,0x7fa05678,0x80000000];captures=[]
 for corrected in [False,True]:
  enabled=corrected;events=[];u.mem_write(container,b'\0'*0xb0);u.mem_write(owner,b'\0'*0x160);write32(container,owner);write32(owner+0xe8,resource if present else 0);write32(container+4,last);write32(container+8,births);write32(container+0xc,births+count*4);write32(container+0x20,ages);write32(container+0x2c,positions);write32(container+0x38,velocities)
  for j,v in enumerate(parameters):write32(owner+0xc4+j*4,v)
  for address,values in [(ages,initial_ages),(positions,initial_positions),(velocities,initial_velocities)]:
   for j,v in enumerate(values):write32(address+j*4,v)
  sp=stack+0x8000;u.mem_write(sp-0x100,b'\0'*0x140);write32(sp,end);write32(sp+4,time);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,container);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
  u.emu_start(0x945620,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==sp+8 and restore is None
  captures.append({'events':events.copy(),'positions':words(positions,count*3),'velocities':words(velocities,count*3),'owner_parameters':words(owner+0xc4,3),'last_time':read32(container+4)})
 cases.append({'present':present,'time':time,'last_time':last,'ages':initial_ages,'positions':initial_positions,'velocities':initial_velocities,'parameters':parameters,'emulator':captures[0],'cpu':captures[1]})
for address in blocks:kernel.VirtualFree(address,0,0x8000)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'entry':'945620','cases':cases,'actual_cpu_sse_operations':cpu_calls,'emulator_cpu_case_disagreements':sum(c['cpu']!=c['emulator'] for c in cases),'adapters':['93BDD0 captured as force endpoint, mutates position/velocity with known raw words to verify array strides and write propagation.'],'limits':['Concrete93BDD0 forces, attractors and other child force bodies remain unqualified. OwnerE8 resource and C4/C8/CC raw parameters explicitly supplied; names/producers not inferred.','No ordinary rendered integration or final game acceptance. Default FP controls and zeroed stack.']}
(r/'data/4.20/simple_forces_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'sse':cpu_calls,'disagreements':proof['emulator_cpu_case_disagreements']}))
