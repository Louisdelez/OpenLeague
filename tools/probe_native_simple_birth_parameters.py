"""Whole941F00 with variable birth scalar tables; actual948FB0 ignores probability."""
from pathlib import Path
import json,itertools,datetime,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_simple_emission_lifecycle.py').read_text(encoding='utf-8').split('\ncaptures=[]')[0]
exec(compile(setup,'birth parameter native setup','exec'))
old=next(x for x in body.splitlines() if x.startswith('for single,'))
body=body.replace(old,'for single,progress,profile in itertools.product([0,1],[-.5,0.,.1,.249,.25,.5,.75,.999,1.,2.],[0,1]):\n rate=4.;latch=0;age=.125;previous=10.')
marker=' sp=stack+0x8000;'
extra='''
 authored={0x88:[.25,1.,2.,4.],0xc4:[.1,.2,.4,.8],0xd8:[.5,1.,2.,3.],0x108:[-2.,0.,2.,4.]}
 if profile:authored={off:[-x for x in vals] for off,vals in authored.items()}
 for off,table in authored.items():
  a=read32(definition+off);write32(definition+off+4,a+len(table)*4);write32(definition+off+8,a+len(table)*4)
  for j,value in enumerate(table):f(a+j*4,value)
  # Valid probability object deliberately present:948FB0 must not read it.
  probability_address=heap+0xa000+off*0x40;u.mem_write(probability_address,b'\\0'*0x30);u.mem_write(probability_address,b'\\1');f(probability_address+4,7.);write32(definition+off+0xc,probability_address)
'''
assert marker in body
body=body.replace(marker,extra+marker).replace('f(sp+8,.5)','f(sp+8,progress)')
body+='\n cases[-1].update(progress=progress,profile=profile,tables={hex(off):table for off,table in authored.items()})\n'
captures=[]
for corrected in [False,True]:
 enabled=corrected;exec(compile(body,'actual birth parameter sources','exec'));captures.append(cases);u.hook_del(birth_observer)
rows=[dict(emulator=a,cpu=b) for a,b in zip(*captures)];assert len(rows)==40
for a in blocks:kernel.VirtualFree(a,0,0x8000)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='941F00',cases=rows,actual_cpu_sse_operations=cpu_calls,emulator_cpu_case_disagreements=sum(c['cpu']!=c['emulator'] for c in rows),adapters=[],limits=['Actual whole emission with four variable scalar tables and valid unused probability objects.948FB0 samples life88,scalarC4,scaleD8,rotation108 without probability; rate74 uses948EE0.','Constant emitter-rate, zero vector tables, no attribute producers/rotation list, identity pose, preallocated arrays. Ordinary game binding not qualified.'])
assert proof['emulator_cpu_case_disagreements']==0
(r/'data/4.20/simple_birth_parameters_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(rows),sse=cpu_calls,disagreements=proof['emulator_cpu_case_disagreements'])))
