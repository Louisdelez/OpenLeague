"""Whole941F00 emission rate sampling, pre-sampling gates and shared birth RNG."""
from pathlib import Path
import json,itertools,datetime,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_simple_birth_vectors.py').read_text(encoding='utf-8').split('\ncaptures=[]')[0]
exec(compile(setup,'rate source native setup','exec'))
old=next(x for x in body.splitlines() if x.startswith('for single,'))
body=body.replace(old,'for single,progress,profile,mode,gate in itertools.product([0,1],[-.5,0.,.5,1.],[0,1],range(4),range(5)):')
marker=' sp=stack+0x8000;'
extra='''
 rate_table=[0.,1.,4.,-2.];rate_factor=[.5,2.][profile]
 a=read32(definition+0x74);write32(definition+0x78,a+16);write32(definition+0x7c,a+16)
 for j,value in enumerate(rate_table):f(a+j*4,value)
 probability_address=heap+0x60000;u.mem_write(probability_address,b'\\0'*0x100);write32(definition+0x80,probability_address if mode else 0)
 u.mem_write(probability_address,bytes([mode==1]));f(probability_address+4,.5);u.mem_write(probability_address+8,bytes([mode==2]));f(probability_address+0xc,.25);f(probability_address+0x10,1.5)
 times=probability_address+0x80;probability_values=probability_address+0xc0
 write32(probability_address+0x14,times);write32(probability_address+0x18,times+12);write32(probability_address+0x20,probability_values);write32(probability_address+0x24,probability_values+12)
 for j,(t,value) in enumerate(zip([0.,.5,1.],[1.,.5,2.])):f(times+j*4,t);f(probability_values+j*4,value)
 f(context+0xec,rate_factor)
 if gate==1:latch=1;u.mem_write(instance+0xd4,b'\\1')
 if gate==2:f(instance+0x10,.125)
 if gate==3:f(definition+0x164,1.)
 if gate==4:f(definition+0x174,0.)
'''
assert marker in body;body=body.replace(marker,extra+marker)
body+='\n cases[-1].update(rate_table=rate_table,rate_factor=rate_factor,gate=gate)\n'
captures=[]
for corrected in [False,True]:
 enabled=corrected;exec(compile(body,'whole rate source and birth stream','exec'));captures.append(cases);u.hook_del(birth_observer)
rows=[dict(emulator=a,cpu=b) for a,b in zip(*captures)];assert len(rows)==320
for a in blocks:kernel.VirtualFree(a,0,0x8000)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='941F00',cases=rows,actual_cpu_sse_operations=cpu_calls,emulator_cpu_case_disagreements=sum(c['cpu']!=c['emulator'] for c in rows),adapters=[],limits=['Actual941F00 samples948EE0 rate with null/constant/fast/generic probability and context scale, before shared scalar/vector birth draws. Whole arrays/emitter/full RNG captured, negative/zero rates, single/latch/life/delay/window gates.','Rate attribute3A4 absent, as are other attribute and rotation-list branches. Identity pose, supplied tables/context/preallocated memory; resource binding and ordinary rendering/audio incomplete.'])
assert proof['emulator_cpu_case_disagreements']==0
(r/'data/4.20/simple_rate_source_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(rows),sse=cpu_calls,disagreements=proof['emulator_cpu_case_disagreements'])))
