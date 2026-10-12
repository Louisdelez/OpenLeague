"""Original9344D1 emission gates/period reset; count/birth callbacks supplied."""
from pathlib import Path
import json,struct,itertools,datetime,shutil
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_probability_curve.py').read_text().split('\ninputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook);','');exec(compile(setup,'native setup','exec'));previous_hook=hook
instance=heap+0x1000;config=heap+0x2000;events=[];count_result=0
def hook(uc,a,size,user):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0x9345f0:events.append({'kind':'count','time_bits':hex(read32(sp+4))});finish(4,count_result);return
 if a==0x934860:events.append({'kind':'birth','time_bits':hex(read32(sp+4)),'count':read32(sp+8)});finish(8,0);return
 previous_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
def bits(v):return struct.unpack('<I',struct.pack('<f',v))[0]
def run(period,active,offset,duration,elapsed,flag334,flag74,flag11c,past_end,count,time=None):
 global events,count_result
 events=[];count_result=count;time=elapsed if time is None else time;u.mem_write(instance,b'\0'*0x300);u.mem_write(config,b'\0'*0x584);write32(instance+8,config);write32(instance+0x7c,bits(duration));write32(config+0x2ec,bits(offset));write32(config+0x308,bits(period));write32(config+0x30c,bits(active));write32(config+0x334,flag334);u.mem_write(instance+0x74,bytes([flag74]));u.mem_write(instance+0x11c,bytes([flag11c]));write32(instance+0x118,17);write32(instance+0x108,bits(8.))
 frame=stack+0x8000;write32(frame+8,bits(time));write32(frame-12,bits(elapsed));u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_ESP,stack+0x7000);u.reg_write(UC_X86_REG_ESI,instance);u.reg_write(UC_X86_REG_EBX,int(past_end));u.reg_write(UC_X86_REG_XMM1,bits(elapsed));u.reg_write(UC_X86_REG_FPCW,0x37f);u.emu_start(0x9344d1,0x934575,count=100000);assert u.reg_read(UC_X86_REG_EIP)==0x934575
 return {'time':time,'period':period,'active':active,'offset':offset,'duration':duration,'elapsed':elapsed,'flag334':flag334,'flag74':flag74,'flag11c':flag11c,'past_end':past_end,'count_result':count,'events':events.copy(),'state_118':read32(instance+0x118),'state_108_bits':hex(read32(instance+0x108))}
cases=[]
for period,active,elapsed in itertools.product([.1,1.,2.,20.,float_at(0x1139294)],[-1.,0.,.1,1.,3.],[-2.,0.,.05,.1,.5,1.,2.,3.,20.]):
 for count in [0,3]:cases.append(run(period,active,-1.,float_at(0x1139294),elapsed,0,0,0,False,count))
for flags in itertools.product([0,1],[0,1],[0,1],[False,True]):
 for offset,duration,elapsed in itertools.product([-1.,0.,.5],[ -1.,0.,1.],[-.5,0.,.5,1.,2.]):cases.append(run(2.,1.,offset,duration,elapsed,*flags,3))
for time in [-1.,0.,10.]:cases.append(run(2.,1.,0.,1.,.5,0,0,0,False,3,time))
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'fragment':['0x9344d1','0x934575'],'cases':cases,'original_instruction_addresses':len(visited),'adapters':['Legal config/instance/caller elapsed and flags supplied; emission-count function returns explicit fixture count and birth callback records actual native arguments. Original gating, CRT CIfmod dispatch/FPREM phase arithmetic, active comparison and counter reset execute.'],'limits':['Finite supplied elapsed/life/active/offset and positive finite period scope. Per-particle age, count function and whole birth execution excluded.','Raw flag334/74/11C source meanings, owner sources and ordinary lifecycle/render integration not qualified.']}
(r/'data/4.20/complex_emission_gate_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'birth_calls':sum(any(e['kind']=='birth' for e in c['events']) for c in cases),'resets':sum(c['state_118']==0 for c in cases),'passed':True}))
