"""Whole9437E0 composing birth factors and sources with pose/update/tail."""
from pathlib import Path
import json,datetime,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_simple_birth_factors.py').read_text(encoding='utf-8').split('\ncaptures=[]')[0]
exec(compile(setup,'whole sources frame setup','exec'))
old=next(x for x in body.splitlines() if x.startswith('for single,'))
new=old.replace('attribute_value in','attribute_value,frame_flag in').replace('[-.5,0.,.5,1.]','[0.,.5,1.]').replace('[-2.,0.,3.]):','[-2.,0.,3.],[0,1]):')
assert old!=new;body=body.replace(old,new)
marker=' sp=stack+0x8000;'
extra='''
 age=progress*.5
 frame_identity=[1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.]
 for j,v in enumerate(frame_identity):f(system+0xf0+j*4,v);f(instance+0x14+j*4,v);f(instance+0x54+j*4,v)
 for j,v in enumerate(position):f(system+0x90+j*4,v);f(system+0x84+j*4,v-50.);f(instance+0x44+j*4,v-50.);f(instance+0x84+j*4,-(v-50.));f(container+0xc4+j*4,v-50.)
 for j,v in enumerate([-1.,-2.,-3.]):f(container+0xa8+j*4,v)
 for j,v in enumerate([1.,2.,3.]):f(container+0xb4+j*4,v)
 f(container+4,10.);f(container+0xc0,10.);f(instance+0xdc,10.);f(instance+0x114,.25);f(instance+0xe0,1.);u.mem_write(definition+0x150,b'\\1');f(definition+0x1ec,.5);f(definition+0x1f0,1.)
'''
assert marker in body;body=body.replace(marker,extra+marker)
body=body.replace('f(sp+8,progress)','write32(sp+8,frame_flag)').replace('u.emu_start(0x941f00,end,count=100000)','u.emu_start(0x9437e0,end,count=200000)')
body=body.replace('factor_samples=[];scaled_births=[];u.reg_write','factor_samples=[];scaled_births=[];frame_events=[];u.reg_write')
body+='''
 cases[-1].update(frame_flag=frame_flag,last_time=read32(container+4),active=read32(container+0xa4),update_counter=read32(metadata+0x24),minimum=[read32(container+0xa8+j*4) for j in range(3)],maximum=[read32(container+0xb4+j*4) for j in range(3)],center=[read32(container+0xc4+j*4) for j in range(3)],bounds_last=read32(container+0xc0),emitter_current=[read32(instance+0x94+j*4) for j in range(16)],emitter_previous=[read32(instance+0x14+j*4) for j in range(16)],emitter_inverse=[read32(instance+0x54+j*4) for j in range(16)],emitter_last_time=read32(instance+0xdc),emitter_finished=u.mem_read(instance+8,1)[0],emitter_clock=read32(instance+0x114),events=frame_events.copy())
'''
def frame_capture(uc,address,size,user):
 if address in [0x943300,0x941f00,0x944e20,0x944600,0x944760,0x945620,0x944c80,0x9456e0]:frame_events.append(hex(address))
u.hook_add(unicorn.UC_HOOK_CODE,frame_capture)
captures=[]
for corrected in [False,True]:
 enabled=corrected;exec(compile(body,'whole sources frame','exec'));captures.append(cases);u.hook_del(birth_observer)
rows=[dict(emulator=a,cpu=b) for a,b in zip(*captures)];assert len(rows)==576
for a in blocks:kernel.VirtualFree(a,0,0x8000)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='9437E0',cases=rows,actual_cpu_sse_operations=cpu_calls,emulator_cpu_case_disagreements=sum(c['cpu']!=c['emulator'] for c in rows),adapters=['64AEA0 reserve supplies temporary two-float vector storage; C98528 releases it. All pose, birth source, factor, rotation, insertion, particle update and tail bodies execute.'],limits=['Selected finite profiles, local pose, no helper/animation/modifier, valid one-bucket attributes, preallocated empty arrays. Temporary allocator controlled.','Raw descriptor population, native memory/terrain providers, ordinary graphics/audio and Rust full-frame integration remain unqualified.'])
assert proof['emulator_cpu_case_disagreements']==0
(r/'data/4.20/simple_sources_frame_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(rows),sse=cpu_calls,disagreements=proof['emulator_cpu_case_disagreements'])))
