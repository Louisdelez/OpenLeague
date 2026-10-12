from pathlib import Path
import json,datetime
r=Path('E:/OpenLeague')
prefix=(r/'tools/probe_native_simple_cycle.py').read_text(encoding='utf-8').split('frames=[]')[0]
exec(compile(prefix,'native setup','exec'))
cases=[]
for bits in [0,0xa5a5a5a5,0x40800000]:
 for offset in [0xbc,0xc0]:write32(system+offset,bits)
 write32(instance+0xe0,bits)
 u.reg_write(UC_X86_REG_EDI,system);u.emu_start(0x93dc47,0x93dc5b,count=100)
 assert u.reg_read(UC_X86_REG_EIP)==0x93dc5b
 u.reg_write(UC_X86_REG_EBX,instance);u.emu_start(0x9414a9,0x9414b3,count=100)
 assert u.reg_read(UC_X86_REG_EIP)==0x9414b3
 cases.append(dict(previous_bits=hex(bits),system_bc=floats(system+0xbc,1)[0],system_c0=floats(system+0xc0,1)[0],emitter_scale=floats(instance+0xe0,1)[0]))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),native_sha256=digest,passed=True,complete=False,ranges=[['0x93dc47','0x93dc5b'],['0x9414a9','0x9414b3']],runtime_adapters=[],cases=cases,limits=['Original constructor field-store segments only; not complete system/instance constructors.','Defaults are one; subsequent runtime setters, scale curves and exact missile owner remain to qualify.'])
(r/'data/4.20/projected_scale_defaults_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
print(json.dumps(proof))
