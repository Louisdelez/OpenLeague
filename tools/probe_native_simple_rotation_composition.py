"""942C5D..942E21/943036: list gates, probabilities and actual matrix composition."""
from pathlib import Path
import json,struct,itertools,datetime,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_simple_movement.py').read_text(encoding='utf-8').split('\ncontainer=')[0]
exec(compile(setup,'rotation composition native setup','exec'))
instance=heap+0x22000;definition=heap+0x23000;angles=heap+0x24000;descriptors=heap+0x25000;axes=heap+0x26000;prob=heap+0x27000;frame=stack+0x4000
def words(a,n):return [read32(a+j*4) for j in range(n)]
def stop_composition(uc,a,size,user):
 if a in [0x942e21,0x943036]:u.emu_stop()
u.hook_add(unicorn.UC_HOOK_CODE,stop_composition)
identity=[bits(1.) if i in [0,5,10,15] else 0 for i in range(16)]
lists=[[],[0.],[90.],[90.,-45.,30.],[.000001,180.,-360.]];cases=[]
for angle_values,profile,mode,seed in itertools.product(lists,range(2),range(5),[0,17]):
 axis_values=([[1.,0.,0.],[0.,1.,0.],[0.,0.,1.]] if profile==0 else [[.5,-.25,2.],[0.,0.,0.],[1.,1.,1.]])[:len(angle_values)]
 rng=[((12345+13579*j)^seed)&0xffffffff for j in range(55)];captures=[]
 for corrected in [False,True]:
  enabled=corrected;u.mem_write(instance,b'\0'*0x160);u.mem_write(definition,b'\0'*0x420);u.mem_write(prob,b'\0'*0x100)
  write32(instance+4,definition);write32(definition+0x138,descriptors);write32(definition+0x144,axes)
  u.mem_write(prob,bytes([mode in [1,2]]));write32(prob+4,bits(.5 if mode==1 else 0.));u.mem_write(prob+8,bytes([mode==3]));write32(prob+0xc,bits(.25));write32(prob+0x10,bits(1.5))
  times=prob+0x80;probability_values=prob+0xc0;write32(prob+0x14,times);write32(prob+0x18,times+12);write32(prob+0x20,probability_values);write32(prob+0x24,probability_values+12)
  for j,(t,v) in enumerate(zip([0.,.5,1.],[1.,.5,2.])):write32(times+j*4,bits(t));write32(probability_values+j*4,bits(v))
  for i,value in enumerate(angle_values):
   descriptor=heap+0x28000+i*0x40;write32(descriptors+i*4,descriptor);write32(descriptor+0xc,prob if mode else 0);write32(angles+i*4,bits(value))
   for j,v in enumerate(axis_values[i]):write32(axes+i*12+j*4,bits(v))
  write32(0x2d6ece4,0);write32(0x2d6ece8,0)
  for j,v in enumerate(rng):write32(0x2d6ec08+j*4,v)
  sp=stack+0x8000;u.mem_write(sp-0x600,b'\0'*0x640);u.mem_write(frame-0x300,b'\0'*0x340);write32(frame-0x64,len(angle_values));write32(frame-0x94,angles)
  for j,v in enumerate(identity):write32(frame-0x178+j*4,v)
  for reg,value in [(UC_X86_REG_ESP,sp),(UC_X86_REG_EBP,frame),(UC_X86_REG_EBX,instance),(UC_X86_REG_FPCW,0x37f),(UC_X86_REG_FPTAG,0xffff),(UC_X86_REG_MXCSR,0x1f80)]:u.reg_write(reg,value)
  u.emu_start(0x942c5d,end,count=100000);assert u.reg_read(UC_X86_REG_EIP) in [0x942e21,0x943036] and restore is None
  captures.append(dict(matrix=words(frame-0x178,16),unchanged=bool(u.mem_read(frame-0x1d,1)[0]),rng=words(0x2d6ec08,55),first=read32(0x2d6ece4),second=read32(0x2d6ece8)))
 cases.append(dict(angles=[bits(v) for v in angle_values],axes=[[bits(v) for v in a] for a in axis_values],mode=mode,rng=rng,emulator=captures[0],cpu=captures[1]))
for address in blocks:kernel.VirtualFree(address,0,0x8000)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,range='942C5D..942E21/943036',cases=cases,actual_cpu_sse_operations=cpu_calls,emulator_cpu_case_disagreements=sum(c['cpu']!=c['emulator'] for c in cases),adapters=[],limits=['Pre-sampled lists and initial identity matrix supplied; real element gates, shared probabilities/RNG, degree conversion, whole axis-angle and8DF790 composition execute. SSE host reference, x87 emulator.','Raw list sampling/allocator, final position/velocity transforms and ordinary graphics integration incomplete.'])
assert proof['emulator_cpu_case_disagreements']==0
(r/'data/4.20/simple_rotation_composition_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(cases),sse=cpu_calls,disagreements=proof['emulator_cpu_case_disagreements'])))
