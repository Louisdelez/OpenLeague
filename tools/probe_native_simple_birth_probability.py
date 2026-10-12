"""Whole941F00 variable scalar tables with native per-birth probability draws."""
from pathlib import Path
import json,itertools,datetime,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_simple_birth_parameters.py').read_text(encoding='utf-8').split('\ncaptures=[]')[0]
exec(compile(setup,'per-birth probability native setup','exec'))
body=body.replace('for single,progress,profile in itertools.product([0,1],[-.5,0.,.1,.249,.25,.5,.75,.999,1.,2.],[0,1]):','for single,progress,profile,mode in itertools.product([0,1],[-.5,0.,.1,.249,.25,.5,.75,.999,1.,2.],[0,1],range(4)):')
marker=' sp=stack+0x8000;'
extra='''
 for off in authored:
  a=read32(definition+off+0xc)
  write32(definition+off+0xc,a if mode else 0)
  u.mem_write(a,bytes([mode==1]));f(a+4,7.);u.mem_write(a+8,bytes([mode==2]));f(a+0xc,.25);f(a+0x10,1.5)
  times=a+0x80;probability_values=a+0xc0
  write32(a+0x14,times);write32(a+0x18,times+12);write32(a+0x20,probability_values);write32(a+0x24,probability_values+12)
  for j,(t,value) in enumerate(zip([0.,.5,1.],[1.,.5,2.])):f(times+j*4,t);f(probability_values+j*4,value)
'''
assert marker in body;body=body.replace(marker,extra+marker)
body+='\n cases[-1]["mode"]=mode\n'
captures=[]
for corrected in [False,True]:
 enabled=corrected;exec(compile(body,'native scalar birth probability ordering','exec'));captures.append(cases);u.hook_del(birth_observer)
rows=[dict(emulator=a,cpu=b) for a,b in zip(*captures)];assert len(rows)==160
for a in blocks:kernel.VirtualFree(a,0,0x8000)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='941F00',cases=rows,actual_cpu_sse_operations=cpu_calls,emulator_cpu_case_disagreements=sum(c['cpu']!=c['emulator'] for c in rows),adapters=[],limits=['Actual whole emission; variable scalar tables, null/constant/fast/generic probabilities applied per birth. Native probability/RNG/insertion bodies run without endpoint adapters.','Constant rate and vector tables, no attributes/rotation list, identity pose and preallocated storage. Dynamic vector/attribute order, memory backend and ordinary rendering/audio remain incomplete.'])
assert proof['emulator_cpu_case_disagreements']==0
(r/'data/4.20/simple_birth_probability_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(rows),sse=cpu_calls,disagreements=proof['emulator_cpu_case_disagreements'])))
