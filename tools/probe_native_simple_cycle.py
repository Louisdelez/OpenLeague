"""Run original Simple frame update using native defaults and preallocated storage."""
from pathlib import Path
import struct,json,datetime
r=Path('E:/OpenLeague')
s=(r/'tools/probe_native_simple_defaults.py').read_text(encoding='utf-8').split('offsets=')[0].replace('\nu.hook_add(unicorn.UC_HOOK_CODE,hook)','\ndefault_hook=u.hook_add(unicorn.UC_HOOK_CODE,hook)')
exec(compile(s,'native constructor setup','exec'))
definition=object_address
u.mem_write(definition,b'\0'*0x410)
sp=stack+0x8000;write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,definition)
u.emu_start(0x91c0c0,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
initialization_adapters=list(calls);u.hook_del(default_hook);visited=set();birth_calls=[]
u.mem_map(heap+0x10000,0x10000)
instance=heap+0x11000;system=heap+0x12000;context=heap+0x13000;container=heap+0x14000;metadata=heap+0x15000
def f(a,v):u.mem_write(a,struct.pack('<f',v))
def floats(a,n):return list(struct.unpack('<'+'f'*n,u.mem_read(a,n*4)))
def hook_cycle(uc,a,size,user):
 visited.add(a)
 if a==0x943284:birth_calls.append(floats(u.reg_read(UC_X86_REG_ESP),2))
 assert any(lo<=a<hi for lo,hi in native_code_ranges),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook_cycle)
write32(instance,system);write32(instance+4,definition);write32(instance+0xc,container);write32(instance+0x140,context)
write32(definition+4,metadata);write32(container,instance)
f(instance+0x10,1.);f(instance+0xdc,-3.4028234663852886e38);f(container+4,-3.4028234663852886e38);f(system+0xa8,10.);f(context+0xec,1.)
write32(definition+0x17c,1);u.mem_write(definition+0x151,b'\1')
for off,value in [(0x74,1.),(0x88,2.),(0xd8,500.),(0x108,0.)]:f(read32(definition+off),value)
for i,off in enumerate(range(8,0x99,12)):
 a=heap+0x18000+i*0x100;write32(container+off,a);write32(container+off+4,a);write32(container+off+8,a+0x100)
for off in [0xa8,0xac,0xb0]:f(container+off,3.4028234663852886e38)
for off in [0xb4,0xb8,0xbc]:f(container+off,-3.4028234663852886e38)
write32(0x2d6ece4,0);write32(0x2d6ece8,0)
for i in range(55):write32(0x2d6ec08+4*i,12345+13579*i)
identity=[1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.]
yaw90=[0.,0.,-1.,0.,0.,1.,0.,0.,1.,0.,0.,0.,0.,0.,0.,1.]
frames=[]
for age in [0.,.125,.25,.5,1.,1.5,1.999,2.,2.125]:
 for i,x in enumerate(identity if age<.5 else yaw90):f(system+0xf0+4*i,x)
 for i,x in enumerate([100.+age*100.,200.,300.]):f(system+0x90+4*i,x)
 write32(sp,end);f(sp+4,10.+age);f(sp+8,.125);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,instance)
 u.emu_start(0x9437e0,end,count=200000);assert u.reg_read(UC_X86_REG_EIP)==end
 n=(read32(container+0xc)-read32(container+8))//4
 frames.append(dict(age=age,particle_slots=n,active_count=read32(container+0xa4),emitter_finished=u.mem_read(instance+8,1)[0],normalized_age=floats(read32(container+0x20),n),life=floats(read32(container+0x14),n),position=floats(read32(container+0x2c),n*3),previous_matrix=floats(instance+0x14,16),previous_inverse=floats(instance+0x54,16),last_update=floats(container+4,1)[0]))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),native_sha256=digest,complete=False,passed=True,entry='0x9437e0',original_instruction_addresses=len(visited),runtime_adapters=[],initialization_adapters=initialization_adapters,delta_threshold=floats(0x11389d8,1)[0],delta_threshold_bits=read32(0x11389d8),birth_calls=birth_calls,frames=frames,limits=['Native Simple default initializer executed with heap adapters; subsequent full frame updates execute without adapters.','Explicit preallocated arrays, owner metadata, constant native curve edits rate1/life2/scale500(d8)/rotationVelocity0(108), local-orient1, emitter lifetime1, system pose/time and native RNG seed supplied.','Owner destruction, system pose/bone producer, terrain receiver and final visual acceptance remain unqualified.'])
(r/'data/4.20/simple_cycle_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
print(json.dumps(dict(instructions=len(visited),births=birth_calls,delta_threshold=proof['delta_threshold'],delta_threshold_bits=proof['delta_threshold_bits'],frames=len(frames))))
