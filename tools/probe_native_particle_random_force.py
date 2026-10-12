"""Whole93C450 random force including original RNG and norm, no endpoints."""
from pathlib import Path
import json,struct,itertools,datetime,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_particle_force_body.py').read_text(encoding='utf-8').split('\nforce=')[0]
exec(compile(setup,'random force native setup','exec'))
cpu_hook.__code__=cpu_hook.__code__.replace(co_consts=tuple(0x93c6f9 if c==0x93c122 else c for c in cpu_hook.__code__.co_consts))
force=heap+0x22000;position=heap+0x23000;velocity=heap+0x24000
def words(a,n):return [read32(a+j*4) for j in range(n)]
cases=[]
for count,radius,pos_index,seed,strength,scales in itertools.product([0,1,2,5],[0.,1.,5.],range(4),[0,17,0xffffffff],[0.,.5,2.],[[1.,1.,1.],[.5,-1.,2.]]):
 pos=[bits(x) for x in [[0.,0.,0.],[1.,0.,0.],[3.,4.,0.],[0.,0.,6.]][pos_index]];vel=[bits(x) for x in [1.,-2.,3.]];center=[0,0,0];rng=[(12345+13579*j)^seed for j in range(55)];captures=[]
 for corrected in [False,True]:
  enabled=corrected;u.mem_write(force,b'\0'*0x50);write32(force+0x40,count);write32(force+0x20,bits(radius));write32(force+0x2c,bits(strength))
  for j in range(3):write32(force+0x10+j*4,center[j]);write32(force+0x30+j*4,bits(scales[j]));write32(position+j*4,pos[j]);write32(velocity+j*4,vel[j])
  write32(0x2d6ece4,0);write32(0x2d6ece8,0)
  for j,v in enumerate(rng):write32(0x2d6ec08+j*4,v)
  sp=stack+0x8000;u.mem_write(sp-0x100,b'\0'*0x140);write32(sp,end);write32(sp+4,position);write32(sp+8,velocity);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,force);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
  u.emu_start(0x93c450,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==sp+12 and restore is None
  captures.append({'position':words(position,3),'velocity':words(velocity,3),'rng':words(0x2d6ec08,55),'first':read32(0x2d6ece4),'second':read32(0x2d6ece8)})
 cases.append({'count':count,'radius':bits(radius),'position':pos,'velocity':vel,'center':center,'strength':bits(strength),'scales':[bits(x) for x in scales],'rng':rng,'emulator':captures[0],'cpu':captures[1]})
constants={hex(a):read32(a) for a in [0x113898c,0x1138df8,0x1139280]}
for address in blocks:kernel.VirtualFree(address,0,0x8000)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'entry':'93C450','cases':cases,'constants':constants,'actual_cpu_sse_operations':cpu_calls,'emulator_cpu_case_disagreements':sum(c['cpu']!=c['emulator'] for c in cases),'adapters':[],'limits':['Explicit raw force fields and RNG words/cursors supplied; original x87 random direction and norm bodies execute. Selected finite profiles only. Owner construction and ordinary renderer integration unqualified.','Reference uses actual CPU SSE/RSQRTSS and default FP mode.']}
(r/'data/4.20/particle_random_force_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'sse':cpu_calls,'disagreements':proof['emulator_cpu_case_disagreements'],'constants':constants}))
