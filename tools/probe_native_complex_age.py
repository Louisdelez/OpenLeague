"""Original934860 prologue/duration selection and emitter normalized-age producer."""
from pathlib import Path
import json,struct,itertools,datetime,shutil
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_probability_curve.py').read_text().split('\ninputs=')[0];exec(compile(setup,'native setup','exec'))
instance=heap+0x1000;config=heap+0x2000;owner=heap+0x3000
def bits(v):return struct.unpack('<I',struct.pack('<f',v))[0]
duration_bits=[bits(v) for v in [-2.,-0.,0.,.1,1.,20.]]+[0x7f7fffff,0x7f800000,0xff800000,0x7fc00000]
time_inputs=[(bits(3.),bits(1.),bits(.25)),(bits(0.),bits(0.),bits(0.)),(bits(-1.),bits(2.),bits(-.5))]
cases=[]
def run(a,b,c,now,start,offset):
 u.mem_write(instance,b'\0'*0x100);u.mem_write(config,b'\0'*0x584);u.mem_write(owner,b'\0'*0xb0);write32(instance+4,owner);write32(instance+8,config);write32(instance+0x7c,c);write32(config+0x308,a);write32(config+0x30c,b);write32(config+0x2ec,offset);write32(owner+0xa8,start)
 sp=stack+0x8000;write32(sp,end);write32(sp+4,now);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,instance);u.emu_start(0x934860,0x9348e1,count=1000);assert u.reg_read(UC_X86_REG_EIP)==0x9348e1
 duration=read32(u.reg_read(UC_X86_REG_EAX));age=u.reg_read(UC_X86_REG_XMM1)&0xffffffff
 return {'config_308_bits':hex(a),'config_30c_bits':hex(b),'instance_7c_bits':hex(c),'time_bits':hex(now),'owner_a8_bits':hex(start),'offset_bits':hex(offset),'selected_duration_bits':hex(duration),'normalized_age_bits':hex(age)}
for a,b,c in itertools.product(duration_bits,repeat=3):
 for now,start,offset in time_inputs:cases.append(run(a,b,c,now,start,offset))
for now,start,offset in itertools.product([0x7fc00000,0x7f800000,0xff800000,0x7f7fffff],repeat=3):cases.append(run(bits(2.),bits(3.),bits(1.),now,start,offset))
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'entry':'0x934860','stop':'0x9348e1','cases':cases,'original_instruction_addresses':len(visited),'adapters':['Legal emitter/config/owner fields supplied at original offsets; native prologue, SSE comparisons, conditional moves, sequential subtraction and division execute without math/clock adapters.'],'limits':['Qualifies normalized emitter age for this birth/configuration caller, not normalized per-particle age. Field meanings/source updates for config308/30c and instance7c remain to qualify.','Stops before scalar/vector/color table selection and full birth/lifecycle execution; ordinary renderer remains unbound.']}
(r/'data/4.20/complex_emitter_age_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'passed':True}))
