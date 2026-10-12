"""Whole941F00 variable vector tables and interleaved scalar/vector probabilities."""
from pathlib import Path
import json,itertools,datetime,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_simple_birth_probability.py').read_text(encoding='utf-8').split('\ncaptures=[]')[0]
exec(compile(setup,'vector birth native setup','exec'))
marker=' sp=stack+0x8000;'
extra='''
 vector_tables={0xa8:[[1.,2.,3.],[4.,-5.,6.],[-2.,3.,-4.]],0xec:[[.25,-.5,1.],[1.,2.,-3.],[-4.,.5,6.]],0x11c:[[10.,20.,30.],[-2.,4.,-6.],[3.,-7.,2.]]}
 vector_modes={}
 for off,table in vector_tables.items():
  a=read32(definition+off);write32(definition+off+4,a+len(table)*12);write32(definition+off+8,a+len(table)*12)
  for j,value in enumerate(x for row in table for x in row):f(a+j*4,value)
  vector_modes[hex(off)]=[]
  for axis in range(3):
   vector_mode=(mode+axis)%4;vector_modes[hex(off)].append(vector_mode)
   probability_address=heap+0x70000+off*0x800+axis*0x100
   u.mem_write(probability_address,b'\\0'*0x100);write32(definition+off+0xc+axis*4,probability_address if vector_mode else 0)
   u.mem_write(probability_address,bytes([vector_mode==1]));f(probability_address+4,.5);u.mem_write(probability_address+8,bytes([vector_mode==2]));f(probability_address+0xc,.25);f(probability_address+0x10,1.5)
   times=probability_address+0x80;probability_values=probability_address+0xc0
   write32(probability_address+0x14,times);write32(probability_address+0x18,times+12);write32(probability_address+0x20,probability_values);write32(probability_address+0x24,probability_values+12)
   for j,(t,value) in enumerate(zip([0.,.5,1.],[1.,.5,2.])):f(times+j*4,t);f(probability_values+j*4,value)
'''
assert marker in body;body=body.replace(marker,extra+marker)
body+='\n cases[-1].update(vector_tables={hex(off):table for off,table in vector_tables.items()},vector_modes=vector_modes)\n'
captures=[]
for corrected in [False,True]:
 enabled=corrected;exec(compile(body,'actual scalar vector interleaved emission','exec'));captures.append(cases);u.hook_del(birth_observer)
rows=[dict(emulator=a,cpu=b) for a,b in zip(*captures)];assert len(rows)==160
for a in blocks:kernel.VirtualFree(a,0,0x8000)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='941F00',cases=rows,actual_cpu_sse_operations=cpu_calls,emulator_cpu_case_disagreements=sum(c['cpu']!=c['emulator'] for c in rows),adapters=[],limits=['Actual941F00 variable scalar and three vector tables; per-component null/constant/fast/generic probabilities execute9492F0 and native RNG, interleaved with scalar draws. All particle arrays, emitter state and full RNG captured.','Constant rate, identity pose, no attributes/rotation list, supplied preallocated storage. Native resource binding, attributes, memory/pose/terrain producers and ordinary render/audio incomplete.'])
assert proof['emulator_cpu_case_disagreements']==0
(r/'data/4.20/simple_birth_vectors_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(rows),sse=cpu_calls,disagreements=proof['emulator_cpu_case_disagreements'])))
