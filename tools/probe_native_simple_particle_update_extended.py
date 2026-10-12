"""Whole944E20 particle update, selected concrete resources, no endpoints."""
from pathlib import Path
import json,itertools,datetime,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_simple_movement.py').read_text(encoding='utf-8').split('\ncontainer=')[0]
exec(compile(setup,'Whole particle update setup','exec'))
cpu_hook.__code__=cpu_hook.__code__.replace(co_consts=tuple(0x945863 if c==0x945120 else c for c in cpu_hook.__code__.co_consts))
container=heap+0x22000;owner=heap+0x23000;definition=heap+0x24000;stats=heap+0x24500;births=heap+0x25000;life=heap+0x25100;ages=heap+0x25200;positions=heap+0x26000;velocities=heap+0x27000;scales=heap+0x28000;factors=heap+0x28100;scalar=heap+0x28200;rates=heap+0x28300;auxiliary=heap+0x28400;attribute_a=heap+0x28500;attribute_b=heap+0x28600;heights=heap+0x28700;table=heap+0x29000;probability=heap+0x29100;times=heap+0x29200;probability_values=heap+0x29300;force=heap+0x30000
conversion_count=0
def words(a,n):return [read32(a+j*4) for j in range(n)]
def observe(uc,a,size,user):
 global conversion_count
 if a in [0x944600,0x944760,0x945620,0x944c80,0x9456e0]:events.append(hex(a))
 if enabled and 0x945120<=a<0x945466:
  ins=next(cs.disasm(bytes(u.mem_read(a,size)),a),None)
  if ins and ins.mnemonic in conversion_functions:
   dest,source=ins.operands;dr=getattr(registers,'UC_X86_REG_'+ins.reg_name(dest.reg).upper());sr=getattr(registers,'UC_X86_REG_'+ins.reg_name(source.reg).upper());value=u.reg_read(sr)&0xffffffff;converted=conversion_functions[ins.mnemonic](value);conversion_count+=1;u.reg_write(dr,(u.reg_read(dr)&~0xffffffff)|converted if ins.mnemonic=='cvtsi2ss' else converted);u.reg_write(UC_X86_REG_EIP,a+size)
u.hook_add(unicorn.UC_HOOK_CODE,observe)
identity=[bits(v) for v in [1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.]];cases=[]
for count,local,sticky,(time,last),cap,flag,scalar_enabled,circular,direction,force_enabled,probability_mode,seed in itertools.product([1,4],[0,1],[0],[(.125,0.),(.5,.25)],[.5,3.4028234663852886e38],[1],[1],[0,1],[0,1,5],[False,True],[1,2,3],[0,17]):
 birth_values=[bits(j*.125) for j in range(count)];life_values=[bits(v) for v in [1.,.5,2.,1.]][:count];initial_positions=[bits(v) for j in range(count) for v in [400.+j,500.,600.]];velocity_values=[bits(v) for j in range(count) for v in [1.,-2.,3.]];initial_scales=[bits(1.)]*count;factor_values=[bits(1.+j*.5) for j in range(count)];initial_scalar=[bits(-.5)]*count;rate_values=[bits(.25)]*count;initial_heights=[0]*count;rng=[(12345+13579*j)^seed for j in range(55)];captures=[]
 for corrected in [False,True]:
  enabled=corrected;events=[]
  for address in [container,owner,definition,stats]:u.mem_write(address,b'\0'*0x400)
  write32(container,owner);write32(owner+4,definition);write32(definition+4,stats);write32(stats+0x24,7);write32(container+4,bits(last));write32(container+0xa4,99);write32(container+0xc0,0)
  u.mem_write(definition+0x151,bytes([local]));u.mem_write(definition+0x160,bytes([sticky]));write32(definition+0x158,0);write32(definition+0x15c,bits(1.));write32(owner+0xe0,bits(1.));u.mem_write(definition+0x152,bytes([circular]));write32(definition+0x154,direction);write32(owner+0xe8,force if force_enabled else 0);u.mem_write(force,b'\0'*0x80);write32(force+0x10,1)
  for j,v in enumerate([1.,-2.,.5]):write32(force+1+j*4,bits(v))
  for base,values in [(owner+0x44,[bits(100.),bits(200.),bits(300.)]),(owner+0xc4,[bits(110.),bits(220.),bits(330.)]),(container+0xc4,[bits(100.),bits(200.),bits(300.)]),(container+0xa8,[bits(-1.),bits(-2.),bits(-3.)]),(container+0xb4,[bits(1.),bits(2.),bits(3.)])]:
   for j,v in enumerate(values):write32(base+j*4,v)
  inverse=identity.copy();current=identity.copy();inverse[12:15]=[bits(-100.),bits(-200.),bits(-300.)];current[12:15]=[bits(110.),bits(220.),bits(330.)]
  for address,values in [(owner+0x54,inverse),(owner+0x94,current)]:
   for j,v in enumerate(values):write32(address+j*4,v)
  # Owner current pose translation overlaps current_position C4/C8/CC by design.
  for offset,address,values in [(8,births,birth_values),(0x14,life,life_values),(0x20,ages,[0xcccccccc]*count),(0x2c,positions,initial_positions),(0x38,velocities,velocity_values),(0x44,scales,initial_scales),(0x50,factors,factor_values),(0x5c,scalar,initial_scalar),(0x68,rates,rate_values),(0x74,auxiliary,[0]*count),(0x80,attribute_a,[0xcccccccc]*count),(0x8c,attribute_b,[0xcccccccc]*count),(0x98,heights,initial_heights)]:
   write32(container+offset,address);write32(container+offset+4,address+len(values)*4)
   for j,v in enumerate(values):write32(address+j*4,v)
  for j,v in enumerate([1.,2.,3.]):write32(table+j*4,bits(v))
  for offset in [0x1a0,0x1b4]:write32(definition+offset,table);write32(definition+offset+4,table+12)
  u.mem_write(definition+0x1c8,bytes([scalar_enabled]));u.mem_write(probability,b'\0'*0x40)
  if probability_mode==1:u.mem_write(probability,b'\1');write32(probability+4,bits(.5))
  if probability_mode==2:u.mem_write(probability+8,b'\1');write32(probability+0xc,bits(.25));write32(probability+0x10,bits(1.5))
  if probability_mode==3:
   write32(probability+20,times);write32(probability+24,times+12);write32(probability+32,probability_values);write32(probability+36,probability_values+12)
   for j,(t,v) in enumerate([(0.,1.),(.5,.5),(1.,2.)]):write32(times+j*4,bits(t));write32(probability_values+j*4,bits(v))
  write32(definition+0x1ac,probability);write32(0x2d6ece4,0);write32(0x2d6ece8,0)
  for j,v in enumerate(rng):write32(0x2d6ec08+j*4,v)
  write32(definition+0x1c0,probability);write32(definition+0x1ec,bits(1.));write32(definition+0x1f0,bits(2.))
  sp=stack+0x8000;u.mem_write(sp-0x100,b'\0'*0x140);write32(sp,end);write32(sp+4,bits(time));write32(sp+8,bits(cap));write32(sp+12,flag);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,container);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
  u.emu_start(0x944e20,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==sp+16 and restore is None
  captures.append({'life':words(life,count),'ages':words(ages,count),'positions':words(positions,count*3),'velocities':words(velocities,count*3),'scales':words(scales,count),'scalar':words(scalar,count),'attribute_a':words(attribute_a,count),'attribute_b':words(attribute_b,count),'last_time':read32(container+4),'active':read32(container+0xa4),'counter':read32(stats+0x24),'minimum':words(container+0xa8,3),'maximum':words(container+0xb4,3),'center':words(container+0xc4,3),'bounds_last':read32(container+0xc0),'rng':words(0x2d6ec08,55),'first':read32(0x2d6ece4),'second':read32(0x2d6ece8),'events':events.copy()})
 cases.append({'circular':circular,'direction':direction,'force_enabled':force_enabled,'probability_mode':probability_mode,'rng':rng,'local':local,'sticky':sticky,'time':bits(time),'last':bits(last),'cap':bits(cap),'flag':flag,'scalar_enabled':scalar_enabled,'birth':birth_values,'life':life_values,'positions':initial_positions,'velocities':velocity_values,'factors':factor_values,'emulator':captures[0],'cpu':captures[1]})
for address in blocks:kernel.VirtualFree(address,0,0x8000)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'entry':'944E20','cases':cases,'actual_cpu_sse_operations':cpu_calls,'actual_cpu_conversion_operations':conversion_count,'emulator_cpu_case_disagreements':sum(c['cpu']!=c['emulator'] for c in cases),'adapters':[],'limits':['Whole particle update and actual attachment, linear movement, scalar/probability/attribute, bounds and tail bodies execute. Explicit preallocated arrays, poses and resources. Selected null/uniform force resource, linear/circular motion with three directions, shared constant/fast/generic probability and explicit55-word RNG state. Terrain disabled; broader concrete resources and ordinary integration incomplete.','No resource producers or ordinary rendered gameplay acceptance. Finite selected matrices; actual hardware scalar SSE/conversions, default FP mode.']}
(r/'data/4.20/simple_particle_update_extended_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'sse':cpu_calls,'conversions':conversion_count,'disagreements':proof['emulator_cpu_case_disagreements']}))
