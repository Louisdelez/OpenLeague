"""Whole941F00 position/velocity attribute stages with actual lookup and RNG."""
from pathlib import Path
import json,itertools,datetime,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_simple_life_attribute.py').read_text(encoding='utf-8').split('\ncaptures=[]')[0]
exec(compile(setup,'vector attribute native setup','exec'))
marker=' sp=stack+0x8000;'
extra='''
 attribute_vectors={0x36c:[[.5,1.,-.25],[1.5,-2.,3.],[-1.,.25,2.]],0x3e4:[[1.,-.5,2.],[-2.,3.,.5],[.25,-1.,1.5]]};attribute_vector_modes={}
 for index,(off,table) in enumerate(attribute_vectors.items()):
  table_address=heap+0x66000+index*0x1000;write32(definition+off-4,7);write32(definition+off,table_address);write32(definition+off+4,table_address+len(table)*12);write32(definition+off+8,table_address+len(table)*12);u.mem_write(definition+off+0x1c,b'\\1')
  for j,value in enumerate(x for row in table for x in row):f(table_address+j*4,value)
  attribute_vector_modes[hex(off)]=[]
  for axis in range(3):
   vector_mode=(mode+axis+1)%4;attribute_vector_modes[hex(off)].append(vector_mode)
   probability_address=heap+0x68000+index*0x1000+axis*0x100;u.mem_write(probability_address,b'\\0'*0x100);write32(definition+off+0xc+axis*4,probability_address if vector_mode else 0)
   u.mem_write(probability_address,bytes([vector_mode==1]));f(probability_address+4,.5);u.mem_write(probability_address+8,bytes([vector_mode==2]));f(probability_address+0xc,.25);f(probability_address+0x10,1.5)
   times=probability_address+0x80;probability_values=probability_address+0xc0;write32(probability_address+0x14,times);write32(probability_address+0x18,times+12);write32(probability_address+0x20,probability_values);write32(probability_address+0x24,probability_values+12)
   for j,(t,value) in enumerate(zip([0.,.5,1.],[1.,.5,2.])):f(times+j*4,t);f(probability_values+j*4,value)
'''
assert marker in body;body=body.replace(marker,extra+marker)
body=body.replace('life_samples=[];u.reg_write','life_samples=[];vector_samples=[];u.reg_write')
body+='\n cases[-1].update(attribute_vectors={hex(off):table for off,table in attribute_vectors.items()},attribute_vector_modes=attribute_vector_modes,prepared_vectors=vector_samples.copy())\n'
def observe_vectors(uc,address,size,user):
 if address==0x94225c:
  frame=u.reg_read(UC_X86_REG_EBP);vector_samples.append(dict(position=[read32(frame-0x88+j*4) for j in range(3)],velocity=[read32(frame-0x7c+j*4) for j in range(3)]))
u.hook_add(unicorn.UC_HOOK_CODE,observe_vectors)
captures=[]
for corrected in [False,True]:
 enabled=corrected;exec(compile(body,'whole position velocity attribute stages','exec'));captures.append(cases);u.hook_del(birth_observer)
rows=[dict(emulator=a,cpu=b) for a,b in zip(*captures)];assert len(rows)==384
for a in blocks:kernel.VirtualFree(a,0,0x8000)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='941F00',cases=rows,actual_cpu_sse_operations=cpu_calls,emulator_cpu_case_disagreements=sum(c['cpu']!=c['emulator'] for c in rows),adapters=[],findings=['Position and velocity first add attribute times raw vector weight with separate SSE multiplication/addition.','Per birth, own component probabilities run first; attribute component probabilities then multiply the augmented prepared vector, not the raw weight vector. Attribute times this result is added, preserving interleaved life/position/scale/scalar/velocity/rotation/offset RNG order.'],limits=['Whole native rate/life/position/velocity attribute branches with actual map lookup, supplied finite tables and attributes -2/0/3, identity pose and preallocated arrays.','Rust vector attribute validation recorded separately. Rotation attribute/list, rounding extremes, source population and ordinary rendering/audio integration remain incomplete.'])
assert proof['emulator_cpu_case_disagreements']==0
(r/'data/4.20/simple_vector_attributes_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(rows),sse=cpu_calls,disagreements=proof['emulator_cpu_case_disagreements'])))
