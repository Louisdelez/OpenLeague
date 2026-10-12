"""Whole9437E0 with actual normal941F00 births and944E20 updates."""
from pathlib import Path
import json,struct,itertools,datetime,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_simple_emission_lifecycle.py').read_text(encoding='utf-8').split('\ncaptures=[]')[0]
exec(compile(setup,'Normal Simple frame native setup','exec'))
body=body.replace('for single,latch,rate,age,previous in itertools.product([0,1],[0,1],[0.,1.,2.9,20.],[0.,.125,.5,1.],[10.,10.5]):','for single,latch,rate,age,previous,flag in itertools.product([0,1],[0,1],[0.,1.,2.9,20.],[0.,.125,.5,1.],[10.,10.5],[0,1]):')
needle='f(instance+0x10,1.);'
extra='''
 identity=[1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.]
 for j,v in enumerate(identity):f(system+0xf0+j*4,v);f(instance+0x14+j*4,v);f(instance+0x54+j*4,v)
 for j,v in enumerate(position):f(system+0x90+j*4,v);f(system+0x84+j*4,v-50.);f(instance+0x44+j*4,v-50.);f(instance+0x84+j*4,-(v-50.));f(container+0xc4+j*4,v-50.)
 for j,v in enumerate([-1.,-2.,-3.]):f(container+0xa8+j*4,v)
 for j,v in enumerate([1.,2.,3.]):f(container+0xb4+j*4,v)
 f(container+4,10.);f(container+0xc0,10.);f(instance+0xdc,10.);f(instance+0x114,.25);f(instance+0xe0,1.);u.mem_write(definition+0x150,b'\\1');f(definition+0x1ec,1.);f(definition+0x1f0,2.)
'''
# Inverse translation starts54+30=84; previous translation14+30=44.
assert needle in body
body=body.replace(needle,extra+' '+needle)
body=body.replace('f(sp+8,.5)','write32(sp+8,flag)').replace('u.emu_start(0x941f00,end,count=100000)','u.emu_start(0x9437e0,end,count=100000)').replace(' calls=[];u.reg_write',' calls=[];frame_events=[];u.reg_write')
body+='''
 cases[-1].update(flag=flag,last_time=read32(container+4),active=read32(container+0xa4),update_counter=read32(metadata+0x24),minimum=[read32(container+0xa8+j*4) for j in range(3)],maximum=[read32(container+0xb4+j*4) for j in range(3)],center=[read32(container+0xc4+j*4) for j in range(3)],bounds_last=read32(container+0xc0),emitter_current=[read32(instance+0x94+j*4) for j in range(16)],emitter_previous=[read32(instance+0x14+j*4) for j in range(16)],emitter_inverse=[read32(instance+0x54+j*4) for j in range(16)],emitter_last_time=read32(instance+0xdc),emitter_finished=u.mem_read(instance+8,1)[0],emitter_clock=read32(instance+0x114),events=frame_events.copy())
'''
def frame_observe(uc,a,size,user):
 if a in [0x943300,0x941f00,0x944e20,0x944600,0x944760,0x945620,0x944c80,0x9456e0]:frame_events.append(hex(a))
u.hook_add(unicorn.UC_HOOK_CODE,frame_observe)
captures=[]
for corrected in [False,True]:
 enabled=corrected;exec(compile(body,'actual whole normal Simple frame','exec'));captures.append(cases);u.hook_del(birth_observer)
rows=[dict(emulator=a,cpu=b) for a,b in zip(*captures)];assert len(rows)==256
for a in blocks:kernel.VirtualFree(a,0,0x8000)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='9437E0',cases=rows,actual_cpu_sse_operations=cpu_calls,emulator_cpu_case_disagreements=sum(c['cpu']!=c['emulator'] for c in rows),adapters=[],limits=['Actual whole9437E0 invokes943300,941F00 normal/burst birth and944E20 particle update. Cold/warm pose, bounds flags, raw signed birth count/latch, all particle/emitter arrays and shared RNG captured. Preallocated empty arrays and constant resource tables; no helper/animation/modifier.','Allocation, dynamic attributes/rotation/probability producers, ordinary rendered/audio acceptance remain incomplete.'])
(r/'data/4.20/simple_normal_frame_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(rows),sse=cpu_calls,disagreements=proof['emulator_cpu_case_disagreements'])))
