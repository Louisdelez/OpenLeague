from pathlib import Path
import json,struct,datetime,math,hashlib,sys
r=Path('E:/OpenLeague')
prefix=(r/'tools/probe_native_simple_cycle.py').read_text(encoding='utf-8').split('frames=[]')[0]
cases=[]
for particle_linger,emitter_linger in [(0.,0.),(.75,0.),(2.,0.),(0.,.5),(.75,.5)]:
 exec(compile(prefix,'native frame setup','exec'))
 f(definition+0xa0,particle_linger);f(definition+0xa4,emitter_linger)
 frames=[]
 for age in [0.,.125,.25,.5,.50005,.625,.75,1.,1.5,2.]:
  ended=age>=.5
  write32(system+0x1dc,0x10 if ended else 0)
  for i,x in enumerate(identity if age<.5 else yaw90):f(system+0xf0+4*i,x)
  for i,x in enumerate([100.+age*100.,200.,300.]):f(system+0x90+4*i,x)
  write32(sp,end);f(sp+4,10.+age);f(sp+8,.125);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,instance)
  u.emu_start(0x9437e0,end,count=200000);assert u.reg_read(UC_X86_REG_EIP)==end
  n=(read32(container+0xc)-read32(container+8))//4
  norm=floats(read32(container+0x20),n)
  frames.append(dict(age=age,owner_end_flag=ended,particle_slots=n,active_count=read32(container+0xa4),emitter_finished=u.mem_read(instance+8,1)[0],normalized_age=[x if math.isfinite(x) else 'Infinity' if x>0 else '-Infinity' if x<0 else 'NaN' for x in norm],normalized_age_bits=[read32(read32(container+0x20)+4*i) for i in range(n)],life=floats(read32(container+0x14),n),position=floats(read32(container+0x2c),n*3),previous_matrix=floats(instance+0x14,16),last_update=floats(container+4,1)[0]))
 cases.append(dict(particle_linger=particle_linger,emitter_linger=emitter_linger,original_instruction_addresses=len(visited),birth_calls=birth_calls,frames=frames))
 print(json.dumps({'p':particle_linger,'e':emitter_linger,'frames':[(x['age'],x['normalized_age'],x['active_count'],x['emitter_finished']) for x in frames]}))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),native_sha256=digest,complete=False,passed=True,entry='0x9437e0',runtime_adapters=[],cases=cases,limits=['Owner-end flag supplied explicitly at age0.5; upstream flag and system-start-time producer unqualified.','Explicit p-linger/e-linger values, preallocated storage and constant native curves supplied.','No normal gameplay binding or GPU validation claimed.'])
(r/'data/4.20/simple_owner_end_contract.json').write_text(json.dumps(proof,indent=2,allow_nan=False)+'\n')
# Keep exact primary-source reader instructions and referenced constant values.
import capstone
md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
code=[dict(address=hex(i.address),mnemonic=i.mnemonic,operands=i.op_str) for i in md.disasm(bytes(u.mem_read(0x91ef33,0xb0)),0x91ef33)]
reader=dict(native_sha256=digest,complete=False,reader_executed=False,instructions=code,constants={hex(a):{'bits':read32(a),'float':floats(a,1)[0]} for a in [0x1138fa8,0x1138c74]})
(r/'data/4.20/simple_linger_reader_contract.json').write_text(json.dumps(reader,indent=2)+'\n')
