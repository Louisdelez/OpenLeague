"""943924..9439DF baseline and auxiliary owner displacement/time writes."""
from pathlib import Path
import json,datetime,ctypes,shutil,itertools
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_troy_frame_timing.py').read_text(encoding='utf-8').split('\ncases=[]')[0]
setup=setup.replace("'0x93f45b<=a<0x93f5c0'", "'0x943924<=a<0x9439df'").replace('u.hook_add(unicorn.UC_HOOK_CODE,timing_hook)','timing_hook_id=u.hook_add(unicorn.UC_HOOK_CODE,timing_hook)')
exec(compile(setup,'simple auxiliary setup','exec'));u.hook_del(timing_hook_id)
instance=heap+0x9000;helper=heap+0xa000;manager=heap+0xb000
native_reset=read32(0x12258c4);assert read32(0x11393b0)==0xff7fffff
def auxiliary_hook(uc,a,size,user):
 if a==0x9439df:u.emu_stop();return
 if a==0x5ce0f0:
  events.append({'event':'manager_init','delta':[hex(read32(helper+0x10+i*4)) for i in range(3)]});write32(0x2d78560,manager);finish();return
 reset_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,auxiliary_hook)
patterns=[0xff7fffff,0,0x80000000,1,0x3f000000,0x3f800000,0x7f800000,0xff800000,0x7fa01234,0xffa05678,0x7fc01234,0x40000000]
cases=[]
profiles=itertools.product(range(12),[False,True],[False,True],[0,1,255],[0,1,255])
for index,(phase,present,manager_present,manager_flag,helper_flag) in enumerate(profiles):
 previous=patterns[phase];now=patterns[(phase+3)%12];old_accumulator=patterns[(phase+6)%12];reset_value=patterns[(phase+7)%12];position=[patterns[(phase+i)%12] for i in range(3)];old_position=[patterns[(phase+i+5)%12] for i in range(3)];captures=[]
 for corrected in [False,True]:
  enabled=corrected;events=[];u.mem_write(instance,b'\0'*0x160);u.mem_write(actor,b'\0'*0x200);u.mem_write(helper,b'\0'*0x40);u.mem_write(manager,b'\0'*0x10);write32(instance+0xdc,previous);write32(instance+0xe4,helper if present else 0);write32(helper+0x24,old_accumulator);u.mem_write(helper+0x2c,bytes([helper_flag]));u.mem_write(manager+5,bytes([manager_flag]));write32(0x2d78560,manager if manager_present else 0);write32(0x12258c4,reset_value)
  for i in range(3):write32(actor+0x90+i*4,position[i]);write32(actor+0x84+i*4,old_position[i]);write32(helper+0x10+i*4,0xcccccccc)
  sp=stack+0x8000;u.mem_write(sp-0x100,b'\0'*0x200);write32(frame+8,now);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_EBX,instance);u.reg_write(UC_X86_REG_ESI,actor);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
  u.emu_start(0x943924,0x9439df,count=10000);assert u.reg_read(UC_X86_REG_EIP)==0x9439df
  captures.append({'baseline':hex(read32(sp+0x10)),'delta':[hex(read32(helper+0x10+i*4)) for i in range(3)],'helper_flag':u.mem_read(helper+0x2c,1)[0],'accumulator':hex(read32(helper+0x24)),'events':events.copy()})
 cases.append({'previous_time':hex(previous),'time':hex(now),'old_accumulator':hex(old_accumulator),'reset_value':hex(reset_value),'position':[hex(v) for v in position],'previous_position':[hex(v) for v in old_position],'present':present,'manager_present':manager_present,'manager_flag':manager_flag,'helper_flag':helper_flag,'emulator':captures[0],'cpu':captures[1]})
for address in blocks:kernel.VirtualFree(address,0,0x8000)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'range':'943924..9439DF','native_initial_reset_bits':hex(native_reset),'cases':cases,'actual_cpu_sse_operations':cpu_calls,'emulator_cpu_case_disagreements':sum(c['emulator']!=c['cpu'] for c in cases),'adapters':['Whole baseline/helper writes execute; manager initialization5CE0F0 endpoint supplies manager pointer/flag and records already-written delta. Existing manager supplied directly.','Writable global12258C4 supplied as explicit reset word, not treated as immutable constant. Original initial image value recorded separately.'],'limits':['Manager initialization producer body and semantic production of helper/global flags remain unqualified. Remaining Simple body and ordinary integration incomplete.','Default FP controls and single-threaded supplied state.']}
(r/'data/4.20/simple_auxiliary_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'sse':cpu_calls,'disagreements':proof['emulator_cpu_case_disagreements']}))
