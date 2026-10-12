"""Whole943CD0 append/reuse, scale probabilities and initial terrain height."""
from pathlib import Path
import json,struct,itertools,datetime,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_simple_movement.py').read_text(encoding='utf-8').split('\ncontainer=')[0]
exec(compile(setup,'Simple insertion native setup','exec'))
container=heap+0x22000;owner=heap+0x23000;definition=heap+0x24000;root=heap+0x28000;provider=heap+0x29000;vtable=heap+0x2a000;stub=heap+0x2b000;response=heap+0x2c000;position=heap+0x25000;velocity=heap+0x26000;table=heap+0x40000;probability=heap+0x41000;times=heap+0x42000;probability_values=heap+0x43000
u.mem_write(stub,b'\xd9\x05'+struct.pack('<I',response)+b'\xc2\x0c\x00')
def words(a,n):return [read32(a+j*4) for j in range(n)]
def observe(uc,a,size,user):
 if a==stub:
  sp=u.reg_read(UC_X86_REG_ESP);events.append(dict(arguments=words(sp+4,3),height=bits(2.)));write32(response,bits(2.))
u.hook_add(unicorn.UC_HOOK_CODE,observe)
profiles=[[],[0,bits(.5),bits(.9)],[bits(1.),bits(.5),bits(2.)],[bits(.5),bits(1.),bits(2.)],[0x7fa01234,bits(.5),bits(1.)]]
cases=[]
for age_values,mode,factor,terrain in itertools.product(profiles,range(4),[.5,-2.],[0,1]):
 count=len(age_values);captures=[];initial={}
 for corrected in [False,True]:
  enabled=corrected;events=[]
  for a in [container,owner,definition,root,provider,vtable,probability]:u.mem_write(a,b'\0'*0x410)
  write32(container,owner);write32(owner+4,definition);write32(container+0xd0,root);write32(root+8,provider);write32(provider,vtable);write32(vtable+0x58,stub);u.mem_write(definition+0x161,bytes([terrain]))
  write32(definition+0x1a0,table);write32(definition+0x1a4,table+12);write32(definition+0x1ac,probability if mode else 0)
  for j,v in enumerate([1.,2.,3.]):write32(table+j*4,bits(v))
  u.mem_write(probability,bytes([mode==1]));write32(probability+4,bits(.5));u.mem_write(probability+8,bytes([mode==2]));write32(probability+0xc,bits(.25));write32(probability+0x10,bits(1.5))
  #91B770 native vector descriptors at14/20.
  write32(probability+0x14,times);write32(probability+0x18,times+12);write32(probability+0x20,probability_values);write32(probability+0x24,probability_values+12)
  for j,(t,v) in enumerate(zip([0.,.5,1.],[1.,.5,2.])):write32(times+j*4,bits(t));write32(probability_values+j*4,bits(v))
  for j,off in enumerate(range(8,0x99,12)):
   a=heap+0x30000+j*0x100;length=count*(3 if off in [0x2c,0x38] else 1);data=age_values if off==0x20 else [bits(-9.)]*length
   write32(container+off,a);write32(container+off+4,a+length*4);write32(container+off+8,a+0x100)
   for k,v in enumerate(data):write32(a+k*4,v)
   initial[hex(off)]=data.copy()
  for j,v in enumerate([3.,4.,5.]):write32(position+j*4,bits(v))
  for j,v in enumerate([.25,-.5,1.]):write32(velocity+j*4,bits(v))
  write32(0x2d6ece4,0);write32(0x2d6ece8,0)
  for j in range(55):write32(0x2d6ec08+j*4,12345+j*13579)
  sp=stack+0x8000;write32(sp,end)
  args=[bits(10.125),bits(2.),position,velocity,bits(-.5),bits(500.),bits(factor),bits(.125)]
  for j,v in enumerate(args):write32(sp+4+j*4,v)
  u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,container);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
  u.emu_start(0x943cd0,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==sp+36 and restore is None
  captures.append(dict(arrays={hex(off):words(read32(container+off),(read32(container+off+4)-read32(container+off))//4) for off in range(8,0x99,12)},rng=words(0x2d6ec08,55),first=read32(0x2d6ece4),second=read32(0x2d6ece8),events=events.copy()))
 cases.append(dict(initial=initial.copy(),mode=mode,factor=bits(factor),terrain=terrain,emulator=captures[0],cpu=captures[1]))
for a in blocks:kernel.VirtualFree(a,0,0x8000)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='943CD0',cases=cases,actual_cpu_sse_operations=cpu_calls,emulator_cpu_case_disagreements=sum(c['cpu']!=c['emulator'] for c in cases),adapters=['Virtual height provider58 captures X/Z/Y and returns supplied height2 through actual FLD/RET12 stub. Real height provider unqualified.'],limits=['Actual whole insertion with preallocated finite storage, expired/NaN age filters, null/constant/fast/generic probability and terrain enabled/disabled. Source emission samplers and allocation unqualified.'])
(r/'data/4.20/simple_birth_insert_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(cases),sse=cpu_calls,disagreements=proof['emulator_cpu_case_disagreements'])))
