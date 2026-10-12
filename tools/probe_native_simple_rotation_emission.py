"""Whole941F00 with raw rotation tables and controlled temporary vector storage."""
from pathlib import Path
import json,itertools,datetime,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_simple_birth_vectors.py').read_text(encoding='utf-8').split('\ncaptures=[]')[0]
exec(compile(setup,'rotation list emission native setup','exec'))
marker=' sp=stack+0x8000;'
extra='''
 rotation_tables=[[90.,0.,-45.,180.],[-30.,60.,90.,-90.]];rotation_axes=[[1.,0.,0.],[0.,1.,0.]];rotation_modes=[mode,(mode+1)%4]
 rotation_descriptors=heap+0x30000;rotation_axis_data=heap+0x31000
 write32(definition+0x138,rotation_descriptors);write32(definition+0x13c,rotation_descriptors+8);write32(definition+0x140,rotation_descriptors+8);write32(definition+0x144,rotation_axis_data)
 for i,table in enumerate(rotation_tables):
  descriptor=heap+0x32000+i*0x100;data=heap+0x33000+i*0x100;probability_address=heap+0x34000+i*0x100;rotation_mode=rotation_modes[i]
  write32(rotation_descriptors+i*4,descriptor);write32(descriptor,data);write32(descriptor+4,data+16);write32(descriptor+8,data+16);write32(descriptor+0xc,probability_address if rotation_mode else 0)
  for j,v in enumerate(table):f(data+j*4,v)
  for j,v in enumerate(rotation_axes[i]):f(rotation_axis_data+i*12+j*4,v)
  u.mem_write(probability_address,b'\\0'*0x100);u.mem_write(probability_address,bytes([rotation_mode==1]));f(probability_address+4,.5);u.mem_write(probability_address+8,bytes([rotation_mode==2]));f(probability_address+0xc,.25);f(probability_address+0x10,1.5)
  times=probability_address+0x80;probability_values=probability_address+0xc0;write32(probability_address+0x14,times);write32(probability_address+0x18,times+12);write32(probability_address+0x20,probability_values);write32(probability_address+0x24,probability_values+12)
  for j,(t,v) in enumerate(zip([0.,.5,1.],[1.,.5,2.])):f(times+j*4,t);f(probability_values+j*4,v)
'''
assert marker in body;body=body.replace(marker,extra+marker)
body+='\n cases[-1].update(rotation_tables=rotation_tables,rotation_axes=rotation_axes,rotation_modes=rotation_modes)\n'
buffer=heap+0x36000
def temporary_vector(uc,a,size,user):
 if a==0x64aea0 and read32(u.reg_read(UC_X86_REG_ESP))==0x942315:
  sp=u.reg_read(UC_X86_REG_ESP);n=read32(sp+4);assert n==2;obj=u.reg_read(UC_X86_REG_ECX)
  write32(obj,buffer);write32(obj+4,buffer);write32(obj+8,buffer+n*4);finish(pop=4)
 if a==0xc98528 and read32(u.reg_read(UC_X86_REG_ESP))==0x9432c9:
  assert read32(u.reg_read(UC_X86_REG_ESP)+4)==buffer;finish()
u.hook_add(unicorn.UC_HOOK_CODE,temporary_vector)
captures=[]
for corrected in [False,True]:
 enabled=corrected;exec(compile(body,'whole rotation list emission','exec'));captures.append(cases);u.hook_del(birth_observer)
rows=[dict(emulator=a,cpu=b) for a,b in zip(*captures)];assert len(rows)==160
for a in blocks:kernel.VirtualFree(a,0,0x8000)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='941F00',cases=rows,actual_cpu_sse_operations=cpu_calls,emulator_cpu_case_disagreements=sum(c['cpu']!=c['emulator'] for c in rows),adapters=['64AEA0 reserve supplies temporary two-float vector storage; C98528 releases that supplied vector. Actual list table sampling,6BDC40 append, gates, probabilities, RNG, matrices, transforms and insertion execute.'],limits=['Selected raw scalar/vector/rotation tables, identity owner pose and preallocated particle arrays. Native temporary allocator/free backend not qualified.','Source resource binding, general memory/pose/terrain providers and ordinary graphics/audio integration remain incomplete.'])
assert proof['emulator_cpu_case_disagreements']==0
(r/'data/4.20/simple_rotation_emission_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(rows),sse=cpu_calls,disagreements=proof['emulator_cpu_case_disagreements'])))
