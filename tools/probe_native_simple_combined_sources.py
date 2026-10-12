"""Whole941F00 rate/life/vector/rotation/offset attributes plus rotation lists."""
from pathlib import Path
import ast,json,itertools,datetime,shutil,re
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_simple_rotation_attribute.py').read_text(encoding='utf-8').split('\ncaptures=[]')[0]
exec(compile(setup,'combined source native setup','exec'))
def extra_from(path):
 tree=ast.parse(Path(path).read_text(encoding='utf-8'))
 return next(ast.literal_eval(n.value) for n in tree.body if isinstance(n,ast.Assign) and any(isinstance(t,ast.Name) and t.id=='extra' for t in n.targets))
offset_extra=re.sub(r'\bweight_mode\b','offset_component_mode',extra_from(r/'tools/probe_native_simple_offset_attribute.py'))
extra=extra_from(r/'tools/probe_native_simple_rotation_emission.py')+offset_extra
marker=' sp=stack+0x8000;';assert marker in body;body=body.replace(marker,extra+marker)
body=body.replace('rotation_samples=[];u.reg_write','rotation_samples=[];offset_samples=[];u.reg_write')
body+='\n cases[-1].update(rotation_tables=rotation_tables,rotation_axes=rotation_axes,rotation_modes=rotation_modes,offset_weights=offset_weights,offset_weight_modes=offset_weight_modes,augmented_offsets=offset_samples.copy())\n'
body+='''
 actual_rate_probability=read32(definition+0x39c);recorded_rate_mode=cases[-1]['weight_mode']
 assert bool(actual_rate_probability)==bool(recorded_rate_mode)
 if actual_rate_probability:
  assert bool(u.mem_read(actual_rate_probability,1)[0])==(recorded_rate_mode==1)
  assert bool(u.mem_read(actual_rate_probability+8,1)[0])==(recorded_rate_mode==2)
'''
buffer=heap+0x6e000
def combined_capture(uc,address,size,user):
 if address==0x942b62:offset_samples.append([read32(u.reg_read(UC_X86_REG_EBP)-0x38+j*4) for j in range(3)])
 if address==0x64aea0 and read32(u.reg_read(UC_X86_REG_ESP))==0x942315:
  sp=u.reg_read(UC_X86_REG_ESP);n=read32(sp+4);assert n==2;obj=u.reg_read(UC_X86_REG_ECX)
  write32(obj,buffer);write32(obj+4,buffer);write32(obj+8,buffer+n*4);finish(pop=4)
 if address==0xc98528 and read32(u.reg_read(UC_X86_REG_ESP))==0x9432c9:
  assert read32(u.reg_read(UC_X86_REG_ESP)+4)==buffer;finish()
u.hook_add(unicorn.UC_HOOK_CODE,combined_capture)
captures=[]
for corrected in [False,True]:
 enabled=corrected;exec(compile(body,'whole combined source emission','exec'));captures.append(cases);u.hook_del(birth_observer)
rows=[dict(emulator=a,cpu=b) for a,b in zip(*captures)];assert len(rows)==384
for a in blocks:kernel.VirtualFree(a,0,0x8000)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='941F00',cases=rows,actual_cpu_sse_operations=cpu_calls,emulator_cpu_case_disagreements=sum(c['cpu']!=c['emulator'] for c in rows),adapters=['64AEA0 reserve supplies temporary two-float vector storage; C98528 releases that supplied vector. Source samplers, attribute lookups, probabilities/RNG, matrices, transforms and insertion execute.'],limits=['Finite supplied rate/life/vector/rotation/final-offset attribute and rotation-list tables; -2/0/3 present/missing attributes, one-bucket map, identity pose and preallocated particle arrays. Temporary allocator/free controlled.','Other scaling flags, general rounding/source population, native memory/pose/terrain and ordinary graphics/audio integration remain incomplete.'])
assert proof['emulator_cpu_case_disagreements']==0
(r/'data/4.20/simple_combined_sources_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(rows),sse=cpu_calls,disagreements=proof['emulator_cpu_case_disagreements'])))
