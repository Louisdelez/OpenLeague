"""942C90..942D9E/942E21: angle gate and real probability/RNG, before matrices."""
from pathlib import Path
import json,struct,itertools,datetime,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_simple_movement.py').read_text(encoding='utf-8').split('\ncontainer=')[0]
exec(compile(setup,'rotation gate native setup','exec'))
instance=heap+0x22000;definition=heap+0x23000;angles=heap+0x24000;descriptors=heap+0x25000;descriptor=heap+0x26000;prob=heap+0x27000;frame=stack+0x4000
def words(a,n):return [read32(a+j*4) for j in range(n)]
def gate_stop(uc,a,size,user):
 if a in [0x942d9e,0x942e21]:u.emu_stop()
u.hook_add(unicorn.UC_HOOK_CODE,gate_stop)
epsilon=read32(0x11389a0);assert epsilon==0x358637bd
angle_bits=[0,0x80000000,epsilon-1,epsilon,epsilon+1,(epsilon-1)|0x80000000,epsilon|0x80000000,(epsilon+1)|0x80000000,bits(1.),bits(-90.),bits(180.),bits(.000002)]
cases=[]
for angle,mode,seed in itertools.product(angle_bits,range(5),[0,17,0xffffffff]):
 rng=[((12345+13579*j)^seed)&0xffffffff for j in range(55)];captures=[]
 for corrected in [False,True]:
  enabled=corrected;u.mem_write(instance,b'\0'*0x160);u.mem_write(definition,b'\0'*0x420);u.mem_write(descriptor,b'\0'*0x20);u.mem_write(prob,b'\0'*0x100)
  write32(instance+4,definition);write32(definition+0x138,descriptors);write32(descriptors,descriptor);write32(descriptor+0xc,prob if mode else 0);write32(angles,angle)
  u.mem_write(prob,bytes([mode in [1,2]]));write32(prob+4,bits(.5 if mode==1 else 0.));u.mem_write(prob+8,bytes([mode==3]));write32(prob+0xc,bits(.25));write32(prob+0x10,bits(1.5))
  times=prob+0x80;probability_values=prob+0xc0;write32(prob+0x14,times);write32(prob+0x18,times+12);write32(prob+0x20,probability_values);write32(prob+0x24,probability_values+12)
  for j,(t,v) in enumerate(zip([0.,.5,1.],[1.,.5,2.])):write32(times+j*4,bits(t));write32(probability_values+j*4,bits(v))
  write32(0x2d6ece4,0);write32(0x2d6ece8,0)
  for j,v in enumerate(rng):write32(0x2d6ec08+j*4,v)
  sp=stack+0x8000;u.mem_write(sp-0x400,b'\0'*0x440);u.mem_write(frame-0x300,b'\0'*0x340);write32(frame-0x64,1);write32(frame-0x94,angles);u.mem_write(frame-0x1d,b'\1')
  for reg,value in [(UC_X86_REG_ESP,sp),(UC_X86_REG_EBP,frame),(UC_X86_REG_EBX,instance),(UC_X86_REG_EDI,angles),(UC_X86_REG_ECX,0),(UC_X86_REG_EDX,0),(UC_X86_REG_ESI,1),(UC_X86_REG_EAX,1),(UC_X86_REG_XMM3,epsilon),(UC_X86_REG_FPCW,0x37f),(UC_X86_REG_FPTAG,0xffff),(UC_X86_REG_MXCSR,0x1f80)]:u.reg_write(reg,value)
  u.emu_start(0x942c90,end,count=10000);stop=u.reg_read(UC_X86_REG_EIP);assert stop in [0x942d9e,0x942e21] and restore is None
  captures.append(dict(angle=read32(frame-0x4c),matrix_needed=stop==0x942d9e,rng=words(0x2d6ec08,55),first=read32(0x2d6ece4),second=read32(0x2d6ece8)))
 cases.append(dict(angle=angle,mode=mode,rng=rng,emulator=captures[0],cpu=captures[1]))
for address in blocks:kernel.VirtualFree(address,0,0x8000)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,range='942C90..942D9E/942E21',cases=cases,epsilon_bits=epsilon,actual_cpu_sse_operations=cpu_calls,emulator_cpu_case_disagreements=sum(c['cpu']!=c['emulator'] for c in cases),adapters=[],findings=['Inclusive authored near-zero gate skips probability and RNG entirely; second inclusive near-zero gate follows probability.'],limits=['Single supplied descriptor, selected finite angle boundaries and five probability modes; stops before matrix construction. List sampling/allocation, matrix composition and rendered integration remain incomplete.'])
assert proof['emulator_cpu_case_disagreements']==0
(r/'data/4.20/simple_rotation_gate_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(cases),sse=cpu_calls,disagreements=proof['emulator_cpu_case_disagreements'])))
