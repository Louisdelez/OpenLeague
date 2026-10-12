"""Original instance duration initialization and elapsed-time end-flag fragment."""
from pathlib import Path
import json,struct,itertools,datetime,shutil
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_probability_curve.py').read_text().split('\ninputs=')[0];exec(compile(setup,'native setup','exec'))
instance=heap+0x1000;config=heap+0x2000;owner=heap+0x3000
def bits(v):return struct.unpack('<I',struct.pack('<f',v))[0]
values=[bits(v) for v in [-2.,-0.,0.,.1,1.,20.]]+[0x7f7fffff,0x7f800000,0xff800000,0x7fc00000]
initial=[];ends=[]
for life,scale,enabled in itertools.product(values,values,[False,True]):
 u.mem_write(instance,b'\0'*0x300);u.mem_write(config,b'\0'*0x584);u.mem_write(owner,b'\0'*0x200);write32(instance+4,owner);write32(instance+8,config);write32(config+0x2f0,life);u.mem_write(config+0x2f4,bytes([enabled]));write32(owner+0x80,scale)
 u.reg_write(UC_X86_REG_EBX,instance);u.reg_write(UC_X86_REG_ESP,stack+0x8000);u.emu_start(0x9331d0,0x9331fa,count=1000);assert u.reg_read(UC_X86_REG_EIP)==0x9331fa
 initial.append({'life_bits':hex(life),'scale_bits':hex(scale),'enabled':enabled,'instance_duration_bits':hex(read32(instance+0x7c))})
for duration,override,now,start,flags in itertools.product(values,[bits(v) for v in [-1.,0.,1.]]+[0x7f7fffff,0x7f800000,0x7fc00000],values,[bits(0.),bits(1.),0x7fc00000],[0,0x10]):
 u.mem_write(instance,b'\0'*0x300);u.mem_write(config,b'\0'*0x584);u.mem_write(owner,b'\0'*0x200);write32(instance+4,owner);write32(instance+8,config);write32(instance+0x7c,duration);write32(config+0x33c,override);write32(owner+0xa8,start);write32(owner+0x1dc,flags)
 frame=stack+0x8000;write32(frame+8,now);u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_ESP,stack+0x7000);u.reg_write(UC_X86_REG_ESI,instance);u.reg_write(UC_X86_REG_EBX,0xffffffff);u.emu_start(0x934469,0x9344d1,count=1000);assert u.reg_read(UC_X86_REG_EIP)==0x9344d1
 ends.append({'instance_duration_bits':hex(duration),'override_33c_bits':hex(override),'time_bits':hex(now),'owner_start_bits':hex(start),'owner_flags':flags,'elapsed_bits':hex(read32(frame-12)),'past_end':bool(u.reg_read(UC_X86_REG_EBX)&255),'local_end_flag':bool(u.mem_read(frame-8,1)[0])})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'initial_fragment':['0x9331d0','0x9331fa'],'end_fragment':['0x934469','0x9344d1'],'initial_cases':initial,'end_cases':ends,'original_instruction_addresses':len(visited),'adapters':['Legal config/instance/owner memory and registers supplied. Original duration copy/conditional owner-scale multiplication and elapsed subtraction/flag-dependent comparison execute without math adapter.'],'limits':['Config2F4 statically resolves to e-life-scale, but raw boolean getter/startup producer still unqualified. Owner80 scale producer and flag10/config33C meanings remain to qualify.','Past-end flag is not full emitter completion: later emission/period/linger/live-particle branches are outside fragment. No per-particle age or ordinary rendering qualification.']}
(r/'data/4.20/complex_instance_life_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'initial_cases':len(initial),'end_cases':len(ends),'passed':True}))
