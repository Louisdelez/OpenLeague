"""Whole941F00 with contextual/attribute birth factors and combined sources."""
from pathlib import Path
import json,itertools,datetime,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_simple_combined_sources.py').read_text(encoding='utf-8').split('\ncaptures=[]')[0]
exec(compile(setup,'birth factor native setup','exec'))
marker=' sp=stack+0x8000;'
extra='''
 factor_profile=(mode+profile*4)%6
 factor_context=[2.,3.,4.] if profile==0 else [-2.,3.,-4.]
 factor_offset_coefficients=[[0.,0.,0.],[.5,0.,0.],[-.5,0.,0.],[0.,.5,0.],[0.,0.,.5],[.5,-1.,.25]][factor_profile]
 factor_bounds_coefficients=[[0.,0.,0.],[.5,0.,0.],[-.5,0.,0.],[0.,.5,0.],[0.,0.,-.5],[.25,.5,-1.]][factor_profile]
 factor_life_enabled=(mode+profile)%2;factor_life_value=[-2.,0.,2.][(mode+profile)%3]
 factor_offset_enabled=mode&1;factor_size_enabled=(mode>>1)&1;factor_offset_multiplier=.5;factor_size_multiplier=.5
 for off,v in zip([0xc4,0xe0,0xe4],factor_context):f(system+off,v)
 for off,v in zip([0x20c,0x21c,0x214],factor_offset_coefficients):f(definition+off,v)
 for off,v in zip([0x210,0x220,0x218],factor_bounds_coefficients):f(definition+off,v)
 u.mem_write(definition+0x9c,bytes([factor_life_enabled]));f(system+0x80,factor_life_value)
 write32(definition+0x32c,7);f(definition+0x330,factor_offset_multiplier);u.mem_write(definition+0x334,bytes([factor_offset_enabled]))
 write32(definition+0x338,7);f(definition+0x33c,factor_size_multiplier);u.mem_write(definition+0x340,bytes([factor_size_enabled]))
'''
assert marker in body;body=body.replace(marker,extra+marker)
body=body.replace('offset_samples=[];u.reg_write','offset_samples=[];factor_samples=[];scaled_births=[];u.reg_write')
body+='\n cases[-1].update(factor_profile=factor_profile,factor_context=factor_context,factor_offset_coefficients=factor_offset_coefficients,factor_bounds_coefficients=factor_bounds_coefficients,factor_life_enabled=factor_life_enabled,factor_life_value=factor_life_value,factor_offset_enabled=factor_offset_enabled,factor_size_enabled=factor_size_enabled,factor_offset_multiplier=factor_offset_multiplier,factor_size_multiplier=factor_size_multiplier,prepared_factors=factor_samples.copy(),scaled_births=scaled_births.copy())\n'
def factor_capture(uc,address,size,user):
 frame=u.reg_read(UC_X86_REG_EBP)
 if address==0x942487:factor_samples.append(dict(offset_context=read32(frame-0xe0),bounds=read32(instance+0xe0),offset_attribute=read32(frame-0xbc),size_attribute=read32(frame-0xa8)))
 if address==0x942c3c:scaled_births.append(dict(life=read32(frame-0x50),offset=[read32(frame+off) for off in [-0x1c,-0x18,-0x28]],factor=read32(frame-0xcc)))
u.hook_add(unicorn.UC_HOOK_CODE,factor_capture)
captures=[]
for corrected in [False,True]:
 enabled=corrected;exec(compile(body,'whole birth factors and sources','exec'));captures.append(cases);u.hook_del(birth_observer)
rows=[dict(emulator=a,cpu=b) for a,b in zip(*captures)];assert len(rows)==384
threshold=read32(0x11389ac)
for a in blocks:kernel.VirtualFree(a,0,0x8000)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='941F00',cases=rows,threshold_bits=threshold,actual_cpu_sse_operations=cpu_calls,emulator_cpu_case_disagreements=sum(c['cpu']!=c['emulator'] for c in rows),adapters=['64AEA0 reserve supplies temporary two-float vector storage; C98528 releases that supplied vector. Context/attribute factor lookup, life/offset/size scaling, source probabilities, rotations and insertion execute.'],limits=['Six selected finite coefficient profiles, life multiplier -2/0/2 and flags, -2/0/3 present/missing attributes, valid one-bucket map, identity pose and preallocated particle arrays. Temporary allocation controlled.','Source field names/defaults beyond addresses, generalized rounding and native memory/pose/terrain providers, ordinary graphics/audio incomplete.'])
assert proof['emulator_cpu_case_disagreements']==0
(r/'data/4.20/simple_birth_factors_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(rows),sse=cpu_calls,disagreements=proof['emulator_cpu_case_disagreements'],threshold_bits=threshold)))
