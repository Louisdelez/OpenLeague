"""Original944E20..944EDD age/count producer, no particle loop formula adapter."""
from pathlib import Path
import json,struct,itertools,datetime,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_simple_frame.py').read_text(encoding='utf-8').split('\nhelper=')[0]
exec(compile(setup,'native Simple particle age setup','exec'))
cpu_hook.__code__=cpu_hook.__code__.replace(co_consts=tuple(0x944e20 if c==0x9437e0 else 0x944edd if c==0x943b58 else c for c in cpu_hook.__code__.co_consts))
container=heap+0x22000;births=heap+0x23000;lifetimes=heap+0x24000;ages=heap+0x25000
def stop_hook(uc,a,size,user):
 if a in [0x944edd,0x9455ef]:u.emu_stop()
u.hook_add(unicorn.UC_HOOK_CODE,stop_hook)
profiles=[0,0x80000000,1,bits(.25),bits(1.),0xff7fffff,0x7f800000,0x7fa01234]
life_profiles=[bits(2.),bits(.5),0,0x80000000,0xbf800000,0x7f800000,0x7fa05678]
cases=[]
for index,(time,last,cap,count) in enumerate(itertools.product(profiles,profiles,profiles,[0,1,3,7])):
 birth=[profiles[(index+j)%len(profiles)] for j in range(count)];life=[life_profiles[(index+j)%len(life_profiles)] for j in range(count)];captures=[]
 for corrected in [False,True]:
  enabled=corrected;u.mem_write(container,b'\0'*0xb0);write32(container+4,last);write32(container+8,births);write32(container+0xc,births+count*4);write32(container+0x14,lifetimes);write32(container+0x20,ages);write32(container+0xa4,99)
  for j in range(count):write32(births+j*4,birth[j]);write32(lifetimes+j*4,life[j]);write32(ages+j*4,0xcccccccc)
  sp=stack+0x8000;u.mem_write(sp-0x100,b'\0'*0x140);write32(sp,end);write32(sp+4,time);write32(sp+8,cap);write32(sp+12,1);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,container);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
  u.emu_start(0x944e20,end,count=10000);assert u.reg_read(UC_X86_REG_EIP) in [0x944edd,0x9455ef] and restore is None
  captures.append({'processed':u.reg_read(UC_X86_REG_EIP)==0x944edd,'last_time':read32(container+4),'active':read32(container+0xa4),'life':[read32(lifetimes+j*4) for j in range(count)],'ages':[read32(ages+j*4) for j in range(count)]})
 cases.append({'time':time,'last_time':last,'cap':cap,'birth':birth,'life':life,'emulator':captures[0],'cpu':captures[1]})
for address in blocks:kernel.VirtualFree(address,0,0x8000)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'range':'944E20..944EDD','cases':cases,'actual_cpu_sse_operations':cpu_calls,'emulator_cpu_case_disagreements':sum(c['cpu']!=c['emulator'] for c in cases),'threshold_bits':read32(0x11389d8),'adapters':[],'limits':['Stops before attachment/local-orientation and curve/position producers. Explicit preallocated arrays and initial active99 supplied. Not complete944E20 or game integration.','Default FP controls; finite/subnormal/infinite/signaling NaN profiles with0/1/3/7particles.']}
(r/'data/4.20/simple_particle_age_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'sse':cpu_calls,'disagreements':proof['emulator_cpu_case_disagreements'],'threshold':proof['threshold_bits']}))
